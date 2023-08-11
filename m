Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4F0C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbjHKXOC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237187AbjHKXNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4BB26A0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D6FF67AD3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD9FC433CA;
        Fri, 11 Aug 2023 23:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794985;
        bh=fcwt1ZSRxU2mArJr/yyUhuvslp+ws8PFRv1j0oiz4zs=;
        h=Date:To:From:Subject:From;
        b=PdgUMB0w+C1eQEM7HxFGvRGx8RQejaLSYo5l2AwNW2loB57McWO8FQVH//iDSUPXW
         l1Y0CRkGjMrGnlzNrKbZp9grwW0nnZnVQxT3WNQCypTr2SnfZyIuDUy7K/bFg02XRm
         +vc1Tm0CgENCo8nNRwi2CYBtX0l5RnPfVz9I8ESY=
Date:   Fri, 11 Aug 2023 16:03:05 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-run-the-fault-around-code-under-the-vma-lock.patch removed from -mm tree
Message-Id: <20230811230305.BFD9FC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: run the fault-around code under the VMA lock
has been removed from the -mm tree.  Its filename was
     mm-run-the-fault-around-code-under-the-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: run the fault-around code under the VMA lock
Date: Mon, 24 Jul 2023 19:54:08 +0100

The map_pages fs method should be safe to run under the VMA lock instead
of the mmap lock.  This should have a measurable reduction in contention
on the mmap lock.

Link: https://lkml.kernel.org/r/20230724185410.1124082-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-run-the-fault-around-code-under-the-vma-lock
+++ a/mm/memory.c
@@ -4533,11 +4533,6 @@ static vm_fault_t do_read_fault(struct v
 	vm_fault_t ret = 0;
 	struct folio *folio;
 
-	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vmf->vma);
-		return VM_FAULT_RETRY;
-	}
-
 	/*
 	 * Let's call ->map_pages() first and use ->fault() as fallback
 	 * if page by the offset is not ready to be mapped (cold cache or
@@ -4549,6 +4544,11 @@ static vm_fault_t do_read_fault(struct v
 			return ret;
 	}
 
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		vma_end_read(vmf->vma);
+		return VM_FAULT_RETRY;
+	}
+
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
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

