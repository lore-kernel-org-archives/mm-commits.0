From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-sh.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:42:11 -0700
Message-ID: <201010042342.o94NgBIF022780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460Ab0JDXxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, lethal@linux-sh.org


The patch titled
     ptrace: cleanup arch_ptrace() on sh
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-sh.patch

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
Subject: ptrace: cleanup arch_ptrace() on sh
From: Namhyung Kim <namhyung@gmail.com>

Remove unnecessary castings and get rid of dummy pointer in favor of
offsetof() macro in ptrace_32.c. Also use temporary variables and
break long lines in order to improve readability.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/ptrace_32.c |   38 +++++++++++++++++++----------------
 arch/sh/kernel/ptrace_64.c |   19 +++++++++++------
 2 files changed, 33 insertions(+), 24 deletions(-)

diff -puN arch/sh/kernel/ptrace_32.c~ptrace-cleanup-arch_ptrace-on-sh arch/sh/kernel/ptrace_32.c
--- a/arch/sh/kernel/ptrace_32.c~ptrace-cleanup-arch_ptrace-on-sh
+++ a/arch/sh/kernel/ptrace_32.c
@@ -368,7 +368,6 @@ const struct user_regset_view *task_user
 long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
-	struct user * dummy = NULL;
 	unsigned long __user *datap = (unsigned long __user *)data;
 	int ret;
 
@@ -384,17 +383,20 @@ long arch_ptrace(struct task_struct *chi
 
 		if (addr < sizeof(struct pt_regs))
 			tmp = get_stack_long(child, addr);
-		else if (addr >= (unsigned long) &dummy->fpu &&
-			 addr < (unsigned long) &dummy->u_fpvalid) {
+		else if (addr >= offsetof(struct user, fpu) &&
+			 addr < offsetof(struct user, u_fpvalid)) {
 			if (!tsk_used_math(child)) {
-				if (addr == (unsigned long)&dummy->fpu.fpscr)
+				if (addr == offsetof(struct user, fpu.fpscr))
 					tmp = FPSCR_INIT;
 				else
 					tmp = 0;
-			} else
+			} else {
+				unsigned long index;
+				index = addr - offsetof(struct user, fpu);
 				tmp = ((unsigned long *)child->thread.xstate)
-					[(addr - (long)&dummy->fpu) >> 2];
-		} else if (addr == (unsigned long) &dummy->u_fpvalid)
+					[index >> 2];
+			}
+		} else if (addr == offsetof(struct user, u_fpvalid))
 			tmp = !!tsk_used_math(child);
 		else if (addr == PT_TEXT_ADDR)
 			tmp = child->mm->start_code;
