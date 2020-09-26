Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E458C4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E847620BED
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087847;
	bh=g+7i4ms73i13+2FJYlngyQNDeof/mALcTVY3kUpW56s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qXaLEFH39p4uROIkrz2hdr8NNpww955rbWzW3yU43iHUv4SZsTBMm5/gy58qmo2pB
	 IG/maN+sQrH0C0tDMWhvpykQ4+1J9d1hI6A3Pu0Q3bX2u5OZrWOkUADkyk06ay1Kpb
	 vbYE4CRNfL+eQQFHD19SC6pCD0g73hD/yM46cMvY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgIZCh1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgIZCh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:37:27 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2222E2087D;
        Sat, 26 Sep 2020 02:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087846;
        bh=g+7i4ms73i13+2FJYlngyQNDeof/mALcTVY3kUpW56s=;
        h=Date:From:To:Subject:From;
        b=qEjBAJC8Lhps+e+9qOyNCOwrxmF0+HgzymhiU0AqJBUuAa7hCQy7jiSre7YHKCS1N
         GKY1r7EpEmMF38Bb9wOMEMSL2squL9ayh14WpMEoWfxbNwzy3jylJzoVNusKOosPN2
         fPccnYy55eXvPoKtQCxZsXN6sU01mxIGdm9Tml0Y=
Date:   Fri, 25 Sep 2020 19:37:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        viro@zeniv.linux.org.uk, tycho@tycho.ws, tglx@linutronix.de,
        shuah@kernel.org, peterz@infradead.org, paul.walmsley@sifive.com,
        palmerdabbelt@google.com, palmer@dabbelt.com,
        mtk.manpages@gmail.com, mingo@redhat.com, mark.rutland@arm.com,
        luto@kernel.org, kirill@shutemov.name, jejb@linux.ibm.com,
        idan.yaniv@ibm.com, hpa@zytor.com, elena.reshetova@intel.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, cl@linux.com, catalin.marinas@arm.com,
        bp@alien8.de, arnd@arndb.de, rppt@linux.ibm.com
Subject:  [to-be-updated] mmap-make-mlock_future_check-global.patch
 removed from -mm tree
Message-ID: <20200926023724.NSuUu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: make mlock_future_check() global
has been removed from the -mm tree.  Its filename was
     mmap-make-mlock_future_check-global.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mmap: make mlock_future_check() global

It will be used by the upcoming secret memory implementation.

Link: https://lkml.kernel.org/r/20200924132904.1391-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Idan Yaniv <idan.yaniv@ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 mm/mmap.c     |    5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mmap-make-mlock_future_check-global
+++ a/mm/internal.h
@@ -348,6 +348,9 @@ static inline void munlock_vma_pages_all
 extern void mlock_vma_page(struct page *page);
 extern unsigned int munlock_vma_page(struct page *page);
 
+extern int mlock_future_check(struct mm_struct *mm, unsigned long flags,
+			      unsigned long len);
+
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
  * we want to unconditionally remove a page from the pagecache -- e.g.,
--- a/mm/mmap.c~mmap-make-mlock_future_check-global
+++ a/mm/mmap.c
@@ -1348,9 +1348,8 @@ static inline unsigned long round_hint_t
 	return hint;
 }
 
-static inline int mlock_future_check(struct mm_struct *mm,
-				     unsigned long flags,
-				     unsigned long len)
+int mlock_future_check(struct mm_struct *mm, unsigned long flags,
+		       unsigned long len)
 {
 	unsigned long locked, lock_limit;
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-account-pmd-tables-like-pte-tables-fix.patch
kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch
dma-contiguous-simplify-cma_early_percent_memory.patch
arm-xtensa-simplify-initialization-of-high-memory-pages.patch
arm64-numa-simplify-dummy_numa_init.patch
h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch
riscv-drop-unneeded-node-initialization.patch
mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch
memblock-make-for_each_memblock_type-iterator-private.patch
memblock-make-memblock_debug-and-related-functionality-private.patch
memblock-reduce-number-of-parameters-in-for_each_mem_range.patch
arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch
mm-remove-unused-early_pfn_valid.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

