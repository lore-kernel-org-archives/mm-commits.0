Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BFF23D3EA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837103; cv=none; b=ChxponBEn6B8VXTwS/1B2Va+pdGybEYVgIquyJO0SkuWO9Z6SyNbUYNpySzF7J1Cx2u46QU0YXkQfeHbTqSRYgS73DvO9nzF7mqksfKfB4AKb5bfvOitcdNInAOG4X9N1f5Tz2xAS6EokXmgH5i+GnQ6m3xobUY5FbDH1sbVjg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837103; c=relaxed/simple;
	bh=ThHEKk7wvYAsn78kDiz8n1RbXHxwc+HfgM8KhdiHzFI=;
	h=Date:To:From:Subject:Message-Id; b=TTx7Clfr1TC1JYSbBadL4dpNga2Lt8pQ9XRCQGw8vjovm4VIIcD7tkxNBldUfqc9NFykaEciqQ80mOVb693Kd/Lx2q0Yv4kXb6bW+qiInKNBfYxjpydIzJBCOUKITDRZ5svW639Gc0avPmq3z2G0uHCUd2ch7AVWihZKEozfk+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AYNRCb3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AYNRCb3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C8EC4CEDD;
	Tue, 14 Jan 2025 06:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837103;
	bh=ThHEKk7wvYAsn78kDiz8n1RbXHxwc+HfgM8KhdiHzFI=;
	h=Date:To:From:Subject:From;
	b=AYNRCb3+gtIUzijq0hS5cgmdxlor9I2F2Jx+L2Xbb2MN6vicr0EDkpDbntG29L8aK
	 v3IuYbfV+9TYmlvYrV3/v2PNBGnWvrNv4Lcxjcdp84LaTte6oiLbcB8U6cQQ+IHtMZ
	 hQ9Qj8mTBG1aLJ98TXYFExQ/nOhjtz92Gf9ZSBf8=
Date: Mon, 13 Jan 2025 22:45:02 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-free-hugepage-folios-after-migration.patch removed from -mm tree
Message-Id: <20250114064503.60C8EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: replace free hugepage folios after migration
has been removed from the -mm tree.  Its filename was
     mm-replace-free-hugepage-folios-after-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: yangge <yangge1116@126.com>
Subject: mm: replace free hugepage folios after migration
Date: Sat, 11 Jan 2025 15:58:20 +0800

My machine has 4 NUMA nodes, each equipped with 32GB of memory.  I have
configured each NUMA node with 16GB of CMA and 16GB of in-use hugetlb
pages.  The allocation of contiguous memory via cma_alloc() can fail
probabilistically.

When there are free hugetlb folios in the hugetlb pool, during the
migration of in-use hugetlb folios, new folios are allocated from the free
hugetlb pool.  After the migration is completed, the old folios are
released back to the free hugetlb pool instead of being returned to the
buddy system.  This can cause test_pages_isolated() check to fail,
ultimately leading to the failure of cma_alloc().

Call trace:

cma_alloc()
    __alloc_contig_migrate_range() // migrate in-use hugepage
    test_pages_isolated()
        __test_page_isolated_in_pageblock()
             PageBuddy(page) // check if the page is in buddy

To address this issue, we introduce a function named
replace_free_hugepage_folios().  This function will replace the hugepage
in the free hugepage pool with a new one and release the old one to the
buddy system.  After the migration of in-use hugetlb pages is completed,
we will invoke replace_free_hugepage_folios() to ensure that these
hugepages are properly released to the buddy system.  Following this step,
when test_pages_isolated() is executed for inspection, it will
successfully pass.

Additionally, when alloc_contig_range() is used to migrate multiple in-use
hugetlb pages, it can result in some in-use hugetlb pages being released
back to the free hugetlb pool and subsequently being reallocated and used
again.  For example:

[huge 0] [huge 1]

To migrate huge 0, we obtain huge x from the pool.  After the migration is
completed, we return the now-freed huge 0 back to the pool.  When it's
time to migrate huge 1, we can simply reuse the now-freed huge 0 from the
pool.  As a result, when replace_free_hugepage_folios() is executed, it
cannot release huge 0 back to the buddy system.  To address this issue, we
should prevent the reuse of isolated free hugepages during the migration
process.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge1116@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge1116@126.com
Signed-off-by: yangge <yangge1116@126.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 ++++++
 mm/hugetlb.c            |   42 ++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         |   12 +++++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-replace-free-hugepage-folios-after-migration
+++ a/include/linux/hugetlb.h
@@ -681,6 +681,7 @@ struct huge_bootmem_page {
 };
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
+int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1059,6 +1060,12 @@ static inline int isolate_or_dissolve_hu
 	return -ENOMEM;
 }
 
+static inline int replace_free_hugepage_folios(unsigned long start_pfn,
+		unsigned long end_pfn)
+{
+	return 0;
+}
+
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   int avoid_reserve)
--- a/mm/hugetlb.c~mm-replace-free-hugepage-folios-after-migration
+++ a/mm/hugetlb.c
@@ -48,6 +48,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1336,6 +1337,9 @@ static struct folio *dequeue_hugetlb_fol
 		if (folio_test_hwpoison(folio))
 			continue;
 
+		if (is_migrate_isolate_page(&folio->page))
+			continue;
+
 		list_move(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
 		folio_clear_hugetlb_freed(folio);
@@ -2974,6 +2978,44 @@ int isolate_or_dissolve_huge_page(struct
 
 	return ret;
 }
+
+/*
+ *  replace_free_hugepage_folios - Replace free hugepage folios in a given pfn
+ *  range with new folios.
+ *  @start_pfn: start pfn of the given pfn range
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
+			ret = alloc_and_dissolve_hugetlb_folio(h, folio,
+							       &isolate_list);
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
 
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
--- a/mm/page_alloc.c~mm-replace-free-hugepage-folios-after-migration
+++ a/mm/page_alloc.c
@@ -6504,7 +6504,17 @@ int alloc_contig_range_noprof(unsigned l
 	ret = __alloc_contig_migrate_range(&cc, start, end, migratetype);
 	if (ret && ret != -EBUSY)
 		goto done;
-	ret = 0;
+
+	/*
+	 * When in-use hugetlb pages are migrated, they may simply be released
+	 * back into the free hugepage pool instead of being returned to the
+	 * buddy system.  After the migration of in-use huge pages is completed,
+	 * we will invoke replace_free_hugepage_folios() to ensure that these
+	 * hugepages are properly released to the buddy system.
+	 */
+	ret = replace_free_hugepage_folios(start, end);
+	if (ret)
+		goto done;
 
 	/*
 	 * Pages from [start, end) are within a pageblock_nr_pages
_

Patches currently in -mm which might be from yangge1116@126.com are

mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch

