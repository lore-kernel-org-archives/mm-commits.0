Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD11C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359491AbiEMTYO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382819AbiEMTW6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CC43CFD1
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5F51B83159
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9144CC34100;
        Fri, 13 May 2022 19:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469719;
        bh=wuI/xpqX7gasfScM1fj6ZVOBkXniqUFQT8fnNPX/v3M=;
        h=Date:To:From:Subject:From;
        b=g9iyLagFV+3ImLIhPwBLVS8SpDPE779dz3e5WwhZ6rtmMw2Z4YOgf+TgCPEqwOsr4
         cULVsYpK+cXnQd9zbs5rH7NiGcyylytJP6BQNTpOUcUNUawxQpc3jKJDo78xngGIeM
         huBClVM6kUTHm/XAe0asLjQIVftXTqcLiCeew25w=
Date:   Fri, 13 May 2022 12:21:59 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch removed from -mm tree
Message-Id: <20220513192159.9144CC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: turn shmem_should_replace_page into shmem_should_replace_folio
has been removed from the -mm tree.  Its filename was
     mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/shmem: turn shmem_should_replace_page into shmem_should_replace_folio

This is a straightforward conversion.

Link: https://lkml.kernel.org/r/20220504182857.4013401-20-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio
+++ a/mm/shmem.c
@@ -1601,9 +1601,9 @@ failed:
  * NUMA mempolicy, and applied also to anonymous pages in do_swap_page();
  * but for now it is a simple matter of zone.
  */
-static bool shmem_should_replace_page(struct page *page, gfp_t gfp)
+static bool shmem_should_replace_folio(struct folio *folio, gfp_t gfp)
 {
-	return page_zonenum(page) > gfp_zone(gfp);
+	return folio_zonenum(folio) > gfp_zone(gfp);
 }
 
 static int shmem_replace_page(struct page **pagep, gfp_t gfp,
@@ -1735,13 +1735,13 @@ static int shmem_swapin_page(struct inod
 	 */
 	arch_swap_restore(swap, page);
 
-	if (shmem_should_replace_page(page, gfp)) {
+	folio = page_folio(page);
+	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_page(&page, gfp, info, index);
 		if (error)
 			goto failed;
 	}
 
-	folio = page_folio(page);
 	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp,
 					charge_mm);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

