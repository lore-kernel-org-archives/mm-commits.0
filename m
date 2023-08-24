Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4496EE49A6
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241993AbjHXXVr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235590AbjHXXVI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFE6A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDDC0646AB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D98C433C8;
        Thu, 24 Aug 2023 23:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919265;
        bh=vndkl3WRZB/OJiIscG9iKSgv8rUtjCMitDhY4uPxfxg=;
        h=Date:To:From:Subject:From;
        b=zmE4Dch6kiTABqnR7OydctaE1HceFoEerMQVilSnncw6TgZ6aH9P9Rz7YMBSeexvW
         M0rqRHYxivgS2JyyaTCkwXn26R+Mfp9Iqxc8orQRb7KmXbAPQYGmYL5Kr1UEw/LYt9
         92+oKTc3rtQHH8kzy+6yqGQi47QJwXXYbgGqqdfI=
Date:   Thu, 24 Aug 2023 16:21:04 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, punit.agrawal@bytedance.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hughd@google.com,
        hdanton@sina.com, hch@lst.de, hannes@cmpxchg.org,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        conor.dooley@microchip.com, brauner@kernel.org, apopple@nvidia.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch removed from -mm tree
Message-Id: <20230824232105.26D98C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: drop per-VMA lock when returning VM_FAULT_RETRY or VM_FAULT_COMPLETED
has been removed from the -mm tree.  Its filename was
     mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[willy@infradead.org: fix riscv]
  Link: https://lkml.kernel.org/r/CAJuCfpE6GWEx1rPBmNpUfoD5o-gNFz9-UFywzCE2PbEGBiVz7g@mail.gmail.com
Link: https://lkml.kernel.org/r/20230630211957.1341547-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
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
 arch/riscv/mm/fault.c   |    3 ++-
 arch/s390/mm/fault.c    |    3 ++-
 arch/x86/mm/fault.c     |    3 ++-
 mm/memory.c             |   12 ++++++++++++
 6 files changed, 22 insertions(+), 5 deletions(-)

--- a/arch/arm64/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed
+++ a/arch/arm64/mm/fault.c
@@ -599,7 +599,8 @@ static int __kprobes do_page_fault(unsig
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
@@ -488,7 +488,8 @@ static int ___do_page_fault(struct pt_re
 	}
 
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
-	vma_end_read(vma);
+	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
--- a/arch/riscv/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed
+++ a/arch/riscv/mm/fault.c
@@ -296,7 +296,8 @@ void handle_page_fault(struct pt_regs *r
 	}
 
 	fault = handle_mm_fault(vma, addr, flags | FAULT_FLAG_VMA_LOCK, regs);
-	vma_end_read(vma);
+	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
--- a/arch/s390/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed
+++ a/arch/s390/mm/fault.c
@@ -417,7 +417,8 @@ static inline vm_fault_t do_exception(st
 		goto lock_mmap;
 	}
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
-	vma_end_read(vma);
+	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+		vma_end_read(vma);
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
 		if (likely(!(fault & VM_FAULT_ERROR)))
--- a/arch/x86/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed
+++ a/arch/x86/mm/fault.c
@@ -1340,7 +1340,8 @@ void do_user_addr_fault(struct pt_regs *
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
@@ -3747,6 +3747,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		ret = VM_FAULT_RETRY;
+		vma_end_read(vma);
 		goto out;
 	}
 
@@ -5248,6 +5249,17 @@ static vm_fault_t sanitize_fault_flags(s
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


