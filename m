From: akpm@linux-foundation.org
Subject: + sched-dynamically-update-the-root-domain-span-online-maps.patch added to -mm tree
Date: Tue, 18 Dec 2007 03:28:25 -0800
Message-ID: <200712181128.lBIBSPHG032552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbXLRL3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 06:29:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ghaskins@novell.com, ego@in.ibm.com, mingo@elte.hu


The patch titled
     sched: dynamically update the root-domain span/online maps
has been added to the -mm tree.  Its filename is
     sched-dynamically-update-the-root-domain-span-online-maps.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: dynamically update the root-domain span/online maps
From: Gregory Haskins <ghaskins@novell.com>

The baseline code statically builds the span maps when the domain is
formed.  Previous attempts at dynamically updating the maps caused a
suspend-to-ram regression, which should now be fixed.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff -puN kernel/sched.c~sched-dynamically-update-the-root-domain-span-online-maps kernel/sched.c
--- a/kernel/sched.c~sched-dynamically-update-the-root-domain-span-online-maps
+++ a/kernel/sched.c
@@ -359,8 +359,6 @@ struct rt_rq {
  * exclusive cpuset is created, we also create and attach a new root-domain
  * object.
  *
- * By default the system creates a single root-domain with all cpus as
- * members (mimicking the global state we have today).
  */
 struct root_domain {
 	atomic_t refcount;
@@ -375,6 +373,10 @@ struct root_domain {
 	atomic_t rto_count;
 };
 
+/*
+ * By default the system creates a single root-domain with all cpus as
+ * members (mimicking the global state we have today).
+ */
 static struct root_domain def_root_domain;
 
 #endif
@@ -5854,6 +5856,9 @@ static void rq_attach_root(struct rq *rq
 				class->leave_domain(rq);
 		}
 
+		cpu_clear(rq->cpu, old_rd->span);
+		cpu_clear(rq->cpu, old_rd->online);
+
 		if (atomic_dec_and_test(&old_rd->refcount))
 			kfree(old_rd);
 	}
@@ -5861,6 +5866,10 @@ static void rq_attach_root(struct rq *rq
 	atomic_inc(&rd->refcount);
 	rq->rd = rd;
 
+	cpu_set(rq->cpu, rd->span);
+	if (cpu_isset(rq->cpu, cpu_online_map))
+		cpu_set(rq->cpu, rd->online);
+
 	for (class = sched_class_highest; class; class = class->next) {
 		if (class->join_domain)
 			class->join_domain(rq);
@@ -5869,23 +5878,21 @@ static void rq_attach_root(struct rq *rq
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-static void init_rootdomain(struct root_domain *rd, const cpumask_t *map)
+static void init_rootdomain(struct root_domain *rd)
 {
 	memset(rd, 0, sizeof(*rd));
 
-	rd->span = *map;
-	cpus_and(rd->online, rd->span, cpu_online_map);
+	cpus_clear(rd->span);
+	cpus_clear(rd->online);
 }
 
 static void init_defrootdomain(void)
 {
-	cpumask_t cpus = CPU_MASK_ALL;
-
-	init_rootdomain(&def_root_domain, &cpus);
+	init_rootdomain(&def_root_domain);
 	atomic_set(&def_root_domain.refcount, 1);
 }
 
-static struct root_domain *alloc_rootdomain(const cpumask_t *map)
+static struct root_domain *alloc_rootdomain(void)
 {
 	struct root_domain *rd;
 
@@ -5893,7 +5900,7 @@ static struct root_domain *alloc_rootdom
 	if (!rd)
 		return NULL;
 
-	init_rootdomain(rd, map);
+	init_rootdomain(rd);
 
 	return rd;
 }
@@ -6314,7 +6321,7 @@ static int build_sched_domains(const cpu
 	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
 #endif
 
-	rd = alloc_rootdomain(cpu_map);
+	rd = alloc_rootdomain();
 	if (!rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
 		return -ENOMEM;
@@ -6886,7 +6893,6 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq_attach_root(rq, &def_root_domain);
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
 		rq->push_cpu = 0;
@@ -6895,6 +6901,7 @@ void __init sched_init(void)
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq->rt.highest_prio = MAX_RT_PRIO;
 		rq->rt.overloaded = 0;
+		rq_attach_root(rq, &def_root_domain);
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 
_

Patches currently in -mm which might be from ghaskins@novell.com are

git-kvm.patch
git-sched.patch
sched-dynamically-update-the-root-domain-span-online-maps.patch
