Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22673C43219
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiCYWn7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiCYWn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2076B209A7E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5904B82A2F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D75AC3410F;
        Fri, 25 Mar 2022 22:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248111;
        bh=bA7b7QbHnBSpkgSd11D2D35Dv89n2ORBhdU9dWIofJo=;
        h=Date:To:From:Subject:From;
        b=AcwUc0Qx1zekfcxkAbMEjVV60+24NaD32vHXNzsbIJnoY/BoU/sAaY6YCotpq4721
         E/tU+Mf4dkGczuaKG9NkU4RfDgNIJoSymO8asF1Ymo2TQWPdUVZaglfRxZ0LhcCnSY
         PZcesbm0UYxrNQwMHm/3rz+oDcew2f8SlIcwmUf8=
Date:   Fri, 25 Mar 2022 15:41:50 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        kirill.shutemov@linux.intel.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch removed from -mm tree
Message-Id: <20220325224151.5D75AC3410F@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: fix NR_FILE_MAPPED accounting in page_*_file_rmap()
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: fix NR_FILE_MAPPED accounting in page_*_file_rmap()

NR_FILE_MAPPED accounting in mm/rmap.c (for /proc/meminfo "Mapped" and
/proc/vmstat "nr_mapped" and the memcg's memory.stat "mapped_file") is
slightly flawed for file or shmem huge pages.

It is well thought out, and looks convincing, but there's a racy case when
the careful counting in page_remove_file_rmap() (without page lock) gets
discarded.  So that in a workload like two "make -j20" kernel builds under
memory pressure, with cc1 on hugepage text, "Mapped" can easily grow by a
spurious 5MB or more on each iteration, ending up implausibly bigger than
most other numbers in /proc/meminfo.  And, hypothetically, might grow to
the point of seriously interfering in mm/vmscan.c's heuristics, which do
take NR_FILE_MAPPED into some consideration.

Fixed by moving the __mod_lruvec_page_state() down to where it will not be
missed before return (and I've grown a bit tired of that oft-repeated
but-not-everywhere comment on the __ness: it gets lost in the move here).

Does page_add_file_rmap() need the same change?  I suspect not, because
page lock is held in all relevant cases, and its skipping case looks safe;
but it's much easier to be sure, if we do make the same change.

Link: https://lkml.kernel.org/r/e02e52a1-8550-a57c-ed29-f51191ea2375@google.com
Fixes: dd78fedde4b9 ("rmap: support file thp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/mm/rmap.c~mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap
+++ a/mm/rmap.c
@@ -1236,14 +1236,14 @@ void page_add_new_anon_rmap(struct page
 void page_add_file_rmap(struct page *page,
 	struct vm_area_struct *vma, bool compound)
 {
-	int i, nr = 1;
+	int i, nr = 0;
 
 	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
 	lock_page_memcg(page);
 	if (compound && PageTransHuge(page)) {
 		int nr_pages = thp_nr_pages(page);
 
-		for (i = 0, nr = 0; i < nr_pages; i++) {
+		for (i = 0; i < nr_pages; i++) {
 			if (atomic_inc_and_test(&page[i]._mapcount))
 				nr++;
 		}
@@ -1271,11 +1271,12 @@ void page_add_file_rmap(struct page *pag
 			VM_WARN_ON_ONCE(!PageLocked(page));
 			SetPageDoubleMap(compound_head(page));
 		}
-		if (!atomic_inc_and_test(&page->_mapcount))
-			goto out;
+		if (atomic_inc_and_test(&page->_mapcount))
+			nr++;
 	}
-	__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
 out:
+	if (nr)
+		__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
 	unlock_page_memcg(page);
 
 	mlock_vma_page(page, vma, compound);
@@ -1283,7 +1284,7 @@ out:
 
 static void page_remove_file_rmap(struct page *page, bool compound)
 {
-	int i, nr = 1;
+	int i, nr = 0;
 
 	VM_BUG_ON_PAGE(compound && !PageHead(page), page);
 
@@ -1298,12 +1299,12 @@ static void page_remove_file_rmap(struct
 	if (compound && PageTransHuge(page)) {
 		int nr_pages = thp_nr_pages(page);
 
-		for (i = 0, nr = 0; i < nr_pages; i++) {
+		for (i = 0; i < nr_pages; i++) {
 			if (atomic_add_negative(-1, &page[i]._mapcount))
 				nr++;
 		}
 		if (!atomic_add_negative(-1, compound_mapcount_ptr(page)))
-			return;
+			goto out;
 		if (PageSwapBacked(page))
 			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
 						-nr_pages);
@@ -1311,16 +1312,12 @@ static void page_remove_file_rmap(struct
 			__mod_lruvec_page_state(page, NR_FILE_PMDMAPPED,
 						-nr_pages);
 	} else {
-		if (!atomic_add_negative(-1, &page->_mapcount))
-			return;
+		if (atomic_add_negative(-1, &page->_mapcount))
+			nr++;
 	}
-
-	/*
-	 * We use the irq-unsafe __{inc|mod}_lruvec_page_state because
-	 * these counters are not modified in interrupt context, and
-	 * pte lock(a spinlock) is held, which implies preemption disabled.
-	 */
-	__mod_lruvec_page_state(page, NR_FILE_MAPPED, -nr);
+out:
+	if (nr)
+		__mod_lruvec_page_state(page, NR_FILE_MAPPED, -nr);
 }
 
 static void page_remove_anon_compound_rmap(struct page *page)
_

Patches currently in -mm which might be from hughd@google.com are


