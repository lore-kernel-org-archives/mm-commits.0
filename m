From: akpm@linux-foundation.org
Subject: + mount-options-fix-tmpfs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:56 -0800
Message-ID: <200801292322.m0TNMuLF009743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36116 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529AbYA2X0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, mszeredi@suse.cz


The patch titled
     mount options: fix tmpfs
has been added to the -mm tree.  Its filename is
     mount-options-fix-tmpfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix tmpfs

Add .show_options super operation to tmpfs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    5 
 mm/shmem.c               |  196 ++++++++++++++++++++++++-------------
 2 files changed, 136 insertions(+), 65 deletions(-)

diff -puN include/linux/shmem_fs.h~mount-options-fix-tmpfs include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~mount-options-fix-tmpfs
+++ a/include/linux/shmem_fs.h
@@ -30,9 +30,12 @@ struct shmem_sb_info {
 	unsigned long free_blocks;  /* How many are left for allocation */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
+	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
+	uid_t uid;		    /* Mount uid for root directory */
+	gid_t gid;		    /* Mount gid for root directory */
+	mode_t mode;		    /* Mount mode for root directory */
 	int policy;		    /* Default NUMA memory alloc policy */
 	nodemask_t policy_nodes;    /* nodemask for preferred and bind */
-	spinlock_t    stat_lock;
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
diff -puN mm/shmem.c~mount-options-fix-tmpfs mm/shmem.c
--- a/mm/shmem.c~mount-options-fix-tmpfs
+++ a/mm/shmem.c
@@ -49,6 +49,7 @@
 #include <linux/ctype.h>
 #include <linux/migrate.h>
 #include <linux/highmem.h>
+#include <linux/seq_file.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
@@ -84,6 +85,16 @@ enum sgp_type {
 	SGP_WRITE,	/* may exceed i_size, may allocate page */
 };
 
+static unsigned long shmem_default_max_blocks(void)
+{
+	return totalram_pages / 2;
+}
+
+static unsigned long shmem_default_max_inodes(void)
+{
+	return min(totalram_pages - totalhigh_pages, totalram_pages / 2);
+}
+
 static int shmem_getpage(struct inode *inode, unsigned long idx,
 			 struct page **pagep, enum sgp_type sgp, int *type);
 
@@ -1068,7 +1079,8 @@ redirty:
 }
 
 #ifdef CONFIG_NUMA
-static inline int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
+#ifdef CONFIG_TMPFS
+static int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
 {
 	char *nodelist = strchr(value, ':');
 	int err = 1;
@@ -1117,6 +1129,42 @@ out:
 	return err;
 }
 
+static void shmem_show_mpol(struct seq_file *seq, int policy,
+			    const nodemask_t policy_nodes)
+{
+	char *policy_string;
+
+	switch (policy) {
+	case MPOL_PREFERRED:
+		policy_string = "prefer";
+		break;
+	case MPOL_BIND:
+		policy_string = "bind";
+		break;
+	case MPOL_INTERLEAVE:
+		policy_string = "interleave";
+		break;
+	default:
+		/* MPOL_DEFAULT */
+		return;
+	}
+
+	seq_printf(seq, ",mpol=%s", policy_string);
+
+	if (policy != MPOL_INTERLEAVE ||
+	    !nodes_equal(policy_nodes, node_states[N_HIGH_MEMORY])) {
+		char buffer[64];
+		int len;
+
+		len = nodelist_scnprintf(buffer, sizeof(buffer), policy_nodes);
+		if (len < sizeof(buffer))
+			seq_printf(seq, ":%s", buffer);
+		else
+			seq_printf(seq, ":?");
+	}
+}
+#endif /* CONFIG_TMPFS */
+
 static struct page *shmem_swapin(swp_entry_t entry, gfp_t gfp,
 			struct shmem_inode_info *info, unsigned long idx)
 {
@@ -1148,13 +1196,20 @@ static struct page *shmem_alloc_page(gfp
 	mpol_free(pvma.vm_policy);
 	return page;
 }
-#else
+#else /* !CONFIG_NUMA */
+#ifdef CONFIG_TMPFS
 static inline int shmem_parse_mpol(char *value, int *policy,
 						nodemask_t *policy_nodes)
 {
 	return 1;
 }
 
+static inline void shmem_show_mpol(struct seq_file *seq, int policy,
+			    const nodemask_t policy_nodes)
+{
+}
+#endif /* CONFIG_TMPFS */
+
 static inline struct page *shmem_swapin(swp_entry_t entry, gfp_t gfp,
 			struct shmem_inode_info *info, unsigned long idx)
 {
@@ -1166,7 +1221,7 @@ static inline struct page *shmem_alloc_p
 {
 	return alloc_page(gfp);
 }
-#endif
+#endif /* CONFIG_NUMA */
 
 /*
  * shmem_getpage - either get the page from swap or allocate a new one
@@ -2077,9 +2132,8 @@ static const struct export_operations sh
 	.fh_to_dentry	= shmem_fh_to_dentry,
 };
 
-static int shmem_parse_options(char *options, int *mode, uid_t *uid,
-	gid_t *gid, unsigned long *blocks, unsigned long *inodes,
-	int *policy, nodemask_t *policy_nodes)
+static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
+			       bool remount)
 {
 	char *this_char, *value, *rest;
 
@@ -2122,35 +2176,37 @@ static int shmem_parse_options(char *opt
 			}
 			if (*rest)
 				goto bad_val;
-			*blocks = DIV_ROUND_UP(size, PAGE_CACHE_SIZE);
+			sbinfo->max_blocks =
+				DIV_ROUND_UP(size, PAGE_CACHE_SIZE);
 		} else if (!strcmp(this_char,"nr_blocks")) {
-			*blocks = memparse(value,&rest);
+			sbinfo->max_blocks = memparse(value, &rest);
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"nr_inodes")) {
-			*inodes = memparse(value,&rest);
+			sbinfo->max_inodes = memparse(value, &rest);
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"mode")) {
-			if (!mode)
+			if (remount)
 				continue;
-			*mode = simple_strtoul(value,&rest,8);
+			sbinfo->mode = simple_strtoul(value, &rest, 8) & 07777;
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"uid")) {
-			if (!uid)
+			if (remount)
 				continue;
-			*uid = simple_strtoul(value,&rest,0);
+			sbinfo->uid = simple_strtoul(value, &rest, 0);
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"gid")) {
-			if (!gid)
+			if (remount)
 				continue;
-			*gid = simple_strtoul(value,&rest,0);
+			sbinfo->gid = simple_strtoul(value, &rest, 0);
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
-			if (shmem_parse_mpol(value,policy,policy_nodes))
+			if (shmem_parse_mpol(value, &sbinfo->policy,
+					     &sbinfo->policy_nodes))
 				goto bad_val;
 		} else {
 			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
@@ -2170,24 +2226,20 @@ bad_val:
 static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
-	unsigned long max_blocks = sbinfo->max_blocks;
-	unsigned long max_inodes = sbinfo->max_inodes;
-	int policy = sbinfo->policy;
-	nodemask_t policy_nodes = sbinfo->policy_nodes;
+	struct shmem_sb_info config = *sbinfo;
 	unsigned long blocks;
 	unsigned long inodes;
 	int error = -EINVAL;
 
-	if (shmem_parse_options(data, NULL, NULL, NULL, &max_blocks,
-				&max_inodes, &policy, &policy_nodes))
+	if (shmem_parse_options(data, &config, true))
 		return error;
 
 	spin_lock(&sbinfo->stat_lock);
 	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
-	if (max_blocks < blocks)
+	if (config.max_blocks < blocks)
 		goto out;
-	if (max_inodes < inodes)
+	if (config.max_inodes < inodes)
 		goto out;
 	/*
 	 * Those tests also disallow limited->unlimited while any are in
@@ -2195,23 +2247,42 @@ static int shmem_remount_fs(struct super
 	 * but we must separately disallow unlimited->limited, because
 	 * in that case we have no record of how much is already in use.
 	 */
-	if (max_blocks && !sbinfo->max_blocks)
+	if (config.max_blocks && !sbinfo->max_blocks)
 		goto out;
-	if (max_inodes && !sbinfo->max_inodes)
+	if (config.max_inodes && !sbinfo->max_inodes)
 		goto out;
 
 	error = 0;
-	sbinfo->max_blocks  = max_blocks;
-	sbinfo->free_blocks = max_blocks - blocks;
-	sbinfo->max_inodes  = max_inodes;
-	sbinfo->free_inodes = max_inodes - inodes;
-	sbinfo->policy = policy;
-	sbinfo->policy_nodes = policy_nodes;
+	sbinfo->max_blocks  = config.max_blocks;
+	sbinfo->free_blocks = config.max_blocks - blocks;
+	sbinfo->max_inodes  = config.max_inodes;
+	sbinfo->free_inodes = config.max_inodes - inodes;
+	sbinfo->policy      = config.policy;
+	sbinfo->policy_nodes = config.policy_nodes;
 out:
 	spin_unlock(&sbinfo->stat_lock);
 	return error;
 }
-#endif
+
+static int shmem_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(vfs->mnt_sb);
+
+	if (sbinfo->max_blocks != shmem_default_max_blocks())
+		seq_printf(seq, ",size=%luk",
+			sbinfo->max_blocks << (PAGE_CACHE_SHIFT - 10));
+	if (sbinfo->max_inodes != shmem_default_max_inodes())
+		seq_printf(seq, ",nr_inodes=%lu", sbinfo->max_inodes);
+	if (sbinfo->mode != (S_IRWXUGO | S_ISVTX))
+		seq_printf(seq, ",mode=%03o", sbinfo->mode);
+	if (sbinfo->uid != 0)
+		seq_printf(seq, ",uid=%u", sbinfo->uid);
+	if (sbinfo->gid != 0)
+		seq_printf(seq, ",gid=%u", sbinfo->gid);
+	shmem_show_mpol(seq, sbinfo->policy, sbinfo->policy_nodes);
+	return 0;
+}
+#endif /* CONFIG_TMPFS */
 
 static void shmem_put_super(struct super_block *sb)
 {
@@ -2224,15 +2295,23 @@ static int shmem_fill_super(struct super
 {
 	struct inode *inode;
 	struct dentry *root;
-	int mode   = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->fsuid;
-	gid_t gid = current->fsgid;
-	int err = -ENOMEM;
 	struct shmem_sb_info *sbinfo;
-	unsigned long blocks = 0;
-	unsigned long inodes = 0;
-	int policy = MPOL_DEFAULT;
-	nodemask_t policy_nodes = node_states[N_HIGH_MEMORY];
+	int err = -ENOMEM;
+
+	/* Round up to L1_CACHE_BYTES to resist false sharing */
+	sbinfo = kmalloc(max((int)sizeof(struct shmem_sb_info),
+				L1_CACHE_BYTES), GFP_KERNEL);
+	if (!sbinfo)
+		return -ENOMEM;
+
+	sbinfo->max_blocks = 0;
+	sbinfo->max_inodes = 0;
+	sbinfo->mode = S_IRWXUGO | S_ISVTX;
+	sbinfo->uid = current->fsuid;
+	sbinfo->gid = current->fsgid;
+	sbinfo->policy = MPOL_DEFAULT;
+	sbinfo->policy_nodes = node_states[N_HIGH_MEMORY];
+	sb->s_fs_info = sbinfo;
 
 #ifdef CONFIG_TMPFS
 	/*
@@ -2241,34 +2320,22 @@ static int shmem_fill_super(struct super
 	 * but the internal instance is left unlimited.
 	 */
 	if (!(sb->s_flags & MS_NOUSER)) {
-		blocks = totalram_pages / 2;
-		inodes = totalram_pages - totalhigh_pages;
-		if (inodes > blocks)
-			inodes = blocks;
-		if (shmem_parse_options(data, &mode, &uid, &gid, &blocks,
-					&inodes, &policy, &policy_nodes))
-			return -EINVAL;
+		sbinfo->max_blocks = shmem_default_max_blocks();
+		sbinfo->max_inodes = shmem_default_max_inodes();
+		if (shmem_parse_options(data, sbinfo, false)) {
+			err = -EINVAL;
+			goto failed;
+		}
 	}
 	sb->s_export_op = &shmem_export_ops;
 #else
 	sb->s_flags |= MS_NOUSER;
 #endif
 
-	/* Round up to L1_CACHE_BYTES to resist false sharing */
-	sbinfo = kmalloc(max((int)sizeof(struct shmem_sb_info),
-				L1_CACHE_BYTES), GFP_KERNEL);
-	if (!sbinfo)
-		return -ENOMEM;
-
 	spin_lock_init(&sbinfo->stat_lock);
-	sbinfo->max_blocks = blocks;
-	sbinfo->free_blocks = blocks;
-	sbinfo->max_inodes = inodes;
-	sbinfo->free_inodes = inodes;
-	sbinfo->policy = policy;
-	sbinfo->policy_nodes = policy_nodes;
+	sbinfo->free_blocks = sbinfo->max_blocks;
+	sbinfo->free_inodes = sbinfo->max_inodes;
 
-	sb->s_fs_info = sbinfo;
 	sb->s_maxbytes = SHMEM_MAX_BYTES;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
@@ -2280,11 +2347,11 @@ static int shmem_fill_super(struct super
 	sb->s_flags |= MS_POSIXACL;
 #endif
 
-	inode = shmem_get_inode(sb, S_IFDIR | mode, 0);
+	inode = shmem_get_inode(sb, S_IFDIR | sbinfo->mode, 0);
 	if (!inode)
 		goto failed;
-	inode->i_uid = uid;
-	inode->i_gid = gid;
+	inode->i_uid = sbinfo->uid;
+	inode->i_gid = sbinfo->gid;
 	root = d_alloc_root(inode);
 	if (!root)
 		goto failed_iput;
@@ -2420,6 +2487,7 @@ static const struct super_operations shm
 #ifdef CONFIG_TMPFS
 	.statfs		= shmem_statfs,
 	.remount_fs	= shmem_remount_fs,
+	.show_options	= shmem_show_options,
 #endif
 	.delete_inode	= shmem_delete_inode,
 	.drop_inode	= generic_delete_inode,
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
tmpfs-move-swap_state-stats-update.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-move-swap-swizzling-into-shmem.patch
tmpfs-allow-filepage-alongside-swappage.patch
tmpfs-allocate-on-read-when-stacked.patch
tmpfs-make-shmem_unuse-more-preemptible.patch
tmpfs-open-a-window-in-shmem_unuse_inode.patch
tmpfs-radix_tree_preloading.patch
tmpfs-fix-shmem_swaplist-races.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
mm-dont-waste-swap-on-locked-pages.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
printk-trivial-optimizations-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
prio_tree-debugging-patch.patch
