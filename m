From: akpm@linux-foundation.org
Subject: + res_counter-return-amount-of-charges-after-res_counter_uncharge.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:03:28 -0700
Message-ID: <20121102000328.E37055C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51857 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab2KBADd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:03:33 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so63404wib.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:03:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: res_counter: return amount of charges after res_counter_uncharge()
has been added to the -mm tree.  Its filename is
     res_counter-return-amount-of-charges-after-res_counter_uncharge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: res_counter: return amount of charges after res_counter_uncharge()

It is useful to know how many charges are still left after a call to
res_counter_uncharge.  While it is possible to issue a res_counter_read
after uncharge, this can be racy.

If we need, for instance, to take some action when the counters drop down
to 0, only one of the callers should see it.  This is the same semantics
as the atomic variables in the kernel.

Since the current return value is void, we don't need to worry about
anything breaking due to this change: nobody relied on that, and only
users appearing from now on will be checking this value.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/resource_counter.txt |    7 +++---
 include/linux/res_counter.h                |   12 ++++++-----
 kernel/res_counter.c                       |   20 ++++++++++++-------
 3 files changed, 24 insertions(+), 15 deletions(-)

diff -puN Documentation/cgroups/resource_counter.txt~res_counter-return-amount-of-charges-after-res_counter_uncharge Documentation/cgroups/resource_counter.txt
--- a/Documentation/cgroups/resource_counter.txt~res_counter-return-amount-of-charges-after-res_counter_uncharge
+++ a/Documentation/cgroups/resource_counter.txt
@@ -83,16 +83,17 @@ to work with it.
 	res_counter->lock internally (it must be called with res_counter->lock
 	held). The force parameter indicates whether we can bypass the limit.
 
- e. void res_counter_uncharge[_locked]
+ e. u64 res_counter_uncharge[_locked]
 			(struct res_counter *rc, unsigned long val)
 
 	When a resource is released (freed) it should be de-accounted
 	from the resource counter it was accounted to.  This is called
-	"uncharging".
+	"uncharging". The return value of this function indicate the amount
+	of charges still present in the counter.
 
 	The _locked routines imply that the res_counter->lock is taken.
 
- f. void res_counter_uncharge_until
+ f. u64 res_counter_uncharge_until
 		(struct res_counter *rc, struct res_counter *top,
 		 unsinged long val)
 
diff -puN include/linux/res_counter.h~res_counter-return-amount-of-charges-after-res_counter_uncharge include/linux/res_counter.h
--- a/include/linux/res_counter.h~res_counter-return-amount-of-charges-after-res_counter_uncharge
+++ a/include/linux/res_counter.h
@@ -130,14 +130,16 @@ int res_counter_charge_nofail(struct res
  *
  * these calls check for usage underflow and show a warning on the console
  * _locked call expects the counter->lock to be taken
+ *
+ * returns the total charges still present in @counter.
  */
 
-void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
-void res_counter_uncharge(struct res_counter *counter, unsigned long val);
+u64 res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
+u64 res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
-void res_counter_uncharge_until(struct res_counter *counter,
-				struct res_counter *top,
-				unsigned long val);
+u64 res_counter_uncharge_until(struct res_counter *counter,
+			       struct res_counter *top,
+			       unsigned long val);
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff -puN kernel/res_counter.c~res_counter-return-amount-of-charges-after-res_counter_uncharge kernel/res_counter.c
--- a/kernel/res_counter.c~res_counter-return-amount-of-charges-after-res_counter_uncharge
+++ a/kernel/res_counter.c
@@ -86,33 +86,39 @@ int res_counter_charge_nofail(struct res
 	return __res_counter_charge(counter, val, limit_fail_at, true);
 }
 
-void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
+u64 res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
 {
 	if (WARN_ON(counter->usage < val))
 		val = counter->usage;
 
 	counter->usage -= val;
+	return counter->usage;
 }
 
-void res_counter_uncharge_until(struct res_counter *counter,
-				struct res_counter *top,
-				unsigned long val)
+u64 res_counter_uncharge_until(struct res_counter *counter,
+			       struct res_counter *top,
+			       unsigned long val)
 {
 	unsigned long flags;
 	struct res_counter *c;
+	u64 ret = 0;
 
 	local_irq_save(flags);
 	for (c = counter; c != top; c = c->parent) {
+		u64 r;
 		spin_lock(&c->lock);
-		res_counter_uncharge_locked(c, val);
+		r = res_counter_uncharge_locked(c, val);
+		if (c == counter)
+			ret = r;
 		spin_unlock(&c->lock);
 	}
 	local_irq_restore(flags);
+	return ret;
 }
 
-void res_counter_uncharge(struct res_counter *counter, unsigned long val)
+u64 res_counter_uncharge(struct res_counter *counter, unsigned long val)
 {
-	res_counter_uncharge_until(counter, NULL, val);
+	return res_counter_uncharge_until(counter, NULL, val);
 }
 
 static inline unsigned long long *
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

