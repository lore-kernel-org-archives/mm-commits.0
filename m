From: akpm@linux-foundation.org
Subject: - hrtimer-reduce-calls-to-hrtimer_get_softirq_time.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:36 -0700
Message-ID: <200804261640.m3QGea3o031048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756234AbYDZQlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sivanich@sgi.com, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimer: reduce calls to hrtimer_get_softirq_time()
has been removed from the -mm tree.  Its filename was
     hrtimer-reduce-calls-to-hrtimer_get_softirq_time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimer: reduce calls to hrtimer_get_softirq_time()
From: Dimitri Sivanich <sivanich@sgi.com>

It seems that hrtimer_run_queues() is calling hrtimer_get_softirq_time() more
often than it needs to.  This can cause frequent contention on systems with
large numbers of processors/cores.

With this patch, hrtimer_run_queues only calls hrtimer_get_softirq_time() if
there is a pending timer in one of the hrtimer bases, and only once.

This also combines hrtimer_run_queues() and the inline run_hrtimer_queue()
into one function.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |   65 ++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff -puN kernel/hrtimer.c~hrtimer-reduce-calls-to-hrtimer_get_softirq_time kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-reduce-calls-to-hrtimer_get_softirq_time
+++ a/kernel/hrtimer.c
@@ -1238,51 +1238,52 @@ void hrtimer_run_pending(void)
 /*
  * Called from hardirq context every jiffy
  */
-static inline void run_hrtimer_queue(struct hrtimer_cpu_base *cpu_base,
-				     int index)
+void hrtimer_run_queues(void)
 {
 	struct rb_node *node;
-	struct hrtimer_clock_base *base = &cpu_base->clock_base[index];
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_clock_base *base;
+	int index;
+	int gst = 1;
 
-	if (!base->first)
+	if (hrtimer_hres_active())
 		return;
 
-	if (base->get_softirq_time)
-		base->softirq_time = base->get_softirq_time();
+	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
+		base = &cpu_base->clock_base[index];
 
-	spin_lock(&cpu_base->lock);
-
-	while ((node = base->first)) {
-		struct hrtimer *timer;
-
-		timer = rb_entry(node, struct hrtimer, node);
-		if (base->softirq_time.tv64 <= timer->expires.tv64)
-			break;
-
-		if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
-			__remove_hrtimer(timer, base, HRTIMER_STATE_PENDING, 0);
-			list_add_tail(&timer->cb_entry,
-					&base->cpu_base->cb_pending);
+		if (!base->first)
 			continue;
+
+		if (gst) {
+			hrtimer_get_softirq_time(cpu_base);
+			gst = 0;
 		}
 
-		__run_hrtimer(timer);
-	}
-	spin_unlock(&cpu_base->lock);
-}
+		if (base->get_softirq_time)
+			base->softirq_time = base->get_softirq_time();
 
-void hrtimer_run_queues(void)
-{
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	int i;
+		spin_lock(&cpu_base->lock);
 
-	if (hrtimer_hres_active())
-		return;
+		while ((node = base->first)) {
+			struct hrtimer *timer;
 
-	hrtimer_get_softirq_time(cpu_base);
+			timer = rb_entry(node, struct hrtimer, node);
+			if (base->softirq_time.tv64 <= timer->expires.tv64)
+				break;
+
+			if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
+				__remove_hrtimer(timer, base,
+					HRTIMER_STATE_PENDING, 0);
+				list_add_tail(&timer->cb_entry,
+					&base->cpu_base->cb_pending);
+				continue;
+			}
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
-		run_hrtimer_queue(cpu_base, i);
+			__run_hrtimer(timer);
+		}
+		spin_unlock(&cpu_base->lock);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from sivanich@sgi.com are

origin.patch
git-hrt.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch

