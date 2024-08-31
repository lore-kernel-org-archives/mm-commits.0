Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90859B673
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 00:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063823; cv=none; b=sV68DjMxq0HLmGSouUOLKuqKVe/rCfnKNnFeo5w8ggw5zVhPgNvugfvwewPNlii4tvakPK2pEbpOtysfP4bcDDD+7vTs3CLK0/zofucpkQe3aR3avPBTHqZWi1Ew4LMHa27Ovt1d1aBCRR73my94YdWcg/3tjniDAIx9M5rWRcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063823; c=relaxed/simple;
	bh=4M5tJPBNDUlK469RPwdUHVcP9f/EQV1PPp7Kdc+0J7k=;
	h=Date:To:From:Subject:Message-Id; b=Q4t9vH0UsoqnbEGS8NsrKv4lzYl2MfqprwYr4h19e949jarPOMypve2uljNdvIyuM7r9axYRPJSMYu+WV5Pz7DXmFAR6O3mxprog9AtUeh8XBD4OfftplCsCMnGq8HxTxOsdPpGHKM6usd5cPXrkzkwRS8lgPtD5EdmRXblK7WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cqVMTZWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cqVMTZWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31BCC4CEC2;
	Sat, 31 Aug 2024 00:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725063823;
	bh=4M5tJPBNDUlK469RPwdUHVcP9f/EQV1PPp7Kdc+0J7k=;
	h=Date:To:From:Subject:From;
	b=cqVMTZWFFWAbQxvNqTGgASRd7kl+Veib8qcHnRjR5cPiWe1LP9rxjlY302XEa/pEl
	 OIOQhlmU8NQI3ir1F1lCBQ54WXywo0mJI8gOYmil2lZZ+AIOTVsyDUeq2EYoOdlatB
	 LIj4Vk7iUaT0MPQSIYblZ9CZmmXoaPUqqsYuEd7o=
Date: Fri, 30 Aug 2024 17:23:42 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix.patch added to mm-unstable branch
Message-Id: <20240831002342.F31BCC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-support-only-one-page_type-per-page-fix.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix.patch
mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

