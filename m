Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E351C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbiGDBNG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbiGDBL7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285286436
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE6A3B803F6
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64535C341C6;
        Mon,  4 Jul 2022 01:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897059;
        bh=iP/AKdVNpkrKJx42icMISPgNUsot75VnbBx1n3QJ+jI=;
        h=Date:To:From:Subject:From;
        b=u4onGKTFOBOiAmZOvDCTkGuKFuaTy32A43CTRWDuHI2y8PjxLEnkPdREgBhovNfaV
         14cQyDDKSTgLqLGQ7lR78Ia0juUPvISkwtCNHt2X0cs2py6JOvE7jJMXjf2Ov75VMP
         0LR/jLEoNrm3alEYYxy5tUUBmfPh+BSjN8t3AgMg=
Date:   Sun, 03 Jul 2022 18:10:58 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch removed from -mm tree
Message-Id: <20220704011059.64535C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: trivial typo and codestyle cleanup
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -599,7 +599,7 @@ static int __collapse_huge_page_isolate(
 	int none_or_zero = 0, shared = 0, result = 0, referenced = 0;
 	bool writable = false;
 
-	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
+	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval) || (pte_present(pteval) &&
@@ -1215,7 +1215,7 @@ static int khugepaged_scan_pmd(struct mm
 
 	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
-	for (_address = address, _pte = pte; _pte < pte+HPAGE_PMD_NR;
+	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (is_swap_pte(pteval)) {
@@ -1305,7 +1305,7 @@ static int khugepaged_scan_pmd(struct mm
 		/*
 		 * Check if the page has any GUP (or other external) pins.
 		 *
-		 * Here the check is racy it may see totmal_mapcount > refcount
+		 * Here the check is racy it may see total_mapcount > refcount
 		 * in some cases.
 		 * For example, one process with one forked child process.
 		 * The parent has the PMD split due to MADV_DONTNEED, then
@@ -1553,7 +1553,7 @@ static void retract_page_tables(struct a
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

mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

