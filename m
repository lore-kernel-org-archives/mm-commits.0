Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B935829CF0
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423102; cv=none; b=Cd0wB+hmNqRB0FCuihDh73r4zHNfg+1b2jCUvxOgxPwgMxfZJhs4L4hSS8Rsl8Uoa2EVaX+rYAJmyHLVUu4MkP/ZkvHHGWA1cgYXQZ3ezy9+1SvjcipqAHTbTO8BGvhJqyzPEJS7lP9urVDaSyjuyBhG0IMp9KklO53wS5jPYzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423102; c=relaxed/simple;
	bh=fnkUd7l9SPxmIaPt8eIv1Np8BASlzqpHCEvgVH4/etM=;
	h=Date:To:From:Subject:Message-Id; b=QO2urg9N8z9uCKrrcptxTrAIYnLBnh8fDrDz5io8W/zK5kWKP8OEQcIrzX5vKn87riKJog3QWM8VpYbiWwwqTW+QjZIHjHFujwU6CuvIHSpIZJnR9wYReLT9DIWNerk6oLzJd6j3lC18IjRnYCOAs06P2/Sqnv8NRL3YhanBfWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ocx3gUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ocx3gUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32603C4CEC2;
	Wed,  4 Sep 2024 04:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423102;
	bh=fnkUd7l9SPxmIaPt8eIv1Np8BASlzqpHCEvgVH4/etM=;
	h=Date:To:From:Subject:From;
	b=2ocx3gUo11hwk66LDNlzFPzOxPZnk2oazKqFbJwRN2DjC9djly4DQ0bWZcYa34eWP
	 QTrbf5qBcG3wIdQgt3aOZbBqT2J/ScTBbaePTAv3oPWzkVxQsCY/OEChxwewDHZ9X4
	 lFnKn7XftD2bGhuC65J5lEjc41vdnyJaAfjp7UsA=
Date: Tue, 03 Sep 2024 21:11:41 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix.patch removed from -mm tree
Message-Id: <20240904041142.32603C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation fix
Date: Thu, 29 Aug 2024 23:05:00 +0800

  - Use folio_try_get()/folio_put() unconditionally, per David
  - print current pfn when isolate_folio_to_list fails.
  - memory hotremove test passed for free/used hugetlb folio

Link: https://lkml.kernel.org/r/20240829150500.2599549-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix
+++ a/mm/memory_hotplug.c
@@ -1780,7 +1780,6 @@ static void do_migrate_range(unsigned lo
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		struct page *page;
-		bool hugetlb;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -1811,22 +1810,21 @@ static void do_migrate_range(unsigned lo
 			continue;
 		}
 
-		hugetlb = folio_test_hugetlb(folio);
-		if (!hugetlb) {
-			folio = folio_get_nontail_page(page);
-			if (!folio)
-				continue;
-		}
+		if (!folio_try_get(folio))
+			continue;
+
+		if (unlikely(page_folio(page) != folio))
+			goto put_folio;
 
 		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {
-				pr_warn("failed to isolate pfn %lx\n", pfn);
+				pr_warn("failed to isolate pfn %lx\n",
+					page_to_pfn(page));
 				dump_page(page, "isolation failed");
 			}
 		}
-
-		if (!hugetlb)
-			folio_put(folio);
+put_folio:
+		folio_put(folio);
 	}
 	if (!list_empty(&source)) {
 		nodemask_t nmask = node_states[N_MEMORY];
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

