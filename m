Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B4DC04A6A
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 19:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjGXTGZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjGXTGU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 15:06:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CAA1993
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 12:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95B6A6129D
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 19:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F91C433C7;
        Mon, 24 Jul 2023 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225562;
        bh=A1QMdbubhUNVfTm/NArdHlfSvnaMapbAgiv3ffI+T7U=;
        h=Date:To:From:Subject:From;
        b=DWPJwWuJlVzZqwMs/zMusCZJBpl34C29YgNKrz/xIhhHShRpEPP+W0Xusaguv26IG
         0CgR2RgCBWmwgNk+CJwjoQoVgY6GsgKfIVyitzvbQXZHTfa8b3FsRfJ2pY/hF+Wcq0
         OS035ijvKLycR1qR78sMxz2+dc0MPKw0/Cp8Fx8o=
Date:   Mon, 24 Jul 2023 12:06:02 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch added to mm-unstable branch
Message-Id: <20230724190602.C4F91C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle faults that merely update the accessed bit under the VMA lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch

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
Subject: mm: handle faults that merely update the accessed bit under the VMA lock
Date: Mon, 24 Jul 2023 19:54:10 +0100

Move FAULT_FLAG_VMA_LOCK check out of handle_pte_fault().  This should
have a significant performance improvement for mmaped files.  Write faults
(on read-only shared pages) still take the mmap lock as we do not want to
audit all the implementations of ->pfn_mkwrite() and ->page_mkwrite(). 
However write-faults on private mappings are handled under the VMA lock.

Link: https://lkml.kernel.org/r/20230724185410.1124082-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock
+++ a/mm/memory.c
@@ -3391,6 +3391,11 @@ static vm_fault_t wp_pfn_shared(struct v
 		vm_fault_t ret;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+			vma_end_read(vmf->vma);
+			return VM_FAULT_RETRY;
+		}
+
 		vmf->flags |= FAULT_FLAG_MKWRITE;
 		ret = vma->vm_ops->pfn_mkwrite(vmf);
 		if (ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))
@@ -3413,6 +3418,12 @@ static vm_fault_t wp_page_shared(struct
 		vm_fault_t tmp;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+			folio_put(folio);
+			vma_end_read(vmf->vma);
+			return VM_FAULT_RETRY;
+		}
+
 		tmp = do_page_mkwrite(vmf, folio);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
@@ -5111,12 +5122,6 @@ static vm_fault_t handle_pte_fault(struc
 	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
 		return do_numa_page(vmf);
 
-	if ((vmf->flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vmf->vma)) {
-		pte_unmap(vmf->pte);
-		vma_end_read(vmf->vma);
-		return VM_FAULT_RETRY;
-	}
-
 	spin_lock(vmf->ptl);
 	entry = vmf->orig_pte;
 	if (unlikely(!pte_same(ptep_get(vmf->pte), entry))) {
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

