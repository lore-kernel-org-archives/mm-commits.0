Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A88AC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4559613DF
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhEMArE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232486AbhEMAn6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:43:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07D5861405;
        Thu, 13 May 2021 00:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620866567;
        bh=MMt0bFD6WEwGJJ+7uMpZ1WVvIxsgIc3RPJK7yZU0Eok=;
        h=Date:From:To:Subject:From;
        b=jM8fdtzptmiIFBzaTCNmmvHkT+WwsIPia2fRa/w2IgVLRJ3FFmrkNLELcxiraDtde
         udDa/FiJxfmvOOqiXDtDaaQT9ImX5UJOo6Bi3RdJ2ezw2TIOYKISyivqzPmD/LjX2N
         lhnZ8FmCiBiK+pB2/UDC5NtwEY517c1doJH5pOBI=
Date:   Wed, 12 May 2021 17:42:46 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org,
        rppt@kernel.org, uladzislau.rezki@sony.com
Subject:  +
 powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch added to
 -mm tree
Message-ID: <20210513004246.Z8CkH_jLh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/8xx: add support for huge pages on VMAP and VMALLOC
has been added to the -mm tree.  Its filename is
     powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/8xx: add support for huge pages on VMAP and VMALLOC

powerpc 8xx has 4 page sizes:
- 4k
- 16k
- 512k
- 8M

At the time being, vmalloc and vmap only support huge pages which are leaf
at PMD level.

Here the PMD level is 4M, it doesn't correspond to any supported page
size.

For now, implement use of 16k and 512k pages which is done at PTE level.

Support of 8M pages will be implemented later, it requires vmalloc to
support hugepd tables.

Link: https://lkml.kernel.org/r/8b972f1c03fb6bd59953035f0a3e4d26659de4f8.1620795204.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                         |    2 
 arch/powerpc/include/asm/nohash/32/mmu-8xx.h |   43 +++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h~powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc
+++ a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
@@ -178,6 +178,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/mmdebug.h>
+#include <linux/sizes.h>
 
 void mmu_pin_tlb(unsigned long top, bool readonly);
 
@@ -225,6 +226,48 @@ static inline unsigned int mmu_psize_to_
 	BUG();
 }
 
+static inline bool arch_vmap_try_size(unsigned long addr, unsigned long end, u64 pfn,
+				      unsigned int max_page_shift, unsigned long size)
+{
+	if (end - addr < size)
+		return false;
+
+	if ((1UL << max_page_shift) < size)
+		return false;
+
+	if (!IS_ALIGNED(addr, size))
+		return false;
+
+	if (!IS_ALIGNED(PFN_PHYS(pfn), size))
+		return false;
+
+	return true;
+}
+
+static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr, unsigned long end,
+							 u64 pfn, unsigned int max_page_shift)
+{
+	if (arch_vmap_try_size(addr, end, pfn, max_page_shift, SZ_512K))
+		return SZ_512K;
+	if (PAGE_SIZE == SZ_16K)
+		return SZ_16K;
+	if (arch_vmap_try_size(addr, end, pfn, max_page_shift, SZ_16K))
+		return SZ_16K;
+	return PAGE_SIZE;
+}
+#define arch_vmap_pte_range_map_size arch_vmap_pte_range_map_size
+
+static inline int arch_vmap_pte_supported_shift(unsigned long size)
+{
+	if (size >= SZ_512K)
+		return 19;
+	else if (size >= SZ_16K)
+		return 14;
+	else
+		return PAGE_SHIFT;
+}
+#define arch_vmap_pte_supported_shift arch_vmap_pte_supported_shift
+
 /* patch sites */
 extern s32 patch__itlbmiss_exit_1, patch__dtlbmiss_exit_1;
 extern s32 patch__itlbmiss_perf, patch__dtlbmiss_perf;
--- a/arch/powerpc/Kconfig~powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc
+++ a/arch/powerpc/Kconfig
@@ -187,7 +187,7 @@ config PPC
 	select GENERIC_VDSO_TIME_NS
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HUGE_VMALLOC		if HAVE_ARCH_HUGE_VMAP
-	select HAVE_ARCH_HUGE_VMAP		if PPC_BOOK3S_64 && PPC_RADIX_MMU
+	select HAVE_ARCH_HUGE_VMAP		if PPC_RADIX_MMU || PPC_8xx
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN			if PPC32 && PPC_PAGE_SHIFT <= 14
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch

