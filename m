From: akpm@linux-foundation.org
Subject: [merged] reiserfs-dont-compile-procfso-at-all-if-no-support.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:05 -0800
Message-ID: <200912162037.nBGKb5hq013305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935480AbZLPUhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: don't compile procfs.o at all if no support
has been removed from the -mm tree.  Its filename was
     reiserfs-dont-compile-procfso-at-all-if-no-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: don't compile procfs.o at all if no support
From: Alexey Dobriyan <adobriyan@gmail.com>

* small define cleanup in header
* fix #ifdeffery in procfs.c via Kconfig

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/Makefile        |    6 +++++-
 fs/reiserfs/procfs.c        |   26 --------------------------
 include/linux/reiserfs_fs.h |   30 +++++++++++++++++++++---------
 3 files changed, 26 insertions(+), 36 deletions(-)

diff -puN fs/reiserfs/Makefile~reiserfs-dont-compile-procfso-at-all-if-no-support fs/reiserfs/Makefile
--- a/fs/reiserfs/Makefile~reiserfs-dont-compile-procfso-at-all-if-no-support
+++ a/fs/reiserfs/Makefile
@@ -7,7 +7,11 @@ obj-$(CONFIG_REISERFS_FS) += reiserfs.o
 reiserfs-objs := bitmap.o do_balan.o namei.o inode.o file.o dir.o fix_node.o \
 		 super.o prints.o objectid.o lbalance.o ibalance.o stree.o \
 		 hashes.o tail_conversion.o journal.o resize.o \
-		 item_ops.o ioctl.o procfs.o xattr.o lock.o
+		 item_ops.o ioctl.o xattr.o lock.o
+
+ifeq ($(CONFIG_REISERFS_PROC_INFO),y)
+reiserfs-objs += procfs.o
+endif
 
 ifeq ($(CONFIG_REISERFS_FS_XATTR),y)
 reiserfs-objs += xattr_user.o xattr_trusted.o
diff -puN fs/reiserfs/procfs.c~reiserfs-dont-compile-procfso-at-all-if-no-support fs/reiserfs/procfs.c
--- a/fs/reiserfs/procfs.c~reiserfs-dont-compile-procfso-at-all-if-no-support
+++ a/fs/reiserfs/procfs.c
@@ -17,8 +17,6 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 
-#ifdef CONFIG_REISERFS_PROC_INFO
-
 /*
  * LOCKING:
  *
@@ -551,30 +549,6 @@ int reiserfs_proc_info_global_done(void)
 	}
 	return 0;
 }
-
-/* REISERFS_PROC_INFO */
-#else
-
-int reiserfs_proc_info_init(struct super_block *sb)
-{
-	return 0;
-}
-int reiserfs_proc_info_done(struct super_block *sb)
-{
-	return 0;
-}
-
-int reiserfs_proc_info_global_init(void)
-{
-	return 0;
-}
-int reiserfs_proc_info_global_done(void)
-{
-	return 0;
-}
-/* REISERFS_PROC_INFO */
-#endif
-
 /*
  * Revision 1.1.8.2  2001/07/15 17:08:42  god
  *  . use get_super() in procfs.c
diff -puN include/linux/reiserfs_fs.h~reiserfs-dont-compile-procfso-at-all-if-no-support include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-dont-compile-procfso-at-all-if-no-support
+++ a/include/linux/reiserfs_fs.h
@@ -2051,21 +2051,13 @@ void set_de_name_and_namelen(struct reis
 int search_by_entry_key(struct super_block *sb, const struct cpu_key *key,
 			struct treepath *path, struct reiserfs_dir_entry *de);
 struct dentry *reiserfs_get_parent(struct dentry *);
-/* procfs.c */
-
-#if defined( CONFIG_PROC_FS ) && defined( CONFIG_REISERFS_PROC_INFO )
-#define REISERFS_PROC_INFO
-#else
-#undef REISERFS_PROC_INFO
-#endif
 
+#ifdef CONFIG_REISERFS_PROC_INFO
 int reiserfs_proc_info_init(struct super_block *sb);
 int reiserfs_proc_info_done(struct super_block *sb);
 int reiserfs_proc_info_global_init(void);
 int reiserfs_proc_info_global_done(void);
 
-#if defined( REISERFS_PROC_INFO )
-
 #define PROC_EXP( e )   e
 
 #define __PINFO( sb ) REISERFS_SB(sb) -> s_proc_info_data
@@ -2079,6 +2071,26 @@ int reiserfs_proc_info_global_done(void)
     PROC_INFO_ADD( sb, free_at[ ( level ) ], B_FREE_SPACE( bh ) );	\
     PROC_INFO_ADD( sb, items_at[ ( level ) ], B_NR_ITEMS( bh ) )
 #else
+static inline int reiserfs_proc_info_init(struct super_block *sb)
+{
+	return 0;
+}
+
+static inline int reiserfs_proc_info_done(struct super_block *sb)
+{
+	return 0;
+}
+
+static inline int reiserfs_proc_info_global_init(void)
+{
+	return 0;
+}
+
+static inline int reiserfs_proc_info_global_done(void)
+{
+	return 0;
+}
+
 #define PROC_EXP( e )
 #define VOID_V ( ( void ) 0 )
 #define PROC_INFO_MAX( sb, field, value ) VOID_V
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
mpt-fusion-convert-to-seq_file.patch
uml-irq-register-race-condition.patch

