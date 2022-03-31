Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6C7C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiCaEgK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiCaEgE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:36:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9FA5B3D7
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E059B81ED5
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457B6C340ED;
        Thu, 31 Mar 2022 04:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701222;
        bh=H3TAWqhYjY5gTECA22rRRUhAzKx6XV/upRx6tX797Qs=;
        h=Date:To:From:Subject:From;
        b=DgT4eTMxnsXx0rrGNUgGtZ0lkoQj043mcfeZFp1OhzFxQER256Ltc/oLfvXZWSay8
         EMVWr9q+/TDDRE03wnAfBj5qm60cxRi+FDdGvsOMXPIkqSJz11neWhFm4FkMX6piJy
         wcU/ra5qPX1ukzLbAL34YIHJlRlbjrRfmuhg22Fs=
Date:   Wed, 30 Mar 2022 21:33:41 -0700
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
Subject: + powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch added to -mm tree
Message-Id: <20220331043342.457B6C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE for book3s
has been added to the -mm tree.  Its filename is
     powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

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
Subject: powerpc/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE for book3s

Right now, the last 5 bits (0x1f) of the swap entry are used for the type
and the bit before that (0x20) is used for _PAGE_SWP_SOFT_DIRTY.  We
cannot use 0x40, as that collides with _RPAGE_RSV1 -- contained in
_PAGE_HPTEFLAGS.  The next candidate would be _RPAGE_SW3 (0x200) -- which
is used for _PAGE_SOFT_DIRTY for !swp ptes.

So let's just use _PAGE_SOFT_DIRTY for _PAGE_SWP_SOFT_DIRTY (to make it
easier to grasp) and use 0x20 now for _PAGE_SWP_EXCLUSIVE.

Link: https://lkml.kernel.org/r/20220329164329.208407-9-david@redhat.com
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

 arch/powerpc/include/asm/book3s/64/pgtable.h |   21 ++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -752,6 +752,7 @@ static inline pte_t pte_modify(pte_t pte
 	 */							\
 	BUILD_BUG_ON(_PAGE_HPTEFLAGS & SWP_TYPE_MASK); \
 	BUILD_BUG_ON(_PAGE_HPTEFLAGS & _PAGE_SWP_SOFT_DIRTY);	\
+	BUILD_BUG_ON(_PAGE_HPTEFLAGS & _PAGE_SWP_EXCLUSIVE);	\
 	} while (0)
 
 #define SWP_TYPE_BITS 5
@@ -772,11 +773,13 @@ static inline pte_t pte_modify(pte_t pte
 #define __swp_entry_to_pmd(x)	(pte_pmd(__swp_entry_to_pte(x)))
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-#define _PAGE_SWP_SOFT_DIRTY	_PAGE_NON_IDEMPOTENT
+#define _PAGE_SWP_SOFT_DIRTY	_PAGE_SOFT_DIRTY
 #else
 #define _PAGE_SWP_SOFT_DIRTY	0UL
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_NON_IDEMPOTENT
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
@@ -794,6 +797,22 @@ static inline pte_t pte_swp_clear_soft_d
 }
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
+}
+
 static inline bool check_pte_access(unsigned long access, unsigned long ptev)
 {
 	/*
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

