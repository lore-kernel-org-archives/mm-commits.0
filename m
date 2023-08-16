Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62144C27C6E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346905AbjHPWnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346835AbjHPWnT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:43:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC42173F
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:43:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3174A602F9
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BFAC433C8;
        Wed, 16 Aug 2023 22:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692225795;
        bh=OUNTzp10HFvqFgBQT1Brg4Ns91qEKvPKJ505T/VHRlw=;
        h=Date:To:From:Subject:From;
        b=z9NrVyy9Nz2nUsM8+iyTcAdaFL5YoAgQ+QuFlBKw3i5tc9vDRvSBbJ1oOnemvuvOT
         bWVHYnvemxDtFiVse5k5yiEYfiw4vmPcm4hqbtAwhTgHPhf8f9H2IimmtHVqBYF+GK
         wpW8iGoLygzF8ED6IXC3ymBdRhOwyp/kL92MRMvA=
Date:   Wed, 16 Aug 2023 15:43:14 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-free_huge_page-to-free_huge_folio.patch added to mm-unstable branch
Message-Id: <20230816224315.89BFAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert free_huge_page() to free_huge_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-free_huge_page-to-free_huge_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-free_huge_page-to-free_huge_folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert free_huge_page() to free_huge_folio()
Date: Wed, 16 Aug 2023 16:11:51 +0100

Pass a folio instead of the head page to save a few instructions.  Update
the documentation, at least in English.

Link: https://lkml.kernel.org/r/20230816151201.3655946-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/hugetlbfs_reserv.rst                    |   14 +-
 Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst |    4 
 include/linux/hugetlb.h                                  |    2 
 mm/hugetlb.c                                             |   48 ++++------
 mm/page_alloc.c                                          |    2 
 5 files changed, 34 insertions(+), 36 deletions(-)

