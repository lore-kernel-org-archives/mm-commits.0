Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD36C64EC7
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjBMXz3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjBMXzW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97408271B
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43B8EB81A2F
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC989C4339C;
        Mon, 13 Feb 2023 23:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332518;
        bh=26dbQ5KDhhCdsHxGJMLiA0Qpj7eH3r9Rh4/7LmzXGm8=;
        h=Date:To:From:Subject:From;
        b=1b7zUlbev8YoK1qqKKRFhzl0gj+kTtVyg7BerHUFyzQ4xVftvcFKeUU7ongsV5myi
         keIAO2hrpRyDHtTeWzthsUGYFJMaDAink5QI5gcJMqbw28QaMwsRPQD7nl/Rle/ZQh
         hOcZQFgln6P3Kjcm5Kn4E3U0VFnriScCIomxBUa8=
Date:   Mon, 13 Feb 2023 15:55:17 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, gerald.schaefer@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-hugetlb_install_page-to-folios.patch removed from -mm tree
Message-Id: <20230213235517.EC989C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert hugetlb_install_page to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-hugetlb_install_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert hugetlb_install_page to folios
Date: Wed, 25 Jan 2023 09:05:30 -0800

Patch series "convert hugetlb fault functions to folios", v2.

This series converts the hugetlb page faulting functions to operate on
folios. These include hugetlb_no_page(), hugetlb_wp(),
copy_hugetlb_page_range(), and hugetlb_mcopy_atomic_pte().


This patch (of 8):

Change hugetlb_install_page() to hugetlb_install_folio().  This reduces
one user of the Huge Page flag macros which take in a page.

Link: https://lkml.kernel.org/r/20230125170537.96973-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20230125170537.96973-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlb_install_page-to-folios
+++ a/mm/hugetlb.c
@@ -4946,14 +4946,14 @@ static bool is_hugetlb_entry_hwpoisoned(
 }
 
 static void
-hugetlb_install_page(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
-		     struct page *new_page)
+hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
+		     struct folio *new_folio)
 {
-	__SetPageUptodate(new_page);
-	hugepage_add_new_anon_rmap(new_page, vma, addr);
-	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, new_page, 1));
+	__folio_mark_uptodate(new_folio);
+	hugepage_add_new_anon_rmap(&new_folio->page, vma, addr);
+	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, &new_folio->page, 1));
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
-	SetHPageMigratable(new_page);
+	folio_set_hugetlb_migratable(new_folio);
 }
 
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
@@ -5107,7 +5107,7 @@ again:
 					/* huge_ptep of dst_pte won't change as in child */
 					goto again;
 				}
-				hugetlb_install_page(dst_vma, dst_pte, addr, new);
+				hugetlb_install_folio(dst_vma, dst_pte, addr, page_folio(new));
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				continue;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


