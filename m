Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37387C64EC7
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjBMXzd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjBMXz2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F57917CEE
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31BA1B818FF
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CE2C433D2;
        Mon, 13 Feb 2023 23:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332523;
        bh=xN9FMO5nm9wAnXgANG30pEZGcGFHBq/XzxuG/SfgZQk=;
        h=Date:To:From:Subject:From;
        b=PordEk/f/gZHCmdlP5uAdrXTaDogw0sT2F9VzGUjTDtW+mMwX1TvPZO6KWG7Z9evc
         dzuA/q+OAWCfvIE97Js0LbprG2IeYFtt4p/ppVAFk7TaMbEkAcPpYbVoK2iZNgZ5vH
         Buu72SRa/1GZAO6cE3JqfBmRi9tIBQg5nVBD431g=
Date:   Mon, 13 Feb 2023 15:55:22 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, gerald.schaefer@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch removed from -mm tree
Message-Id: <20230213235522.E1CE2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert restore_reserve_on_error to take in a folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert restore_reserve_on_error to take in a folio
Date: Wed, 25 Jan 2023 09:05:34 -0800

Every caller of restore_reserve_on_error() is now passing in &folio->page,
change the function to take in a folio directly and clean up the call
sites.

Link: https://lkml.kernel.org/r/20230125170537.96973-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hugetlbfs/inode.c~mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio
+++ a/fs/hugetlbfs/inode.c
@@ -873,7 +873,7 @@ static long hugetlbfs_fallocate(struct f
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(&folio->page, mapping, index);
 		if (unlikely(error)) {
-			restore_reserve_on_error(h, &pseudo_vma, addr, &folio->page);
+			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
 			folio_put(folio);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			goto out;
--- a/include/linux/hugetlb.h~mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio
+++ a/include/linux/hugetlb.h
@@ -726,7 +726,7 @@ struct folio *alloc_hugetlb_folio_vma(st
 int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
-				unsigned long address, struct page *page);
+				unsigned long address, struct folio *folio);
 
 /* arch callback */
 int __init __alloc_bootmem_huge_page(struct hstate *h, int nid);
--- a/mm/hugetlb.c~mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio
+++ a/mm/hugetlb.c
@@ -2802,9 +2802,9 @@ static long vma_del_reservation(struct h
  * and the hugetlb mutex should remain held when calling this routine.
  *
  * It handles two specific cases:
- * 1) A reservation was in place and the page consumed the reservation.
- *    HPageRestoreReserve is set in the page.
- * 2) No reservation was in place for the page, so HPageRestoreReserve is
+ * 1) A reservation was in place and the folio consumed the reservation.
+ *    hugetlb_restore_reserve is set in the folio.
+ * 2) No reservation was in place for the page, so hugetlb_restore_reserve is
  *    not set.  However, alloc_hugetlb_folio always updates the reserve map.
  *
  * In case 1, free_huge_page later in the error path will increment the
@@ -2817,9 +2817,8 @@ static long vma_del_reservation(struct h
  * In case 2, simply undo reserve map modifications done by alloc_hugetlb_folio.
  */
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
-			unsigned long address, struct page *page)
+			unsigned long address, struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
 	long rc = vma_needs_reservation(h, vma, address);
 
 	if (folio_test_hugetlb_restore_reserve(folio)) {
@@ -5102,7 +5101,7 @@ again:
 				entry = huge_ptep_get(src_pte);
 				if (!pte_same(src_pte_old, entry)) {
 					restore_reserve_on_error(h, dst_vma, addr,
-								&new_folio->page);
+								new_folio);
 					folio_put(new_folio);
 					/* huge_ptep of dst_pte won't change as in child */
 					goto again;
@@ -5634,7 +5633,7 @@ out_release_all:
 	 * unshare)
 	 */
 	if (new_folio != page_folio(old_page))
-		restore_reserve_on_error(h, vma, haddr, &new_folio->page);
+		restore_reserve_on_error(h, vma, haddr, new_folio);
 	folio_put(new_folio);
 out_release_old:
 	put_page(old_page);
@@ -5846,7 +5845,7 @@ static vm_fault_t hugetlb_no_page(struct
 				 * to the page cache. So it's safe to call
 				 * restore_reserve_on_error() here.
 				 */
-				restore_reserve_on_error(h, vma, haddr, &folio->page);
+				restore_reserve_on_error(h, vma, haddr, folio);
 				folio_put(folio);
 				goto out;
 			}
@@ -5947,7 +5946,7 @@ backout:
 	spin_unlock(ptl);
 backout_unlocked:
 	if (new_folio && !new_pagecache_folio)
-		restore_reserve_on_error(h, vma, haddr, &folio->page);
+		restore_reserve_on_error(h, vma, haddr, folio);
 
 	folio_unlock(folio);
 	folio_put(folio);
@@ -6210,7 +6209,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			/* Free the allocated folio which may have
 			 * consumed a reservation.
 			 */
-			restore_reserve_on_error(h, dst_vma, dst_addr, &folio->page);
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 
 			/* Allocate a temporary folio to hold the copied
@@ -6339,7 +6338,7 @@ out_release_unlock:
 		folio_unlock(folio);
 out_release_nounlock:
 	if (!folio_in_pagecache)
-		restore_reserve_on_error(h, dst_vma, dst_addr, &folio->page);
+		restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 	folio_put(folio);
 	goto out;
 }
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


