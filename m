From: akpm@linux-foundation.org
Subject: + x86-mm-sparse-warning-fix-for-early_memremap.patch added to -mm tree
Date: Thu, 13 Mar 2014 13:51:56 -0700
Message-ID: <53221a6c.UIoE8Gb3o+yBwG/x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaCMUv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 16:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, tglx@linutronix.de, msalter@redhat.com, mingo@elte.hu, hpa@zytor.com, catalin.marinas@arm.com, borislav.petkov@amd.com, dyoung@redhat.com

Subject: + x86-mm-sparse-warning-fix-for-early_memremap.patch added to -mm tree
To: dyoung@redhat.com,borislav.petkov@amd.com,catalin.marinas@arm.com,hpa@zytor.com,mingo@elte.hu,msalter@redhat.com,tglx@linutronix.de,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 13:51:56 -0700


The patch titled
     Subject: x86/mm: sparse warning fix for early_memremap
has been added to the -mm tree.  Its filename is
     x86-mm-sparse-warning-fix-for-early_memremap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-sparse-warning-fix-for-early_memremap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-sparse-warning-fix-for-early_memremap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: x86/mm: sparse warning fix for early_memremap

This patch series takes the common bits from the x86 early ioremap
implementation and creates a generic implementation which may be used by
other architectures.  The early ioremap interfaces are intended for
situations where boot code needs to make temporary virtual mappings before
the normal ioremap interfaces are available.  Typically, this means before
paging_init() has run.



This patch (of 6):

There's a lot of sparse warnings for code like below: void *a =
early_memremap(phys_addr, size);

early_memremap intend to map kernel memory with ioremap facility, the
return pointer should be a kernel ram pointer instead of iomem one.

For making the function clearer and supressing sparse warnings this patch
do below two things:
1. cast to (__force void *) for the return value of early_memremap
2. add early_memunmap function and pass (__force void __iomem *) to iounmap

From Boris:
: Ingo told me yesterday, it makes sense too. I'd guess we can try it.
: FWIW, all callers of early_memremap use the memory they get remapped as
: normal memory so we should be safe.

Signed-off-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/io.h |    3 ++-
 arch/x86/mm/ioremap.c     |   10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/io.h~x86-mm-sparse-warning-fix-for-early_memremap arch/x86/include/asm/io.h
--- a/arch/x86/include/asm/io.h~x86-mm-sparse-warning-fix-for-early_memremap
+++ a/arch/x86/include/asm/io.h
@@ -325,9 +325,10 @@ extern void early_ioremap_init(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(resource_size_t phys_addr,
 				   unsigned long size);
-extern void __iomem *early_memremap(resource_size_t phys_addr,
+extern void *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void early_memunmap(void *addr, unsigned long size);
 extern void fixup_early_ioremap(void);
 extern bool is_early_ioremap_ptep(pte_t *ptep);
 
diff -puN arch/x86/mm/ioremap.c~x86-mm-sparse-warning-fix-for-early_memremap arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-mm-sparse-warning-fix-for-early_memremap
+++ a/arch/x86/mm/ioremap.c
@@ -562,10 +562,9 @@ early_ioremap(resource_size_t phys_addr,
 }
 
 /* Remap memory */
-void __init __iomem *
-early_memremap(resource_size_t phys_addr, unsigned long size)
+void __init *early_memremap(resource_size_t phys_addr, unsigned long size)
 {
-	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
+	return (__force void *)__early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
 void __init early_iounmap(void __iomem *addr, unsigned long size)
@@ -620,3 +619,8 @@ void __init early_iounmap(void __iomem *
 	}
 	prev_map[slot] = NULL;
 }
+
+void __init early_memunmap(void *addr, unsigned long size)
+{
+	early_iounmap((__force void __iomem *)addr, size);
+}
_

Patches currently in -mm which might be from dyoung@redhat.com are

x86-mm-sparse-warning-fix-for-early_memremap.patch
mm-create-generic-early_ioremap-support.patch
x86-use-generic-early_ioremap.patch
arm64-initialize-pgprot-info-earlier-in-boot.patch
arm64-add-early_ioremap-support.patch
doc-kernel-parameterstxt-add-early_ioremap_debug.patch
linux-next.patch

