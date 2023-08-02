Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8ADC001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 18:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjHBSwE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjHBSv4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 14:51:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219B4B0
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 11:51:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A41F061AB0
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 18:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051CBC433C8;
        Wed,  2 Aug 2023 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691002300;
        bh=a9J4KQQTXbeuF/fmjeeVKAYF/uZXBXGvILkBoXWnzi8=;
        h=Date:To:From:Subject:From;
        b=GonNvARw3zIgD4lAFGNg8ylgcLcE2sv5pWwm6rzJ0+xjIySmCMwwJ/zZOyqdjdmlQ
         ARzY9PpE0JRlSN7BtP63d1mBkN6cKvTyLyCH8Uq+A8ohPR5AzlQVUgpGUJEIi+0L3i
         9DAqSo7bFsjoeqPfw0dtXPjZI1/5qMYl+KdtWuBU=
Date:   Wed, 02 Aug 2023 11:51:39 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        anshuman.khandual@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-generic-flush_icache_pages-and-documentation.patch added to mm-unstable branch
Message-Id: <20230802185140.051CBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add generic flush_icache_pages() and documentation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-generic-flush_icache_pages-and-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-generic-flush_icache_pages-and-documentation.patch

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
Subject: mm: add generic flush_icache_pages() and documentation
Date: Wed, 2 Aug 2023 16:13:31 +0100

flush_icache_page() is deprecated but not yet removed, so add a range
version of it.  Change the documentation to refer to
update_mmu_cache_range() instead of update_mmu_cache().

Link: https://lkml.kernel.org/r/20230802151406.3735276-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/cachetlb.rst |   41 ++++++++++++++------------
 include/asm-generic/cacheflush.h    |    5 +++
 2 files changed, 28 insertions(+), 18 deletions(-)

--- a/Documentation/core-api/cachetlb.rst~mm-add-generic-flush_icache_pages-and-documentation
+++ a/Documentation/core-api/cachetlb.rst
@@ -88,13 +88,17 @@ changes occur:
 
 	This is used primarily during fault processing.
 
-5) ``void update_mmu_cache(struct vm_area_struct *vma,
-   unsigned long address, pte_t *ptep)``
+5) ``void update_mmu_cache_range(struct vm_fault *vmf,
+   struct vm_area_struct *vma, unsigned long address, pte_t *ptep,
+   unsigned int nr)``
+
+	At the end of every page fault, this routine is invoked to tell
+	the architecture specific code that translations now exists
+	in the software page tables for address space "vma->vm_mm"
+	at virtual address "address" for "nr" consecutive pages.
 
-	At the end of every page fault, this routine is invoked to
-	tell the architecture specific code that a translation
-	now exists at virtual address "address" for address space
-	"vma->vm_mm", in the software page tables.
+	This routine is also invoked in various other places which pass
+	a NULL "vmf".
 
 	A port may use this information in any way it so chooses.
 	For example, it could use this event to pre-load TLB
@@ -306,17 +310,18 @@ maps this page at its virtual address.
 	private".  The kernel guarantees that, for pagecache pages, it will
 	clear this bit when such a page first enters the pagecache.
 
-	This allows these interfaces to be implemented much more efficiently.
-	It allows one to "defer" (perhaps indefinitely) the actual flush if
-	there are currently no user processes mapping this page.  See sparc64's
-	flush_dcache_page and update_mmu_cache implementations for an example
-	of how to go about doing this.
-
-	The idea is, first at flush_dcache_page() time, if page_file_mapping()
-	returns a mapping, and mapping_mapped on that mapping returns %false,
-	just mark the architecture private page flag bit.  Later, in
-	update_mmu_cache(), a check is made of this flag bit, and if set the
-	flush is done and the flag bit is cleared.
+	This allows these interfaces to be implemented much more
+	efficiently.  It allows one to "defer" (perhaps indefinitely) the
+	actual flush if there are currently no user processes mapping this
+	page.  See sparc64's flush_dcache_page and update_mmu_cache_range
+	implementations for an example of how to go about doing this.
+
+	The idea is, first at flush_dcache_page() time, if
+	page_file_mapping() returns a mapping, and mapping_mapped on that
+	mapping returns %false, just mark the architecture private page
+	flag bit.  Later, in update_mmu_cache_range(), a check is made
+	of this flag bit, and if set the flush is done and the flag bit
+	is cleared.
 
 	.. important::
 
@@ -369,7 +374,7 @@ maps this page at its virtual address.
   ``void flush_icache_page(struct vm_area_struct *vma, struct page *page)``
 
 	All the functionality of flush_icache_page can be implemented in
-	flush_dcache_page and update_mmu_cache. In the future, the hope
+	flush_dcache_page and update_mmu_cache_range. In the future, the hope
 	is to remove this interface completely.
 
 The final category of APIs is for I/O to deliberately aliased address
--- a/include/asm-generic/cacheflush.h~mm-add-generic-flush_icache_pages-and-documentation
+++ a/include/asm-generic/cacheflush.h
@@ -78,6 +78,11 @@ static inline void flush_icache_range(un
 #endif
 
 #ifndef flush_icache_page
+static inline void flush_icache_pages(struct vm_area_struct *vma,
+				     struct page *page, unsigned int nr)
+{
+}
+
 static inline void flush_icache_page(struct vm_area_struct *vma,
 				     struct page *page)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
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
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock-fix.patch
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

