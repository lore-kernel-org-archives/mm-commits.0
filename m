Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90083C7113B
	for <mm-commits@archiver.kernel.org>; Wed, 23 Aug 2023 21:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbjHWV2s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Aug 2023 17:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbjHWV23 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2023 17:28:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC039CEE
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 14:28:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AF0F63D45
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 21:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9715CC433C7;
        Wed, 23 Aug 2023 21:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692826106;
        bh=a7uviWs71gKnFEcK/OyQeEZm4uM3ewjlkHYUDpwwlXA=;
        h=Date:To:From:Subject:From;
        b=C5J2lvDRpgyuWe8Wujn5MjHnK+ICG9mtyE4kTFmVzEp7YdIFLjJdCrUCZR178WnE2
         pWRvzJXWPW+poxzJJQefGXxGIWUPCmE0BnNznp/knhidm9KRgoa7cx3CyO7X2SPcEg
         Xvn76avxXgGBynMnUllqFYYy5gnGjtB3N/n5UYlA=
Date:   Wed, 23 Aug 2023 14:28:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-enum-page_entry_size-fix.patch added to mm-unstable branch
Message-Id: <20230823212826.9715CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-enum-page_entry_size-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-enum-page_entry_size-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-enum-page_entry_size-fix.patch

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
Subject: mm-remove-enum-page_entry_size-fix
Date: Tue, 22 Aug 2023 21:20:10 +0100

Use "order %u" to match the (non dev_t) style of the rest of the xfs
tracepoints.

Link: https://lkml.kernel.org/r/ZOUYekbtTv+n8hYf@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_trace.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/fs/xfs/xfs_trace.h~mm-remove-enum-page_entry_size-fix
+++ a/fs/xfs/xfs_trace.h
@@ -802,9 +802,6 @@ DEFINE_INODE_EVENT(xfs_inode_inactivatin
  * ring buffer.  Somehow this was only worth mentioning in the ftrace sample
  * code.
  */
-TRACE_DEFINE_ENUM(PMD_ORDER);
-TRACE_DEFINE_ENUM(PUD_ORDER);
-
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
 
@@ -823,13 +820,10 @@ TRACE_EVENT(xfs_filemap_fault,
 		__entry->order = order;
 		__entry->write_fault = write_fault;
 	),
-	TP_printk("dev %d:%d ino 0x%llx %s write_fault %d",
+	TP_printk("dev %d:%d ino 0x%llx order %u write_fault %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __print_symbolic(__entry->order,
-			{ 0,		"PTE" },
-			{ PMD_ORDER,	"PMD" },
-			{ PUD_ORDER,	"PUD" }),
+		  __entry->order,
 		  __entry->write_fault)
 )
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api-fix-2.patch
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
mm-swap-use-dedicated-entry-for-swap-in-folio.patch
mm-remove-checks-for-pte_index.patch
mm-move-pmd_order-to-pgtableh.patch
mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch
mm-remove-enum-page_entry_size.patch
mm-remove-enum-page_entry_size-fix.patch
mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-get_mctgt_type-kernel-doc-fix-2.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch
hugetlb-add-documentation-for-vma_kernel_pagesize.patch
secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch

