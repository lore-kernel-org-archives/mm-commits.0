Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E16C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbjHKXGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbjHKXFF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743F2270E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BF3B67AD3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ADFC433C8;
        Fri, 11 Aug 2023 23:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794988;
        bh=n3EQVjjNBInSf/sL17aLzuGY5vIuN/WNsqlGcpivPhs=;
        h=Date:To:From:Subject:From;
        b=mjjhcgguKEkXCBjy/BT3nh+GrBFOdwnwqqlF5KsPx400pc4PtXDgbWFjkGuIAI2rQ
         22uuiuWJq+yNt8y0RltmghjwRBADLBZ2sFk6FemlezS4Xm08HD6QN/m3VnEesoCuTP
         0gDfCYlvf5McD67TLSyChwPZcuokbuJ6boRdZSwI=
Date:   Fri, 11 Aug 2023 16:03:07 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch removed from -mm tree
Message-Id: <20230811230308.65ADFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle faults that merely update the accessed bit under the VMA lock
has been removed from the -mm tree.  Its filename was
     mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: handle faults that merely update the accessed bit under the VMA lock
Date: Mon, 24 Jul 2023 19:54:10 +0100

Move FAULT_FLAG_VMA_LOCK check out of handle_pte_fault().  This should
have a significant performance improvement for mmaped files.  Write faults
(on read-only shared pages) still take the mmap lock as we do not want to
audit all the implementations of ->pfn_mkwrite() and ->page_mkwrite(). 
However write-faults on private mappings are handled under the VMA lock.

[willy@infradead.org: address "suspicious RCU usage" warning]
  Link: https://lkml.kernel.org/r/ZMK7jwpI4uD6tKrF@casper.infradead.org
Link: https://lkml.kernel.org/r/20230724185410.1124082-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock
+++ a/mm/memory.c
@@ -3268,6 +3268,11 @@ static vm_fault_t wp_pfn_shared(struct v
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
@@ -3290,6 +3295,12 @@ static vm_fault_t wp_page_shared(struct
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
@@ -3431,6 +3442,12 @@ reuse:
 		return 0;
 	}
 copy:
+	if ((vmf->flags & FAULT_FLAG_VMA_LOCK) && !vma->anon_vma) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		vma_end_read(vmf->vma);
+		return VM_FAULT_RETRY;
+	}
+
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
@@ -4985,12 +5002,6 @@ static vm_fault_t handle_pte_fault(struc
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

