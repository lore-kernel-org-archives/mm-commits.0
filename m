From: akpm@linux-foundation.org
Subject: [merged]
 res_counter-remove-interface-for-locked-charging-and-uncharging.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:46:35 -0700
Message-ID: <5344602b.UZKA3h50vj6cmQPb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHUqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:46:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wujianguo@huawei.com, tj@kernel.org, thockin@google.com, riel@redhat.com, penberg@kernel.org, oleg@redhat.com, mhocko@suse.cz, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cl@linux.com, cl@linux-foundation.org, rientjes@google.com

Subject: [merged] res_counter-remove-interface-for-locked-charging-and-uncharging.patch removed from -mm tree
To: rientjes@google.com,cl@linux-foundation.org,cl@linux.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mgorman@suse.de,mhocko@suse.cz,oleg@redhat.com,penberg@kernel.org,riel@redhat.com,thockin@google.com,tj@kernel.org,wujianguo@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:46:35 -0700


The patch titled
     Subject: res_counter: remove interface for locked charging and uncharging
has been removed from the -mm tree.  Its filename was
     res_counter-remove-interface-for-locked-charging-and-uncharging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: res_counter: remove interface for locked charging and uncharging

The res_counter_{charge,uncharge}_locked() variants are not used in the
kernel outside of the resource counter code itself, so remove the
interface.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Tim Hockin <thockin@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/resource_counter.txt |   12 +--------
 include/linux/res_counter.h                |    6 ----
 kernel/res_counter.c                       |   23 +++++++++----------
 3 files changed, 15 insertions(+), 26 deletions(-)

diff -puN Documentation/cgroups/resource_counter.txt~res_counter-remove-interface-for-locked-charging-and-uncharging Documentation/cgroups/resource_counter.txt
--- a/Documentation/cgroups/resource_counter.txt~res_counter-remove-interface-for-locked-charging-and-uncharging
+++ a/Documentation/cgroups/resource_counter.txt
@@ -76,15 +76,7 @@ to work with it.
 	limit_fail_at parameter is set to the particular res_counter element
 	where the charging failed.
 
- d. int res_counter_charge_locked
-			(struct res_counter *rc, unsigned long val, bool force)
-
-	The same as res_counter_charge(), but it must not acquire/release the
-	res_counter->lock internally (it must be called with res_counter->lock
-	held). The force parameter indicates whether we can bypass the limit.
-
- e. u64 res_counter_uncharge[_locked]
-			(struct res_counter *rc, unsigned long val)
+ d. u64 res_counter_uncharge(struct res_counter *rc, unsigned long val)
 
 	When a resource is released (freed) it should be de-accounted
 	from the resource counter it was accounted to.  This is called
@@ -93,7 +85,7 @@ to work with it.
 
 	The _locked routines imply that the res_counter->lock is taken.
 
- f. u64 res_counter_uncharge_until
+ e. u64 res_counter_uncharge_until
 		(struct res_counter *rc, struct res_counter *top,
 		 unsigned long val)
 
diff -puN include/linux/res_counter.h~res_counter-remove-interface-for-locked-charging-and-uncharging include/linux/res_counter.h
--- a/include/linux/res_counter.h~res_counter-remove-interface-for-locked-charging-and-uncharging
+++ a/include/linux/res_counter.h
@@ -104,15 +104,13 @@ void res_counter_init(struct res_counter
  *       units, e.g. numbers, bytes, Kbytes, etc
  *
  * returns 0 on success and <0 if the counter->usage will exceed the
- * counter->limit _locked call expects the counter->lock to be taken
+ * counter->limit
  *
  * charge_nofail works the same, except that it charges the resource
  * counter unconditionally, and returns < 0 if the after the current
  * charge we are over limit.
  */
 
-int __must_check res_counter_charge_locked(struct res_counter *counter,
-					   unsigned long val, bool force);
 int __must_check res_counter_charge(struct res_counter *counter,
 		unsigned long val, struct res_counter **limit_fail_at);
 int res_counter_charge_nofail(struct res_counter *counter,
@@ -125,12 +123,10 @@ int res_counter_charge_nofail(struct res
  * @val: the amount of the resource
  *
  * these calls check for usage underflow and show a warning on the console
- * _locked call expects the counter->lock to be taken
  *
  * returns the total charges still present in @counter.
  */
 
-u64 res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
 u64 res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
 u64 res_counter_uncharge_until(struct res_counter *counter,
diff -puN kernel/res_counter.c~res_counter-remove-interface-for-locked-charging-and-uncharging kernel/res_counter.c
--- a/kernel/res_counter.c~res_counter-remove-interface-for-locked-charging-and-uncharging
+++ a/kernel/res_counter.c
@@ -22,8 +22,18 @@ void res_counter_init(struct res_counter
 	counter->parent = parent;
 }
 
-int res_counter_charge_locked(struct res_counter *counter, unsigned long val,
-			      bool force)
+static u64 res_counter_uncharge_locked(struct res_counter *counter,
+				       unsigned long val)
+{
+	if (WARN_ON(counter->usage < val))
+		val = counter->usage;
+
+	counter->usage -= val;
+	return counter->usage;
+}
+
+static int res_counter_charge_locked(struct res_counter *counter,
+				     unsigned long val, bool force)
 {
 	int ret = 0;
 
@@ -86,15 +96,6 @@ int res_counter_charge_nofail(struct res
 	return __res_counter_charge(counter, val, limit_fail_at, true);
 }
 
-u64 res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
-{
-	if (WARN_ON(counter->usage < val))
-		val = counter->usage;
-
-	counter->usage -= val;
-	return counter->usage;
-}
