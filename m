From: akpm@linux-foundation.org
Subject: - debugfs-fix-sparse-warnings.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:24:10 -0800
Message-ID: <200802232024.m1NKOAfs013615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761586AbYBWU2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     debugfs: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     debugfs-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
markers-fix-sparse-warnings-in-markersc.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-nfsd.patch
git-sched.patch
git-scsi-rc-fixes.patch
git-x86.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
