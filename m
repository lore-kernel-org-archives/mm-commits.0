Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D91ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiILD2v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiILD2W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471C026136
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEE77B80C70
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEBEC43470;
        Mon, 12 Sep 2022 03:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953294;
        bh=AvmlmybB1tXGWS/bVsO0JNDY5ph3ZZgBEig0hRj0tl0=;
        h=Date:To:From:Subject:From;
        b=t4DZwJnLwfz+TOQZqpFfcnqj6aAsPTqn+IoQJBlP3vx0y5yMhy9nGbsJRqRMNuCjJ
         1F7aYNIPNYpi9WdoCBJKIGy5A+XmUyoSaTKPaa58DH0rmlvaEr5k3/2+HIjVVRiEu/
         r9snhoUPDBmGyg86rqTJjJHg/xFdl606CCXA6MV4=
Date:   Sun, 11 Sep 2022 20:28:13 -0700
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
Subject: [merged mm-stable] selftests-vm-dedup-hugepage-allocation-logic.patch removed from -mm tree
Message-Id: <20220912032814.8FEBEC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: dedup hugepage allocation logic
has been removed from the -mm tree.  Its filename was
     selftests-vm-dedup-hugepage-allocation-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
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

