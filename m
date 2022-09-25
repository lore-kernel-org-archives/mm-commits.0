Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CA6C54EE9
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiIYTNW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiIYTNV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:13:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D2124BD4
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA555612B1
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4690C433D6;
        Sun, 25 Sep 2022 19:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664133199;
        bh=+cQZyDJ6MtYmdHxDF0kfspVHP0ew4VSX3LXOFTYMjt4=;
        h=Date:To:From:Subject:From;
        b=AMduNzdrSXzLFC1giMiyoXoENQzMnq/HvBPNk+LcMUrt8owvUCzNRoeW6bRc6Aolh
         VkfD73HbbUEM6pPrqmTC86pEI/qok4aZIgwsjio/JiqekOcrqXu42GrWtbFDm6+Qrb
         05wTLoJHtP7gSZ9wtDLxHwJmDyfiopiaHAZPNzrs=
Date:   Sun, 25 Sep 2022 12:13:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch added to mm-unstable branch
Message-Id: <20220925191318.B4690C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: check compound_order() in collapse_pte_mapped_thp()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch

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
Subject: mm/khugepaged: check compound_order() in collapse_pte_mapped_thp()
Date: Thu, 22 Sep 2022 15:27:31 -0700

By the time we lock a page in collapse_pte_mapped_thp(), the page mapped
by the address pushed onto the slot's .pte_mapped_thp[] array might have
changed arbitrarily since we last looked at it.  We revalidate that the
page is still the head of a compound page, but we don't revalidate if the
compound page is of order HPAGE_PMD_ORDER before applying rmap and page
table updates.

Since the kernel now supports large folios of arbitrary order, and since
replacing page's pte mappings by a pmd mapping only makes sense for
compound pages of order HPAGE_PMD_ORDER, revalidate that the compound
order is indeed of order HPAGE_PMD_ORDER before proceeding.

Link: https://lore.kernel.org/linux-mm/CAHbLzkon+2ky8v9ywGcsTUgXM_B35jt5NThYqQKXW2YV_GUacw@mail.gmail.com/
Link: https://lkml.kernel.org/r/20220922222731.1124481-1-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Suggested-by: Yang Shi <shy828301@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/khugepaged.c~mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp
+++ a/mm/khugepaged.c
@@ -1399,6 +1399,9 @@ void collapse_pte_mapped_thp(struct mm_s
 	if (!PageHead(hpage))
 		goto drop_hpage;
 
+	if (compound_order(hpage) != HPAGE_PMD_ORDER)
+		goto drop_hpage;
+
 	if (find_pmd_or_thp_or_none(mm, haddr, &pmd) != SCAN_SUCCEED)
 		goto drop_hpage;
 
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch
mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch
selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch
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

