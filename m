Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15A6C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbiDXUGX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiDXUGU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:06:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951241EC40
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:03:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 153A661313
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5BFC385A9;
        Sun, 24 Apr 2022 20:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650830597;
        bh=ImluHgGuarDJo5pLm5kzmLIZwJRlqN9ywUKcZz5Wp9s=;
        h=Date:To:From:Subject:From;
        b=WFvC0S8YVvDzBtDw5cYBaAuAAD4BC8C0MS7fvDOMLBNjkWRIV46RSYBr55dTbgE35
         4GRG75zza36aqu65uGAYtqwdHRFb5DIC8d2o5ZAuJjT3ednRMWXFC//Qjf8ceiSym5
         voQQ1AA7QVtzSOoRX8S6gbHP8Sc5/NYizxDwzvRQ=
Date:   Sun, 24 Apr 2022 13:03:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, sfr@canb.auug.org.au, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, minchan@kernel.org,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch added to -mm tree
Message-Id: <20220424200317.6B5BFC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     swap bits in unuse_pte()
has been added to the -mm tree.  Its filename is
     mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com> Subject: mm/swapfile: fix lost
swap bits in unuse_pte()

This is observed by code review only but not any real report.

When we turn off swapping we could have lost the bits stored in the swap
ptes.  The new rmap-exclusive bit is fine since that turned into a page
flag, but not for soft-dirty and uffd-wp.  Add them.

Link: https://lkml.kernel.org/r/20220424091105.48374-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-lost-swap-bits-in-unuse_pte
+++ a/mm/swapfile.c
@@ -1783,7 +1783,7 @@ static int unuse_pte(struct vm_area_stru
 {
 	struct page *swapcache;
 	spinlock_t *ptl;
-	pte_t *pte;
+	pte_t *pte, new_pte;
 	int ret = 1;
 
 	swapcache = page;
@@ -1832,8 +1832,12 @@ static int unuse_pte(struct vm_area_stru
 		page_add_new_anon_rmap(page, vma, addr);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	}
-	set_pte_at(vma->vm_mm, addr, pte,
-		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
+	new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
+	if (pte_swp_soft_dirty(*pte))
+		new_pte = pte_mksoft_dirty(new_pte);
+	if (pte_swp_uffd_wp(*pte))
+		new_pte = pte_mkuffd_wp(new_pte);
+	set_pte_at(vma->vm_mm, addr, pte, new_pte);
 	swap_free(entry);
 out:
 	pte_unmap_unlock(pte, ptl);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mmapc-use-helper-mlock_future_check.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mremap-avoid-unneeded-do_munmap-call.patch
mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch
mm-memory-failurec-dissolve-truncated-hugetlb-page.patch
mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch
mm-vmscan-fix-comment-for-current_may_throttle.patch
mm-vmscan-fix-comment-for-isolate_lru_pages.patch
mm-z3fold-declare-z3fold_mount-with-__init.patch
mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch
mm-z3fold-minor-clean-up-for-z3fold_free.patch
mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch
mm-z3fold-remove-confusing-local-variable-l-reassignment.patch
mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch
mm-z3fold-remove-redundant-list_del_init-of-zhdr-buddy-in-z3fold_free.patch
mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch
mm-compaction-use-helper-isolation_suitable.patch
drivers-base-nodec-fix-compaction-sysfs-file-leak.patch
mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch
mm-migration-remove-unneeded-local-variable-mapping_locked.patch
mm-migration-remove-unneeded-local-variable-page_lru.patch
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch
mm-madvise-fix-potential-pte_unmap_unlock-pte-error.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch
mm-compaction-remove-unneeded-pfn-update.patch
mm-compaction-remove-unneeded-assignment-to-isolate_start_pfn.patch
mm-compaction-clean-up-comment-for-sched-contention.patch
mm-compaction-clean-up-comment-about-suitable-migration-target-recheck.patch
mm-compaction-use-compact_cluster_max-in-compactionc.patch
mm-compaction-use-helper-compound_nr-in-isolate_migratepages_block.patch
mm-compaction-clean-up-comment-about-async-compaction-in-isolate_migratepages.patch
mm-compaction-avoid-possible-null-pointer-dereference-in-kcompactd_cpu_online.patch
mm-compaction-make-compaction_zonelist_suitable-return-false-when-compact_success.patch
mm-compaction-simplify-the-code-in-__compact_finished.patch
mm-compaction-make-sure-highest-is-above-the-min_pfn.patch
mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch

