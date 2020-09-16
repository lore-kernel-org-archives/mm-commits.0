Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77343C43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 415FD22207
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600298445;
	bh=zePgcVrcRaQS1o0Z4J84+yq51OlKhJfsA2tA2tF3pUg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qK6DHAdfBTDnScZrvYURjaO6him/jkbfFWxGEmHYoBkevMJXbSe4zgrVwlvmDQ3/m
	 4qTtDZwBoOLGflzNIDe2M+SVc5yVJvXJBpXfLlUTxeTYopMWw3Q4rpWRXqU14shjBZ
	 K6QvPHQV+rb+elPckoSu1chrW3jHzPmTldLjhR4k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgIPXUo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXUo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 19:20:44 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC4222205;
        Wed, 16 Sep 2020 23:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600298443;
        bh=zePgcVrcRaQS1o0Z4J84+yq51OlKhJfsA2tA2tF3pUg=;
        h=Date:From:To:Subject:From;
        b=ZG95dB2Kng8JAdlJIAzR06tGCdhkadwxdOr6CCDVUxNkQ4tUGJ4RbhLyb+A84NhWQ
         bYFytRUytQvfSn19iytkyw8nAvK3QupjkK7nKUdRWR41x0e9SIQLNiXu2L91JIkgYO
         OmnXFT1PKk/AWOLP7VfHwhJQeC8A7xbKg/ifnpKM=
Date:   Wed, 16 Sep 2020 16:20:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        viro@zeniv.linux.org.uk, tycho@tycho.ws, tglx@linutronix.de,
        peterz@infradead.org, paul.walmsley@sifive.com,
        palmerdabbelt@google.com, palmer@dabbelt.com,
        mtk.manpages@gmail.com, mingo@redhat.com, mark.rutland@arm.com,
        luto@kernel.org, kirill@shutemov.name, jejb@linux.ibm.com,
        idan.yaniv@ibm.com, hpa@zytor.com, elena.reshetova@intel.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, cl@linux.com, catalin.marinas@arm.com,
        bp@alien8.de, arnd@arndb.de, rppt@linux.ibm.com
Subject:  + mmap-make-mlock_future_check-global.patch added to -mm
 tree
Message-ID: <20200916232041.X0kWL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: make mlock_future_check() global
has been added to the -mm tree.  Its filename is
     mmap-make-mlock_future_check-global.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmap-make-mlock_future_check-global.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmap-make-mlock_future_check-global.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mmap: make mlock_future_check() global

It will be used by the upcoming secret memory implementation.

Link: https://lkml.kernel.org/r/20200916073539.3552-3-rppt@kernel.org
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
@@ -1307,9 +1307,8 @@ static inline unsigned long round_hint_t
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
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch

