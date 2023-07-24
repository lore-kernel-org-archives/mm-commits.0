Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17212C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 19:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjGXTF7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjGXTF5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 15:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492AA10E3
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 12:05:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB4CC611F8
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 19:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F69C433C7;
        Mon, 24 Jul 2023 19:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225552;
        bh=rVl2fBYSGJLM1cdwUwp/eCWrcujGSKKl5NNaB0r8pIc=;
        h=Date:To:From:Subject:From;
        b=fs9hgPCD7WaSULvUEwwDItkwaZDZiY9kM/nJL63AnS1EX778LlmsFXweQKEPzjBhq
         PvbqyaE1kdgNk/PE1baWVsYXlEt41ALHc+OoliQhlmY4eH8Tr/iVX0AgAIiMQpikDN
         apwDgz/cM8jwbSFQ4zTG8KjCbuG8VbShxoLl8sh4=
Date:   Mon, 24 Jul 2023 12:05:51 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-pud-faults-under-the-vma-lock.patch added to mm-unstable branch
Message-Id: <20230724190551.E1F69C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle PUD faults under the VMA lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-pud-faults-under-the-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-pud-faults-under-the-vma-lock.patch

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
Subject: mm: handle PUD faults under the VMA lock
Date: Mon, 24 Jul 2023 19:54:04 +0100

Postpone checking the VMA_LOCK flag until we've attempted to handle faults
on PUDs.  There's a mild upside to this patch in that we'll allocate the
page tables while under the VMA lock rather than the mmap lock, reducing
the hold time on the mmap lock, since the retry will find the page tables
already populated.  The real purpose here is to make a commit that shows
we don't call ->huge_fault under the VMA lock.  We do now handle setting
the accessed bit on a PUD fault under the VMA lock, but that doesn't seem
likely to be a measurable difference.

Link: https://lkml.kernel.org/r/20230724185410.1124082-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/mm/memory.c~mm-handle-pud-faults-under-the-vma-lock
+++ a/mm/memory.c
@@ -4985,11 +4985,17 @@ static vm_fault_t create_huge_pud(struct
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	struct vm_area_struct *vma = vmf->vma;
 	/* No support for anonymous transparent PUD pages yet */
-	if (vma_is_anonymous(vmf->vma))
+	if (vma_is_anonymous(vma))
 		return VM_FAULT_FALLBACK;
-	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+	if (vma->vm_ops->huge_fault) {
+		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+			vma_end_read(vma);
+			return VM_FAULT_RETRY;
+		}
+		return vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+	}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 	return VM_FAULT_FALLBACK;
 }
@@ -4998,21 +5004,26 @@ static vm_fault_t wp_huge_pud(struct vm_
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret;
 
 	/* No support for anonymous transparent PUD pages yet */
-	if (vma_is_anonymous(vmf->vma))
+	if (vma_is_anonymous(vma))
 		goto split;
-	if (vmf->vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
-		if (vmf->vma->vm_ops->huge_fault) {
-			ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		if (vma->vm_ops->huge_fault) {
+			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+				vma_end_read(vma);
+				return VM_FAULT_RETRY;
+			}
+			ret = vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
 		}
 	}
 split:
 	/* COW or write-notify not handled on PUD level: split pud.*/
-	__split_huge_pud(vmf->vma, vmf->pud, vmf->address);
+	__split_huge_pud(vma, vmf->pud, vmf->address);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 	return VM_FAULT_FALLBACK;
 }
@@ -5132,11 +5143,6 @@ static vm_fault_t __handle_mm_fault(stru
 	p4d_t *p4d;
 	vm_fault_t ret;
 
-	if ((flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vma)) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
-
 	pgd = pgd_offset(mm, address);
 	p4d = p4d_alloc(mm, pgd, address);
 	if (!p4d)
@@ -5180,6 +5186,11 @@ retry_pud:
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
+	if ((flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vma)) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+
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

