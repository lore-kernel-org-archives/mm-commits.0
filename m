From: akpm@linux-foundation.org
Subject: + kernel-signalc-fix-suboptimal-printk-usage.patch added to -mm tree
Date: Tue, 19 Feb 2013 13:53:42 -0800
Message-ID: <20130219215342.ABD705A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:41915 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933545Ab3BSVxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 16:53:43 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so462765qah.4
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 13:53:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Valdis.Kletnieks@vt.edu, oleg@redhat.com, valdis.kletnieks@vt.edu


The patch titled
     From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
has been added to the -mm tree.  Its filename is
     kernel-signalc-fix-suboptimal-printk-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: kernel/signal.c - fix suboptimal printk usage

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

swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix-fix.patch
kernel-signalc-fix-suboptimal-printk-usage.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix.patch

