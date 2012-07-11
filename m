From: akpm@linux-foundation.org
Subject: + fat-exportfs-fix-dentry-reconnection.patch added to -mm tree
Date: Wed, 11 Jul 2012 15:08:57 -0700
Message-ID: <20120711220858.468CA1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37038 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030280Ab2GKWI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 18:08:59 -0400
Received: by yhl10 with SMTP id 10so175927yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 15:08:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@digidescorp.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat (exportfs): fix dentry reconnection
has been added to the -mm tree.  Its filename is
     fat-exportfs-fix-dentry-reconnection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Steven J. Magnani" <steve@digidescorp.com>
Subject: fat (exportfs): fix dentry reconnection

Maintain an index of directory inodes by starting cluster, so that
fat_get_parent() can return the proper cached inode rather than inventing
one that cannot be traced back to the filesystem root.

Add a new msdos/vfat binary mount option "nfs" so that FAT filesystems
that are _not_ exported via NFS are not saddled with maintenance of an
index they will never use.

Finally, simplify NFS file handle generation and lookups.  An
ext2-congruent implementation is adequate for FAT needs.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c         |   20 ++---
 fs/fat/fat.h         |   27 +++----
 fs/fat/inode.c       |   71 +++++++++++++++++--
 fs/fat/namei_msdos.c |    5 -
 fs/fat/namei_vfat.c  |    5 -
 fs/fat/nfs.c         |  152 +++++++++++++----------------------------
 6 files changed, 142 insertions(+), 138 deletions(-)

diff -puN fs/fat/dir.c~fat-exportfs-fix-dentry-reconnection fs/fat/dir.c
--- a/fs/fat/dir.c~fat-exportfs-fix-dentry-reconnection
+++ a/fs/fat/dir.c
@@ -872,21 +872,23 @@ static int fat_get_short_entry(struct in
 }
 
 /*
- * The ".." entry can not provide the "struct fat_slot_info" informations
- * for inode. So, this function provide the some informations only.
+ * The ".." entry can not provide the "struct fat_slot_info" information
+ * for inode, nor a usable i_pos. So, this function provides some information
+ * only.
+ *
+ * Since this function walks through the on-disk inodes within a directory,
+ * callers are responsible for taking any locks necessary to prevent the
+ * directory from changing.
  */
 int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
-			 struct msdos_dir_entry **de, loff_t *i_pos)
+			 struct msdos_dir_entry **de)
 {
-	loff_t offset;
+	loff_t offset = 0;
 
-	offset = 0;
-	*bh = NULL;
+	*de = NULL;
 	while (fat_get_short_entry(dir, &offset, bh, de) >= 0) {
-		if (!strncmp((*de)->name, MSDOS_DOTDOT, MSDOS_NAME)) {
-			*i_pos = fat_make_i_pos(dir->i_sb, *bh, *de);
+		if (!strncmp((*de)->name, MSDOS_DOTDOT, MSDOS_NAME))
 			return 0;
-		}
 	}
 	return -ENOENT;
 }
diff -puN fs/fat/fat.h~fat-exportfs-fix-dentry-reconnection fs/fat/fat.h
--- a/fs/fat/fat.h~fat-exportfs-fix-dentry-reconnection
+++ a/fs/fat/fat.h
@@ -5,6 +5,7 @@
 #include <linux/string.h>
 #include <linux/nls.h>
 #include <linux/fs.h>
+#include <linux/hash.h>
 #include <linux/mutex.h>
 #include <linux/ratelimit.h>
 #include <linux/msdos_fs.h>
@@ -46,7 +47,8 @@ struct fat_mount_options {
 		 usefree:1,	  /* Use free_clusters for FAT32 */
 		 tz_utc:1,	  /* Filesystem timestamps are in UTC */
 		 rodir:1,	  /* allow ATTR_RO for directory */
-		 discard:1;	  /* Issue discard requests on deletions */
+		 discard:1,	  /* Issue discard requests on deletions */
+		 nfs:1;		  /* Do extra work needed for NFS export */
 };
 
 #define FAT_HASH_BITS	8
@@ -88,6 +90,9 @@ struct msdos_sb_info {
 
 	spinlock_t inode_hash_lock;
 	struct hlist_head inode_hashtable[FAT_HASH_SIZE];
+
+	spinlock_t dir_hash_lock;
+	struct hlist_head dir_hashtable[FAT_HASH_SIZE];
 };
 
 #define FAT_CACHE_VALID	0	/* special case for valid cache */
@@ -110,6 +115,7 @@ struct msdos_inode_info {
 	int i_attrs;		/* unused attribute bits */
 	loff_t i_pos;		/* on-disk position of directory entry or 0 */
 	struct hlist_node i_fat_hash;	/* hash by i_location */
+	struct hlist_node i_dir_hash;	/* hash by i_logstart */
 	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
 	struct inode vfs_inode;
 };
@@ -262,7 +268,7 @@ extern int fat_subdirs(struct inode *dir
 extern int fat_scan(struct inode *dir, const unsigned char *name,
 		    struct fat_slot_info *sinfo);
 extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
-				struct msdos_dir_entry **de, loff_t *i_pos);
+				struct msdos_dir_entry **de);
 extern int fat_alloc_new_dir(struct inode *dir, struct timespec *ts);
 extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			   struct fat_slot_info *sinfo);
@@ -341,18 +347,9 @@ extern int fat_fill_super(struct super_b
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
-static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
-				    struct inode *inode)
+static inline unsigned long fat_dir_hash(int logstart)
 {
-	loff_t i_pos;
-#if BITS_PER_LONG == 32
-	spin_lock(&sbi->inode_hash_lock);
-#endif
-	i_pos = MSDOS_I(inode)->i_pos;
-#if BITS_PER_LONG == 32
-	spin_unlock(&sbi->inode_hash_lock);
-#endif
-	return i_pos;
+	return hash_32(logstart, FAT_HASH_BITS);
 }
 
 /* fat/misc.c */
@@ -382,10 +379,10 @@ void fat_cache_destroy(void);
 
 /* fat/nfs.c */
 struct fid;
-extern int fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp,
-			 struct inode *parent);
 extern struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
 				       int fh_len, int fh_type);
+extern struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type);
 extern struct dentry *fat_get_parent(struct dentry *child_dir);
 
 /* helper for printk */
diff -puN fs/fat/inode.c~fat-exportfs-fix-dentry-reconnection fs/fat/inode.c
--- a/fs/fat/inode.c~fat-exportfs-fix-dentry-reconnection
+++ a/fs/fat/inode.c
@@ -281,15 +281,42 @@ static inline unsigned long fat_hash(lof
 	return hash_32(i_pos, FAT_HASH_BITS);
 }
 
+static void dir_hash_init(struct super_block *sb)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int i;
+
+	spin_lock_init(&sbi->dir_hash_lock);
+	for (i = 0; i < FAT_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&sbi->dir_hashtable[i]);
+}
+
 void fat_attach(struct inode *inode, loff_t i_pos)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
-	struct hlist_head *head = sbi->inode_hashtable + fat_hash(i_pos);
 
