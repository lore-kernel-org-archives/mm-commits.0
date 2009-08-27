From: akpm@linux-foundation.org
Subject: + reiserfs-remove-proc-fs-reiserfs-version.patch added to -mm tree
Date: Thu, 27 Aug 2009 14:13:17 -0700
Message-ID: <200908272113.n7RLDHCt021275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbZH0VN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 17:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, jeffm@suse.com


The patch titled
     reiserfs: remove /proc/fs/reiserfs/version
has been added to the -mm tree.  Its filename is
     reiserfs-remove-proc-fs-reiserfs-version.patch

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
Subject: reiserfs: remove /proc/fs/reiserfs/version
From: Alexey Dobriyan <adobriyan@gmail.com>

/proc/fs/reiserfs/version is on the way of removing ->read_proc interface.
 It's empty however, so simply remove it instead of doing dummy
conversion.  It's hard to see what information userspace can extract from
empty file.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/procfs.c        |   39 ----------------------------------
 fs/reiserfs/super.c         |    4 ---
 include/linux/reiserfs_fs.h |    5 ----
 3 files changed, 48 deletions(-)

diff -puN fs/reiserfs/procfs.c~reiserfs-remove-proc-fs-reiserfs-version fs/reiserfs/procfs.c
--- a/fs/reiserfs/procfs.c~reiserfs-remove-proc-fs-reiserfs-version
+++ a/fs/reiserfs/procfs.c
@@ -48,14 +48,6 @@ static int show_version(struct seq_file 
 	return 0;
 }
 
-int reiserfs_global_version_in_proc(char *buffer, char **start, off_t offset,
-				    int count, int *eof, void *data)
-{
-	*start = buffer;
-	*eof = 1;
-	return 0;
-}
-
 #define SF( x ) ( r -> x )
 #define SFP( x ) SF( s_proc_info_data.x )
 #define SFPL( x ) SFP( x[ level ] )
@@ -538,19 +530,6 @@ int reiserfs_proc_info_done(struct super
 	return 0;
 }
 
-struct proc_dir_entry *reiserfs_proc_register_global(char *name,
-						     read_proc_t * func)
-{
-	return (proc_info_root) ? create_proc_read_entry(name, 0,
-							 proc_info_root,
-							 func, NULL) : NULL;
-}
-
-void reiserfs_proc_unregister_global(const char *name)
-{
-	remove_proc_entry(name, proc_info_root);
-}
-
 int reiserfs_proc_info_global_init(void)
 {
 	if (proc_info_root == NULL) {
@@ -585,16 +564,6 @@ int reiserfs_proc_info_done(struct super
 	return 0;
 }
 
-struct proc_dir_entry *reiserfs_proc_register_global(char *name,
-						     read_proc_t * func)
-{
-	return NULL;
-}
-
-void reiserfs_proc_unregister_global(const char *name)
-{;
-}
-
 int reiserfs_proc_info_global_init(void)
 {
 	return 0;
@@ -603,14 +572,6 @@ int reiserfs_proc_info_global_done(void)
 {
 	return 0;
 }
-
-int reiserfs_global_version_in_proc(char *buffer, char **start,
-				    off_t offset,
-				    int count, int *eof, void *data)
-{
-	return 0;
-}
-
 /* REISERFS_PROC_INFO */
 #endif
 
diff -puN fs/reiserfs/super.c~reiserfs-remove-proc-fs-reiserfs-version fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-remove-proc-fs-reiserfs-version
+++ a/fs/reiserfs/super.c
@@ -2222,8 +2222,6 @@ static int __init init_reiserfs_fs(void)
 	}
 
 	reiserfs_proc_info_global_init();
-	reiserfs_proc_register_global("version",
-				      reiserfs_global_version_in_proc);
 
 	ret = register_filesystem(&reiserfs_fs_type);
 
@@ -2231,7 +2229,6 @@ static int __init init_reiserfs_fs(void)
 		return 0;
 	}
 
-	reiserfs_proc_unregister_global("version");
 	reiserfs_proc_info_global_done();
 	destroy_inodecache();
 
@@ -2240,7 +2237,6 @@ static int __init init_reiserfs_fs(void)
 
 static void __exit exit_reiserfs_fs(void)
 {
-	reiserfs_proc_unregister_global("version");
 	reiserfs_proc_info_global_done();
 	unregister_filesystem(&reiserfs_fs_type);
 	destroy_inodecache();
diff -puN include/linux/reiserfs_fs.h~reiserfs-remove-proc-fs-reiserfs-version include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-remove-proc-fs-reiserfs-version
+++ a/include/linux/reiserfs_fs.h
@@ -2061,13 +2061,8 @@ struct dentry *reiserfs_get_parent(struc
 
 int reiserfs_proc_info_init(struct super_block *sb);
 int reiserfs_proc_info_done(struct super_block *sb);
-struct proc_dir_entry *reiserfs_proc_register_global(char *name,
-						     read_proc_t * func);
-void reiserfs_proc_unregister_global(const char *name);
 int reiserfs_proc_info_global_init(void);
 int reiserfs_proc_info_global_done(void);
-int reiserfs_global_version_in_proc(char *buffer, char **start, off_t offset,
-				    int count, int *eof, void *data);
 
 #if defined( REISERFS_PROC_INFO )
 
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

