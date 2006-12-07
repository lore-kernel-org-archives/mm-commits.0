From: akpm@osdl.org
Subject: - fix-kunmap_atomics-use-of-kpte_clear_flush.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:52 -0800
Message-ID: <200612072256.kB7MuqwI029244@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163603AbWLGW5A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Fix kunmap_atomic's use of kpte_clear_flush()
has been removed from the -mm tree.  Its filename was
     fix-kunmap_atomics-use-of-kpte_clear_flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix kunmap_atomic's use of kpte_clear_flush()
From: Jeremy Fitzhardinge <jeremy@goop.org>

kunmap_atomic() will call kpte_clear_flush with vaddr/ptep arguments which
don't correspond if the vaddr is just a normal lowmem address (ie, not in
the KMAP area).  This patch makes sure that the pte is only cleared if kmap
area was actually used for the mapping.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mm/highmem.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN arch/i386/mm/highmem.c~fix-kunmap_atomics-use-of-kpte_clear_flush arch/i386/mm/highmem.c
--- a/arch/i386/mm/highmem.c~fix-kunmap_atomics-use-of-kpte_clear_flush
+++ a/arch/i386/mm/highmem.c
@@ -50,22 +50,20 @@ void kunmap_atomic(void *kvaddr, enum km
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
 
-#ifdef CONFIG_DEBUG_HIGHMEM
-	if (vaddr >= PAGE_OFFSET && vaddr < (unsigned long)high_memory) {
-		pagefault_enable();
-		return;
-	}
-
-	if (vaddr != __fix_to_virt(FIX_KMAP_BEGIN+idx))
-		BUG();
-#endif
 	/*
 	 * Force other mappings to Oops if they'll try to access this pte
 	 * without first remap it.  Keeping stale mappings around is a bad idea
 	 * also, in case the page changes cacheability attributes or becomes
 	 * a protected page in a hypervisor.
 	 */
-	kpte_clear_flush(kmap_pte-idx, vaddr);
+	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
+		kpte_clear_flush(kmap_pte-idx, vaddr);
+	else {
+#ifdef CONFIG_DEBUG_HIGHMEM
+		BUG_ON(vaddr < PAGE_OFFSET);
+		BUG_ON(vaddr >= (unsigned long)high_memory);
+#endif
+	}
 
 	pagefault_enable();
 }
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
convert-i386-pda-code-to-use-%fs.patch
generic-bug-implementation.patch
generic-bug-implementation-handle-bug=n.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
generic-bug-for-i386.patch
generic-bug-for-x86-64.patch
uml-add-generic-bug-support.patch
use-generic-bug-for-ppc.patch
bug-test-1.patch
fix-generic-warn_on-message.patch
time-uninline-jiffiesh-fix.patch

