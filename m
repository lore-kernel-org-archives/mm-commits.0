Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10B784A2F
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724799796; cv=none; b=l+kqxyAbgqiVjFoCnqIpOQ5Pq5nLdPjdVP9RZrJuuglk1ROfauyPo1DsIlKFk5cyYXt1oh5VekT8Jt5d4KLfWxi4mB5QZyUgiT6w/mY3SIjyE9LsTgj3Q4a37Ty/gwXoDv04rA5I3Ks+R+mo8nPGDYWxa/1mYUlQgyuWwO5gQ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724799796; c=relaxed/simple;
	bh=E2+BI6Kaw/mI2Gv+OV4V3CZF82hi1dwfusbVtReoMZM=;
	h=Date:To:From:Subject:Message-Id; b=fx/Jhn/YpsBEljEU8TM2gFP6BsTEGp3wSU5AG80gzwEU4UhE9gA/a3QDj+mFIQ4LI7ed1UvJuXHHnNcEwUa/0tX8sb1ogkkHM8nqimFlIau9BOHRj0gnUZxvJtm3b89vi4SGDS0OLj7DqrQYr0pt34JDHQvhfI7GbaZ2V1x72BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XyECNiCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XyECNiCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951A7C4AF13;
	Tue, 27 Aug 2024 23:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724799796;
	bh=E2+BI6Kaw/mI2Gv+OV4V3CZF82hi1dwfusbVtReoMZM=;
	h=Date:To:From:Subject:From;
	b=XyECNiCyB2ntmOS7KfAduQGnC2ObuAR4GCB9dFdd0dznMiO78bM6+OdwsKzA6IwAv
	 ilfXhfLfuER2mqFvIoUmVNyVMhYJ16MeFzEi6lB/GINWhCIKTeWXjN/o/nzX2E5bIJ
	 Hd4YVFic58fMOGPchYHYcCET90wCJDC28m7bhO6E=
Date: Tue, 27 Aug 2024 16:03:15 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch added to mm-unstable branch
Message-Id: <20240827230316.951A7C4AF13@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

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
Subject: mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation
Date: Tue, 27 Aug 2024 19:47:28 +0800

Use the isolate_folio_to_list() to unify hugetlb/LRU/non-LRU folio
isolation, which cleanup code a bit and save a few calls to
compound_head().

Link: https://lkml.kernel.org/r/20240827114728.3212578-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   45 +++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation
+++ a/mm/memory_hotplug.c
@@ -1772,15 +1772,15 @@ found:
 
 static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
+	struct folio *folio;
 	unsigned long pfn;
-	struct page *page;
 	LIST_HEAD(source);
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-		struct folio *folio;
-		bool isolated;
+		struct page *page;
+		bool hugetlb;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -1811,34 +1811,22 @@ static void do_migrate_range(unsigned lo
 			continue;
 		}
 
-		if (folio_test_hugetlb(folio)) {
-			isolate_hugetlb(folio, &source);
-			continue;
+		hugetlb = folio_test_hugetlb(folio);
+		if (!hugetlb) {
+			folio = folio_get_nontail_page(page);
+			if (!folio)
+				continue;
 		}
 
-		if (!get_page_unless_zero(page))
-			continue;
-		/*
-		 * We can skip free pages. And we can deal with pages on
-		 * LRU and non-lru movable pages.
-		 */
-		if (PageLRU(page))
-			isolated = isolate_lru_page(page);
-		else
-			isolated = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
-		if (isolated) {
-			list_add_tail(&page->lru, &source);
-			if (!__PageMovable(page))
-				inc_node_page_state(page, NR_ISOLATED_ANON +
-						    page_is_file_lru(page));
-
-		} else {
+		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {
 				pr_warn("failed to isolate pfn %lx\n", pfn);
 				dump_page(page, "isolation failed");
 			}
 		}
-		put_page(page);
+
+		if (!hugetlb)
+			folio_put(folio);
 	}
 	if (!list_empty(&source)) {
 		nodemask_t nmask = node_states[N_MEMORY];
@@ -1853,7 +1841,7 @@ static void do_migrate_range(unsigned lo
 		 * We have checked that migration range is on a single zone so
 		 * we can use the nid of the first page to all the others.
 		 */
-		mtc.nid = page_to_nid(list_first_entry(&source, struct page, lru));
+		mtc.nid = folio_nid(list_first_entry(&source, struct folio, lru));
 
 		/*
 		 * try to allocate from a different node but reuse this node
@@ -1866,11 +1854,12 @@ static void do_migrate_range(unsigned lo
 		ret = migrate_pages(&source, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_HOTPLUG, NULL);
 		if (ret) {
-			list_for_each_entry(page, &source, lru) {
+			list_for_each_entry(folio, &source, lru) {
 				if (__ratelimit(&migrate_rs)) {
 					pr_warn("migrating pfn %lx failed ret:%d\n",
-						page_to_pfn(page), ret);
-					dump_page(page, "migration failure");
+						folio_pfn(folio), ret);
+					dump_page(&folio->page,
+						  "migration failure");
 				}
 			}
 			putback_movable_pages(&source);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

