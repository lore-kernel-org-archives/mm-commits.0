From: akpm@linux-foundation.org
Subject: [folded-merged]
 arch-kunmap_atomic-consolidate-duplicate-code-fix.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 16:09:29 -0700
Message-ID: <20200604230929.nd_p280I2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXJb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:09:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, chris@zankel.net, davem@davemloft.net, hch@lst.de, ira.weiny@intel.com, jcmvbkbc@gmail.com, linux@roeck-us.net, luto@kernel.org, mm-commits@vger.kernel.org, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: arch/{mips,sparc,microblaze,powerpc}: don't enable pagefault/preempt twice
has been removed from the -mm tree.  Its filename was
     arch-kunmap_atomic-consolidate-duplicate-code-fix.patch

This patch was dropped because it was folded into arch-kunmap_atomic-consolidate-duplicate-code.patch

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: arch/{mips,sparc,microblaze,powerpc}: don't enable pagefault/preempt twice

The kunmap_atomic clean up failed to remove one set of pagefault/preempt
enables when vaddr is not in the fixmap.

Link: http://lkml.kernel.org/r/20200518184843.3029640-1-ira.weiny@intel.com
Fixes: bee2128a09e6 ("arch/kunmap_atomic: consolidate duplicate code")
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/mm/highmem.c |    5 +----
 arch/mips/mm/highmem.c       |    5 +----
 arch/powerpc/mm/highmem.c    |    5 +----
 arch/sparc/mm/highmem.c      |    5 +----
 4 files changed, 4 insertions(+), 16 deletions(-)

--- a/arch/microblaze/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code-fix
+++ a/arch/microblaze/mm/highmem.c
@@ -57,11 +57,8 @@ void kunmap_atomic_high(void *kvaddr)
 	int type;
 	unsigned int idx;
 
-	if (vaddr < __fix_to_virt(FIX_KMAP_END)) {
-		pagefault_enable();
-		preempt_enable();
+	if (vaddr < __fix_to_virt(FIX_KMAP_END))
 		return;
-	}
 
 	type = kmap_atomic_idx();
 
--- a/arch/mips/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code-fix
+++ a/arch/mips/mm/highmem.c
@@ -41,11 +41,8 @@ void kunmap_atomic_high(void *kvaddr)
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	int type __maybe_unused;
 
-	if (vaddr < FIXADDR_START) { // FIXME
-		pagefault_enable();
-		preempt_enable();
+	if (vaddr < FIXADDR_START)
 		return;
-	}
 
 	type = kmap_atomic_idx();
 #ifdef CONFIG_DEBUG_HIGHMEM
--- a/arch/powerpc/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code-fix
+++ a/arch/powerpc/mm/highmem.c
@@ -44,11 +44,8 @@ void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 
-	if (vaddr < __fix_to_virt(FIX_KMAP_END)) {
-		pagefault_enable();
-		preempt_enable();
+	if (vaddr < __fix_to_virt(FIX_KMAP_END))
 		return;
-	}
 
 	if (IS_ENABLED(CONFIG_DEBUG_HIGHMEM)) {
 		int type = kmap_atomic_idx();
--- a/arch/sparc/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code-fix
+++ a/arch/sparc/mm/highmem.c
@@ -89,11 +89,8 @@ void kunmap_atomic_high(void *kvaddr)
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	int type;
 
-	if (vaddr < FIXADDR_START) { // FIXME
-		pagefault_enable();
-		preempt_enable();
+	if (vaddr < FIXADDR_START)
 		return;
-	}
 
 	type = kmap_atomic_idx();
 
_

Patches currently in -mm which might be from ira.weiny@intel.com are

arch-kmap-remove-bug_on.patch
arch-xtensa-move-kmap-build-bug-out-of-the-way.patch
arch-kmap-remove-redundant-arch-specific-kmaps.patch
arch-kunmap-remove-duplicate-kunmap-implementations.patch
x86powerpcmicroblaze-kmap-move-preempt-disable.patch
arch-kmap_atomic-consolidate-duplicate-code.patch
arch-kunmap_atomic-consolidate-duplicate-code.patch
arch-kmap-ensure-kmap_prot-visibility.patch
arch-kmap-dont-hard-code-kmap_prot-values.patch
arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
drm-remove-drm-specific-kmap_atomic-code.patch
kmap-remove-kmap_atomic_to_page.patch
parisc-kmap-remove-duplicate-kmap-code.patch
sparc-remove-unnecessary-includes.patch
kmap-consolidate-kmap_prot-definitions.patch
