From: akpm@linux-foundation.org
Subject: - alpha-convert-to-generic-sys_ptrace.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:29 -0700
Message-ID: <200710162036.l9GKaTi2015185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42010 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935944AbXJPVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: convert to generic sys_ptrace
has been removed from the -mm tree.  Its filename was
     alpha-convert-to-generic-sys_ptrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alpha: convert to generic sys_ptrace
From: Christoph Hellwig <hch@lst.de>

This patch converts alpha to the generic sys_ptrace.  We use
force_successful_syscall_return to avoid having to pass the pt_regs pointer
down to the function.  I think the removal of the assemly stub is correct,
but I could only compile-test this patch, so please give it a spin before
commiting :)

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/entry.S  |    9 -------
 arch/alpha/kernel/ptrace.c |   42 +++++------------------------------
 include/asm-alpha/ptrace.h |    2 -
 3 files changed, 6 insertions(+), 47 deletions(-)

diff -puN arch/alpha/kernel/entry.S~alpha-convert-to-generic-sys_ptrace arch/alpha/kernel/entry.S
--- a/arch/alpha/kernel/entry.S~alpha-convert-to-generic-sys_ptrace
+++ a/arch/alpha/kernel/entry.S
@@ -917,15 +917,6 @@ sys_pipe:
 .end sys_pipe
 
 	.align	4
-	.globl	sys_ptrace
-	.ent	sys_ptrace
-sys_ptrace:
-	.prologue 0
-	mov	$sp, $20
-	jmp	$31, do_sys_ptrace
-.end sys_ptrace
-
-	.align	4
 	.globl	sys_execve
 	.ent	sys_execve
 sys_execve:
diff -puN arch/alpha/kernel/ptrace.c~alpha-convert-to-generic-sys_ptrace arch/alpha/kernel/ptrace.c
--- a/arch/alpha/kernel/ptrace.c~alpha-convert-to-generic-sys_ptrace
+++ a/arch/alpha/kernel/ptrace.c
@@ -260,38 +260,12 @@ void ptrace_disable(struct task_struct *
 	ptrace_cancel_bpt(child);
 }
 
-asmlinkage long
-do_sys_ptrace(long request, long pid, long addr, long data,
-	      struct pt_regs *regs)
+long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	struct task_struct *child;
 	unsigned long tmp;
 	size_t copied;
 	long ret;
 
-	lock_kernel();
-	DBG(DBG_MEM, ("request=%ld pid=%ld addr=0x%lx data=0x%lx\n",
-		      request, pid, addr, data));
-	if (request == PTRACE_TRACEME) {
-		ret = ptrace_traceme();
-		goto out_notsk;
-	}
-
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child)) {
-		ret = PTR_ERR(child);
-		goto out_notsk;
-	}
-
-	if (request == PTRACE_ATTACH) {
-		ret = ptrace_attach(child);
-		goto out;
-	}
-
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (ret < 0)
-		goto out;
-
 	switch (request) {
 	/* When I and D space are separate, these will need to be fixed.  */
 	case PTRACE_PEEKTEXT: /* read word at location addr. */
@@ -301,13 +275,13 @@ do_sys_ptrace(long request, long pid, lo
 		if (copied != sizeof(tmp))
 			break;
 		
-		regs->r0 = 0;	/* special return: no errors */
+		force_successful_syscall_return();
 		ret = tmp;
 		break;
 
 	/* Read register number ADDR. */
 	case PTRACE_PEEKUSR:
-		regs->r0 = 0;	/* special return: no errors */
+		force_successful_syscall_return();
 		ret = get_reg(child, addr);
 		DBG(DBG_MEM, ("peek $%ld->%#lx\n", addr, ret));
 		break;
@@ -353,7 +327,7 @@ do_sys_ptrace(long request, long pid, lo
 		/* make sure single-step breakpoint is gone. */
 		ptrace_cancel_bpt(child);
 		wake_up_process(child);
-		goto out;
+		break;
 
 	case PTRACE_SINGLESTEP:  /* execute single instruction. */
 		ret = -EIO;
@@ -366,16 +340,12 @@ do_sys_ptrace(long request, long pid, lo
 		wake_up_process(child);
 		/* give it a chance to run. */
 		ret = 0;
-		goto out;
+		break;
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
-		goto out;
+		break;
 	}
- out:
-	put_task_struct(child);
- out_notsk:
-	unlock_kernel();
 	return ret;
 }
 
diff -puN include/asm-alpha/ptrace.h~alpha-convert-to-generic-sys_ptrace include/asm-alpha/ptrace.h
--- a/include/asm-alpha/ptrace.h~alpha-convert-to-generic-sys_ptrace
+++ a/include/asm-alpha/ptrace.h
@@ -68,8 +68,6 @@ struct switch_stack {
 
 #ifdef __KERNEL__
 
-#define __ARCH_SYS_PTRACE	1
-
 #define user_mode(regs) (((regs)->ps & 8) != 0)
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
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
