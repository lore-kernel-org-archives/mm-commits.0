Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D20DEE49AF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 21:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjHUV3a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjHUV33 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 17:29:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C366F3
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 14:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCAF663072
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 21:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D14CC433C7;
        Mon, 21 Aug 2023 21:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692653367;
        bh=YgC/uO95OGSBT9VTMq4mgqw/om0FQ16UKuI5lzB3uYA=;
        h=Date:To:From:Subject:From;
        b=aUOVYk9FHzfK92v2Eoynla4l5thnT+ethnNvizJ4vD+cj9spKfqJCazbDQf8c5sDn
         oOLITrGAWBA0VkeA+9e2aTuRc+vPZqp3W71Oa3DhKDUfqTjB/5Z0pr9gv/xUc7OH0F
         kPe84FnkFUzGOoU9HAdMWgFx95odIJcVv6hY5p6c=
Date:   Mon, 21 Aug 2023 14:29:26 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] io_uring-stop-calling-free_compound_page.patch removed from -mm tree
Message-Id: <20230821212927.2D14CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: io_uring: stop calling free_compound_page()
has been removed from the -mm tree.  Its filename was
     io_uring-stop-calling-free_compound_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: io_uring: stop calling free_compound_page()
Date: Wed, 16 Aug 2023 16:11:49 +0100

Patch series "Remove _folio_dtor and _folio_order", v2.


This patch (of 13):

folio_put() is the standard way to write this, and it's not appreciably
slower.  This is an enabling patch for removing free_compound_page()
entirely.

Link: https://lkml.kernel.org/r/20230816151201.3655946-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230816151201.3655946-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 io_uring/io_uring.c |    6 +-----
 io_uring/kbuf.c     |    6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/io_uring/io_uring.c~io_uring-stop-calling-free_compound_page
+++ a/io_uring/io_uring.c
@@ -2643,14 +2643,10 @@ static int io_cqring_wait(struct io_ring
 
 static void io_mem_free(void *ptr)
 {
-	struct page *page;
-
 	if (!ptr)
 		return;
 
-	page = virt_to_head_page(ptr);
-	if (put_page_testzero(page))
-		free_compound_page(page);
+	folio_put(virt_to_folio(ptr));
 }
 
 static void io_pages_free(struct page ***pages, int npages)
--- a/io_uring/kbuf.c~io_uring-stop-calling-free_compound_page
+++ a/io_uring/kbuf.c
@@ -218,11 +218,7 @@ static int __io_remove_buffers(struct io
 	if (bl->is_mapped) {
 		i = bl->buf_ring->tail - bl->head;
 		if (bl->is_mmap) {
-			struct page *page;
-
-			page = virt_to_head_page(bl->buf_ring);
-			if (put_page_testzero(page))
-				free_compound_page(page);
+			folio_put(virt_to_folio(bl->buf_ring));
 			bl->buf_ring = NULL;
 			bl->is_mmap = 0;
 		} else if (bl->buf_nr_pages) {
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
mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch

