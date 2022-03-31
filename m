Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD29C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiCaEgP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiCaEfV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:35:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F10B5AEC1
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF83A61480
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354E9C340ED;
        Thu, 31 Mar 2022 04:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701213;
        bh=KDcFpz9Zx4dOubO4KWtChnbcx3F93ZY6oLIDsW9HbS8=;
        h=Date:To:From:Subject:From;
        b=icfGXhsUMYpzmHxXbuqM7wUJKhNRo29rOd71KoyNVDg63URFfUjoCbcav9GUH9SyT
         Qryp9czZyfY4cgRvgPsvwvZ4wE93V4ffBe1r+/NjN+Rfa6/BOD8+Uwyju54Ff/cwOU
         X6LUiNMH3zsJfpPC0YOGzb1aoPEQgaI9Uu/j8wyg=
Date:   Wed, 30 Mar 2022 21:33:32 -0700
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
Subject: + arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch added to -mm tree
Message-Id: <20220331043333.354E9C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been added to the -mm tree.  Its filename is
     arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch

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
Subject: arm64/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE

Let's use one of the type bits: core-mm only supports 5, so there is no
need to consume 6.

Note that we might be able to reuse bit 1, but reusing bit 1 turned out
problematic in the past for PROT_NONE handling; so let's play safe and use
another bit.

Link: https://lkml.kernel.org/r/20220329164329.208407-5-david@redhat.com
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
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

 arch/arm64/include/asm/pgtable-prot.h |    1 +
 arch/arm64/include/asm/pgtable.h      |   23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-pgtable-support-__have_arch_pte_swp_exclusive
+++ a/arch/arm64/include/asm/pgtable.h
@@ -402,6 +402,22 @@ static inline pgprot_t mk_pmd_sect_prot(
 	return __pgprot((pgprot_val(prot) & ~PMD_TABLE_BIT) | PMD_TYPE_SECT);
 }
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return set_pte_bit(pte, __pgprot(PTE_SWP_EXCLUSIVE));
+}
+
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_val(pte) & PTE_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return clear_pte_bit(pte, __pgprot(PTE_SWP_EXCLUSIVE));
+}
+
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * See the comment in include/linux/pgtable.h
@@ -909,12 +925,13 @@ static inline pmd_t pmdp_establish(struc
 /*
  * Encode and decode a swap entry:
  *	bits 0-1:	present (must be zero)
- *	bits 2-7:	swap type
+ *	bits 2:		remember PG_anon_exclusive
+ *	bits 3-7:	swap type
  *	bits 8-57:	swap offset
  *	bit  58:	PTE_PROT_NONE (must be zero)
  */
-#define __SWP_TYPE_SHIFT	2
-#define __SWP_TYPE_BITS		6
+#define __SWP_TYPE_SHIFT	3
+#define __SWP_TYPE_BITS		5
 #define __SWP_OFFSET_BITS	50
 #define __SWP_TYPE_MASK		((1 << __SWP_TYPE_BITS) - 1)
 #define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
--- a/arch/arm64/include/asm/pgtable-prot.h~arm64-pgtable-support-__have_arch_pte_swp_exclusive
+++ a/arch/arm64/include/asm/pgtable-prot.h
@@ -14,6 +14,7 @@
  * Software defined PTE bits definition.
  */
 #define PTE_WRITE		(PTE_DBM)		 /* same as DBM (51) */
+#define PTE_SWP_EXCLUSIVE	(_AT(pteval_t, 1) << 2)	 /* only for swp ptes */
 #define PTE_DIRTY		(_AT(pteval_t, 1) << 55)
 #define PTE_SPECIAL		(_AT(pteval_t, 1) << 56)
 #define PTE_DEVMAP		(_AT(pteval_t, 1) << 57)
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

