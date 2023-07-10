Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC1BEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjGJXby (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjGJXbt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:31:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FCBA6
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAB3361261
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DEDC433C7;
        Mon, 10 Jul 2023 23:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031907;
        bh=aB59qmco5FziD2ZC6oj1kyk2KvH0nTbh1NcVJKvyGIs=;
        h=Date:To:From:Subject:From;
        b=OG9r52OgvtSzHtGP6EFr8WTyg9fmUdnz7PO3WjIrwenxFEHYzeJQ3BPrPjRc8hX/j
         Ri9PXei0z8fKmfXilzN/MTWDNtiVmk3avnK3SFyb6F8deoEzgHopYoN0RQ1f+0qgB4
         qr26vU9KFxM3Ce4hfXlckv5C0AskZlsrk0mSjK6o=
Date:   Mon, 10 Jul 2023 16:31:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch added to mm-unstable branch
Message-Id: <20230710233147.07DEDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call update_mmu_cache_range() in more page fault handling paths
has been added to the -mm mm-unstable branch.  Its filename is
     mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

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
Subject: mm: call update_mmu_cache_range() in more page fault handling paths
Date: Mon, 10 Jul 2023 21:43:39 +0100

Pass the vm_fault to the architecture to help it make smarter decisions
about which PTEs to insert into the TLB.

Link: https://lkml.kernel.org/r/20230710204339.3554919-39-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths
+++ a/mm/memory.c
@@ -2867,7 +2867,7 @@ static inline int __wp_page_copy_user(st
 
 		entry = pte_mkyoung(vmf->orig_pte);
 		if (ptep_set_access_flags(vma, addr, vmf->pte, entry, 0))
-			update_mmu_cache(vma, addr, vmf->pte);
+			update_mmu_cache_range(vmf, vma, addr, vmf->pte, 1);
 	}
 
 	/*
@@ -3045,7 +3045,7 @@ static inline void wp_page_reuse(struct
 	entry = pte_mkyoung(vmf->orig_pte);
 	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
-		update_mmu_cache(vma, vmf->address, vmf->pte);
+		update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	count_vm_event(PGREUSE);
 }
@@ -3169,7 +3169,7 @@ static vm_fault_t wp_page_copy(struct vm
 		 */
 		BUG_ON(unshare && pte_write(entry));
 		set_pte_at_notify(mm, vmf->address, vmf->pte, entry);
-		update_mmu_cache(vma, vmf->address, vmf->pte);
+		update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 		if (old_folio) {
 			/*
 			 * Only after switching the pte to the new page may
@@ -4039,7 +4039,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 	/* No need to invalidate - it was non-present before */
-	update_mmu_cache(vma, vmf->address, vmf->pte);
+	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -4163,7 +4163,7 @@ setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
 
 	/* No need to invalidate - it was non-present before */
-	update_mmu_cache(vma, vmf->address, vmf->pte);
+	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -4837,7 +4837,7 @@ out_map:
 	if (writable)
 		pte = pte_mkwrite(pte);
 	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
-	update_mmu_cache(vma, vmf->address, vmf->pte);
+	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	goto out;
 }
@@ -4986,7 +4986,8 @@ static vm_fault_t handle_pte_fault(struc
 	entry = pte_mkyoung(entry);
 	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
 				vmf->flags & FAULT_FLAG_WRITE)) {
-		update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
+		update_mmu_cache_range(vmf, vmf->vma, vmf->address,
+				vmf->pte, 1);
 	} else {
 		/* Skip spurious TLB flush for retried page fault */
 		if (vmf->flags & FAULT_FLAG_TRIED)
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

