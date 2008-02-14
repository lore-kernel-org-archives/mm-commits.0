From: akpm@linux-foundation.org
Subject: + debugfs-fix-sparse-warnings.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:03:27 -0800
Message-ID: <200802142103.m1EL3RHp002730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762096AbYBNVDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:03:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, greg@kroah.com


The patch titled
     debugfs: fix sparse warnings
has been added to the -mm tree.  Its filename is
     debugfs-fix-sparse-warnings.patch

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
Subject: debugfs: fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

extern does not belong in C files, move declaration to linux/debugfs.h
fs/debugfs/file.c:42:30: warning: symbol 'debugfs_file_operations' was not declared. Should it be static?
fs/debugfs/file.c:54:31: warning: symbol 'debugfs_link_operations' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/debugfs/inode.c      |    4 ----
 include/linux/debugfs.h |    5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/debugfs/inode.c~debugfs-fix-sparse-warnings fs/debugfs/inode.c
--- a/fs/debugfs/inode.c~debugfs-fix-sparse-warnings
+++ a/fs/debugfs/inode.c
@@ -29,10 +29,6 @@
 
 #define DEBUGFS_MAGIC	0x64626720
 
-/* declared over in file.c */
-extern struct file_operations debugfs_file_operations;
-extern struct inode_operations debugfs_link_operations;
-
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 
diff -puN include/linux/debugfs.h~debugfs-fix-sparse-warnings include/linux/debugfs.h
--- a/include/linux/debugfs.h~debugfs-fix-sparse-warnings
+++ a/include/linux/debugfs.h
@@ -27,6 +27,11 @@ struct debugfs_blob_wrapper {
 };
 
 #if defined(CONFIG_DEBUG_FS)
+
+/* declared over in file.c */
+extern const struct file_operations debugfs_file_operations;
+extern const struct inode_operations debugfs_link_operations;
+
 struct dentry *debugfs_create_file(const char *name, mode_t mode,
 				   struct dentry *parent, void *data,
 				   const struct file_operations *fops);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
include-linux-remove-all-users-of-fastcall-macro.patch
rcupdate-fix-comment.patch
remove-final-fastcall-users.patch
final-removal-of-fastcall-fastcall.patch
inotify-make-variables-static-in-inotify_userc.patch
kernel-doc-remove-fastcall.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
