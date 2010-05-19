From: akpm@linux-foundation.org
Subject: + fatfs-ratelimit-corruption-report.patch added to -mm tree
Date: Wed, 19 May 2010 13:57:29 -0700
Message-ID: <201005192057.o4JKvTpp005659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab0ESU5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 16:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fatfs: ratelimit corruption report
has been added to the -mm tree.  Its filename is
     fatfs-ratelimit-corruption-report.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fatfs: ratelimit corruption report
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |   13 +++++++------
 fs/fat/fat.h   |   12 ++++++++++--
 fs/fat/inode.c |    2 ++
 fs/fat/misc.c  |   22 ++++++++++++----------
 4 files changed, 31 insertions(+), 18 deletions(-)

diff -puN fs/fat/cache.c~fatfs-ratelimit-corruption-report fs/fat/cache.c
--- a/fs/fat/cache.c~fatfs-ratelimit-corruption-report
+++ a/fs/fat/cache.c
@@ -242,9 +242,10 @@ int fat_get_cluster(struct inode *inode,
 	while (*fclus < cluster) {
 		/* prevent the infinite loop of cluster chain */
 		if (*fclus > limit) {
-			fat_fs_error(sb, "%s: detected the cluster chain loop"
-				     " (i_pos %lld)", __func__,
-				     MSDOS_I(inode)->i_pos);
+			fat_fs_error_ratelimit(sb,
+					"%s: detected the cluster chain loop"
+					" (i_pos %lld)", __func__,
+					MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
 		}
@@ -253,9 +254,9 @@ int fat_get_cluster(struct inode *inode,
 		if (nr < 0)
 			goto out;
 		else if (nr == FAT_ENT_FREE) {
-			fat_fs_error(sb, "%s: invalid cluster chain"
-				     " (i_pos %lld)", __func__,
-				     MSDOS_I(inode)->i_pos);
+			fat_fs_error_ratelimit(sb, "%s: invalid cluster chain"
+					       " (i_pos %lld)", __func__,
+					       MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
 		} else if (nr == FAT_ENT_EOF) {
diff -puN fs/fat/fat.h~fatfs-ratelimit-corruption-report fs/fat/fat.h
--- a/fs/fat/fat.h~fatfs-ratelimit-corruption-report
+++ a/fs/fat/fat.h
@@ -6,6 +6,7 @@
 #include <linux/nls.h>
 #include <linux/fs.h>
 #include <linux/mutex.h>
+#include <linux/ratelimit.h>
 #include <linux/msdos_fs.h>
 
 /*
@@ -82,6 +83,8 @@ struct msdos_sb_info {
 	struct fatent_operations *fatent_ops;
 	struct inode *fat_inode;
 
+	struct ratelimit_state ratelimit;
+
 	spinlock_t inode_hash_lock;
 	struct hlist_head inode_hashtable[FAT_HASH_SIZE];
 };
@@ -322,8 +325,13 @@ extern int fat_fill_super(struct super_b
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 /* fat/misc.c */
-extern void fat_fs_error(struct super_block *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3))) __cold;
+extern void
+__fat_fs_error(struct super_block *s, int report, const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4))) __cold;
+#define fat_fs_error(s, fmt, args...)		\
+	__fat_fs_error(s, 1, fmt , ## args)
+#define fat_fs_error_ratelimit(s, fmt, args...) \
+	__fat_fs_error(s, __ratelimit(&MSDOS_SB(s)->ratelimit), fmt , ## args)
 extern int fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
diff -puN fs/fat/inode.c~fatfs-ratelimit-corruption-report fs/fat/inode.c
--- a/fs/fat/inode.c~fatfs-ratelimit-corruption-report
+++ a/fs/fat/inode.c
@@ -1250,6 +1250,8 @@ int fat_fill_super(struct super_block *s
 	sb->s_op = &fat_sops;
 	sb->s_export_op = &fat_export_ops;
 	sbi->dir_ops = fs_dir_inode_ops;
+	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
 
 	error = parse_options(data, isvfat, silent, &debug, &sbi->options);
 	if (error)
diff -puN fs/fat/misc.c~fatfs-ratelimit-corruption-report fs/fat/misc.c
--- a/fs/fat/misc.c~fatfs-ratelimit-corruption-report
+++ a/fs/fat/misc.c
@@ -20,27 +20,29 @@
  * In case the file system is remounted read-only, it can be made writable
  * again by remounting it.
  */
-void fat_fs_error(struct super_block *s, const char *fmt, ...)
+void __fat_fs_error(struct super_block *s, int report, const char *fmt, ...)
 {
 	struct fat_mount_options *opts = &MSDOS_SB(s)->options;
 	va_list args;
 
-	printk(KERN_ERR "FAT: Filesystem error (dev %s)\n", s->s_id);
+	if (report) {
+		printk(KERN_ERR "FAT: Filesystem error (dev %s)\n", s->s_id);
 
-	printk(KERN_ERR "    ");
-	va_start(args, fmt);
-	vprintk(fmt, args);
-	va_end(args);
-	printk("\n");
+		printk(KERN_ERR "    ");
+		va_start(args, fmt);
+		vprintk(fmt, args);
+		va_end(args);
+		printk("\n");
+	}
 
 	if (opts->errors == FAT_ERRORS_PANIC)
-		panic("    FAT fs panic from previous error\n");
+		panic("FAT: fs panic from previous error\n");
 	else if (opts->errors == FAT_ERRORS_RO && !(s->s_flags & MS_RDONLY)) {
 		s->s_flags |= MS_RDONLY;
-		printk(KERN_ERR "    File system has been set read-only\n");
+		printk(KERN_ERR "FAT: Filesystem has been set read-only\n");
 	}
 }
-EXPORT_SYMBOL_GPL(fat_fs_error);
+EXPORT_SYMBOL_GPL(__fat_fs_error);
 
 /* Flushes the number of free clusters on FAT32 */
 /* XXX: Need to write one per FSINFO block.  Currently only writes 1 */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
linux-next.patch
printk_ratelimited-fix-uninitialized-spinlock.patch
ratelimit-add-ratelimit_state_init.patch
fatfs-ratelimit-corruption-report.patch

