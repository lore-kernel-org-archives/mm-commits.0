From: akpm@linux-foundation.org
Subject: - uml-remove-unused-sigcontext-accessors.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:01 -0800
Message-ID: <200802250045.m1P0j1Om006150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbYBYAsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, olsajiri@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove unused sigcontext accessors
has been removed from the -mm tree.  Its filename was
     uml-remove-unused-sigcontext-accessors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove unused sigcontext accessors
From: Jeff Dike <jdike@addtoit.com>

The macros which extract registers from a struct sigcontext are no longer
needed and can be removed.  They are starting not to build anyway, given the
removal of the 'e' and 'r' from register names during the x86 merge.

Cc: Jiri Olsa <olsajiri@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/user-offsets.c   |   27 ---------------------------
 arch/um/sys-x86_64/user-offsets.c |   28 ----------------------------
 2 files changed, 55 deletions(-)

diff -puN arch/um/sys-i386/user-offsets.c~uml-remove-unused-sigcontext-accessors arch/um/sys-i386/user-offsets.c
--- a/arch/um/sys-i386/user-offsets.c~uml-remove-unused-sigcontext-accessors
+++ a/arch/um/sys-i386/user-offsets.c
@@ -17,36 +17,9 @@
 
 void foo(void)
 {
-	OFFSET(HOST_SC_IP, sigcontext, eip);
-	OFFSET(HOST_SC_SP, sigcontext, esp);
-	OFFSET(HOST_SC_FS, sigcontext, fs);
-	OFFSET(HOST_SC_GS, sigcontext, gs);
-	OFFSET(HOST_SC_DS, sigcontext, ds);
-	OFFSET(HOST_SC_ES, sigcontext, es);
-	OFFSET(HOST_SC_SS, sigcontext, ss);
-	OFFSET(HOST_SC_CS, sigcontext, cs);
-	OFFSET(HOST_SC_EFLAGS, sigcontext, eflags);
-	OFFSET(HOST_SC_EAX, sigcontext, eax);
-	OFFSET(HOST_SC_EBX, sigcontext, ebx);
-	OFFSET(HOST_SC_ECX, sigcontext, ecx);
-	OFFSET(HOST_SC_EDX, sigcontext, edx);
-	OFFSET(HOST_SC_EDI, sigcontext, edi);
-	OFFSET(HOST_SC_ESI, sigcontext, esi);
-	OFFSET(HOST_SC_EBP, sigcontext, ebp);
 	OFFSET(HOST_SC_TRAPNO, sigcontext, trapno);
 	OFFSET(HOST_SC_ERR, sigcontext, err);
 	OFFSET(HOST_SC_CR2, sigcontext, cr2);
-	OFFSET(HOST_SC_FPSTATE, sigcontext, fpstate);
-	OFFSET(HOST_SC_SIGMASK, sigcontext, oldmask);
-	OFFSET(HOST_SC_FP_CW, _fpstate, cw);
-	OFFSET(HOST_SC_FP_SW, _fpstate, sw);
-	OFFSET(HOST_SC_FP_TAG, _fpstate, tag);
-	OFFSET(HOST_SC_FP_IPOFF, _fpstate, ipoff);
-	OFFSET(HOST_SC_FP_CSSEL, _fpstate, cssel);
-	OFFSET(HOST_SC_FP_DATAOFF, _fpstate, dataoff);
-	OFFSET(HOST_SC_FP_DATASEL, _fpstate, datasel);
-	OFFSET(HOST_SC_FP_ST, _fpstate, _st);
-	OFFSET(HOST_SC_FXSR_ENV, _fpstate, _fxsr_env);
 
 	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
 	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fpxregs_struct));
diff -puN arch/um/sys-x86_64/user-offsets.c~uml-remove-unused-sigcontext-accessors arch/um/sys-x86_64/user-offsets.c
--- a/arch/um/sys-x86_64/user-offsets.c~uml-remove-unused-sigcontext-accessors
+++ a/arch/um/sys-x86_64/user-offsets.c
@@ -19,37 +19,9 @@
 
 void foo(void)
 {
-	OFFSET(HOST_SC_RBX, sigcontext, rbx);
-	OFFSET(HOST_SC_RCX, sigcontext, rcx);
-	OFFSET(HOST_SC_RDX, sigcontext, rdx);
-	OFFSET(HOST_SC_RSI, sigcontext, rsi);
-	OFFSET(HOST_SC_RDI, sigcontext, rdi);
-	OFFSET(HOST_SC_RBP, sigcontext, rbp);
-	OFFSET(HOST_SC_RAX, sigcontext, rax);
-	OFFSET(HOST_SC_R8, sigcontext, r8);
-	OFFSET(HOST_SC_R9, sigcontext, r9);
-	OFFSET(HOST_SC_R10, sigcontext, r10);
-	OFFSET(HOST_SC_R11, sigcontext, r11);
-	OFFSET(HOST_SC_R12, sigcontext, r12);
-	OFFSET(HOST_SC_R13, sigcontext, r13);
-	OFFSET(HOST_SC_R14, sigcontext, r14);
-	OFFSET(HOST_SC_R15, sigcontext, r15);
-	OFFSET(HOST_SC_IP, sigcontext, rip);
-	OFFSET(HOST_SC_SP, sigcontext, rsp);
 	OFFSET(HOST_SC_CR2, sigcontext, cr2);
 	OFFSET(HOST_SC_ERR, sigcontext, err);
 	OFFSET(HOST_SC_TRAPNO, sigcontext, trapno);
-	OFFSET(HOST_SC_CS, sigcontext, cs);
-	OFFSET(HOST_SC_FS, sigcontext, fs);
-	OFFSET(HOST_SC_GS, sigcontext, gs);
-	OFFSET(HOST_SC_EFLAGS, sigcontext, eflags);
-	OFFSET(HOST_SC_SIGMASK, sigcontext, oldmask);
-#if 0
-	OFFSET(HOST_SC_ORIG_RAX, sigcontext, orig_rax);
-	OFFSET(HOST_SC_DS, sigcontext, ds);
-	OFFSET(HOST_SC_ES, sigcontext, es);
-	OFFSET(HOST_SC_SS, sigcontext, ss);
-#endif
 
 	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
 	DEFINE(HOST_XFP_SIZE, 0);
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
arch-um-kernel-um_archc-some-small-improvements.patch
random-add-async-notification-support-to-dev-random.patch
asm-futexh-should-include-linux-uaccessh.patch
