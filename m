Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DD1C6FA82
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiIBX3C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiIBX2I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:28:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B58FBA6C
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08D8CB82E02
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB347C433D7;
        Fri,  2 Sep 2022 23:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161281;
        bh=Dnas6tVC3wqgfJN3yvvlztj0yFnxJwiQ+ozRoT9HT5Q=;
        h=Date:To:From:Subject:From;
        b=HtWqP4vWtQHU2lPGGQa8dn7bBHVTu0HWYd7/sr2b90Ieoj8+cnIfs4R8gVk/biniZ
         87WFynF/2s0GJax54o7WVJW4c14m9Qu7NZbYTAzbcmrbKkv3aril5kpS7S+xiYvmFl
         gl7ie4wLPOBMk8JJBaqiEzBQN+0suAdlQvmvungE=
Date:   Fri, 02 Sep 2022 16:28:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch added to mm-unstable branch
Message-Id: <20220902232801.AB347C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page_get_anon_vma() to folio_get_anon_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch

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
Subject: mm: convert page_get_anon_vma() to folio_get_anon_vma()
Date: Fri, 2 Sep 2022 20:46:50 +0100

With all callers now passing in a folio, rename the function and convert
all callers.  Removes a couple of calls to compound_head() and a reference
to page->mapping.

Link: https://lkml.kernel.org/r/20220902194653.1739778-55-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/huge_memory.c     |    2 +-
 mm/migrate.c         |    6 +++---
 mm/rmap.c            |   14 +++++++-------
 4 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/rmap.h~mm-convert-page_get_anon_vma-to-folio_get_anon_vma
+++ a/include/linux/rmap.h
@@ -163,7 +163,7 @@ static inline void anon_vma_merge(struct
 	unlink_anon_vmas(next);
 }
 
-struct anon_vma *page_get_anon_vma(struct page *page);
+struct anon_vma *folio_get_anon_vma(struct folio *folio);
 
 /* RMAP flags, currently only relevant for some anon rmap operations. */
 typedef int __bitwise rmap_t;
