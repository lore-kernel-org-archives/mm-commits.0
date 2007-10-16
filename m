From: akpm@linux-foundation.org
Subject: - m32r-convert-to-generic-sys_ptrace.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:39 -0700
Message-ID: <200710162036.l9GKadun015201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965489AbXJPVf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: convert to generic sys_ptrace
has been removed from the -mm tree.  Its filename was
     m32r-convert-to-generic-sys_ptrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m32r: convert to generic sys_ptrace
From: Christoph Hellwig <hch@lst.de>

Convert m32r to the generic sys_ptrace.  The conversion requires an
architecture hook after ptrace_attach which this patch adds.  The hook
will also be needed for a conersion of ia64 to the generic ptrace code.

Thanks to Hirokazu Takata for fixing a bug in the first version of this
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/ptrace.c |   42 ++----------------------------------
 include/asm-m32r/ptrace.h |    5 +++-
 kernel/ptrace.c           |   10 ++++++++
 3 files changed, 17 insertions(+), 40 deletions(-)

diff -puN arch/m32r/kernel/ptrace.c~m32r-convert-to-generic-sys_ptrace arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~m32r-convert-to-generic-sys_ptrace
+++ a/arch/m32r/kernel/ptrace.c
@@ -570,7 +570,7 @@ withdraw_debug_trap(struct pt_regs *regs
 	}
 }
 
-static void
+void
 init_debug_traps(struct task_struct *child)
 {
 	struct debug_trap *p = &child->thread.debug_trap;
@@ -593,8 +593,8 @@ void ptrace_disable(struct task_struct *
 	/* nothing to do.. */
 }
 
-static int
-do_ptrace(long request, struct task_struct *child, long addr, long data)
+long
+arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	int ret;
 
@@ -720,42 +720,6 @@ do_ptrace(long request, struct task_stru
 	return ret;
 }
 
-asmlinkage long sys_ptrace(long request, long pid, long addr, long data)
-{
-	struct task_struct *child;
-	int ret;
-
-	lock_kernel();
-	if (request == PTRACE_TRACEME) {
-		ret = ptrace_traceme();
-		goto out;
-	}
-
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child)) {
-		ret = PTR_ERR(child);
-		goto out;
-	}
-
-	if (request == PTRACE_ATTACH) {
-		ret = ptrace_attach(child);
-		if (ret == 0)
-			init_debug_traps(child);
-		goto out_tsk;
-	}
-
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (ret == 0)
-		ret = do_ptrace(request, child, addr, data);
-
-out_tsk:
-	put_task_struct(child);
-out:
-	unlock_kernel();
-
-	return ret;
-}
-
 /* notification of system call entry/exit
  * - triggered by current->work.syscall_trace
  */
diff -puN include/asm-m32r/ptrace.h~m32r-convert-to-generic-sys_ptrace include/asm-m32r/ptrace.h
--- a/include/asm-m32r/ptrace.h~m32r-convert-to-generic-sys_ptrace
+++ a/include/asm-m32r/ptrace.h
@@ -120,7 +120,10 @@ struct pt_regs {
 
 #include <asm/m32r.h>		/* M32R_PSW_BSM, M32R_PSW_BPM */
 
-#define __ARCH_SYS_PTRACE	1
+struct task_struct;
+extern void init_debug_traps(struct task_struct *);
+#define arch_ptrace_attach(child) \
+	init_debug_traps(child)
 
 #if defined(CONFIG_ISA_M32R2) || defined(CONFIG_CHIP_VDEC2)
 #define user_mode(regs) ((M32R_PSW_BPM & (regs)->psw) != 0)
diff -puN kernel/ptrace.c~m32r-convert-to-generic-sys_ptrace kernel/ptrace.c
--- a/kernel/ptrace.c~m32r-convert-to-generic-sys_ptrace
+++ a/kernel/ptrace.c
@@ -453,6 +453,10 @@ struct task_struct *ptrace_get_task_stru
 	return child;
 }
 
+#ifndef arch_ptrace_attach
+#define arch_ptrace_attach(child)	do { } while (0)
+#endif
+
 #ifndef __ARCH_SYS_PTRACE
 asmlinkage long sys_ptrace(long request, long pid, long addr, long data)
 {
@@ -476,6 +480,12 @@ asmlinkage long sys_ptrace(long request,
 
 	if (request == PTRACE_ATTACH) {
 		ret = ptrace_attach(child);
+		/*
+		 * Some architectures need to do book-keeping after
+		 * a ptrace attach.
+		 */
+		if (!ret)
+			arch_ptrace_attach(child);
 		goto out_put_task_struct;
 	}
 
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
partially-fix-up-the-lookup_one_noperm-mess.patch
git-xfs.patch
kill-declare_mutex_locked.patch
remove-unneded-lock_kernel-in-driver-block-loopc.patch
ufs-move-non-layout-parts-of-ufs_fsh-to-fs-ufs.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
f_dupfd_cloexec-implementation.patch
f_dupfd_cloexec-implementation-fix-2.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch
cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch
r-o-bind-mounts-give-permission-a-local-mnt-variable.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
make-reiserfs-stop-using-struct-file-for-internal.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
xfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
