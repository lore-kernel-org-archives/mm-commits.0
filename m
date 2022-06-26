Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F7ACCA47E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiFZU2M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiFZU16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:27:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2291BFC3
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C433EB80DFB
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E45C341CA;
        Sun, 26 Jun 2022 20:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656275274;
        bh=3vIGof/MeGMyzGEQXY8yLeB123OSBBTUD83MMAYp9HI=;
        h=Date:To:From:Subject:From;
        b=PJd6vRZESiGgtBUHZYcgaqwwAWm+qNEdYAza3wOjKOaUFNlNTQbrPFytasRfgTLbd
         Rwai7Ku/vaeNe/YPQdgjAA9lPSzpLhsdoECtVcUY6grWt7WLshXsrzj2erC6f94USz
         nYDLYaO07Y2JXQYcxvW6Q7ue443ApwttE+qFl55o=
Date:   Sun, 26 Jun 2022 13:27:53 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch added to mm-unstable branch
Message-Id: <20220626202754.74E45C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: remove unneeded return value of khugepaged_add_pte_mapped_thp()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: remove unneeded return value of khugepaged_add_pte_mapped_thp()
Date: Sat, 25 Jun 2022 17:28:15 +0800

The return value of khugepaged_add_pte_mapped_thp() is always 0 and also
ignored.  Remove it to clean up the code.

Link: https://lkml.kernel.org/r/20220625092816.4856-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp
+++ a/mm/khugepaged.c
@@ -1339,8 +1339,8 @@ static void collect_mm_slot(struct mm_sl
  * Notify khugepaged that given addr of the mm is pte-mapped THP. Then
  * khugepaged should try to collapse the page table.
  */
-static int khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
-					 unsigned long addr)
+static void khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
+					  unsigned long addr)
 {
 	struct mm_slot *mm_slot;
 
@@ -1351,7 +1351,6 @@ static int khugepaged_add_pte_mapped_thp
 	if (likely(mm_slot && mm_slot->nr_pte_mapped_thp < MAX_PTE_MAPPED_THP))
 		mm_slot->pte_mapped_thp[mm_slot->nr_pte_mapped_thp++] = addr;
 	spin_unlock(&khugepaged_mm_lock);
-	return 0;
 }
 
 static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch

