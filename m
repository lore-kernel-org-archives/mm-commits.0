Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C346C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 19:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjGXTGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjGXTF7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 15:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5A510E6
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 12:05:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 571086129D
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 19:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896A0C433C7;
        Mon, 24 Jul 2023 19:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225555;
        bh=7UnSnHugmKaq7hctOGk3OCKiaIZaJVpEPN83nPQIgoI=;
        h=Date:To:From:Subject:From;
        b=dWrq+85d0Z6UEOmxWTMJua8Az1EJD5j3zVr2QsyzO88KS9TZSJZgNInIXS7TF2vN5
         Jsvcm25sdORzRi6+us2Kw5mRkPLtL6Qu+Qed+hHOA854qRxUggV32yh2WSZtvVBd5f
         hqyoBa9PZlUdPuOQAF75JiEIy405+bvEhwqtCkC8=
Date:   Mon, 24 Jul 2023 12:05:55 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch added to mm-unstable branch
Message-Id: <20230724190555.896A0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move FAULT_FLAG_VMA_LOCK check down in handle_pte_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch

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
Subject: mm: move FAULT_FLAG_VMA_LOCK check down in handle_pte_fault()
Date: Mon, 24 Jul 2023 19:54:06 +0100

Call do_pte_missing() under the VMA lock ...  then immediately retry in
do_fault().

Link: https://lkml.kernel.org/r/20230724185410.1124082-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault
+++ a/mm/memory.c
@@ -4773,6 +4773,11 @@ static vm_fault_t do_fault(struct vm_fau
 	struct mm_struct *vm_mm = vma->vm_mm;
 	vm_fault_t ret;
 
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK){
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+
 	/*
 	 * The VMA was not fully populated on mmap() or missing VM_DONTEXPAND
 	 */
@@ -5058,11 +5063,6 @@ static vm_fault_t handle_pte_fault(struc
 {
 	pte_t entry;
 
-	if ((vmf->flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vmf->vma)) {
-		vma_end_read(vmf->vma);
-		return VM_FAULT_RETRY;
-	}
-
 	if (unlikely(pmd_none(*vmf->pmd))) {
 		/*
 		 * Leave __pte_alloc() until later: because vm_ops->fault may
@@ -5095,6 +5095,12 @@ static vm_fault_t handle_pte_fault(struc
 	if (!vmf->pte)
 		return do_pte_missing(vmf);
 
+	if ((vmf->flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vmf->vma)) {
+		pte_unmap(vmf->pte);
+		vma_end_read(vmf->vma);
+		return VM_FAULT_RETRY;
+	}
+
 	if (!pte_present(vmf->orig_pte))
 		return do_swap_page(vmf);
 
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

