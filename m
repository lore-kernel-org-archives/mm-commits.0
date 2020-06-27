From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-remove-vmalloc_exec.patch removed from -mm
 tree
Date: Fri, 26 Jun 2020 20:34:11 -0700
Message-ID: <20200627033411.mR8s9BeZp%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0DeM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:34:12 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, david@redhat.com, decui@microsoft.com, hch@lst.de, jeyu@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, vkuznets@redhat.com, wei.liu@kernel.org, will@kernel.org


The patch titled
     Subject: mm: remove vmalloc_exec
has been removed from the -mm tree.  Its filename was
     mm-remove-vmalloc_exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove vmalloc_exec

Merge vmalloc_exec into its only caller.  Note that for !CONFIG_MMU
__vmalloc_node_range maps to __vmalloc, which directly clears the
__GFP_HIGHMEM added by the vmalloc_exec stub anyway.

Link: http://lkml.kernel.org/r/20200618064307.32739-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 -
 kernel/module.c         |    4 +++-
 mm/nommu.c              |   17 -----------------
 mm/vmalloc.c            |   20 --------------------
 4 files changed, 3 insertions(+), 39 deletions(-)

--- a/include/linux/vmalloc.h~mm-remove-vmalloc_exec
+++ a/include/linux/vmalloc.h
@@ -106,7 +106,6 @@ extern void *vzalloc(unsigned long size)
 extern void *vmalloc_user(unsigned long size);
 extern void *vmalloc_node(unsigned long size, int node);
 extern void *vzalloc_node(unsigned long size, int node);
-extern void *vmalloc_exec(unsigned long size);
 extern void *vmalloc_32(unsigned long size);
 extern void *vmalloc_32_user(unsigned long size);
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask);
--- a/kernel/module.c~mm-remove-vmalloc_exec
+++ a/kernel/module.c
@@ -2783,7 +2783,9 @@ static void dynamic_debug_remove(struct
 
 void * __weak module_alloc(unsigned long size)
 {
-	return vmalloc_exec(size);
+	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
+			GFP_KERNEL, PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERMS,
+			NUMA_NO_NODE, __func__);
 }
 
 bool __weak module_init_section(const char *name)
--- a/mm/nommu.c~mm-remove-vmalloc_exec
+++ a/mm/nommu.c
@@ -291,23 +291,6 @@ void *vzalloc_node(unsigned long size, i
 EXPORT_SYMBOL(vzalloc_node);
 
 /**
- *	vmalloc_exec  -  allocate virtually contiguous, executable memory
- *	@size:		allocation size
- *
- *	Kernel-internal function to allocate enough pages to cover @size
- *	the page level allocator and map them into contiguous and
- *	executable kernel virtual space.
- *
- *	For tight control over page level allocator and protection flags
- *	use __vmalloc() instead.
- */
-
-void *vmalloc_exec(unsigned long size)
-{
-	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM);
-}
-
-/**
  * vmalloc_32  -  allocate virtually contiguous memory (32bit addressable)
  *	@size:		allocation size
  *
--- a/mm/vmalloc.c~mm-remove-vmalloc_exec
+++ a/mm/vmalloc.c
@@ -2695,26 +2695,6 @@ void *vzalloc_node(unsigned long size, i
 }
 EXPORT_SYMBOL(vzalloc_node);
 
-/**
- * vmalloc_exec - allocate virtually contiguous, executable memory
- * @size:	  allocation size
- *
- * Kernel-internal function to allocate enough pages to cover @size
- * the page level allocator and map them into contiguous and
- * executable kernel virtual space.
- *
- * For tight control over page level allocator and protection flags
- * use __vmalloc() instead.
- *
- * Return: pointer to the allocated memory or %NULL on error
- */
-void *vmalloc_exec(unsigned long size)
-{
-	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
-			GFP_KERNEL, PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERMS,
-			NUMA_NO_NODE, __builtin_return_address(0));
-}
