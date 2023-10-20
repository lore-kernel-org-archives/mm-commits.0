Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CB1C0032E
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 23:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjJTXup (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 19:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjJTXuo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 19:50:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58F0D6B
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 16:50:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2A4C433CA;
        Fri, 20 Oct 2023 23:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697845839;
        bh=F86sJUUMfF31Y4w6Um9wm82daDAYiL2mZjpo19uwkD4=;
        h=Date:To:From:Subject:From;
        b=k0Z75r/tgn3FVZ7c0cKkoxlpmh4PYIceu/nPZ1Qduu+SRa1+e7YD+KEIhgSJk9cC2
         g8PqqhB9/EV9RJsdviGH89/YUrAcywv4c19sYIxUiGd09pw6K+XXSlpMXpR+3wxB5m
         DztXHbUlok8RK2+cZZ0Y/6DV+G6PZRthqj17u0lE=
Date:   Fri, 20 Oct 2023 16:50:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, shy828301@gmail.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-convert-is_refcount_suitable-to-use-folios.patch added to mm-unstable branch
Message-Id: <20231020235039.3F2A4C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: convert is_refcount_suitable() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-convert-is_refcount_suitable-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-convert-is_refcount_suitable-to-use-folios.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/khugepaged: convert is_refcount_suitable() to use folios
Date: Fri, 20 Oct 2023 11:33:29 -0700

Both callers of is_refcount_suitable() have been converted to use
folios, so convert it to take in a folio. Both callers only operate on
head pages of folios so mapcount/refcount conversions here are trivial.

Removes 3 calls to compound head, and removes 315 bytes of kernel text.

Link: https://lkml.kernel.org/r/20231020183331.10770-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-convert-is_refcount_suitable-to-use-folios
+++ a/mm/khugepaged.c
@@ -524,15 +524,15 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
-static bool is_refcount_suitable(struct page *page)
+static bool is_refcount_suitable(struct folio *folio)
 {
 	int expected_refcount;
 
-	expected_refcount = total_mapcount(page);
-	if (PageSwapCache(page))
-		expected_refcount += compound_nr(page);
+	expected_refcount = folio_mapcount(folio);
+	if (folio_test_swapcache(folio))
+		expected_refcount += folio_nr_pages(folio);
 
-	return page_count(page) == expected_refcount;
+	return folio_ref_count(folio) == expected_refcount;
 }
 
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
@@ -625,7 +625,7 @@ static int __collapse_huge_page_isolate(
 		 * but not from this process. The other process cannot write to
 		 * the page, only trigger CoW.
 		 */
-		if (!is_refcount_suitable(&folio->page)) {
+		if (!is_refcount_suitable(folio)) {
 			folio_unlock(folio);
 			result = SCAN_PAGE_COUNT;
 			goto out;
@@ -1371,7 +1371,7 @@ static int hpage_collapse_scan_pmd(struc
 		 * has excessive GUP pins (i.e. 512).  Anyway the same check
 		 * will be done again later the risk seems low.
 		 */
-		if (!is_refcount_suitable(&folio->page)) {
+		if (!is_refcount_suitable(folio)) {
 			result = SCAN_PAGE_COUNT;
 			goto out_unmap;
 		}
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-khugepaged-convert-__collapse_huge_page_isolate-to-use-folios.patch
mm-khugepaged-convert-hpage_collapse_scan_pmd-to-use-folios.patch
mm-khugepaged-convert-is_refcount_suitable-to-use-folios.patch
mm-khugepaged-convert-alloc_charge_hpage-to-use-folios.patch
mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios.patch

