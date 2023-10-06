Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3148E94114
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 20:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbjJFUPL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 16:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjJFUPJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 16:15:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E823CBF
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 13:15:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226DFC433C9;
        Fri,  6 Oct 2023 20:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696623307;
        bh=Sz8jb7z7RHRBRPEGw7ORbresLyrUiohwi3cDhNeH/hk=;
        h=Date:To:From:Subject:From;
        b=YrHvI1+ZCxUwKL9r3zyTWog2uxES2hMxGWeTlIZH3p5k/1YIczUCi6wCg6M2lqgGO
         M3E0HIk7Nz4uIkjacQGidurfqTASbpg0uGhAASfn/WFwhVRbSlJ8FHjoV7qWg419gC
         P2yNoeh4/kkk3+/q4fS39jTFwHI7ONX0EMy2IsYQ=
Date:   Fri, 06 Oct 2023 13:15:04 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch added to mm-unstable branch
Message-Id: <20231006201507.226DFC433C9@smtp.kernel.org>
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
Date: Fri, 6 Oct 2023 20:53:18 +0100

I think this is a pretty rare occurrence, but for consistency handle
faults with the VMA lock held the same way that we handle other faults
with the VMA lock held.

Link: https://lkml.kernel.org/r/20231006195318.4087158-7-willy@infradead.org
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
+		ret = vmf_can_call_fault(vmf);
+		if (ret)
+			return ret;
 
 		vmf->flags |= FAULT_FLAG_MKWRITE;
 		ret = vma->vm_ops->pfn_mkwrite(vmf);
@@ -3331,10 +3330,10 @@ static vm_fault_t wp_page_shared(struct
 		vm_fault_t tmp;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		tmp = vmf_can_call_fault(vmf);
+		if (tmp) {
 			folio_put(folio);
-			vma_end_read(vmf->vma);
-			return VM_FAULT_RETRY;
+			return tmp;
 		}
 
 		tmp = do_page_mkwrite(vmf, folio);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch
iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch
iomap-protect-read_bytes_pending-with-the-state_lock.patch
mm-add-folio_end_read.patch
ext4-use-folio_end_read.patch
buffer-use-folio_end_read.patch
iomap-use-folio_end_read.patch
bitops-add-xor_unlock_is_negative_byte.patch
alpha-implement-xor_unlock_is_negative_byte.patch
m68k-implement-xor_unlock_is_negative_byte.patch
mips-implement-xor_unlock_is_negative_byte.patch
powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch
riscv-implement-xor_unlock_is_negative_byte.patch
s390-implement-arch_xor_unlock_is_negative_byte.patch
mm-delete-checks-for-xor_unlock_is_negative_byte.patch
mm-add-folio_xor_flags_has_waiters.patch
mm-make-__end_folio_writeback-return-void.patch
mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch

