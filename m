From: akpm@linux-foundation.org
Subject: [merged] kernel-signalc-fix-suboptimal-printk-usage.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:37 -0800
Message-ID: <20130228201137.AEA1831C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59099 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:38 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so39726qcs.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Valdis.Kletnieks@vt.edu, oleg@redhat.com, valdis.kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: fix suboptimal printk usage
has been removed from the -mm tree.  Its filename was
     kernel-signalc-fix-suboptimal-printk-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: kernel/signal.c: fix suboptimal printk usage

Several printk's were missing KERN_INFO and KERN_CONT flags.
In addition, a printk that was outside a #if/#endif should have
been inside, which would result in stray blank line on non-x86 boxes.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/signal.c~kernel-signalc-fix-suboptimal-printk-usage kernel/signal.c
--- a/kernel/signal.c~kernel-signalc-fix-suboptimal-printk-usage
+++ a/kernel/signal.c
@@ -1157,11 +1157,11 @@ static int send_signal(int sig, struct s
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
-	printk("%s/%d: potentially unexpected fatal signal %d.\n",
+	printk(KERN_INFO "%s/%d: potentially unexpected fatal signal %d.\n",
 		current->comm, task_pid_nr(current), signr);
 
 #if defined(__i386__) && !defined(__arch_um__)
-	printk("code at %08lx: ", regs->ip);
+	printk(KERN_INFO "code at %08lx: ", regs->ip);
 	{
 		int i;
 		for (i = 0; i < 16; i++) {
@@ -1169,11 +1169,11 @@ static void print_fatal_signal(int signr
 
 			if (get_user(insn, (unsigned char *)(regs->ip + i)))
 				break;
-			printk("%02x ", insn);
+			printk(KERN_CONT "%02x ", insn);
 		}
 	}
+	printk(KERN_CONT "\n");
 #endif
-	printk("\n");
 	preempt_disable();
 	show_regs(regs);
 	preempt_enable();
_

Patches currently in -mm which might be from Valdis.Kletnieks@vt.edu are

origin.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix.patch

