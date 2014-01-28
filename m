From: akpm@linux-foundation.org
Subject: [merged] softirq-convert-printks-to-pr_level.patch removed from
 -mm tree
Date: Tue, 28 Jan 2014 11:09:51 -0800
Message-ID: <52e8007f.BdTs/Denoq8MN7h2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbaA1TJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, fweisbec@gmail.com, joe@perches.com

Subject: [merged] softirq-convert-printks-to-pr_level.patch removed from -mm tree
To: joe@perches.com,fweisbec@gmail.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:51 -0800


The patch titled
     Subject: softirq: convert printks to pr_<level>
has been removed from the -mm tree.  Its filename was
     softirq-convert-printks-to-pr_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: softirq: convert printks to pr_<level>

Use a more current logging style.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/softirq.c~softirq-convert-printks-to-pr_level kernel/softirq.c
--- a/kernel/softirq.c~softirq-convert-printks-to-pr_level
+++ a/kernel/softirq.c
@@ -8,6 +8,8 @@
  *	Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/export.h>
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
@@ -269,7 +271,7 @@ restart:
 		h->action(h);
 		trace_softirq_exit(vec_nr);
 		if (unlikely(prev_count != preempt_count())) {
-			printk(KERN_ERR "huh, entered softirq %u %s %p with preempt_count %08x, exited with %08x?\n",
+			pr_err("huh, entered softirq %u %s %p with preempt_count %08x, exited with %08x?\n",
 			       vec_nr, softirq_to_name[vec_nr], h->action,
 			       prev_count, preempt_count());
 			preempt_count_set(prev_count);
@@ -568,7 +570,7 @@ EXPORT_SYMBOL(tasklet_init);
 void tasklet_kill(struct tasklet_struct *t)
 {
 	if (in_interrupt())
-		printk("Attempt to kill tasklet from interrupt\n");
+		pr_notice("Attempt to kill tasklet from interrupt\n");
 
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
 		do {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
linux-next.patch

