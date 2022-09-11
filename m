Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BD4C6FA83
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiIKXct (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIKXcs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F611F2CA
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DC2B6112C
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9344BC433B5;
        Sun, 11 Sep 2022 23:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662939166;
        bh=cANDzG3/D1cPDzrG/6VI5GRdmzaZKn+6QHBknzbBOVk=;
        h=Date:To:From:Subject:From;
        b=0LYh7Wmr5y6OInW+zIsgButUYEMujVIHdb6JLVZDo41QmE3w9oeTtnkKSNMKjfMEK
         ifWTmuMcDGLLw/Cy1dXtgvrx2uxKcQ5h0u6sE7h5EvI1Y5GvVOYswz4bYTnkW8o+RE
         hu0fXHEw/q0hD3V+RR+wNuDVH4Mn+S3AkiiY2Wdc=
Date:   Sun, 11 Sep 2022 16:32:45 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jrdr.linux@gmail.com, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hughd@google.com, deller@gmx.de, david@redhat.com,
        dan.carpenter@oracle.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch removed from -mm tree
Message-Id: <20220911233246.9344BC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: consistently order cc->is_khugepaged and pte_* checks
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch

This patch was dropped because it was folded into mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/khugepaged: consistently order cc->is_khugepaged and pte_* checks
Date: Wed, 20 Jul 2022 07:06:01 -0700

cc->is_khugepaged is used to predicate the khugepaged-only behavior of
enforcing khugepaged heuristics limited by the sysfs knobs
khugepaged_max_ptes_[none|swap|shared].

In branches where khugepaged_max_ptes_* is checked, consistently check
cc->is_khugepaged first.  Also, local counters (for comparison vs
khugepaged_max_ptes_* limits) were previously incremented in the
comparison expression.  Some of these counters (unmapped) are additionally
used outside of khugepaged_max_ptes_* enforcement, and all counters are
communicated in tracepoints.  Move the correct accounting of these
counters before branching statements to avoid future errors due to C's
short-circuiting evaluation.

Link: https://lkml.kernel.org/r/20220720140603.1958773-3-zokeefe@google.com
Link: https://lore.kernel.org/linux-mm/Ys2qJm6FaOQcxkha@google.com/
Fixes: 9fab4752a181 ("mm/khugepaged: add flag to predicate khugepaged-only behavior")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   49 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix
+++ a/mm/khugepaged.c
@@ -571,9 +571,10 @@ static int __collapse_huge_page_isolate(
 		pte_t pteval = *_pte;
 		if (pte_none(pteval) || (pte_present(pteval) &&
 				is_zero_pfn(pte_pfn(pteval)))) {
+			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    (++none_or_zero <= khugepaged_max_ptes_none ||
-			     !cc->is_khugepaged)) {
+			    (!cc->is_khugepaged ||
+			     none_or_zero <= khugepaged_max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -593,11 +594,14 @@ static int __collapse_huge_page_isolate(
 
 		VM_BUG_ON_PAGE(!PageAnon(page), page);
 
-		if (cc->is_khugepaged && page_mapcount(page) > 1 &&
-		    ++shared > khugepaged_max_ptes_shared) {
-			result = SCAN_EXCEED_SHARED_PTE;
-			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-			goto out;
+		if (page_mapcount(page) > 1) {
+			++shared;
+			if (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared) {
+				result = SCAN_EXCEED_SHARED_PTE;
+				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				goto out;
+			}
 		}
 
 		if (PageCompound(page)) {
@@ -1131,8 +1135,9 @@ static int khugepaged_scan_pmd(struct mm
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (is_swap_pte(pteval)) {
-			if (++unmapped <= khugepaged_max_ptes_swap ||
-			    !cc->is_khugepaged) {
+			++unmapped;
+			if (!cc->is_khugepaged ||
+			    unmapped <= khugepaged_max_ptes_swap) {
 				/*
 				 * Always be strict with uffd-wp
 				 * enabled swap entries.  Please see
@@ -1150,9 +1155,10 @@ static int khugepaged_scan_pmd(struct mm
 			}
 		}
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    (++none_or_zero <= khugepaged_max_ptes_none ||
-			     !cc->is_khugepaged)) {
+			    (!cc->is_khugepaged ||
+			     none_or_zero <= khugepaged_max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1182,12 +1188,14 @@ static int khugepaged_scan_pmd(struct mm
 			goto out_unmap;
 		}
 
-		if (cc->is_khugepaged &&
-		    page_mapcount(page) > 1 &&
-		    ++shared > khugepaged_max_ptes_shared) {
-			result = SCAN_EXCEED_SHARED_PTE;
-			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-			goto out_unmap;
+		if (page_mapcount(page) > 1) {
+			++shared;
+			if (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared) {
+				result = SCAN_EXCEED_SHARED_PTE;
+				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				goto out_unmap;
+			}
 		}
 
 		page = compound_head(page);
@@ -1923,8 +1931,9 @@ static int khugepaged_scan_file(struct m
 			continue;
 
 		if (xa_is_value(page)) {
+			++swap;
 			if (cc->is_khugepaged &&
-			    ++swap > khugepaged_max_ptes_swap) {
+			    swap > khugepaged_max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;
@@ -1975,8 +1984,8 @@ static int khugepaged_scan_file(struct m
 	rcu_read_unlock();
 
 	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - khugepaged_max_ptes_none &&
-		    cc->is_khugepaged) {
+		if (cc->is_khugepaged &&
+		    present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-3.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
mm-madvise-add-madv_collapse-to-process_madvise-fix.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch
mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

