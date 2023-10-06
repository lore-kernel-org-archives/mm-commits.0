Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502ECE94114
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 20:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjJFUPP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 16:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbjJFUPP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 16:15:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFEFBF
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 13:15:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B982C433C7;
        Fri,  6 Oct 2023 20:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696623310;
        bh=NjFtMC7UnOKQN9ZZ2XDg0DMje9a0z133OOSLgAc3dMY=;
        h=Date:To:From:Subject:From;
        b=LviqDF6oAZYvQDUtPSV5S/DIJkzNYX2ptER3FXPR1GIdRkQw51+j8cRoSlxudVcQX
         V6aigY9wXLK+RXf4KKH+WrnJhyYxRZg0TE2gP30vEsF7a4gVI0juxwFaEVtsExQRBQ
         jeei0LBZYC8L7F5eSgUy/QyuzrCuLYCg5JpJokFk=
Date:   Fri, 06 Oct 2023 13:15:08 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-read-faults-under-the-vma-lock.patch added to mm-unstable branch
Message-Id: <20231006201510.7B982C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle read faults under the VMA lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-read-faults-under-the-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-read-faults-under-the-vma-lock.patch

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
Subject: mm: handle read faults under the VMA lock
Date: Fri, 6 Oct 2023 20:53:17 +0100

Most file-backed faults are already handled through ->map_pages(), but if
we need to do I/O we'll come this way.  Since filemap_fault() is now safe
to be called under the VMA lock, we can handle these faults under the VMA
lock now.

Link: https://lkml.kernel.org/r/20231006195318.4087158-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-handle-read-faults-under-the-vma-lock
+++ a/mm/memory.c
@@ -4620,10 +4620,9 @@ static vm_fault_t do_read_fault(struct v
 			return ret;
 	}
 
-	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vmf->vma);
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

