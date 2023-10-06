Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C80E94115
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 20:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbjJFUPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 16:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjJFUO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 16:14:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E14FBD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 13:14:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB92CC433C7;
        Fri,  6 Oct 2023 20:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696623298;
        bh=MabzTckMYRcgkxx6iZx2v+p0QVIYbH8d3k1cAj4IZes=;
        h=Date:To:From:Subject:From;
        b=Mxipi+Bu32AymorpIVUV+JJwYe9n0+wZm4tBrBmg/BUC8HtmlYsJ8NYlsA2b4IfQs
         wS6525xfqG3bPjtCn645Hxpo3O2Nzei3Khq6LGhkNXXhi7wcWls2Vw0HQvLH/C7j1L
         V6QCesEnqF7QIC2k8TPdnq+embh+jW/Rb6rFyLrc=
Date:   Fri, 06 Oct 2023 13:14:55 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-shared-faults-under-the-vma-lock.patch added to mm-unstable branch
Message-Id: <20231006201457.DB92CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle shared faults under the VMA lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-shared-faults-under-the-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-shared-faults-under-the-vma-lock.patch

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
Subject: mm: handle shared faults under the VMA lock
Date: Fri, 6 Oct 2023 20:53:15 +0100

There are many implementations of ->fault and some of them depend on
mmap_lock being held.  All vm_ops that implement ->map_pages() end up
calling filemap_fault(), which I have audited to be sure it does not rely
on mmap_lock.  So (for now) key off ->map_pages existing as a flag to
indicate that it's safe to call ->fault while only holding the vma lock.

Link: https://lkml.kernel.org/r/20231006195318.4087158-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-handle-shared-faults-under-the-vma-lock
+++ a/mm/memory.c
@@ -3045,6 +3045,21 @@ static inline void wp_page_reuse(struct
 	count_vm_event(PGREUSE);
 }
 
+/*
+ * We could add a bitflag somewhere, but for now, we know that all
+ * vm_ops that have a ->map_pages have been audited and don't need
+ * the mmap_lock to be held.
+ */
+static inline vm_fault_t vmf_can_call_fault(const struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+
+	if (vma->vm_ops->map_pages || !(vmf->flags & FAULT_FLAG_VMA_LOCK))
+		return 0;
+	vma_end_read(vma);
+	return VM_FAULT_RETRY;
+}
+
 static vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -4672,10 +4687,9 @@ static vm_fault_t do_shared_fault(struct
 	vm_fault_t ret, tmp;
 	struct folio *folio;
 
-	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
+	ret = vmf_can_call_fault(vmf);
+	if (ret)
+		return ret;
 
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
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

