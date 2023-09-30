Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6863DE7734E
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjI3AVU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjI3AVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AD71B0
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 17:21:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02DBC433C7;
        Sat, 30 Sep 2023 00:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033273;
        bh=uzdnCGdvy2Vu0YYOvU4M+R5Mo3M+U07NkfLJgxENqKk=;
        h=Date:To:From:Subject:From;
        b=dO3VTYt1ZVl78j/eZwx7BpV9lYfofP/29oX11lFwCiXfKAQVtZ4hlhueI4R4rIlVM
         gfWThm1t2/6SOlbMzkpxL1hMCClkS2jW+Y95gO0ZSx8AxN6pY8VIQ6ULiOMJYDMyoy
         lW+73VsZCAreMWlfWf++IljADNLJCiqBGazRaLCE=
Date:   Fri, 29 Sep 2023 17:21:12 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        fengwei.yin@intel.com, david@redhat.com, dave.hansen@intel.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-report-success-more-often-from-filemap_map_folio_range.patch removed from -mm tree
Message-Id: <20230930002113.A02DBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: report success more often from filemap_map_folio_range()
has been removed from the -mm tree.  Its filename was
     mm-report-success-more-often-from-filemap_map_folio_range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: report success more often from filemap_map_folio_range()
Date: Wed, 20 Sep 2023 04:53:35 +0100

Even though we had successfully mapped the relevant page, we would rarely
return success from filemap_map_folio_range().  That leads to falling back
from the VMA lock path to the mmap_lock path, which is a speed &
scalability issue.  Found by inspection.

Link: https://lkml.kernel.org/r/20230920035336.854212-1-willy@infradead.org
Fixes: 617c28ecab22 ("filemap: batch PTE mappings")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-report-success-more-often-from-filemap_map_folio_range
+++ a/mm/filemap.c
@@ -3503,7 +3503,7 @@ skip:
 		if (count) {
 			set_pte_range(vmf, folio, page, count, addr);
 			folio_ref_add(folio, count);
-			if (in_range(vmf->address, addr, count))
+			if (in_range(vmf->address, addr, count * PAGE_SIZE))
 				ret = VM_FAULT_NOPAGE;
 		}
 
@@ -3517,7 +3517,7 @@ skip:
 	if (count) {
 		set_pte_range(vmf, folio, page, count, addr);
 		folio_ref_add(folio, count);
-		if (in_range(vmf->address, addr, count))
+		if (in_range(vmf->address, addr, count * PAGE_SIZE))
 			ret = VM_FAULT_NOPAGE;
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-abstract-moving-to-the-next-pfn.patch
i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch
mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch
mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

