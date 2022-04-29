Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78913C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380558AbiD2UOL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380557AbiD2UOC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:14:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1608214015
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F324B837B8
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60CDC385A7;
        Fri, 29 Apr 2022 20:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263026;
        bh=+0Dv/sCNaQEHRlC8bnJjSae/V6//OEAmMhi59ee6sBc=;
        h=Date:To:From:Subject:From;
        b=0i2ArdgB0EMsRMiDUb31pjiBy0YKRx+QL0fuE92LTmlbMNy4Ul9jsfG5X2lBgTp42
         KGmTRHB1xb/gH2fmMetPlYaYepzXDEmf+GNbEZS7HIfpjUovtvcMa4keDZ69h+GBIt
         eMRLUKrQV/+mCRy/vhaLEWL47b2TutCoVQOs1M3w=
Date:   Fri, 29 Apr 2022 13:10:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-convert-page-buffer-handling-to-use-folios.patch added to mm-unstable branch
Message-Id: <20220429201026.C60CDC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: convert page buffer handling to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-convert-page-buffer-handling-to-use-folios.patch

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
Subject: vmscan: convert page buffer handling to use folios

This mostly just removes calls to compound_head() although nr_reclaimed
should be incremented by the number of pages, not just 1.

Link: https://lkml.kernel.org/r/20220429192329.3034378-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

--- a/mm/vmscan.c~vmscan-convert-page-buffer-handling-to-use-folios
+++ a/mm/vmscan.c
@@ -1859,38 +1859,40 @@ retry:
 		}
 
 		/*
-		 * If the page has buffers, try to free the buffer mappings
-		 * associated with this page. If we succeed we try to free
-		 * the page as well.
+		 * If the folio has buffers, try to free the buffer
+		 * mappings associated with this folio. If we succeed
+		 * we try to free the folio as well.
 		 *
-		 * We do this even if the page is PageDirty().
-		 * try_to_release_page() does not perform I/O, but it is
-		 * possible for a page to have PageDirty set, but it is actually
-		 * clean (all its buffers are clean).  This happens if the
-		 * buffers were written out directly, with submit_bh(). ext3
-		 * will do this, as well as the blockdev mapping.
-		 * try_to_release_page() will discover that cleanness and will
-		 * drop the buffers and mark the page clean - it can be freed.
+		 * We do this even if the folio is dirty.
+		 * filemap_release_folio() does not perform I/O, but it
+		 * is possible for a folio to have the dirty flag set,
+		 * but it is actually clean (all its buffers are clean).
+		 * This happens if the buffers were written out directly,
+		 * with submit_bh(). ext3 will do this, as well as
+		 * the blockdev mapping.  filemap_release_folio() will
+		 * discover that cleanness and will drop the buffers
+		 * and mark the folio clean - it can be freed.
 		 *
-		 * Rarely, pages can have buffers and no ->mapping.  These are
-		 * the pages which were not successfully invalidated in
-		 * truncate_cleanup_page().  We try to drop those buffers here
-		 * and if that worked, and the page is no longer mapped into
-		 * process address space (page_count == 1) it can be freed.
-		 * Otherwise, leave the page on the LRU so it is swappable.
+		 * Rarely, folios can have buffers and no ->mapping.
+		 * These are the folios which were not successfully
+		 * invalidated in truncate_cleanup_folio().  We try to
+		 * drop those buffers here and if that worked, and the
+		 * folio is no longer mapped into process address space
+		 * (refcount == 1) it can be freed.  Otherwise, leave
+		 * the folio on the LRU so it is swappable.
 		 */
-		if (page_has_private(page)) {
-			if (!try_to_release_page(page, sc->gfp_mask))
+		if (folio_has_private(folio)) {
+			if (!filemap_release_folio(folio, sc->gfp_mask))
 				goto activate_locked;
-			if (!mapping && page_count(page) == 1) {
-				unlock_page(page);
-				if (put_page_testzero(page))
+			if (!mapping && folio_ref_count(folio) == 1) {
+				folio_unlock(folio);
+				if (folio_put_testzero(folio))
 					goto free_it;
 				else {
 					/*
 					 * rare race with speculative reference.
 					 * the speculative reference will free
-					 * this page shortly, so we may
+					 * this folio shortly, so we may
 					 * increment nr_reclaimed here (and
 					 * leave it off the LRU).
 					 */
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

