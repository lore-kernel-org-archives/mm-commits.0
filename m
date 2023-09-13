Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6AAEE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjIMTsQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjIMTsP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:48:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C579B
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:48:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B1AC433C9;
        Wed, 13 Sep 2023 19:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694634491;
        bh=PZFVLRE6ryA9fh+t/9992T3TxK8KcXRspUesRI/Ip5k=;
        h=Date:To:From:Subject:From;
        b=DStgZnDW/NCd9TNA7JmlWi3ldG9O95soTKQPAcFrRBkX2xkJAUMZZgM/HFjghJ5+d
         IlFUl+x+mPOcgAO0xpUQ7OrO+cb5//Dsr1NEEPhx4eNVgBBGrz5MBGeQCjGlcMMPaD
         etQHIIVSjPe5HzVAiuyocPyS8GdQQlNFDxxJ1xQM=
Date:   Wed, 13 Sep 2023 12:48:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch added to mm-unstable branch
Message-Id: <20230913194811.25B1AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: move folio_test_anon() check out of __folio_set_anon()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch

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
Subject: mm/rmap: move folio_test_anon() check out of __folio_set_anon()
Date: Wed, 13 Sep 2023 14:51:10 +0200

Let's handle it in the caller; no need for the "first" check based on the
mapcount.

We really only end up with !anon pages in page_add_anon_rmap() via
do_swap_page(), where we hold the folio lock.  So races are not possible. 
Add a VM_WARN_ON_FOLIO() to make sure that we really hold the folio lock.

In the future, we might want to let do_swap_page() use
folio_add_new_anon_rmap() on new pages instead: however, we might have to
pass then whether the folio is exclusive or not.  So keep it in there for
now.

For hugetlb we never expect to have a non-anon page in
hugepage_add_anon_rmap().  Remove that code, along with some other checks
that are either not required or were checked in
hugepage_add_new_anon_rmap() already.

Link: https://lkml.kernel.org/r/20230913125113.313322-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/mm/rmap.c~mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon
+++ a/mm/rmap.c
@@ -1135,9 +1135,6 @@ static void __folio_set_anon(struct foli
 
 	BUG_ON(!anon_vma);
 
-	if (folio_test_anon(folio))
-		return;
-
 	/*
 	 * If the folio isn't exclusive to this vma, we must use the _oldest_
 	 * possible anon_vma for the folio mapping!
@@ -1239,12 +1236,12 @@ void page_add_anon_rmap(struct page *pag
 	if (nr)
 		__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
 
-	if (likely(!folio_test_ksm(folio))) {
-		if (first)
-			__folio_set_anon(folio, vma, address,
-					 !!(flags & RMAP_EXCLUSIVE));
-		else
-			__page_check_anon_rmap(folio, page, vma, address);
+	if (unlikely(!folio_test_anon(folio))) {
+		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+		__folio_set_anon(folio, vma, address,
+				 !!(flags & RMAP_EXCLUSIVE));
+	} else if (likely(!folio_test_ksm(folio))) {
+		__page_check_anon_rmap(folio, page, vma, address);
 	}
 	if (flags & RMAP_EXCLUSIVE)
 		SetPageAnonExclusive(page);
@@ -2528,17 +2525,13 @@ void hugepage_add_anon_rmap(struct page
 			    unsigned long address, rmap_t flags)
 {
 	struct folio *folio = page_folio(page);
-	struct anon_vma *anon_vma = vma->anon_vma;
 	int first;
 
-	BUG_ON(!folio_test_locked(folio));
-	BUG_ON(!anon_vma);
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
 	first = atomic_inc_and_test(&folio->_entire_mapcount);
 	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
 	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
-	if (first)
-		__folio_set_anon(folio, vma, address,
-				 !!(flags & RMAP_EXCLUSIVE));
 	if (flags & RMAP_EXCLUSIVE)
 		SetPageAnonExclusive(page);
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch
mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch
mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch
mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch

