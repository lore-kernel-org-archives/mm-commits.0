From: akpm@linux-foundation.org
Subject: + x86-fix-broken-math-emu-with-lazy-allocation-of-fpu-area.patch added to -mm tree
Date: Wed, 28 May 2008 14:18:30 -0700
Message-ID: <200805282118.m4SLIUSK000512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbYE1VSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 17:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com


The patch titled
     x86: fix broken math-emu with lazy allocation of fpu area
has been added to the -mm tree.  Its filename is
     x86-fix-broken-math-emu-with-lazy-allocation-of-fpu-area.patch

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
Subject: x86: fix broken math-emu with lazy allocation of fpu area
From: Suresh Siddha <suresh.b.siddha@intel.com>

Fix the math emulation that got broken with the recent lazy allocation of
FPU area.  init_fpu() need to be added for the math-emulation path aswell
for the FPU area allocation.

math emulation enabled kernel booted fine with this, in the presence of
"no387 nofxsr" boot param.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/i387.c        |   44 +++++++++++++++++++++-----------
 arch/x86/math-emu/fpu_entry.c |   13 +++++----
 include/asm-x86/i387.h        |    2 +
 3 files changed, 39 insertions(+), 20 deletions(-)

diff -puN arch/x86/kernel/i387.c~x86-fix-broken-math-emu-with-lazy-allocation-of-fpu-area arch/x86/kernel/i387.c
--- a/arch/x86/kernel/i387.c~x86-fix-broken-math-emu-with-lazy-allocation-of-fpu-area
+++ a/arch/x86/kernel/i387.c
@@ -56,6 +56,11 @@ void __cpuinit mxcsr_feature_mask_init(v
 
 void __init init_thread_xstate(void)
 {
+	if (!HAVE_HWFP) {
+		xstate_size = sizeof(struct i387_soft_struct);
+		return;
+	}
+
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
 #ifdef CONFIG_X86_32
@@ -94,7 +99,7 @@ void __cpuinit fpu_init(void)
 int init_fpu(struct task_struct *tsk)
 {
 	if (tsk_used_math(tsk)) {
-		if (tsk == current)
+		if (HAVE_HWFP && tsk == current)
 			unlazy_fpu(tsk);
 		return 0;
 	}
@@ -109,6 +114,15 @@ int init_fpu(struct task_struct *tsk)
 			return -ENOMEM;
 	}
 
+#ifdef CONFIG_X86_32
+	if (!HAVE_HWFP) {
+		memset(tsk->thread.xstate, 0, xstate_size);
+		finit();
+		set_stopped_child_used_math(tsk);
+		return 0;
+	}
+#endif
+
 	if (cpu_has_fxsr) {
 		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
 
@@ -330,13 +344,13 @@ int fpregs_get(struct task_struct *targe
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	if (!HAVE_HWFP)
-		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
-
 	ret = init_fpu(target);
 	if (ret)
 		return ret;
 
+	if (!HAVE_HWFP)
+		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
+
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 					   &target->thread.xstate->fsave, 0,
@@ -360,15 +374,15 @@ int fpregs_set(struct task_struct *targe
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	if (!HAVE_HWFP)
-		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
-
 	ret = init_fpu(target);
 	if (ret)
 		return ret;
 
 	set_stopped_child_used_math(target);
 
+	if (!HAVE_HWFP)
+		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
+
 	if (!cpu_has_fxsr) {
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 					  &target->thread.xstate->fsave, 0, -1);
@@ -474,18 +488,18 @@ static int restore_i387_fxsave(struct _f
 int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 {
 	int err;
+	struct task_struct *tsk = current;
 
-	if (HAVE_HWFP) {
-		struct task_struct *tsk = current;
-
+	if (HAVE_HWFP)
 		clear_fpu(tsk);
 
-		if (!used_math()) {
-			err = init_fpu(tsk);
-			if (err)
-				return err;
-		}
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
 
+	if (HAVE_HWFP) {
 		if (cpu_has_fxsr)
 			err = restore_i387_fxsave(buf);
 		else
diff -puN arch/x86/math-emu/fpu_entry.c~x86-fix-broken-math-emu-with-lazy-allocation-of-fpu-area arch/x86/math-emu/fpu_entry.c
--- a/arch/x86/math-emu/fpu_entry.c~x86-fix-broken-math-emu-with-lazy-allocation-of-fpu-area
+++ a/arch/x86/math-emu/fpu_entry.c
@@ -30,6 +30,7 @@
 #include <asm/uaccess.h>
 #include <asm/desc.h>
 #include <asm/user.h>
+#include <asm/i387.h>
 
 #include "fpu_system.h"
 #include "fpu_emu.h"
@@ -146,6 +147,13 @@ asmlinkage void math_emulate(long arg)
 	unsigned long code_limit = 0;	/* Initialized to stop compiler warnings */
 	struct desc_struct code_descriptor;
 
+	if (!used_math()) {
+		if (init_fpu(current)) {
+			do_group_exit(SIGKILL);
+			return;
+		}
+	}
+
 #ifdef RE_ENTRANT_CHECKING
 	if (emulating) {
 		printk("ERROR: wm-FPU-emu is not RE-ENTRANT!\n");
@@ -153,11 +161,6 @@ asmlinkage void math_emulate(long arg)
 	RE_ENTRANT_CHECK_ON;
 #endif /* RE_ENTRANT_CHECKING */
 
-	if (!used_math()) {
-		finit();
-		set_used_math();
-	}
