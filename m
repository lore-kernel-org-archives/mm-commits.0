Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29B1EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 17:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjHURfJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 13:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbjHURfJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 13:35:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8C210F
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 10:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7985F640AB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 17:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00EEC433C9;
        Mon, 21 Aug 2023 17:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692639298;
        bh=LNZXgZ00YGnUK2ZtrDDu27/ZhgjagGmCgoqt93ozfp8=;
        h=Date:To:From:Subject:From;
        b=EW0D5Ose5Bbo7feICyfLhPoqN2TxSBVKWBfIm6EKk4l+WMEcWdfvEQ7igYd++mB9Y
         dxDvWWeeajq1wjl4YOnWVXU6E6isd3qswER7YNN7WRbhLLdWfNKcwnruWW1fwWmIp3
         30CQt6YPnXqnur+FLSGzSjeE4+wxT53SbiXbOBJc=
Date:   Mon, 21 Aug 2023 10:34:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com, peterx@redhat.com,
        hughd@google.com, ddstreet@ieee.org, catalin.marinas@arm.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch added to mm-unstable branch
Message-Id: <20230821173458.D00EEC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: stop using page->private on tail pages for THP_SWAP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/swap: stop using page->private on tail pages for THP_SWAP
Date: Mon, 21 Aug 2023 18:08:46 +0200

Patch series "mm/swap: stop using page->private on tail pages for THP_SWAP
+ cleanups".

This series stops using page->private on tail pages for THP_SWAP, replaces
folio->private by folio->swap for swapcache folios, and starts using
"new_folio" for tail pages that we are splitting to remove the usage of
page->private for swapcache handling completely.


This patch (of 4):

Let's stop using page->private on tail pages, making it possible to just
unconditionally reuse that field in the tail pages of large folios.

The remaining usage of the private field for THP_SWAP is in the THP
splitting code (mm/huge_memory.c), that we'll handle separately later.

Update the THP_SWAP documentation and sanity checks in mm_types.h and
__split_huge_page_tail().

Link: https://lkml.kernel.org/r/20230821160849.531668-1-david@redhat.com
Link: https://lkml.kernel.org/r/20230821160849.531668-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mteswap.c  |    5 +++--
 include/linux/mm_types.h |   12 +-----------
 include/linux/swap.h     |    9 +++++++++
 mm/huge_memory.c         |   15 ++++++---------
 mm/memory.c              |    2 +-
 mm/rmap.c                |    2 +-
 mm/swap_state.c          |    5 +++--
 mm/swapfile.c            |    4 ++--
 8 files changed, 26 insertions(+), 28 deletions(-)

--- a/arch/arm64/mm/mteswap.c~mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap
+++ a/arch/arm64/mm/mteswap.c
@@ -33,8 +33,9 @@ int mte_save_tags(struct page *page)
 
 	mte_save_page_tags(page_address(page), tag_storage);
 
-	/* page_private contains the swap entry.val set in do_swap_page */
-	ret = xa_store(&mte_pages, page_private(page), tag_storage, GFP_KERNEL);
+	/* lookup the swap entry.val from the page */
+	ret = xa_store(&mte_pages, page_swap_entry(page).val, tag_storage,
+		       GFP_KERNEL);
 	if (WARN(xa_is_err(ret), "Failed to store MTE tags")) {
 		mte_free_tag_storage(tag_storage);
 		return xa_err(ret);
--- a/include/linux/mm_types.h~mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap
+++ a/include/linux/mm_types.h
@@ -333,11 +333,8 @@ struct folio {
 			atomic_t _pincount;
 #ifdef CONFIG_64BIT
 			unsigned int _folio_nr_pages;
-			/* 4 byte gap here */
-	/* private: the union with struct page is transitional */
-			/* Fix THP_SWAP to not use tail->private */
-			unsigned long _private_1;
 #endif
+	/* private: the union with struct page is transitional */
 		};
 		struct page __page_1;
 	};
@@ -358,9 +355,6 @@ struct folio {
 	/* public: */
 			struct list_head _deferred_list;
 	/* private: the union with struct page is transitional */
-			unsigned long _avail_2a;
-			/* Fix THP_SWAP to not use tail->private */
-			unsigned long _private_2a;
 		};
 		struct page __page_2;
 	};
@@ -385,9 +379,6 @@ FOLIO_MATCH(memcg_data, memcg_data);
 			offsetof(struct page, pg) + sizeof(struct page))
 FOLIO_MATCH(flags, _flags_1);
 FOLIO_MATCH(compound_head, _head_1);
