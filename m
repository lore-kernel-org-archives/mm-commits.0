From: akpm@linux-foundation.org
Subject: + kernel-signalc-convert-printkkern_level-to-pr_level.patch added to -mm tree
Date: Fri, 22 Apr 2016 14:02:19 -0700
Message-ID: <571a915b.7ED7n5r2KBfsOHPY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbcDVVCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:02:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: convert printk(KERN_<LEVEL> ...) to pr_<level>(...)
has been added to the -mm tree.  Its filename is
     kernel-signalc-convert-printkkern_level-to-pr_level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-signalc-convert-printkkern_level-to-pr_level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-signalc-convert-printkkern_level-to-pr_level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Subject: kernel/signal.c: convert printk(KERN_<LEVEL> ...) to pr_<level>(...)

Use pr_<level> instead of printk(KERN_<LEVEL> ).

Signed-off-by: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/signal.c~kernel-signalc-convert-printkkern_level-to-pr_level kernel/signal.c
--- a/kernel/signal.c~kernel-signalc-convert-printkkern_level-to-pr_level
+++ a/kernel/signal.c
@@ -224,7 +224,7 @@ static inline void print_dropped_signal(
 	if (!__ratelimit(&ratelimit_state))
 		return;
 
-	printk(KERN_INFO "%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
+	pr_info("%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
 				current->comm, current->pid, sig);
 }
 
@@ -1089,10 +1089,10 @@ static int send_signal(int sig, struct s
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
-	printk(KERN_INFO "potentially unexpected fatal signal %d.\n", signr);
+	pr_info("potentially unexpected fatal signal %d.\n", signr);
 
 #if defined(__i386__) && !defined(__arch_um__)
-	printk(KERN_INFO "code at %08lx: ", regs->ip);
+	pr_info("code at %08lx: ", regs->ip);
 	{
 		int i;
 		for (i = 0; i < 16; i++) {
@@ -1100,10 +1100,10 @@ static void print_fatal_signal(int signr
 
 			if (get_user(insn, (unsigned char *)(regs->ip + i)))
 				break;
-			printk(KERN_CONT "%02x ", insn);
+			pr_cont("%02x ", insn);
 		}
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 #endif
 	preempt_disable();
 	show_regs(regs);
_

Patches currently in -mm which might be from wangxq10@lzu.edu.cn are

kernel-signalc-convert-printkkern_level-to-pr_level.patch

