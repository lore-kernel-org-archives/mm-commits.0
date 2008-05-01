From: akpm@linux-foundation.org
Subject: - x86-ioremap-add-checks-for-virtual-addresses.patch removed from -mm tree
Date: Thu, 01 May 2008 13:48:07 -0700
Message-ID: <200805012048.m41Km7CA024564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbYEAUtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 16:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, andi@firstfloor.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 ioremap(): add checks for virtual addresses
has been removed from the -mm tree.  Its filename was
     x86-ioremap-add-checks-for-virtual-addresses.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 ioremap(): add checks for virtual addresses
From: Christoph Lameter <clameter@sgi.com>

Add checks to ensure that virtual addresses are not used in invalid contexts.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c     |    1 +
 include/asm-x86/page_32.h |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/ioremap.c~x86-ioremap-add-checks-for-virtual-addresses arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-ioremap-add-checks-for-virtual-addresses
+++ a/arch/x86/mm/ioremap.c
@@ -25,6 +25,7 @@
 
 unsigned long __phys_addr(unsigned long x)
 {
+	VM_BUG_ON(is_vmalloc_addr((void *)x));
 	if (x >= __START_KERNEL_map)
 		return x - __START_KERNEL_map + phys_base;
 	return x - PAGE_OFFSET;
diff -puN include/asm-x86/page_32.h~x86-ioremap-add-checks-for-virtual-addresses include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h~x86-ioremap-add-checks-for-virtual-addresses
+++ a/include/asm-x86/page_32.h
@@ -64,7 +64,12 @@ typedef struct page *pgtable_t;
 #endif
 
 #ifndef __ASSEMBLY__
-#define __phys_addr(x)		((x) - PAGE_OFFSET)
+static inline unsigned long __phys_addr(unsigned long x)
+{
+	VM_BUG_ON(is_vmalloc_addr((void *)x));
+	return x - PAGE_OFFSET;
+}
+
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
 #ifdef CONFIG_FLATMEM
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
remove-div_long_long_rem.patch
git-unionfs.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

