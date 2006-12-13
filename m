From: akpm@osdl.org
Subject: - move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:53:18 -0800
Message-ID: <200612130653.kBD6rIip030517@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57497 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964997AbWLMGxW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:53:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@openvz.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     move_task_off_dead_cpu() should be called with disabled ints
has been removed from the -mm tree.  Its filename was
     move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: move_task_off_dead_cpu() should be called with disabled ints
From: Kirill Korotaev <dev@openvz.org>

move_task_off_dead_cpu() requires interrupts to be disabled, while
migrate_dead() calls it with enabled interrupts.  Added appropriate
comments to functions and added BUG_ON(!irqs_disabled()) into
double_rq_lock() and double_lock_balance() which are the origin sources of
such bugs.

Signed-off-by: Kirill Korotaev <dev@openvz.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~move_task_off_dead_cpu-should-be-called-with-disabled-ints kernel/sched.c
--- a/kernel/sched.c~move_task_off_dead_cpu-should-be-called-with-disabled-ints
+++ a/kernel/sched.c
@@ -1952,6 +1952,7 @@ static void double_rq_lock(struct rq *rq
 	__acquires(rq1->lock)
 	__acquires(rq2->lock)
 {
+	BUG_ON(!irqs_disabled());
 	if (rq1 == rq2) {
 		spin_lock(&rq1->lock);
 		__acquire(rq2->lock);	/* Fake it out ;) */
@@ -1991,6 +1992,11 @@ static void double_lock_balance(struct r
 	__acquires(busiest->lock)
 	__acquires(this_rq->lock)
 {
+	if (unlikely(!irqs_disabled())) {
+		/* printk() doesn't work good under rq->lock */
+		spin_unlock(&this_rq->lock);
+		BUG_ON(1);
+	}
 	if (unlikely(!spin_trylock(&busiest->lock))) {
 		if (busiest < this_rq) {
 			spin_unlock(&this_rq->lock);
@@ -5067,7 +5073,10 @@ wait_to_die:
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-/* Figure out where task on dead CPU should go, use force if neccessary. */
+/*
+ * Figure out where task on dead CPU should go, use force if neccessary.
+ * NOTE: interrupts should be disabled by the caller
+ */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	unsigned long flags;
@@ -5187,6 +5196,7 @@ void idle_task_exit(void)
 	mmdrop(mm);
 }
 
+/* called under rq->lock with disabled interrupts */
 static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
 {
 	struct rq *rq = cpu_rq(dead_cpu);
@@ -5203,10 +5213,11 @@ static void migrate_dead(unsigned int de
 	 * Drop lock around migration; if someone else moves it,
 	 * that's OK.  No task can be added to this CPU, so iteration is
 	 * fine.
+	 * NOTE: interrupts should be left disabled  --dev@
 	 */
-	spin_unlock_irq(&rq->lock);
+	spin_unlock(&rq->lock);
 	move_task_off_dead_cpu(dead_cpu, p);
-	spin_lock_irq(&rq->lock);
+	spin_lock(&rq->lock);
 
 	put_task_struct(p);
 }
_

Patches currently in -mm which might be from dev@openvz.org are

origin.patch

