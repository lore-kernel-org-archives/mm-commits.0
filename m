Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5496DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiCaEgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiCaEfZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:35:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F78D5AEE2
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC10AB81ED5
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A619AC340ED;
        Thu, 31 Mar 2022 04:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701215;
        bh=f03q6I8BjMuJoJG7dz6tmzb1ED/6ofMVlG9X7vtAMwU=;
        h=Date:To:From:Subject:From;
        b=RlqmYcUkp7F+pAV7sOrpi9Ke72dK2Gf/sk0MT5OGprHZKoXE6A0S1sF8lc8u2wmo8
         9Z1FjQIR/tfM1T2htEx+A9TVOyFv5AhXHOGDL5qHjA2u6Q5eZ8VoOj2HoPnXSrv9nC
         koJ11duz+eMN7Uabfo1xIPxqHxgel7BS6MMSQvBA=
Date:   Wed, 30 Mar 2022 21:33:35 -0700
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
Subject: + s390-pgtable-cleanup-description-of-swp-pte-layout.patch added to -mm tree
Message-Id: <20220331043335.A619AC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390/pgtable: cleanup description of swp pte layout
has been added to the -mm tree.  Its filename is
     s390-pgtable-cleanup-description-of-swp-pte-layout.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/s390-pgtable-cleanup-description-of-swp-pte-layout.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/s390-pgtable-cleanup-description-of-swp-pte-layout.patch

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
Subject: s390/pgtable: cleanup description of swp pte layout

Bit 52 and bit 55 don't have to be zero: they only trigger a
translation-specifiation exception if the PTE is marked as valid, which is
not the case for swap ptes.

Document which bits are used for what, and which ones are unused.

Link: https://lkml.kernel.org/r/20220329164329.208407-6-david@redhat.com
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

 arch/s390/include/asm/pgtable.h |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~s390-pgtable-cleanup-description-of-swp-pte-layout
+++ a/arch/s390/include/asm/pgtable.h
@@ -1712,18 +1712,17 @@ static inline int has_transparent_hugepa
 /*
  * 64 bit swap entry format:
  * A page-table entry has some bits we have to treat in a special way.
- * Bits 52 and bit 55 have to be zero, otherwise a specification
- * exception will occur instead of a page translation exception. The
- * specification exception has the bad habit not to store necessary
- * information in the lowcore.
- * Bits 54 and 63 are used to indicate the page type.
+ * Bits 54 and 63 are used to indicate the page type. Bit 53 marks the pte
+ * as invalid.
  * A swap pte is indicated by bit pattern (pte & 0x201) == 0x200
- * This leaves the bits 0-51 and bits 56-62 to store type and offset.
- * We use the 5 bits from 57-61 for the type and the 52 bits from 0-51
- * for the offset.
- * |			  offset			|01100|type |00|
+ * |			  offset			|X11XX|type |S0|
  * |0000000000111111111122222222223333333333444444444455|55555|55566|66|
  * |0123456789012345678901234567890123456789012345678901|23456|78901|23|
+ *
+ * Bits 0-51 store the offset.
+ * Bits 57-61 store the type.
+ * Bit 62 (S) is used for softdirty tracking.
+ * Bits 52, 55 and 56 (X) are unused.
  */
 
 #define __SWP_OFFSET_MASK	((1UL << 52) - 1)
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

