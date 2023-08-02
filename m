Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECA3C001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 18:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjHBSwO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbjHBSv6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 14:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EE52D42
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 11:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 773A961A7C
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 18:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA22EC433C8;
        Wed,  2 Aug 2023 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691002305;
        bh=J9lb2DKvPbhbiKp12JdBfsXpKzPwgOHXRO84zXZHemk=;
        h=Date:To:From:Subject:From;
        b=JXoy9+PQ5xAe+DvMpZp93ghAoH7LFggjwonkhJt9ZP1q0K8nMhqsQ9usGFUwuc3uG
         RC8PclO9XTnXmQsnYwS9B+P5V6fM1wmiU+OYqeiv9OCcLv+g5QqLLz+rPgf9aL+Sm9
         sWFKYOx8JduPgOt305uvuZGi28BdhmoYgH8z9nEQ=
Date:   Wed, 02 Aug 2023 11:51:45 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        anshuman.khandual@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-arch_implements_flush_dcache_folio.patch added to mm-unstable branch
Message-Id: <20230802185145.CA22EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove ARCH_IMPLEMENTS_FLUSH_DCACHE_FOLIO
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-arch_implements_flush_dcache_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-arch_implements_flush_dcache_folio.patch

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
Subject: mm: remove ARCH_IMPLEMENTS_FLUSH_DCACHE_FOLIO
Date: Wed, 2 Aug 2023 16:13:33 +0100

Current best practice is to reuse the name of the function as a define to
indicate that the function is implemented by the architecture.

Link: https://lkml.kernel.org/r/20230802151406.3735276-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/cachetlb.rst |   24 +++++++++---------------
 include/linux/cacheflush.h          |    4 ++--
 mm/util.c                           |    2 +-
 3 files changed, 12 insertions(+), 18 deletions(-)

--- a/Documentation/core-api/cachetlb.rst~mm-remove-arch_implements_flush_dcache_folio
+++ a/Documentation/core-api/cachetlb.rst
@@ -273,7 +273,7 @@ maps this page at its virtual address.
 	If D-cache aliasing is not an issue, these two routines may
 	simply call memcpy/memset directly and do nothing more.
 
-  ``void flush_dcache_page(struct page *page)``
+  ``void flush_dcache_folio(struct folio *folio)``
 
         This routines must be called when:
 
@@ -281,7 +281,7 @@ maps this page at its virtual address.
 	     and / or in high memory
 	  b) the kernel is about to read from a page cache page and user space
 	     shared/writable mappings of this page potentially exist.  Note
-	     that {get,pin}_user_pages{_fast} already call flush_dcache_page
+	     that {get,pin}_user_pages{_fast} already call flush_dcache_folio
 	     on any page found in the user address space and thus driver
 	     code rarely needs to take this into account.
 
@@ -295,7 +295,7 @@ maps this page at its virtual address.
 
 	The phrase "kernel writes to a page cache page" means, specifically,
 	that the kernel executes store instructions that dirty data in that
-	page at the page->virtual mapping of that page.  It is important to
+	page at the kernel virtual mapping of that page.  It is important to
 	flush here to handle D-cache aliasing, to make sure these kernel stores
 	are visible to user space mappings of that page.
 
@@ -306,18 +306,18 @@ maps this page at its virtual address.
 	If D-cache aliasing is not an issue, this routine may simply be defined
 	as a nop on that architecture.
 
-        There is a bit set aside in page->flags (PG_arch_1) as "architecture
+        There is a bit set aside in folio->flags (PG_arch_1) as "architecture
 	private".  The kernel guarantees that, for pagecache pages, it will
 	clear this bit when such a page first enters the pagecache.
 
 	This allows these interfaces to be implemented much more
 	efficiently.  It allows one to "defer" (perhaps indefinitely) the
 	actual flush if there are currently no user processes mapping this
-	page.  See sparc64's flush_dcache_page and update_mmu_cache_range
+	page.  See sparc64's flush_dcache_folio and update_mmu_cache_range
 	implementations for an example of how to go about doing this.
 
-	The idea is, first at flush_dcache_page() time, if
-	page_file_mapping() returns a mapping, and mapping_mapped on that
+	The idea is, first at flush_dcache_folio() time, if
+	folio_flush_mapping() returns a mapping, and mapping_mapped() on that
 	mapping returns %false, just mark the architecture private page
 	flag bit.  Later, in update_mmu_cache_range(), a check is made
 	of this flag bit, and if set the flush is done and the flag bit
@@ -331,12 +331,6 @@ maps this page at its virtual address.
 			dirty.  Again, see sparc64 for examples of how
 			to deal with this.
 
-  ``void flush_dcache_folio(struct folio *folio)``
-	This function is called under the same circumstances as
-	flush_dcache_page().  It allows the architecture to
-	optimise for flushing the entire folio of pages instead
-	of flushing one page at a time.
-
   ``void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
   unsigned long user_vaddr, void *dst, void *src, int len)``
   ``void copy_from_user_page(struct vm_area_struct *vma, struct page *page,
@@ -357,7 +351,7 @@ maps this page at its virtual address.
 
   	When the kernel needs to access the contents of an anonymous
 	page, it calls this function (currently only
-	get_user_pages()).  Note: flush_dcache_page() deliberately
+	get_user_pages()).  Note: flush_dcache_folio() deliberately
 	doesn't work for an anonymous page.  The default
 	implementation is a nop (and should remain so for all coherent
 	architectures).  For incoherent architectures, it should flush
@@ -374,7 +368,7 @@ maps this page at its virtual address.
   ``void flush_icache_page(struct vm_area_struct *vma, struct page *page)``
 
 	All the functionality of flush_icache_page can be implemented in
-	flush_dcache_page and update_mmu_cache_range. In the future, the hope
+	flush_dcache_folio and update_mmu_cache_range. In the future, the hope
 	is to remove this interface completely.
 
 The final category of APIs is for I/O to deliberately aliased address
--- a/include/linux/cacheflush.h~mm-remove-arch_implements_flush_dcache_folio
+++ a/include/linux/cacheflush.h
@@ -7,14 +7,14 @@
 struct folio;
 
 #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
-#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_FOLIO
+#ifndef flush_dcache_folio
 void flush_dcache_folio(struct folio *folio);
 #endif
 #else
 static inline void flush_dcache_folio(struct folio *folio)
 {
 }
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_FOLIO 0
+#define flush_dcache_folio flush_dcache_folio
 #endif /* ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE */
 
 #endif /* _LINUX_CACHEFLUSH_H */
--- a/mm/util.c~mm-remove-arch_implements_flush_dcache_folio
+++ a/mm/util.c
@@ -1119,7 +1119,7 @@ void page_offline_end(void)
 }
 EXPORT_SYMBOL(page_offline_end);
 
-#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_FOLIO
+#ifndef flush_dcache_folio
 void flush_dcache_folio(struct folio *folio)
 {
 	long i, nr = folio_nr_pages(folio);
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

