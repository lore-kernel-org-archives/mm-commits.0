From: akpm@linux-foundation.org
Subject: [merged] vmalloc-eagerly-clear-ptes-on-vunmap.patch removed from -mm tree
Date: Tue, 07 Dec 2010 11:46:43 -0800
Message-ID: <201012071948.oB7JmIpA004601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845Ab0LGTsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 14:48:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, Trond.Myklebust@netapp.com, aelder@sgi.com, bjschuma@netapp.com, david@fromorbit.com, hch@lst.de, jeremy.fitzhardinge@citrix.com, npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     vmalloc: eagerly clear ptes on vunmap
has been removed from the -mm tree.  Its filename was
     vmalloc-eagerly-clear-ptes-on-vunmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: eagerly clear ptes on vunmap
From: Jeremy Fitzhardinge <jeremy@goop.org>

On stock 2.6.37-rc4, running:

# mount lilith:/export /mnt/lilith
# find  /mnt/lilith/ -type f -print0 | xargs -0 file

crashes the machine fairly quickly under Xen.  Often it results in oops
messages, but the couple of times I tried just now, it just hung quietly
and made Xen print some rude messages:

    (XEN) mm.c:2389:d80 Bad type (saw 7400000000000001 != exp
    3000000000000000) for mfn 1d7058 (pfn 18fa7)
    (XEN) mm.c:964:d80 Attempt to create linear p.t. with write perms
    (XEN) mm.c:2389:d80 Bad type (saw 7400000000000010 != exp
    1000000000000000) for mfn 1d2e04 (pfn 1d1fb)
    (XEN) mm.c:2965:d80 Error while pinning mfn 1d2e04

Which means the domain tried to map a pagetable page RW, which would allow
it to map arbitrary memory, so Xen stopped it.  This is because
vm_unmap_ram() left some pages mapped in the vmalloc area after NFS had
finished with them, and those pages got recycled as pagetable pages while
still having these RW aliases.

Removing those mappings immediately removes the Xen-visible aliases, and
so it has no problem with those pages being reused as pagetable pages. 
Deferring the TLB flush doesn't upset Xen because it can flush the TLB
itself as needed to maintain its invariants.


When unmapping a region in the vmalloc space, clear the ptes immediately. 
There's no point in deferring this because there's no amortization
benefit.

The TLBs are left dirty, and they are flushed lazily to amortize the cost
of the IPIs.

This specific motivation for this patch is an oops-causing regression
since 2.6.36 when using NFS under Xen, triggered by the NFS client's use
of vm_map_ram() introduced in 56e4ebf877b60 ("NFS: readdir with vmapped
pages") .  XFS also uses vm_map_ram() and could cause similar problems.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Bryan Schumaker <bjschuma@netapp.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu.c      |    2 --
 include/linux/vmalloc.h |    2 --
 mm/vmalloc.c            |   28 +++++++++++++++++-----------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff -puN arch/x86/xen/mmu.c~vmalloc-eagerly-clear-ptes-on-vunmap arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~vmalloc-eagerly-clear-ptes-on-vunmap
+++ a/arch/x86/xen/mmu.c
@@ -2415,8 +2415,6 @@ void __init xen_init_mmu_ops(void)
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
 
-	vmap_lazy_unmap = false;
-
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
 }
 
diff -puN include/linux/vmalloc.h~vmalloc-eagerly-clear-ptes-on-vunmap include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~vmalloc-eagerly-clear-ptes-on-vunmap
+++ a/include/linux/vmalloc.h
@@ -7,8 +7,6 @@
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 
-extern bool vmap_lazy_unmap;
-
 /* bits in flags of vmalloc's vm_struct below */
 #define VM_IOREMAP	0x00000001	/* ioremap() and friends */
 #define VM_ALLOC	0x00000002	/* vmalloc() */
diff -puN mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap
+++ a/mm/vmalloc.c
@@ -31,8 +31,6 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
-bool vmap_lazy_unmap __read_mostly = true;
-
 /*** Page table manipulation functions ***/
 
 static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end)
@@ -503,9 +501,6 @@ static unsigned long lazy_max_pages(void
 {
 	unsigned int log;
 
-	if (!vmap_lazy_unmap)
-		return 0;
-
 	log = fls(num_online_cpus());
 
 	return log * (32UL * 1024 * 1024 / PAGE_SIZE);
@@ -566,7 +561,6 @@ static void __purge_vmap_area_lazy(unsig
 			if (va->va_end > *end)
 				*end = va->va_end;
 			nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
-			unmap_vmap_area(va);
 			list_add_tail(&va->purge_list, &valist);
 			va->flags |= VM_LAZY_FREEING;
 			va->flags &= ~VM_LAZY_FREE;
@@ -611,10 +605,11 @@ static void purge_vmap_area_lazy(void)
 }
 
 /*
- * Free and unmap a vmap area, caller ensuring flush_cache_vunmap had been
- * called for the correct range previously.
+ * Free a vmap area, caller ensuring that the area has been unmapped
+ * and flush_cache_vunmap had been called for the correct range
+ * previously.
  */
-static void free_unmap_vmap_area_noflush(struct vmap_area *va)
+static void free_vmap_area_noflush(struct vmap_area *va)
 {
 	va->flags |= VM_LAZY_FREE;
 	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
@@ -623,6 +618,16 @@ static void free_unmap_vmap_area_noflush
 }
 
 /*
+ * Free and unmap a vmap area, caller ensuring flush_cache_vunmap had been
+ * called for the correct range previously.
+ */
+static void free_unmap_vmap_area_noflush(struct vmap_area *va)
+{
+	unmap_vmap_area(va);
+	free_vmap_area_noflush(va);
+}
+
+/*
  * Free and unmap a vmap area
  */
 static void free_unmap_vmap_area(struct vmap_area *va)
@@ -798,7 +803,7 @@ static void free_vmap_block(struct vmap_
 	spin_unlock(&vmap_block_tree_lock);
 	BUG_ON(tmp != vb);
 
-	free_unmap_vmap_area_noflush(vb->va);
+	free_vmap_area_noflush(vb->va);
 	call_rcu(&vb->rcu_head, rcu_free_vb);
 }
 
@@ -936,6 +941,8 @@ static void vb_free(const void *addr, un
 	rcu_read_unlock();
 	BUG_ON(!vb);
 
+	vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
+
 	spin_lock(&vb->lock);
 	BUG_ON(bitmap_allocate_region(vb->dirty_map, offset >> PAGE_SHIFT, order));
 
@@ -988,7 +995,6 @@ void vm_unmap_aliases(void)
 
 				s = vb->va->va_start + (i << PAGE_SHIFT);
 				e = vb->va->va_start + (j << PAGE_SHIFT);
-				vunmap_page_range(s, e);
 				flush = 1;
 
 				if (s < start)
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch

