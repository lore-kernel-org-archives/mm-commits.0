From: akpm@linux-foundation.org
Subject: - kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:04 -0800
Message-ID: <200901082246.n08Mk4fA025590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763464AbZAHWvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     kmemleak: add the vmalloc memory allocation/freeing hooks
has been removed from the -mm tree.  Its filename was
     kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: add the vmalloc memory allocation/freeing hooks
From: Catalin Marinas <catalin.marinas@arm.com>

Add the callbacks to kmemleak_(alloc|free) functions from vmalloc/vfree.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks mm/vmalloc.c
--- a/mm/vmalloc.c~kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks
+++ a/mm/vmalloc.c
@@ -24,6 +24,7 @@
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/kmemleak.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -1223,6 +1224,9 @@ static void __vunmap(const void *addr, i
 void vfree(const void *addr)
 {
 	BUG_ON(in_interrupt());
+
+	kmemleak_free(addr);
+
 	__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
@@ -1332,8 +1336,16 @@ fail:
 
 void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_area_node(area, gfp_mask, prot, -1,
-					__builtin_return_address(0));
+	void *addr = __vmalloc_area_node(area, gfp_mask, prot, -1,
+					 __builtin_return_address(0));
+
+	/*
+	 * This needs ref_count = 2 since vm_struct also contains a pointer to
+	 * this address. The guard page is subtracted from the size.
+	 */
+	kmemleak_alloc(addr, area->size - PAGE_SIZE, 2, gfp_mask);
+
+	return addr;
 }
 
 /**
@@ -1352,6 +1364,8 @@ static void *__vmalloc_node(unsigned lon
 						int node, void *caller)
 {
 	struct vm_struct *area;
+	void *addr;
+	unsigned long real_size = size;
 
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > num_physpages)
@@ -1363,7 +1377,15 @@ static void *__vmalloc_node(unsigned lon
 	if (!area)
 		return NULL;
 
-	return __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+
+	/*
+	 * This needs ref_count = 2 since the vm_struct also contains a
+	 * pointer to this address.
+	 */
+	kmemleak_alloc(addr, real_size, 2, gfp_mask);
+
+	return addr;
 }
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch
kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

