Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB76C43334
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiFZU1v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbiFZU1u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:27:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA243EB5
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5592560F70
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF0CC341CA;
        Sun, 26 Jun 2022 20:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656275268;
        bh=jHKxec83p/euTKilyvKaRM99xCf2mqbLZJY6asXIS0s=;
        h=Date:To:From:Subject:From;
        b=ZLeM53strQvHTVbHZ/Z9cx2zVjajqpk506iDchXPa1bN2X2ahJP1kXJPB7Hw1z73L
         3USrZlRMLMyGN4rE+kOnwOEGvT4/MozepqmTndF04gb4v/KSowhpSBoxeiZpa5BlzX
         dDkdk9tMZkHeBj8jVnW/viKIMBqVhm3WvdexObOI=
Date:   Sun, 26 Jun 2022 13:27:48 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch added to mm-unstable branch
Message-Id: <20220626202748.ACF0CC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: trivial typo and codestyle cleanup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch

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
Subject: mm/khugepaged: trivial typo and codestyle cleanup
Date: Sat, 25 Jun 2022 17:28:12 +0800

Fix some typos and tweak the code to meet codestyle.  No functional change
intended.

Link: https://lkml.kernel.org/r/20220625092816.4856-4-linmiaohe@huawei.com
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

 mm/khugepaged.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-trivial-typo-and-codestyle-cleanup
+++ a/mm/khugepaged.c
@@ -260,7 +260,7 @@ static ssize_t khugepaged_max_ptes_none_
 	unsigned long max_ptes_none;
 
 	err = kstrtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > HPAGE_PMD_NR-1)
+	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
@@ -286,7 +286,7 @@ static ssize_t khugepaged_max_ptes_swap_
 	unsigned long max_ptes_swap;
 
 	err  = kstrtoul(buf, 10, &max_ptes_swap);
-	if (err || max_ptes_swap > HPAGE_PMD_NR-1)
+	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
 		return -EINVAL;
 
 	khugepaged_max_ptes_swap = max_ptes_swap;
@@ -313,7 +313,7 @@ static ssize_t khugepaged_max_ptes_share
 	unsigned long max_ptes_shared;
 
 	err  = kstrtoul(buf, 10, &max_ptes_shared);
-	if (err || max_ptes_shared > HPAGE_PMD_NR-1)
+	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
 		return -EINVAL;
 
 	khugepaged_max_ptes_shared = max_ptes_shared;
@@ -560,7 +560,7 @@ static int __collapse_huge_page_isolate(
 	int none_or_zero = 0, shared = 0, result = 0, referenced = 0;
 	bool writable = false;
 
-	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
+	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval) || (pte_present(pteval) &&
@@ -1183,7 +1183,7 @@ static int khugepaged_scan_pmd(struct mm
 
 	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
-	for (_address = address, _pte = pte; _pte < pte+HPAGE_PMD_NR;
+	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (is_swap_pte(pteval)) {
@@ -1273,7 +1273,7 @@ static int khugepaged_scan_pmd(struct mm
 		/*
 		 * Check if the page has any GUP (or other external) pins.
 		 *
-		 * Here the check is racy it may see totmal_mapcount > refcount
+		 * Here the check is racy it may see total_mapcount > refcount
 		 * in some cases.
 		 * For example, one process with one forked child process.
 		 * The parent has the PMD split due to MADV_DONTNEED, then
@@ -1524,7 +1524,7 @@ static void retract_page_tables(struct a
 		 * mmap_write_lock(mm) as PMD-mapping is likely to be split
 		 * later.
 		 *
-		 * Not that vma->anon_vma check is racy: it can be set up after
+		 * Note that vma->anon_vma check is racy: it can be set up after
 		 * the check but before we took mmap_lock by the fault path.
 		 * But page lock would prevent establishing any new ptes of the
 		 * page, so we are safe.
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

