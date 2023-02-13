Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D949C636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjBMX4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjBMXze (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C1D17CC5
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9A46B81A2E
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708E4C433EF;
        Mon, 13 Feb 2023 23:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332530;
        bh=pBLVaPPFSZndiv1mcpp+BlH7Ix3tRyfV0gBRQu1/OGY=;
        h=Date:To:From:Subject:From;
        b=P4TMuM77G2Gp0lNZUisy9LgazGVfif638nXVGbPYvNoNwF6H+oCmk8lG5xGNsjO80
         434/8QKnBAXtPCv762/MZuCr6upSsy2hgcA6f9+OTKgMMiXElPkM1ZjjVdp1hRzMGY
         kUnm+bpxO8R20g/pJaF0hoDg//hgdPZrjAPBFx9o=
Date:   Mon, 13 Feb 2023 15:55:29 -0800
To:     mm-commits@vger.kernel.org, jane.chu@oracle.com,
        fengwei.yin@intel.com, david@redhat.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch removed from -mm tree
Message-Id: <20230213235530.708E4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: convert queue_pages_pte_range() to queue_folios_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/mempolicy: convert queue_pages_pte_range() to queue_folios_pte_range()
Date: Mon, 30 Jan 2023 12:18:30 -0800

This function now operates on folios associated with ptes instead of
pages.

This change is in preparation for the conversion of queue_pages_required()
to queue_folio_required() and migrate_page_add() to migrate_folio_add().

Link: https://lkml.kernel.org/r/20230130201833.27042-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: "Yin, Fengwei" <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mempolicy.c~mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range
+++ a/mm/mempolicy.c
@@ -491,19 +491,19 @@ unlock:
  * Scan through pages checking if pages follow certain conditions,
  * and move them to the pagelist if they do.
  *
- * queue_pages_pte_range() has three possible return values:
- * 0 - pages are placed on the right node or queued successfully, or
+ * queue_folios_pte_range() has three possible return values:
+ * 0 - folios are placed on the right node or queued successfully, or
  *     special page is met, i.e. zero page.
- * 1 - there is unmovable page, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
+ * 1 - there is unmovable folio, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
  *     specified.
- * -EIO - only MPOL_MF_STRICT was specified and an existing page was already
+ * -EIO - only MPOL_MF_STRICT was specified and an existing folio was already
  *        on a node that does not follow the policy.
  */
-static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
+static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->vma;
-	struct page *page;
+	struct folio *folio;
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
 	bool has_unmovable = false;
@@ -521,16 +521,16 @@ static int queue_pages_pte_range(pmd_t *
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
-		page = vm_normal_page(vma, addr, *pte);
-		if (!page || is_zone_device_page(page))
+		folio = vm_normal_folio(vma, addr, *pte);
+		if (!folio || folio_is_zone_device(folio))
 			continue;
 		/*
-		 * vm_normal_page() filters out zero pages, but there might
-		 * still be PageReserved pages to skip, perhaps in a VDSO.
+		 * vm_normal_folio() filters out zero pages, but there might
+		 * still be reserved folios to skip, perhaps in a VDSO.
 		 */
-		if (PageReserved(page))
+		if (folio_test_reserved(folio))
 			continue;
-		if (!queue_pages_required(page, qp))
+		if (!queue_pages_required(&folio->page, qp))
 			continue;
 		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 			/* MPOL_MF_STRICT must be specified if we get here */
@@ -544,7 +544,7 @@ static int queue_pages_pte_range(pmd_t *
 			 * temporary off LRU pages in the range.  Still
 			 * need migrate other LRU pages.
 			 */
-			if (migrate_page_add(page, qp->pagelist, flags))
+			if (migrate_page_add(&folio->page, qp->pagelist, flags))
 				has_unmovable = true;
 		} else
 			break;
@@ -704,7 +704,7 @@ static int queue_pages_test_walk(unsigne
 
 static const struct mm_walk_ops queue_pages_walk_ops = {
 	.hugetlb_entry		= queue_pages_hugetlb,
-	.pmd_entry		= queue_pages_pte_range,
+	.pmd_entry		= queue_folios_pte_range,
 	.test_walk		= queue_pages_test_walk,
 };
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


