From: akpm@linux-foundation.org
Subject: [merged] mm-fix-misuse-of-debug_kmap_atomic.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:59 -0700
Message-ID: <200904061938.n36Jcx4Y013627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbZDFTkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix misuse of debug_kmap_atomic
has been removed from the -mm tree.  Its filename was
     mm-fix-misuse-of-debug_kmap_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix misuse of debug_kmap_atomic
From: Akinobu Mita <akinobu.mita@gmail.com>

Commit 7ca43e7564679604d86e9ed834e7bbcffd8a4a3f (mm: use
debug_kmap_atomic) introduced some debug_kmap_atomic() in wrong places.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/highmem_32.c |    1 -
 arch/x86/mm/iomap_32.c   |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/mm/highmem_32.c~mm-fix-misuse-of-debug_kmap_atomic arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~mm-fix-misuse-of-debug_kmap_atomic
+++ a/arch/x86/mm/highmem_32.c
@@ -40,7 +40,6 @@ void *kmap_atomic_prot(struct page *page
 
 	debug_kmap_atomic(type);
 
-	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
diff -puN arch/x86/mm/iomap_32.c~mm-fix-misuse-of-debug_kmap_atomic arch/x86/mm/iomap_32.c
--- a/arch/x86/mm/iomap_32.c~mm-fix-misuse-of-debug_kmap_atomic
+++ a/arch/x86/mm/iomap_32.c
@@ -39,6 +39,7 @@ void *kmap_atomic_prot_pfn(unsigned long
 
 	pagefault_disable();
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
@@ -72,7 +73,6 @@ iounmap_atomic(void *kvaddr, enum km_typ
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
 
-	debug_kmap_atomic(type);
 	/*
 	 * Force other mappings to Oops if they'll try to access this pte
 	 * without first remap it.  Keeping stale mappings around is a bad idea
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

