Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D846ACCA473
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiGDBNC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiGDBL5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2546422
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C9B9B803F6
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8972C341C6;
        Mon,  4 Jul 2022 01:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897056;
        bh=C+cQN1npwhGQeHgzsf39QyFf7KDH0v3w72wutVe1isA=;
        h=Date:To:From:Subject:From;
        b=OVEZxSoyniYIYfXu8kPVXHQld6JfDv5vA1Pxl62raIxHZzIff7UZmbqhB488mV9Ky
         hk17cO37X9kygVWcQgT8W1wV7donl8zF8q0d5JiBp96sEPfWTmqPIbp+3Cfo8AFt6X
         OV1oKo6uF9YbR0Xo2LNKGT7cWJkqoPCi57pwmpcs=
Date:   Sun, 03 Jul 2022 18:10:56 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch removed from -mm tree
Message-Id: <20220704011056.C8972C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: remove unneeded shmem_huge_enabled() check
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: remove unneeded shmem_huge_enabled() check
Date: Sat, 25 Jun 2022 17:28:10 +0800

Patch series "A few cleanup patches for khugepaged", v2.

This series contains a few cleaup patches to remove unneeded return value,
use helper macro, fix typos and so on.  More details can be found in the
respective changelogs.


This patch (of 7):

If we reach here, khugepaged_scan_mm_slot() has already made sure that
hugepage is enabled for shmem, via its call to hugepage_vma_check(). 
Remove this duplicated check.

Link: https://lkml.kernel.org/r/20220625092816.4856-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220625092816.4856-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-unneeded-shmem_huge_enabled-check
+++ a/mm/khugepaged.c
@@ -2145,8 +2145,6 @@ skip:
 		if (khugepaged_scan.address < hstart)
 			khugepaged_scan.address = hstart;
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
-		if (shmem_file(vma->vm_file) && !shmem_huge_enabled(vma))
-			goto skip;
 
 		while (khugepaged_scan.address < hend) {
 			int ret;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

