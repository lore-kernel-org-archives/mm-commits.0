Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF6DCCA47C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiGDBMR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbiGDBLH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3625C63AA
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE5B612F5
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C150C341CB;
        Mon,  4 Jul 2022 01:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897043;
        bh=/qvWjhu06xXchJZIwPIViMxz2medXVVQXbHD1YD9+cs=;
        h=Date:To:From:Subject:From;
        b=rJSbeh1lNB8aiC13Owow7oL+MsiBarhE1dRyj4JGjzkoIne3sEVmQxbg0n7gozzoR
         5xaMoHq61g236Ja+NHaoGHAkSQoqR5Lwb1f9UHcznAxWx4dkbd0rPi5TpMRMDbc3fo
         SRvC3NAadXox1jdXgkwKKWphmFQ+US2kVhhwp/lI=
Date:   Sun, 03 Jul 2022 18:10:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch removed from -mm tree
Message-Id: <20220704011043.1C150C341CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert __delete_from_swap_cache() to a folio
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert __delete_from_swap_cache() to a folio
Date: Fri, 17 Jun 2022 18:50:20 +0100

All callers now have a folio, so convert the entire function to operate
on folios.

Link: https://lkml.kernel.org/r/20220617175020.717127-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    4 ++--
 mm/swap_state.c |   25 +++++++++++++------------
 mm/vmscan.c     |    2 +-
 3 files changed, 16 insertions(+), 15 deletions(-)

--- a/mm/swap.h~mm-swap-convert-__delete_from_swap_cache-to-a-folio
+++ a/mm/swap.h
@@ -36,7 +36,7 @@ bool add_to_swap(struct folio *folio);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
 int add_to_swap_cache(struct page *page, swp_entry_t entry,
 		      gfp_t gfp, void **shadowp);
-void __delete_from_swap_cache(struct page *page,
+void __delete_from_swap_cache(struct folio *folio,
 			      swp_entry_t entry, void *shadow);
 void delete_from_swap_cache(struct folio *folio);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
@@ -135,7 +135,7 @@ static inline int add_to_swap_cache(stru
 	return -1;
 }
 
-static inline void __delete_from_swap_cache(struct page *page,
+static inline void __delete_from_swap_cache(struct folio *folio,
 					swp_entry_t entry, void *shadow)
 {
 }
--- a/mm/swap_state.c~mm-swap-convert-__delete_from_swap_cache-to-a-folio
+++ a/mm/swap_state.c
@@ -133,31 +133,32 @@ unlock:
 }
 
 /*
- * This must be called only on pages that have
+ * This must be called only on folios that have
  * been verified to be in the swap cache.
  */
-void __delete_from_swap_cache(struct page *page,
+void __delete_from_swap_cache(struct folio *folio,
 			swp_entry_t entry, void *shadow)
 {
 	struct address_space *address_space = swap_address_space(entry);
-	int i, nr = thp_nr_pages(page);
+	int i;
+	long nr = folio_nr_pages(folio);
 	pgoff_t idx = swp_offset(entry);
 	XA_STATE(xas, &address_space->i_pages, idx);
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	VM_BUG_ON_PAGE(PageWriteback(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
 
 	for (i = 0; i < nr; i++) {
 		void *entry = xas_store(&xas, shadow);
-		VM_BUG_ON_PAGE(entry != page, entry);
-		set_page_private(page + i, 0);
+		VM_BUG_ON_FOLIO(entry != folio, folio);
+		set_page_private(folio_page(folio, i), 0);
 		xas_next(&xas);
 	}
-	ClearPageSwapCache(page);
+	folio_clear_swapcache(folio);
 	address_space->nrpages -= nr;
-	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
-	__mod_lruvec_page_state(page, NR_SWAPCACHE, -nr);
+	__node_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
+	__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
 }
 
 /**
@@ -233,7 +234,7 @@ void delete_from_swap_cache(struct folio
 	struct address_space *address_space = swap_address_space(entry);
 
 	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(&folio->page, entry, NULL);
+	__delete_from_swap_cache(folio, entry, NULL);
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_page(&folio->page, entry);
--- a/mm/vmscan.c~mm-swap-convert-__delete_from_swap_cache-to-a-folio
+++ a/mm/vmscan.c
@@ -1329,7 +1329,7 @@ static int __remove_mapping(struct addre
 		mem_cgroup_swapout(folio, swap);
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__delete_from_swap_cache(&folio->page, swap, shadow);
+		__delete_from_swap_cache(folio, swap, shadow);
 		xa_unlock_irq(&mapping->i_pages);
 		put_swap_page(&folio->page, swap);
 	} else {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mips-rename-pmd_order-to-pmd_table_order.patch

