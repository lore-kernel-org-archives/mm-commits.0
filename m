Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F26201278
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343116; cv=none; b=vFz7HICufsJZIn7E0QkAb5ecYvmEJtzbdcHYt89BlqQpr0AoKyI+5J38oc2Ju4yewCcuH+GUy9Ye0QPu5ptWUwvKfrpe/kIIQoIrCV7LYMT9Mu1lIWxRlhNNUmShd8xUEeFN/guuBVNEjkkQpc589EKox6HIQq7JuqOtwT/MlVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343116; c=relaxed/simple;
	bh=4cEpaVzPXeh0cmg0K1dHB6qpN3bi/W63YYGYb/XK/p8=;
	h=Date:To:From:Subject:Message-Id; b=hu8XlSh1s4mxxDdrSna7hFavVtBGS4O3mLUxnpGlXcrMyCOR22PCsLiaHuBosm9gek2rljO8rbMGfAblmsXYHR1mM/qm/bFSG6QgPHXFYWCOmH1Oe+ybETw/neqomrwtYOP3GS8RfiiEcnlVcuItU+D1bQ146Tr+QxxtCSWidCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mghVrFXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mghVrFXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E7AC4CEF1;
	Mon, 17 Nov 2025 01:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343116;
	bh=4cEpaVzPXeh0cmg0K1dHB6qpN3bi/W63YYGYb/XK/p8=;
	h=Date:To:From:Subject:From;
	b=mghVrFXyCcFYudLOe1scFJi05NyPjynR0hubNPfPKbPbATsJvp1ekvHgNbeBcfqSm
	 qAaHhach2YMwXWaMPHaidn4UQXeQy0DHuyt1AMa7cS+UZOe9Ny/b8ppomNqRZK1OmG
	 MJjIhXao9oD4YNyOP9mKp2QWo5U6BsQwS3ZgN8Ms=
Date: Sun, 16 Nov 2025 17:31:55 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sj@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-create-hstate_is_gigantic_no_runtime-helper.patch removed from -mm tree
Message-Id: <20251117013156.33E7AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: create hstate_is_gigantic_no_runtime helper
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-create-hstate_is_gigantic_no_runtime-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm/hugetlb: create hstate_is_gigantic_no_runtime helper
Date: Thu, 9 Oct 2025 18:24:30 +0100

This is a common condition used to skip operations that cannot be
performed on gigantic pages when runtime support is disabled.  This helper
is introduced as the condition will exist even more when allowing
"overcommit" of gigantic hugepages.  No functional change intended with
this patch.

Link: https://lkml.kernel.org/r/20251009172433.4158118-1-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-create-hstate_is_gigantic_no_runtime-helper
+++ a/mm/hugetlb.c
@@ -135,6 +135,17 @@ static void hugetlb_free_folio(struct fo
 	folio_put(folio);
 }
 
+/*
+ * Check if the hstate represents gigantic pages but gigantic page
+ * runtime support is not available. This is a common condition used to
+ * skip operations that cannot be performed on gigantic pages when runtime
+ * support is disabled.
+ */
+static inline bool hstate_is_gigantic_no_runtime(struct hstate *h)
+{
+	return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
+}
+
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
@@ -1535,7 +1546,7 @@ static void remove_hugetlb_folio(struct
 	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
 
 	lockdep_assert_held(&hugetlb_lock);
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		return;
 
 	list_del(&folio->lru);
@@ -1597,7 +1608,7 @@ static void __update_and_free_hugetlb_fo
 {
 	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
 
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		return;
 
 	/*
@@ -2491,7 +2502,7 @@ static void return_unused_surplus_pages(
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		goto out;
 
 	/*
@@ -3705,7 +3716,7 @@ static void __init hugetlb_init_hstates(
 		 * - If CMA allocation is possible, we can not demote
 		 *   HUGETLB_PAGE_ORDER or smaller size pages.
 		 */
-		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+		if (hstate_is_gigantic_no_runtime(h))
 			continue;
 		if (hugetlb_cma_total_size() && h->order <= HUGETLB_PAGE_ORDER)
 			continue;
@@ -4182,7 +4193,7 @@ static ssize_t __nr_hugepages_store_comm
 	int err;
 	nodemask_t nodes_allowed, *n_mask;
 
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		return -EINVAL;
 
 	if (nid == NUMA_NO_NODE) {
_

Patches currently in -mm which might be from usamaarif642@gmail.com are


