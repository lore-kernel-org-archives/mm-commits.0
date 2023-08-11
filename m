Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9004AC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbjHKXNc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237180AbjHKXNF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7381619F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12A5167942
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A194C433C8;
        Fri, 11 Aug 2023 23:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794980;
        bh=WDxZ0Nh81V3FsBSLTtzj7Zu+pVfNjBi+GsYXDkEEVDA=;
        h=Date:To:From:Subject:From;
        b=D7C4gFn3vSxiW4Of8Viq8JI6zTlsKJicUbdDAO1jPKFrhGQEYsfzfhm2HrLOKFXab
         X2De+Z4f8Pir8C/JCbNwsuwH7sOlU7/IDjmV2z/ILmBxxlOhvUGANSzseEHW0uRxaf
         teJbQBakw6wNEB/lhGN46sWW9D15edl1xYHZbQzM=
Date:   Fri, 11 Aug 2023 16:02:59 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-pud-faults-under-the-vma-lock.patch removed from -mm tree
Message-Id: <20230811230300.6A194C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle PUD faults under the VMA lock
has been removed from the -mm tree.  Its filename was
     mm-handle-pud-faults-under-the-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4859,11 +4859,17 @@ static vm_fault_t create_huge_pud(struct
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
@@ -4872,21 +4878,26 @@ static vm_fault_t wp_huge_pud(struct vm_
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
@@ -5006,11 +5017,6 @@ static vm_fault_t __handle_mm_fault(stru
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
@@ -5054,6 +5060,11 @@ retry_pud:
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

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
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
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
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

