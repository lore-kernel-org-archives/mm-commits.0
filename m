Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BBFC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 21:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350913AbiAaVkn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381219AbiAaVip (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 16:38:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2A0C061768
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 13:38:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2899261416
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 21:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F072DC340EE;
        Mon, 31 Jan 2022 21:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643665099;
        bh=ksobzh5SGHbeqoCOr8UWaehciuyeJdvt+Jkw2sVHBAo=;
        h=Date:To:From:Subject:From;
        b=ZenVucCcHVx1TqkCErM9uMFouRGNzduioY5fMeCAWKMLTUvnDWYzmn/M6OIqxWABV
         8h0CeV4QZXqlJ5OZudTf2eRpPUPdkFaKzDTHsWZ3aZnCiXsJDH0NMmPDvVrjVuUREQ
         rDskBhk/+dagVmktkvEhJeebL0U+QkNlLWtCVbno=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 13:38:17 -0800
Date:   Mon, 31 Jan 2022 13:38:17 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, will@kernel.org,
        weixugc@google.com, songmuchun@bytedance.com, rppt@kernel.org,
        rientjes@google.com, pjt@google.com, mingo@redhat.com,
        jirislaby@kernel.org, hughd@google.com, hpa@zytor.com,
        gthelen@google.com, dave.hansen@linux.intel.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        pasha.tatashin@soleen.com
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-unify-collapse-pmd-clear-flush-and-free.patch added to -mm tree
Message-Id: <20220131213817.F072DC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: unify collapse pmd clear, flush and free
has been added to the -mm tree.  Its filename is
     mm-khugepaged-unify-collapse-pmd-clear-flush-and-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-unify-collapse-pmd-clear-flush-and-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-unify-collapse-pmd-clear-flush-and-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm/khugepaged: unify collapse pmd clear, flush and free

Unify the code that flushes, clears pmd entry, and frees the PTE table
level into a new function collapse_and_free_pmd().

This cleanup is useful as in the next patch we will add another call to
this function to iterate through PTE prior to freeing the level for page
table check.

Link: https://lkml.kernel.org/r/20220131203249.2832273-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Paul Turner <pjt@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-unify-collapse-pmd-clear-flush-and-free
+++ a/mm/khugepaged.c
@@ -1416,6 +1416,19 @@ static int khugepaged_add_pte_mapped_thp
 	return 0;
 }
 
+static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
+				  unsigned long addr, pmd_t *pmdp)
+{
+	spinlock_t *ptl;
+	pmd_t pmd;
+
+	ptl = pmd_lock(vma->vm_mm, pmdp);
+	pmd = pmdp_collapse_flush(vma, addr, pmdp);
+	spin_unlock(ptl);
+	mm_dec_nr_ptes(mm);
+	pte_free(mm, pmd_pgtable(pmd));
+}
+
 /**
  * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
  * address haddr.
@@ -1433,7 +1446,7 @@ void collapse_pte_mapped_thp(struct mm_s
 	struct vm_area_struct *vma = find_vma(mm, haddr);
 	struct page *hpage;
 	pte_t *start_pte, *pte;
-	pmd_t *pmd, _pmd;
+	pmd_t *pmd;
 	spinlock_t *ptl;
 	int count = 0;
 	int i;
@@ -1509,12 +1522,7 @@ void collapse_pte_mapped_thp(struct mm_s
 	}
 
 	/* step 4: collapse pmd */
-	ptl = pmd_lock(vma->vm_mm, pmd);
-	_pmd = pmdp_collapse_flush(vma, haddr, pmd);
-	spin_unlock(ptl);
-	mm_dec_nr_ptes(mm);
-	pte_free(mm, pmd_pgtable(_pmd));
-
+	collapse_and_free_pmd(mm, vma, haddr, pmd);
 drop_hpage:
 	unlock_page(hpage);
 	put_page(hpage);
@@ -1552,7 +1560,7 @@ static void retract_page_tables(struct a
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	unsigned long addr;
-	pmd_t *pmd, _pmd;
+	pmd_t *pmd;
 
 	i_mmap_lock_write(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
@@ -1591,14 +1599,8 @@ static void retract_page_tables(struct a
 		 * reverse order. Trylock is a way to avoid deadlock.
 		 */
 		if (mmap_write_trylock(mm)) {
-			if (!khugepaged_test_exit(mm)) {
-				spinlock_t *ptl = pmd_lock(mm, pmd);
-				/* assume page table is clear */
-				_pmd = pmdp_collapse_flush(vma, addr, pmd);
-				spin_unlock(ptl);
-				mm_dec_nr_ptes(mm);
-				pte_free(mm, pmd_pgtable(_pmd));
-			}
+			if (!khugepaged_test_exit(mm))
+				collapse_and_free_pmd(mm, vma, addr, pmd);
 			mmap_write_unlock(mm);
 		} else {
 			/* Try again later */
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table.patch
mm-page_table_check-use-unsigned-long-for-page-counters-and-cleanup.patch
mm-khugepaged-unify-collapse-pmd-clear-flush-and-free.patch
mm-page_table_check-check-entries-at-pmd-levels.patch

