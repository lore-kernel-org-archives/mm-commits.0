Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4911DE784BD
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 15:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbjJBPTG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbjJBPTF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 11:19:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC1DDA
        for <mm-commits@vger.kernel.org>; Mon,  2 Oct 2023 08:19:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57C0C433C8;
        Mon,  2 Oct 2023 15:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696259941;
        bh=gQOstL2gESzlZ8ETutRMqUzzCNnZFyUMHwCjHxHssvc=;
        h=Date:To:From:Subject:From;
        b=vEBaLvMWHZhJk4Wczq3b/jfxPk6kHzFkcEHFPuNwu/o0WGaBwT11tn0/TTE21JsrJ
         GtOE00SdvQr+tPl3oZuNB3s5fs82wNUJAtB8UIPM1BIjhjmuGNsKXI8PLGeuKMw1l5
         m6T6vPUjbdTQJW5sTSqYPQThfLfEwgunSPXRtgUY=
Date:   Mon, 02 Oct 2023 08:19:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch added to mm-unstable branch
Message-Id: <20231002151901.B57C0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: move SetPageAnonExclusive() out of page_move_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch

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
Subject: mm/rmap: move SetPageAnonExclusive() out of page_move_anon_rmap()
Date: Mon, 2 Oct 2023 16:29:47 +0200

Patch series "mm/rmap: convert page_move_anon_rmap() to
folio_move_anon_rmap()".

Convert page_move_anon_rmap() to folio_move_anon_rmap(), letting the
callers handle PageAnonExclusive.  I'm including cleanup patch #3 because
it fits into the picture and can be done cleaner by the conversion.


This patch (of 3):

Let's move it into the caller: there is a difference between whether an
anon folio can only be mapped by one process (e.g., into one VMA), and
whether it is truly exclusive (e.g., no references -- including GUP --
from other processes).

Further, for large folios the page might not actually be pointing at the
head page of the folio, so it better be handled in the caller.  This is a
preparation for converting page_move_anon_rmap() to consume a folio.

Link: https://lkml.kernel.org/r/20231002142949.235104-1-david@redhat.com
Link: https://lkml.kernel.org/r/20231002142949.235104-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 mm/hugetlb.c     |    4 +++-
 mm/memory.c      |    1 +
 mm/rmap.c        |    1 -
 4 files changed, 5 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap
+++ a/mm/huge_memory.c
@@ -1506,6 +1506,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 		pmd_t entry;
 
 		page_move_anon_rmap(page, vma);
+		SetPageAnonExclusive(page);
 		folio_unlock(folio);
 reuse:
 		if (unlikely(unshare)) {
--- a/mm/hugetlb.c~mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap
+++ a/mm/hugetlb.c
@@ -5460,8 +5460,10 @@ retry_avoidcopy:
 	 * owner and can reuse this page.
 	 */
 	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio)) {
-		if (!PageAnonExclusive(&old_folio->page))
+		if (!PageAnonExclusive(&old_folio->page)) {
 			page_move_anon_rmap(&old_folio->page, vma);
+			SetPageAnonExclusive(&old_folio->page);
+		}
 		if (likely(!unshare))
 			set_huge_ptep_writable(vma, haddr, ptep);
 
--- a/mm/memory.c~mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap
+++ a/mm/memory.c
@@ -3484,6 +3484,7 @@ static vm_fault_t do_wp_page(struct vm_f
 		 * sunglasses. Hit it.
 		 */
 		page_move_anon_rmap(vmf->page, vma);
+		SetPageAnonExclusive(vmf->page);
 		folio_unlock(folio);
 reuse:
 		if (unlikely(unshare)) {
--- a/mm/rmap.c~mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap
+++ a/mm/rmap.c
@@ -1165,7 +1165,6 @@ void page_move_anon_rmap(struct page *pa
 	 * folio_test_anon()) will not see one without the other.
 	 */
 	WRITE_ONCE(folio->mapping, anon_vma);
-	SetPageAnonExclusive(page);
 }
 
 /**
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

