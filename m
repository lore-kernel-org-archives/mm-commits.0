Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F247E82CA7
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 15:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjI0P6N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbjI0P6M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 11:58:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9369191
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 08:58:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E09C433C8;
        Wed, 27 Sep 2023 15:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695830290;
        bh=tiT4oyj8Az1XzxN4sXhvftz8kiBYqBsYnRxA25VBpJw=;
        h=Date:To:From:Subject:From;
        b=F4CmQRSJSxB8Vh9aUaSnAOcWDRqGVvav7lYOITypexYrkgfVrPMXw9Dwip/1R74Xk
         fjC83zaf4TpQ6LLnjgKwB5r58Dw/gXZfyNAhe4ECKdQ4WBiKuC1FA0EvEOBIuvfLkh
         A43ZhBGHjMqC02r5dCIagn1gkJKVaY69K5E9+yMY=
Date:   Wed, 27 Sep 2023 08:58:09 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch added to mm-unstable branch
Message-Id: <20230927155810.65E09C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make lock_folio_maybe_drop_mmap() VMA lock aware
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch

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
Subject: mm: make lock_folio_maybe_drop_mmap() VMA lock aware
Date: Wed, 27 Sep 2023 06:24:59 +0100

Patch series "Handle more faults under the VMA lock".

At this point, we're handling the majority of file-backed page faults
under the VMA lock, using the ->map_pages entry point.  This patch set
attempts to expand that for the following siutations:

 - We have to do a read.  This could be because we've hit the point in
   the readahead window where we need to kick off the next readahead,
   or because the page is simply not present in cache.
 - We're handling a write fault.  Most applications don't do I/O by writes
   to shared mmaps for very good reasons, but some do, and it'd be nice
   to not make that slow unnecessarily.
 - We're doing a COW of a private mapping (both PTE already present
   and PTE not-present).  These are two different codepaths and I handle
   both of them in this patch set.

There is no support in this patch set for drivers to mark themselves as
being VMA lock friendly; they could implement the ->map_pages
vm_operation, but if they do, they would be the first.  This is probably
something we want to change at some point in the future, and I've marked
where to make that change in the code.


This patch (of 6):

Drop the VMA lock instead of the mmap_lock if that's the one which is
held.

Link: https://lkml.kernel.org/r/20230927052505.2855872-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230927052505.2855872-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware
+++ a/mm/filemap.c
@@ -3090,7 +3090,7 @@ static int lock_folio_maybe_drop_mmap(st
 
 	/*
 	 * NOTE! This will make us return with VM_FAULT_RETRY, but with
-	 * the mmap_lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
+	 * the fault lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
 	 * is supposed to work. We have way too many special cases..
 	 */
 	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
@@ -3100,13 +3100,14 @@ static int lock_folio_maybe_drop_mmap(st
 	if (vmf->flags & FAULT_FLAG_KILLABLE) {
 		if (__folio_lock_killable(folio)) {
 			/*
-			 * We didn't have the right flags to drop the mmap_lock,
-			 * but all fault_handlers only check for fatal signals
-			 * if we return VM_FAULT_RETRY, so we need to drop the
-			 * mmap_lock here and return 0 if we don't have a fpin.
+			 * We didn't have the right flags to drop the
+			 * fault lock, but all fault_handlers only check
+			 * for fatal signals if we return VM_FAULT_RETRY,
+			 * so we need to drop the fault lock here and
+			 * return 0 if we don't have a fpin.
 			 */
 			if (*fpin == NULL)
-				mmap_read_unlock(vmf->vma->vm_mm);
+				release_fault_lock(vmf);
 			return 0;
 		}
 	} else
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

