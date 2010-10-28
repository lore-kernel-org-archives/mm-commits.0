From: akpm@linux-foundation.org
Subject: + um-fix-ptrace-build-error.patch added to -mm tree
Date: Thu, 28 Oct 2010 12:51:40 -0700
Message-ID: <201010281951.o9SJpepj017731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496Ab0J1Txw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Oct 2010 15:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, jdike@addtoit.com, namhyung@gmail.com


The patch titled
     um: fix ptrace build error
has been added to the -mm tree.  Its filename is
     um-fix-ptrace-build-error.patch

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

origin.patch
um-fix-ptrace-build-error.patch
linux-next.patch