@@ -418,13 +420,15 @@ long arch_ptrace(struct task_struct *chi
 
 		if (addr < sizeof(struct pt_regs))
 			ret = put_stack_long(child, addr, data);
-		else if (addr >= (unsigned long) &dummy->fpu &&
-			 addr < (unsigned long) &dummy->u_fpvalid) {
+		else if (addr >= offsetof(struct user, fpu) &&
+			 addr < offsetof(struct user, u_fpvalid)) {
+			unsigned long index;
+			index = addr - offsetof(struct user, fpu);
 			set_stopped_child_used_math(child);
 			((unsigned long *)child->thread.xstate)
-				[(addr - (long)&dummy->fpu) >> 2] = data;
+				[index >> 2] = data;
 			ret = 0;
-		} else if (addr == (unsigned long) &dummy->u_fpvalid) {
+		} else if (addr == offsetof(struct user, u_fpvalid)) {
 			conditional_stopped_child_used_math(data, child);
 			ret = 0;
 		}
@@ -434,35 +438,35 @@ long arch_ptrace(struct task_struct *chi
 		return copy_regset_to_user(child, &user_sh_native_view,
 					   REGSET_GENERAL,
 					   0, sizeof(struct pt_regs),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETREGS:
 		return copy_regset_from_user(child, &user_sh_native_view,
 					     REGSET_GENERAL,
 					     0, sizeof(struct pt_regs),
-					     (const void __user *)data);
+					     datap);
 #ifdef CONFIG_SH_FPU
 	case PTRACE_GETFPREGS:
 		return copy_regset_to_user(child, &user_sh_native_view,
 					   REGSET_FPU,
 					   0, sizeof(struct user_fpu_struct),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETFPREGS:
 		return copy_regset_from_user(child, &user_sh_native_view,
 					     REGSET_FPU,
 					     0, sizeof(struct user_fpu_struct),
-					     (const void __user *)data);
+					     datap);
 #endif
 #ifdef CONFIG_SH_DSP
 	case PTRACE_GETDSPREGS:
 		return copy_regset_to_user(child, &user_sh_native_view,
 					   REGSET_DSP,
 					   0, sizeof(struct pt_dspregs),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETDSPREGS:
 		return copy_regset_from_user(child, &user_sh_native_view,
 					     REGSET_DSP,
 					     0, sizeof(struct pt_dspregs),
-					     (const void __user *)data);
+					     datap);
 #endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
diff -puN arch/sh/kernel/ptrace_64.c~ptrace-cleanup-arch_ptrace-on-sh arch/sh/kernel/ptrace_64.c
--- a/arch/sh/kernel/ptrace_64.c~ptrace-cleanup-arch_ptrace-on-sh
+++ a/arch/sh/kernel/ptrace_64.c
@@ -387,6 +387,7 @@ long arch_ptrace(struct task_struct *chi
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -401,13 +402,15 @@ long arch_ptrace(struct task_struct *chi
 			tmp = get_stack_long(child, addr);
 		else if ((addr >= offsetof(struct user, fpu)) &&
 			 (addr <  offsetof(struct user, u_fpvalid))) {
-			tmp = get_fpu_long(child, addr - offsetof(struct user, fpu));
+			unsigned long index;
+			index = addr - offsetof(struct user, fpu);
+			tmp = get_fpu_long(child, index);
 		} else if (addr == offsetof(struct user, u_fpvalid)) {
 			tmp = !!tsk_used_math(child);
 		} else {
 			break;
 		}
-		ret = put_user(tmp, (unsigned long *)data);
+		ret = put_user(tmp, datap);
 		break;
 	}
 
@@ -438,7 +441,9 @@ long arch_ptrace(struct task_struct *chi
 		}
 		else if ((addr >= offsetof(struct user, fpu)) &&
 			 (addr <  offsetof(struct user, u_fpvalid))) {
-			ret = put_fpu_long(child, addr - offsetof(struct user, fpu), data);
+			unsigned long index;
+			index = addr - offsetof(struct user, fpu);
+			ret = put_fpu_long(child, index, data);
 		}
 		break;
 
@@ -446,23 +451,23 @@ long arch_ptrace(struct task_struct *chi
 		return copy_regset_to_user(child, &user_sh64_native_view,
 					   REGSET_GENERAL,
 					   0, sizeof(struct pt_regs),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETREGS:
 		return copy_regset_from_user(child, &user_sh64_native_view,
 					     REGSET_GENERAL,
 					     0, sizeof(struct pt_regs),
-					     (const void __user *)data);
+					     datap);
 #ifdef CONFIG_SH_FPU
 	case PTRACE_GETFPREGS:
 		return copy_regset_to_user(child, &user_sh64_native_view,
 					   REGSET_FPU,
 					   0, sizeof(struct user_fpu_struct),
-					   (void __user *)data);
+					   datap);
 	case PTRACE_SETFPREGS:
 		return copy_regset_from_user(child, &user_sh64_native_view,
 					     REGSET_FPU,
 					     0, sizeof(struct user_fpu_struct),
-					     (const void __user *)data);
+					     datap);
 #endif
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

