Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A457EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 18:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjHUS5L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 14:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjHUS5L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 14:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBA23C9D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 11:56:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E47F64284
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 18:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CF6C433C9;
        Mon, 21 Aug 2023 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692644091;
        bh=g75tRC8YOqLB99sJUG7WZu81f3pCm44L1+INo74gGek=;
        h=Date:To:From:Subject:From;
        b=dddnF1ySnOhQxB28Z2gxhRPoAR1+xTl0ISV8aReo3ZmVBCYDEuTI04FQ2Z3qcf9/w
         gqFi34xsegZ+kCkmH7LXOF8XYgL+X370fN2XGW+8Kt1JBzPOp5z4facmppK/CnuZGK
         Xf0vWBkDsROfDZE7YywgKe3R7NEDXljUpNmAZclA=
Date:   Mon, 21 Aug 2023 11:54:50 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, rdunlap@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-get_mctgt_type-kernel-doc.patch added to mm-unstable branch
Message-Id: <20230821185451.75CF6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix get_mctgt_type() kernel-doc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-get_mctgt_type-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-get_mctgt_type-kernel-doc.patch

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
Subject: mm: fix get_mctgt_type() kernel-doc
Date: Fri, 18 Aug 2023 21:06:28 +0100

Convert the return values to an ReST list and tidy up the wording while
I'm touching it.

Link: https://lkml.kernel.org/r/20230818200630.2719595-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

--- a/mm/memcontrol.c~mm-fix-get_mctgt_type-kernel-doc
+++ a/mm/memcontrol.c
@@ -5850,25 +5850,20 @@ out:
  * @ptent: the pte to be checked
  * @target: the pointer the target page or swap ent will be stored(can be NULL)
  *
- * Returns
- *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
- *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
- *     move charge. if @target is not NULL, the page is stored in target->page
- *     with extra refcnt got(Callers should handle it).
- *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
- *     target for charge migration. if @target is not NULL, the entry is stored
- *     in target->ent.
- *   3(MC_TARGET_DEVICE): like MC_TARGET_PAGE  but page is device memory and
- *   thus not on the lru.
- *     For now we such page is charge like a regular page would be as for all
- *     intent and purposes it is just special memory taking the place of a
- *     regular page.
- *
- *     See Documentations/vm/hmm.txt and include/linux/hmm.h
- *
- * Called with pte lock held.
+ * Context: Called with pte lock held.
+ * Return:
+ * * MC_TARGET_NONE - If the pte is not a target for move charge.
+ * * MC_TARGET_PAGE - If the page corresponding to this pte is a target for
+ *   move charge. If @target is not NULL, the page is stored in target->page
+ *   with extra refcnt got (Callers should handle it).
+ * * MC_TARGET_SWAP - If the swap entry corresponding to this pte is a
+ *   target for charge migration. if @target is not NULL, the entry is stored
+ *   in target->ent.
+ * * MC_TARGET_DEVICE - Like MC_TARGET_PAGE but page is device memory and
+ *   thus not on the lru.  For now such page is charged like a regular page
+ *   would be as it is just special memory taking the place of a regular page.
+ *   See Documentations/vm/hmm.txt and include/linux/hmm.h
  */
-
 static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 		unsigned long addr, pte_t ptent, union mc_target *target)
 {
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

