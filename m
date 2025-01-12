Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0957B632
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736659640; cv=none; b=CbgDHbZF6Le9+eP6XMxUDNcU9MbcQSToyA18VRI3hccvO/Ymb3ijiTSY+qCpS6bWNyF5a5HU/bpUUZfx5jp7qa2pB+t2YSZINtKICkhZiqQfkAVPxIHLJNWp+9JkBgv5DhERJQOXHIP+qjsdY5SEmU6KDeaxS1V95WqIGwzvlB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736659640; c=relaxed/simple;
	bh=0nVSLExaPi/EDZxnxxdCoPAy1634ymtEQx0Bx9sxfOk=;
	h=Date:To:From:Subject:Message-Id; b=PRSeU0iKTBAMiQHU8IC+T/iOXU/XjAj/kXIJEHOmtBwgrj+fiUilxfpIFX9LUc9hrKCXUoY0TteTMldhT36dqfMvvETOXQC9o9a7c9r7KVmFO0GN2wLL/wfuK2S8bujCQbNbz9bx42MYMKnlk3dAQUkgXDewpXCkJma3manEtok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HQJ9Obu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HQJ9Obu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76610C4CEE0;
	Sun, 12 Jan 2025 05:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736659639;
	bh=0nVSLExaPi/EDZxnxxdCoPAy1634ymtEQx0Bx9sxfOk=;
	h=Date:To:From:Subject:From;
	b=HQJ9Obu/6/I2TAXzncdvMd5hzEsxpCy+nwX6D38FM+eLZh7lDOhazXzWuJm22AqIK
	 I42kAAMtVlRt6jM5gfnF5xpSCal9g72LinUFnfb6uNJU2oHSH4CH43lLkbVotAc8jC
	 HRr1/u5ENUkT++T9XnKqewx46VsR0PbDSjcyMgpI=
Date: Sat, 11 Jan 2025 21:27:18 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] replace-free-hugepage-folios-after-migration.patch removed from -mm tree
Message-Id: <20250112052719.76610C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: replace free hugepage folios after migration
has been removed from the -mm tree.  Its filename was
     replace-free-hugepage-folios-after-migration.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: yangge <yangge1116@126.com>
Subject: mm: replace free hugepage folios after migration
Date: Wed, 18 Dec 2024 14:33:08 +0800

My machine has 4 NUMA nodes, each equipped with 32GB of memory.  I have
configured each NUMA node with 16GB of CMA and 16GB of in-use hugetlb
pages.  The allocation of contiguous memory via cma_alloc() can fail
probabilistically.

cma_alloc() may fail if it sees an in-use hugetlb page within the
allocation range, even if that page has already been migrated.  When
in-use hugetlb pages are migrated, they may simply be released back into
the free hugepage pool instead of being returned to the buddy system. 
This can cause test_pages_isolated() check to fail, ultimately leading to
the failure of cma_alloc():

cma_alloc()
    __alloc_contig_migrate_range() // migrate in-use hugepage
    test_pages_isolated()
        __test_page_isolated_in_pageblock()
             PageBuddy(page) // check if the page is in buddy

To address this issue, we add a function named
replace_free_hugepage_folios().  This function will replace the hugepage
in the free hugepage pool with a new one and release the old one to the
buddy system.  After the migration of in-use hugetlb pages is completed,
we will invoke replace_free_hugepage_folios() to ensure that these
hugepages are properly released to the buddy system.  Following this step,
when test_pages_isolated() is executed for inspection, it will
successfully pass.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge1116@126.com
Signed-off-by: yangge <yangge1116@126.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++++++
 mm/hugetlb.c            |   37 +++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         |   13 ++++++++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~replace-free-hugepage-folios-after-migration
+++ a/include/linux/hugetlb.h
@@ -681,6 +681,7 @@ struct huge_bootmem_page {
 };
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1059,6 +1060,11 @@ static inline int isolate_or_dissolve_hu
 	return -ENOMEM;
 }
 
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
+{
+	return 0;
+}
+
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   int avoid_reserve)
--- a/mm/hugetlb.c~replace-free-hugepage-folios-after-migration
+++ a/mm/hugetlb.c
@@ -2975,6 +2975,43 @@ int isolate_or_dissolve_huge_page(struct
 	return ret;
 }
 
+/*
+ *  replace_free_hugepage_folios - Replace free hugepage folios in a given pfn
+ *  range with new folios.
+ *  @stat_pfn: start pfn of the given pfn range
+ *  @end_pfn: end pfn of the given pfn range
+ *  Returns 0 on success, otherwise negated error.
+ */
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
+{
+	struct hstate *h;
+	struct folio *folio;
+	int ret = 0;
+
+	LIST_HEAD(isolate_list);
+
+	while (start_pfn < end_pfn) {
+		folio = pfn_folio(start_pfn);
+		if (folio_test_hugetlb(folio)) {
+			h = folio_hstate(folio);
+		} else {
+			start_pfn++;
+			continue;
+		}
+
+		if (!folio_ref_count(folio)) {
+			ret = alloc_and_dissolve_hugetlb_folio(h, folio, &isolate_list);
+			if (ret)
+				break;
+
+			putback_movable_pages(&isolate_list);
+		}
+		start_pfn++;
+	}
+
+	return ret;
+}
+
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
--- a/mm/page_alloc.c~replace-free-hugepage-folios-after-migration
+++ a/mm/page_alloc.c
@@ -6507,7 +6507,18 @@ int alloc_contig_range_noprof(unsigned l
 	ret = __alloc_contig_migrate_range(&cc, start, end, migratetype);
 	if (ret && ret != -EBUSY)
 		goto done;
-	ret = 0;
+
+	/*
+	 * When in-use hugetlb pages are migrated, they may simply be
+	 * released back into the free hugepage pool instead of being
+	 * returned to the buddy system. After the migration of in-use
+	 * huge pages is completed, we will invoke the
+	 * replace_free_hugepage_folios() function to ensure that
+	 * these hugepages are properly released to the buddy system.
+	 */
+	ret = replace_free_hugepage_folios(start, end);
+	if (ret)
+		goto done;
 
 	/*
 	 * Pages from [start, end) are within a pageblock_nr_pages
_

Patches currently in -mm which might be from yangge1116@126.com are

replace-free-hugepage-folios-after-migration-fix-3.patch
mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch
mm-replace-free-hugepage-folios-after-migration.patch

