Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E821BE223
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941187; cv=none; b=lgCMOJYsE5HS/qcnYoGSsNu739N51B/Gb3A0gFtDBVDUk3F01Uf66TWpgK3ro9LE7Y624bwSoJNIH6MLFbushGGO/Z5utZ9Le72LqIuHozuinF376CMSYy1E8Av4AeisoBi23n8G8CboObVv4U6Lyt2vRXdDPfUAVBydHXZj6y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941187; c=relaxed/simple;
	bh=JsEdtGrGXOj4KSRAfEFdxEFAy16FRQ9PxC6ck+zKius=;
	h=Date:To:From:Subject:Message-Id; b=SrujSr0VkiSm2mFjcMTaFI+9jY1GrkXj+MQv9Qp+S4yZ1KTRRoo/VYF4OZ+CDCCX0SgzgK1fXjpRSWVS7gf9w3o8r3hiL55EgndcejZjBMCG5wt4/OtcjggJkb5bEn1DPhvvWubFWgUYpRXsZbb2nV8a0gZnC/xcXoY7jXDT0Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cwj86iCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cwj86iCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C59C4AF0C;
	Tue,  2 Jul 2024 17:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941187;
	bh=JsEdtGrGXOj4KSRAfEFdxEFAy16FRQ9PxC6ck+zKius=;
	h=Date:To:From:Subject:From;
	b=cwj86iCgf6klMQtStZlnHc286WG24R4+CuNiEue1wzmi33ARqQe/3bK/AzSp9BUa8
	 xat0gmXuukSdB0wBaIgzgNkarYPp4DlD08qf2ljI6We60cPrfRcW28J3rSlYZAYz1k
	 ggmnW5G16uBa/DrFxfq8auvhI1oPkf1XNlp/j7Qo=
Date: Tue, 02 Jul 2024 10:26:26 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-remove-_page_psize.patch added to mm-unstable branch
Message-Id: <20240702172627.32C59C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: remove _PAGE_PSIZE
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-remove-_page_psize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-remove-_page_psize.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/mm: remove _PAGE_PSIZE
Date: Tue, 2 Jul 2024 15:51:21 +0200

_PAGE_PSIZE macro is never used outside the place it is defined and is
used only on 8xx and e500.

Remove indirection, remove it and use its content directly.

Link: https://lkml.kernel.org/r/c41da3b0ceda7311a50f0391cc4d54302ae15b74.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/nohash/32/pte-44x.h  |    3 ---
 arch/powerpc/include/asm/nohash/32/pte-85xx.h |    3 ---
 arch/powerpc/include/asm/nohash/32/pte-8xx.h  |    5 ++---
 arch/powerpc/include/asm/nohash/pte-e500.h    |    4 +---
 4 files changed, 3 insertions(+), 12 deletions(-)

--- a/arch/powerpc/include/asm/nohash/32/pte-44x.h~powerpc-mm-remove-_page_psize
+++ a/arch/powerpc/include/asm/nohash/32/pte-44x.h
@@ -75,9 +75,6 @@
 #define _PAGE_NO_CACHE	0x00000400		/* H: I bit */
 #define _PAGE_WRITETHRU	0x00000800		/* H: W bit */
 
-/* No page size encoding in the linux PTE */
-#define _PAGE_PSIZE		0
-
 /* TODO: Add large page lowmem mapping support */
 #define _PMD_PRESENT	0
 #define _PMD_PRESENT_MASK (PAGE_MASK)
--- a/arch/powerpc/include/asm/nohash/32/pte-85xx.h~powerpc-mm-remove-_page_psize
+++ a/arch/powerpc/include/asm/nohash/32/pte-85xx.h
@@ -31,9 +31,6 @@
 #define _PAGE_WRITETHRU	0x00400	/* H: W bit */
 #define _PAGE_SPECIAL	0x00800 /* S: Special page */
 
-/* No page size encoding in the linux PTE */
-#define _PAGE_PSIZE		0
-
 #define _PMD_PRESENT	0
 #define _PMD_PRESENT_MASK (PAGE_MASK)
 #define _PMD_BAD	(~PAGE_MASK)
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h~powerpc-mm-remove-_page_psize
+++ a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -74,12 +74,11 @@
 #define _PTE_NONE_MASK	0
 
 #ifdef CONFIG_PPC_16K_PAGES
-#define _PAGE_PSIZE	_PAGE_SPS
+#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_SPS)
 #else
-#define _PAGE_PSIZE		0
+#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED)
 #endif
 
-#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_PSIZE)
 #define _PAGE_BASE	(_PAGE_BASE_NC)
 
 #include <asm/pgtable-masks.h>
--- a/arch/powerpc/include/asm/nohash/pte-e500.h~powerpc-mm-remove-_page_psize
+++ a/arch/powerpc/include/asm/nohash/pte-e500.h
@@ -65,8 +65,6 @@
 
 #define _PAGE_SPECIAL	_PAGE_SW0
 
-/* Base page size */
-#define _PAGE_PSIZE	_PAGE_PSIZE_4K
 #define	PTE_RPN_SHIFT	(24)
 
 #define PTE_WIMGE_SHIFT (19)
@@ -89,7 +87,7 @@
  * pages. We always set _PAGE_COHERENT when SMP is enabled or
  * the processor might need it for DMA coherency.
  */
-#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_PSIZE)
+#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_PSIZE_4K)
 #if defined(CONFIG_SMP)
 #define _PAGE_BASE	(_PAGE_BASE_NC | _PAGE_COHERENT)
 #else
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch
mm-provide-mm_struct-and-address-to-huge_ptep_get.patch
powerpc-mm-remove-_page_psize.patch
powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch
powerpc-mm-allow-hugepages-without-hugepd.patch
powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch
powerpc-8xx-rework-support-for-8m-pages-using-contiguous-pte-entries.patch
powerpc-8xx-simplify-struct-mmu_psize_def.patch
powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch
powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits.patch
powerpc-e500-encode-hugepage-size-in-pte-bits.patch
powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch
powerpc-e500-free-r10-for-find_pte.patch
powerpc-e500-use-contiguous-pmd-instead-of-hugepd.patch
powerpc-64s-use-contiguous-pmd-pud-instead-of-hugepd.patch
powerpc-mm-remove-hugepd-leftovers.patch
mm-remove-config_arch_has_hugepd.patch

