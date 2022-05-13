Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1088AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383706AbiEMTXQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383833AbiEMTWV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7103BBE0
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6D1BB8315C
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64117C34100;
        Fri, 13 May 2022 19:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469710;
        bh=hXh4XyEv1JY12T3jITu9uqPKJtJPXZa1xIYZ5bpEwgo=;
        h=Date:To:From:Subject:From;
        b=pz5CzId4hQC9qRWSQnOSbSK5OrjMuXQkUshZ+OvFkIMGvJmODGfTTwWpdavsAm/l3
         qfdYhz1UNskJSl6OnB5yl9YvOxRZMBSRa/kkL9mu5x65qqrf4jy9nKHQget/TaW8w8
         i1HqvOvmNmw+NVhDL35nX4Y+q6UPr/+tCEzTPv+o=
Date:   Fri, 13 May 2022 12:21:49 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-convert-page-buffer-handling-to-use-folios.patch removed from -mm tree
Message-Id: <20220513192150.64117C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmscan: convert page buffer handling to use folios
has been removed from the -mm tree.  Its filename was
     vmscan-convert-page-buffer-handling-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmscan: convert page buffer handling to use folios

This mostly just removes calls to compound_head() although nr_reclaimed
should be incremented by the number of pages, not just 1.

Link: https://lkml.kernel.org/r/20220504182857.4013401-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

