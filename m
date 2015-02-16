From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:18:28 -0800
Message-ID: <54e25094.FvUfkIo+FKIPgzsP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbbBPUTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: add flag preventing guard hole allocation
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: vmalloc: add flag preventing guard hole allocation

For instrumenting global variables KASan will shadow memory backing memory
for modules.  So on module loading we will need to allocate memory for
shadow and map it at address in shadow that corresponds to the address
allocated in module_alloc().

__vmalloc_node_range() could be used for this purpose, except it puts a
guard hole after allocated area.  Guard hole in shadow memory should be a
problem because at some future point we might need to have a shadow memory
at address occupied by guard hole.  So we could fail to allocate shadow
for module_alloc().

Add a new vm_struct flag 'VM_NO_GUARD' indicating that vm area doesn't
have a guard hole.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    9 +++++++--
 mm/vmalloc.c            |    6 ++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmalloc-add-flag-preventing-guard-hole-allocation include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-add-flag-preventing-guard-hole-allocation
+++ a/include/linux/vmalloc.h
@@ -16,6 +16,7 @@ struct vm_area_struct;		/* vma defining
 #define VM_USERMAP		0x00000008	/* suitable for remap_vmalloc_range */
 #define VM_VPAGES		0x00000010	/* buffer for pages was vmalloc'ed */
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
+#define VM_NO_GUARD		0x00000040      /* don't add guard page */
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
@@ -96,8 +97,12 @@ void vmalloc_sync_all(void);
 
 static inline size_t get_vm_area_size(const struct vm_struct *area)
 {
-	/* return actual size without guard page */
-	return area->size - PAGE_SIZE;
+	if (!(area->flags & VM_NO_GUARD))
+		/* return actual size without guard page */
+		return area->size - PAGE_SIZE;
+	else
+		return area->size;
+
 }
 
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
diff -puN mm/vmalloc.c~mm-vmalloc-add-flag-preventing-guard-hole-allocation mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-add-flag-preventing-guard-hole-allocation
+++ a/mm/vmalloc.c
@@ -1324,10 +1324,8 @@ static struct vm_struct *__get_vm_area_n
 	if (unlikely(!area))
 		return NULL;
 
-	/*
-	 * We always allocate a guard page.
-	 */
-	size += PAGE_SIZE;
+	if (!(flags & VM_NO_GUARD))
+		size += PAGE_SIZE;
 
 	va = alloc_vmap_area(size, align, start, end, node, gfp_mask);
 	if (IS_ERR(va)) {
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch

