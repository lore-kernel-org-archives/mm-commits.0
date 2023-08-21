Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4118EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 17:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbjHURfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 13:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236614AbjHURfV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 13:35:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2885123
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 10:35:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FE9E640DE
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 17:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BA8C433CA;
        Mon, 21 Aug 2023 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692639308;
        bh=ybO/M7+kpeYrubr9YUEJW+9qqV9YxMlLtnYRlIRHG7g=;
        h=Date:To:From:Subject:From;
        b=Eb7ssXsHDQhnOiSDPcjNoiTqj6BdKMKoqEclNZPlWbyJVTu65V2hPD3LLTP+wywaB
         92kRs7o7ezwWNGZg9PGx4dOt2XPBhdlk9vstJzJBogi+fwo+jbQta+1FZlfKZJCSIj
         qQTdXGx7DzfomRTsa+j+80QhJcmI/fkuAJ3SYZ2s=
Date:   Mon, 21 Aug 2023 10:35:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com, peterx@redhat.com,
        hughd@google.com, ddstreet@ieee.org, catalin.marinas@arm.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch added to mm-unstable branch
Message-Id: <20230821173508.C1BA8C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: inline folio_set_swap_entry() and folio_swap_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch

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
Subject: mm/swap: inline folio_set_swap_entry() and folio_swap_entry()
Date: Mon, 21 Aug 2023 18:08:48 +0200

Let's simply work on the folio directly and remove the helpers.

Link: https://lkml.kernel.org/r/20230821160849.531668-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   12 +-----------
 mm/memory.c          |    2 +-
 mm/shmem.c           |    6 +++---
 mm/swap_state.c      |    7 +++----
 mm/swapfile.c        |    2 +-
 mm/util.c            |    2 +-
 mm/vmscan.c          |    2 +-
 mm/zswap.c           |    4 ++--
 8 files changed, 13 insertions(+), 24 deletions(-)

--- a/include/linux/swap.h~mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry
+++ a/include/linux/swap.h
@@ -333,25 +333,15 @@ struct swap_info_struct {
 					   */
 };
 
-static inline swp_entry_t folio_swap_entry(struct folio *folio)
-{
-	return folio->swap;
-}
-
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);
-	swp_entry_t entry = folio_swap_entry(folio);
+	swp_entry_t entry = folio->swap;
 
 	entry.val += page - &folio->page;
 	return entry;
 }
 
-static inline void folio_set_swap_entry(struct folio *folio, swp_entry_t entry)
-{
-	folio->swap = entry;
-}
-
 /* linux/mm/workingset.c */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset);
 void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
--- a/mm/memory.c~mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry
+++ a/mm/memory.c
@@ -3831,7 +3831,7 @@ vm_fault_t do_swap_page(struct vm_fault
 				folio_add_lru(folio);
 
 				/* To provide entry to swap_readpage() */
-				folio_set_swap_entry(folio, entry);
+				folio->swap = entry;
 				swap_readpage(page, true, NULL);
 				folio->private = NULL;
 			}
--- a/mm/shmem.c~mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry
+++ a/mm/shmem.c
@@ -1657,7 +1657,7 @@ static int shmem_replace_folio(struct fo
 	int error;
 
 	old = *foliop;
-	entry = folio_swap_entry(old);
+	entry = old->swap;
 	swap_index = swp_offset(entry);
 	swap_mapping = swap_address_space(entry);
 
@@ -1678,7 +1678,7 @@ static int shmem_replace_folio(struct fo
 	__folio_set_locked(new);
 	__folio_set_swapbacked(new);
 	folio_mark_uptodate(new);
-	folio_set_swap_entry(new, entry);
+	new->swap = entry;
 	folio_set_swapcache(new);
 
 	/*
@@ -1800,7 +1800,7 @@ static int shmem_swapin_folio(struct ino
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
-	    folio_swap_entry(folio).val != swap.val ||
+	    folio->swap.val != swap.val ||
 	    !shmem_confirm_swap(mapping, index, swap)) {
 		error = -EEXIST;
 		goto unlock;
--- a/mm/swapfile.c~mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry
+++ a/mm/swapfile.c
@@ -1536,7 +1536,7 @@ unlock_out:
 
 static bool folio_swapped(struct folio *folio)
 {
-	swp_entry_t entry = folio_swap_entry(folio);
+	swp_entry_t entry = folio->swap;
 	struct swap_info_struct *si = _swap_info_get(entry);
 
 	if (!si)
--- a/mm/swap_state.c~mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry
+++ a/mm/swap_state.c
@@ -100,7 +100,7 @@ int add_to_swap_cache(struct folio *foli
 
 	folio_ref_add(folio, nr);
 	folio_set_swapcache(folio);
-	folio_set_swap_entry(folio, entry);
+	folio->swap = entry;
 
 	do {
 		xas_lock_irq(&xas);
@@ -156,8 +156,7 @@ void __delete_from_swap_cache(struct fol
 		VM_BUG_ON_PAGE(entry != folio, entry);
 		xas_next(&xas);
 	}
-	entry.val = 0;
-	folio_set_swap_entry(folio, entry);
+	folio->swap.val = 0;
 	folio_clear_swapcache(folio);
 	address_space->nrpages -= nr;
 	__node_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
@@ -233,7 +232,7 @@ fail:
  */
 void delete_from_swap_cache(struct folio *folio)
 {
-	swp_entry_t entry = folio_swap_entry(folio);
+	swp_entry_t entry = folio->swap;
 	struct address_space *address_space = swap_address_space(entry);
 
 	xa_lock_irq(&address_space->i_pages);
--- a/mm/util.c~mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry
+++ a/mm/util.c
@@ -764,7 +764,7 @@ struct address_space *folio_mapping(stru
 		return NULL;
 
 	if (unlikely(folio_test_swapcache(folio)))
-		return swap_address_space(folio_swap_entry(folio));
+		return swap_address_space(folio->swap);
 
 	mapping = folio->mapping;
 	if ((unsigned long)mapping & PAGE_MAPPING_FLAGS)
--- a/mm/vmscan.c~mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry
+++ a/mm/vmscan.c
@@ -1423,7 +1423,7 @@ static int __remove_mapping(struct addre
 	}
 
 	if (folio_test_swapcache(folio)) {
-		swp_entry_t swap = folio_swap_entry(folio);
+		swp_entry_t swap = folio->swap;
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
--- a/mm/zswap.c~mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry
+++ a/mm/zswap.c
@@ -1190,7 +1190,7 @@ static void zswap_fill_page(void *ptr, u
 
 bool zswap_store(struct folio *folio)
 {
-	swp_entry_t swp = folio_swap_entry(folio);
+	swp_entry_t swp = folio->swap;
 	int type = swp_type(swp);
 	pgoff_t offset = swp_offset(swp);
 	struct page *page = &folio->page;
@@ -1370,7 +1370,7 @@ shrink:
 
 bool zswap_load(struct folio *folio)
 {
-	swp_entry_t swp = folio_swap_entry(folio);
+	swp_entry_t swp = folio->swap;
 	int type = swp_type(swp);
 	pgoff_t offset = swp_offset(swp);
 	struct page *page = &folio->page;
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

