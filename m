From: akpm@linux-foundation.org
Subject: +
 memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass.patch added
 to -mm tree
Date: Mon, 14 Sep 2015 14:14:23 -0700
Message-ID: <55f738af.M3ciWalMwBF3VWBp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbINVOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mhocko@suse.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: collect kmem bypass conditions into __memcg_kmem_bypass()
has been added to the -mm tree.  Its filename is
     memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   46 ++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-collect-kmem-bypass-conditions-into-__memcg_kmem_bypass
+++ a/include/linux/memcontrol.h
@@ -776,20 +776,7 @@ int memcg_charge_kmem(struct mem_cgroup
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
@@ -811,6 +798,26 @@ memcg_kmem_newpage_charge(gfp_t gfp, str
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
 
@@ -853,17 +860,8 @@ memcg_kmem_commit_charge(struct page *pa
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
