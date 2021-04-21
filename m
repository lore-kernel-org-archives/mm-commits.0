Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563F3C43460
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 02:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22DAD61419
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 02:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbhDUCzY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 22:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhDUCzY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 22:55:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10DAE6140C;
        Wed, 21 Apr 2021 02:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618973687;
        bh=A0buZBQzmnSAEdwUcUxCcF9wXjsnvWbbGrIZWrNSkKk=;
        h=Date:From:To:Subject:From;
        b=ItI5rpZVhdGVhDcqk2asdnPSaa3wqvhymBcHqKVs//pmavcw4TNqcwwUiyhdFAcq1
         HZT2Vyp8dLj+in8BA7OBIRl3PKxgI+ZX1TeCh2fC92WOOcdh2engaGIqdGyxDnNWD4
         pou/MLcaLrbAg1xmlvQdFvFOI2qZFsXwyxzxJrXg=
Date:   Tue, 20 Apr 2021 19:54:46 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  + mmhugetlb-split-prep_new_huge_page-functionality.patch
 added to -mm tree
Message-ID: <20210421025446.xx_WCgbZz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: split prep_new_huge_page functionality
has been added to the -mm tree.  Its filename is
     mmhugetlb-split-prep_new_huge_page-functionality.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhugetlb-split-prep_new_huge_page-functionality.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhugetlb-split-prep_new_huge_page-functionality.patch

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
Subject: mm,hugetlb: split prep_new_huge_page functionality

Currently, prep_new_huge_page() performs two functions.  It sets the right
state for a new hugetlb, and increases the hstate's counters to account
for the new page.

Let us split its functionality into two separate functions, decoupling the
handling of the counters from initializing a hugepage.  The outcome is
having __prep_new_huge_page(), which only initializes the page , and
__prep_account_new_huge_page(), which adds the new page to the hstate's
counters.

This allows us to be able to set a hugetlb without having to worry about
the counter/locking.  It will prove useful in the next patch. 
prep_new_huge_page() still calls both functions.

Link: https://lkml.kernel.org/r/20210419075413.1064-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-split-prep_new_huge_page-functionality
+++ a/mm/hugetlb.c
@@ -1484,16 +1484,30 @@ void free_huge_page(struct page *page)
 	}
 }
 
-static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
+/*
+ * Must be called with the hugetlb lock held
+ */
+static void __prep_account_new_huge_page(struct hstate *h, int nid)
+{
+	lockdep_assert_held(&hugetlb_lock);
+	h->nr_huge_pages++;
+	h->nr_huge_pages_node[nid]++;
+}
+
+static void __prep_new_huge_page(struct page *page)
 {
 	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 	hugetlb_set_page_subpool(page, NULL);
 	set_hugetlb_cgroup(page, NULL);
 	set_hugetlb_cgroup_rsvd(page, NULL);
+}
+
+static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
+{
+	__prep_new_huge_page(page);
 	spin_lock_irq(&hugetlb_lock);
-	h->nr_huge_pages++;
-	h->nr_huge_pages_node[nid]++;
+	__prep_account_new_huge_page(h, nid);
 	spin_unlock_irq(&hugetlb_lock);
 }
 
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