-	spin_lock(&sbi->inode_hash_lock);
-	MSDOS_I(inode)->i_pos = i_pos;
-	hlist_add_head(&MSDOS_I(inode)->i_fat_hash, head);
-	spin_unlock(&sbi->inode_hash_lock);
+	if (inode->i_ino != MSDOS_ROOT_INO) {
+		struct hlist_head *head =   sbi->inode_hashtable
+					  + fat_hash(i_pos);
+
+		spin_lock(&sbi->inode_hash_lock);
+		MSDOS_I(inode)->i_pos = i_pos;
+		hlist_add_head(&MSDOS_I(inode)->i_fat_hash, head);
+		spin_unlock(&sbi->inode_hash_lock);
+	}
+
+	/* If NFS support is enabled, cache the mapping of start cluster
+	 * to directory inode. This is used during reconnection of
+	 * dentries to the filesystem root.
+	 */
+	if (S_ISDIR(inode->i_mode) && sbi->options.nfs) {
+		struct hlist_head *d_head = sbi->dir_hashtable;
+		d_head += fat_dir_hash(MSDOS_I(inode)->i_logstart);
+
+		spin_lock(&sbi->dir_hash_lock);
+		hlist_add_head(&MSDOS_I(inode)->i_dir_hash, d_head);
+		spin_unlock(&sbi->dir_hash_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(fat_attach);
 
@@ -300,6 +327,12 @@ void fat_detach(struct inode *inode)
 	MSDOS_I(inode)->i_pos = 0;
 	hlist_del_init(&MSDOS_I(inode)->i_fat_hash);
 	spin_unlock(&sbi->inode_hash_lock);
+
+	if (S_ISDIR(inode->i_mode) && sbi->options.nfs) {
+		spin_lock(&sbi->dir_hash_lock);
+		hlist_del_init(&MSDOS_I(inode)->i_dir_hash);
+		spin_unlock(&sbi->dir_hash_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(fat_detach);
 
@@ -504,6 +537,7 @@ static void init_once(void *foo)
 	ei->cache_valid_id = FAT_CACHE_VALID + 1;
 	INIT_LIST_HEAD(&ei->cache_lru);
 	INIT_HLIST_NODE(&ei->i_fat_hash);
+	INIT_HLIST_NODE(&ei->i_dir_hash);
 	inode_init_once(&ei->vfs_inode);
 }
 
@@ -562,6 +596,20 @@ static int fat_statfs(struct dentry *den
 	return 0;
 }
 
+static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
+				    struct inode *inode)
+{
+	loff_t i_pos;
+#if BITS_PER_LONG == 32
+	spin_lock(&sbi->inode_hash_lock);
+#endif
+	i_pos = MSDOS_I(inode)->i_pos;
+#if BITS_PER_LONG == 32
+	spin_unlock(&sbi->inode_hash_lock);
+#endif
+	return i_pos;
+}
+
 static int __fat_write_inode(struct inode *inode, int wait)
 {
 	struct super_block *sb = inode->i_sb;
@@ -655,8 +703,8 @@ static const struct super_operations fat
 };
 
 static const struct export_operations fat_export_ops = {
-	.encode_fh	= fat_encode_fh,
 	.fh_to_dentry	= fat_fh_to_dentry,
+	.fh_to_parent	= fat_fh_to_parent,
 	.get_parent	= fat_get_parent,
 };
 
@@ -704,6 +752,8 @@ static int fat_show_options(struct seq_f
 		seq_puts(m, ",usefree");
 	if (opts->quiet)
 		seq_puts(m, ",quiet");
+	if (opts->nfs)
+		seq_puts(m, ",nfs");
 	if (opts->showexec)
 		seq_puts(m, ",showexec");
 	if (opts->sys_immutable)
@@ -748,7 +798,7 @@ enum {
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
-	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_err,
+	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -777,6 +827,7 @@ static const match_table_t fat_tokens = 
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_discard, "discard"},
+	{Opt_nfs, "nfs"},
 	{Opt_obsolete, "conv=binary"},
 	{Opt_obsolete, "conv=text"},
 	{Opt_obsolete, "conv=auto"},
@@ -857,6 +908,7 @@ static int parse_options(struct super_bl
 	opts->numtail = 1;
 	opts->usefree = opts->nocase = 0;
 	opts->tz_utc = 0;
+	opts->nfs = 0;
 	opts->errors = FAT_ERRORS_RO;
 	*debug = 0;
 
@@ -1017,6 +1069,9 @@ static int parse_options(struct super_bl
 		case Opt_discard:
 			opts->discard = 1;
 			break;
+		case Opt_nfs:
+			opts->nfs = 1;
+			break;
 
 		/* obsolete mount options */
 		case Opt_obsolete:
@@ -1307,6 +1362,7 @@ int fat_fill_super(struct super_block *s
 
 	/* set up enough so that it can read an inode */
 	fat_hash_init(sb);
+	dir_hash_init(sb);
 	fat_ent_access_init(sb);
 
 	/*
@@ -1361,6 +1417,7 @@ int fat_fill_super(struct super_block *s
 	}
 	error = -ENOMEM;
 	insert_inode_hash(root_inode);
+	fat_attach(root_inode, 0);
 	sb->s_root = d_make_root(root_inode);
 	if (!sb->s_root) {
 		fat_msg(sb, KERN_ERR, "get root inode failed");
diff -puN fs/fat/namei_msdos.c~fat-exportfs-fix-dentry-reconnection fs/fat/namei_msdos.c
--- a/fs/fat/namei_msdos.c~fat-exportfs-fix-dentry-reconnection
+++ a/fs/fat/namei_msdos.c
@@ -440,7 +440,7 @@ static int do_msdos_rename(struct inode 
 	struct inode *old_inode, *new_inode;
 	struct fat_slot_info old_sinfo, sinfo;
 	struct timespec ts;
-	loff_t dotdot_i_pos, new_i_pos;
+	loff_t new_i_pos;
 	int err, old_attrs, is_dir, update_dotdot, corrupt = 0;
 
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
@@ -456,8 +456,7 @@ static int do_msdos_rename(struct inode 
 	is_dir = S_ISDIR(old_inode->i_mode);
 	update_dotdot = (is_dir && old_dir != new_dir);
 	if (update_dotdot) {
-		if (fat_get_dotdot_entry(old_inode, &dotdot_bh, &dotdot_de,
-					 &dotdot_i_pos) < 0) {
+		if (fat_get_dotdot_entry(old_inode, &dotdot_bh, &dotdot_de)) {
 			err = -EIO;
 			goto out;
 		}
diff -puN fs/fat/namei_vfat.c~fat-exportfs-fix-dentry-reconnection fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-exportfs-fix-dentry-reconnection
+++ a/fs/fat/namei_vfat.c
@@ -914,7 +914,7 @@ static int vfat_rename(struct inode *old
 	struct inode *old_inode, *new_inode;
 	struct fat_slot_info old_sinfo, sinfo;
 	struct timespec ts;
-	loff_t dotdot_i_pos, new_i_pos;
+	loff_t new_i_pos;
 	int err, is_dir, update_dotdot, corrupt = 0;
 	struct super_block *sb = old_dir->i_sb;
 
@@ -929,8 +929,7 @@ static int vfat_rename(struct inode *old
 	is_dir = S_ISDIR(old_inode->i_mode);
 	update_dotdot = (is_dir && old_dir != new_dir);
 	if (update_dotdot) {
-		if (fat_get_dotdot_entry(old_inode, &dotdot_bh, &dotdot_de,
-					 &dotdot_i_pos) < 0) {
+		if (fat_get_dotdot_entry(old_inode, &dotdot_bh, &dotdot_de)) {
 			err = -EIO;
 			goto out;
 		}
diff -puN fs/fat/nfs.c~fat-exportfs-fix-dentry-reconnection fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-exportfs-fix-dentry-reconnection
+++ a/fs/fat/nfs.c
@@ -14,47 +14,46 @@
 #include <linux/exportfs.h>
 #include "fat.h"
 
-/*
- * a FAT file handle with fhtype 3 is
- *  0/  i_ino - for fast, reliable lookup if still in the cache
- *  1/  i_generation - to see if i_ino is still valid
- *          bit 0 == 0 iff directory
- *  2/  i_pos(8-39) - if ino has changed, but still in cache
- *  3/  i_pos(4-7)|i_logstart - to semi-verify inode found at i_pos
- *  4/  i_pos(0-3)|parent->i_logstart - maybe used to hunt for the file on disc
- *
- * Hack for NFSv2: Maximum FAT entry number is 28bits and maximum
- * i_pos is 40bits (blocknr(32) + dir offset(8)), so two 4bits
- * of i_logstart is used to store the directory entry offset.
+/**
+ * Look up a directory inode given its starting cluster.
  */
-
-int
-fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
+static struct inode *fat_dget(struct super_block *sb, int i_logstart)
 {
-	int len = *lenp;
-	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
-	loff_t i_pos;
-
-	if (len < 5) {
-		*lenp = 5;
-		return 255; /* no room */
-	}
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct hlist_head *head;
+	struct hlist_node *_p;
+	struct msdos_inode_info *i;
+	struct inode *inode = NULL;
 
-	i_pos = fat_i_pos_read(sbi, inode);
-	*lenp = 5;
-	fh[0] = inode->i_ino;
-	fh[1] = inode->i_generation;
-	fh[2] = i_pos >> 8;
-	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
-	fh[4] = (i_pos & 0x0f) << 28;
-	if (parent)
-		fh[4] |= MSDOS_I(parent)->i_logstart;
-	return 3;
+	head = sbi->dir_hashtable + fat_dir_hash(i_logstart);
+	spin_lock(&sbi->dir_hash_lock);
+	hlist_for_each_entry(i, _p, head, i_dir_hash) {
+		BUG_ON(i->vfs_inode.i_sb != sb);
+		if (i->i_logstart != i_logstart)
+			continue;
+		inode = igrab(&i->vfs_inode);
+		if (inode)
+			break;
+	}
+	spin_unlock(&sbi->dir_hash_lock);
+	return inode;
 }
 
-static int fat_is_valid_fh(int fh_len, int fh_type)
+static struct inode *fat_nfs_get_inode(struct super_block *sb,
+				       u64 ino, u32 generation)
 {
-	return ((fh_len >= 5) && (fh_type == 3));
+	struct inode *inode;
+
+	if ((ino < MSDOS_ROOT_INO) || (ino == MSDOS_FSINFO_INO))
+		return NULL;
+
+	inode = ilookup(sb, ino);
+	if (inode && generation && (inode->i_generation != generation)) {
+		iput(inode);
+		inode = NULL;
+	}
+
+	return inode;
 }
 
 /**
@@ -64,57 +63,19 @@ static int fat_is_valid_fh(int fh_len, i
 struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
 				int fh_len, int fh_type)
 {
-	struct inode *inode = NULL;
-	u32 *fh = fid->raw;
-	loff_t i_pos;
-	unsigned long i_ino;
-	__u32 i_generation;
-	int i_logstart;
-
-	if (!fat_is_valid_fh(fh_len, fh_type))
-		return NULL;
-
-	i_ino = fh[0];
-	i_generation = fh[1];
-	i_logstart = fh[3] & 0x0fffffff;
-
-	/* Try i_ino lookup first - fastest and most reliable */
-	inode = ilookup(sb, i_ino);
-	if (inode && (inode->i_generation != i_generation)) {
-		iput(inode);
-		inode = NULL;
-	}
-	if (!inode) {
-		i_pos = (loff_t)fh[2] << 8;
-		i_pos |= ((fh[3] >> 24) & 0xf0) | (fh[4] >> 28);
-
-		/* try 2 - see if i_pos is in F-d-c
-		 * require i_logstart to be the same
-		 * Will fail if you truncate and then re-write
-		 */
-
-		inode = fat_iget(sb, i_pos);
-		if (inode && MSDOS_I(inode)->i_logstart != i_logstart) {
-			iput(inode);
-			inode = NULL;
-		}
-	}
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    fat_nfs_get_inode);
+}
 
-	/*
-	 * For now, do nothing if the inode is not found.
-	 *
-	 * What we could do is:
-	 *
-	 *	- follow the file starting at fh[4], and record the ".." entry,
-	 *	  and the name of the fh[2] entry.
-	 *	- then follow the ".." file finding the next step up.
-	 *
-	 * This way we build a path to the root of the tree. If this works, we
-	 * lookup the path and so get this inode into the cache.  Finally try
-	 * the fat_iget lookup again.  If that fails, then we are totally out
-	 * of luck.  But all that is for another day
-	 */
-	return d_obtain_alias(inode);
+/*
+ * Find the parent for a file specified by NFS handle.
+ * This requires that the handle contain the i_ino of the parent.
+ */
+struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
+				int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    fat_nfs_get_inode);
 }
 
 /*
@@ -128,24 +89,13 @@ struct dentry *fat_get_parent(struct den
 	struct super_block *sb = child_dir->d_sb;
 	struct buffer_head *bh = NULL;
 	struct msdos_dir_entry *de;
-	loff_t i_pos;
-	struct dentry *parent;
-	struct inode *inode;
-	int err;
-
-	lock_super(sb);
+	struct inode *parent_inode = NULL;
 
-	err = fat_get_dotdot_entry(child_dir->d_inode, &bh, &de, &i_pos);
-	if (err) {
-		parent = ERR_PTR(err);
-		goto out;
+	if (!fat_get_dotdot_entry(child_dir->d_inode, &bh, &de)) {
+		int parent_logstart = fat_get_start(MSDOS_SB(sb), de);
+		parent_inode = fat_dget(sb, parent_logstart);
 	}
-	inode = fat_build_inode(sb, de, i_pos);
