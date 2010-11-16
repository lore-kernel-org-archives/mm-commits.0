From: akpm@linux-foundation.org
Subject: [merged] um-fix-ptrace-build-error.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:29:51 -0800
Message-ID: <201011161933.oAGJX30Q003067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756309Ab0KPTdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, jdike@addtoit.com, namhyung@gmail.com, will.newton@gmail.com, mm-commits@vger.kernel.org


The patch titled
     um: fix ptrace build error
has been removed from the -mm tree.  Its filename was
     um-fix-ptrace-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: fix ptrace build error
From: Richard Weinberger <richard@nod.at>

Both 0a3d763 ("ptrace: cleanup arch_ptrace() on um") and 9b05a69 ("ptrace:
change signature of arch_ptrace()") broke the um build.  This patch fixes
the issues.

0a3d763 introduced the undeclared variable "datavp".  The patch seems
completely untested.  :-(

9b05a69 changed arch_ptrace()'s signature but did not update
um/include/asm/ptrace-generic.h.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Tested-by: Will Newton <will.newton@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/ptrace-generic.h |    4 ++--
 arch/um/kernel/ptrace.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/include/asm/ptrace-generic.h~um-fix-ptrace-build-error arch/um/include/asm/ptrace-generic.h
--- a/arch/um/include/asm/ptrace-generic.h~um-fix-ptrace-build-error
+++ a/arch/um/include/asm/ptrace-generic.h
@@ -38,8 +38,8 @@ struct pt_regs {
 
 struct task_struct;
 
-extern long subarch_ptrace(struct task_struct *child, long request, long addr,
-			   long data);
+extern long subarch_ptrace(struct task_struct *child, long request,
+	unsigned long addr, unsigned long data);
 extern unsigned long getreg(struct task_struct *child, int regno);
 extern int putreg(struct task_struct *child, int regno, unsigned long value);
 extern int get_fpregs(struct user_i387_struct __user *buf,
diff -puN arch/um/kernel/ptrace.c~um-fix-ptrace-build-error arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~um-fix-ptrace-build-error
+++ a/arch/um/kernel/ptrace.c
@@ -122,7 +122,7 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
-		ret = ptrace_set_thread_area(child, addr, datavp);
+		ret = ptrace_set_thread_area(child, addr, vp);
 		break;
 
 	case PTRACE_FAULTINFO: {
_

Patches currently in -mm which might be from richard@nod.at are

um-mark-config_highmem-as-broken.patch

