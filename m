Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACC9E936E5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbjJDUc0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244810AbjJDUWL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AAB10D3
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D32EC433CA;
        Wed,  4 Oct 2023 20:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450861;
        bh=PNBU6bQOSTgrYuWFM1rGgQBXuqYXF41jhAN+h6e+uzk=;
        h=Date:To:From:Subject:From;
        b=oS8a7CVnYBrDxHmCPdDvaEfTWjE2DnL5yazA+2+z+inR+mUjHEnYRz3GyH/OaVlkz
         +62wEKUKjc7XSghgQEE8h6Hf7dI6/Fvvpnoh01stFfqUKZWTptPRpTZFUnTuZLOu/Q
         i7olZubAK9rFcDHz0jumRxaCcG9hVeMLso4K3D+4=
Date:   Wed, 04 Oct 2023 13:20:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch removed from -mm tree
Message-Id: <20231004202101.6D32EC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: move folio_test_anon() check out of __folio_set_anon()
has been removed from the -mm tree.  Its filename was
     mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2541,17 +2538,13 @@ void hugepage_add_anon_rmap(struct page
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

mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch
memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch

