Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57936C6FA82
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiIBX1d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiIBX1C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:27:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17C8FB2AC
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F30E61E2F
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B41C433D6;
        Fri,  2 Sep 2022 23:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161219;
        bh=KgTiKln5ux1RLO0K+K8lKYmyKZL4r1qq3mMyrNuRHAM=;
        h=Date:To:From:Subject:From;
        b=NDgo/ka5ybyhyFzDGY9E74FiH13qX/gWjjHn9fhGPmxhKIoUdbxygpmr/OxW4gOfb
         LT8fFkq93pRNs1zkmcxiyChrVksudBVx/LXB0rSlk8prJguxLrdY6Z6qAzVRZS6ttr
         M06RJ1VLPg4KtrnloDj99NJ5hZSe02378c8dUguQ=
Date:   Fri, 02 Sep 2022 16:26:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-add-shmem_get_folio.patch added to mm-unstable branch
Message-Id: <20220902232659.C7B41C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: add shmem_get_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-add-shmem_get_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-add-shmem_get_folio.patch

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
Subject: shmem: add shmem_get_folio()
Date: Fri, 2 Sep 2022 20:46:20 +0100

With no remaining callers of shmem_getpage_gfp(), add shmem_get_folio()
and reimplement shmem_getpage() as a call to shmem_get_folio().

Link: https://lkml.kernel.org/r/20220902194653.1739778-25-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 ++
 mm/shmem.c               |   23 ++++++++++-------------
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/include/linux/shmem_fs.h~shmem-add-shmem_get_folio
+++ a/include/linux/shmem_fs.h
@@ -113,6 +113,8 @@ enum sgp_type {
 
 extern int shmem_getpage(struct inode *inode, pgoff_t index,
 		struct page **pagep, enum sgp_type sgp);
+int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
+		enum sgp_type sgp);
 
 static inline struct page *shmem_read_mapping_page(
 				struct address_space *mapping, pgoff_t index)
--- a/mm/shmem.c~shmem-add-shmem_get_folio
+++ a/mm/shmem.c
@@ -2025,14 +2025,18 @@ unlock:
 	return error;
 }
 
-static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
-		struct page **pagep, enum sgp_type sgp,
-		gfp_t gfp, struct vm_area_struct *vma,
-		struct vm_fault *vmf, vm_fault_t *fault_type)
+int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
+		enum sgp_type sgp)
+{
+	return shmem_get_folio_gfp(inode, index, foliop, sgp,
+			mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
+}
+
+int shmem_getpage(struct inode *inode, pgoff_t index,
+		struct page **pagep, enum sgp_type sgp)
 {
 	struct folio *folio = NULL;
-	int ret = shmem_get_folio_gfp(inode, index, &folio, sgp, gfp, vma,
-			vmf, fault_type);
+	int ret = shmem_get_folio(inode, index, &folio, sgp);
 
 	if (folio)
 		*pagep = folio_file_page(folio, index);
@@ -2041,13 +2045,6 @@ static int shmem_getpage_gfp(struct inod
 	return ret;
 }
 
-int shmem_getpage(struct inode *inode, pgoff_t index,
-		struct page **pagep, enum sgp_type sgp)
-{
-	return shmem_getpage_gfp(inode, index, pagep, sgp,
-		mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
-}
-
 /*
  * This is like autoremove_wake_function, but it removes the wait queue
  * entry unconditionally - even if something else had already woken the
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

