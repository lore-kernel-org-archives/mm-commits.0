From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-inline-mem_cgroup_charge_common.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 13:50:51 -0700
Message-ID: <5344612b.2JuCseQUL1YOtrp0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaDHUuw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:50:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcg-inline-mem_cgroup_charge_common.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:50:51 -0700


The patch titled
     Subject: mm: memcg: inline mem_cgroup_charge_common()
has been removed from the -mm tree.  Its filename was
     mm-memcg-inline-mem_cgroup_charge_common.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: inline mem_cgroup_charge_common()

mem_cgroup_charge_common() is used by both cache and anon pages, but most
of its body only applies to anon pages and the remainder is not worth
having in a separate function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-inline-mem_cgroup_charge_common mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-inline-mem_cgroup_charge_common
+++ a/mm/memcontrol.c
@@ -3887,20 +3887,21 @@ out:
 	return ret;
 }
 
-/*
- * Charge the memory controller for page usage.
- * Return
- * 0 if the charge was successful
- * < 0 if the cgroup is over its limit
- */
-static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask, enum charge_type ctype)
+int mem_cgroup_newpage_charge(struct page *page,
+			      struct mm_struct *mm, gfp_t gfp_mask)
 {
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
 	bool oom = true;
 	int ret;
 
+	if (mem_cgroup_disabled())
+		return 0;
+
+	VM_BUG_ON_PAGE(page_mapped(page), page);
+	VM_BUG_ON_PAGE(page->mapping && !PageAnon(page), page);
+	VM_BUG_ON(!mm);
+
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
@@ -3914,22 +3915,11 @@ static int mem_cgroup_charge_common(stru
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret == -ENOMEM)
 		return ret;
-	__mem_cgroup_commit_charge(memcg, page, nr_pages, ctype, false);
+	__mem_cgroup_commit_charge(memcg, page, nr_pages,
+				   MEM_CGROUP_CHARGE_TYPE_ANON, false);
 	return 0;
 }
 
-int mem_cgroup_newpage_charge(struct page *page,
-			      struct mm_struct *mm, gfp_t gfp_mask)
-{
-	if (mem_cgroup_disabled())
-		return 0;
-	VM_BUG_ON_PAGE(page_mapped(page), page);
-	VM_BUG_ON_PAGE(page->mapping && !PageAnon(page), page);
-	VM_BUG_ON(!mm);
-	return mem_cgroup_charge_common(page, mm, gfp_mask,
-					MEM_CGROUP_CHARGE_TYPE_ANON);
-}
-
 /*
  * While swap-in, try_charge -> commit or cancel, the page is locked.
  * And when try_charge() successfully returns, one refcnt to memcg without
@@ -4047,9 +4037,11 @@ int mem_cgroup_cache_charge(struct page
 	if (PageCompound(page))
 		return 0;
 
-	if (!PageSwapCache(page))
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
-	else { /* page is swapcache/shmem */
+	if (!PageSwapCache(page)) {
+		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
+		if (ret != -ENOMEM)
+			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
+	} else { /* page is swapcache/shmem */
 		ret = __mem_cgroup_try_charge_swapin(mm, page,
 						     gfp_mask, &memcg);
 		if (!ret)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