--- a/Documentation/mm/hugetlbfs_reserv.rst~mm-convert-free_huge_page-to-free_huge_folio
+++ a/Documentation/mm/hugetlbfs_reserv.rst
@@ -271,12 +271,12 @@ to the global reservation count (resv_hu
 Freeing Huge Pages
 ==================
 
-Huge page freeing is performed by the routine free_huge_page().  This routine
-is the destructor for hugetlbfs compound pages.  As a result, it is only
-passed a pointer to the page struct.  When a huge page is freed, reservation
-accounting may need to be performed.  This would be the case if the page was
-associated with a subpool that contained reserves, or the page is being freed
-on an error path where a global reserve count must be restored.
+Huge pages are freed by free_huge_folio().  It is only passed a pointer
+to the folio as it is called from the generic MM code.  When a huge page
+is freed, reservation accounting may need to be performed.  This would
+be the case if the page was associated with a subpool that contained
+reserves, or the page is being freed on an error path where a global
+reserve count must be restored.
 
 The page->private field points to any subpool associated with the page.
 If the PagePrivate flag is set, it indicates the global reserve count should
@@ -525,7 +525,7 @@ However, there are several instances whe
 page is allocated but before it is instantiated.  In this case, the page
 allocation has consumed the reservation and made the appropriate subpool,
 reservation map and global count adjustments.  If the page is freed at this
-time (before instantiation and clearing of PagePrivate), then free_huge_page
+time (before instantiation and clearing of PagePrivate), then free_huge_folio
 will increment the global reservation count.  However, the reservation map
 indicates the reservation was consumed.  This resulting inconsistent state
 will cause the 'leak' of a reserved huge page.  The global reserve count will
--- a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst~mm-convert-free_huge_page-to-free_huge_folio
+++ a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
@@ -219,7 +219,7 @@ 当一个已经实例化的巨页被释�
 释放巨页
 ========
 
-巨页释放是由函数free_huge_page()执行的。这个函数是hugetlbfs复合页的析构器。因此，它只传
+巨页释放是由函数free_huge_folio()执行的。这个函数是hugetlbfs复合页的析构器。因此，它只传
 递一个指向页面结构体的指针。当一个巨页被释放时，可能需要进行预留计算。如果该页与包含保
 留的子池相关联，或者该页在错误路径上被释放，必须恢复全局预留计数，就会出现这种情况。
 
@@ -387,7 +387,7 @@ 正确的。
 
 然而，有几种情况是，在一个巨页被分配后，但在它被实例化之前，就遇到了错误。在这种情况下，
 页面分配已经消耗了预留，并进行了适当的子池、预留映射和全局计数调整。如果页面在这个时候被释放
-（在实例化和清除PagePrivate之前），那么free_huge_page将增加全局预留计数。然而，预留映射
+（在实例化和清除PagePrivate之前），那么free_huge_folio将增加全局预留计数。然而，预留映射
 显示报留被消耗了。这种不一致的状态将导致预留的巨页的 “泄漏” 。全局预留计数将比它原本的要高，
 并阻止分配一个预先分配的页面。
 
--- a/include/linux/hugetlb.h~mm-convert-free_huge_page-to-free_huge_folio
+++ a/include/linux/hugetlb.h
@@ -26,7 +26,7 @@ typedef struct { unsigned long pd; } hug
 #define __hugepd(x) ((hugepd_t) { (x) })
 #endif
 
-void free_huge_page(struct page *page);
+void free_huge_folio(struct folio *folio);
 
 #ifdef CONFIG_HUGETLB_PAGE
 
--- a/mm/hugetlb.c~mm-convert-free_huge_page-to-free_huge_folio
+++ a/mm/hugetlb.c
@@ -1706,10 +1706,10 @@ static void add_hugetlb_folio(struct hst
 	zeroed = folio_put_testzero(folio);
 	if (unlikely(!zeroed))
 		/*
-		 * It is VERY unlikely soneone else has taken a ref on
-		 * the page.  In this case, we simply return as the
-		 * hugetlb destructor (free_huge_page) will be called
-		 * when this other ref is dropped.
+		 * It is VERY unlikely soneone else has taken a ref
+		 * on the folio.  In this case, we simply return as
+		 * free_huge_folio() will be called when this other ref
+		 * is dropped.
 		 */
 		return;
 
@@ -1875,13 +1875,12 @@ struct hstate *size_to_hstate(unsigned l
 	return NULL;
 }
 
-void free_huge_page(struct page *page)
+void free_huge_folio(struct folio *folio)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
 	 * compound page destructor.
 	 */
-	struct folio *folio = page_folio(page);
 	struct hstate *h = folio_hstate(folio);
 	int nid = folio_nid(folio);
 	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
@@ -1936,7 +1935,7 @@ void free_huge_page(struct page *page)
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
-		arch_clear_hugepage_flags(page);
+		arch_clear_hugepage_flags(&folio->page);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
@@ -2246,7 +2245,7 @@ static int alloc_pool_huge_page(struct h
 		folio = alloc_fresh_hugetlb_folio(h, gfp_mask, node,
 					nodes_allowed, node_alloc_noretry);
 		if (folio) {
-			free_huge_page(&folio->page); /* free it into the hugepage allocator */
+			free_huge_folio(folio); /* free it into the hugepage allocator */
 			return 1;
 		}
 	}
@@ -2429,13 +2428,13 @@ static struct folio *alloc_surplus_huget
 	 * We could have raced with the pool size change.
 	 * Double check that and simply deallocate the new page
 	 * if we would end up overcommiting the surpluses. Abuse
-	 * temporary page to workaround the nasty free_huge_page
+	 * temporary page to workaround the nasty free_huge_folio
 	 * codeflow
 	 */
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		folio_set_hugetlb_temporary(folio);
 		spin_unlock_irq(&hugetlb_lock);
-		free_huge_page(&folio->page);
+		free_huge_folio(folio);
 		return NULL;
 	}
 
@@ -2547,8 +2546,7 @@ static int gather_surplus_pages(struct h
 	__must_hold(&hugetlb_lock)
 {
 	LIST_HEAD(surplus_list);
-	struct folio *folio;
-	struct page *page, *tmp;
+	struct folio *folio, *tmp;
 	int ret;
 	long i;
 	long needed, allocated;
@@ -2608,21 +2606,21 @@ retry:
 	ret = 0;
 
 	/* Free the needed pages to the hugetlb pool */
-	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
 		if ((--needed) < 0)
 			break;
 		/* Add the page to the hugetlb allocator */
-		enqueue_hugetlb_folio(h, page_folio(page));
+		enqueue_hugetlb_folio(h, folio);
 	}
 free:
 	spin_unlock_irq(&hugetlb_lock);
 
 	/*
 	 * Free unnecessary surplus pages to the buddy allocator.
-	 * Pages have no ref count, call free_huge_page directly.
+	 * Pages have no ref count, call free_huge_folio directly.
 	 */
-	list_for_each_entry_safe(page, tmp, &surplus_list, lru)
-		free_huge_page(page);
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
+		free_huge_folio(folio);
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
@@ -2836,11 +2834,11 @@ static long vma_del_reservation(struct h
  * 2) No reservation was in place for the page, so hugetlb_restore_reserve is
  *    not set.  However, alloc_hugetlb_folio always updates the reserve map.
  *
- * In case 1, free_huge_page later in the error path will increment the
- * global reserve count.  But, free_huge_page does not have enough context
+ * In case 1, free_huge_folio later in the error path will increment the
+ * global reserve count.  But, free_huge_folio does not have enough context
  * to adjust the reservation map.  This case deals primarily with private
  * mappings.  Adjust the reserve map here to be consistent with global
- * reserve count adjustments to be made by free_huge_page.  Make sure the
+ * reserve count adjustments to be made by free_huge_folio.  Make sure the
  * reserve map indicates there is a reservation present.
  *
  * In case 2, simply undo reserve map modifications done by alloc_hugetlb_folio.
@@ -2856,7 +2854,7 @@ void restore_reserve_on_error(struct hst
 			 * Rare out of memory condition in reserve map
 			 * manipulation.  Clear hugetlb_restore_reserve so
 			 * that global reserve count will not be incremented
-			 * by free_huge_page.  This will make it appear
+			 * by free_huge_folio.  This will make it appear
 			 * as though the reservation for this folio was
 			 * consumed.  This may prevent the task from
 			 * faulting in the folio at a later time.  This
@@ -3232,7 +3230,7 @@ static void __init gather_bootmem_preall
 		if (prep_compound_gigantic_folio(folio, huge_page_order(h))) {
 			WARN_ON(folio_test_reserved(folio));
 			prep_new_hugetlb_folio(h, folio, folio_nid(folio));
-			free_huge_page(page); /* add to the hugepage allocator */
+			free_huge_folio(folio); /* add to the hugepage allocator */
 		} else {
 			/* VERY unlikely inflated ref count on a tail page */
 			free_gigantic_folio(folio, huge_page_order(h));
@@ -3264,7 +3262,7 @@ static void __init hugetlb_hstate_alloc_
 					&node_states[N_MEMORY], NULL);
 			if (!folio)
 				break;
-			free_huge_page(&folio->page); /* free it into the hugepage allocator */
+			free_huge_folio(folio); /* free it into the hugepage allocator */
 		}
 		cond_resched();
 	}
@@ -3542,7 +3540,7 @@ static int set_max_huge_pages(struct hst
 	while (count > persistent_huge_pages(h)) {
 		/*
 		 * If this allocation races such that we no longer need the
-		 * page, free_huge_page will handle it by freeing the page
+		 * page, free_huge_folio will handle it by freeing the page
 		 * and reducing the surplus.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
@@ -3658,7 +3656,7 @@ static int demote_free_hugetlb_folio(str
 			prep_compound_page(subpage, target_hstate->order);
 		folio_change_private(inner_folio, NULL);
 		prep_new_hugetlb_folio(target_hstate, inner_folio, nid);
-		free_huge_page(subpage);
+		free_huge_folio(inner_folio);
 	}
 	mutex_unlock(&target_hstate->resize_lock);
 
--- a/mm/page_alloc.c~mm-convert-free_huge_page-to-free_huge_folio
+++ a/mm/page_alloc.c
@@ -610,7 +610,7 @@ void destroy_large_folio(struct folio *f
 	enum compound_dtor_id dtor = folio->_folio_dtor;
 
 	if (folio_test_hugetlb(folio)) {
-		free_huge_page(&folio->page);
+		free_huge_folio(folio);
 		return;
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch
mm-allow-fault_dirty_shared_page-to-be-called-under-the-vma-lock.patch
io_uring-stop-calling-free_compound_page.patch
mm-call-free_huge_page-directly.patch
mm-convert-free_huge_page-to-free_huge_folio.patch
mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch
mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch
mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch
mm-remove-hugetlb_page_dtor.patch
mm-add-large_rmappable-page-flag.patch
mm-rearrange-page-flags.patch
mm-free-up-a-word-in-the-first-tail-page.patch
mm-remove-folio_test_transhuge.patch
mm-add-tail-private-fields-to-struct-folio.patch
mm-convert-split_huge_pages_pid-to-use-a-folio.patch

