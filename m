Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B3EC64EC7
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjBMX4D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjBMXzg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC1F17CFA
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C55B5B81A2C
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859C4C4339C;
        Mon, 13 Feb 2023 23:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332531;
        bh=b1ausGXZhTWlikpROh1u3jfbKa//49RVt8wp8ImPr0k=;
        h=Date:To:From:Subject:From;
        b=tL8UHDsg6qyARDb56dN0SHg2vwtAL3m0IyEaqdYMgoKrwntcLpdCvj6q4SIb9RsMk
         T3qXK0DqUOMs1vu8Mv9IjXDdByWvZ8taHwDn4Ovh4gjLbHX+vbuT5wnTn/6xweb2My
         YBAwC+gm8YNm0tWNgvwUPTi6pAn9ZqO99GGFlmQE=
Date:   Mon, 13 Feb 2023 15:55:30 -0800
To:     mm-commits@vger.kernel.org, jane.chu@oracle.com,
        fengwei.yin@intel.com, david@redhat.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch removed from -mm tree
Message-Id: <20230213235531.859C4C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: convert queue_pages_hugetlb() to queue_folios_hugetlb()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/mempolicy: convert queue_pages_hugetlb() to queue_folios_hugetlb()
Date: Mon, 30 Jan 2023 12:18:31 -0800

This change is in preparation for the conversion of queue_pages_required()
to queue_folio_required() and migrate_page_add() to migrate_folio_add().

Link: https://lkml.kernel.org/r/20230130201833.27042-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: "Yin, Fengwei" <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mempolicy.c~mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb
+++ a/mm/mempolicy.c
@@ -558,7 +558,7 @@ static int queue_folios_pte_range(pmd_t
 	return addr != end ? -EIO : 0;
 }
 
-static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
+static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 			       unsigned long addr, unsigned long end,
 			       struct mm_walk *walk)
 {
@@ -566,7 +566,7 @@ static int queue_pages_hugetlb(pte_t *pt
 #ifdef CONFIG_HUGETLB_PAGE
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = (qp->flags & MPOL_MF_VALID);
-	struct page *page;
+	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t entry;
 
@@ -574,13 +574,13 @@ static int queue_pages_hugetlb(pte_t *pt
 	entry = huge_ptep_get(pte);
 	if (!pte_present(entry))
 		goto unlock;
-	page = pte_page(entry);
-	if (!queue_pages_required(page, qp))
+	folio = pfn_folio(pte_pfn(entry));
+	if (!queue_pages_required(&folio->page, qp))
 		goto unlock;
 
 	if (flags == MPOL_MF_STRICT) {
 		/*
-		 * STRICT alone means only detecting misplaced page and no
+		 * STRICT alone means only detecting misplaced folio and no
 		 * need to further check other vma.
 		 */
 		ret = -EIO;
@@ -591,21 +591,28 @@ static int queue_pages_hugetlb(pte_t *pt
 		/*
 		 * Must be STRICT with MOVE*, otherwise .test_walk() have
 		 * stopped walking current vma.
-		 * Detecting misplaced page but allow migrating pages which
+		 * Detecting misplaced folio but allow migrating folios which
 		 * have been queued.
 		 */
 		ret = 1;
 		goto unlock;
 	}
 
-	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
+	/*
+	 * With MPOL_MF_MOVE, we try to migrate only unshared folios. If it
+	 * is shared it is likely not worth migrating.
+	 *
+	 * To check if the folio is shared, ideally we want to make sure
+	 * every page is mapped to the same process. Doing that is very
+	 * expensive, so check the estimated mapcount of the folio instead.
+	 */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	    (flags & MPOL_MF_MOVE && folio_estimated_sharers(folio) == 1 &&
 	     !hugetlb_pmd_shared(pte))) {
-		if (isolate_hugetlb(page_folio(page), qp->pagelist) &&
+		if (isolate_hugetlb(folio, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
-			 * Failed to isolate page but allow migrating pages
+			 * Failed to isolate folio but allow migrating pages
 			 * which have been queued.
 			 */
 			ret = 1;
@@ -703,7 +710,7 @@ static int queue_pages_test_walk(unsigne
 }
 
 static const struct mm_walk_ops queue_pages_walk_ops = {
-	.hugetlb_entry		= queue_pages_hugetlb,
+	.hugetlb_entry		= queue_folios_hugetlb,
 	.pmd_entry		= queue_folios_pte_range,
 	.test_walk		= queue_pages_test_walk,
 };
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


