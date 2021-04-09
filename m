Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC20C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E704610A2
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhDIFJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233285AbhDIFJS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:09:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1DF961179;
        Fri,  9 Apr 2021 05:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944880;
        bh=LZwBGaz3eDdzxdqFJGfhVxfMIvN29cVJjNZhbROW6Ao=;
        h=Date:From:To:Subject:From;
        b=Ea3sTxscTTEp6Mf5JCnnaXNdUYW8vi5UDY7CfBdfN1Q4iQ/k8GVCYNcjFwsqQeDBB
         6uvAcHd60JoJ6re4YUAuKr3knGU81ywBZvhax874cSg9nnj5UCUtv3RWnDNy0FqT4f
         5d2EQyzIyuAaHUpwFzHdIDMxiDHUbZPjNJxr0gN4=
Date:   Thu, 08 Apr 2021 22:07:59 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch removed from -mm
 tree
Message-ID: <20210409050759.bEOgl7gjt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make alloc_contig_range handle free hugetlb pages
has been removed from the -mm tree.  Its filename was
     mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm: make alloc_contig_range handle free hugetlb pages

alloc_contig_range will fail if it ever sees a HugeTLB page within the
range we are trying to allocate, even when that page is free and can be
easily reallocated.

This has proved to be problematic for some users of alloc_contic_range,
e.g: CMA and virtio-mem, where those would fail the call even when those
pages lay in ZONE_MOVABLE and are free.

We can do better by trying to replace such page.

Free hugepages are tricky to handle so as to no userspace application
notices disruption, we need to replace the current free hugepage with a
new one.

In order to do that, a new function called alloc_and_dissolve_huge_page is
introduced.  This function will first try to get a new fresh hugepage, and
if it succeeds, it will replace the old one in the free hugepage pool.

The free page replacement is done under hugetlb_lock, so no external user
of hugetlb will notice the change.  There is one tricky case when page's
refcount is 0 because it is in the process of being released.  A missing
PageHugeFreed bit will tell us that freeing is in flight so we retry after
dropping the hugetlb_lock.  The race window should be small and the next
retry should make a forward progress.

E.g:

CPU0				CPU1
__free_huge_page()		isolate_or_dissolve_huge_page
				  PageHuge() == T
				  alloc_and_dissolve_huge_page
				    alloc_fresh_huge_page()
				    spin_lock(hugetlb_lock)
				    // PageHuge() && !PageHugeFreed &&
				    // !PageCount()
				    spin_unlock(hugetlb_lock)
  spin_lock(hugetlb_lock)
  1) update_and_free_page
       PageHuge() == F
       __free_pages()
  2) enqueue_huge_page
       SetPageHugeFreed()
  spin_unlock(&hugetlb_lock)
				  spin_lock(hugetlb_lock)
                                   1) PageHuge() == F (freed by case#1 from CPU0)
				   2) PageHuge() == T
                                       PageHugeFreed() == T
                                       - proceed with replacing the page

In the case above we retry as the window race is quite small and we have
high chances to succeed next time.

With regard to the allocation, we restrict it to the node the page belongs
to with __GFP_THISNODE, meaning we do not fallback on other node's zones.

Note that gigantic hugetlb pages are fenced off since there is a cyclic
dependency between them and alloc_contig_range.

Link: https://lkml.kernel.org/r/20210319132004.4341-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++
 mm/compaction.c         |   36 +++++++++++-
 mm/hugetlb.c            |  109 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 146 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~mm-make-alloc_contig_range-handle-free-hugetlb-pages
+++ a/include/linux/hugetlb.h
@@ -587,6 +587,7 @@ struct huge_bootmem_page {
 	struct hstate *hstate;
 };
 
+int isolate_or_dissolve_huge_page(struct page *page);
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
@@ -869,6 +870,11 @@ static inline void huge_ptep_modify_prot
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
+static inline int isolate_or_dissolve_huge_page(struct page *page)
+{
+	return -ENOMEM;
+}
+
 static inline struct page *alloc_huge_page(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   int avoid_reserve)
