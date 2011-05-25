From: akpm@linux-foundation.org
Subject: [merged] um-print-info-about-fatal-segfaults.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:04 -0700
Message-ID: <201105252029.p4PKTRb2014841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097Ab1EYUpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: print info about fatal segfaults
has been removed from the -mm tree.  Its filename was
     um-print-info-about-fatal-segfaults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: print info about fatal segfaults
From: Richard Weinberger <richard@nod.at>

Print a short info about fatal segfaults like other archs do.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/trap.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN arch/um/kernel/trap.c~um-print-info-about-fatal-segfaults arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~um-print-info-about-fatal-segfaults
+++ a/arch/um/kernel/trap.c
@@ -113,6 +113,27 @@ out_of_memory:
 	return 0;
 }
 
+static void show_segv_info(struct uml_pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+	struct faultinfo *fi = UPT_FAULTINFO(regs);
+
+	if (!unhandled_signal(tsk, SIGSEGV))
+		return;
+
+	if (!printk_ratelimit())
+		return;
+
+	printk("%s%s[%d]: segfault at %lx ip %p sp %p error %x",
+		task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
+		tsk->comm, task_pid_nr(tsk), FAULT_ADDRESS(*fi),
+		(void *)UPT_IP(regs), (void *)UPT_SP(regs),
+		fi->error_code);
+
+	print_vma_addr(KERN_CONT " in ", UPT_IP(regs));
+	printk(KERN_CONT "\n");
+}
+
 static void bad_segv(struct faultinfo fi, unsigned long ip)
 {
 	struct siginfo si;
@@ -141,6 +162,7 @@ void segv_handler(int sig, struct uml_pt
 	struct faultinfo * fi = UPT_FAULTINFO(regs);
 
 	if (UPT_IS_USER(regs) && !SEGV_IS_FIXABLE(fi)) {
+		show_segv_info(regs);
 		bad_segv(*fi, UPT_IP(regs));
 		return;
 	}
@@ -202,6 +224,8 @@ unsigned long segv(struct faultinfo fi, 
 		      address, ip);
 	}
 
+	show_segv_info(regs);
+
 	if (err == -EACCES) {
 		si.si_signo = SIGBUS;
 		si.si_errno = 0;
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch

