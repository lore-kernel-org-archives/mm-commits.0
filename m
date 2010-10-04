From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-mn10300.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:42:02 -0700
Message-ID: <201010042342.o94Ng2Nd022757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757026Ab0JDXms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com


The patch titled
     ptrace: cleanup arch_ptrace() on mn10300
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-mn10300.patch

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
Subject: ptrace: cleanup arch_ptrace() on mn10300
From: Namhyung Kim <namhyung@gmail.com>

Use new 'datap' variable in order to remove unnecessary castings.
Also remove checking @addr less than 0 because @addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/ptrace.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN arch/mn10300/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-mn10300 arch/mn10300/kernel/ptrace.c
--- a/arch/mn10300/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-mn10300
+++ a/arch/mn10300/kernel/ptrace.c
@@ -300,27 +300,26 @@ long arch_ptrace(struct task_struct *chi
 {
 	unsigned long tmp;
 	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR:
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & 3) || addr > sizeof(struct user) - 3)
 			break;
 
 		tmp = 0;  /* Default return condition */
 		if (addr < NR_PTREGS << 2)
 			tmp = get_stack_long(child,
 					     ptrace_regid_to_frame[addr]);
-		ret = put_user(tmp, (unsigned long *) data);
+		ret = put_user(tmp, datap);
 		break;
 
 		/* write the word at location addr in the USER area */
 	case PTRACE_POKEUSR:
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & 3) || addr > sizeof(struct user) - 3)
 			break;
 
 		ret = 0;
@@ -333,25 +332,25 @@ long arch_ptrace(struct task_struct *chi
 		return copy_regset_to_user(child, &user_mn10300_native_view,
 					   REGSET_GENERAL,
 					   0, NR_PTREGS * sizeof(long),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETREGS:	/* Set all integer regs in the child. */
 		return copy_regset_from_user(child, &user_mn10300_native_view,
 					     REGSET_GENERAL,
 					     0, NR_PTREGS * sizeof(long),
-					     (const void __user *)data);
+					     datap);
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
 		return copy_regset_to_user(child, &user_mn10300_native_view,
 					   REGSET_FPU,
 					   0, sizeof(struct fpu_state_struct),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
 		return copy_regset_from_user(child, &user_mn10300_native_view,
 					     REGSET_FPU,
 					     0, sizeof(struct fpu_state_struct),
-					     (const void __user *)data);
+					     datap);
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-cleanup-gfp_zone-fix-sparse-warnings.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
ptrace-change-signature-of-sys_ptrace-and-friends.patch
ptrace-cleanup-ptrace_request.patch
ptrace-change-signature-of-arch_ptrace.patch
ptrace-cleanup-arch_ptrace-on-x86.patch
ptrace-cleanup-arch_ptrace-on-arm.patch
ptrace-cleanup-arch_ptrace-on-avr32.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch
ptrace-cleanup-arch_ptrace-on-cris.patch
ptrace-cleanup-arch_ptrace-on-frv.patch
ptrace-cleanup-arch_ptrace-on-h8300.patch
ptrace-cleanup-arch_ptrace-on-m32r.patch
ptrace-cleanup-arch_ptrace-on-m68k.patch
ptrace-cleanup-arch_ptrace-on-microblaze.patch
ptrace-cleanup-arch_ptrace-on-mips.patch
ptrace-cleanup-arch_ptrace-on-mn10300.patch
ptrace-cleanup-arch_ptrace-on-parisc.patch
ptrace-cleanup-arch_ptrace-on-powerpc.patch
ptrace-cleanup-arch_ptrace-on-score.patch
ptrace-cleanup-arch_ptrace-on-sh.patch
ptrace-cleanup-arch_ptrace-on-sparc.patch
ptrace-cleanup-arch_ptrace-on-tile.patch
ptrace-cleanup-arch_ptrace-on-um.patch
ptrace-cleanup-arch_ptrace-on-xtensa.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

