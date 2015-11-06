From: akpm@linux-foundation.org
Subject: [merged]
 memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:24 -0800
Message-ID: <563d087c.GAv49UcPgIfKBMBL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965940AbbKFUHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: collect kmem bypass conditions into __memcg_kmem_bypass()
has been removed from the -mm tree.  Its filename was
     memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memcg: collect kmem bypass conditions into __memcg_kmem_bypass()

memcg_kmem_newpage_charge() and memcg_kmem_get_cache() are testing the
same series of conditions to decide whether to bypass kmem accounting. 
Collect the tests into __memcg_kmem_bypass().

This is pure refactoring.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   46 ++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass
+++ a/include/linux/memcontrol.h
@@ -777,20 +777,7 @@ int memcg_charge_kmem(struct mem_cgroup
 		      unsigned long nr_pages);
 void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned long nr_pages);
 
-/**
- * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
- * @gfp: the gfp allocation flags.
- * @memcg: a pointer to the memcg this was charged against.
- * @order: allocation order.
- *
- * returns true if the memcg where the current task belongs can hold this
- * allocation.
- *
- * We return true automatically if this allocation is not to be accounted to
- * any memcg.
- */
-static inline bool
-memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
+static inline bool __memcg_kmem_bypass(gfp_t gfp)
 {
 	if (!memcg_kmem_enabled())
 		return true;
@@ -812,6 +799,26 @@ memcg_kmem_newpage_charge(gfp_t gfp, str
 	if (unlikely(fatal_signal_pending(current)))
 		return true;
 
+	return false;
+}
+
+/**
+ * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
+ * @gfp: the gfp allocation flags.
+ * @memcg: a pointer to the memcg this was charged against.
+ * @order: allocation order.
+ *
+ * returns true if the memcg where the current task belongs can hold this
+ * allocation.
+ *
+ * We return true automatically if this allocation is not to be accounted to
+ * any memcg.
+ */
+static inline bool
+memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
+{
+	if (__memcg_kmem_bypass(gfp))
+		return true;
 	return __memcg_kmem_newpage_charge(gfp, memcg, order);
 }
 
@@ -854,17 +861,8 @@ memcg_kmem_commit_charge(struct page *pa
 static __always_inline struct kmem_cache *
 memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
-	if (!memcg_kmem_enabled())
-		return cachep;
-	if (gfp & __GFP_NOACCOUNT)
-		return cachep;
-	if (gfp & __GFP_NOFAIL)
+	if (__memcg_kmem_bypass(gfp))
 		return cachep;
-	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
-		return cachep;
-	if (unlikely(fatal_signal_pending(current)))
-		return cachep;
