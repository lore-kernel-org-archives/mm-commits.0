Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DD3C6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiIKXXQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiIKXXN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC6C252B9;
        Sun, 11 Sep 2022 16:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC1E2B80B94;
        Sun, 11 Sep 2022 23:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD5AC433D7;
        Sun, 11 Sep 2022 23:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938587;
        bh=BEOAADO3g1s4sJyuu//w0CxzVqEvfXHYzk5JTnaunxw=;
        h=Date:To:From:Subject:From;
        b=GvKL1SfFQIrAa6x54V02Hbf0YG5Cb8ma+hy3rMcfZ2Ovlxb5SGfthxbaSx8K8v6BJ
         XespXSKEUepXJRgGyr/3Xe6lCo8W+hsaNq7p7tY9oeAPhmxcNJlVpG7UhvbFIP0SUM
         DoUnBUTaGMreB7Jo8MPzlFTqzaxAJZFGZh0dJwIE=
Date:   Sun, 11 Sep 2022 16:23:06 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, stable@vger.kernel.org, rcampbell@nvidia.com,
        peterx@redhat.com, paulus@ozlabs.org, nadav.amit@gmail.com,
        lyude@redhat.com, logang@deltatee.com, kherbst@redhat.com,
        jhubbard@nvidia.com, jgg@nvidia.com, huang.ying.caritas@gmail.com,
        Felix.Kuehling@amd.com, david@redhat.com, bskeggs@redhat.com,
        alex.sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate_devicec-flush-tlb-while-holding-ptl.patch removed from -mm tree
Message-Id: <20220911232307.5AD5AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate_device.c: flush TLB while holding PTL
has been removed from the -mm tree.  Its filename was
     mm-migrate_devicec-flush-tlb-while-holding-ptl.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate_device.c: flush TLB while holding PTL
Date: Fri, 2 Sep 2022 10:35:51 +1000

When clearing a PTE the TLB should be flushed whilst still holding the PTL
to avoid a potential race with madvise/munmap/etc.  For example consider
the following sequence:

  CPU0                          CPU1
  ----                          ----

  migrate_vma_collect_pmd()
  pte_unmap_unlock()
                                madvise(MADV_DONTNEED)
                                -> zap_pte_range()
                                pte_offset_map_lock()
                                [ PTE not present, TLB not flushed ]
                                pte_unmap_unlock()
                                [ page is still accessible via stale TLB ]
  flush_tlb_range()

In this case the page may still be accessed via the stale TLB entry after
madvise returns.  Fix this by flushing the TLB while holding the PTL.

Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Link: https://lkml.kernel.org/r/9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_devicec-flush-tlb-while-holding-ptl
+++ a/mm/migrate_device.c
@@ -254,13 +254,14 @@ next:
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = mpfn;
 	}
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(ptep - 1, ptl);
 
 	/* Only flush the TLB if we actually modified any entries */
 	if (unmapped)
 		flush_tlb_range(walk->vma, start, end);
 
+	arch_leave_lazy_mmu_mode();
+	pte_unmap_unlock(ptep - 1, ptl);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
selftests-hmm-tests-add-test-for-dirty-bits.patch
mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch
mm-gupc-refactor-check_and_migrate_movable_pages.patch
mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch

