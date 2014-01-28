From: akpm@linux-foundation.org
Subject: [merged] softirq-use-ffs-in-__do_softirq.patch removed from -mm
 tree
Date: Tue, 28 Jan 2014 11:09:49 -0800
Message-ID: <52e8007d.5WDpAKGoWEfPbs0y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbaA1TJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, fweisbec@gmail.com, joe@perches.com

Subject: [merged] softirq-use-ffs-in-__do_softirq.patch removed from -mm tree
To: joe@perches.com,fweisbec@gmail.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:49 -0800


The patch titled
     Subject: softirq: use ffs() in __do_softirq()
has been removed from the -mm tree.  Its filename was
     softirq-use-ffs-in-__do_softirq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: softirq: use ffs() in __do_softirq()

Possible speed improvement of __do_softirq() by using ffs() instead of
using a while loop with an & 1 test then single bit shift.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff -puN kernel/softirq.c~softirq-use-ffs-in-__do_softirq kernel/softirq.c
--- a/kernel/softirq.c~softirq-use-ffs-in-__do_softirq
+++ a/kernel/softirq.c
@@ -229,6 +229,7 @@ asmlinkage void __do_softirq(void)
 	struct softirq_action *h;
 	bool in_hardirq;
 	__u32 pending;
+	int softirq_bit;
 	int cpu;
 
 	/*
@@ -253,30 +254,30 @@ restart:
 
 	h = softirq_vec;
 
-	do {
-		if (pending & 1) {
-			unsigned int vec_nr = h - softirq_vec;
-			int prev_count = preempt_count();
-
-			kstat_incr_softirqs_this_cpu(vec_nr);
-
-			trace_softirq_entry(vec_nr);
-			h->action(h);
-			trace_softirq_exit(vec_nr);
-			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered softirq %u %s %p"
-				       "with preempt_count %08x,"
-				       " exited with %08x?\n", vec_nr,
-				       softirq_to_name[vec_nr], h->action,
-				       prev_count, preempt_count());
-				preempt_count_set(prev_count);
-			}
-
-			rcu_bh_qs(cpu);
+	while ((softirq_bit = ffs(pending))) {
+		unsigned int vec_nr;
+		int prev_count;
+
+		h += softirq_bit - 1;
+
+		vec_nr = h - softirq_vec;
+		prev_count = preempt_count();
+
+		kstat_incr_softirqs_this_cpu(vec_nr);
+
+		trace_softirq_entry(vec_nr);
+		h->action(h);
+		trace_softirq_exit(vec_nr);
+		if (unlikely(prev_count != preempt_count())) {
+			printk(KERN_ERR "huh, entered softirq %u %s %p with preempt_count %08x, exited with %08x?\n",
+			       vec_nr, softirq_to_name[vec_nr], h->action,
+			       prev_count, preempt_count());
+			preempt_count_set(prev_count);
 		}
+		rcu_bh_qs(cpu);
 		h++;
-		pending >>= 1;
-	} while (pending);
+		pending >>= softirq_bit;
+	}
 
 	local_irq_disable();
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
linux-next.patch

