Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FA0CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 19:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjJRTNT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 15:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjJRTNQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 15:13:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF228133;
        Wed, 18 Oct 2023 12:13:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CC6C433C9;
        Wed, 18 Oct 2023 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697656394;
        bh=CbiZ+XPJ2doFmIVjBORRbaj8pINn0bHMqxr8Erk7Bow=;
        h=Date:To:From:Subject:From;
        b=vvh7Sk4SjBqWiizMga6527CxbYPsawh0Dt83e3N1+7TEGmQfIeNRchgF+bKbc3Cw1
         +vAmBoo/Zl4RjeSRU1Mjhm0wIDUOlTaTrOR3ldkTQAiCOH3fNSic7UQiwrKqoJWoW2
         54JbL+L8Xhh0gQKiF5nJKuKAqT0hRwrrUadkU5aQ=
Date:   Wed, 18 Oct 2023 12:13:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, muchun.song@linux.dev,
        mike.kravetz@oracle.com, riel@surriel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlbfs-clear-resv_map-pointer-if-mmap-fails.patch removed from -mm tree
Message-Id: <20231018191314.71CC6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: clear resv_map pointer if mmap fails
has been removed from the -mm tree.  Its filename was
     hugetlbfs-clear-resv_map-pointer-if-mmap-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


