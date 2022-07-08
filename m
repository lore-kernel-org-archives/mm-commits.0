Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB087CCA482
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 21:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbiGHVFl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbiGHVFU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 17:05:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8489FE04
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 14:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ED79B82998
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 21:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2935C341C0;
        Fri,  8 Jul 2022 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657314317;
        bh=ZxKV+N2czHgBZISFQA7BlQ/d9DcvYRPvQVnsjujHbl4=;
        h=Date:To:From:Subject:From;
        b=PS+7Vtpp2+fzGh5YiCaH44ocwAkhMY1WYggGDc8HShfvxLrYYcq2yuK7aYUdnTrFp
         1/HlhMU05D2upchJ+iHfabqHSiUsL74bmDlTY8y9706nBMhJktu0g5PzaIEpirTpdX
         MGiLqaZl/1WoqLd6rOI3dnWmZUb4qbpxTD6IR/Is=
Date:   Fri, 08 Jul 2022 14:05:16 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, deller@gmx.de,
        david@redhat.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-dedup-hugepage-allocation-logic.patch added to mm-unstable branch
Message-Id: <20220708210516.F2935C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: dedup hugepage allocation logic
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-dedup-hugepage-allocation-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-dedup-hugepage-allocation-logic.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: dedup hugepage allocation logic
Date: Wed, 6 Jul 2022 16:59:33 -0700

The code

	p = alloc_mapping();
	printf("Allocate huge page...");
	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
	fill_memory(p, 0, hpage_pmd_size);
	if (check_huge(p))
		success("OK");
	else
		fail("Fail");

Is repeated many times in different tests.  Add a helper, alloc_hpage()
to handle this.

Link: https://lkml.kernel.org/r/20220706235936.2197195-16-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
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
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |   62 ++++++++--------------
 1 file changed, 23 insertions(+), 39 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-dedup-hugepage-allocation-logic
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -461,6 +461,25 @@ static void fill_memory(int *p, unsigned
 		p[i * page_size / sizeof(*p)] = i + 0xdead0000;
 }
 
+/*
+ * Returns pmd-mapped hugepage in VMA marked VM_HUGEPAGE, filled with
+ * validate_memory()'able contents.
+ */
+static void *alloc_hpage(void)
+{
+	void *p;
+
+	p = alloc_mapping();
+	printf("Allocate huge page...");
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	fill_memory(p, 0, hpage_pmd_size);
+	if (check_huge(p))
+		success("OK");
+	else
+		fail("Fail");
+	return p;
+}
+
 static void validate_memory(int *p, unsigned long start, unsigned long end)
 {
 	int i;
@@ -682,15 +701,7 @@ static void collapse_single_pte_entry_co
 {
 	void *p;
 
-	p = alloc_mapping();
-
-	printf("Allocate huge page...");
-	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
-	fill_memory(p, 0, hpage_pmd_size);
-	if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
+	p = alloc_hpage();
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 
 	printf("Split huge page leaving single PTE mapping compound page...");
@@ -710,16 +721,7 @@ static void collapse_full_of_compound(st
 {
 	void *p;
 
-	p = alloc_mapping();
-
-	printf("Allocate huge page...");
-	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
-	fill_memory(p, 0, hpage_pmd_size);
-	if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
-
+	p = alloc_hpage();
 	printf("Split huge page leaving single PTE page table full of compound pages...");
 	madvise(p, page_size, MADV_NOHUGEPAGE);
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
@@ -837,16 +839,7 @@ static void collapse_fork_compound(struc
 	int wstatus;
 	void *p;
 
-	p = alloc_mapping();
-
-	printf("Allocate huge page...");
-	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
-	fill_memory(p, 0, hpage_pmd_size);
-	if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
-
+	p = alloc_hpage();
 	printf("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
@@ -896,16 +889,7 @@ static void collapse_max_ptes_shared(str
 	int wstatus;
 	void *p;
 
-	p = alloc_mapping();
-
-	printf("Allocate huge page...");
-	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
-	fill_memory(p, 0, hpage_pmd_size);
-	if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
-
+	p = alloc_hpage();
 	printf("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch
mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
proc-smaps-add-pmdmappable-field-to-smaps.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

