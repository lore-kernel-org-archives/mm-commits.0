From: akpm@linux-foundation.org
Subject: [merged] res_counter-return-amount-of-charges-after-res_counter_uncharge.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:28 -0800
Message-ID: <20121219204029.56D3B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43752 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2LSUkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:33 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so133988wgb.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: res_counter: return amount of charges after res_counter_uncharge()
has been removed from the -mm tree.  Its filename was
     res_counter-return-amount-of-charges-after-res_counter_uncharge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -125,14 +125,16 @@ int res_counter_charge_nofail(struct res
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

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

