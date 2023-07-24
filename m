Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0645EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 19:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjGXTF5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjGXTFw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 15:05:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE05710E4
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 12:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 781876131D
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 19:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EECC433C7;
        Mon, 24 Jul 2023 19:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225549;
        bh=OCuiGWKRLPqx/ZeBgnxRjeTeWy51rSiqqgMAK03IPvI=;
        h=Date:To:From:Subject:From;
        b=2wMEMiTNiP7NI9oefuYq5QdUSsMdB+p0RLIyslpiJLPxAELsNJfPuDyQNE0gwvdJS
         QmI1ignCpe2N9UShS5ikqQ7b1N/DxdduIlhCWsX7YR4Lce0Mp5q5OaZcFl+UTQl42w
         CMIDkLcA1EzSWEb7oxrUqknD5Ly+ScwVgdahqqcA=
Date:   Mon, 24 Jul 2023 12:05:49 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch added to mm-unstable branch
Message-Id: <20230724190549.A5EECC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move FAULT_FLAG_VMA_LOCK check from handle_mm_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch

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
Subject: mm: move FAULT_FLAG_VMA_LOCK check from handle_mm_fault()
Date: Mon, 24 Jul 2023 19:54:03 +0100

Handle a little more of the page fault path outside the mmap sem.  The
hugetlb path doesn't need to check whether the VMA is anonymous; the
VM_HUGETLB flag is only set on hugetlbfs VMAs.  There should be no
performance change from the previous commit; this is simply a step to ease
bisection of any problems.

Link: https://lkml.kernel.org/r/20230724185410.1124082-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++++
 mm/memory.c  |   18 +++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~mm-move-fault_flag_vma_lock-check-from-handle_mm_fault
+++ a/mm/hugetlb.c
@@ -6089,6 +6089,12 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	int need_wait_lock = 0;
 	unsigned long haddr = address & huge_page_mask(h);
 
+	/* TODO: Handle faults under the VMA lock */
+	if (flags & FAULT_FLAG_VMA_LOCK) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+
 	/*
 	 * Serialize hugepage allocation and instantiation, so that we don't
 	 * get spurious allocation failures if two CPUs race to instantiate
--- a/mm/memory.c~mm-move-fault_flag_vma_lock-check-from-handle_mm_fault
+++ a/mm/memory.c
@@ -5110,10 +5110,10 @@ unlock:
 }
 
 /*
- * By the time we get here, we already hold the mm semaphore
- *
- * The mmap_lock may have been released depending on flags and our
- * return value.  See filemap_fault() and __folio_lock_or_retry().
+ * On entry, we hold either the VMA lock or the mmap_lock
+ * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set in
+ * the result, the mmap_lock is not held on exit.  See filemap_fault()
+ * and __folio_lock_or_retry().
  */
 static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags)
@@ -5132,6 +5132,11 @@ static vm_fault_t __handle_mm_fault(stru
 	p4d_t *p4d;
 	vm_fault_t ret;
 
+	if ((flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vma)) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+
 	pgd = pgd_offset(mm, address);
 	p4d = p4d_alloc(mm, pgd, address);
 	if (!p4d)
@@ -5359,11 +5364,6 @@ vm_fault_t handle_mm_fault(struct vm_are
 		goto out;
 	}
 
-	if ((flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vma)) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
-
 	/*
 	 * Enable the memcg OOM handling for faults triggered in user
 	 * space.  Kernel faults are handled more gracefully.
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-remove-config_per_vma_lock-ifdefs.patch
mm-allow-per-vma-locks-on-file-backed-vmas.patch
mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch
mm-handle-pud-faults-under-the-vma-lock.patch
mm-handle-some-pmd-faults-under-the-vma-lock.patch
mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch
mm-move-fault_flag_vma_lock-check-down-from-do_fault.patch
mm-run-the-fault-around-code-under-the-vma-lock.patch
mm-handle-swap-and-numa-pte-faults-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch

