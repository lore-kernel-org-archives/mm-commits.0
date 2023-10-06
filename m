Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7A5E94115
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 20:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbjJFUO5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 16:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjJFUO4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 16:14:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862FFBD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 13:14:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C002CC433C8;
        Fri,  6 Oct 2023 20:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696623295;
        bh=88j0PQu+3Gk+Ik4ulxUnYzUzHHveH4hAAATWSodabHc=;
        h=Date:To:From:Subject:From;
        b=ZCcfGYTiWLffbQHVEKF9sm9MCOc7Os7vQejpjNuvrh09dsGhw31nhK2Cqt1cGIMwQ
         F7yrpkXG4MEK/pz0RLQdR8SQhqZnHKgUN1vM4w0/JpihQK/u0A20A1SQpw+LTX/HNS
         n6YcKCNfE7rDNvSEMy3VhfuJJisJBIjnY2h4ERhU=
Date:   Fri, 06 Oct 2023 13:14:51 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch added to mm-unstable branch
Message-Id: <20231006201454.C002CC433C8@smtp.kernel.org>
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
Date: Fri, 6 Oct 2023 20:53:13 +0100

Patch series "Handle more faults under the VMA lock", v2.

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

There is very little performance change in the benchmarks we've run;
mostly because the vast majority of page faults are handled through the
other paths.  I still think this patch series is useful for workloads that
may take these paths more often, and just for cleaning up the fault path
in general (it's now clearer why we have to retry in these cases).


This patch (of 6):

Drop the VMA lock instead of the mmap_lock if that's the one which
is held.

Link: https://lkml.kernel.org/r/20231006195318.4087158-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231006195318.4087158-2-willy@infradead.org
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

