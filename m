Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933B1E784BF
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 15:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbjJBPTM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238060AbjJBPTL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 11:19:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39595F2
        for <mm-commits@vger.kernel.org>; Mon,  2 Oct 2023 08:19:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8ECC433C8;
        Mon,  2 Oct 2023 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696259947;
        bh=l6ddSMbcyiUNS0GJZnlQZuLvzdsYLgaTU2VStYEW5zU=;
        h=Date:To:From:Subject:From;
        b=RduC2YO4fahegeVryJ5Rfti1Nm9q9NdRsDOHnggUk7MYfMWqXsivcHGHFUOFVb704
         NiJEHM18Z5v+PZe2of5H9VqZWo4UtLa7lzZqXWHOSwCZhXIoapRE7wTUWBjQRoZqje
         JIbfeoB+M65xyb5WMprutFs78QE/TXEmxZ+2yDwc=
Date:   Mon, 02 Oct 2023 08:19:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch added to mm-unstable branch
Message-Id: <20231002151907.AB8ECC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory: move exclusivity detection in do_wp_page() into wp_can_reuse_anon_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch

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
Subject: memory: move exclusivity detection in do_wp_page() into wp_can_reuse_anon_folio()
Date: Mon, 2 Oct 2023 16:29:49 +0200

Let's clean up do_wp_page() a bit, removing two labels and making it a
easier to read.

wp_can_reuse_anon_folio() now only operates on the whole folio.  Move the
SetPageAnonExclusive() out into do_wp_page().  No need to do this under
page lock -- the page table lock is sufficient.

Link: https://lkml.kernel.org/r/20231002142949.235104-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   88 +++++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 43 deletions(-)

--- a/mm/memory.c~memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio
+++ a/mm/memory.c
@@ -3358,6 +3358,44 @@ static vm_fault_t wp_page_shared(struct
 	return ret;
 }
 
+static bool wp_can_reuse_anon_folio(struct folio *folio,
+				    struct vm_area_struct *vma)
+{
+	/*
+	 * We have to verify under folio lock: these early checks are
+	 * just an optimization to avoid locking the folio and freeing
+	 * the swapcache if there is little hope that we can reuse.
+	 *
+	 * KSM doesn't necessarily raise the folio refcount.
+	 */
+	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
+		return false;
+	if (!folio_test_lru(folio))
+		/*
+		 * We cannot easily detect+handle references from
+		 * remote LRU caches or references to LRU folios.
+		 */
+		lru_add_drain();
+	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
+		return false;
+	if (!folio_trylock(folio))
+		return false;
+	if (folio_test_swapcache(folio))
+		folio_free_swap(folio);
+	if (folio_test_ksm(folio) || folio_ref_count(folio) != 1) {
+		folio_unlock(folio);
+		return false;
+	}
+	/*
+	 * Ok, we've got the only folio reference from our mapping
+	 * and the folio is locked, it's dark out, and we're wearing
+	 * sunglasses. Hit it.
+	 */
+	folio_move_anon_rmap(folio, vma);
+	folio_unlock(folio);
+	return true;
+}
+
 /*
  * This routine handles present pages, when
  * * users try to write to a shared page (FAULT_FLAG_WRITE)
@@ -3444,49 +3482,14 @@ static vm_fault_t do_wp_page(struct vm_f
 	/*
 	 * Private mapping: create an exclusive anonymous page copy if reuse
 	 * is impossible. We might miss VM_WRITE for FOLL_FORCE handling.
+	 *
+	 * If we encounter a page that is marked exclusive, we must reuse
+	 * the page without further checks.
 	 */
-	if (folio && folio_test_anon(folio)) {
-		/*
-		 * If the page is exclusive to this process we must reuse the
-		 * page without further checks.
-		 */
-		if (PageAnonExclusive(vmf->page))
-			goto reuse;
-
-		/*
-		 * We have to verify under folio lock: these early checks are
-		 * just an optimization to avoid locking the folio and freeing
-		 * the swapcache if there is little hope that we can reuse.
-		 *
-		 * KSM doesn't necessarily raise the folio refcount.
-		 */
-		if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
-			goto copy;
-		if (!folio_test_lru(folio))
-			/*
-			 * We cannot easily detect+handle references from
-			 * remote LRU caches or references to LRU folios.
-			 */
-			lru_add_drain();
-		if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
-			goto copy;
-		if (!folio_trylock(folio))
-			goto copy;
-		if (folio_test_swapcache(folio))
-			folio_free_swap(folio);
-		if (folio_test_ksm(folio) || folio_ref_count(folio) != 1) {
-			folio_unlock(folio);
-			goto copy;
-		}
-		/*
-		 * Ok, we've got the only folio reference from our mapping
-		 * and the folio is locked, it's dark out, and we're wearing
-		 * sunglasses. Hit it.
-		 */
-		folio_move_anon_rmap(folio, vma);
-		SetPageAnonExclusive(vmf->page);
-		folio_unlock(folio);
-reuse:
+	if (folio && folio_test_anon(folio) &&
+	    (PageAnonExclusive(vmf->page) || wp_can_reuse_anon_folio(folio, vma))) {
+		if (!PageAnonExclusive(vmf->page))
+			SetPageAnonExclusive(vmf->page);
 		if (unlikely(unshare)) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return 0;
@@ -3494,7 +3497,6 @@ reuse:
 		wp_page_reuse(vmf);
 		return 0;
 	}
-copy:
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch
mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch
mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix.patch
mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch
memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch

