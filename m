From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-prot-argument-from-vm_map_ram.patch added
 to -mm tree
Date: Tue, 14 Apr 2020 21:47:39 -0700
Message-ID: <20200415044739.8JJVxzWMx%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393127AbgDOErm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 00:47:42 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org


The patch titled
     Subject: mm: remove the prot argument from vm_map_ram
has been added to the -mm tree.  Its filename is
     mm-remove-the-prot-argument-from-vm_map_ram.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-prot-argument-from-vm_map_ram.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-prot-argument-from-vm_map_ram.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the prot argument from vm_map_ram

This is always PAGE_KERNEL - for long term mappings with other properties
vmap should be used.

Link: http://lkml.kernel.org/r/20200414131348.444715-19-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c   |    2 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |    3 +--
 drivers/media/common/videobuf2/videobuf2-vmalloc.c |    3 +--
 fs/erofs/decompressor.c                            |    2 +-
 fs/xfs/xfs_buf.c                                   |    2 +-
 include/linux/vmalloc.h                            |    3 +--
 mm/nommu.c                                         |    2 +-
 mm/vmalloc.c                                       |    4 ++--
 8 files changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c~mm-remove-the-prot-argument-from-vm_map_ram
+++ a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
@@ -66,7 +66,7 @@ static void *mock_dmabuf_vmap(struct dma
 {
 	struct mock_dmabuf *mock = to_mock(dma_buf);
 
-	return vm_map_ram(mock->pages, mock->npages, 0, PAGE_KERNEL);
+	return vm_map_ram(mock->pages, mock->npages, 0);
 }
 
 static void mock_dmabuf_vunmap(struct dma_buf *dma_buf, void *vaddr)
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c~mm-remove-the-prot-argument-from-vm_map_ram
+++ a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -309,8 +309,7 @@ static void *vb2_dma_sg_vaddr(void *buf_
 		if (buf->db_attach)
 			buf->vaddr = dma_buf_vmap(buf->db_attach->dmabuf);
 		else
-			buf->vaddr = vm_map_ram(buf->pages,
-					buf->num_pages, -1, PAGE_KERNEL);
+			buf->vaddr = vm_map_ram(buf->pages, buf->num_pages, -1);
 	}
 
 	/* add offset in case userptr is not page-aligned */
--- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c~mm-remove-the-prot-argument-from-vm_map_ram
+++ a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
@@ -107,8 +107,7 @@ static void *vb2_vmalloc_get_userptr(str
 		buf->vaddr = (__force void *)
 			ioremap(__pfn_to_phys(nums[0]), size + offset);
 	} else {
-		buf->vaddr = vm_map_ram(frame_vector_pages(vec), n_pages, -1,
-					PAGE_KERNEL);
+		buf->vaddr = vm_map_ram(frame_vector_pages(vec), n_pages, -1);
 	}
 
 	if (!buf->vaddr)
--- a/fs/erofs/decompressor.c~mm-remove-the-prot-argument-from-vm_map_ram
+++ a/fs/erofs/decompressor.c
@@ -274,7 +274,7 @@ static int z_erofs_decompress_generic(st
 
 	i = 0;
 	while (1) {
-		dst = vm_map_ram(rq->out, nrpages_out, -1, PAGE_KERNEL);
+		dst = vm_map_ram(rq->out, nrpages_out, -1);
 
 		/* retry two more times (totally 3 times) */
 		if (dst || ++i >= 3)
--- a/fs/xfs/xfs_buf.c~mm-remove-the-prot-argument-from-vm_map_ram
+++ a/fs/xfs/xfs_buf.c
@@ -477,7 +477,7 @@ _xfs_buf_map_pages(
 		nofs_flag = memalloc_nofs_save();
 		do {
 			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
-						-1, PAGE_KERNEL);
+						-1);
 			if (bp->b_addr)
 				break;
 			vm_unmap_aliases();
--- a/include/linux/vmalloc.h~mm-remove-the-prot-argument-from-vm_map_ram
+++ a/include/linux/vmalloc.h
@@ -88,8 +88,7 @@ struct vmap_area {
  *	Highlevel APIs for driver use
  */
 extern void vm_unmap_ram(const void *mem, unsigned int count);
-extern void *vm_map_ram(struct page **pages, unsigned int count,
-				int node, pgprot_t prot);
+extern void *vm_map_ram(struct page **pages, unsigned int count, int node);
 extern void vm_unmap_aliases(void);
 
 #ifdef CONFIG_MMU
--- a/mm/nommu.c~mm-remove-the-prot-argument-from-vm_map_ram
+++ a/mm/nommu.c
@@ -351,7 +351,7 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
-void *vm_map_ram(struct page **pages, unsigned int count, int node, pgprot_t prot)
+void *vm_map_ram(struct page **pages, unsigned int count, int node)
 {
 	BUG();
 	return NULL;
--- a/mm/vmalloc.c~mm-remove-the-prot-argument-from-vm_map_ram
+++ a/mm/vmalloc.c
@@ -1834,7 +1834,7 @@ EXPORT_SYMBOL(vm_unmap_ram);
  *
  * Returns: a pointer to the address that has been mapped, or %NULL on failure
  */
-void *vm_map_ram(struct page **pages, unsigned int count, int node, pgprot_t prot)
+void *vm_map_ram(struct page **pages, unsigned int count, int node)
 {
 	unsigned long size = (unsigned long)count << PAGE_SHIFT;
 	unsigned long addr;
@@ -1858,7 +1858,7 @@ void *vm_map_ram(struct page **pages, un
 
 	kasan_unpoison_vmalloc(mem, size);
 
-	if (map_kernel_range(addr, size, prot, pages) < 0) {
+	if (map_kernel_range(addr, size, PAGE_KERNEL, pages) < 0) {
 		vm_unmap_ram(mem, count);
 		return NULL;
 	}
_

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
