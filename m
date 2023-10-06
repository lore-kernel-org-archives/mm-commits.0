Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135CBE9410A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbjJFTS0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjJFTSZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:18:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCEAA2;
        Fri,  6 Oct 2023 12:18:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B030CC433CA;
        Fri,  6 Oct 2023 19:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619903;
        bh=QI29I3DlfPkKEl854+NQuvPDPNWvR84y/r5nhlYEXxo=;
        h=Date:To:From:Subject:From;
        b=XxnLajM99R/O6KLaE+nDr2lpoWFQVttL0blJraxOSEwhGWz6eC1e9TD2QxBjNEs4g
         APn9/Rmn5jcF2LMCuvds3Zs4k1Y06VE0pJycZM9gozKKfKHyxiUg8FJUktffRpYS7W
         ocDNXVGlK4mg4TRYipVBsSWQ20RWtNTVCxmXIBlE=
Date:   Fri, 06 Oct 2023 12:18:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, muchun.song@linux.dev,
        mike.kravetz@oracle.com, riel@surriel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-clear-resv_map-pointer-if-mmap-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20231006191822.B030CC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: clear resv_map pointer if mmap fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlbfs-clear-resv_map-pointer-if-mmap-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-clear-resv_map-pointer-if-mmap-fails.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Rik van Riel <riel@surriel.com>
Subject: hugetlbfs: clear resv_map pointer if mmap fails
Date: Thu, 5 Oct 2023 23:59:06 -0400

Patch series "hugetlbfs: close race between MADV_DONTNEED and page fault", v7.

Malloc libraries, like jemalloc and tcalloc, take decisions on when to
call madvise independently from the code in the main application.

This sometimes results in the application page faulting on an address,
right after the malloc library has shot down the backing memory with
MADV_DONTNEED.

Usually this is harmless, because we always have some 4kB pages sitting
around to satisfy a page fault.  However, with hugetlbfs systems often
allocate only the exact number of huge pages that the application wants.

Due to TLB batching, hugetlbfs MADV_DONTNEED will free pages outside of
any lock taken on the page fault path, which can open up the following
race condition:

       CPU 1                            CPU 2

       MADV_DONTNEED
       unmap page
       shoot down TLB entry
                                       page fault
                                       fail to allocate a huge page
                                       killed with SIGBUS
       free page

Fix that race by extending the hugetlb_vma_lock locking scheme to also
cover private hugetlb mappings (with resv_map), and pulling the locking
from __unmap_hugepage_final_range into helper functions called from
zap_page_range_single.  This ensures page faults stay locked out of the
MADV_DONTNEED VMA until the huge pages have actually been freed.


This patch (of 3):

Hugetlbfs leaves a dangling pointer in the VMA if mmap fails.  This has
not been a problem so far, but other code in this patch series tries to
follow that pointer.

Link: https://lkml.kernel.org/r/20231006040020.3677377-1-riel@surriel.com
Link: https://lkml.kernel.org/r/20231006040020.3677377-2-riel@surriel.com
Fixes: 04ada095dcfc ("hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlbfs-clear-resv_map-pointer-if-mmap-fails
+++ a/mm/hugetlb.c
@@ -1138,8 +1138,7 @@ static void set_vma_resv_map(struct vm_a
 	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
 	VM_BUG_ON_VMA(vma->vm_flags & VM_MAYSHARE, vma);
 
-	set_vma_private_data(vma, (get_vma_private_data(vma) &
-				HPAGE_RESV_MASK) | (unsigned long)map);
+	set_vma_private_data(vma, (unsigned long)map);
 }
 
 static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long flags)
@@ -6811,8 +6810,10 @@ out_err:
 		 */
 		if (chg >= 0 && add < 0)
 			region_abort(resv_map, from, to, regions_needed);
-	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		kref_put(&resv_map->refs, resv_map_release);
+		set_vma_resv_map(vma, NULL);
+	}
 	return false;
 }
 
_

Patches currently in -mm which might be from riel@surriel.com are

hugetlbfs-clear-resv_map-pointer-if-mmap-fails.patch
hugetlbfs-extend-hugetlb_vma_lock-to-private-vmas.patch
hugetlbfs-close-race-between-madv_dontneed-and-page-fault.patch