-#ifdef CONFIG_64BIT
-FOLIO_MATCH(private, _private_1);
-#endif
 #undef FOLIO_MATCH
 #define FOLIO_MATCH(pg, fl)						\
 	static_assert(offsetof(struct folio, fl) ==			\
@@ -396,7 +387,6 @@ FOLIO_MATCH(flags, _flags_2);
 FOLIO_MATCH(compound_head, _head_2);
 FOLIO_MATCH(flags, _flags_2a);
 FOLIO_MATCH(compound_head, _head_2a);
-FOLIO_MATCH(private, _private_2a);
 #undef FOLIO_MATCH
 
 /**
--- a/include/linux/swap.h~mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap
+++ a/include/linux/swap.h
@@ -339,6 +339,15 @@ static inline swp_entry_t folio_swap_ent
 	return entry;
 }
 
+static inline swp_entry_t page_swap_entry(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+	swp_entry_t entry = folio_swap_entry(folio);
+
+	entry.val += page - &folio->page;
+	return entry;
+}
+
 static inline void folio_set_swap_entry(struct folio *folio, swp_entry_t entry)
 {
 	folio->private = (void *)entry.val;
--- a/mm/huge_memory.c~mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap
+++ a/mm/huge_memory.c
@@ -2446,18 +2446,15 @@ static void __split_huge_page_tail(struc
 	page_tail->index = head->index + tail;
 
 	/*
-	 * page->private should not be set in tail pages with the exception
-	 * of swap cache pages that store the swp_entry_t in tail pages.
-	 * Fix up and warn once if private is unexpectedly set.
-	 *
-	 * What of 32-bit systems, on which folio->_pincount overlays
-	 * head[1].private?  No problem: THP_SWAP is not enabled on 32-bit, and
-	 * pincount must be 0 for folio_ref_freeze() to have succeeded.
+	 * page->private should not be set in tail pages. Fix up and warn once
+	 * if private is unexpectedly set.
 	 */
-	if (!folio_test_swapcache(page_folio(head))) {
-		VM_WARN_ON_ONCE_PAGE(page_tail->private != 0, page_tail);
+	if (unlikely(page_tail->private)) {
+		VM_WARN_ON_ONCE_PAGE(true, page_tail);
 		page_tail->private = 0;
 	}
+	if (PageSwapCache(head))
+		set_page_private(page_tail, (unsigned long)head->private + tail);
 
 	/* Page flags must be visible before we make the page non-compound. */
 	smp_wmb();
--- a/mm/memory.c~mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap
+++ a/mm/memory.c
@@ -3882,7 +3882,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * changed.
 		 */
 		if (unlikely(!folio_test_swapcache(folio) ||
-			     page_private(page) != entry.val))
+			     page_swap_entry(page).val != entry.val))
 			goto out_page;
 
 		/*
--- a/mm/rmap.c~mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap
+++ a/mm/rmap.c
@@ -1647,7 +1647,7 @@ static bool try_to_unmap_one(struct foli
 			 */
 			dec_mm_counter(mm, mm_counter(&folio->page));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = { .val = page_private(subpage) };
+			swp_entry_t entry = page_swap_entry(subpage);
 			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
--- a/mm/swapfile.c~mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap
+++ a/mm/swapfile.c
@@ -3369,7 +3369,7 @@ struct swap_info_struct *swp_swap_info(s
 
 struct swap_info_struct *page_swap_info(struct page *page)
 {
-	swp_entry_t entry = { .val = page_private(page) };
+	swp_entry_t entry = page_swap_entry(page);
 	return swp_swap_info(entry);
 }
 
@@ -3384,7 +3384,7 @@ EXPORT_SYMBOL_GPL(swapcache_mapping);
 
 pgoff_t __page_file_index(struct page *page)
 {
-	swp_entry_t swap = { .val = page_private(page) };
+	swp_entry_t swap = page_swap_entry(page);
 	return swp_offset(swap);
 }
 EXPORT_SYMBOL_GPL(__page_file_index);
--- a/mm/swap_state.c~mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap
+++ a/mm/swap_state.c
@@ -100,6 +100,7 @@ int add_to_swap_cache(struct folio *foli
 
 	folio_ref_add(folio, nr);
 	folio_set_swapcache(folio);
+	folio_set_swap_entry(folio, entry);
 
 	do {
 		xas_lock_irq(&xas);
@@ -113,7 +114,6 @@ int add_to_swap_cache(struct folio *foli
 				if (shadowp)
 					*shadowp = old;
 			}
-			set_page_private(folio_page(folio, i), entry.val + i);
 			xas_store(&xas, folio);
 			xas_next(&xas);
 		}
@@ -154,9 +154,10 @@ void __delete_from_swap_cache(struct fol
 	for (i = 0; i < nr; i++) {
 		void *entry = xas_store(&xas, shadow);
 		VM_BUG_ON_PAGE(entry != folio, entry);
-		set_page_private(folio_page(folio, i), 0);
 		xas_next(&xas);
 	}
+	entry.val = 0;
+	folio_set_swap_entry(folio, entry);
 	folio_clear_swapcache(folio);
 	address_space->nrpages -= nr;
 	__node_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reintroduce-foll_numa-as-foll_honor_numa_fault.patch
smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd.patch
mm-gup-handle-cont-pte-hugetlb-pages-correctly-in-gup_must_unshare-via-gup-fast.patch
kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch
mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch
pgtable-improve-pte_protnone-comment.patch
selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch
selftest-mm-ksm_functional_tests-add-prot_none-test.patch
selftest-mm-ksm_functional_tests-add-prot_none-test-fix.patch
mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch
mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch
mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch

