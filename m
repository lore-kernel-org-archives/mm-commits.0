Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BDAC433B4
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 02:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5306B6141E
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 02:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhDUCzX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 22:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234686AbhDUCzW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 22:55:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6E9561415;
        Wed, 21 Apr 2021 02:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618973690;
        bh=CS+1c59MioMVHPrdbLW+0uHRsuKmD2q+h/3ISAivD44=;
        h=Date:From:To:Subject:From;
        b=QpaT1ZqbQ1RfiLGK0klQoMi+Bg4EnDfzrYOnmqCPsZgGDoh25aP+SEpRaW6IsAznv
         yQebESGMHYRsT8l+GEGuU/WKTU9YHWZDlbRrZ5ueP+WutnNIUIKZOOU3NQ0x8MJV4Q
         2PidI22lCByqN5QHNB4hPUptF7AOqy0G+k9ALXmU=
Date:   Tue, 20 Apr 2021 19:54:49 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  +
 mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch added to -mm
 tree
Message-ID: <20210421025449.87QNhKkKg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make alloc_contig_range handle free hugetlb pages
has been added to the -mm tree.  Its filename is
     mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

The free page replacement is done under hugetlb_lock, so no external users
of hugetlb will notice the change.  To allocate the new huge page, we use
alloc_buddy_huge_page(), so we do not have to deal with any counters, and
prep_new_huge_page() is not called.  This is valulable because in case we
need to free the new page, we only need to call __free_pages().

Once we know that the page to be replaced is a genuine 0-refcounted huge
page, we remove the old page from the freelist by remove_hugetlb_page(). 
Then, we can call __prep_new_huge_page() and
__prep_account_new_huge_page() for the new huge page to properly
initialize it and increment the hstate->nr_huge_pages counter (previously
decremented by remove_hugetlb_page()).  Once done, the page is enqueued by
enqueue_huge_page() and it is ready to be used.

There is one tricky case when page's refcount is 0 because it is in the
process of being released.  A missing PageHugeFreed bit will tell us that
freeing is in flight so we retry after dropping the hugetlb_lock.  The
race window should be small and the next retry should make a forward
progress.

E.g:

CPU0				CPU1
free_huge_page()		isolate_or_dissolve_huge_page
				  PageHuge() == T
				  alloc_and_dissolve_huge_page
				    alloc_buddy_huge_page()
				    spin_lock_irq(hugetlb_lock)
				    // PageHuge() && !PageHugeFreed &&
				    // !PageCount()
				    spin_unlock_irq(hugetlb_lock)
  spin_lock_irq(hugetlb_lock)
  1) update_and_free_page
       PageHuge() == F
       __free_pages()
  2) enqueue_huge_page
       SetPageHugeFreed()
  spin_unlock_irq(&hugetlb_lock)
				  spin_lock_irq(hugetlb_lock)
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

Link: https://lkml.kernel.org/r/20210419075413.1064-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +
 mm/compaction.c         |   33 +++++++++-
 mm/hugetlb.c            |  116 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 3 deletions(-)

--- a/include/linux/hugetlb.h~mm-make-alloc_contig_range-handle-free-hugetlb-pages
+++ a/include/linux/hugetlb.h
@@ -588,6 +588,7 @@ struct huge_bootmem_page {
 	struct hstate *hstate;
 };
 
+int isolate_or_dissolve_huge_page(struct page *page);
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
@@ -870,6 +871,11 @@ static inline void huge_ptep_modify_prot
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
  * cc->migrate_pfn will contain the next pfn to scan.
  *
  * The pages are isolated on cc->migratepages list (not required to be empty),
@@ -906,6 +906,29 @@ isolate_migratepages_block(struct compac
 			valid_page = page;
 		}
 
+		if (PageHuge(page) && cc->alloc_contig) {
+			ret = isolate_or_dissolve_huge_page(page);
+
+			/*
+			 * Fail isolation in case isolate_or_dissolve_huge_page()
+			 * reports an error. In case of -ENOMEM, abort right away.
+			 */
+			if (ret < 0) {
+				 /* Do not report -EBUSY down the chain */
+				if (ret == -EBUSY)
+					ret = 0;
+				low_pfn += (1UL << compound_order(page)) - 1;
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
@@ -1065,7 +1088,7 @@ isolate_fail_put:
 		put_page(page);
 
 isolate_fail:
-		if (!skip_on_failure)
+		if (!skip_on_failure && ret != -ENOMEM)
 			continue;
 
 		/*
@@ -1091,6 +1114,9 @@ isolate_fail:
 			 */
 			next_skip_pfn += 1UL << cc->order;
 		}
+
+		if (ret == -ENOMEM)
+			break;
 	}
 
 	/*
@@ -1143,7 +1169,8 @@ fatal_pending:
  * @start_pfn: The first PFN to start isolating.
  * @end_pfn:   The one-past-last PFN.
  *
- * Returns -EAGAIN when contented, -EINTR in case of a signal pending or 0.
+ * Returns -EAGAIN when contented, -EINTR in case of a signal pending, -ENOMEM
+ * in case we could not allocate a page, or 0.
  */
 int
 isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
--- a/mm/hugetlb.c~mm-make-alloc_contig_range-handle-free-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -2267,6 +2267,122 @@ static void restore_reserve_on_error(str
 	}
 }
 
+/*
+ * alloc_and_dissolve_huge_page - Allocate a new page and dissolve the old one
+ * @h: struct hstate old page belongs to
+ * @old_page: Old page to dissolve
+ * Returns 0 on success, otherwise negated error.
+ */
+static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page)
+{
+	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
+	int nid = page_to_nid(old_page);
+	struct page *new_page;
+	int ret = 0;
+
+	/*
+	 * Before dissolving the page, we need to allocate a new one for the
+	 * pool to remain stable. Using alloc_buddy_huge_page() allows us to
+	 * not having to deal with prep_new_huge_page() and avoids dealing of any
+	 * counters. This simplifies and let us do the whole thing under the
+	 * lock.
+	 */
+	new_page = alloc_buddy_huge_page(h, gfp_mask, nid, NULL, NULL);
+	if (!new_page)
+		return -ENOMEM;
+
+retry:
+	spin_lock_irq(&hugetlb_lock);
+	if (!PageHuge(old_page)) {
+		/*
+		 * Freed from under us. Drop new_page too.
+		 */
+		goto free_new;
+	} else if (page_count(old_page)) {
+		/*
+		 * Someone has grabbed the page, fail for now.
+		 */
+		ret = -EBUSY;
+		goto free_new;
+	} else if (!HPageFreed(old_page)) {
+		/*
+		 * Page's refcount is 0 but it has not been enqueued in the
+		 * freelist yet. Race window is small, so we can succeed here if
+		 * we retry.
+		 */
+		spin_unlock_irq(&hugetlb_lock);
+		cond_resched();
+		goto retry;
+	} else {
+		/*
+		 * Ok, old_page is still a genuine free hugepage. Remove it from
+		 * the freelist and decrease the counters. These will be
+		 * incremented again when calling __prep_account_new_huge_page()
+		 * and enqueue_huge_page() for new_page. The counters will remain
+		 * stable since this happens under the lock.
+		 */
+		remove_hugetlb_page(h, old_page, false);
+
+		/*
+		 * new_page needs to be initialized with the standard hugetlb
+		 * state. This is normally done by prep_new_huge_page() but
+		 * that takes hugetlb_lock which is already held so we need to
+		 * open code it here.
+		 * Reference count trick is needed because allocator gives us
+		 * referenced page but the pool requires pages with 0 refcount.
+		 */
+		__prep_new_huge_page(new_page);
+		__prep_account_new_huge_page(h, nid);
+		page_ref_dec(new_page);
+		enqueue_huge_page(h, new_page);
+
+		/*
+		 * Pages have been replaced, we can safely free the old one.
+		 */
+		spin_unlock_irq(&hugetlb_lock);
+		update_and_free_page(h, old_page);
+	}
+
+	return ret;
+
+free_new:
+	spin_unlock_irq(&hugetlb_lock);
+	__free_pages(new_page, huge_page_order(h));
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
+	spin_lock_irq(&hugetlb_lock);
+	if (PageHuge(page)) {
+		head = compound_head(page);
+		h = page_hstate(head);
+	} else {
+		spin_unlock_irq(&hugetlb_lock);
+		return 0;
+	}
+	spin_unlock_irq(&hugetlb_lock);
+
+	/*
+	 * Fence off gigantic pages as there is a cyclic dependency between
+	 * alloc_contig_range and them. Return -ENOMEM as this has the effect
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
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch
mmhugetlb-split-prep_new_huge_page-functionality.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
drivers-base-memory-introduce-memory_block_onlineoffline.patch
mmmemory_hotplug-relax-fully-spanned-sections-check.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