--- a/mm/huge_memory.c~mm-convert-page_get_anon_vma-to-folio_get_anon_vma
+++ a/mm/huge_memory.c
@@ -2649,7 +2649,7 @@ int split_huge_page_to_list(struct page
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = page_get_anon_vma(&folio->page);
+		anon_vma = folio_get_anon_vma(folio);
 		if (!anon_vma) {
 			ret = -EBUSY;
 			goto out;
--- a/mm/migrate.c~mm-convert-page_get_anon_vma-to-folio_get_anon_vma
+++ a/mm/migrate.c
@@ -1052,14 +1052,14 @@ static int __unmap_and_move(struct folio
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
 	 *
-	 * Only page_get_anon_vma() understands the subtleties of
+	 * Only folio_get_anon_vma() understands the subtleties of
 	 * getting a hold on an anon_vma from outside one of its mms.
 	 * But if we cannot get anon_vma, then we won't need it anyway,
 	 * because that implies that the anon page is no longer mapped
 	 * (and cannot be remapped so long as we hold the page lock).
 	 */
 	if (folio_test_anon(src) && !folio_test_ksm(src))
-		anon_vma = page_get_anon_vma(&src->page);
+		anon_vma = folio_get_anon_vma(src);
 
 	/*
 	 * Block others from accessing the new page when we get around to
@@ -1298,7 +1298,7 @@ static int unmap_and_move_huge_page(new_
 	}
 
 	if (folio_test_anon(src))
-		anon_vma = page_get_anon_vma(&src->page);
+		anon_vma = folio_get_anon_vma(src);
 
 	if (unlikely(!folio_trylock(dst)))
 		goto put_anon;
--- a/mm/rmap.c~mm-convert-page_get_anon_vma-to-folio_get_anon_vma
+++ a/mm/rmap.c
@@ -486,16 +486,16 @@ void __init anon_vma_init(void)
  * if there is a mapcount, we can dereference the anon_vma after observing
  * those.
  */
-struct anon_vma *page_get_anon_vma(struct page *page)
+struct anon_vma *folio_get_anon_vma(struct folio *folio)
 {
 	struct anon_vma *anon_vma = NULL;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
-	anon_mapping = (unsigned long)READ_ONCE(page->mapping);
+	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
-	if (!page_mapped(page))
+	if (!folio_mapped(folio))
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
@@ -505,13 +505,13 @@ struct anon_vma *page_get_anon_vma(struc
 	}
 
 	/*
-	 * If this page is still mapped, then its anon_vma cannot have been
+	 * If this folio is still mapped, then its anon_vma cannot have been
 	 * freed.  But if it has been unmapped, we have no security against the
 	 * anon_vma structure being freed and reused (for another anon_vma:
 	 * SLAB_TYPESAFE_BY_RCU guarantees that - so the atomic_inc_not_zero()
 	 * above cannot corrupt).
 	 */
-	if (!page_mapped(page)) {
+	if (!folio_mapped(folio)) {
 		rcu_read_unlock();
 		put_anon_vma(anon_vma);
 		return NULL;
@@ -523,11 +523,11 @@ out:
 }
 
 /*
- * Similar to page_get_anon_vma() except it locks the anon_vma.
+ * Similar to folio_get_anon_vma() except it locks the anon_vma.
  *
  * Its a little more complex as it tries to keep the fast path to a single
  * atomic op -- the trylock. If we fail the trylock, we fall back to getting a
- * reference like with page_get_anon_vma() and then block on the mutex
+ * reference like with folio_get_anon_vma() and then block on the mutex
  * on !rwc->try_lock case.
  */
 struct anon_vma *folio_lock_anon_vma_read(struct folio *folio,
_

Patches currently in -mm which might be from willy@infradead.org are

tools-fix-compilation-after-gfp_typesh-split.patch
mm-fix-vm_bug_on-in-__delete_from_swap_cache.patch
vmscan-check-folio_test_private-not-folio_get_private.patch
support-highmem-pages-in-vmap_pages_range_noflush.patch
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
mm-vmscan-fix-a-lot-of-comments.patch
mm-add-the-first-tail-page-to-struct-folio.patch
mm-reimplement-folio_order-and-folio_nr_pages.patch
mm-add-split_folio.patch
mm-add-folio_add_lru_vma.patch
shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch
shmem-convert-shmem_delete_from_page_cache-to-take-a-folio.patch
shmem-convert-shmem_replace_page-to-use-folios-throughout.patch
mm-swapfile-remove-page_swapcount.patch
mm-swapfile-convert-try_to_free_swap-to-folio_free_swap.patch
mm-swap-convert-__read_swap_cache_async-to-use-a-folio.patch
mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch
mm-swap-convert-put_swap_page-to-put_swap_folio.patch
mm-convert-do_swap_page-to-use-a-folio.patch
mm-convert-do_swap_pages-swapcache-variable-to-a-folio.patch
memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch
shmem-convert-shmem_mfill_atomic_pte-to-use-a-folio.patch
shmem-convert-shmem_replace_page-to-shmem_replace_folio.patch
swap-add-swap_cache_get_folio.patch
shmem-eliminate-struct-page-from-shmem_swapin_folio.patch
shmem-convert-shmem_getpage_gfp-to-shmem_get_folio_gfp.patch
shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp.patch
shmem-convert-shmem_read_mapping_page_gfp-to-use-shmem_get_folio_gfp.patch
shmem-add-shmem_get_folio.patch
shmem-convert-shmem_get_partial_folio-to-use-shmem_get_folio.patch
shmem-convert-shmem_write_begin-to-use-shmem_get_folio.patch
shmem-convert-shmem_file_read_iter-to-use-shmem_get_folio.patch
shmem-convert-shmem_fallocate-to-use-a-folio.patch
shmem-convert-shmem_symlink-to-use-a-folio.patch
shmem-convert-shmem_get_link-to-use-a-folio.patch
khugepaged-call-shmem_get_folio.patch
userfaultfd-convert-mcontinue_atomic_pte-to-use-a-folio.patch
shmem-remove-shmem_getpage.patch
swapfile-convert-try_to_unuse-to-use-a-folio.patch
swapfile-convert-__try_to_reclaim_swap-to-use-a-folio.patch
swapfile-convert-unuse_pte_range-to-use-a-folio.patch
mm-convert-do_swap_page-to-use-swap_cache_get_folio.patch
mm-remove-lookup_swap_cache.patch
swap_state-convert-free_swap_cache-to-use-a-folio.patch
swap-convert-swap_writepage-to-use-a-folio.patch
mm-convert-do_wp_page-to-use-a-folio.patch
huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch
madvise-convert-madvise_free_pte_range-to-use-a-folio.patch
uprobes-use-folios-more-widely-in-__replace_page.patch
ksm-use-a-folio-in-replace_page.patch
mm-convert-do_swap_page-to-use-folio_free_swap.patch
memcg-convert-mem_cgroup_swap_full-to-take-a-folio.patch
mm-remove-try_to_free_swap.patch
rmap-convert-page_move_anon_rmap-to-use-a-folio.patch
migrate-convert-__unmap_and_move-to-use-folios.patch
migrate-convert-unmap_and_move_huge_page-to-use-folios.patch
huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch
huge_memory-convert-unmap_page-to-unmap_folio.patch
mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch
rmap-remove-page_unlock_anon_vma_read.patch
uprobes-use-new_folio-in-__replace_page.patch
mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch

