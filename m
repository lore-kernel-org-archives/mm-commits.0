Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBDDEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 17:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjGBRy5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 13:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjGBRy4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 13:54:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DD5E5E
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 10:54:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 710F760C77
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06CAC433C7;
        Sun,  2 Jul 2023 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688320493;
        bh=S1t+m6iZusDAB5BgwLljsID8eEXAVYIl1VAAnMyl4q0=;
        h=Date:To:From:Subject:From;
        b=tzgo+hJoC0OH7QiHSXRHJoKzagg/1JF+2m7cXasW+SogjqVE7PXJxNwR5TqFRr5ey
         FPG1U89ABnV14ZMxgjNSisxCjn5lJOiQawOM4Bof/mIxlxZcflABMc0gSLqXsG59uR
         Nta32Ho+wbO43Nxgp0rScz+eQQP/spNloSdffcEQ=
Date:   Sun, 02 Jul 2023 10:54:50 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, punit.agrawal@bytedance.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hughd@google.com,
        hdanton@sina.com, hch@lst.de, hannes@cmpxchg.org,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, apopple@nvidia.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch added to mm-unstable branch
Message-Id: <20230702175453.C06CAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop per-VMA lock when returning VM_FAULT_RETRY or VM_FAULT_COMPLETED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: drop per-VMA lock when returning VM_FAULT_RETRY or VM_FAULT_COMPLETED
Date: Fri, 30 Jun 2023 14:19:54 -0700

handle_mm_fault returning VM_FAULT_RETRY or VM_FAULT_COMPLETED means
mmap_lock has been released.  However with per-VMA locks behavior is
different and the caller should still release it.  To make the rules
consistent for the caller, drop the per-VMA lock when returning
VM_FAULT_RETRY or VM_FAULT_COMPLETED.  Currently the only path returning
VM_FAULT_RETRY under per-VMA locks is do_swap_page and no path returns
VM_FAULT_COMPLETED for now.

Link: https://lkml.kernel.org/r/20230630211957.1341547-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c   |    3 ++-
 arch/powerpc/mm/fault.c |    3 ++-
 arch/s390/mm/fault.c    |    3 ++-
 arch/x86/mm/fault.c     |    3 ++-
 mm/memory.c             |   12 ++++++++++++
 5 files changed, 20 insertions(+), 4 deletions(-)

--- a/arch/arm64/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed
+++ a/arch/arm64/mm/fault.c
@@ -602,7 +602,8 @@ static int __kprobes do_page_fault(unsig
 		goto lock_mmap;
 	}
 	fault = handle_mm_fault(vma, addr, mm_flags | FAULT_FLAG_VMA_LOCK, regs);
-	vma_end_read(vma);
+	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
--- a/arch/powerpc/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed
+++ a/arch/powerpc/mm/fault.c
@@ -489,7 +489,8 @@ static int ___do_page_fault(struct pt_re
 	}
 
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
-	vma_end_read(vma);
+	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
--- a/arch/s390/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed
+++ a/arch/s390/mm/fault.c
@@ -418,7 +418,8 @@ static inline vm_fault_t do_exception(st
 		goto lock_mmap;
 	}
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
-	vma_end_read(vma);
+	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+		vma_end_read(vma);
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
 		goto out;
--- a/arch/x86/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed
+++ a/arch/x86/mm/fault.c
@@ -1341,7 +1341,8 @@ void do_user_addr_fault(struct pt_regs *
 		goto lock_mmap;
 	}
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
-	vma_end_read(vma);
+	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
--- a/mm/memory.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed
+++ a/mm/memory.c
@@ -3733,6 +3733,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		ret = VM_FAULT_RETRY;
+		vma_end_read(vma);
 		goto out;
 	}
 
@@ -5185,6 +5186,17 @@ static vm_fault_t sanitize_fault_flags(s
 				 !is_cow_mapping(vma->vm_flags)))
 			return VM_FAULT_SIGSEGV;
 	}
+#ifdef CONFIG_PER_VMA_LOCK
+	/*
+	 * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT because of
+	 * the assumption that lock is dropped on VM_FAULT_RETRY.
+	 */
+	if (WARN_ON_ONCE((*flags &
+			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) ==
+			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
+		return VM_FAULT_SIGSEGV;
+#endif
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from surenb@google.com are

swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch

