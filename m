Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D74BC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjHKXNF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbjHKXNC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B56F1736
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD40F666E3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22519C433C7;
        Fri, 11 Aug 2023 23:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794983;
        bh=Jny8+1d7aXbK9SNV8DMK61tbVJ9oKPYQdK9h4MAb52E=;
        h=Date:To:From:Subject:From;
        b=pHohKtNkRqTsQmNn4wXQyCNN6qMT6CXXycujFRF/zrUWhX6g3GBqiZpYyZ2ceLVIJ
         buJT0R27uGrJrxYOwQ+HI3qSCrgjcqKZWCmLFpezcFC4jqocYJUicLLmNSo6F2UokJ
         cNuJb5f5fDSEzOIZ4L+2l/Jv8WDpQm/sh3RZsAVw=
Date:   Fri, 11 Aug 2023 16:03:02 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch removed from -mm tree
Message-Id: <20230811230303.22519C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move FAULT_FLAG_VMA_LOCK check down in handle_pte_fault()
has been removed from the -mm tree.  Its filename was
     mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4647,6 +4647,11 @@ static vm_fault_t do_fault(struct vm_fau
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
@@ -4932,11 +4937,6 @@ static vm_fault_t handle_pte_fault(struc
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
@@ -4969,6 +4969,12 @@ static vm_fault_t handle_pte_fault(struc
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