--- a/mm/compaction.c~mm-make-alloc_contig_range-handle-free-hugetlb-pages
+++ a/mm/compaction.c
@@ -788,7 +788,7 @@ static bool too_many_isolated(pg_data_t
  * Isolate all pages that can be migrated from the range specified by
  * [low_pfn, end_pfn). The range is expected to be within same pageblock.
  * Returns errno, like -EAGAIN or -EINTR in case e.g signal pending or congestion,
- * or 0.
+ * -ENOMEM in case we could not allocate a page, or 0.
  * cc->migrate_pfn will contain the next pfn to scan (which may be both less,
  * equal to or more that end_pfn).
  *
@@ -809,6 +809,7 @@ isolate_migratepages_block(struct compac
 	bool skip_on_failure = false;
 	unsigned long next_skip_pfn = 0;
 	bool skip_updated = false;
+	bool fatal_error = false;
 	int ret = 0;
 
 	cc->migrate_pfn = low_pfn;
@@ -907,6 +908,32 @@ isolate_migratepages_block(struct compac
 			valid_page = page;
 		}
 
+		if (PageHuge(page) && cc->alloc_contig) {
+			ret = isolate_or_dissolve_huge_page(page);
+
+			/*
+			 * Fail isolation in case isolate_or_dissolve_huge_page
+			 * reports an error. In case of -ENOMEM, abort right away.
+			 */
+			if (ret < 0) {
+				/*
+				 * Do not report -EBUSY down the chain.
+				 */
+				if (ret == -ENOMEM)
+					fatal_error = true;
+				else
+					ret = 0;
+				goto isolate_fail;
+			}
+
+			/*
+			 * Ok, the hugepage was dissolved. Now these pages are
+			 * Buddy and cannot be re-allocated because they are
+			 * isolated. Fall-through as the check below handles
+			 * Buddy pages.
+			 */
+		}
+
 		/*
 		 * Skip if free. We read page order here without zone lock
 		 * which is generally unsafe, but the race window is small and
@@ -1092,6 +1119,9 @@ isolate_fail:
 			 */
 			next_skip_pfn += 1UL << cc->order;
 		}
+
+		if (fatal_error)
+			break;
 	}
 
 	/*
@@ -1144,8 +1174,8 @@ fatal_pending:
  * @start_pfn: The first PFN to start isolating.
  * @end_pfn:   The one-past-last PFN.
  *
- * Returns errno, like -EAGAIN or -EINTR in case e.g signal pending or congestion,
- * or 0.
+ * Returns errno, like -EAGAIN or -EINTR in case e.g signal pending or
+ * congestion, -ENOMEM in case we could not allocate a page, or 0.
  */
 int
 isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
--- a/mm/hugetlb.c~mm-make-alloc_contig_range-handle-free-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -1056,13 +1056,18 @@ static bool vma_has_reserves(struct vm_a
 	return false;
 }
 
+static void __enqueue_huge_page(struct list_head *list, struct page *page)
+{
+	list_move(&page->lru, list);
+	SetHPageFreed(page);
+}
+
 static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
-	list_move(&page->lru, &h->hugepage_freelists[nid]);
+	__enqueue_huge_page(&h->hugepage_freelists[nid], page);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
-	SetHPageFreed(page);
 }
 
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
@@ -2266,6 +2271,106 @@ static void restore_reserve_on_error(str
 	}
 }
 
+/*
+ * alloc_and_dissolve_huge_page - Allocate a new page and dissolve the old one
+ * @h: struct hstate old page belongs to
+ * @old_page: Old page to dissolve
+ * Returns 0 on success, otherwise negated error.
+ */
+
+static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page)
+{
+	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
+	int nid = page_to_nid(old_page);
+	struct page *new_page;
+	int ret = 0;
+
+	/*
+	 * Before dissolving the page, we need to allocate a new one,
+	 * so the pool remains stable.
+	 */
+	new_page = alloc_fresh_huge_page(h, gfp_mask, nid, NULL, NULL);
+	if (!new_page)
+		return -ENOMEM;
+
+	/*
+	 * Pages got from Buddy are self-refcounted, but free hugepages
+	 * need to have a refcount of 0.
+	 */
+	page_ref_dec(new_page);
+retry:
+	spin_lock(&hugetlb_lock);
+	if (!PageHuge(old_page)) {
+		/*
+		 * Freed from under us. Drop new_page too.
+		 */
+		update_and_free_page(h, new_page);
+		goto unlock;
+	} else if (page_count(old_page)) {
+		/*
+		 * Someone has grabbed the page, fail for now.
+		 */
+		ret = -EBUSY;
+		update_and_free_page(h, new_page);
+		goto unlock;
+	} else if (!HPageFreed(old_page)) {
+		/*
+		 * Page's refcount is 0 but it has not been enqueued in the
+		 * freelist yet. Race window is small, so we can succed here if
+		 * we retry.
+		 */
+		spin_unlock(&hugetlb_lock);
+		cond_resched();
+		goto retry;
+	} else {
+		/*
+		 * Ok, old_page is still a genuine free hugepage. Replace it
+		 * with the new one.
+		 */
+		list_del(&old_page->lru);
+		update_and_free_page(h, old_page);
+		/*
+		 * h->free_huge_pages{_node} counters do not need to be updated.
+		 */
+		__enqueue_huge_page(&h->hugepage_freelists[nid], new_page);
+	}
+unlock:
+	spin_unlock(&hugetlb_lock);
+
+	return ret;
+}
+
+int isolate_or_dissolve_huge_page(struct page *page)
+{
+	struct hstate *h;
+	struct page *head;
+
+	/*
+	 * The page might have been dissolved from under our feet, so make sure
+	 * to carefully check the state under the lock.
+	 * Return success when racing as if we dissolved the page ourselves.
+	 */
+	spin_lock(&hugetlb_lock);
+	if (PageHuge(page)) {
+		head = compound_head(page);
+		h = page_hstate(head);
+	} else {
+		spin_unlock(&hugetlb_lock);
+		return 0;
+	}
+	spin_unlock(&hugetlb_lock);
+
+	/*
+	 * Fence off gigantic pages as there is a cyclic dependency between
+	 * alloc_contig_range and them. Return -ENOME as this has the effect
+	 * of bailing out right away without further retrying.
+	 */
+	if (hstate_is_gigantic(h))
+		return -ENOMEM;
+
+	return alloc_and_dissolve_huge_page(h, head);
+}
+
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

