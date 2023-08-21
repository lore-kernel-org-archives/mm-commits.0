Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9F7EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 17:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbjHURfT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 13:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236518AbjHURfS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 13:35:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EF0131
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 10:35:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3459640DC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 17:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B19C433C9;
        Mon, 21 Aug 2023 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692639305;
        bh=CWUNZAN9TZO2fgfNCYuqHcfueQKe3Eev4RX/iWIif9U=;
        h=Date:To:From:Subject:From;
        b=Im4wQ+bJvWtvcAf6qa5NcQiCnz+JzmslXDDAhnpRbnj29eo7KmifdLMaDawfzmsjc
         FZ4zJj+uSuck+8czLJUuwOoLOu3eZQfD+g9MKrtL3ESNpsQopRebfedjkOqtxHyQPK
         XAfB3uT3a4Kl7fYQ84MiunZh9o7SSZdMbyxHLHE4=
Date:   Mon, 21 Aug 2023 10:35:04 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com, peterx@redhat.com,
        hughd@google.com, ddstreet@ieee.org, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-dedicated-entry-for-swap-in-folio.patch added to mm-unstable branch
Message-Id: <20230821173505.26B19C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: use dedicated entry for swap in folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-use-dedicated-entry-for-swap-in-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-dedicated-entry-for-swap-in-folio.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm/swap: use dedicated entry for swap in folio
Date: Mon, 21 Aug 2023 18:08:47 +0200

Let's stop working on the private field and use an explicit swap field. 
We have to move the swp_entry_t typedef.

Link: https://lkml.kernel.org/r/20230821160849.531668-3-david@redhat.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   23 +++++++++++++----------
 include/linux/swap.h     |    5 ++---
 2 files changed, 15 insertions(+), 13 deletions(-)

--- a/include/linux/mm_types.h~mm-swap-use-dedicated-entry-for-swap-in-folio
+++ a/include/linux/mm_types.h
@@ -259,6 +259,14 @@ static inline struct page *encoded_page_
  */
 #define  TAIL_MAPPING_REUSED_MAX  (2)
 
+/*
+ * A swap entry has to fit into a "unsigned long", as the entry is hidden
+ * in the "index" field of the swapper address space.
+ */
+typedef struct {
+	unsigned long val;
+} swp_entry_t;
+
 /**
  * struct folio - Represents a contiguous set of bytes.
  * @flags: Identical to the page flags.
@@ -269,7 +277,7 @@ static inline struct page *encoded_page_
  * @index: Offset within the file, in units of pages.  For anonymous memory,
  *    this is the index from the beginning of the mmap.
  * @private: Filesystem per-folio data (see folio_attach_private()).
- *    Used for swp_entry_t if folio_test_swapcache().
+ * @swap: Used for swp_entry_t if folio_test_swapcache().
  * @_mapcount: Do not access this member directly.  Use folio_mapcount() to
  *    find out how many times this folio is mapped by userspace.
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
@@ -312,7 +320,10 @@ struct folio {
 			};
 			struct address_space *mapping;
 			pgoff_t index;
-			void *private;
+			union {
+				void *private;
+				swp_entry_t swap;
+			};
 			atomic_t _mapcount;
 			atomic_t _refcount;
 #ifdef CONFIG_MEMCG
@@ -1220,14 +1231,6 @@ enum tlb_flush_reason {
 	NR_TLB_FLUSH_REASONS,
 };
 
- /*
-  * A swap entry has to fit into a "unsigned long", as the entry is hidden
-  * in the "index" field of the swapper address space.
-  */
-typedef struct {
-	unsigned long val;
-} swp_entry_t;
-
 /**
  * enum fault_flag - Fault flag definitions.
  * @FAULT_FLAG_WRITE: Fault was a write fault.
--- a/include/linux/swap.h~mm-swap-use-dedicated-entry-for-swap-in-folio
+++ a/include/linux/swap.h
@@ -335,8 +335,7 @@ struct swap_info_struct {
 
 static inline swp_entry_t folio_swap_entry(struct folio *folio)
 {
-	swp_entry_t entry = { .val = page_private(&folio->page) };
-	return entry;
+	return folio->swap;
 }
 
 static inline swp_entry_t page_swap_entry(struct page *page)
@@ -350,7 +349,7 @@ static inline swp_entry_t page_swap_entr
 
 static inline void folio_set_swap_entry(struct folio *folio, swp_entry_t entry)
 {
-	folio->private = (void *)entry.val;
+	folio->swap = entry;
 }
 
 /* linux/mm/workingset.c */
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
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
mm-allow-fault_dirty_shared_page-to-be-called-under-the-vma-lock.patch
io_uring-stop-calling-free_compound_page.patch
mm-call-free_huge_page-directly.patch
mm-convert-free_huge_page-to-free_huge_folio.patch
mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch
mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch
mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch
mm-remove-hugetlb_page_dtor.patch
mm-add-large_rmappable-page-flag.patch
mm-rearrange-page-flags.patch
mm-free-up-a-word-in-the-first-tail-page.patch
mm-remove-folio_test_transhuge.patch
mm-add-tail-private-fields-to-struct-folio.patch
mm-convert-split_huge_pages_pid-to-use-a-folio.patch
mm-swap-use-dedicated-entry-for-swap-in-folio.patch

