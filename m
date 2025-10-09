Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EEE284678
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760045160; cv=none; b=AJ9T4LW0BBMMLacWiajiypfaflfvfzNWh9z+3mO+o8g8Sa4ll/BaXoUrK4MZnN+eYOiebo+RjcPnedx1iUuMTibXmjJ08/iF0+Qwcf7x+MEdjy/d3Sgs/hn8/MgkBH71DrsR0N7g4zFqywOgGbdEVLIIaMvx4fQAkGOLpqleE48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760045160; c=relaxed/simple;
	bh=lVYBIIO4JNAJs4DnkDNHyUOZBBvMhm/5k4bGltmicms=;
	h=Date:To:From:Subject:Message-Id; b=HOPu5tFDyneoIvpiuTYkmkd3ZrcI884cXxGM0Nq+0uEcCkL4vpl09cI7I5/hnToNHxM0es1m6B+jpLWAsoOUWzzW/3rWgnV6qRx51nbTrLnkYKXAw6Q6BK9KzWwLYfZ/lAuOSjOmt1uQw04dN9wtef/wH3KAawKCxcOkH+x3Udk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sw5bKGcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sw5bKGcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC34FC4CEE7;
	Thu,  9 Oct 2025 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760045159;
	bh=lVYBIIO4JNAJs4DnkDNHyUOZBBvMhm/5k4bGltmicms=;
	h=Date:To:From:Subject:From;
	b=Sw5bKGcE6gij2/LTN8xQhIuODXIgZDxBxQ3rATO3Sl4BWLk845AFQODrbf8tAxP8T
	 US4h0YXYuv49sSHnfhVAkYYmsUPYS4vQGHK7rA3sQrueV9cCGc5C6JGPxXrv86K6kF
	 n0+LUPQUTBFwdF5MFFEWp4EK4xaLa2uYvaTANClU=
Date: Thu, 09 Oct 2025 14:25:59 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-create-hstate_is_gigantic_no_runtime-helper.patch added to mm-new branch
Message-Id: <20251009212559.CC34FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: create hstate_is_gigantic_no_runtime helper
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-create-hstate_is_gigantic_no_runtime-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-create-hstate_is_gigantic_no_runtime-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-create-hstate_is_gigantic_no_runtime-helper
+++ a/mm/hugetlb.c
@@ -134,6 +134,17 @@ static void hugetlb_free_folio(struct fo
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
@@ -1555,7 +1566,7 @@ static void remove_hugetlb_folio(struct
 	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
 
 	lockdep_assert_held(&hugetlb_lock);
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		return;
 
 	list_del(&folio->lru);
@@ -1617,7 +1628,7 @@ static void __update_and_free_hugetlb_fo
 {
 	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
 
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		return;
 
 	/*
@@ -2511,7 +2522,7 @@ static void return_unused_surplus_pages(
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		goto out;
 
 	/*
@@ -3725,7 +3736,7 @@ static void __init hugetlb_init_hstates(
 		 * - If CMA allocation is possible, we can not demote
 		 *   HUGETLB_PAGE_ORDER or smaller size pages.
 		 */
-		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+		if (hstate_is_gigantic_no_runtime(h))
 			continue;
 		if (hugetlb_cma_total_size() && h->order <= HUGETLB_PAGE_ORDER)
 			continue;
@@ -4202,7 +4213,7 @@ static ssize_t __nr_hugepages_store_comm
 	int err;
 	nodemask_t nodes_allowed, *n_mask;
 
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		return -EINVAL;
 
 	if (nid == NUMA_NO_NODE) {
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-hugetlb-create-hstate_is_gigantic_no_runtime-helper.patch
mm-hugetlb-allow-overcommitting-gigantic-hugepages.patch

