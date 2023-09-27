Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FCAE82CA9
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 15:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjI0P61 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjI0P6U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 11:58:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4FB191
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 08:58:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583CDC433C7;
        Wed, 27 Sep 2023 15:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695830299;
        bh=EZaJceYFxjnlp/A7t9ylth9Z7m2NfztTEn0JhX65z18=;
        h=Date:To:From:Subject:From;
        b=Mg0QoYZmzfVokZfk5UBls2l/f/KGUNFWM1ycCHCv/wWUNlU3XzylCr7N97oPOL9De
         gL4GJBHuNYBcbevNCrj8e6pYtFvUTsZcYZ4jomip7dLZeRp3DMIwhGCzfSGc5qK4xX
         B8oT/6mBpXBjtPEctYL6/EByCFKnyazmOVvG7rJk=
Date:   Wed, 27 Sep 2023 08:58:18 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch added to mm-unstable branch
Message-Id: <20230927155819.583CDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle write faults to RO pages under the VMA lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: handle write faults to RO pages under the VMA lock
Date: Wed, 27 Sep 2023 06:25:04 +0100

I think this is a pretty rare occurrence, but for consistency handle
faults with the VMA lock held the same way that we handle other faults
with the VMA lock held.

Link: https://lkml.kernel.org/r/20230927052505.2855872-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-handle-write-faults-to-ro-pages-under-the-vma-lock
+++ a/mm/memory.c
@@ -3304,10 +3304,9 @@ static vm_fault_t wp_pfn_shared(struct v
 		vm_fault_t ret;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-			vma_end_read(vmf->vma);
-			return VM_FAULT_RETRY;
-		}
+		ret = vmf_maybe_unlock_vma(vmf);
+		if (ret)
+			return ret;
 
 		vmf->flags |= FAULT_FLAG_MKWRITE;
 		ret = vma->vm_ops->pfn_mkwrite(vmf);
@@ -3331,10 +3330,10 @@ static vm_fault_t wp_page_shared(struct
 		vm_fault_t tmp;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		tmp = vmf_maybe_unlock_vma(vmf);
+		if (tmp) {
 			folio_put(folio);
-			vma_end_read(vmf->vma);
-			return VM_FAULT_RETRY;
+			return tmp;
 		}
 
 		tmp = do_page_mkwrite(vmf, folio);
_

Patches currently in -mm which might be from willy@infradead.org are

i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch
mm-report-success-more-often-from-filemap_map_folio_range.patch
mm-abstract-moving-to-the-next-pfn.patch
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

