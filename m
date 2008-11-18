From: akpm@linux-foundation.org
Subject: + memory-cgroup-resource-counters-for-hierarchy-v4.patch added to -mm tree
Date: Tue, 18 Nov 2008 15:30:54 -0800
Message-ID: <200811182330.mAINUtM7025772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbYKRXbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 18:31:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg: memory cgroup resource counters for hierarchy
has been added to the -mm tree.  Its filename is
     memory-cgroup-resource-counters-for-hierarchy-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: memory cgroup resource counters for hierarchy
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Add support for building hierarchies in resource counters.  Cgroups allows
us to build a deep hierarchy, but we currently don't link the resource
counters belonging to the memory controller control groups, in the same
fashion as the corresponding cgroup entries in the cgroup hierarchy.  This
patch provides the infrastructure for resource counters that have the same
hiearchy as their cgroup counter parts.

These set of patches are based on the resource counter hiearchy patches
posted by Pavel Emelianov.

NOTE: Building hiearchies is expensive, deeper hierarchies imply charging
the all the way up to the root.  It is known that hiearchies are
expensive, so the user needs to be careful and aware of the trade-offs
before creating very deep ones.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    8 ++++--
 kernel/res_counter.c        |   42 +++++++++++++++++++++++++++-------
 mm/memcontrol.c             |   20 ++++++++++------
 3 files changed, 53 insertions(+), 17 deletions(-)

diff -puN include/linux/res_counter.h~memory-cgroup-resource-counters-for-hierarchy-v4 include/linux/res_counter.h
--- a/include/linux/res_counter.h~memory-cgroup-resource-counters-for-hierarchy-v4
+++ a/include/linux/res_counter.h
@@ -43,6 +43,10 @@ struct res_counter {
 	 * the routines below consider this to be IRQ-safe
 	 */
 	spinlock_t lock;
+	/*
+	 * Parent counter, used for hierarchial resource accounting
+	 */
+	struct res_counter *parent;
 };
 
 /**
@@ -87,7 +91,7 @@ enum {
  * helpers for accounting
  */
 
-void res_counter_init(struct res_counter *counter);
+void res_counter_init(struct res_counter *counter, struct res_counter *parent);
 
 /*
  * charge - try to consume more resource.
@@ -103,7 +107,7 @@ void res_counter_init(struct res_counter
 int __must_check res_counter_charge_locked(struct res_counter *counter,
 		unsigned long val);
 int __must_check res_counter_charge(struct res_counter *counter,
-		unsigned long val);
+		unsigned long val, struct res_counter **limit_fail_at);
 
 /*
  * uncharge - tell that some portion of the resource is released
diff -puN kernel/res_counter.c~memory-cgroup-resource-counters-for-hierarchy-v4 kernel/res_counter.c
--- a/kernel/res_counter.c~memory-cgroup-resource-counters-for-hierarchy-v4
+++ a/kernel/res_counter.c
@@ -15,10 +15,11 @@
 #include <linux/uaccess.h>
 #include <linux/mm.h>
 
-void res_counter_init(struct res_counter *counter)
+void res_counter_init(struct res_counter *counter, struct res_counter *parent)
 {
 	spin_lock_init(&counter->lock);
 	counter->limit = (unsigned long long)LLONG_MAX;
+	counter->parent = parent;
 }
 
 int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
@@ -34,14 +35,34 @@ int res_counter_charge_locked(struct res
 	return 0;
 }
 
-int res_counter_charge(struct res_counter *counter, unsigned long val)
+int res_counter_charge(struct res_counter *counter, unsigned long val,
+			struct res_counter **limit_fail_at)
 {
 	int ret;
 	unsigned long flags;
+	struct res_counter *c, *u;
 
-	spin_lock_irqsave(&counter->lock, flags);
-	ret = res_counter_charge_locked(counter, val);
-	spin_unlock_irqrestore(&counter->lock, flags);
+	*limit_fail_at = NULL;
+	local_irq_save(flags);
+	for (c = counter; c != NULL; c = c->parent) {
+		spin_lock(&c->lock);
+		ret = res_counter_charge_locked(c, val);
+		spin_unlock(&c->lock);
+		if (ret < 0) {
+			*limit_fail_at = c;
+			goto undo;
+		}
+	}
+	ret = 0;
+	goto done;
+undo:
+	for (u = counter; u != c; u = u->parent) {
+		spin_lock(&u->lock);
+		res_counter_uncharge_locked(u, val);
+		spin_unlock(&u->lock);
+	}
+done:
+	local_irq_restore(flags);
 	return ret;
 }
 
@@ -56,10 +77,15 @@ void res_counter_uncharge_locked(struct 
 void res_counter_uncharge(struct res_counter *counter, unsigned long val)
 {
 	unsigned long flags;
+	struct res_counter *c;
 
-	spin_lock_irqsave(&counter->lock, flags);
-	res_counter_uncharge_locked(counter, val);
-	spin_unlock_irqrestore(&counter->lock, flags);
+	local_irq_save(flags);
+	for (c = counter; c != NULL; c = c->parent) {
+		spin_lock(&c->lock);
+		res_counter_uncharge_locked(c, val);
+		spin_unlock(&c->lock);
+	}
+	local_irq_restore(flags);
 }
 
 
diff -puN mm/memcontrol.c~memory-cgroup-resource-counters-for-hierarchy-v4 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-resource-counters-for-hierarchy-v4
+++ a/mm/memcontrol.c
@@ -471,6 +471,7 @@ static int __mem_cgroup_try_charge(struc
 {
 	struct mem_cgroup *mem;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	struct res_counter *fail_res;
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
@@ -499,11 +500,12 @@ static int __mem_cgroup_try_charge(struc
 		int ret;
 		bool noswap = false;
 
-		ret = res_counter_charge(&mem->res, PAGE_SIZE);
+		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res);
 		if (likely(!ret)) {
 			if (!do_swap_account)
 				break;
-			ret = res_counter_charge(&mem->memsw, PAGE_SIZE);
+			ret = res_counter_charge(&mem->memsw, PAGE_SIZE,
+							&fail_res);
 			if (likely(!ret))
 				break;
 			/* mem+swap counter fails */
@@ -1699,22 +1701,26 @@ static void __init enable_swap_cgroup(vo
 static struct cgroup_subsys_state *
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem, *parent;
 	int node;
 
 	mem = mem_cgroup_alloc();
 	if (!mem)
 		return ERR_PTR(-ENOMEM);
 
-	res_counter_init(&mem->res);
-	res_counter_init(&mem->memsw);
-
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
 			goto free_out;
 	/* root ? */
-	if (cont->parent == NULL)
+	if (cont->parent == NULL) {
 		enable_swap_cgroup();
+		parent = NULL;
+	} else
+		parent = mem_cgroup_from_cont(cont->parent);
+
+ 	res_counter_init(&mem->res, parent ? &parent->res : NULL);
+	res_counter_init(&mem->memsw, parent ? &parent->memsw : NULL);
+
 
 	return &mem->css;
 free_out:
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchy-feature-selector-v4.patch

