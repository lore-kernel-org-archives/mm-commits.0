Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D169C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380576AbiD2UOT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380559AbiD2UOC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:14:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16557140C0
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48FA160EDC
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBAAC385A4;
        Fri, 29 Apr 2022 20:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263028;
        bh=8/q8jPVjJUGUACO9x0YPLAAGaIB2jnXQeXztHAwSvxo=;
        h=Date:To:From:Subject:From;
        b=Z+QhfYsWGTt9bJWk6Aw8+kCqYhzPouLmxkbtMaR5YkwajbaivliPqa22m+4sNMVjK
         yTTe0xpvszCYiuliK33bss7Ya5TZZd/w6Wvd2C2rtWMYMU47uqSM25gSumveYviIcH
         uy5wuxJhhUpHrKhuvl1ncn4Ly4LV2Bza7a51akmQ=
Date:   Fri, 29 Apr 2022 13:10:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-convert-lazy-freeing-to-folios.patch added to mm-unstable branch
Message-Id: <20220429201028.9DBAAC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: convert lazy freeing to folios
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-convert-lazy-freeing-to-folios.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: vmscan: convert lazy freeing to folios

Remove a hidden call to compound_head(), and account nr_pages instead of a
single page.  This matches the code in lru_lazyfree_fn() that accounts
nr_pages to PGLAZYFREE.

Link: https://lkml.kernel.org/r/20220429192329.3034378-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 ++++++++++++++
 mm/vmscan.c                |   18 +++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

--- a/include/linux/memcontrol.h~vmscan-convert-lazy-freeing-to-folios
+++ a/include/linux/memcontrol.h
@@ -1057,6 +1057,15 @@ static inline void count_memcg_page_even
 		count_memcg_events(memcg, idx, 1);
 }
 
+static inline void count_memcg_folio_events(struct folio *folio,
+		enum vm_event_item idx, unsigned long nr)
+{
+	struct mem_cgroup *memcg = folio_memcg(folio);
+
+	if (memcg)
+		count_memcg_events(memcg, idx, nr);
+}
+
 static inline void count_memcg_event_mm(struct mm_struct *mm,
 					enum vm_event_item idx)
 {
@@ -1494,6 +1503,11 @@ static inline void count_memcg_page_even
 {
 }
 
+static inline void count_memcg_folio_events(struct folio *folio,
+		enum vm_event_item idx, unsigned long nr)
+{
+}
+
 static inline
 void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
--- a/mm/vmscan.c~vmscan-convert-lazy-freeing-to-folios
+++ a/mm/vmscan.c
@@ -1902,20 +1902,20 @@ retry:
 			}
 		}
 
-		if (PageAnon(page) && !PageSwapBacked(page)) {
+		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
 			/* follow __remove_mapping for reference */
-			if (!page_ref_freeze(page, 1))
+			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
 			/*
-			 * The page has only one reference left, which is
+			 * The folio has only one reference left, which is
 			 * from the isolation. After the caller puts the
-			 * page back on lru and drops the reference, the
-			 * page will be freed anyway. It doesn't matter
-			 * which lru it goes. So we don't bother checking
-			 * PageDirty here.
+			 * folio back on the lru and drops the reference, the
+			 * folio will be freed anyway. It doesn't matter
+			 * which lru it goes on. So we don't bother checking
+			 * the dirty flag here.
 			 */
-			count_vm_event(PGLAZYFREED);
-			count_memcg_page_event(page, PGLAZYFREED);
+			count_vm_events(PGLAZYFREED, nr_pages);
+			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
 		} else if (!mapping || !__remove_mapping(mapping, folio, true,
 							 sc->target_mem_cgroup))
 			goto keep_locked;
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
mm-remove-alloc_pages_vma.patch
vmscan-use-folio_mapped-in-shrink_page_list.patch
vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
swap-turn-get_swap_page-into-folio_alloc_swap.patch
swap-convert-add_to_swap-to-take-a-folio.patch
vmscan-convert-dirty-page-handling-to-folios.patch
vmscan-convert-page-buffer-handling-to-use-folios.patch
vmscan-convert-lazy-freeing-to-folios.patch
vmscan-move-initialisation-of-mapping-down.patch
vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-turn-shmem_alloc_page-into-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch
vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch
vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

