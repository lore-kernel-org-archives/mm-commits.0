Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8056BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiCaEgP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiCaEfT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:35:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4002D5AA75
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE025B81ED6
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CCCC340ED;
        Thu, 31 Mar 2022 04:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701210;
        bh=EoTlhDjEalyScY3F4TcRbo+1oXuP/M2G2hboZxyvjN8=;
        h=Date:To:From:Subject:From;
        b=PmzS4TlMLhqenCgWhPUHLhxIak+ytKYIkJRVk0ydFuWQxpFwCwYlX8FOhBsZs1Zj5
         ug0maLWAXiAiV9v51Bzbt+6aG7/DxX/nGyaD5QTWDA7AQWWNVPxKTDG4ZG40BzLa48
         uA52YD6uTHifvZ3W+A+FcO15XwT7cdDsm3vpJCaA=
Date:   Wed, 30 Mar 2022 21:33:29 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, will@kernel.org, vbabka@suse.cz,
        tglx@linutronix.de, shakeelb@google.com, rppt@linux.ibm.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        paulus@samba.org, oleg@redhat.com, oded.gabbay@gmail.com,
        namit@vmware.com, mpe@ellerman.id.au, mingo@redhat.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jgg@nvidia.com, jannh@google.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, hca@linux.ibm.com, guro@fb.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, ddutile@redhat.com,
        dave.hansen@linux.intel.com, catalin.marinas@arm.com, bp@alien8.de,
        benh@kernel.crashing.org, agordeev@linux.ibm.com,
        aarcange@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-pgtable-support-__have_arch_pte_swp_exclusive.patch added to -mm tree
Message-Id: <20220331043330.74CCCC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been added to the -mm tree.  Its filename is
     x86-pgtable-support-__have_arch_pte_swp_exclusive.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-pgtable-support-__have_arch_pte_swp_exclusive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE

Let's use bit 3 to remember PG_anon_exclusive in swap ptes.

Link: https://lkml.kernel.org/r/20220329164329.208407-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h       |   16 ++++++++++++++++
 arch/x86/include/asm/pgtable_64.h    |    4 +++-
 arch/x86/include/asm/pgtable_types.h |    5 +++++
 3 files changed, 24 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable_64.h~x86-pgtable-support-__have_arch_pte_swp_exclusive
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -186,7 +186,7 @@ static inline void native_pgd_clear(pgd_
  *
  * |     ...            | 11| 10|  9|8|7|6|5| 4| 3|2| 1|0| <- bit number
  * |     ...            |SW3|SW2|SW1|G|L|D|A|CD|WT|U| W|P| <- bit names
- * | TYPE (59-63) | ~OFFSET (9-58)  |0|0|X|X| X| X|F|SD|0| <- swp entry
+ * | TYPE (59-63) | ~OFFSET (9-58)  |0|0|X|X| X| E|F|SD|0| <- swp entry
  *
  * G (8) is aliased and used as a PROT_NONE indicator for
  * !present ptes.  We need to start storing swap entries above
@@ -203,6 +203,8 @@ static inline void native_pgd_clear(pgd_
  * F (2) in swp entry is used to record when a pagetable is
  * writeprotected by userfaultfd WP support.
  *
+ * E (3) in swp entry is used to rememeber PG_anon_exclusive.
+ *
  * Bit 7 in swp entry should be 0 because pmd_present checks not only P,
  * but also L and G.
  *
--- a/arch/x86/include/asm/pgtable.h~x86-pgtable-support-__have_arch_pte_swp_exclusive
+++ a/arch/x86/include/asm/pgtable.h
@@ -1292,6 +1292,22 @@ static inline void update_mmu_cache_pud(
 {
 }
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return pte_set_flags(pte, _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
+}
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
--- a/arch/x86/include/asm/pgtable_types.h~x86-pgtable-support-__have_arch_pte_swp_exclusive
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -84,6 +84,11 @@
 #endif
 
 /*
+ * We borrow bit 3 to remember PG_anon_exclusive.
+ */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_PWT
+
+/*
  * Tracking soft dirty bit when a page goes to a swap is tricky.
  * We need a bit which can be stored in pte _and_ not conflict
  * with swap entry format. On x86 bits 1-4 are *not* involved
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch
mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch
mm-memory-slightly-simplify-copy_present_pte.patch
mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch
mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch
mm-rmap-remove-do_page_add_anon_rmap.patch
mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch
mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch
mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch
mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch
mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch
mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

