From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-powerpc.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:42:07 -0700
Message-ID: <201010042342.o94Ng7IH022767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab0JDXml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:42:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     ptrace: cleanup arch_ptrace() on powerpc
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-powerpc.patch

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
Subject: ptrace: cleanup arch_ptrace() on powerpc
From: Namhyung Kim <namhyung@gmail.com>

Use new 'datavp' and 'datalp' variables in order to remove unnecessary
castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ptrace.c |   51 ++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff -puN arch/powerpc/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-powerpc arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-powerpc
+++ a/arch/powerpc/kernel/ptrace.c
@@ -1409,26 +1409,28 @@ static long ppc_del_hwdebug(struct task_
 static long arch_ptrace_old(struct task_struct *child, long request,
 			    unsigned long addr, unsigned long data)
 {
+	void __user *datavp = (void __user *) data;
+
 	switch (request) {
 	case PPC_PTRACE_GETREGS:	/* Get GPRs 0 - 31. */
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_GPR, 0, 32 * sizeof(long),
-					   (void __user *) data);
+					   datavp);
 
 	case PPC_PTRACE_SETREGS:	/* Set GPRs 0 - 31. */
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_GPR, 0, 32 * sizeof(long),
-					     (const void __user *) data);
+					     datavp);
 
 	case PPC_PTRACE_GETFPREGS:	/* Get FPRs 0 - 31. */
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_FPR, 0, 32 * sizeof(double),
-					   (void __user *) data);
+					   datavp);
 
 	case PPC_PTRACE_SETFPREGS:	/* Set FPRs 0 - 31. */
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_FPR, 0, 32 * sizeof(double),
-					     (const void __user *) data);
+					     datavp);
 	}
 
 	return -EPERM;
@@ -1438,6 +1440,8 @@ long arch_ptrace(struct task_struct *chi
 		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
+	void __user *datavp = (void __user *) data;
+	unsigned long __user *datalp = datavp;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -1464,7 +1468,7 @@ long arch_ptrace(struct task_struct *chi
 			tmp = ((unsigned long *)child->thread.fpr)
 				[TS_FPRWIDTH * (index - PT_FPR0)];
 		}
-		ret = put_user(tmp,(unsigned long __user *) data);
+		ret = put_user(tmp, datalp);
 		break;
 	}
 
@@ -1526,11 +1530,11 @@ long arch_ptrace(struct task_struct *chi
 		dbginfo.features = 0;
 #endif /* CONFIG_PPC_ADV_DEBUG_REGS */
 
-		if (!access_ok(VERIFY_WRITE, data,
+		if (!access_ok(VERIFY_WRITE, datavp,
 			       sizeof(struct ppc_debug_info)))
 			return -EFAULT;
-		ret = __copy_to_user((struct ppc_debug_info __user *)data,
-				     &dbginfo, sizeof(struct ppc_debug_info)) ?
+		ret = __copy_to_user(datavp, &dbginfo,
+				     sizeof(struct ppc_debug_info)) ?
 		      -EFAULT : 0;
 		break;
 	}
@@ -1538,11 +1542,10 @@ long arch_ptrace(struct task_struct *chi
 	case PPC_PTRACE_SETHWDEBUG: {
 		struct ppc_hw_breakpoint bp_info;
 
-		if (!access_ok(VERIFY_READ, data,
+		if (!access_ok(VERIFY_READ, datavp,
 			       sizeof(struct ppc_hw_breakpoint)))
 			return -EFAULT;
-		ret = __copy_from_user(&bp_info,
-				       (struct ppc_hw_breakpoint __user *)data,
+		ret = __copy_from_user(&bp_info, datavp,
 				       sizeof(struct ppc_hw_breakpoint)) ?
 		      -EFAULT : 0;
 		if (!ret)
@@ -1561,11 +1564,9 @@ long arch_ptrace(struct task_struct *chi
 		if (addr > 0)
 			break;
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-		ret = put_user(child->thread.dac1,
-			       (unsigned long __user *)data);
+		ret = put_user(child->thread.dac1, datalp);
 #else
-		ret = put_user(child->thread.dabr,
-			       (unsigned long __user *)data);
+		ret = put_user(child->thread.dabr, datalp);
 #endif
 		break;
 	}
@@ -1581,7 +1582,7 @@ long arch_ptrace(struct task_struct *chi
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_GPR,
 					   0, sizeof(struct pt_regs),
-					   (void __user *) data);
+					   datavp);
 
 #ifdef CONFIG_PPC64
 	case PTRACE_SETREGS64:
@@ -1590,19 +1591,19 @@ long arch_ptrace(struct task_struct *chi
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_GPR,
 					     0, sizeof(struct pt_regs),
-					     (const void __user *) data);
+					     datavp);
 
 	case PTRACE_GETFPREGS: /* Get the child FPU state (FPR0...31 + FPSCR) */
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_FPR,
 					   0, sizeof(elf_fpregset_t),
-					   (void __user *) data);
+					   datavp);
 
 	case PTRACE_SETFPREGS: /* Set the child FPU state (FPR0...31 + FPSCR) */
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_FPR,
 					     0, sizeof(elf_fpregset_t),
-					     (const void __user *) data);
+					     datavp);
 
 #ifdef CONFIG_ALTIVEC
 	case PTRACE_GETVRREGS:
@@ -1610,40 +1611,40 @@ long arch_ptrace(struct task_struct *chi
 					   REGSET_VMX,
 					   0, (33 * sizeof(vector128) +
 					       sizeof(u32)),
-					   (void __user *) data);
+					   datavp);
 
 	case PTRACE_SETVRREGS:
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_VMX,
 					     0, (33 * sizeof(vector128) +
 						 sizeof(u32)),
-					     (const void __user *) data);
+					     datavp);
 #endif
 #ifdef CONFIG_VSX
 	case PTRACE_GETVSRREGS:
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_VSX,
 					   0, 32 * sizeof(double),
-					   (void __user *) data);
+					   datavp);
 
 	case PTRACE_SETVSRREGS:
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_VSX,
 					     0, 32 * sizeof(double),
-					     (const void __user *) data);
+					     datavp);
 #endif
 #ifdef CONFIG_SPE
 	case PTRACE_GETEVRREGS:
 		/* Get the child spe register state. */
 		return copy_regset_to_user(child, &user_ppc_native_view,
 					   REGSET_SPE, 0, 35 * sizeof(u32),
-					   (void __user *) data);
+					   datavp);
 
 	case PTRACE_SETEVRREGS:
 		/* Set the child spe register state. */
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					     REGSET_SPE, 0, 35 * sizeof(u32),
-					     (const void __user *) data);
+					     datavp);
 #endif
 
 	/* Old reverse args ptrace callss */
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

