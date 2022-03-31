Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EFFC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiCaEgR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiCaEfQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:35:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE245A5B0
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB11B6147B
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42533C340ED;
        Thu, 31 Mar 2022 04:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701208;
        bh=D8j/w3vPK583YsJ2xLOTCbPkaVlcOr9i3QTX1YH14bw=;
        h=Date:To:From:Subject:From;
        b=Wdl+goFJzhC14qHWcEgSdgeiEucoxMfJnDIxW/bRg0ULI7heNLfvHe4VByqNy0V2I
         faX+aN90dv1etSFAqw0dlxFQf2LCoxXr8Wa0n1EtRm/bmpz87pDImGumKEiQpyO0q3
         s5xOjmJBQRKF5MugHbIy9mTkgsDPLLf0NoQnc2Vk=
Date:   Wed, 30 Mar 2022 21:33:27 -0700
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
Subject: + mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch added to -mm tree
Message-Id: <20220331043328.42533C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: add tests for __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch

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
Subject: mm/debug_vm_pgtable: add tests for __HAVE_ARCH_PTE_SWP_EXCLUSIVE

Let's test that __HAVE_ARCH_PTE_SWP_EXCLUSIVE works as expected.

Link: https://lkml.kernel.org/r/20220329164329.208407-3-david@redhat.com
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

 mm/debug_vm_pgtable.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive
+++ a/mm/debug_vm_pgtable.c
@@ -837,6 +837,19 @@ static void __init pmd_soft_dirty_tests(
 static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static void __init pte_swap_exclusive_tests(struct pgtable_debug_args *args)
+{
+#ifdef __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
+
+	pr_debug("Validating PTE swap exclusive\n");
+	pte = pte_swp_mkexclusive(pte);
+	WARN_ON(!pte_swp_exclusive(pte));
+	pte = pte_swp_clear_exclusive(pte);
+	WARN_ON(pte_swp_exclusive(pte));
+#endif /* __HAVE_ARCH_PTE_SWP_EXCLUSIVE */
+}
+
 static void __init pte_swap_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t swp;
@@ -1288,6 +1301,8 @@ static int __init debug_vm_pgtable(void)
 	pte_swap_soft_dirty_tests(&args);
 	pmd_swap_soft_dirty_tests(&args);
 
+	pte_swap_exclusive_tests(&args);
+
 	pte_swap_tests(&args);
 	pmd_swap_tests(&args);
 
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

