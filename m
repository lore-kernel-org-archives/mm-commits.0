From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-kunmap_atomic-consolidate-duplicate-code-fix.patch
 added to -mm tree
Date: Mon, 18 May 2020 12:44:07 -0700
Message-ID: <20200518194407.vcV5hU66Y%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgERToJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 15:44:09 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, chris@zankel.net, davem@davemloft.net, hch@lst.de, ira.weiny@intel.com, jcmvbkbc@gmail.com, luto@kernel.org, mm-commits@vger.kernel.org, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: arch/{mips,sparc,microblaze,powerpc}: Don't enable pagefault/preempt twice
has been added to the -mm tree.  Its filename is
     arch-kunmap_atomic-consolidate-duplicate-code-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kunmap_atomic-consolidate-duplicate-code-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kunmap_atomic-consolidate-duplicate-code-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: ira.weiny@intel.com
Subject: arch/{mips,sparc,microblaze,powerpc}: Don't enable pagefault/preempt twice


The kunmap_atomic clean up failed to remove one set of pagefault/preempt
enables when vaddr is not in the fixmap.

Link: http://lkml.kernel.org/r/20200518184843.3029640-1-ira.weiny@intel.com
Fixes: bee2128a09e6 ("arch/kunmap_atomic: consolidate duplicate code")
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
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
arch-kunmap_atomic-consolidate-duplicate-code-fix.patch
arch-kmap-ensure-kmap_prot-visibility.patch
arch-kmap-dont-hard-code-kmap_prot-values.patch
arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
drm-remove-drm-specific-kmap_atomic-code.patch
kmap-remove-kmap_atomic_to_page.patch
parisc-kmap-remove-duplicate-kmap-code.patch
sparc-remove-unnecessary-includes.patch
kmap-consolidate-kmap_prot-definitions.patch
