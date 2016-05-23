From: akpm@linux-foundation.org
Subject: [patch 35/84] kernel/signal.c: convert printk(KERN_<LEVEL> ...)
 to pr_<level>(...)
Date: Mon, 23 May 2016 16:23:59 -0700
Message-ID: <5743910f.UnshMZIeTNbL+zsH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbcEWXYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, wangxq10@lzu.edu.cn

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
