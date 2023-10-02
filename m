Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B22DE784BE
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 15:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238061AbjJBPTL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238065AbjJBPTK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 11:19:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E744D3
        for <mm-commits@vger.kernel.org>; Mon,  2 Oct 2023 08:19:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9466CC433C9;
        Mon,  2 Oct 2023 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696259944;
        bh=aay+89VIJQHOg5H0l7BziQjuAI/ifW4xYmZQtj+HWKo=;
        h=Date:To:From:Subject:From;
        b=WDYSfYLWxc24cKaHEHi1vmWWjV9e+YBergMVfGtDbY/OioFuUwMoFoBUVWq0exjND
         wuos885vSvv2ZIyayHl+bdHzcfcz3WDSgHp1+nUyzLYYWt/jlEsBoVsJnW5WQ3/2sx
         hDOEm6IPsZZXgxIiVBgCf225d8bmte9yhZsnRbJo=
Date:   Mon, 02 Oct 2023 08:19:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch added to mm-unstable branch
Message-Id: <20231002151904.9466CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: convert page_move_anon_rmap() to folio_move_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch

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
Subject: mm/rmap: convert page_move_anon_rmap() to folio_move_anon_rmap()
Date: Mon, 2 Oct 2023 16:29:48 +0200

Let's convert it to consume a folio.

Link: https://lkml.kernel.org/r/20231002142949.235104-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/huge_memory.c     |    2 +-
 mm/hugetlb.c         |    2 +-
 mm/memory.c          |    2 +-
 mm/rmap.c            |   16 +++++++---------
 5 files changed, 11 insertions(+), 13 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/include/linux/rmap.h
@@ -194,7 +194,7 @@ typedef int __bitwise rmap_t;
 /*
  * rmap interfaces called when adding or removing pte of page
  */
-void page_move_anon_rmap(struct page *, struct vm_area_struct *);
+void folio_move_anon_rmap(struct folio *, struct vm_area_struct *);
 void page_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
--- a/mm/huge_memory.c~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/mm/huge_memory.c
@@ -1505,7 +1505,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	if (folio_ref_count(folio) == 1) {
 		pmd_t entry;
 
-		page_move_anon_rmap(page, vma);
+		folio_move_anon_rmap(folio, vma);
 		SetPageAnonExclusive(page);
 		folio_unlock(folio);
 reuse:
--- a/mm/hugetlb.c~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/mm/hugetlb.c
@@ -5461,7 +5461,7 @@ retry_avoidcopy:
 	 */
 	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio)) {
 		if (!PageAnonExclusive(&old_folio->page)) {
-			page_move_anon_rmap(&old_folio->page, vma);
+			folio_move_anon_rmap(old_folio, vma);
 			SetPageAnonExclusive(&old_folio->page);
 		}
 		if (likely(!unshare))
--- a/mm/memory.c~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/mm/memory.c
@@ -3483,7 +3483,7 @@ static vm_fault_t do_wp_page(struct vm_f
 		 * and the folio is locked, it's dark out, and we're wearing
 		 * sunglasses. Hit it.
 		 */
-		page_move_anon_rmap(vmf->page, vma);
+		folio_move_anon_rmap(folio, vma);
 		SetPageAnonExclusive(vmf->page);
 		folio_unlock(folio);
 reuse:
--- a/mm/rmap.c~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/mm/rmap.c
@@ -1141,19 +1141,17 @@ int folio_total_mapcount(struct folio *f
 }
 
 /**
- * page_move_anon_rmap - move a page to our anon_vma
- * @page:	the page to move to our anon_vma
- * @vma:	the vma the page belongs to
+ * folio_move_anon_rmap - move a folio to our anon_vma
+ * @page:	The folio to move to our anon_vma
+ * @vma:	The vma the folio belongs to
  *
- * When a page belongs exclusively to one process after a COW event,
- * that page can be moved into the anon_vma that belongs to just that
- * process, so the rmap code will not search the parent or sibling
- * processes.
+ * When a folio belongs exclusively to one process after a COW event,
+ * that folio can be moved into the anon_vma that belongs to just that
+ * process, so the rmap code will not search the parent or sibling processes.
  */
-void page_move_anon_rmap(struct page *page, struct vm_area_struct *vma)
+void folio_move_anon_rmap(struct folio *folio, struct vm_area_struct *vma)
 {
 	void *anon_vma = vma->anon_vma;
-	struct folio *folio = page_folio(page);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_VMA(!anon_vma, vma);
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

