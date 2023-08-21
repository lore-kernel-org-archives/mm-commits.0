Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F640EE4993
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 18:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjHUS45 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 14:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjHUS44 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 14:56:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C924EF4
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 11:56:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45250642A0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 18:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923CCC433C7;
        Mon, 21 Aug 2023 18:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692644099;
        bh=LmHWXtHva042Q6Y6WLWzwZUXN/bBqptl6kqZtHOUQBw=;
        h=Date:To:From:Subject:From;
        b=MCp0OB/wq0+JCZc7gMVjziY5vdw2CwI2YI4W75EYEwIhozRXRcVfFV4naG6Io2wxK
         N4ZAuqDio9irqq7sYOm5rVpdwdEfOlBRAb+dpAoJ8b+/oJPBC6oRulU6Xgx18/rmUb
         zDk+MsZDOuG3OQq6ClnEQ55exf/jV8bfsNLsgfeM=
Date:   Mon, 21 Aug 2023 11:54:58 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, rdunlap@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-orphaned-kernel-doc-to-the-rst-files.patch added to mm-unstable branch
Message-Id: <20230821185459.923CCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add orphaned kernel-doc to the rst files.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-orphaned-kernel-doc-to-the-rst-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-orphaned-kernel-doc-to-the-rst-files.patch

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
Subject: mm: add orphaned kernel-doc to the rst files.
Date: Fri, 18 Aug 2023 21:06:30 +0100

There are many files in mm/ that contain kernel-doc which is not
currently published on kernel.org.  Some of it is easily categorisable,
but most of it is going into the miscellaneous documentation section to
be organised later.

Some files aren't ready to be included; they contain documentation with
build errors.  Or they're nommu.c which duplicates documentation from
"real" MMU systems.  Those files are noted with a # mark (although really
anything which isn't a recognised directive would do to prevent inclusion)

Link: https://lkml.kernel.org/r/20230818200630.2719595-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |   25 +++++++++++++++++++++++++
 Documentation/mm/highmem.rst      |    1 +
 Documentation/mm/zsmalloc.rst     |    5 +++++
 3 files changed, 31 insertions(+)

--- a/Documentation/core-api/mm-api.rst~mm-add-orphaned-kernel-doc-to-the-rst-files
+++ a/Documentation/core-api/mm-api.rst
@@ -115,3 +115,28 @@ More Memory Management Functions
 .. kernel-doc:: include/linux/mmzone.h
 .. kernel-doc:: mm/util.c
    :functions: folio_mapping
+
+.. kernel-doc:: mm/rmap.c
+.. kernel-doc:: mm/migrate.c
+.. kernel-doc:: mm/mmap.c
+.. kernel-doc:: mm/kmemleak.c
+.. #kernel-doc:: mm/hmm.c (build warnings)
+.. kernel-doc:: mm/memremap.c
+.. kernel-doc:: mm/hugetlb.c
+.. kernel-doc:: mm/swap.c
+.. kernel-doc:: mm/zpool.c
+.. kernel-doc:: mm/memcontrol.c
+.. #kernel-doc:: mm/memory-tiers.c (build warnings)
+.. kernel-doc:: mm/shmem.c
+.. kernel-doc:: mm/migrate_device.c
+.. #kernel-doc:: mm/nommu.c (duplicates kernel-doc from other files)
+.. kernel-doc:: mm/mapping_dirty_helpers.c
+.. #kernel-doc:: mm/memory-failure.c (build warnings)
+.. kernel-doc:: mm/percpu.c
+.. kernel-doc:: mm/maccess.c
+.. kernel-doc:: mm/vmscan.c
+.. kernel-doc:: mm/memory_hotplug.c
+.. kernel-doc:: mm/mmu_notifier.c
+.. kernel-doc:: mm/balloon_compaction.c
+.. kernel-doc:: mm/huge_memory.c
+.. kernel-doc:: mm/io-mapping.c
--- a/Documentation/mm/highmem.rst~mm-add-orphaned-kernel-doc-to-the-rst-files
+++ a/Documentation/mm/highmem.rst
@@ -206,4 +206,5 @@ Functions
 =========
 
 .. kernel-doc:: include/linux/highmem.h
+.. kernel-doc:: mm/highmem.c
 .. kernel-doc:: include/linux/highmem-internal.h
--- a/Documentation/mm/zsmalloc.rst~mm-add-orphaned-kernel-doc-to-the-rst-files
+++ a/Documentation/mm/zsmalloc.rst
@@ -263,3 +263,8 @@ is heavy internal fragmentation and zspo
 objects and release zspages. In these cases, it is recommended to decrease
 the limit on the size of the zspage chains (as specified by the
 CONFIG_ZSMALLOC_CHAIN_SIZE option).
+
+Functions
+=========
+
+.. kernel-doc:: mm/zsmalloc.c
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
mm-remove-checks-for-pte_index.patch
mm-move-pmd_order-to-pgtableh.patch
mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch
mm-remove-enum-page_entry_size.patch
mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch

