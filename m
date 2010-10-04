From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-sparc.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:42:13 -0700
Message-ID: <201010042342.o94NgDHB022784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757380Ab0JDXxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, davem@davemloft.net


The patch titled
     ptrace: cleanup arch_ptrace() on sparc
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-sparc.patch

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
Subject: ptrace: cleanup arch_ptrace() on sparc
From: Namhyung Kim <namhyung@gmail.com>

Factor out struct fps and remove redundant castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/ptrace_32.c |   54 +++++++++++---------------------
 arch/sparc/kernel/ptrace_64.c |    8 ++--
 2 files changed, 24 insertions(+), 38 deletions(-)

diff -puN arch/sparc/kernel/ptrace_32.c~ptrace-cleanup-arch_ptrace-on-sparc arch/sparc/kernel/ptrace_32.c
--- a/arch/sparc/kernel/ptrace_32.c~ptrace-cleanup-arch_ptrace-on-sparc
+++ a/arch/sparc/kernel/ptrace_32.c
@@ -323,19 +323,35 @@ const struct user_regset_view *task_user
 	return &user_sparc32_view;
 }
 
+struct fps {
+	unsigned long regs[32];
+	unsigned long fsr;
+	unsigned long flags;
+	unsigned long extra;
+	unsigned long fpqd;
+	struct fq {
+		unsigned long *insnaddr;
+		unsigned long insn;
+	} fpq[16];
+};
+
 long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	unsigned long addr2 = current->thread.kregs->u_regs[UREG_I4];
+	void __user *addr2p;
 	const struct user_regset_view *view;
+	struct pt_regs __user *pregs;
+	struct fps __user *fps;
 	int ret;
 
 	view = task_user_regset_view(current);
+	addr2p = (void __user *) addr2;
+	pregs = (struct pt_regs __user *) addr;
+	fps = (struct fps __user *) addr;
 
 	switch(request) {
 	case PTRACE_GETREGS: {
-		struct pt_regs __user *pregs = (struct pt_regs __user *) addr;
-
 		ret = copy_regset_to_user(child, view, REGSET_GENERAL,
 					  32 * sizeof(u32),
 					  4 * sizeof(u32),
@@ -349,8 +365,6 @@ long arch_ptrace(struct task_struct *chi
 	}
 
 	case PTRACE_SETREGS: {
-		struct pt_regs __user *pregs = (struct pt_regs __user *) addr;
-
 		ret = copy_regset_from_user(child, view, REGSET_GENERAL,
 					    32 * sizeof(u32),
 					    4 * sizeof(u32),
@@ -364,19 +378,6 @@ long arch_ptrace(struct task_struct *chi
 	}
 
 	case PTRACE_GETFPREGS: {
-		struct fps {
-			unsigned long regs[32];
-			unsigned long fsr;
-			unsigned long flags;
-			unsigned long extra;
-			unsigned long fpqd;
-			struct fq {
-				unsigned long *insnaddr;
-				unsigned long insn;
-			} fpq[16];
-		};
-		struct fps __user *fps = (struct fps __user *) addr;
-
 		ret = copy_regset_to_user(child, view, REGSET_FP,
 					  0 * sizeof(u32),
 					  32 * sizeof(u32),
@@ -398,19 +399,6 @@ long arch_ptrace(struct task_struct *chi
 	}
 
 	case PTRACE_SETFPREGS: {
-		struct fps {
-			unsigned long regs[32];
-			unsigned long fsr;
-			unsigned long flags;
-			unsigned long extra;
-			unsigned long fpqd;
-			struct fq {
-				unsigned long *insnaddr;
-				unsigned long insn;
-			} fpq[16];
-		};
-		struct fps __user *fps = (struct fps __user *) addr;
-
 		ret = copy_regset_from_user(child, view, REGSET_FP,
 					    0 * sizeof(u32),
 					    32 * sizeof(u32),
@@ -425,8 +413,7 @@ long arch_ptrace(struct task_struct *chi
 
 	case PTRACE_READTEXT:
 	case PTRACE_READDATA:
-		ret = ptrace_readdata(child, addr,
-				      (void __user *) addr2, data);
+		ret = ptrace_readdata(child, addr, addr2p, data);
 
 		if (ret == data)
 			ret = 0;
@@ -436,8 +423,7 @@ long arch_ptrace(struct task_struct *chi
 
 	case PTRACE_WRITETEXT:
 	case PTRACE_WRITEDATA:
-		ret = ptrace_writedata(child, (void __user *) addr2,
-				       addr, data);
+		ret = ptrace_writedata(child, addr2p, addr, data);
 
 		if (ret == data)
 			ret = 0;
diff -puN arch/sparc/kernel/ptrace_64.c~ptrace-cleanup-arch_ptrace-on-sparc arch/sparc/kernel/ptrace_64.c
--- a/arch/sparc/kernel/ptrace_64.c~ptrace-cleanup-arch_ptrace-on-sparc
+++ a/arch/sparc/kernel/ptrace_64.c
@@ -976,10 +976,12 @@ long arch_ptrace(struct task_struct *chi
 	unsigned long addr2 = task_pt_regs(current)->u_regs[UREG_I4];
 	struct pt_regs __user *pregs;
 	struct fps __user *fps;
+	void __user *addr2p;
 	int ret;
 
 	pregs = (struct pt_regs __user *) addr;
 	fps = (struct fps __user *) addr;
+	addr2p = (void __user *) addr2;
 
 	switch (request) {
 	case PTRACE_PEEKUSR:
@@ -1030,8 +1032,7 @@ long arch_ptrace(struct task_struct *chi
 
 	case PTRACE_READTEXT:
 	case PTRACE_READDATA:
-		ret = ptrace_readdata(child, addr,
-				      (char __user *)addr2, data);
+		ret = ptrace_readdata(child, addr, addr2p, data);
 		if (ret == data)
 			ret = 0;
 		else if (ret >= 0)
@@ -1040,8 +1041,7 @@ long arch_ptrace(struct task_struct *chi
 
 	case PTRACE_WRITETEXT:
 	case PTRACE_WRITEDATA:
-		ret = ptrace_writedata(child, (char __user *) addr2,
-				       addr, data);
+		ret = ptrace_writedata(child, addr2p, addr, data);
 		if (ret == data)
 			ret = 0;
 		else if (ret >= 0)
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

