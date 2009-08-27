From: akpm@linux-foundation.org
Subject: + reiserfs-dont-compile-procfso-at-all-if-no-support.patch added to -mm tree
Date: Thu, 27 Aug 2009 14:13:19 -0700
Message-ID: <200908272113.n7RLDKBi021482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbZH0VNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 17:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, jeffm@suse.com


The patch titled
     reiserfs: don't compile procfs.o at all if no support
has been added to the -mm tree.  Its filename is
     reiserfs-dont-compile-procfso-at-all-if-no-support.patch

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
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch

