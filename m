Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2B3C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbjAZAs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbjAZAsX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:48:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EDCFF14
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:48:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFFEE616B5
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DD6C433EF;
        Thu, 26 Jan 2023 00:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674694100;
        bh=OcOjC0Zr9wd96PrU3Rp4FEXZrmzMyucmGDJdXolltTQ=;
        h=Date:To:From:Subject:From;
        b=x88/bYTmEebISTRapxuXFFwCF2t0c/Xd8f29CMWSNQM4tyqpfOGeSfp4+yQ7FcTOj
         RzyGN9ZH6x+VpEPrb0MH1nKAV8iWCoXpTACy8hd3fDAidib+hkjhHHKjuZVkO0N2Ab
         lJrGqojQ/aqb1CAK8unii/apezBS/tnbqdy2Mhdk=
Date:   Wed, 25 Jan 2023 16:48:19 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com, lkp@intel.com,
        jhubbard@nvidia.com, gerald.schaefer@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch added to mm-unstable branch
Message-Id: <20230126004820.20DD6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert restore_reserve_on_error to take in a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch

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
Cc: kernel test robot <lkp@intel.com>
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
@@ -725,7 +725,7 @@ struct folio *alloc_hugetlb_folio_vma(st
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

mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb-fault-paths-to-use-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

