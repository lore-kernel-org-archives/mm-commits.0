Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09E8E82CA7
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 15:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjI0P6S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjI0P6O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 11:58:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98487194
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 08:58:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DC0C433C7;
        Wed, 27 Sep 2023 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695830292;
        bh=noeqPipeL+j2oNZgeRembDYcaZ5GwskAVw5srBZPZew=;
        h=Date:To:From:Subject:From;
        b=Mjxxo7CSZdyGx+RQPbqOlxLxVmJuk/0+wjH3up9BJnWUd75ljfH42WOflkMDNNFNY
         4IDBHOmqXZH0xD4kfykw50wWRsnb5W/eMoEYZ+1yqinbq84SqvJFTq175Uc/tdKnFS
         HJsF2XOaGNMLJOEe5WwccNhxBuy67v70PZ2WLdc0=
Date:   Wed, 27 Sep 2023 08:58:11 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-call-wp_page_copy-under-the-vma-lock.patch added to mm-unstable branch
Message-Id: <20230927155812.32DC0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call wp_page_copy() under the VMA lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-call-wp_page_copy-under-the-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-call-wp_page_copy-under-the-vma-lock.patch

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
Subject: mm: call wp_page_copy() under the VMA lock
Date: Wed, 27 Sep 2023 06:25:00 +0100

It is usually safe to call wp_page_copy() under the VMA lock.  The only
unsafe situation is when no anon_vma has been allocated for this VMA, and
we have to look at adjacent VMAs to determine if their anon_vma can be
shared.  Since this happens only for the first COW of a page in this VMA,
the majority of calls to wp_page_copy() do not need to fall back to the
mmap_sem.

Add vmf_anon_prepare() as an alternative to anon_vma_prepare() which will
return RETRY if we currently hold the VMA lock and need to allocate an
anon_vma.  This lets us drop the check in do_wp_page().

Link: https://lkml.kernel.org/r/20230927052505.2855872-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

--- a/mm/memory.c~mm-call-wp_page_copy-under-the-vma-lock
+++ a/mm/memory.c
@@ -3045,6 +3045,21 @@ static inline void wp_page_reuse(struct
 	count_vm_event(PGREUSE);
 }
 
+static vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+
+	if (likely(vma->anon_vma))
+		return 0;
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+	if (__anon_vma_prepare(vma))
+		return VM_FAULT_OOM;
+	return 0;
+}
+
 /*
  * Handle the case of a page which we actually need to copy to a new page,
  * either due to COW or unsharing.
@@ -3072,27 +3087,29 @@ static vm_fault_t wp_page_copy(struct vm
 	pte_t entry;
 	int page_copied = 0;
 	struct mmu_notifier_range range;
-	int ret;
+	vm_fault_t ret;
 
 	delayacct_wpcopy_start();
 
 	if (vmf->page)
 		old_folio = page_folio(vmf->page);
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
+	ret = vmf_anon_prepare(vmf);
+	if (unlikely(ret))
+		goto out;
 
 	if (is_zero_pfn(pte_pfn(vmf->orig_pte))) {
 		new_folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
 		if (!new_folio)
 			goto oom;
 	} else {
+		int err;
 		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
 				vmf->address, false);
 		if (!new_folio)
 			goto oom;
 
-		ret = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
-		if (ret) {
+		err = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
+		if (err) {
 			/*
 			 * COW failed, if the fault was solved by other,
 			 * it's fine. If not, userspace would re-fault on
@@ -3105,7 +3122,7 @@ static vm_fault_t wp_page_copy(struct vm
 				folio_put(old_folio);
 
 			delayacct_wpcopy_end();
-			return ret == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
+			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
 		kmsan_copy_page_meta(&new_folio->page, vmf->page);
 	}
@@ -3215,11 +3232,13 @@ static vm_fault_t wp_page_copy(struct vm
 oom_free_new:
 	folio_put(new_folio);
 oom:
+	ret = VM_FAULT_OOM;
+out:
 	if (old_folio)
 		folio_put(old_folio);
 
 	delayacct_wpcopy_end();
-	return VM_FAULT_OOM;
+	return ret;
 }
 
 /**
@@ -3461,12 +3480,6 @@ reuse:
 		return 0;
 	}
 copy:
-	if ((vmf->flags & FAULT_FLAG_VMA_LOCK) && !vma->anon_vma) {
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		vma_end_read(vmf->vma);
-		return VM_FAULT_RETRY;
-	}
-
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
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

