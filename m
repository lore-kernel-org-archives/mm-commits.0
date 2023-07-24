Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA00EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 19:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjGXTGB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjGXTF6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 15:05:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E776171E
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 12:05:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 893E4611F8
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 19:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76D7C433C7;
        Mon, 24 Jul 2023 19:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225553;
        bh=4Y3FB6wQWtbV6ZytyilbdD7aXnr/f3vMuEk2JDZgtEc=;
        h=Date:To:From:Subject:From;
        b=2ctfE7UM7wm0hBPm+kn9ifi1F8f+gO+iuEV3+sYZ358hbv10jt8YN/beX5ce0nLyp
         mg+UEUYyXm6imYaeeLR6BOKveR6i94m29gq3+OL1PFLjVVIqpRpNnUe2n0wnMcTJLV
         XkrhJ/GGtX4wWQry6xs2T/ysLFctbzcJETrDdTfs=
Date:   Mon, 24 Jul 2023 12:05:53 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-some-pmd-faults-under-the-vma-lock.patch added to mm-unstable branch
Message-Id: <20230724190553.B76D7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle some PMD faults under the VMA lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-some-pmd-faults-under-the-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-some-pmd-faults-under-the-vma-lock.patch

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
Subject: mm: handle some PMD faults under the VMA lock
Date: Mon, 24 Jul 2023 19:54:05 +0100

Push the VMA_LOCK check down from __handle_mm_fault() to
handle_pte_fault().  Once again, we refuse to call ->huge_fault() with the
VMA lock held, but we will wait for a PMD migration entry with the VMA
lock held, handle NUMA migration and set the accessed bit.  We were
already doing this for anonymous VMAs, so it should be safe.

Link: https://lkml.kernel.org/r/20230724185410.1124082-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

--- a/mm/memory.c~mm-handle-some-pmd-faults-under-the-vma-lock
+++ a/mm/memory.c
@@ -4947,36 +4947,47 @@ out_map:
 
 static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 {
-	if (vma_is_anonymous(vmf->vma))
+	struct vm_area_struct *vma = vmf->vma;
+	if (vma_is_anonymous(vma))
 		return do_huge_pmd_anonymous_page(vmf);
-	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+	if (vma->vm_ops->huge_fault) {
+		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+			vma_end_read(vma);
+			return VM_FAULT_RETRY;
+		}
+		return vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+	}
 	return VM_FAULT_FALLBACK;
 }
 
 /* `inline' is required to avoid gcc 4.1.2 build error */
 static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	vm_fault_t ret;
 
-	if (vma_is_anonymous(vmf->vma)) {
+	if (vma_is_anonymous(vma)) {
 		if (likely(!unshare) &&
-		    userfaultfd_huge_pmd_wp(vmf->vma, vmf->orig_pmd))
+		    userfaultfd_huge_pmd_wp(vma, vmf->orig_pmd))
 			return handle_userfault(vmf, VM_UFFD_WP);
 		return do_huge_pmd_wp_page(vmf);
 	}
 
-	if (vmf->vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
-		if (vmf->vma->vm_ops->huge_fault) {
-			ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		if (vma->vm_ops->huge_fault) {
+			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+				vma_end_read(vma);
+				return VM_FAULT_RETRY;
+			}
+			ret = vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
 		}
 	}
 
 	/* COW or write-notify handled on pte level: split pmd. */
-	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
+	__split_huge_pmd(vma, vmf->pmd, vmf->address, false, NULL);
 
 	return VM_FAULT_FALLBACK;
 }
@@ -5047,6 +5058,11 @@ static vm_fault_t handle_pte_fault(struc
 {
 	pte_t entry;
 
+	if ((vmf->flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vmf->vma)) {
+		vma_end_read(vmf->vma);
+		return VM_FAULT_RETRY;
+	}
+
 	if (unlikely(pmd_none(*vmf->pmd))) {
 		/*
 		 * Leave __pte_alloc() until later: because vm_ops->fault may
@@ -5186,11 +5202,6 @@ retry_pud:
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if ((flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vma)) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
-
 	if (pmd_none(*vmf.pmd) &&
 	    hugepage_vma_check(vma, vm_flags, false, true, true)) {
 		ret = create_huge_pmd(&vmf);
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

