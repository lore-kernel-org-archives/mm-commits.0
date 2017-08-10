From: akpm@linux-foundation.org
Subject: [folded-merged] mm-fix-madv_-tlb-flush-miss-problem-fix.patch
 removed from -mm tree
Date: Thu, 10 Aug 2017 15:19:36 -0700
Message-ID: <598cdbf8.O+I25muP+wk0twO6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47906 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753362AbdHJWTh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:19:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, nadav.amit@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: decrease tlb flush pending count in tlb_finish_mmu
has been removed from the -mm tree.  Its filename was
     mm-fix-madv_-tlb-flush-miss-problem-fix.patch

This patch was dropped because it was folded into mm-fix-madv_-tlb-flush-miss-problem.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: decrease tlb flush pending count in tlb_finish_mmu

The tlb pending count increased by tlb_gather_mmu should be decreased at
tlb_finish_mmu.  Otherwise, A lot of TLB happens which makes performance
regression.

Link: http://lkml.kernel.org/r/20170808080821.GA31730@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-fix-madv_-tlb-flush-miss-problem-fix mm/memory.c
--- a/mm/memory.c~mm-fix-madv_-tlb-flush-miss-problem-fix
+++ a/mm/memory.c
@@ -423,6 +423,7 @@ void tlb_finish_mmu(struct mmu_gather *t
 	bool force = mm_tlb_flush_nested(tlb->mm);
 
 	arch_tlb_finish_mmu(tlb, start, end, force);
+	dec_tlb_flush_pending(tlb->mm);
 }
 
 /*
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-refactoring-tlb-gathering-api.patch
mm-make-tlb_flush_pending-global.patch
mm-fix-madv_-tlb-flush-miss-problem.patch
mm-fix-ksm-data-corruption.patch
zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch
zram-inlining-zram_compress.patch
zram-rename-zram_decompress_page-with-__zram_bvec_read.patch
zram-add-interface-to-specify-backing-device.patch
zram-add-free-space-management-in-backing-device.patch
zram-identify-asynchronous-ios-return-value.patch
zram-write-incompressible-pages-to-backing-device.patch
zram-read-page-from-backing-device.patch
zram-add-config-and-doc-file-for-writeback-feature.patch

