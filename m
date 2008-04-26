From: akpm@linux-foundation.org
Subject: - revert-git-drm.patch removed from -mm tree
Date: Sat, 26 Apr 2008 07:07:05 -0700
Message-ID: <200804261407.m3QE75ci025425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbYDZOHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 10:07:09 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3QE77aU012931
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2008 07:07:08 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     revert git-drm
has been removed from the -mm tree.  Its filename was
     revert-git-drm.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: revert git-drm
=46rom: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/Makefile         |    5=20
 drivers/char/drm/ati_pcigart.c    |   22=20
 drivers/char/drm/drm.h            |  334 ---
 drivers/char/drm/drmP.h           |   96 -
 drivers/char/drm/drm_agpsupport.c |  196 --
 drivers/char/drm/drm_auth.c       |    8=20
 drivers/char/drm/drm_bo.c         | 2677 ----------------------------
 drivers/char/drm/drm_bo_lock.c    |  175 -
 drivers/char/drm/drm_bo_move.c    |  609 ------
 drivers/char/drm/drm_bufs.c       |   42=20
 drivers/char/drm/drm_context.c    |    4=20
 drivers/char/drm/drm_drv.c        |   68=20
 drivers/char/drm/drm_fence.c      |  824 --------
 drivers/char/drm/drm_fops.c       |   62=20
 drivers/char/drm/drm_hashtab.c    |    4=20
 drivers/char/drm/drm_irq.c        |    2=20
 drivers/char/drm/drm_lock.c       |    2=20
 drivers/char/drm/drm_memory.c     |   69=20
 drivers/char/drm/drm_mm.c         |   12=20
 drivers/char/drm/drm_object.c     |  293 ---
 drivers/char/drm/drm_objects.h    |  760 -------
 drivers/char/drm/drm_proc.c       |   90=20
 drivers/char/drm/drm_scatter.c    |    2=20
 drivers/char/drm/drm_stub.c       |   22=20
 drivers/char/drm/drm_ttm.c        |  464 ----
 drivers/char/drm/drm_vm.c         |  198 --
 drivers/char/drm/i915_buffer.c    |  195 --
 drivers/char/drm/i915_dma.c       |  937 ---------
 drivers/char/drm/i915_drm.h       |  137 -
 drivers/char/drm/i915_drv.c       |   23=20
 drivers/char/drm/i915_drv.h       |   88=20
 drivers/char/drm/i915_fence.c     |  269 --
 drivers/char/drm/i915_ioc32.c     |   60=20
 drivers/char/drm/i915_irq.c       |  288 ---
 34 files changed, 237 insertions(+), 8800 deletions(-)

diff -puN drivers/char/drm/Makefile~revert-git-drm drivers/char/drm/Mak=
efile
--- a/drivers/char/drm/Makefile~revert-git-drm
+++ a/drivers/char/drm/Makefile
@@ -6,15 +6,14 @@ drm-objs    :=3D	drm_auth.o drm_bufs.o drm
 		drm_drv.o drm_fops.o drm_ioctl.o drm_irq.o \
 		drm_lock.o drm_memory.o drm_proc.o drm_stub.o drm_vm.o \
 		drm_agpsupport.o drm_scatter.o ati_pcigart.o drm_pci.o \
-		drm_sysfs.o drm_hashtab.o drm_sman.o drm_mm.o drm_object.o \
-		drm_fence.o drm_ttm.o drm_bo.o drm_bo_move.o drm_bo_lock.o
+		drm_sysfs.o drm_hashtab.o drm_sman.o drm_mm.o
=20
 tdfx-objs   :=3D tdfx_drv.o
 r128-objs   :=3D r128_drv.o r128_cce.o r128_state.o r128_irq.o
 mga-objs    :=3D mga_drv.o mga_dma.o mga_state.o mga_warp.o mga_irq.o
 i810-objs   :=3D i810_drv.o i810_dma.o
 i830-objs   :=3D i830_drv.o i830_dma.o i830_irq.o
-i915-objs   :=3D i915_drv.o i915_dma.o i915_irq.o i915_mem.o i915_fenc=
e.o i915_buffer.o
+i915-objs   :=3D i915_drv.o i915_dma.o i915_irq.o i915_mem.o
 radeon-objs :=3D radeon_drv.o radeon_cp.o radeon_state.o radeon_mem.o =
radeon_irq.o r300_cmdbuf.o
 sis-objs    :=3D sis_drv.o sis_mm.o
 savage-objs :=3D savage_drv.o savage_bci.o savage_state.o
diff -puN drivers/char/drm/ati_pcigart.c~revert-git-drm drivers/char/dr=
m/ati_pcigart.c
--- a/drivers/char/drm/ati_pcigart.c~revert-git-drm
+++ a/drivers/char/drm/ati_pcigart.c
@@ -38,29 +38,11 @@
 static int drm_ati_alloc_pcigart_table(struct drm_device *dev,
 				       struct drm_ati_pcigart_info *gart_info)
 {
-<<<<<<< HEAD:drivers/char/drm/ati_pcigart.c
 	gart_info->table_handle =3D drm_pci_alloc(dev, gart_info->table_size,
 						PAGE_SIZE,
 						gart_info->table_mask);
 	if (gart_info->table_handle =3D=3D NULL)
 		return -ENOMEM;
-=3D=3D=3D=3D=3D=3D=3D
-	unsigned long address;
-	struct page *page;
-	int i;
-
-	DRM_DEBUG("%d order\n", order);
-
-	address =3D __get_free_pages(GFP_KERNEL | __GFP_COMP,
-				   order);
-	if (address =3D=3D 0UL)
-		return NULL;
-
-	page =3D virt_to_page(address);
-
-	for (i =3D 0; i < order; i++, page++)
-		SetPageReserved(page);
->>>>>>> FETCH_HEAD:drivers/char/drm/ati_pcigart.c
=20
 	return 0;
 }
@@ -169,7 +151,7 @@ int drm_ati_pcigart_init(struct drm_devi
 		page_base =3D (u32) entry->busaddr[i];
=20
 		for (j =3D 0; j < (PAGE_SIZE / ATI_PCIGART_PAGE_SIZE); j++) {
-			switch (gart_info->gart_reg_if) {
+			switch(gart_info->gart_reg_if) {
 			case DRM_ATI_GART_IGP:
 				*pci_gart =3D cpu_to_le32((page_base) | 0xc);
 				break;
@@ -200,7 +182,7 @@ int drm_ati_pcigart_init(struct drm_devi
 	mb();
 #endif
=20
-done:
+      done:
 	gart_info->addr =3D address;
 	gart_info->bus_addr =3D bus_address;
 	return ret;
diff -puN drivers/char/drm/drm.h~revert-git-drm drivers/char/drm/drm.h
--- a/drivers/char/drm/drm.h~revert-git-drm
+++ a/drivers/char/drm/drm.h
@@ -190,7 +190,6 @@ enum drm_map_type {
 	_DRM_AGP =3D 3,		  /**< AGP/GART */
 	_DRM_SCATTER_GATHER =3D 4,  /**< Scatter/gather memory for PCI DMA */
 	_DRM_CONSISTENT =3D 5,	  /**< Consistent memory for PCI DMA */
-	_DRM_TTM =3D 6
 };
=20
 /**
@@ -472,7 +471,6 @@ struct drm_irq_busid {
 enum drm_vblank_seq_type {
 	_DRM_VBLANK_ABSOLUTE =3D 0x0,	/**< Wait for specific vblank sequence =
number */
 	_DRM_VBLANK_RELATIVE =3D 0x1,	/**< Wait for given number of vblanks *=
/
-	_DRM_VBLANK_FLIP =3D 0x8000000,	/**< Scheduled buffer swap should fli=
p */
 	_DRM_VBLANK_NEXTONMISS =3D 0x10000000,	/**< If missed, wait for next =
vblank */
 	_DRM_VBLANK_SECONDARY =3D 0x20000000,	/**< Secondary display controll=
er */
 	_DRM_VBLANK_SIGNAL =3D 0x40000000	/**< Send signal instead of blockin=
g */
@@ -575,315 +573,6 @@ struct drm_set_version {
 	int drm_dd_minor;
 };
=20
-#define DRM_FENCE_FLAG_EMIT                0x00000001
-#define DRM_FENCE_FLAG_SHAREABLE           0x00000002
-#define DRM_FENCE_FLAG_WAIT_LAZY           0x00000004
-#define DRM_FENCE_FLAG_WAIT_IGNORE_SIGNALS 0x00000008
-#define DRM_FENCE_FLAG_NO_USER             0x00000010
-
-/* Reserved for driver use */
-#define DRM_FENCE_MASK_DRIVER              0xFF000000
-
-#define DRM_FENCE_TYPE_EXE                 0x00000001
-
-struct drm_fence_arg {
-	unsigned int handle;
-	unsigned int fence_class;
-	unsigned int type;
-	unsigned int flags;
-	unsigned int signaled;
-	unsigned int error;
-	unsigned int sequence;
-	unsigned int pad64;
-	uint64_t expand_pad[2]; /*Future expansion */
-};
-
-/* Buffer permissions, referring to how the GPU uses the buffers.
- * these translate to fence types used for the buffers.
- * Typically a texture buffer is read, A destination buffer is write a=
nd
- *  a command (batch-) buffer is exe. Can be or-ed together.
- */
-
-#define DRM_BO_FLAG_READ        (1ULL << 0)
-#define DRM_BO_FLAG_WRITE       (1ULL << 1)
-#define DRM_BO_FLAG_EXE         (1ULL << 2)
-
-/*
- * All of the bits related to access mode
- */
-#define DRM_BO_MASK_ACCESS	(DRM_BO_FLAG_READ | DRM_BO_FLAG_WRITE | DRM=
_BO_FLAG_EXE)
-/*
- * Status flags. Can be read to determine the actual state of a buffer=
=2E
- * Can also be set in the buffer mask before validation.
- */
-
-/*
- * Mask: Never evict this buffer. Not even with force.
- * This type of buffer is only available to root and must be manually
- * removed before buffer manager shutdown or lock.
- * Flags: Acknowledge
- */
-#define DRM_BO_FLAG_NO_EVICT    (1ULL << 4)
-
-/*
- * Mask: Require that the buffer is placed in mappable memory when val=
idated.
- * If not set the buffer may or may not be in mappable memory when val=
idated.
- * Flags: If set, the buffer is in mappable memory.
- */
-#define DRM_BO_FLAG_MAPPABLE    (1ULL << 5)
-
-/* Mask: The buffer should be shareable with other processes.
- * Flags: The buffer is shareable with other processes.
- */
-#define DRM_BO_FLAG_SHAREABLE   (1ULL << 6)
-
-/* Mask: If set, place the buffer in cache-coherent memory if availabl=
e.
- *       If clear, never place the buffer in cache coherent memory if =
validated.
- * Flags: The buffer is currently in cache-coherent memory.
- */
-#define DRM_BO_FLAG_CACHED      (1ULL << 7)
-
-/* Mask: Make sure that every time this buffer is validated,
- *       it ends up on the same location provided that the memory mask
- *       is the same.
- *       The buffer will also not be evicted when claiming space for
- *       other buffers. Basically a pinned buffer but it may be thrown=
 out as
- *       part of buffer manager shutdown or locking.
- * Flags: Acknowledge.
- */
-#define DRM_BO_FLAG_NO_MOVE     (1ULL << 8)
-
-/* Mask: Make sure the buffer is in cached memory when mapped.  In con=
junction
- * with DRM_BO_FLAG_CACHED it also allows the buffer to be bound into =
the GART
- * with unsnooped PTEs instead of snooped, by using chipset-specific c=
ache
- * flushing at bind time.  A better name might be DRM_BO_FLAG_TT_UNSNO=
OPED,
- * as the eviction to local memory (TTM unbind) on map is just a side =
effect
- * to prevent aggressive cache prefetch from the GPU disturbing the ca=
che
- * management that the DRM is doing.
- *
- * Flags: Acknowledge.
- * Buffers allocated with this flag should not be used for suballocato=
rs
- * This type may have issues on CPUs with over-aggressive caching
- * http://marc.info/?l=3Dlinux-kernel&m=3D102376926732464&w=3D2
- */
-#define DRM_BO_FLAG_CACHED_MAPPED    (1ULL << 19)
-
-
-/* Mask: Force DRM_BO_FLAG_CACHED flag strictly also if it is set.
- * Flags: Acknowledge.
- */
-#define DRM_BO_FLAG_FORCE_CACHING  (1ULL << 13)
-
-/*
- * Mask: Force DRM_BO_FLAG_MAPPABLE flag strictly also if it is clear.
- * Flags: Acknowledge.
- */
-#define DRM_BO_FLAG_FORCE_MAPPABLE (1ULL << 14)
-#define DRM_BO_FLAG_TILE           (1ULL << 15)
-
-/*
- * Memory type flags that can be or'ed together in the mask, but only
- * one appears in flags.
- */
-
-/* System memory */
-#define DRM_BO_FLAG_MEM_LOCAL  (1ULL << 24)
-/* Translation table memory */
-#define DRM_BO_FLAG_MEM_TT     (1ULL << 25)
-/* Vram memory */
-#define DRM_BO_FLAG_MEM_VRAM   (1ULL << 26)
-/* Up to the driver to define. */
-#define DRM_BO_FLAG_MEM_PRIV0  (1ULL << 27)
-#define DRM_BO_FLAG_MEM_PRIV1  (1ULL << 28)
-#define DRM_BO_FLAG_MEM_PRIV2  (1ULL << 29)
-#define DRM_BO_FLAG_MEM_PRIV3  (1ULL << 30)
-#define DRM_BO_FLAG_MEM_PRIV4  (1ULL << 31)
-/* We can add more of these now with a 64-bit flag type */
-
-/*
- * This is a mask covering all of the memory type flags; easier to jus=
t
- * use a single constant than a bunch of | values. It covers
- * DRM_BO_FLAG_MEM_LOCAL through DRM_BO_FLAG_MEM_PRIV4
- */
-#define DRM_BO_MASK_MEM         0x00000000FF000000ULL
-/*
- * This adds all of the CPU-mapping options in with the memory
- * type to label all bits which change how the page gets mapped
- */
-#define DRM_BO_MASK_MEMTYPE     (DRM_BO_MASK_MEM | \
-				 DRM_BO_FLAG_CACHED_MAPPED | \
-				 DRM_BO_FLAG_CACHED | \
-				 DRM_BO_FLAG_MAPPABLE)
-
-/* Driver-private flags */
-#define DRM_BO_MASK_DRIVER      0xFFFF000000000000ULL
-
-/*
- * Don't block on validate and map. Instead, return EBUSY.
- */
-#define DRM_BO_HINT_DONT_BLOCK  0x00000002
-/*
- * Don't place this buffer on the unfenced list. This means
- * that the buffer will not end up having a fence associated
- * with it as a result of this operation
- */
-#define DRM_BO_HINT_DONT_FENCE  0x00000004
-/*
- * Sleep while waiting for the operation to complete.
- * Without this flag, the kernel will, instead, spin
- * until this operation has completed. I'm not sure
- * why you would ever want this, so please always
- * provide DRM_BO_HINT_WAIT_LAZY to any operation
- * which may block
- */
-#define DRM_BO_HINT_WAIT_LAZY   0x00000008
-/*
- * The client has compute relocations refering to this buffer using th=
e
- * offset in the presumed_offset field. If that offset ends up matchin=
g
- * where this buffer lands, the kernel is free to skip executing those
- * relocations
- */
-#define DRM_BO_HINT_PRESUMED_OFFSET 0x00000010
-
-
-#define DRM_BO_INIT_MAGIC 0xfe769812
-#define DRM_BO_INIT_MAJOR 1
-#define DRM_BO_INIT_MINOR 0
-#define DRM_BO_INIT_PATCH 0
-
-
-struct drm_bo_info_req {
-	uint64_t mask;
-	uint64_t flags;
-	unsigned int handle;
-	unsigned int hint;
-	unsigned int fence_class;
-	unsigned int desired_tile_stride;
-	unsigned int tile_info;
-	unsigned int pad64;
-	uint64_t presumed_offset;
-};
-
-struct drm_bo_create_req {
-	uint64_t flags;
-	uint64_t size;
-	uint64_t buffer_start;
-	unsigned int hint;
-	unsigned int page_alignment;
-};
-
-
-/*
- * Reply flags
- */
-
-#define DRM_BO_REP_BUSY 0x00000001
-
-struct drm_bo_info_rep {
-	uint64_t flags;
-	uint64_t proposed_flags;
-	uint64_t size;
-	uint64_t offset;
-	uint64_t arg_handle;
-	uint64_t buffer_start;
-	unsigned int handle;
-	unsigned int fence_flags;
-	unsigned int rep_flags;
-	unsigned int page_alignment;
-	unsigned int desired_tile_stride;
-	unsigned int hw_tile_stride;
-	unsigned int tile_info;
-	unsigned int pad64;
-	uint64_t expand_pad[4]; /*Future expansion */
-};
-
-struct drm_bo_arg_rep {
-	struct drm_bo_info_rep bo_info;
-	int ret;
-	unsigned int pad64;
-};
-
-struct drm_bo_create_arg {
-	union {
-		struct drm_bo_create_req req;
-		struct drm_bo_info_rep rep;
-	} d;
-};
-
-struct drm_bo_handle_arg {
-	unsigned int handle;
-};
-
-struct drm_bo_reference_info_arg {
-	union {
-		struct drm_bo_handle_arg req;
-		struct drm_bo_info_rep rep;
-	} d;
-};
-
-struct drm_bo_map_wait_idle_arg {
-	union {
-		struct drm_bo_info_req req;
-		struct drm_bo_info_rep rep;
-	} d;
-};
-
-struct drm_bo_op_req {
-	enum {
-		drm_bo_validate,
-		drm_bo_fence,
-		drm_bo_ref_fence,
-	} op;
-	unsigned int arg_handle;
-	struct drm_bo_info_req bo_req;
-};
-
-
-struct drm_bo_op_arg {
-	uint64_t next;
-	union {
-		struct drm_bo_op_req req;
-		struct drm_bo_arg_rep rep;
-	} d;
-	int handled;
-	unsigned int pad64;
-};
-
-
-#define DRM_BO_MEM_LOCAL 0
-#define DRM_BO_MEM_TT 1
-#define DRM_BO_MEM_VRAM 2
-#define DRM_BO_MEM_PRIV0 3
-#define DRM_BO_MEM_PRIV1 4
-#define DRM_BO_MEM_PRIV2 5
-#define DRM_BO_MEM_PRIV3 6
-#define DRM_BO_MEM_PRIV4 7
-
-#define DRM_BO_MEM_TYPES 8 /* For now. */
-
-#define DRM_BO_LOCK_UNLOCK_BM       (1 << 0)
-#define DRM_BO_LOCK_IGNORE_NO_EVICT (1 << 1)
-
-struct drm_bo_version_arg {
-	uint32_t major;
-	uint32_t minor;
-	uint32_t patchlevel;
-};
-
-struct drm_mm_type_arg {
-	unsigned int mem_type;
-	unsigned int lock_flags;
-};
-
-struct drm_mm_init_arg {
-	unsigned int magic;
-	unsigned int major;
-	unsigned int minor;
-	unsigned int mem_type;
-	uint64_t p_offset;
-	uint64_t p_size;
-};
-
 #define DRM_IOCTL_BASE			'd'
 #define DRM_IO(nr)			_IO(DRM_IOCTL_BASE,nr)
 #define DRM_IOR(nr,type)		_IOR(DRM_IOCTL_BASE,nr,type)
@@ -946,29 +635,6 @@ struct drm_mm_init_arg {
=20
 #define DRM_IOCTL_UPDATE_DRAW		DRM_IOW(0x3f, struct drm_update_draw)
=20
-#define DRM_IOCTL_MM_INIT               DRM_IOWR(0xc0, struct drm_mm_i=
nit_arg)
-#define DRM_IOCTL_MM_TAKEDOWN           DRM_IOWR(0xc1, struct drm_mm_t=
ype_arg)
-#define DRM_IOCTL_MM_LOCK               DRM_IOWR(0xc2, struct drm_mm_t=
ype_arg)
-#define DRM_IOCTL_MM_UNLOCK             DRM_IOWR(0xc3, struct drm_mm_t=
ype_arg)
-
-#define DRM_IOCTL_FENCE_CREATE          DRM_IOWR(0xc4, struct drm_fenc=
e_arg)
-#define DRM_IOCTL_FENCE_REFERENCE       DRM_IOWR(0xc6, struct drm_fenc=
e_arg)
-#define DRM_IOCTL_FENCE_UNREFERENCE     DRM_IOWR(0xc7, struct drm_fenc=
e_arg)
-#define DRM_IOCTL_FENCE_SIGNALED        DRM_IOWR(0xc8, struct drm_fenc=
e_arg)
-#define DRM_IOCTL_FENCE_FLUSH           DRM_IOWR(0xc9, struct drm_fenc=
e_arg)
-#define DRM_IOCTL_FENCE_WAIT            DRM_IOWR(0xca, struct drm_fenc=
e_arg)
-#define DRM_IOCTL_FENCE_EMIT            DRM_IOWR(0xcb, struct drm_fenc=
e_arg)
-#define DRM_IOCTL_FENCE_BUFFERS         DRM_IOWR(0xcc, struct drm_fenc=
e_arg)
-
-#define DRM_IOCTL_BO_CREATE             DRM_IOWR(0xcd, struct drm_bo_c=
reate_arg)
-#define DRM_IOCTL_BO_MAP                DRM_IOWR(0xcf, struct drm_bo_m=
ap_wait_idle_arg)
-#define DRM_IOCTL_BO_UNMAP              DRM_IOWR(0xd0, struct drm_bo_h=
andle_arg)
-#define DRM_IOCTL_BO_REFERENCE          DRM_IOWR(0xd1, struct drm_bo_r=
eference_info_arg)
-#define DRM_IOCTL_BO_UNREFERENCE        DRM_IOWR(0xd2, struct drm_bo_h=
andle_arg)
-#define DRM_IOCTL_BO_SETSTATUS          DRM_IOWR(0xd3, struct drm_bo_m=
ap_wait_idle_arg)
-#define DRM_IOCTL_BO_INFO               DRM_IOWR(0xd4, struct drm_bo_r=
eference_info_arg)
-#define DRM_IOCTL_BO_WAIT_IDLE          DRM_IOWR(0xd5, struct drm_bo_m=
ap_wait_idle_arg)
-#define DRM_IOCTL_BO_VERSION          DRM_IOR(0xd6, struct drm_bo_vers=
ion_arg)
 /**
  * Device specific ioctls should only be in their respective headers
  * The device specific ioctl range is from 0x40 to 0x99.
diff -puN drivers/char/drm/drmP.h~revert-git-drm drivers/char/drm/drmP.=
h
--- a/drivers/char/drm/drmP.h~revert-git-drm
+++ a/drivers/char/drm/drmP.h
@@ -56,7 +56,6 @@
 #include <linux/smp_lock.h>	/* For (un)lock_kernel */
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
-#include <linux/pagemap.h>
 #include <linux/cdev.h>
 #include <linux/mutex.h>
 #if defined(__alpha__) || defined(__powerpc__)
@@ -68,7 +67,6 @@
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
-#include <asm/agp.h>
 #if defined(CONFIG_AGP) || defined(CONFIG_AGP_MODULE)
 #include <linux/types.h>
 #include <linux/agp_backend.h>
@@ -147,22 +145,9 @@ struct drm_device;
 #define DRM_MEM_CTXLIST   21
 #define DRM_MEM_MM        22
 #define DRM_MEM_HASHTAB   23
-#define DRM_MEM_OBJECTS   24
-#define DRM_MEM_FENCE     25
-#define DRM_MEM_TTM       26
-#define DRM_MEM_BUFOBJ    27
=20
 #define DRM_MAX_CTXBITMAP (PAGE_SIZE * 8)
 #define DRM_MAP_HASH_OFFSET 0x10000000
-#define DRM_MAP_HASH_ORDER 12
-#define DRM_OBJECT_HASH_ORDER 12
-#define DRM_FILE_PAGE_OFFSET_START ((0xFFFFFFFFUL >> PAGE_SHIFT) + 1)
-#define DRM_FILE_PAGE_OFFSET_SIZE ((0xFFFFFFFFUL >> PAGE_SHIFT) * 16)
-/*
- * This should be small enough to allow the use of kmalloc for hash ta=
bles
- * instead of vmalloc.
- */
-#define DRM_FILE_HASH_ORDER 8
=20
 /*@}*/
=20
@@ -390,12 +375,6 @@ struct drm_buf_entry {
 	struct drm_freelist freelist;
 };
=20
-enum drm_ref_type {
-	_DRM_REF_USE =3D 0,
-	_DRM_REF_TYPE1,
-	_DRM_NO_REF_TYPES
-};
-
 /** File private data */
 struct drm_file {
 	int authenticated;
@@ -409,14 +388,6 @@ struct drm_file {
 	struct drm_head *head;
 	int remove_auth_on_close;
 	unsigned long lock_count;
-	/*
-	 * The user object hash table is global and resides in the
-	 * drm_device structure. We protect the lists and hash tables with th=
e
-	 * device struct_mutex. A bit coarse-grained but probably the best
-	 * option.
-	 */
-	struct list_head refd_objects;
-	struct drm_open_hash refd_object_hash[_DRM_NO_REF_TYPES];
 	struct file *filp;
 	void *driver_priv;
 };
@@ -548,7 +519,6 @@ struct drm_map_list {
 	struct drm_hash_item hash;
 	struct drm_map *map;			/**< mapping */
 	uint64_t user_token;
-	struct drm_mm_node *file_offset_node;
 };
=20
 typedef struct drm_map drm_local_map_t;
@@ -588,8 +558,6 @@ struct drm_ati_pcigart_info {
 	int table_size;
 };
=20
-#include "drm_objects.h"
-
 /**
  * DRM driver structure. This structure represent the common code for
  * a family of cards. There will one drm_device for each card present
@@ -647,9 +615,6 @@ struct drm_driver {
 	void (*set_version) (struct drm_device *dev,
 			     struct drm_set_version *sv);
=20
-	struct drm_fence_driver *fence_driver;
-	struct drm_bo_driver *bo_driver;
-
 	int major;
 	int minor;
 	int patchlevel;
@@ -724,10 +689,6 @@ struct drm_device {
 	struct list_head maplist;	/**< Linked list of regions */
 	int map_count;			/**< Number of mappable regions */
 	struct drm_open_hash map_hash;	/**< User token hash table for maps */
-	struct drm_mm offset_manager;        /**< User token manager */
-	struct drm_open_hash object_hash;    /**< User token hash table for o=
bjects */
-	struct address_space *dev_mapping;  /**< For unmap_mapping_range() */
-	struct page *ttm_dummy_page;
=20
 	/** \name Context handle management */
 	/*@{ */
@@ -804,9 +765,6 @@ struct drm_device {
 	unsigned int agp_buffer_token;
 	struct drm_head primary;		/**< primary screen head */
=20
-	struct drm_fence_manager fm;
-	struct drm_buffer_manager bm;
-
 	/** \name Drawable information */
 	/*@{ */
 	spinlock_t drw_lock;
@@ -814,15 +772,6 @@ struct drm_device {
 	/*@} */
 };
=20
-#if __OS_HAS_AGP
-struct drm_agp_ttm_backend {
-	struct drm_ttm_backend backend;
-	DRM_AGP_MEM *mem;
-	struct agp_bridge_data *bridge;
-	int populated;
-};
-#endif
-
 static __inline__ int drm_core_check_feature(struct drm_device *dev,
 					     int feature)
 {
@@ -919,15 +868,6 @@ extern int drm_free_agp(DRM_AGP_MEM * ha
 extern int drm_bind_agp(DRM_AGP_MEM * handle, unsigned int start);
 extern int drm_unbind_agp(DRM_AGP_MEM * handle);
=20
-extern void drm_free_memctl(size_t size);
-extern int drm_alloc_memctl(size_t size);
-extern void drm_query_memctl(uint64_t *cur_used,
-			     uint64_t *low_threshold,
-			     uint64_t *high_threshold);
-extern void drm_init_memctl(size_t low_threshold,
-			    size_t high_threshold,
-			    size_t unit_size);
-
 				/* Misc. IOCTL support (drm_ioctl.h) */
 extern int drm_irq_by_busid(struct drm_device *dev, void *data,
 			    struct drm_file *file_priv);
@@ -1085,8 +1025,7 @@ extern DRM_AGP_MEM *drm_agp_allocate_mem
 extern int drm_agp_free_memory(DRM_AGP_MEM * handle);
 extern int drm_agp_bind_memory(DRM_AGP_MEM * handle, off_t start);
 extern int drm_agp_unbind_memory(DRM_AGP_MEM * handle);
-extern struct drm_ttm_backend *drm_agp_init_ttm(struct drm_device *dev=
);
-extern void drm_agp_chipset_flush(struct drm_device *dev);
+
 				/* Stub support (drm_stub.h) */
 extern int drm_get_dev(struct pci_dev *pdev, const struct pci_device_i=
d *ent,
 		       struct drm_driver *driver);
@@ -1210,39 +1149,6 @@ extern void drm_free(void *pt, size_t si
 extern void *drm_calloc(size_t nmemb, size_t size, int area);
 #endif
=20
-/*
- * Accounting variants of standard calls.
- */
-
-static inline void *drm_ctl_alloc(size_t size, int area)
-{
-	void *ret;
-	if (drm_alloc_memctl(size))
-		return NULL;
-	ret =3D drm_alloc(size, area);
-	if (!ret)
-		drm_free_memctl(size);
-	return ret;
-}
-
-static inline void *drm_ctl_calloc(size_t nmemb, size_t size, int area=
)
-{
-	void *ret;
-
-	if (drm_alloc_memctl(nmemb*size))
-		return NULL;
-	ret =3D drm_calloc(nmemb, size, area);
-	if (!ret)
-		drm_free_memctl(nmemb*size);
-	return ret;
-}
-
-static inline void drm_ctl_free(void *pt, size_t size, int area)
-{
-	drm_free(pt, size, area);
-	drm_free_memctl(size);
-}
-
 /*@}*/
=20
 #endif				/* __KERNEL__ */
diff -puN drivers/char/drm/drm_agpsupport.c~revert-git-drm drivers/char=
/drm/drm_agpsupport.c
--- a/drivers/char/drm/drm_agpsupport.c~revert-git-drm
+++ a/drivers/char/drm/drm_agpsupport.c
@@ -68,6 +68,7 @@ int drm_agp_info(struct drm_device *dev,
=20
 	return 0;
 }
+
 EXPORT_SYMBOL(drm_agp_info);
=20
 int drm_agp_info_ioctl(struct drm_device *dev, void *data,
@@ -92,7 +93,7 @@ int drm_agp_info_ioctl(struct drm_device
  * Verifies the AGP device hasn't been acquired before and calls
  * \c agp_backend_acquire.
  */
-int drm_agp_acquire(struct drm_device *dev)
+int drm_agp_acquire(struct drm_device * dev)
 {
 	if (!dev->agp)
 		return -ENODEV;
@@ -103,6 +104,7 @@ int drm_agp_acquire(struct drm_device *d
 	dev->agp->acquired =3D 1;
 	return 0;
 }
+
 EXPORT_SYMBOL(drm_agp_acquire);
=20
 /**
@@ -131,7 +133,7 @@ int drm_agp_acquire_ioctl(struct drm_dev
  *
  * Verifies the AGP device has been acquired and calls \c agp_backend_=
release.
  */
-int drm_agp_release(struct drm_device *dev)
+int drm_agp_release(struct drm_device * dev)
 {
 	if (!dev->agp || !dev->agp->acquired)
 		return -EINVAL;
@@ -157,7 +159,7 @@ int drm_agp_release_ioctl(struct drm_dev
  * Verifies the AGP device has been acquired but not enabled, and call=
s
  * \c agp_enable.
  */
-int drm_agp_enable(struct drm_device *dev, struct drm_agp_mode mode)
+int drm_agp_enable(struct drm_device * dev, struct drm_agp_mode mode)
 {
 	if (!dev->agp || !dev->agp->acquired)
 		return -EINVAL;
@@ -167,6 +169,7 @@ int drm_agp_enable(struct drm_device *de
 	dev->agp->enabled =3D 1;
 	return 0;
 }
+
 EXPORT_SYMBOL(drm_agp_enable);
=20
 int drm_agp_enable_ioctl(struct drm_device *dev, void *data,
@@ -241,7 +244,7 @@ int drm_agp_alloc_ioctl(struct drm_devic
  *
  * Walks through drm_agp_head::memory until finding a matching handle.
  */
-static struct drm_agp_mem *drm_agp_lookup_entry(struct drm_device *dev=
,
+static struct drm_agp_mem *drm_agp_lookup_entry(struct drm_device * de=
v,
 					   unsigned long handle)
 {
 	struct drm_agp_mem *entry;
@@ -418,14 +421,14 @@ struct drm_agp_head *drm_agp_init(struct
 }
=20
 /** Calls agp_allocate_memory() */
-DRM_AGP_MEM *drm_agp_allocate_memory(struct agp_bridge_data *bridge,
+DRM_AGP_MEM *drm_agp_allocate_memory(struct agp_bridge_data * bridge,
 				     size_t pages, u32 type)
 {
 	return agp_allocate_memory(bridge, pages, type);
 }
=20
 /** Calls agp_free_memory() */
-int drm_agp_free_memory(DRM_AGP_MEM *handle)
+int drm_agp_free_memory(DRM_AGP_MEM * handle)
 {
 	if (!handle)
 		return 0;
@@ -434,7 +437,7 @@ int drm_agp_free_memory(DRM_AGP_MEM *han
 }
=20
 /** Calls agp_bind_memory() */
-int drm_agp_bind_memory(DRM_AGP_MEM *handle, off_t start)
+int drm_agp_bind_memory(DRM_AGP_MEM * handle, off_t start)
 {
 	if (!handle)
 		return -EINVAL;
@@ -442,188 +445,11 @@ int drm_agp_bind_memory(DRM_AGP_MEM *han
 }
=20
 /** Calls agp_unbind_memory() */
-int drm_agp_unbind_memory(DRM_AGP_MEM *handle)
+int drm_agp_unbind_memory(DRM_AGP_MEM * handle)
 {
 	if (!handle)
 		return -EINVAL;
 	return agp_unbind_memory(handle);
 }
=20
-
-/*
- * AGP ttm backend interface.
- */
-
-#ifndef AGP_USER_TYPES
-#define AGP_USER_TYPES (1 << 16)
-#define AGP_USER_MEMORY (AGP_USER_TYPES)
-#define AGP_USER_CACHED_MEMORY (AGP_USER_TYPES + 1)
-#endif
-#define AGP_REQUIRED_MAJOR 0
-#define AGP_REQUIRED_MINOR 102
-
-static int drm_agp_needs_unbind_cache_adjust(struct drm_ttm_backend *b=
ackend)
-{
-	return ((backend->flags & DRM_BE_FLAG_BOUND_CACHED) ? 0 : 1);
-}
-
-
-static int drm_agp_populate(struct drm_ttm_backend *backend,
-			    unsigned long num_pages, struct page **pages,
-			    struct page *dummy_read_page)
-{
-	struct drm_agp_ttm_backend *agp_be =3D
-		container_of(backend, struct drm_agp_ttm_backend, backend);
-	struct page **cur_page, **last_page =3D pages + num_pages;
-	DRM_AGP_MEM *mem;
-	int dummy_page_count =3D 0;
-
-	if (drm_alloc_memctl(num_pages * sizeof(void *)))
-		return -1;
-
-	DRM_DEBUG("drm_agp_populate_ttm\n");
-	mem =3D drm_agp_allocate_memory(agp_be->bridge, num_pages, AGP_USER_M=
EMORY);
-	if (!mem) {
-		drm_free_memctl(num_pages * sizeof(void *));
-		return -1;
-	}
-
-	DRM_DEBUG("Current page count is %ld\n", (long) mem->page_count);
-	mem->page_count =3D 0;
-	for (cur_page =3D pages; cur_page < last_page; ++cur_page) {
-		struct page *page =3D *cur_page;
-		if (!page) {
-			page =3D dummy_read_page;
-			++dummy_page_count;
-		}
-		mem->memory[mem->page_count++] =3D phys_to_gart(page_to_phys(page));
-	}
-	if (dummy_page_count)
-		DRM_DEBUG("Mapped %d dummy pages\n", dummy_page_count);
-	agp_be->mem =3D mem;
-	return 0;
-}
-
-static int drm_agp_bind_ttm(struct drm_ttm_backend *backend,
-			    struct drm_bo_mem_reg *bo_mem)
-{
-	struct drm_agp_ttm_backend *agp_be =3D
-		container_of(backend, struct drm_agp_ttm_backend, backend);
-	DRM_AGP_MEM *mem =3D agp_be->mem;
-	int ret;
-	int snooped =3D (bo_mem->flags & DRM_BO_FLAG_CACHED) && !(bo_mem->fla=
gs & DRM_BO_FLAG_CACHED_MAPPED);
-
-	DRM_DEBUG("drm_agp_bind_ttm\n");
-	mem->is_flushed =3D TRUE;
-	mem->type =3D AGP_USER_MEMORY;
-	/* CACHED MAPPED implies not snooped memory */
-	if (snooped)
-		mem->type =3D AGP_USER_CACHED_MEMORY;
-
-	ret =3D drm_agp_bind_memory(mem, bo_mem->mm_node->start);
-	if (ret)
-		DRM_ERROR("AGP Bind memory failed\n");
-
-	DRM_FLAG_MASKED(backend->flags, (bo_mem->flags & DRM_BO_FLAG_CACHED) =
?
-			DRM_BE_FLAG_BOUND_CACHED : 0,
-			DRM_BE_FLAG_BOUND_CACHED);
-	return ret;
-}
-
-static int drm_agp_unbind_ttm(struct drm_ttm_backend *backend)
-{
-	struct drm_agp_ttm_backend *agp_be =3D
-		container_of(backend, struct drm_agp_ttm_backend, backend);
-
-	DRM_DEBUG("drm_agp_unbind_ttm\n");
-	if (agp_be->mem->is_bound)
-		return drm_agp_unbind_memory(agp_be->mem);
-	else
-		return 0;
-}
-
-static void drm_agp_clear_ttm(struct drm_ttm_backend *backend)
-{
-	struct drm_agp_ttm_backend *agp_be =3D
-		container_of(backend, struct drm_agp_ttm_backend, backend);
-	DRM_AGP_MEM *mem =3D agp_be->mem;
-
-	DRM_DEBUG("drm_agp_clear_ttm\n");
-	if (mem) {
-		unsigned long num_pages =3D mem->page_count;
-		backend->func->unbind(backend);
-		agp_free_memory(mem);
-		drm_free_memctl(num_pages * sizeof(void *));
-	}
-	agp_be->mem =3D NULL;
-}
-
-static void drm_agp_destroy_ttm(struct drm_ttm_backend *backend)
-{
-	struct drm_agp_ttm_backend *agp_be;
-
-	if (backend) {
-		DRM_DEBUG("drm_agp_destroy_ttm\n");
-		agp_be =3D container_of(backend, struct drm_agp_ttm_backend, backend=
);
-		if (agp_be) {
-			if (agp_be->mem)
-				backend->func->clear(backend);
-			drm_ctl_free(agp_be, sizeof(*agp_be), DRM_MEM_TTM);
-		}
-	}
-}
-
-static struct drm_ttm_backend_func agp_ttm_backend =3D {
-	.needs_ub_cache_adjust =3D drm_agp_needs_unbind_cache_adjust,
-	.populate =3D drm_agp_populate,
-	.clear =3D drm_agp_clear_ttm,
-	.bind =3D drm_agp_bind_ttm,
-	.unbind =3D drm_agp_unbind_ttm,
-	.destroy =3D  drm_agp_destroy_ttm,
-};
-
-struct drm_ttm_backend *drm_agp_init_ttm(struct drm_device *dev)
-{
-	struct drm_agp_ttm_backend *agp_be;
-	struct agp_kern_info *info;
-
-	if (!dev->agp) {
-		DRM_ERROR("AGP is not initialized.\n");
-		return NULL;
-	}
-	info =3D &dev->agp->agp_info;
-
-	if (info->version.major !=3D AGP_REQUIRED_MAJOR ||
-	    info->version.minor < AGP_REQUIRED_MINOR) {
-		DRM_ERROR("Wrong agpgart version %d.%d\n"
-			  "\tYou need at least version %d.%d.\n",
-			  info->version.major,
-			  info->version.minor,
-			  AGP_REQUIRED_MAJOR,
-			  AGP_REQUIRED_MINOR);
-		return NULL;
-	}
-
-
-	agp_be =3D drm_ctl_calloc(1, sizeof(*agp_be), DRM_MEM_TTM);
-	if (!agp_be)
-		return NULL;
-
-	agp_be->mem =3D NULL;
-
-	agp_be->bridge =3D dev->agp->bridge;
-	agp_be->populated =3D FALSE;
-	agp_be->backend.func =3D &agp_ttm_backend;
-	agp_be->backend.dev =3D dev;
-
-	return &agp_be->backend;
-}
-EXPORT_SYMBOL(drm_agp_init_ttm);
-
-void drm_agp_chipset_flush(struct drm_device *dev)
-{
-	agp_flush_chipset(dev->agp->bridge);
-}
-EXPORT_SYMBOL(drm_agp_chipset_flush);
-
 #endif				/* __OS_HAS_AGP */
diff -puN drivers/char/drm/drm_auth.c~revert-git-drm drivers/char/drm/d=
rm_auth.c
--- a/drivers/char/drm/drm_auth.c~revert-git-drm
+++ a/drivers/char/drm/drm_auth.c
@@ -45,7 +45,7 @@
  * the one with matching magic number, while holding the drm_device::s=
truct_mutex
  * lock.
  */
-static struct drm_file *drm_find_file(struct drm_device *dev, drm_magi=
c_t magic)
+static struct drm_file *drm_find_file(struct drm_device * dev, drm_mag=
ic_t magic)
 {
 	struct drm_file *retval =3D NULL;
 	struct drm_magic_entry *pt;
@@ -71,7 +71,7 @@ static struct drm_file *drm_find_file(st
  * associated the magic number hash key in drm_device::magiclist, whil=
e holding
  * the drm_device::struct_mutex lock.
  */
-static int drm_add_magic(struct drm_device *dev, struct drm_file *priv=
,
+static int drm_add_magic(struct drm_device * dev, struct drm_file * pr=
iv,
 			 drm_magic_t magic)
 {
 	struct drm_magic_entry *entry;
@@ -102,7 +102,7 @@ static int drm_add_magic(struct drm_devi
  * Searches and unlinks the entry in drm_device::magiclist with the ma=
gic
  * number hash key, while holding the drm_device::struct_mutex lock.
  */
-static int drm_remove_magic(struct drm_device *dev, drm_magic_t magic)
+static int drm_remove_magic(struct drm_device * dev, drm_magic_t magic=
)
 {
 	struct drm_magic_entry *pt;
 	struct drm_hash_item *hash;
@@ -139,7 +139,7 @@ static int drm_remove_magic(struct drm_d
  */
 int drm_getmagic(struct drm_device *dev, void *data, struct drm_file *=
file_priv)
 {
-	static drm_magic_t sequence;
+	static drm_magic_t sequence =3D 0;
 	static DEFINE_SPINLOCK(lock);
 	struct drm_auth *auth =3D data;
=20
diff -puN drivers/char/drm/drm_bo.c~revert-git-drm /dev/null
--- a/drivers/char/drm/drm_bo.c
+++ /dev/null
@@ -1,2677 +0,0 @@
-/*********************************************************************=
*****
- *
- * Copyright (c) 2006-2007 Tungsten Graphics, Inc., Cedar Park, TX., U=
SA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaini=
ng a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject =
to
- * the following conditions:
- *
- * The above copyright notice and this permission notice (including th=
e
- * next paragraph) shall be included in all copies or substantial port=
ions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT =
SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR A=
NY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT =
OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE =
OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- *********************************************************************=
*****/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#include "drmP.h"
-
-/*
- * Locking may look a bit complicated but isn't really:
- *
- * The buffer usage atomic_t needs to be protected by dev->struct_mute=
x
- * when there is a chance that it can be zero before or after the oper=
ation.
- *
- * dev->struct_mutex also protects all lists and list heads,
- * Hash tables and hash heads.
- *
- * bo->mutex protects the buffer object itself excluding the usage fie=
ld.
- * bo->mutex does also protect the buffer list heads, so to manipulate=
 those,
- * we need both the bo->mutex and the dev->struct_mutex.
- *
- * Locking order is bo->mutex, dev->struct_mutex. Therefore list trave=
rsal
- * is a bit complicated. When dev->struct_mutex is released to grab bo=
->mutex,
- * the list traversal will, in general, need to be restarted.
- *
- */
-
-static void drm_bo_destroy_locked(struct drm_buffer_object *bo);
-static int drm_bo_setup_vm_locked(struct drm_buffer_object *bo);
-static void drm_bo_takedown_vm_locked(struct drm_buffer_object *bo);
-static void drm_bo_unmap_virtual(struct drm_buffer_object *bo);
-
-static inline uint64_t drm_bo_type_flags(unsigned type)
-{
-	return (1ULL << (24 + type));
-}
-
-/*
- * bo locked. dev->struct_mutex locked.
- */
-
-void drm_bo_add_to_pinned_lru(struct drm_buffer_object *bo)
-{
-	struct drm_mem_type_manager *man;
-
-	DRM_ASSERT_LOCKED(&bo->dev->struct_mutex);
-	DRM_ASSERT_LOCKED(&bo->mutex);
-
-	man =3D &bo->dev->bm.man[bo->pinned_mem_type];
-	list_add_tail(&bo->pinned_lru, &man->pinned);
-}
-
-void drm_bo_add_to_lru(struct drm_buffer_object *bo)
-{
-	struct drm_mem_type_manager *man;
-
-	DRM_ASSERT_LOCKED(&bo->dev->struct_mutex);
-
-	if (!(bo->mem.proposed_flags & (DRM_BO_FLAG_NO_MOVE | DRM_BO_FLAG_NO_=
EVICT))
-	    || bo->mem.mem_type !=3D bo->pinned_mem_type) {
-		man =3D &bo->dev->bm.man[bo->mem.mem_type];
-		list_add_tail(&bo->lru, &man->lru);
-	} else {
-		INIT_LIST_HEAD(&bo->lru);
-	}
-}
-
-static int drm_bo_vm_pre_move(struct drm_buffer_object *bo, int old_is=
_pci)
-{
-	if (!bo->map_list.map)
-		return 0;
-
-	drm_bo_unmap_virtual(bo);
-	return 0;
-}
-
-static void drm_bo_vm_post_move(struct drm_buffer_object *bo)
-{
-}
-
-/*
- * Call bo->mutex locked.
- */
-
-static int drm_bo_add_ttm(struct drm_buffer_object *bo)
-{
-	struct drm_device *dev =3D bo->dev;
-	int ret =3D 0;
-	uint32_t page_flags =3D 0;
-
-	DRM_ASSERT_LOCKED(&bo->mutex);
-	bo->ttm =3D NULL;
-
-	if (bo->mem.proposed_flags & DRM_BO_FLAG_WRITE)
-		page_flags |=3D DRM_TTM_PAGE_WRITE;
-
-	switch (bo->type) {
-	case drm_bo_type_device:
-	case drm_bo_type_kernel:
-		bo->ttm =3D drm_ttm_create(dev, bo->num_pages << PAGE_SHIFT,
-					 page_flags, dev->bm.dummy_read_page);
-		if (!bo->ttm)
-			ret =3D -ENOMEM;
-		break;
-	case drm_bo_type_user:
-		bo->ttm =3D drm_ttm_create(dev, bo->num_pages << PAGE_SHIFT,
-					 page_flags | DRM_TTM_PAGE_USER,
-					 dev->bm.dummy_read_page);
-		if (!bo->ttm)
-			ret =3D -ENOMEM;
-
-		ret =3D drm_ttm_set_user(bo->ttm, current,
-				       bo->buffer_start,
-				       bo->num_pages);
-		if (ret)
-			return ret;
-
-		break;
-	default:
-		DRM_ERROR("Illegal buffer object type\n");
-		ret =3D -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
-static int drm_bo_handle_move_mem(struct drm_buffer_object *bo,
-				  struct drm_bo_mem_reg *mem,
-				  int evict, int no_wait)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	int old_is_pci =3D drm_mem_reg_is_pci(dev, &bo->mem);
-	int new_is_pci =3D drm_mem_reg_is_pci(dev, mem);
-	struct drm_mem_type_manager *old_man =3D &bm->man[bo->mem.mem_type];
-	struct drm_mem_type_manager *new_man =3D &bm->man[mem->mem_type];
-	int ret =3D 0;
-
-	if (old_is_pci || new_is_pci ||
-	    ((mem->flags ^ bo->mem.flags) & DRM_BO_FLAG_CACHED))
-		ret =3D drm_bo_vm_pre_move(bo, old_is_pci);
-	if (ret)
-		return ret;
-
-	/*
-	 * Create and bind a ttm if required.
-	 */
-
-	if (!(new_man->flags & _DRM_FLAG_MEMTYPE_FIXED) && (bo->ttm =3D=3D NU=
LL)) {
-		ret =3D drm_bo_add_ttm(bo);
-		if (ret)
-			goto out_err;
-
-		if (mem->mem_type !=3D DRM_BO_MEM_LOCAL) {
-			ret =3D drm_ttm_bind(bo->ttm, mem);
-			if (ret)
-				goto out_err;
-		}
-	}
-
-	if ((bo->mem.mem_type =3D=3D DRM_BO_MEM_LOCAL) && bo->ttm =3D=3D NULL=
) {
-
-		struct drm_bo_mem_reg *old_mem =3D &bo->mem;
-		uint64_t save_flags =3D old_mem->flags;
-		uint64_t save_proposed_flags =3D old_mem->proposed_flags;
-
-		*old_mem =3D *mem;
-		mem->mm_node =3D NULL;
-		old_mem->proposed_flags =3D save_proposed_flags;
-		DRM_FLAG_MASKED(save_flags, mem->flags, DRM_BO_MASK_MEMTYPE);
-
-	} else if (!(old_man->flags & _DRM_FLAG_MEMTYPE_FIXED) &&
-		   !(new_man->flags & _DRM_FLAG_MEMTYPE_FIXED)) {
-
-		ret =3D drm_bo_move_ttm(bo, evict, no_wait, mem);
-
-	} else if (dev->driver->bo_driver->move) {
-		ret =3D dev->driver->bo_driver->move(bo, evict, no_wait, mem);
-
-	} else {
-
-		ret =3D drm_bo_move_memcpy(bo, evict, no_wait, mem);
-
-	}
-
-	if (ret)
-		goto out_err;
-
-	if (old_is_pci || new_is_pci)
-		drm_bo_vm_post_move(bo);
-
-	if (bo->priv_flags & _DRM_BO_FLAG_EVICTED) {
-		ret =3D
-		    dev->driver->bo_driver->invalidate_caches(dev,
-							      bo->mem.flags);
-		if (ret)
-			DRM_ERROR("Can not flush read caches\n");
-	}
-
-	DRM_FLAG_MASKED(bo->priv_flags,
-			(evict) ? _DRM_BO_FLAG_EVICTED : 0,
-			_DRM_BO_FLAG_EVICTED);
-
-	if (bo->mem.mm_node)
-		bo->offset =3D (bo->mem.mm_node->start << PAGE_SHIFT) +
-			bm->man[bo->mem.mem_type].gpu_offset;
-
-
-	return 0;
-
-out_err:
-	if (old_is_pci || new_is_pci)
-		drm_bo_vm_post_move(bo);
-
-	new_man =3D &bm->man[bo->mem.mem_type];
-	if ((new_man->flags & _DRM_FLAG_MEMTYPE_FIXED) && bo->ttm) {
-		drm_ttm_unbind(bo->ttm);
-		drm_ttm_destroy(bo->ttm);
-		bo->ttm =3D NULL;
-	}
-
-	return ret;
-}
-
-/*
- * Call bo->mutex locked.
- * Wait until the buffer is idle.
- */
-
-int drm_bo_wait(struct drm_buffer_object *bo, int lazy, int ignore_sig=
nals,
-		int no_wait)
-{
-	int ret;
-
-	DRM_ASSERT_LOCKED(&bo->mutex);
-
-	if (bo->fence) {
-		if (drm_fence_object_signaled(bo->fence, bo->fence_type)) {
-			drm_fence_usage_deref_unlocked(&bo->fence);
-			return 0;
-		}
-		if (no_wait)
-			return -EBUSY;
-
-		ret =3D drm_fence_object_wait(bo->fence, lazy, ignore_signals,
-					  bo->fence_type);
-		if (ret)
-			return ret;
-
-		drm_fence_usage_deref_unlocked(&bo->fence);
-	}
-	return 0;
-}
-EXPORT_SYMBOL(drm_bo_wait);
-
-static int drm_bo_expire_fence(struct drm_buffer_object *bo, int allow=
_errors)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-
-	if (bo->fence) {
-		if (bm->nice_mode) {
-			unsigned long _end =3D jiffies + 3 * DRM_HZ;
-			int ret;
-			do {
-				ret =3D drm_bo_wait(bo, 0, 1, 0);
-				if (ret && allow_errors)
-					return ret;
-
-			} while (ret && !time_after_eq(jiffies, _end));
-
-			if (bo->fence) {
-				bm->nice_mode =3D 0;
-				DRM_ERROR("Detected GPU lockup or "
-					  "fence driver was taken down. "
-					  "Evicting buffer.\n");
-			}
-		}
-		if (bo->fence)
-			drm_fence_usage_deref_unlocked(&bo->fence);
-	}
-	return 0;
-}
-
-/*
- * Call dev->struct_mutex locked.
- * Attempts to remove all private references to a buffer by expiring i=
ts
- * fence object and removing from lru lists and memory managers.
- */
-
-static void drm_bo_cleanup_refs(struct drm_buffer_object *bo, int remo=
ve_all)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-
-	DRM_ASSERT_LOCKED(&dev->struct_mutex);
-
-	atomic_inc(&bo->usage);
-	mutex_unlock(&dev->struct_mutex);
-	mutex_lock(&bo->mutex);
-
-	DRM_FLAG_MASKED(bo->priv_flags, 0, _DRM_BO_FLAG_UNFENCED);
-
-	if (bo->fence && drm_fence_object_signaled(bo->fence,
-						   bo->fence_type))
-		drm_fence_usage_deref_unlocked(&bo->fence);
-
-	if (bo->fence && remove_all)
-		(void)drm_bo_expire_fence(bo, 0);
-
-	mutex_lock(&dev->struct_mutex);
-
-	if (!atomic_dec_and_test(&bo->usage))
-		goto out;
-
-	if (!bo->fence) {
-		list_del_init(&bo->lru);
-		if (bo->mem.mm_node) {
-			drm_mm_put_block(bo->mem.mm_node);
-			if (bo->pinned_node =3D=3D bo->mem.mm_node)
-				bo->pinned_node =3D NULL;
-			bo->mem.mm_node =3D NULL;
-		}
-		list_del_init(&bo->pinned_lru);
-		if (bo->pinned_node) {
-			drm_mm_put_block(bo->pinned_node);
-			bo->pinned_node =3D NULL;
-		}
-		list_del_init(&bo->ddestroy);
-		mutex_unlock(&bo->mutex);
-		drm_bo_destroy_locked(bo);
-		return;
-	}
-
-	if (list_empty(&bo->ddestroy)) {
-		drm_fence_object_flush(bo->fence, bo->fence_type);
-		list_add_tail(&bo->ddestroy, &bm->ddestroy);
-		schedule_delayed_work(&bm->wq,
-				      ((DRM_HZ / 100) < 1) ? 1 : DRM_HZ / 100);
-	}
-
-out:
-	mutex_unlock(&bo->mutex);
-	return;
-}
-
-/*
- * Verify that refcount is 0 and that there are no internal references
- * to the buffer object. Then destroy it.
- */
-
-static void drm_bo_destroy_locked(struct drm_buffer_object *bo)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-
-	DRM_ASSERT_LOCKED(&dev->struct_mutex);
-
-	if (list_empty(&bo->lru) && bo->mem.mm_node =3D=3D NULL &&
-	    list_empty(&bo->pinned_lru) && bo->pinned_node =3D=3D NULL &&
-	    list_empty(&bo->ddestroy) && atomic_read(&bo->usage) =3D=3D 0) {
-		if (bo->fence !=3D NULL) {
-			DRM_ERROR("Fence was non-zero.\n");
-			drm_bo_cleanup_refs(bo, 0);
-			return;
-		}
-
-
-		if (bo->ttm) {
-			drm_ttm_unbind(bo->ttm);
-			drm_ttm_destroy(bo->ttm);
-			bo->ttm =3D NULL;
-		}
-
-		atomic_dec(&bm->count);
-
-		drm_ctl_free(bo, sizeof(*bo), DRM_MEM_BUFOBJ);
-
-		return;
-	}
-
-	/*
-	 * Some stuff is still trying to reference the buffer object.
-	 * Get rid of those references.
-	 */
-
-	drm_bo_cleanup_refs(bo, 0);
-
-	return;
-}
-
-/*
- * Call dev->struct_mutex locked.
- */
-
-static void drm_bo_delayed_delete(struct drm_device *dev, int remove_a=
ll)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-
-	struct drm_buffer_object *entry, *nentry;
-	struct list_head *list, *next;
-
-	list_for_each_safe(list, next, &bm->ddestroy) {
-		entry =3D list_entry(list, struct drm_buffer_object, ddestroy);
-
-		nentry =3D NULL;
-		if (next !=3D &bm->ddestroy) {
-			nentry =3D list_entry(next, struct drm_buffer_object,
-					    ddestroy);
-			atomic_inc(&nentry->usage);
-		}
-
-		drm_bo_cleanup_refs(entry, remove_all);
-
-		if (nentry)
-			atomic_dec(&nentry->usage);
-	}
-}
-
-static void drm_bo_delayed_workqueue(struct work_struct *work)
-{
-	struct drm_buffer_manager *bm =3D
-	    container_of(work, struct drm_buffer_manager, wq.work);
-	struct drm_device *dev =3D container_of(bm, struct drm_device, bm);
-
-	DRM_DEBUG("Delayed delete Worker\n");
-
-	mutex_lock(&dev->struct_mutex);
-	if (!bm->initialized) {
-		mutex_unlock(&dev->struct_mutex);
-		return;
-	}
-	drm_bo_delayed_delete(dev, 0);
-	if (bm->initialized && !list_empty(&bm->ddestroy)) {
-		schedule_delayed_work(&bm->wq,
-				      ((DRM_HZ / 100) < 1) ? 1 : DRM_HZ / 100);
-	}
-	mutex_unlock(&dev->struct_mutex);
-}
-
-void drm_bo_usage_deref_locked(struct drm_buffer_object **bo)
-{
-	struct drm_buffer_object *tmp_bo =3D *bo;
-	bo =3D NULL;
-
-	DRM_ASSERT_LOCKED(&tmp_bo->dev->struct_mutex);
-
-	if (atomic_dec_and_test(&tmp_bo->usage))
-		drm_bo_destroy_locked(tmp_bo);
-}
-EXPORT_SYMBOL(drm_bo_usage_deref_locked);
-
-static void drm_bo_base_deref_locked(struct drm_file *file_priv,
-				     struct drm_user_object *uo)
-{
-	struct drm_buffer_object *bo =3D
-	    drm_user_object_entry(uo, struct drm_buffer_object, base);
-
-	DRM_ASSERT_LOCKED(&bo->dev->struct_mutex);
-
-	drm_bo_takedown_vm_locked(bo);
-	drm_bo_usage_deref_locked(&bo);
-}
-
-void drm_bo_usage_deref_unlocked(struct drm_buffer_object **bo)
-{
-	struct drm_buffer_object *tmp_bo =3D *bo;
-	struct drm_device *dev =3D tmp_bo->dev;
-
-	*bo =3D NULL;
-	if (atomic_dec_and_test(&tmp_bo->usage)) {
-		mutex_lock(&dev->struct_mutex);
-		if (atomic_read(&tmp_bo->usage) =3D=3D 0)
-			drm_bo_destroy_locked(tmp_bo);
-		mutex_unlock(&dev->struct_mutex);
-	}
-}
-EXPORT_SYMBOL(drm_bo_usage_deref_unlocked);
-
-void drm_putback_buffer_objects(struct drm_device *dev)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct list_head *list =3D &bm->unfenced;
-	struct drm_buffer_object *entry, *next;
-
-	mutex_lock(&dev->struct_mutex);
-	list_for_each_entry_safe(entry, next, list, lru) {
-		atomic_inc(&entry->usage);
-		mutex_unlock(&dev->struct_mutex);
-
-		mutex_lock(&entry->mutex);
-		BUG_ON(!(entry->priv_flags & _DRM_BO_FLAG_UNFENCED));
-		mutex_lock(&dev->struct_mutex);
-
-		list_del_init(&entry->lru);
-		DRM_FLAG_MASKED(entry->priv_flags, 0, _DRM_BO_FLAG_UNFENCED);
-		wake_up_all(&entry->event_queue);
-
-		/*
-		 * FIXME: Might want to put back on head of list
-		 * instead of tail here.
-		 */
-
-		drm_bo_add_to_lru(entry);
-		mutex_unlock(&entry->mutex);
-		drm_bo_usage_deref_locked(&entry);
-	}
-	mutex_unlock(&dev->struct_mutex);
-}
-EXPORT_SYMBOL(drm_putback_buffer_objects);
-
-
-/*
- * Note. The caller has to register (if applicable)
- * and deregister fence object usage.
- */
-
-int drm_fence_buffer_objects(struct drm_device *dev,
-			     struct list_head *list,
-			     uint32_t fence_flags,
-			     struct drm_fence_object *fence,
-			     struct drm_fence_object **used_fence)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_buffer_object *entry;
-	uint32_t fence_type =3D 0;
-	uint32_t fence_class =3D ~0;
-	int count =3D 0;
-	int ret =3D 0;
-	struct list_head *l;
-
-	mutex_lock(&dev->struct_mutex);
-
-	if (!list)
-		list =3D &bm->unfenced;
-
-	if (fence)
-		fence_class =3D fence->fence_class;
-
-	list_for_each_entry(entry, list, lru) {
-		BUG_ON(!(entry->priv_flags & _DRM_BO_FLAG_UNFENCED));
-		fence_type |=3D entry->new_fence_type;
-		if (fence_class =3D=3D ~0)
-			fence_class =3D entry->new_fence_class;
-		else if (entry->new_fence_class !=3D fence_class) {
-			DRM_ERROR("Unmatching fence classes on unfenced list: "
-				  "%d and %d.\n",
-				  fence_class,
-				  entry->new_fence_class);
-			ret =3D -EINVAL;
-			goto out;
-		}
-		count++;
-	}
-
-	if (!count) {
-		ret =3D -EINVAL;
-		goto out;
-	}
-
-	if (fence) {
-		if ((fence_type & fence->type) !=3D fence_type ||
-		    (fence->fence_class !=3D fence_class)) {
-			DRM_ERROR("Given fence doesn't match buffers "
-				  "on unfenced list.\n");
-			ret =3D -EINVAL;
-			goto out;
-		}
-	} else {
-		mutex_unlock(&dev->struct_mutex);
-		ret =3D drm_fence_object_create(dev, fence_class, fence_type,
-					      fence_flags | DRM_FENCE_FLAG_EMIT,
-					      &fence);
-		mutex_lock(&dev->struct_mutex);
-		if (ret)
-			goto out;
-	}
-
-	count =3D 0;
-	l =3D list->next;
-	while (l !=3D list) {
-		prefetch(l->next);
-		entry =3D list_entry(l, struct drm_buffer_object, lru);
-		atomic_inc(&entry->usage);
-		mutex_unlock(&dev->struct_mutex);
-		mutex_lock(&entry->mutex);
-		mutex_lock(&dev->struct_mutex);
-		list_del_init(l);
-		if (entry->priv_flags & _DRM_BO_FLAG_UNFENCED) {
-			count++;
-			if (entry->fence)
-				drm_fence_usage_deref_locked(&entry->fence);
-			entry->fence =3D drm_fence_reference_locked(fence);
-			entry->fence_class =3D entry->new_fence_class;
-			entry->fence_type =3D entry->new_fence_type;
-			DRM_FLAG_MASKED(entry->priv_flags, 0,
-					_DRM_BO_FLAG_UNFENCED);
-			wake_up_all(&entry->event_queue);
-			drm_bo_add_to_lru(entry);
-		}
-		mutex_unlock(&entry->mutex);
-		drm_bo_usage_deref_locked(&entry);
-		l =3D list->next;
-	}
-	DRM_DEBUG("Fenced %d buffers\n", count);
-out:
-	mutex_unlock(&dev->struct_mutex);
-	*used_fence =3D fence;
-	return ret;
-}
-EXPORT_SYMBOL(drm_fence_buffer_objects);
-
-/*
- * bo->mutex locked
- */
-
-static int drm_bo_evict(struct drm_buffer_object *bo, unsigned mem_typ=
e,
-			int no_wait)
-{
-	int ret =3D 0;
-	struct drm_device *dev =3D bo->dev;
-	struct drm_bo_mem_reg evict_mem;
-
-	/*
-	 * Someone might have modified the buffer before we took the
-	 * buffer mutex.
-	 */
-
-	if (bo->priv_flags & _DRM_BO_FLAG_UNFENCED)
-		goto out;
-	if (bo->mem.mem_type !=3D mem_type)
-		goto out;
-
-	ret =3D drm_bo_wait(bo, 0, 0, no_wait);
-
-	if (ret && ret !=3D -EAGAIN) {
-		DRM_ERROR("Failed to expire fence before "
-			  "buffer eviction.\n");
-		goto out;
-	}
-
-	evict_mem =3D bo->mem;
-	evict_mem.mm_node =3D NULL;
-
-	evict_mem =3D bo->mem;
-	evict_mem.proposed_flags =3D dev->driver->bo_driver->evict_flags(bo);
-	ret =3D drm_bo_mem_space(bo, &evict_mem, no_wait);
-
-	if (ret) {
-		if (ret !=3D -EAGAIN)
-			DRM_ERROR("Failed to find memory space for "
-				  "buffer 0x%p eviction.\n", bo);
-		goto out;
-	}
-
-	ret =3D drm_bo_handle_move_mem(bo, &evict_mem, 1, no_wait);
-
-	if (ret) {
-		if (ret !=3D -EAGAIN)
-			DRM_ERROR("Buffer eviction failed\n");
-		goto out;
-	}
-
-	mutex_lock(&dev->struct_mutex);
-	if (evict_mem.mm_node) {
-		if (evict_mem.mm_node !=3D bo->pinned_node)
-			drm_mm_put_block(evict_mem.mm_node);
-		evict_mem.mm_node =3D NULL;
-	}
-	list_del(&bo->lru);
-	drm_bo_add_to_lru(bo);
-	mutex_unlock(&dev->struct_mutex);
-
-	DRM_FLAG_MASKED(bo->priv_flags, _DRM_BO_FLAG_EVICTED,
-			_DRM_BO_FLAG_EVICTED);
-
-out:
-	return ret;
-}
-
-/**
- * Repeatedly evict memory from the LRU for @mem_type until we create =
enough
- * space, or we've evicted everything and there isn't enough space.
- */
-static int drm_bo_mem_force_space(struct drm_device *dev,
-				  struct drm_bo_mem_reg *mem,
-				  uint32_t mem_type, int no_wait)
-{
-	struct drm_mm_node *node;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_buffer_object *entry;
-	struct drm_mem_type_manager *man =3D &bm->man[mem_type];
-	struct list_head *lru;
-	unsigned long num_pages =3D mem->num_pages;
-	int ret;
-
-	mutex_lock(&dev->struct_mutex);
-	do {
-		node =3D drm_mm_search_free(&man->manager, num_pages,
-					  mem->page_alignment, 1);
-		if (node)
-			break;
-
-		lru =3D &man->lru;
-		if (lru->next =3D=3D lru)
-			break;
-
-		entry =3D list_entry(lru->next, struct drm_buffer_object, lru);
-		atomic_inc(&entry->usage);
-		mutex_unlock(&dev->struct_mutex);
-		mutex_lock(&entry->mutex);
-		BUG_ON(entry->mem.flags & (DRM_BO_FLAG_NO_MOVE | DRM_BO_FLAG_NO_EVIC=
T));
-
-		ret =3D drm_bo_evict(entry, mem_type, no_wait);
-		mutex_unlock(&entry->mutex);
-		drm_bo_usage_deref_unlocked(&entry);
-		if (ret)
-			return ret;
-		mutex_lock(&dev->struct_mutex);
-	} while (1);
-
-	if (!node) {
-		mutex_unlock(&dev->struct_mutex);
-		return -ENOMEM;
-	}
-
-	node =3D drm_mm_get_block(node, num_pages, mem->page_alignment);
-	mutex_unlock(&dev->struct_mutex);
-	mem->mm_node =3D node;
-	mem->mem_type =3D mem_type;
-	return 0;
-}
-
-static int drm_bo_mt_compatible(struct drm_mem_type_manager *man,
-				int disallow_fixed,
-				uint32_t mem_type,
-				uint64_t mask, uint32_t *res_mask)
-{
-	uint64_t cur_flags =3D drm_bo_type_flags(mem_type);
-	uint64_t flag_diff;
-
-	if ((man->flags & _DRM_FLAG_MEMTYPE_FIXED) && disallow_fixed)
-		return 0;
-	if (man->flags & _DRM_FLAG_MEMTYPE_CACHED)
-		cur_flags |=3D DRM_BO_FLAG_CACHED;
-	if (man->flags & _DRM_FLAG_MEMTYPE_MAPPABLE)
-		cur_flags |=3D DRM_BO_FLAG_MAPPABLE;
-	if (man->flags & _DRM_FLAG_MEMTYPE_CSELECT)
-		DRM_FLAG_MASKED(cur_flags, mask, DRM_BO_FLAG_CACHED);
-
-	if ((cur_flags & mask & DRM_BO_MASK_MEM) =3D=3D 0)
-		return 0;
-
-	if (mem_type =3D=3D DRM_BO_MEM_LOCAL) {
-		*res_mask =3D cur_flags;
-		return 1;
-	}
-
-	flag_diff =3D (mask ^ cur_flags);
-	if (flag_diff & DRM_BO_FLAG_CACHED_MAPPED)
-		cur_flags |=3D DRM_BO_FLAG_CACHED_MAPPED;
-
-	if ((flag_diff & DRM_BO_FLAG_CACHED) &&
-	    (!(mask & DRM_BO_FLAG_CACHED) ||
-	     (mask & DRM_BO_FLAG_FORCE_CACHING)))
-		return 0;
-
-	if ((flag_diff & DRM_BO_FLAG_MAPPABLE) &&
-	    ((mask & DRM_BO_FLAG_MAPPABLE) ||
-	     (mask & DRM_BO_FLAG_FORCE_MAPPABLE)))
-		return 0;
-
-	*res_mask =3D cur_flags;
-	return 1;
-}
-
-/**
- * Creates space for memory region @mem according to its type.
- *
- * This function first searches for free space in compatible memory ty=
pes in
- * the priority order defined by the driver.  If free space isn't foun=
d, then
- * drm_bo_mem_force_space is attempted in priority order to evict and =
find
- * space.
- */
-int drm_bo_mem_space(struct drm_buffer_object *bo,
-		     struct drm_bo_mem_reg *mem, int no_wait)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_mem_type_manager *man;
-
-	uint32_t num_prios =3D dev->driver->bo_driver->num_mem_type_prio;
-	const uint32_t *prios =3D dev->driver->bo_driver->mem_type_prio;
-	uint32_t i;
-	uint32_t mem_type =3D DRM_BO_MEM_LOCAL;
-	uint32_t cur_flags;
-	int type_found =3D 0;
-	int type_ok =3D 0;
-	int has_eagain =3D 0;
-	struct drm_mm_node *node =3D NULL;
-	int ret;
-
-	mem->mm_node =3D NULL;
-	for (i =3D 0; i < num_prios; ++i) {
-		mem_type =3D prios[i];
-		man =3D &bm->man[mem_type];
-
-		type_ok =3D drm_bo_mt_compatible(man,
-					       bo->type =3D=3D drm_bo_type_user,
-					       mem_type, mem->proposed_flags,
-					       &cur_flags);
-
-		if (!type_ok)
-			continue;
-
-		if (mem_type =3D=3D DRM_BO_MEM_LOCAL)
-			break;
-
-		if ((mem_type =3D=3D bo->pinned_mem_type) &&
-		    (bo->pinned_node !=3D NULL)) {
-			node =3D bo->pinned_node;
-			break;
-		}
-
-		mutex_lock(&dev->struct_mutex);
-		if (man->has_type && man->use_type) {
-			type_found =3D 1;
-			node =3D drm_mm_search_free(&man->manager, mem->num_pages,
-						  mem->page_alignment, 1);
-			if (node)
-				node =3D drm_mm_get_block(node, mem->num_pages,
-							mem->page_alignment);
-		}
-		mutex_unlock(&dev->struct_mutex);
-		if (node)
-			break;
-	}
-
-	if ((type_ok && (mem_type =3D=3D DRM_BO_MEM_LOCAL)) || node) {
-		mem->mm_node =3D node;
-		mem->mem_type =3D mem_type;
-		mem->flags =3D cur_flags;
-		return 0;
-	}
-
-	if (!type_found)
-		return -EINVAL;
-
-	num_prios =3D dev->driver->bo_driver->num_mem_busy_prio;
-	prios =3D dev->driver->bo_driver->mem_busy_prio;
-
-	for (i =3D 0; i < num_prios; ++i) {
-		mem_type =3D prios[i];
-		man =3D &bm->man[mem_type];
-
-		if (!man->has_type)
-			continue;
-
-		if (!drm_bo_mt_compatible(man,
-					  bo->type =3D=3D drm_bo_type_user,
-					  mem_type,
-					  mem->proposed_flags,
-					  &cur_flags))
-			continue;
-
-		ret =3D drm_bo_mem_force_space(dev, mem, mem_type, no_wait);
-
-		if (ret =3D=3D 0 && mem->mm_node) {
-			mem->flags =3D cur_flags;
-			return 0;
-		}
-
-		if (ret =3D=3D -EAGAIN)
-			has_eagain =3D 1;
-	}
-
-	ret =3D (has_eagain) ? -EAGAIN : -ENOMEM;
-	return ret;
-}
-EXPORT_SYMBOL(drm_bo_mem_space);
-
-/*
- * drm_bo_propose_flags:
- *
- * @bo: the buffer object getting new flags
- *
- * @new_flags: the new set of proposed flag bits
- *
- * @new_mask: the mask of bits changed in new_flags
- *
- * Modify the proposed_flag bits in @bo
- */
-static int drm_bo_modify_proposed_flags(struct drm_buffer_object *bo,
-					uint64_t new_flags, uint64_t new_mask)
-{
-	uint32_t new_access;
-
-	/* Copy unchanging bits from existing proposed_flags */
-	DRM_FLAG_MASKED(new_flags, bo->mem.proposed_flags, ~new_mask);
-
-	if (bo->type =3D=3D drm_bo_type_user &&
-	    ((new_flags & (DRM_BO_FLAG_CACHED | DRM_BO_FLAG_FORCE_CACHING)) !=
=3D
-	     (DRM_BO_FLAG_CACHED | DRM_BO_FLAG_FORCE_CACHING))) {
-		DRM_ERROR("User buffers require cache-coherent memory.\n");
-		return -EINVAL;
-	}
-
-	if ((new_mask & DRM_BO_FLAG_NO_EVICT) && !DRM_SUSER(DRM_CURPROC)) {
-		DRM_ERROR("DRM_BO_FLAG_NO_EVICT is only available to priviliged proc=
esses.\n");
-		return -EPERM;
-	}
-
-	if ((new_flags & DRM_BO_FLAG_NO_MOVE)) {
-		DRM_ERROR("DRM_BO_FLAG_NO_MOVE is not properly implemented yet.\n");
-		return -EPERM;
-	}
-
-	new_access =3D new_flags & (DRM_BO_FLAG_EXE | DRM_BO_FLAG_WRITE |
-				  DRM_BO_FLAG_READ);
-
-	if (new_access =3D=3D 0) {
-		DRM_ERROR("Invalid buffer object rwx properties\n");
-		return -EINVAL;
-	}
-
-	bo->mem.proposed_flags =3D new_flags;
-	return 0;
-}
-
-/*
- * Call dev->struct_mutex locked.
- */
-
-struct drm_buffer_object *drm_lookup_buffer_object(struct drm_file *fi=
le_priv,
-					      uint32_t handle, int check_owner)
-{
-	struct drm_user_object *uo;
-	struct drm_buffer_object *bo;
-
-	uo =3D drm_lookup_user_object(file_priv, handle);
-
-	if (!uo || (uo->type !=3D drm_buffer_type)) {
-		DRM_ERROR("Could not find buffer object 0x%08x\n", handle);
-		return NULL;
-	}
-
-	if (check_owner && file_priv !=3D uo->owner) {
-		if (!drm_lookup_ref_object(file_priv, uo, _DRM_REF_USE))
-			return NULL;
-	}
-
-	bo =3D drm_user_object_entry(uo, struct drm_buffer_object, base);
-	atomic_inc(&bo->usage);
-	return bo;
-}
-EXPORT_SYMBOL(drm_lookup_buffer_object);
-
-/*
- * Call bo->mutex locked.
- * Returns 1 if the buffer is currently rendered to or from. 0 otherwi=
se.
- * Doesn't do any fence flushing as opposed to the drm_bo_busy functio=
n.
- */
-
-static int drm_bo_quick_busy(struct drm_buffer_object *bo)
-{
-	struct drm_fence_object *fence =3D bo->fence;
-
-	BUG_ON(bo->priv_flags & _DRM_BO_FLAG_UNFENCED);
-	if (fence) {
-		if (drm_fence_object_signaled(fence, bo->fence_type)) {
-			drm_fence_usage_deref_unlocked(&bo->fence);
-			return 0;
-		}
-		return 1;
-	}
-	return 0;
-}
-
-/*
- * Call bo->mutex locked.
- * Returns 1 if the buffer is currently rendered to or from. 0 otherwi=
se.
- */
-
-static int drm_bo_busy(struct drm_buffer_object *bo)
-{
-	struct drm_fence_object *fence =3D bo->fence;
-
-	BUG_ON(bo->priv_flags & _DRM_BO_FLAG_UNFENCED);
-	if (fence) {
-		if (drm_fence_object_signaled(fence, bo->fence_type)) {
-			drm_fence_usage_deref_unlocked(&bo->fence);
-			return 0;
-		}
-		drm_fence_object_flush(fence, DRM_FENCE_TYPE_EXE);
-		if (drm_fence_object_signaled(fence, bo->fence_type)) {
-			drm_fence_usage_deref_unlocked(&bo->fence);
-			return 0;
-		}
-		return 1;
-	}
-	return 0;
-}
-
-static int drm_bo_evict_cached(struct drm_buffer_object *bo)
-{
-	int ret =3D 0;
-
-	BUG_ON(bo->priv_flags & _DRM_BO_FLAG_UNFENCED);
-	if (bo->mem.mm_node)
-		ret =3D drm_bo_evict(bo, DRM_BO_MEM_TT, 1);
-	return ret;
-}
-
-/*
- * Wait until a buffer is unmapped.
- */
-
-static int drm_bo_wait_unmapped(struct drm_buffer_object *bo, int no_w=
ait)
-{
-	int ret =3D 0;
-
-	if ((atomic_read(&bo->mapped) >=3D 0) && no_wait)
-		return -EBUSY;
-
-	DRM_WAIT_ON(ret, bo->event_queue, 3 * DRM_HZ,
-		    atomic_read(&bo->mapped) =3D=3D -1);
-
-	if (ret =3D=3D -EINTR)
-		ret =3D -EAGAIN;
-
-	return ret;
-}
-
-static int drm_bo_check_unfenced(struct drm_buffer_object *bo)
-{
-	int ret;
-
-	mutex_lock(&bo->mutex);
-	ret =3D (bo->priv_flags & _DRM_BO_FLAG_UNFENCED);
-	mutex_unlock(&bo->mutex);
-	return ret;
-}
-
-/*
- * Wait until a buffer, scheduled to be fenced moves off the unfenced =
list.
- * Until then, we cannot really do anything with it except delete it.
- */
-
-static int drm_bo_wait_unfenced(struct drm_buffer_object *bo, int no_w=
ait,
-				int eagain_if_wait)
-{
-	int ret =3D (bo->priv_flags & _DRM_BO_FLAG_UNFENCED);
-
-	if (ret && no_wait)
-		return -EBUSY;
-	else if (!ret)
-		return 0;
-
-	ret =3D 0;
-	mutex_unlock(&bo->mutex);
-	DRM_WAIT_ON(ret, bo->event_queue, 3 * DRM_HZ,
-		    !drm_bo_check_unfenced(bo));
-	mutex_lock(&bo->mutex);
-	if (ret =3D=3D -EINTR)
-		return -EAGAIN;
-	ret =3D (bo->priv_flags & _DRM_BO_FLAG_UNFENCED);
-	if (ret) {
-		DRM_ERROR("Timeout waiting for buffer to become fenced\n");
-		return -EBUSY;
-	}
-	if (eagain_if_wait)
-		return -EAGAIN;
-
-	return 0;
-}
-
-/*
- * Fill in the ioctl reply argument with buffer info.
- * Bo locked.
- */
-
-static void drm_bo_fill_rep_arg(struct drm_buffer_object *bo,
-				struct drm_bo_info_rep *rep)
-{
-	if (!rep)
-		return;
-
-	rep->handle =3D bo->base.hash.key;
-	rep->flags =3D bo->mem.flags;
-	rep->size =3D bo->num_pages * PAGE_SIZE;
-	rep->offset =3D bo->offset;
-
-	/*
-	 * drm_bo_type_device buffers have user-visible
-	 * handles which can be used to share across
-	 * processes. Hand that back to the application
-	 */
-	if (bo->type =3D=3D drm_bo_type_device)
-		rep->arg_handle =3D bo->map_list.user_token;
-	else
-		rep->arg_handle =3D 0;
-
-	rep->proposed_flags =3D bo->mem.proposed_flags;
-	rep->buffer_start =3D bo->buffer_start;
-	rep->fence_flags =3D bo->fence_type;
-	rep->rep_flags =3D 0;
-	rep->page_alignment =3D bo->mem.page_alignment;
-
-	if ((bo->priv_flags & _DRM_BO_FLAG_UNFENCED) || drm_bo_quick_busy(bo)=
) {
-		DRM_FLAG_MASKED(rep->rep_flags, DRM_BO_REP_BUSY,
-				DRM_BO_REP_BUSY);
-	}
-}
-
-/*
- * Wait for buffer idle and register that we've mapped the buffer.
- * Mapping is registered as a drm_ref_object with type _DRM_REF_TYPE1,
- * so that if the client dies, the mapping is automatically
- * unregistered.
- */
-
-static int drm_buffer_object_map(struct drm_file *file_priv, uint32_t =
handle,
-				 uint32_t map_flags, unsigned hint,
-				 struct drm_bo_info_rep *rep)
-{
-	struct drm_buffer_object *bo;
-	struct drm_device *dev =3D file_priv->head->dev;
-	int ret =3D 0;
-	int no_wait =3D hint & DRM_BO_HINT_DONT_BLOCK;
-
-	mutex_lock(&dev->struct_mutex);
-	bo =3D drm_lookup_buffer_object(file_priv, handle, 1);
-	mutex_unlock(&dev->struct_mutex);
-
-	if (!bo)
-		return -EINVAL;
-
-	mutex_lock(&bo->mutex);
-	ret =3D drm_bo_wait_unfenced(bo, no_wait, 0);
-	if (ret)
-		goto out;
-
-	/*
-	 * If this returns true, we are currently unmapped.
-	 * We need to do this test, because unmapping can
-	 * be done without the bo->mutex held.
-	 */
-
-	while (1) {
-		if (atomic_inc_and_test(&bo->mapped)) {
-			if (no_wait && drm_bo_busy(bo)) {
-				atomic_dec(&bo->mapped);
-				ret =3D -EBUSY;
-				goto out;
-			}
-			ret =3D drm_bo_wait(bo, 0, 0, no_wait);
-			if (ret) {
-				atomic_dec(&bo->mapped);
-				goto out;
-			}
-
-			if (bo->mem.flags & DRM_BO_FLAG_CACHED_MAPPED)
-				drm_bo_evict_cached(bo);
-
-			break;
-		} else if (bo->mem.flags & DRM_BO_FLAG_CACHED_MAPPED) {
-
-			/*
-			 * We are already mapped with different flags.
-			 * need to wait for unmap.
-			 */
-
-			ret =3D drm_bo_wait_unmapped(bo, no_wait);
-			if (ret)
-				goto out;
-
-			continue;
-		}
-		break;
-	}
-
-	mutex_lock(&dev->struct_mutex);
-	ret =3D drm_add_ref_object(file_priv, &bo->base, _DRM_REF_TYPE1);
-	mutex_unlock(&dev->struct_mutex);
-	if (ret) {
-		if (atomic_add_negative(-1, &bo->mapped))
-			wake_up_all(&bo->event_queue);
-
-	} else
-		drm_bo_fill_rep_arg(bo, rep);
-out:
-	mutex_unlock(&bo->mutex);
-	drm_bo_usage_deref_unlocked(&bo);
-	return ret;
-}
-
-static int drm_buffer_object_unmap(struct drm_file *file_priv, uint32_=
t handle)
-{
-	struct drm_device *dev =3D file_priv->head->dev;
-	struct drm_buffer_object *bo;
-	struct drm_ref_object *ro;
-	int ret =3D 0;
-
-	mutex_lock(&dev->struct_mutex);
-
-	bo =3D drm_lookup_buffer_object(file_priv, handle, 1);
-	if (!bo) {
-		ret =3D -EINVAL;
-		goto out;
-	}
-
-	ro =3D drm_lookup_ref_object(file_priv, &bo->base, _DRM_REF_TYPE1);
-	if (!ro) {
-		ret =3D -EINVAL;
-		goto out;
-	}
-
-	drm_remove_ref_object(file_priv, ro);
-	drm_bo_usage_deref_locked(&bo);
-out:
-	mutex_unlock(&dev->struct_mutex);
-	return ret;
-}
-
-/*
- * Call struct-sem locked.
- */
-
-static void drm_buffer_user_object_unmap(struct drm_file *file_priv,
-					 struct drm_user_object *uo,
-					 enum drm_ref_type action)
-{
-	struct drm_buffer_object *bo =3D
-	    drm_user_object_entry(uo, struct drm_buffer_object, base);
-
-	/*
-	 * We DON'T want to take the bo->lock here, because we want to
-	 * hold it when we wait for unmapped buffer.
-	 */
-
-	BUG_ON(action !=3D _DRM_REF_TYPE1);
-
-	if (atomic_add_negative(-1, &bo->mapped))
-		wake_up_all(&bo->event_queue);
-}
-
-/*
- * bo->mutex locked.
- * Note that new_mem_flags are NOT transferred to the bo->mem.proposed=
_flags.
- */
-
-int drm_bo_move_buffer(struct drm_buffer_object *bo, uint64_t new_mem_=
flags,
-		       int no_wait, int move_unfenced)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	int ret =3D 0;
-	struct drm_bo_mem_reg mem;
-	/*
-	 * Flush outstanding fences.
-	 */
-
-	drm_bo_busy(bo);
-
-	/*
-	 * Wait for outstanding fences.
-	 */
-
-	ret =3D drm_bo_wait(bo, 0, 0, no_wait);
-	if (ret)
-		return ret;
-
-	mem.num_pages =3D bo->num_pages;
-	mem.size =3D mem.num_pages << PAGE_SHIFT;
-	mem.proposed_flags =3D new_mem_flags;
-	mem.page_alignment =3D bo->mem.page_alignment;
-
-	mutex_lock(&bm->evict_mutex);
-	mutex_lock(&dev->struct_mutex);
-	list_del_init(&bo->lru);
-	mutex_unlock(&dev->struct_mutex);
-
-	/*
-	 * Determine where to move the buffer.
-	 */
-	ret =3D drm_bo_mem_space(bo, &mem, no_wait);
-	if (ret)
-		goto out_unlock;
-
-	ret =3D drm_bo_handle_move_mem(bo, &mem, 0, no_wait);
-
-out_unlock:
-	mutex_lock(&dev->struct_mutex);
-	if (ret || !move_unfenced) {
-		if (mem.mm_node) {
-			if (mem.mm_node !=3D bo->pinned_node)
-				drm_mm_put_block(mem.mm_node);
-			mem.mm_node =3D NULL;
-		}
-		drm_bo_add_to_lru(bo);
-		if (bo->priv_flags & _DRM_BO_FLAG_UNFENCED) {
-			wake_up_all(&bo->event_queue);
-			DRM_FLAG_MASKED(bo->priv_flags, 0,
-					_DRM_BO_FLAG_UNFENCED);
-		}
-	} else {
-		list_add_tail(&bo->lru, &bm->unfenced);
-		DRM_FLAG_MASKED(bo->priv_flags, _DRM_BO_FLAG_UNFENCED,
-				_DRM_BO_FLAG_UNFENCED);
-	}
-	mutex_unlock(&dev->struct_mutex);
-	mutex_unlock(&bm->evict_mutex);
-	return ret;
-}
-
-static int drm_bo_mem_compat(struct drm_bo_mem_reg *mem)
-{
-	uint32_t flag_diff =3D (mem->proposed_flags ^ mem->flags);
-
-	if ((mem->proposed_flags & mem->flags & DRM_BO_MASK_MEM) =3D=3D 0)
-		return 0;
-	if ((flag_diff & DRM_BO_FLAG_CACHED) &&
-	    (/* !(mem->proposed_flags & DRM_BO_FLAG_CACHED) ||*/
-	     (mem->proposed_flags & DRM_BO_FLAG_FORCE_CACHING)))
-		return 0;
-
-	if ((flag_diff & DRM_BO_FLAG_MAPPABLE) &&
-	    ((mem->proposed_flags & DRM_BO_FLAG_MAPPABLE) ||
-	     (mem->proposed_flags & DRM_BO_FLAG_FORCE_MAPPABLE)))
-		return 0;
-	return 1;
-}
-
-/**
- * drm_buffer_object_validate:
- *
- * @bo: the buffer object to modify
- *
- * @fence_class: the new fence class covering this buffer
- *
- * @move_unfenced: a boolean indicating whether switching the
- * memory space of this buffer should cause the buffer to
- * be placed on the unfenced list.
- *
- * @no_wait: whether this function should return -EBUSY instead
- * of waiting.
- *
- * Change buffer access parameters. This can involve moving
- * the buffer to the correct memory type, pinning the buffer
- * or changing the class/type of fence covering this buffer
- *
- * Must be called with bo locked.
- */
-
-static int drm_buffer_object_validate(struct drm_buffer_object *bo,
-				      uint32_t fence_class,
-				      int move_unfenced, int no_wait)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_bo_driver *driver =3D dev->driver->bo_driver;
-	uint32_t ftype;
-	int ret;
-
-	DRM_DEBUG("Proposed flags 0x%016llx, Old flags 0x%016llx\n",
-		  (unsigned long long) bo->mem.proposed_flags,
-		  (unsigned long long) bo->mem.flags);
-
-	ret =3D driver->fence_type(bo, &fence_class, &ftype);
-
-	if (ret) {
-		DRM_ERROR("Driver did not support given buffer permissions\n");
-		return ret;
-	}
-
-	/*
-	 * We're switching command submission mechanism,
-	 * or cannot simply rely on the hardware serializing for us.
-	 *
-	 * Insert a driver-dependant barrier or wait for buffer idle.
-	 */
-
-	if ((fence_class !=3D bo->fence_class) ||
-	    ((ftype ^ bo->fence_type) & bo->fence_type)) {
-
-		ret =3D -EINVAL;
-		if (driver->command_stream_barrier) {
-			ret =3D driver->command_stream_barrier(bo,
-							     fence_class,
-							     ftype,
-							     no_wait);
-		}
-		if (ret)
-			ret =3D drm_bo_wait(bo, 0, 0, no_wait);
-
-		if (ret)
-			return ret;
-
-	}
-
-	bo->new_fence_class =3D fence_class;
-	bo->new_fence_type =3D ftype;
-
-	ret =3D drm_bo_wait_unmapped(bo, no_wait);
-	if (ret) {
-		DRM_ERROR("Timed out waiting for buffer unmap.\n");
-		return ret;
-	}
-
-	/*
-	 * Check whether we need to move buffer.
-	 */
-
-	if (!drm_bo_mem_compat(&bo->mem)) {
-		ret =3D drm_bo_move_buffer(bo, bo->mem.proposed_flags, no_wait,
-					 move_unfenced);
-		if (ret) {
-			if (ret !=3D -EAGAIN)
-				DRM_ERROR("Failed moving buffer.\n");
-			return ret;
-		}
-	}
-
-	/*
-	 * Pinned buffers.
-	 */
-
-	if (bo->mem.proposed_flags & (DRM_BO_FLAG_NO_EVICT | DRM_BO_FLAG_NO_M=
OVE)) {
-		bo->pinned_mem_type =3D bo->mem.mem_type;
-		mutex_lock(&dev->struct_mutex);
-		list_del_init(&bo->pinned_lru);
-		drm_bo_add_to_pinned_lru(bo);
-
-		if (bo->pinned_node !=3D bo->mem.mm_node) {
-			if (bo->pinned_node !=3D NULL)
-				drm_mm_put_block(bo->pinned_node);
-			bo->pinned_node =3D bo->mem.mm_node;
-		}
-
-		mutex_unlock(&dev->struct_mutex);
-
-	} else if (bo->pinned_node !=3D NULL) {
-
-		mutex_lock(&dev->struct_mutex);
-
-		if (bo->pinned_node !=3D bo->mem.mm_node)
-			drm_mm_put_block(bo->pinned_node);
-
-		list_del_init(&bo->pinned_lru);
-		bo->pinned_node =3D NULL;
-		mutex_unlock(&dev->struct_mutex);
-
-	}
-
-	/*
-	 * We might need to add a TTM.
-	 */
-
-	if (bo->mem.mem_type =3D=3D DRM_BO_MEM_LOCAL && bo->ttm =3D=3D NULL) =
{
-		ret =3D drm_bo_add_ttm(bo);
-		if (ret)
-			return ret;
-	}
-	/*
-	 * Validation has succeeded, move the access and other
-	 * non-mapping-related flag bits from the proposed flags to
-	 * the active flags
-	 */
-
-	DRM_FLAG_MASKED(bo->mem.flags, bo->mem.proposed_flags, ~DRM_BO_MASK_M=
EMTYPE);
-
-	/*
-	 * Finally, adjust lru to be sure.
-	 */
-
-	mutex_lock(&dev->struct_mutex);
-	list_del(&bo->lru);
-	if (move_unfenced) {
-		list_add_tail(&bo->lru, &bm->unfenced);
-		DRM_FLAG_MASKED(bo->priv_flags, _DRM_BO_FLAG_UNFENCED,
-				_DRM_BO_FLAG_UNFENCED);
-	} else {
-		drm_bo_add_to_lru(bo);
-		if (bo->priv_flags & _DRM_BO_FLAG_UNFENCED) {
-			wake_up_all(&bo->event_queue);
-			DRM_FLAG_MASKED(bo->priv_flags, 0,
-					_DRM_BO_FLAG_UNFENCED);
-		}
-	}
-	mutex_unlock(&dev->struct_mutex);
-
-	return 0;
-}
-
-/**
- * drm_bo_do_validate:
- *
- * @bo:	the buffer object
- *
- * @flags: access rights, mapping parameters and cacheability. See
- * the DRM_BO_FLAG_* values in drm.h
- *
- * @mask: Which flag values to change; this allows callers to modify
- * things without knowing the current state of other flags.
- *
- * @hint: changes the proceedure for this operation, see the DRM_BO_HI=
NT_*
- * values in drm.h.
- *
- * @fence_class: a driver-specific way of doing fences. Presumably,
- * this would be used if the driver had more than one submission and
- * fencing mechanism. At this point, there isn't any use of this
- * from the user mode code.
- *
- * @rep: To be stuffed with the reply from validation
- *
- * 'validate' a buffer object. This changes where the buffer is
- * located, along with changing access modes.
- */
-
-int drm_bo_do_validate(struct drm_buffer_object *bo,
-		       uint64_t flags, uint64_t mask, uint32_t hint,
-		       uint32_t fence_class,
-		       struct drm_bo_info_rep *rep)
-{
-	int ret;
-	int no_wait =3D (hint & DRM_BO_HINT_DONT_BLOCK) !=3D 0;
-
-	mutex_lock(&bo->mutex);
-	ret =3D drm_bo_wait_unfenced(bo, no_wait, 0);
-
-	if (ret)
-		goto out;
-
-	ret =3D drm_bo_modify_proposed_flags (bo, flags, mask);
-	if (ret)
-		goto out;
-
-	ret =3D drm_buffer_object_validate(bo,
-					 fence_class,
-					 !(hint & DRM_BO_HINT_DONT_FENCE),
-					 no_wait);
-out:
-	if (rep)
-		drm_bo_fill_rep_arg(bo, rep);
-
-	mutex_unlock(&bo->mutex);
-	return ret;
-}
-EXPORT_SYMBOL(drm_bo_do_validate);
-
-/**
- * drm_bo_handle_validate
- *
- * @file_priv: the drm file private, used to get a handle to the user =
context
- *
- * @handle: the buffer object handle
- *
- * @flags: access rights, mapping parameters and cacheability. See
- * the DRM_BO_FLAG_* values in drm.h
- *
- * @mask: Which flag values to change; this allows callers to modify
- * things without knowing the current state of other flags.
- *
- * @hint: changes the proceedure for this operation, see the DRM_BO_HI=
NT_*
- * values in drm.h.
- *
- * @fence_class: a driver-specific way of doing fences. Presumably,
- * this would be used if the driver had more than one submission and
- * fencing mechanism. At this point, there isn't any use of this
- * from the user mode code.
- *
- * @use_old_fence_class: don't change fence class, pull it from the bu=
ffer object
- *
- * @rep: To be stuffed with the reply from validation
- *
- * @bp_rep: To be stuffed with the buffer object pointer
- *
- * Perform drm_bo_do_validate on a buffer referenced by a user-space h=
andle.
- * Some permissions checking is done on the parameters, otherwise this
- * is a thin wrapper.
- */
-
-int drm_bo_handle_validate(struct drm_file *file_priv, uint32_t handle=
,
-			   uint64_t flags, uint64_t mask,
-			   uint32_t hint,
-			   uint32_t fence_class,
-			   int use_old_fence_class,
-			   struct drm_bo_info_rep *rep,
-			   struct drm_buffer_object **bo_rep)
-{
-	struct drm_device *dev =3D file_priv->head->dev;
-	struct drm_buffer_object *bo;
-	int ret;
-
-	mutex_lock(&dev->struct_mutex);
-	bo =3D drm_lookup_buffer_object(file_priv, handle, 1);
-	mutex_unlock(&dev->struct_mutex);
-
-	if (!bo)
-		return -EINVAL;
-
-	if (use_old_fence_class)
-		fence_class =3D bo->fence_class;
-
-	/*
-	 * Only allow creator to change shared buffer mask.
-	 */
-
-	if (bo->base.owner !=3D file_priv)
-		mask &=3D ~(DRM_BO_FLAG_NO_EVICT | DRM_BO_FLAG_NO_MOVE);
-
-
-	ret =3D drm_bo_do_validate(bo, flags, mask, hint, fence_class, rep);
-
-	if (!ret && bo_rep)
-		*bo_rep =3D bo;
-	else
-		drm_bo_usage_deref_unlocked(&bo);
-
-	return ret;
-}
-EXPORT_SYMBOL(drm_bo_handle_validate);
-
-static int drm_bo_handle_info(struct drm_file *file_priv, uint32_t han=
dle,
-			      struct drm_bo_info_rep *rep)
-{
-	struct drm_device *dev =3D file_priv->head->dev;
-	struct drm_buffer_object *bo;
-
-	mutex_lock(&dev->struct_mutex);
-	bo =3D drm_lookup_buffer_object(file_priv, handle, 1);
-	mutex_unlock(&dev->struct_mutex);
-
-	if (!bo)
-		return -EINVAL;
-
-	mutex_lock(&bo->mutex);
-	if (!(bo->priv_flags & _DRM_BO_FLAG_UNFENCED))
-		(void)drm_bo_busy(bo);
-	drm_bo_fill_rep_arg(bo, rep);
-	mutex_unlock(&bo->mutex);
-	drm_bo_usage_deref_unlocked(&bo);
-	return 0;
-}
-
-static int drm_bo_handle_wait(struct drm_file *file_priv, uint32_t han=
dle,
-			      uint32_t hint,
-			      struct drm_bo_info_rep *rep)
-{
-	struct drm_device *dev =3D file_priv->head->dev;
-	struct drm_buffer_object *bo;
-	int no_wait =3D hint & DRM_BO_HINT_DONT_BLOCK;
-	int ret;
-
-	mutex_lock(&dev->struct_mutex);
-	bo =3D drm_lookup_buffer_object(file_priv, handle, 1);
-	mutex_unlock(&dev->struct_mutex);
-
-	if (!bo)
-		return -EINVAL;
-
-	mutex_lock(&bo->mutex);
-	ret =3D drm_bo_wait_unfenced(bo, no_wait, 0);
-	if (ret)
-		goto out;
-	ret =3D drm_bo_wait(bo, hint & DRM_BO_HINT_WAIT_LAZY, 0, no_wait);
-	if (ret)
-		goto out;
-
-	drm_bo_fill_rep_arg(bo, rep);
-
-out:
-	mutex_unlock(&bo->mutex);
-	drm_bo_usage_deref_unlocked(&bo);
-	return ret;
-}
-
-int drm_buffer_object_create(struct drm_device *dev,
-			     unsigned long size,
-			     enum drm_bo_type type,
-			     uint64_t flags,
-			     uint32_t hint,
-			     uint32_t page_alignment,
-			     unsigned long buffer_start,
-			     struct drm_buffer_object **buf_obj)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_buffer_object *bo;
-	int ret =3D 0;
-	unsigned long num_pages;
-
-	size +=3D buffer_start & ~PAGE_MASK;
-	num_pages =3D (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (num_pages =3D=3D 0) {
-		DRM_ERROR("Illegal buffer object size.\n");
-		return -EINVAL;
-	}
-
-	bo =3D drm_ctl_calloc(1, sizeof(*bo), DRM_MEM_BUFOBJ);
-
-	if (!bo)
-		return -ENOMEM;
-
-	mutex_init(&bo->mutex);
-	mutex_lock(&bo->mutex);
-
-	atomic_set(&bo->usage, 1);
-	atomic_set(&bo->mapped, -1);
-	DRM_INIT_WAITQUEUE(&bo->event_queue);
-	INIT_LIST_HEAD(&bo->lru);
-	INIT_LIST_HEAD(&bo->pinned_lru);
-	INIT_LIST_HEAD(&bo->ddestroy);
-	bo->dev =3D dev;
-	bo->type =3D type;
-	bo->num_pages =3D num_pages;
-	bo->mem.mem_type =3D DRM_BO_MEM_LOCAL;
-	bo->mem.num_pages =3D bo->num_pages;
-	bo->mem.mm_node =3D NULL;
-	bo->mem.page_alignment =3D page_alignment;
-	bo->buffer_start =3D buffer_start & PAGE_MASK;
-	bo->priv_flags =3D 0;
-	bo->mem.flags =3D (DRM_BO_FLAG_MEM_LOCAL | DRM_BO_FLAG_CACHED |
-			 DRM_BO_FLAG_MAPPABLE);
-	bo->mem.proposed_flags =3D 0;
-	atomic_inc(&bm->count);
-	/*
-	 * Use drm_bo_modify_proposed_flags to error-check the proposed flags
-	 */
-	ret =3D drm_bo_modify_proposed_flags(bo, flags, flags);
-	if (ret)
-		goto out_err;
-
-	/*
-	 * For drm_bo_type_device buffers, allocate
-	 * address space from the device so that applications
-	 * can mmap the buffer from there
-	 */
-	if (bo->type =3D=3D drm_bo_type_device) {
-		mutex_lock(&dev->struct_mutex);
-		ret =3D drm_bo_setup_vm_locked(bo);
-		mutex_unlock(&dev->struct_mutex);
-		if (ret)
-			goto out_err;
-	}
-
-	ret =3D drm_buffer_object_validate(bo, 0, 0, hint & DRM_BO_HINT_DONT_=
BLOCK);
-	if (ret)
-		goto out_err;
-
-	mutex_unlock(&bo->mutex);
-	*buf_obj =3D bo;
-	return 0;
-
-out_err:
-	mutex_unlock(&bo->mutex);
-
-	drm_bo_usage_deref_unlocked(&bo);
-	return ret;
-}
-EXPORT_SYMBOL(drm_buffer_object_create);
-
-
-static int drm_bo_add_user_object(struct drm_file *file_priv,
-				  struct drm_buffer_object *bo, int shareable)
-{
-	struct drm_device *dev =3D file_priv->head->dev;
-	int ret;
-
-	mutex_lock(&dev->struct_mutex);
-	ret =3D drm_add_user_object(file_priv, &bo->base, shareable);
-	if (ret)
-		goto out;
-
-	bo->base.remove =3D drm_bo_base_deref_locked;
-	bo->base.type =3D drm_buffer_type;
-	bo->base.ref_struct_locked =3D NULL;
-	bo->base.unref =3D drm_buffer_user_object_unmap;
-
-out:
-	mutex_unlock(&dev->struct_mutex);
-	return ret;
-}
-
-int drm_bo_create_ioctl(struct drm_device *dev, void *data, struct drm=
_file *file_priv)
-{
-	struct drm_bo_create_arg *arg =3D data;
-	struct drm_bo_create_req *req =3D &arg->d.req;
-	struct drm_bo_info_rep *rep =3D &arg->d.rep;
-	struct drm_buffer_object *entry;
-	enum drm_bo_type bo_type;
-	int ret =3D 0;
-
-	DRM_DEBUG("drm_bo_create_ioctl: %dkb, %dkb align\n",
-	    (int)(req->size / 1024), req->page_alignment * 4);
-
-	if (!dev->bm.initialized) {
-		DRM_ERROR("Buffer object manager is not initialized.\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * If the buffer creation request comes in with a starting address,
-	 * that points at the desired user pages to map. Otherwise, create
-	 * a drm_bo_type_device buffer, which uses pages allocated from the k=
ernel
-	 */
-	bo_type =3D (req->buffer_start) ? drm_bo_type_user : drm_bo_type_devi=
ce;
-
-	/*
-	 * User buffers cannot be shared
-	 */
-	if (bo_type =3D=3D drm_bo_type_user)
-		req->flags &=3D ~DRM_BO_FLAG_SHAREABLE;
-
-	ret =3D drm_buffer_object_create(file_priv->head->dev,
-				       req->size, bo_type, req->flags,
-				       req->hint, req->page_alignment,
-				       req->buffer_start, &entry);
-	if (ret)
-		goto out;
-
-	ret =3D drm_bo_add_user_object(file_priv, entry,
-				     req->flags & DRM_BO_FLAG_SHAREABLE);
-	if (ret) {
-		drm_bo_usage_deref_unlocked(&entry);
-		goto out;
-	}
-
-	mutex_lock(&entry->mutex);
-	drm_bo_fill_rep_arg(entry, rep);
-	mutex_unlock(&entry->mutex);
-
-out:
-	return ret;
-}
-
-int drm_bo_setstatus_ioctl(struct drm_device *dev,
-			   void *data, struct drm_file *file_priv)
-{
-	struct drm_bo_map_wait_idle_arg *arg =3D data;
-	struct drm_bo_info_req *req =3D &arg->d.req;
-	struct drm_bo_info_rep *rep =3D &arg->d.rep;
-	int ret;
-
-	if (!dev->bm.initialized) {
-		DRM_ERROR("Buffer object manager is not initialized.\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_bo_read_lock(&dev->bm.bm_lock);
-	if (ret)
-		return ret;
-
-	/*
-	 * validate the buffer. note that 'fence_class' will be unused
-	 * as we pass use_old_fence_class=3D1 here. Note also that
-	 * the libdrm API doesn't pass fence_class to the kernel,
-	 * so it's a good thing it isn't used here.
-	 */
-	ret =3D drm_bo_handle_validate(file_priv, req->handle,
-				     req->flags,
-				     req->mask,
-				     req->hint | DRM_BO_HINT_DONT_FENCE,
-				     req->fence_class, 1,
-				     rep, NULL);
-
-	(void) drm_bo_read_unlock(&dev->bm.bm_lock);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-int drm_bo_map_ioctl(struct drm_device *dev, void *data, struct drm_fi=
le *file_priv)
-{
-	struct drm_bo_map_wait_idle_arg *arg =3D data;
-	struct drm_bo_info_req *req =3D &arg->d.req;
-	struct drm_bo_info_rep *rep =3D &arg->d.rep;
-	int ret;
-	if (!dev->bm.initialized) {
-		DRM_ERROR("Buffer object manager is not initialized.\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_buffer_object_map(file_priv, req->handle, req->mask,
-				    req->hint, rep);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-int drm_bo_unmap_ioctl(struct drm_device *dev, void *data, struct drm_=
file *file_priv)
-{
-	struct drm_bo_handle_arg *arg =3D data;
-	int ret;
-	if (!dev->bm.initialized) {
-		DRM_ERROR("Buffer object manager is not initialized.\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_buffer_object_unmap(file_priv, arg->handle);
-	return ret;
-}
-
-
-int drm_bo_reference_ioctl(struct drm_device *dev, void *data, struct =
drm_file *file_priv)
-{
-	struct drm_bo_reference_info_arg *arg =3D data;
-	struct drm_bo_handle_arg *req =3D &arg->d.req;
-	struct drm_bo_info_rep *rep =3D &arg->d.rep;
-	struct drm_user_object *uo;
-	int ret;
-
-	if (!dev->bm.initialized) {
-		DRM_ERROR("Buffer object manager is not initialized.\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_user_object_ref(file_priv, req->handle,
-				  drm_buffer_type, &uo);
-	if (ret)
-		return ret;
-
-	ret =3D drm_bo_handle_info(file_priv, req->handle, rep);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-int drm_bo_unreference_ioctl(struct drm_device *dev, void *data, struc=
t drm_file *file_priv)
-{
-	struct drm_bo_handle_arg *arg =3D data;
-	int ret =3D 0;
-
-	if (!dev->bm.initialized) {
-		DRM_ERROR("Buffer object manager is not initialized.\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_user_object_unref(file_priv, arg->handle, drm_buffer_type=
);
-	return ret;
-}
-
-int drm_bo_info_ioctl(struct drm_device *dev, void *data, struct drm_f=
ile *file_priv)
-{
-	struct drm_bo_reference_info_arg *arg =3D data;
-	struct drm_bo_handle_arg *req =3D &arg->d.req;
-	struct drm_bo_info_rep *rep =3D &arg->d.rep;
-	int ret;
-
-	if (!dev->bm.initialized) {
-		DRM_ERROR("Buffer object manager is not initialized.\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_bo_handle_info(file_priv, req->handle, rep);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-int drm_bo_wait_idle_ioctl(struct drm_device *dev, void *data, struct =
drm_file *file_priv)
-{
-	struct drm_bo_map_wait_idle_arg *arg =3D data;
-	struct drm_bo_info_req *req =3D &arg->d.req;
-	struct drm_bo_info_rep *rep =3D &arg->d.rep;
-	int ret;
-	if (!dev->bm.initialized) {
-		DRM_ERROR("Buffer object manager is not initialized.\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_bo_handle_wait(file_priv, req->handle,
-				 req->hint, rep);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static int drm_bo_leave_list(struct drm_buffer_object *bo,
-			     uint32_t mem_type,
-			     int free_pinned,
-			     int allow_errors)
-{
-	struct drm_device *dev =3D bo->dev;
-	int ret =3D 0;
-
-	mutex_lock(&bo->mutex);
-
-	ret =3D drm_bo_expire_fence(bo, allow_errors);
-	if (ret)
-		goto out;
-
-	if (free_pinned) {
-		DRM_FLAG_MASKED(bo->mem.flags, 0, DRM_BO_FLAG_NO_MOVE);
-		mutex_lock(&dev->struct_mutex);
-		list_del_init(&bo->pinned_lru);
-		if (bo->pinned_node =3D=3D bo->mem.mm_node)
-			bo->pinned_node =3D NULL;
-		if (bo->pinned_node !=3D NULL) {
-			drm_mm_put_block(bo->pinned_node);
-			bo->pinned_node =3D NULL;
-		}
-		mutex_unlock(&dev->struct_mutex);
-	}
-
-	if (bo->mem.flags & DRM_BO_FLAG_NO_EVICT) {
-		DRM_ERROR("A DRM_BO_NO_EVICT buffer present at "
-			  "cleanup. Removing flag and evicting.\n");
-		bo->mem.flags &=3D ~DRM_BO_FLAG_NO_EVICT;
-		bo->mem.proposed_flags &=3D ~DRM_BO_FLAG_NO_EVICT;
-	}
-
-	if (bo->mem.mem_type =3D=3D mem_type)
-		ret =3D drm_bo_evict(bo, mem_type, 0);
-
-	if (ret) {
-		if (allow_errors) {
-			goto out;
-		} else {
-			ret =3D 0;
-			DRM_ERROR("Cleanup eviction failed\n");
-		}
-	}
-
-out:
-	mutex_unlock(&bo->mutex);
-	return ret;
-}
-
-
-static struct drm_buffer_object *drm_bo_entry(struct list_head *list,
-					 int pinned_list)
-{
-	if (pinned_list)
-		return list_entry(list, struct drm_buffer_object, pinned_lru);
-	else
-		return list_entry(list, struct drm_buffer_object, lru);
-}
-
-/*
- * dev->struct_mutex locked.
- */
-
-static int drm_bo_force_list_clean(struct drm_device *dev,
-				   struct list_head *head,
-				   unsigned mem_type,
-				   int free_pinned,
-				   int allow_errors,
-				   int pinned_list)
-{
-	struct list_head *list, *next, *prev;
-	struct drm_buffer_object *entry, *nentry;
-	int ret;
-	int do_restart;
-
-	/*
-	 * The list traversal is a bit odd here, because an item may
-	 * disappear from the list when we release the struct_mutex or
-	 * when we decrease the usage count. Also we're not guaranteed
-	 * to drain pinned lists, so we can't always restart.
-	 */
-
-restart:
-	nentry =3D NULL;
-	list_for_each_safe(list, next, head) {
-		prev =3D list->prev;
-
-		entry =3D (nentry !=3D NULL) ? nentry: drm_bo_entry(list, pinned_lis=
t);
-		atomic_inc(&entry->usage);
-		if (nentry) {
-			atomic_dec(&nentry->usage);
-			nentry =3D NULL;
-		}
-
-		/*
-		 * Protect the next item from destruction, so we can check
-		 * its list pointers later on.
-		 */
-
-		if (next !=3D head) {
-			nentry =3D drm_bo_entry(next, pinned_list);
-			atomic_inc(&nentry->usage);
-		}
-		mutex_unlock(&dev->struct_mutex);
-
-		ret =3D drm_bo_leave_list(entry, mem_type, free_pinned,
-					allow_errors);
-		mutex_lock(&dev->struct_mutex);
-
-		drm_bo_usage_deref_locked(&entry);
-		if (ret)
-			return ret;
-
-		/*
-		 * Has the next item disappeared from the list?
-		 */
-
-		do_restart =3D ((next->prev !=3D list) && (next->prev !=3D prev));
-
-		if (nentry !=3D NULL && do_restart)
-			drm_bo_usage_deref_locked(&nentry);
-
-		if (do_restart)
-			goto restart;
-	}
-	return 0;
-}
-
-int drm_bo_clean_mm(struct drm_device *dev, unsigned mem_type)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_mem_type_manager *man =3D &bm->man[mem_type];
-	int ret =3D -EINVAL;
-
-	if (mem_type >=3D DRM_BO_MEM_TYPES) {
-		DRM_ERROR("Illegal memory type %d\n", mem_type);
-		return ret;
-	}
-
-	if (!man->has_type) {
-		DRM_ERROR("Trying to take down uninitialized "
-			  "memory manager type %u\n", mem_type);
-		return ret;
-	}
-	man->use_type =3D 0;
-	man->has_type =3D 0;
-
-	ret =3D 0;
-	if (mem_type > 0) {
-		BUG_ON(!list_empty(&bm->unfenced));
-		drm_bo_force_list_clean(dev, &man->lru, mem_type, 1, 0, 0);
-		drm_bo_force_list_clean(dev, &man->pinned, mem_type, 1, 0, 1);
-
-		if (drm_mm_clean(&man->manager)) {
-			drm_mm_takedown(&man->manager);
-		} else {
-			ret =3D -EBUSY;
-		}
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(drm_bo_clean_mm);
-
-/**
- *Evict all buffers of a particular mem_type, but leave memory manager
- *regions for NO_MOVE buffers intact. New buffers cannot be added at t=
his
- *point since we have the hardware lock.
- */
-
-static int drm_bo_lock_mm(struct drm_device *dev, unsigned mem_type)
-{
-	int ret;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_mem_type_manager *man =3D &bm->man[mem_type];
-
-	if (mem_type =3D=3D 0 || mem_type >=3D DRM_BO_MEM_TYPES) {
-		DRM_ERROR("Illegal memory manager memory type %u.\n", mem_type);
-		return -EINVAL;
-	}
-
-	if (!man->has_type) {
-		DRM_ERROR("Memory type %u has not been initialized.\n",
-			  mem_type);
-		return 0;
-	}
-
-	ret =3D drm_bo_force_list_clean(dev, &man->lru, mem_type, 0, 1, 0);
-	if (ret)
-		return ret;
-	ret =3D drm_bo_force_list_clean(dev, &man->pinned, mem_type, 0, 1, 1)=
;
-
-	return ret;
-}
-
-int drm_bo_init_mm(struct drm_device *dev,
-		   unsigned type,
-		   unsigned long p_offset, unsigned long p_size)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	int ret =3D -EINVAL;
-	struct drm_mem_type_manager *man;
-
-	if (type >=3D DRM_BO_MEM_TYPES) {
-		DRM_ERROR("Illegal memory type %d\n", type);
-		return ret;
-	}
-
-	man =3D &bm->man[type];
-	if (man->has_type) {
-		DRM_ERROR("Memory manager already initialized for type %d\n",
-			  type);
-		return ret;
-	}
-
-	ret =3D dev->driver->bo_driver->init_mem_type(dev, type, man);
-	if (ret)
-		return ret;
-
-	ret =3D 0;
-	if (type !=3D DRM_BO_MEM_LOCAL) {
-		if (!p_size) {
-			DRM_ERROR("Zero size memory manager type %d\n", type);
-			return ret;
-		}
-		ret =3D drm_mm_init(&man->manager, p_offset, p_size);
-		if (ret)
-			return ret;
-	}
-	man->has_type =3D 1;
-	man->use_type =3D 1;
-
-	INIT_LIST_HEAD(&man->lru);
-	INIT_LIST_HEAD(&man->pinned);
-
-	return 0;
-}
-EXPORT_SYMBOL(drm_bo_init_mm);
-
-/*
- * This function is intended to be called on drm driver unload.
- * If you decide to call it from lastclose, you must protect the call
- * from a potentially racing drm_bo_driver_init in firstopen.
- * (This may happen on X server restart).
- */
-
-int drm_bo_driver_finish(struct drm_device *dev)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	int ret =3D 0;
-	unsigned i =3D DRM_BO_MEM_TYPES;
-	struct drm_mem_type_manager *man;
-
-	mutex_lock(&dev->struct_mutex);
-
-	if (!bm->initialized)
-		goto out;
-	bm->initialized =3D 0;
-
-	while (i--) {
-		man =3D &bm->man[i];
-		if (man->has_type) {
-			man->use_type =3D 0;
-			if ((i !=3D DRM_BO_MEM_LOCAL) && drm_bo_clean_mm(dev, i)) {
-				ret =3D -EBUSY;
-				DRM_ERROR("DRM memory manager type %d "
-					  "is not clean.\n", i);
-			}
-			man->has_type =3D 0;
-		}
-	}
-	mutex_unlock(&dev->struct_mutex);
-
-	if (!cancel_delayed_work(&bm->wq))
-		flush_scheduled_work();
-
-	mutex_lock(&dev->struct_mutex);
-	drm_bo_delayed_delete(dev, 1);
-	if (list_empty(&bm->ddestroy))
-		DRM_DEBUG("Delayed destroy list was clean\n");
-
-	if (list_empty(&bm->man[0].lru))
-		DRM_DEBUG("Swap list was clean\n");
-
-	if (list_empty(&bm->man[0].pinned))
-		DRM_DEBUG("NO_MOVE list was clean\n");
-
-	if (list_empty(&bm->unfenced))
-		DRM_DEBUG("Unfenced list was clean\n");
-
-	__free_page(bm->dummy_read_page);
-
-out:
-	mutex_unlock(&dev->struct_mutex);
-	return ret;
-}
-
-/*
- * This function is intended to be called on drm driver load.
- * If you decide to call it from firstopen, you must protect the call
- * from a potentially racing drm_bo_driver_finish in lastclose.
- * (This may happen on X server restart).
- */
-
-int drm_bo_driver_init(struct drm_device *dev)
-{
-	struct drm_bo_driver *driver =3D dev->driver->bo_driver;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	int ret =3D -EINVAL;
-
-	bm->dummy_read_page =3D NULL;
-	drm_bo_init_lock(&bm->bm_lock);
-	mutex_lock(&dev->struct_mutex);
-	if (!driver)
-		goto out_unlock;
-
-	bm->dummy_read_page =3D alloc_page(__GFP_ZERO | GFP_DMA32);
-	if (!bm->dummy_read_page) {
-		ret =3D -ENOMEM;
-		goto out_unlock;
-	}
-
-	/*
-	 * Initialize the system memory buffer type.
-	 * Other types need to be driver / IOCTL initialized.
-	 */
-	ret =3D drm_bo_init_mm(dev, DRM_BO_MEM_LOCAL, 0, 0);
-	if (ret)
-		goto out_unlock;
-
-	INIT_DELAYED_WORK(&bm->wq, drm_bo_delayed_workqueue);
-	bm->initialized =3D 1;
-	bm->nice_mode =3D 1;
-	atomic_set(&bm->count, 0);
-	bm->cur_pages =3D 0;
-	INIT_LIST_HEAD(&bm->unfenced);
-	INIT_LIST_HEAD(&bm->ddestroy);
-out_unlock:
-	mutex_unlock(&dev->struct_mutex);
-	return ret;
-}
-EXPORT_SYMBOL(drm_bo_driver_init);
-
-int drm_mm_init_ioctl(struct drm_device *dev, void *data, struct drm_f=
ile *file_priv)
-{
-	struct drm_mm_init_arg *arg =3D data;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_bo_driver *driver =3D dev->driver->bo_driver;
-	int ret;
-
-	if (!driver) {
-		DRM_ERROR("Buffer objects are not supported by this driver\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_bo_write_lock(&bm->bm_lock, file_priv);
-	if (ret)
-		return ret;
-
-	ret =3D -EINVAL;
-	if (arg->magic !=3D DRM_BO_INIT_MAGIC) {
-		DRM_ERROR("You are using an old libdrm that is not compatible with\n=
"
-			  "\tthe kernel DRM module. Please upgrade your libdrm.\n");
-		return -EINVAL;
-	}
-	if (arg->major !=3D DRM_BO_INIT_MAJOR) {
-		DRM_ERROR("libdrm and kernel DRM buffer object interface major\n"
-			  "\tversion don't match. Got %d, expected %d.\n",
-			  arg->major, DRM_BO_INIT_MAJOR);
-		return -EINVAL;
-	}
-
-	mutex_lock(&dev->struct_mutex);
-	if (!bm->initialized) {
-		DRM_ERROR("DRM memory manager was not initialized.\n");
-		goto out;
-	}
-	if (arg->mem_type =3D=3D 0) {
-		DRM_ERROR("System memory buffers already initialized.\n");
-		goto out;
-	}
-	ret =3D drm_bo_init_mm(dev, arg->mem_type,
-			     arg->p_offset, arg->p_size);
-
-out:
-	mutex_unlock(&dev->struct_mutex);
-	(void) drm_bo_write_unlock(&bm->bm_lock, file_priv);
-
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-int drm_mm_takedown_ioctl(struct drm_device *dev, void *data, struct d=
rm_file *file_priv)
-{
-	struct drm_mm_type_arg *arg =3D data;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_bo_driver *driver =3D dev->driver->bo_driver;
-	int ret;
-
-	if (!driver) {
-		DRM_ERROR("Buffer objects are not supported by this driver\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_bo_write_lock(&bm->bm_lock, file_priv);
-	if (ret)
-		return ret;
-
-	mutex_lock(&dev->struct_mutex);
-	ret =3D -EINVAL;
-	if (!bm->initialized) {
-		DRM_ERROR("DRM memory manager was not initialized\n");
-		goto out;
-	}
-	if (arg->mem_type =3D=3D 0) {
-		DRM_ERROR("No takedown for System memory buffers.\n");
-		goto out;
-	}
-	ret =3D 0;
-	if (drm_bo_clean_mm(dev, arg->mem_type)) {
-		DRM_ERROR("Memory manager type %d not clean. "
-			  "Delaying takedown\n", arg->mem_type);
-	}
-out:
-	mutex_unlock(&dev->struct_mutex);
-	(void) drm_bo_write_unlock(&bm->bm_lock, file_priv);
-
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-int drm_mm_lock_ioctl(struct drm_device *dev, void *data, struct drm_f=
ile *file_priv)
-{
-	struct drm_mm_type_arg *arg =3D data;
-	struct drm_bo_driver *driver =3D dev->driver->bo_driver;
-	int ret;
-
-	if (!driver) {
-		DRM_ERROR("Buffer objects are not supported by this driver\n");
-		return -EINVAL;
-	}
-
-	if (arg->lock_flags & DRM_BO_LOCK_IGNORE_NO_EVICT) {
-		DRM_ERROR("Lock flag DRM_BO_LOCK_IGNORE_NO_EVICT not supported yet.\=
n");
-		return -EINVAL;
-	}
-
-	if (arg->lock_flags & DRM_BO_LOCK_UNLOCK_BM) {
-		ret =3D drm_bo_write_lock(&dev->bm.bm_lock, file_priv);
-		if (ret)
-			return ret;
-	}
-
-	mutex_lock(&dev->struct_mutex);
-	ret =3D drm_bo_lock_mm(dev, arg->mem_type);
-	mutex_unlock(&dev->struct_mutex);
-	if (ret) {
-		(void) drm_bo_write_unlock(&dev->bm.bm_lock, file_priv);
-		return ret;
-	}
-
-	return 0;
-}
-
-int drm_mm_unlock_ioctl(struct drm_device *dev,
-			void *data,
-			struct drm_file *file_priv)
-{
-	struct drm_mm_type_arg *arg =3D data;
-	struct drm_bo_driver *driver =3D dev->driver->bo_driver;
-	int ret;
-
-	if (!driver) {
-		DRM_ERROR("Buffer objects are not supported by this driver\n");
-		return -EINVAL;
-	}
-
-	if (arg->lock_flags & DRM_BO_LOCK_UNLOCK_BM) {
-		ret =3D drm_bo_write_unlock(&dev->bm.bm_lock, file_priv);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-/*
- * buffer object vm functions.
- */
-
-int drm_mem_reg_is_pci(struct drm_device *dev, struct drm_bo_mem_reg *=
mem)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_mem_type_manager *man =3D &bm->man[mem->mem_type];
-
-	if (!(man->flags & _DRM_FLAG_MEMTYPE_FIXED)) {
-		if (mem->mem_type =3D=3D DRM_BO_MEM_LOCAL)
-			return 0;
-
-		if (man->flags & _DRM_FLAG_MEMTYPE_CMA)
-			return 0;
-
-		if (mem->flags & DRM_BO_FLAG_CACHED)
-			return 0;
-	}
-	return 1;
-}
-EXPORT_SYMBOL(drm_mem_reg_is_pci);
-
-/**
- * \c Get the PCI offset for the buffer object memory.
- *
- * \param bo The buffer object.
- * \param bus_base On return the base of the PCI region
- * \param bus_offset On return the byte offset into the PCI region
- * \param bus_size On return the byte size of the buffer object or zer=
o if
- *     the buffer object memory is not accessible through a PCI region=
=2E
- * \return Failure indication.
- *
- * Returns -EINVAL if the buffer object is currently not mappable.
- * Otherwise returns zero.
- */
-
-int drm_bo_pci_offset(struct drm_device *dev,
-		      struct drm_bo_mem_reg *mem,
-		      unsigned long *bus_base,
-		      unsigned long *bus_offset, unsigned long *bus_size)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_mem_type_manager *man =3D &bm->man[mem->mem_type];
-
-	*bus_size =3D 0;
-	if (!(man->flags & _DRM_FLAG_MEMTYPE_MAPPABLE))
-		return -EINVAL;
-
-	if (drm_mem_reg_is_pci(dev, mem)) {
-		*bus_offset =3D mem->mm_node->start << PAGE_SHIFT;
-		*bus_size =3D mem->num_pages << PAGE_SHIFT;
-		*bus_base =3D man->io_offset;
-	}
-
-	return 0;
-}
-
-/**
- * \c Kill all user-space virtual mappings of this buffer object.
- *
- * \param bo The buffer object.
- *
- * Call bo->mutex locked.
- */
-
-void drm_bo_unmap_virtual(struct drm_buffer_object *bo)
-{
-	struct drm_device *dev =3D bo->dev;
-	loff_t offset =3D ((loff_t) bo->map_list.hash.key) << PAGE_SHIFT;
-	loff_t holelen =3D ((loff_t) bo->mem.num_pages) << PAGE_SHIFT;
-
-	if (!dev->dev_mapping)
-		return;
-
-	unmap_mapping_range(dev->dev_mapping, offset, holelen, 1);
-}
-
-/**
- * drm_bo_takedown_vm_locked:
- *
- * @bo: the buffer object to remove any drm device mapping
- *
- * Remove any associated vm mapping on the drm device node that
- * would have been created for a drm_bo_type_device buffer
- */
-static void drm_bo_takedown_vm_locked(struct drm_buffer_object *bo)
-{
-	struct drm_map_list *list;
-	drm_local_map_t *map;
-	struct drm_device *dev =3D bo->dev;
-
-	DRM_ASSERT_LOCKED(&dev->struct_mutex);
-	if (bo->type !=3D drm_bo_type_device)
-		return;
-
-	list =3D &bo->map_list;
-	if (list->user_token) {
-		drm_ht_remove_item(&dev->map_hash, &list->hash);
-		list->user_token =3D 0;
-	}
-	if (list->file_offset_node) {
-		drm_mm_put_block(list->file_offset_node);
-		list->file_offset_node =3D NULL;
-	}
-
-	map =3D list->map;
-	if (!map)
-		return;
-
-	drm_ctl_free(map, sizeof(*map), DRM_MEM_BUFOBJ);
-	list->map =3D NULL;
-	list->user_token =3D 0ULL;
-	drm_bo_usage_deref_locked(&bo);
-}
-
-/**
- * drm_bo_setup_vm_locked:
- *
- * @bo: the buffer to allocate address space for
- *
- * Allocate address space in the drm device so that applications
- * can mmap the buffer and access the contents. This only
- * applies to drm_bo_type_device objects as others are not
- * placed in the drm device address space.
- */
-static int drm_bo_setup_vm_locked(struct drm_buffer_object *bo)
-{
-	struct drm_map_list *list =3D &bo->map_list;
-	drm_local_map_t *map;
-	struct drm_device *dev =3D bo->dev;
-
-	DRM_ASSERT_LOCKED(&dev->struct_mutex);
-	list->map =3D drm_ctl_calloc(1, sizeof(*map), DRM_MEM_BUFOBJ);
-	if (!list->map)
-		return -ENOMEM;
-
-	map =3D list->map;
-	map->offset =3D 0;
-	map->type =3D _DRM_TTM;
-	map->flags =3D _DRM_REMOVABLE;
-	map->size =3D bo->mem.num_pages * PAGE_SIZE;
-	atomic_inc(&bo->usage);
-	map->handle =3D (void *)bo;
-
-	list->file_offset_node =3D drm_mm_search_free(&dev->offset_manager,
-						    bo->mem.num_pages, 0, 0);
-
-	if (!list->file_offset_node) {
-		drm_bo_takedown_vm_locked(bo);
-		return -ENOMEM;
-	}
-
-	list->file_offset_node =3D drm_mm_get_block(list->file_offset_node,
-						  bo->mem.num_pages, 0);
-
-	list->hash.key =3D list->file_offset_node->start;
-	if (drm_ht_insert_item(&dev->map_hash, &list->hash)) {
-		drm_bo_takedown_vm_locked(bo);
-		return -ENOMEM;
-	}
-
-	list->user_token =3D ((uint64_t) list->hash.key) << PAGE_SHIFT;
-
-	return 0;
-}
-
-int drm_bo_version_ioctl(struct drm_device *dev, void *data,
-			 struct drm_file *file_priv)
-{
-	struct drm_bo_version_arg *arg =3D (struct drm_bo_version_arg *)data;
-
-	arg->major =3D DRM_BO_INIT_MAJOR;
-	arg->minor =3D DRM_BO_INIT_MINOR;
-	arg->patchlevel =3D DRM_BO_INIT_PATCH;
-
-	return 0;
-}
diff -puN drivers/char/drm/drm_bo_lock.c~revert-git-drm /dev/null
--- a/drivers/char/drm/drm_bo_lock.c
+++ /dev/null
@@ -1,175 +0,0 @@
-/*********************************************************************=
*****
- *
- * Copyright (c) 2007 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaini=
ng a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject =
to
- * the following conditions:
- *
- * The above copyright notice and this permission notice (including th=
e
- * next paragraph) shall be included in all copies or substantial port=
ions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT =
SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR A=
NY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT =
OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE =
OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- *********************************************************************=
*****/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-/*
- * This file implements a simple replacement for the buffer manager us=
e
- * of the heavyweight hardware lock.
- * The lock is a read-write lock. Taking it in read mode is fast, and
- * intended for in-kernel use only.
- * Taking it in write mode is slow.
- *
- * The write mode is used only when there is a need to block all
- * user-space processes from allocating a
- * new memory area.
- * Typical use in write mode is X server VT switching, and it's allowe=
d
- * to leave kernel space with the write lock held. If a user-space pro=
cess
- * dies while having the write-lock, it will be released during the fi=
le
- * descriptor release.
- *
- * The read lock is typically placed at the start of an IOCTL- or
- * user-space callable function that may end up allocating a memory ar=
ea.
- * This includes setstatus, super-ioctls and no_pfn; the latter may mo=
ve
- * unmappable regions to mappable. It's a bug to leave kernel space wi=
th the
- * read lock held.
- *
- * Both read- and write lock taking is interruptible for low signal-de=
livery
- * latency. The locking functions will return -EAGAIN if interrupted b=
y a
- * signal.
- *
- * Locking order: The lock should be taken BEFORE any kernel mutexes
- * or spinlocks.
- */
-
-#include "drmP.h"
-
-void drm_bo_init_lock(struct drm_bo_lock *lock)
-{
-	DRM_INIT_WAITQUEUE(&lock->queue);
-	atomic_set(&lock->write_lock_pending, 0);
-	atomic_set(&lock->readers, 0);
-}
-
-void drm_bo_read_unlock(struct drm_bo_lock *lock)
-{
-	if (unlikely(atomic_add_negative(-1, &lock->readers)))
-		BUG();
-	if (atomic_read(&lock->readers) =3D=3D 0)
-		wake_up_interruptible(&lock->queue);
-}
-EXPORT_SYMBOL(drm_bo_read_unlock);
-
-int drm_bo_read_lock(struct drm_bo_lock *lock)
-{
-	while (unlikely(atomic_read(&lock->write_lock_pending) !=3D 0)) {
-		int ret;
-		ret =3D wait_event_interruptible
-		    (lock->queue, atomic_read(&lock->write_lock_pending) =3D=3D 0);
-		if (ret)
-			return -EAGAIN;
-	}
-
-	while (unlikely(!atomic_add_unless(&lock->readers, 1, -1))) {
-		int ret;
-		ret =3D wait_event_interruptible
-		    (lock->queue, atomic_add_unless(&lock->readers, 1, -1));
-		if (ret)
-			return -EAGAIN;
-	}
-	return 0;
-}
-EXPORT_SYMBOL(drm_bo_read_lock);
-
-static int __drm_bo_write_unlock(struct drm_bo_lock *lock)
-{
-	if (unlikely(atomic_cmpxchg(&lock->readers, -1, 0) !=3D -1))
-		return -EINVAL;
-	if (unlikely(atomic_cmpxchg(&lock->write_lock_pending, 1, 0) !=3D 1))
-		return -EINVAL;
-	wake_up_interruptible(&lock->queue);
-	return 0;
-}
-
-static void drm_bo_write_lock_remove(struct drm_file *file_priv,
-				     struct drm_user_object *item)
-{
-	struct drm_bo_lock *lock =3D container_of(item, struct drm_bo_lock, b=
ase);
-	int ret;
-
-	ret =3D __drm_bo_write_unlock(lock);
-	BUG_ON(ret);
-}
-
-int drm_bo_write_lock(struct drm_bo_lock *lock, struct drm_file *file_=
priv)
-{
-	int ret =3D 0;
-	struct drm_device *dev;
-
-	if (unlikely(atomic_cmpxchg(&lock->write_lock_pending, 0, 1) !=3D 0))
-		return -EINVAL;
-
-	while (unlikely(atomic_cmpxchg(&lock->readers, 0, -1) !=3D 0)) {
-		ret =3D wait_event_interruptible
-		    (lock->queue, atomic_cmpxchg(&lock->readers, 0, -1) =3D=3D 0);
-
-		if (ret) {
-			atomic_set(&lock->write_lock_pending, 0);
-			wake_up_interruptible(&lock->queue);
-			return -EAGAIN;
-		}
-	}
-
-	/*
-	 * Add a dummy user-object, the destructor of which will
-	 * make sure the lock is released if the client dies
-	 * while holding it.
-	 */
-
-	dev =3D file_priv->head->dev;
-	mutex_lock(&dev->struct_mutex);
-	ret =3D drm_add_user_object(file_priv, &lock->base, 0);
-	lock->base.remove =3D &drm_bo_write_lock_remove;
-	lock->base.type =3D drm_lock_type;
-	if (ret)
-		(void)__drm_bo_write_unlock(lock);
-
-	mutex_unlock(&dev->struct_mutex);
-
-	return ret;
-}
-
-int drm_bo_write_unlock(struct drm_bo_lock *lock, struct drm_file *fil=
e_priv)
-{
-	struct drm_device *dev =3D file_priv->head->dev;
-	struct drm_ref_object *ro;
-
-	mutex_lock(&dev->struct_mutex);
-
-	if (lock->base.owner !=3D file_priv) {
-		mutex_unlock(&dev->struct_mutex);
-		return -EINVAL;
-	}
-	ro =3D drm_lookup_ref_object(file_priv, &lock->base, _DRM_REF_USE);
-	BUG_ON(!ro);
-	drm_remove_ref_object(file_priv, ro);
-	lock->base.owner =3D NULL;
-
-	mutex_unlock(&dev->struct_mutex);
-	return 0;
-}
diff -puN drivers/char/drm/drm_bo_move.c~revert-git-drm /dev/null
--- a/drivers/char/drm/drm_bo_move.c
+++ /dev/null
@@ -1,609 +0,0 @@
-/*********************************************************************=
*****
- *
- * Copyright (c) 2007 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaini=
ng a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject =
to
- * the following conditions:
- *
- * The above copyright notice and this permission notice (including th=
e
- * next paragraph) shall be included in all copies or substantial port=
ions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT =
SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR A=
NY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT =
OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE =
OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- *********************************************************************=
*****/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#include "drmP.h"
-
-/**
- * Free the old memory node unless it's a pinned region and we
- * have not been requested to free also pinned regions.
- */
-
-static void drm_bo_free_old_node(struct drm_buffer_object *bo)
-{
-	struct drm_bo_mem_reg *old_mem =3D &bo->mem;
-
-	if (old_mem->mm_node && (old_mem->mm_node !=3D bo->pinned_node)) {
-		mutex_lock(&bo->dev->struct_mutex);
-		drm_mm_put_block(old_mem->mm_node);
-		old_mem->mm_node =3D NULL;
-		mutex_unlock(&bo->dev->struct_mutex);
-	}
-	old_mem->mm_node =3D NULL;
-}
-
-int drm_bo_move_ttm(struct drm_buffer_object *bo,
-		    int evict, int no_wait, struct drm_bo_mem_reg *new_mem)
-{
-	struct drm_ttm *ttm =3D bo->ttm;
-	struct drm_bo_mem_reg *old_mem =3D &bo->mem;
-	uint64_t save_flags =3D old_mem->flags;
-	uint64_t save_proposed_flags =3D old_mem->proposed_flags;
-	int ret;
-
-	if (old_mem->mem_type =3D=3D DRM_BO_MEM_TT) {
-		if (evict)
-			drm_ttm_evict(ttm);
-		else
-			drm_ttm_unbind(ttm);
-
-		drm_bo_free_old_node(bo);
-		DRM_FLAG_MASKED(old_mem->flags,
-				DRM_BO_FLAG_CACHED | DRM_BO_FLAG_MAPPABLE |
-				DRM_BO_FLAG_MEM_LOCAL, DRM_BO_MASK_MEMTYPE);
-		old_mem->mem_type =3D DRM_BO_MEM_LOCAL;
-		save_flags =3D old_mem->flags;
-	}
-	if (new_mem->mem_type !=3D DRM_BO_MEM_LOCAL) {
-		ret =3D drm_ttm_bind(ttm, new_mem);
-		if (ret)
-			return ret;
-	}
-
-	*old_mem =3D *new_mem;
-	new_mem->mm_node =3D NULL;
-	old_mem->proposed_flags =3D save_proposed_flags;
-	DRM_FLAG_MASKED(save_flags, new_mem->flags, DRM_BO_MASK_MEMTYPE);
-	return 0;
-}
-EXPORT_SYMBOL(drm_bo_move_ttm);
-
-/**
- * \c Return a kernel virtual address to the buffer object PCI memory.
- *
- * \param bo The buffer object.
- * \return Failure indication.
- *
- * Returns -EINVAL if the buffer object is currently not mappable.
- * Returns -ENOMEM if the ioremap operation failed.
- * Otherwise returns zero.
- *
- * After a successfull call, bo->iomap contains the virtual address, o=
r NULL
- * if the buffer object content is not accessible through PCI space.
- * Call bo->mutex locked.
- */
-
-int drm_mem_reg_ioremap(struct drm_device *dev, struct drm_bo_mem_reg =
*mem,
-			void **virtual)
-{
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_mem_type_manager *man =3D &bm->man[mem->mem_type];
-	unsigned long bus_offset;
-	unsigned long bus_size;
-	unsigned long bus_base;
-	int ret;
-	void *addr;
-
-	*virtual =3D NULL;
-	ret =3D drm_bo_pci_offset(dev, mem, &bus_base, &bus_offset, &bus_size=
);
-	if (ret || bus_size =3D=3D 0)
-		return ret;
-
-	if (!(man->flags & _DRM_FLAG_NEEDS_IOREMAP))
-		addr =3D (void *)(((u8 *) man->io_addr) + bus_offset);
-	else {
-		addr =3D ioremap_nocache(bus_base + bus_offset, bus_size);
-		if (!addr)
-			return -ENOMEM;
-	}
-	*virtual =3D addr;
-	return 0;
-}
-EXPORT_SYMBOL(drm_mem_reg_ioremap);
-
-/**
- * \c Unmap mapping obtained using drm_bo_ioremap
- *
- * \param bo The buffer object.
- *
- * Call bo->mutex locked.
- */
-
-void drm_mem_reg_iounmap(struct drm_device *dev, struct drm_bo_mem_reg=
 *mem,
-			 void *virtual)
-{
-	struct drm_buffer_manager *bm;
-	struct drm_mem_type_manager *man;
-
-	bm =3D &dev->bm;
-	man =3D &bm->man[mem->mem_type];
-
-	if (virtual && (man->flags & _DRM_FLAG_NEEDS_IOREMAP))
-		iounmap(virtual);
-}
-
-static int drm_copy_io_page(void *dst, void *src, unsigned long page)
-{
-	uint32_t *dstP =3D
-	    (uint32_t *) ((unsigned long)dst + (page << PAGE_SHIFT));
-	uint32_t *srcP =3D
-	    (uint32_t *) ((unsigned long)src + (page << PAGE_SHIFT));
-
-	int i;
-	for (i =3D 0; i < PAGE_SIZE / sizeof(uint32_t); ++i)
-		iowrite32(ioread32(srcP++), dstP++);
-	return 0;
-}
-
-static int drm_copy_io_ttm_page(struct drm_ttm *ttm, void *src,
-				unsigned long page)
-{
-	struct page *d =3D drm_ttm_get_page(ttm, page);
-	void *dst;
-
-	if (!d)
-		return -ENOMEM;
-
-	src =3D (void *)((unsigned long)src + (page << PAGE_SHIFT));
-	dst =3D kmap(d);
-	if (!dst)
-		return -ENOMEM;
-
-	memcpy_fromio(dst, src, PAGE_SIZE);
-	kunmap(d);
-	return 0;
-}
-
-static int drm_copy_ttm_io_page(struct drm_ttm *ttm, void *dst, unsign=
ed long page)
-{
-	struct page *s =3D drm_ttm_get_page(ttm, page);
-	void *src;
-
-	if (!s)
-		return -ENOMEM;
-
-	dst =3D (void *)((unsigned long)dst + (page << PAGE_SHIFT));
-	src =3D kmap(s);
-	if (!src)
-		return -ENOMEM;
-
-	memcpy_toio(dst, src, PAGE_SIZE);
-	kunmap(s);
-	return 0;
-}
-
-int drm_bo_move_memcpy(struct drm_buffer_object *bo,
-		       int evict, int no_wait, struct drm_bo_mem_reg *new_mem)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_mem_type_manager *man =3D &dev->bm.man[new_mem->mem_type];
-	struct drm_ttm *ttm =3D bo->ttm;
-	struct drm_bo_mem_reg *old_mem =3D &bo->mem;
-	struct drm_bo_mem_reg old_copy =3D *old_mem;
-	void *old_iomap;
-	void *new_iomap;
-	int ret;
-	uint64_t save_flags =3D old_mem->flags;
-	uint64_t save_proposed_flags =3D old_mem->proposed_flags;
-	unsigned long i;
-	unsigned long page;
-	unsigned long add =3D 0;
-	int dir;
-
-	ret =3D drm_mem_reg_ioremap(dev, old_mem, &old_iomap);
-	if (ret)
-		return ret;
-	ret =3D drm_mem_reg_ioremap(dev, new_mem, &new_iomap);
-	if (ret)
-		goto out;
-
-	if (old_iomap =3D=3D NULL && new_iomap =3D=3D NULL)
-		goto out2;
-	if (old_iomap =3D=3D NULL && ttm =3D=3D NULL)
-		goto out2;
-
-	add =3D 0;
-	dir =3D 1;
-
-	if ((old_mem->mem_type =3D=3D new_mem->mem_type) &&
-	    (new_mem->mm_node->start <
-	     old_mem->mm_node->start + old_mem->mm_node->size)) {
-		dir =3D -1;
-		add =3D new_mem->num_pages - 1;
-	}
-
-	for (i =3D 0; i < new_mem->num_pages; ++i) {
-		page =3D i * dir + add;
-		if (old_iomap =3D=3D NULL)
-			ret =3D drm_copy_ttm_io_page(ttm, new_iomap, page);
-		else if (new_iomap =3D=3D NULL)
-			ret =3D drm_copy_io_ttm_page(ttm, old_iomap, page);
-		else
-			ret =3D drm_copy_io_page(new_iomap, old_iomap, page);
-		if (ret)
-			goto out1;
-	}
-	mb();
-out2:
-	drm_bo_free_old_node(bo);
-
-	*old_mem =3D *new_mem;
-	new_mem->mm_node =3D NULL;
-	old_mem->proposed_flags =3D save_proposed_flags;
-	DRM_FLAG_MASKED(save_flags, new_mem->flags, DRM_BO_MASK_MEMTYPE);
-
-	if ((man->flags & _DRM_FLAG_MEMTYPE_FIXED) && (ttm !=3D NULL)) {
-		drm_ttm_unbind(ttm);
-		drm_ttm_destroy(ttm);
-		bo->ttm =3D NULL;
-	}
-
-out1:
-	drm_mem_reg_iounmap(dev, new_mem, new_iomap);
-out:
-	drm_mem_reg_iounmap(dev, &old_copy, old_iomap);
-	return ret;
-}
-EXPORT_SYMBOL(drm_bo_move_memcpy);
-
-/*
- * Transfer a buffer object's memory and LRU status to a newly
- * created object. User-space references remains with the old
- * object. Call bo->mutex locked.
- */
-
-int drm_buffer_object_transfer(struct drm_buffer_object *bo,
-			       struct drm_buffer_object **new_obj)
-{
-	struct drm_buffer_object *fbo;
-	struct drm_device *dev =3D bo->dev;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-
-	fbo =3D drm_ctl_calloc(1, sizeof(*fbo), DRM_MEM_BUFOBJ);
-	if (!fbo)
-		return -ENOMEM;
-
-	*fbo =3D *bo;
-	mutex_init(&fbo->mutex);
-	mutex_lock(&fbo->mutex);
-	mutex_lock(&dev->struct_mutex);
-
-	DRM_INIT_WAITQUEUE(&bo->event_queue);
-	INIT_LIST_HEAD(&fbo->ddestroy);
-	INIT_LIST_HEAD(&fbo->lru);
-	INIT_LIST_HEAD(&fbo->pinned_lru);
-
-	fbo->fence =3D drm_fence_reference_locked(bo->fence);
-	fbo->pinned_node =3D NULL;
-	fbo->mem.mm_node->private =3D (void *)fbo;
-	atomic_set(&fbo->usage, 1);
-	atomic_inc(&bm->count);
-	mutex_unlock(&dev->struct_mutex);
-	mutex_unlock(&fbo->mutex);
-
-	*new_obj =3D fbo;
-	return 0;
-}
-
-/*
- * Since move is underway, we need to block signals in this function.
- * We cannot restart until it has finished.
- */
-
-int drm_bo_move_accel_cleanup(struct drm_buffer_object *bo,
-			      int evict, int no_wait, uint32_t fence_class,
-			      uint32_t fence_type, uint32_t fence_flags,
-			      struct drm_bo_mem_reg *new_mem)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_mem_type_manager *man =3D &dev->bm.man[new_mem->mem_type];
-	struct drm_bo_mem_reg *old_mem =3D &bo->mem;
-	int ret;
-	uint64_t save_flags =3D old_mem->flags;
-	uint64_t save_proposed_flags =3D old_mem->proposed_flags;
-	struct drm_buffer_object *old_obj;
-
-	if (bo->fence)
-		drm_fence_usage_deref_unlocked(&bo->fence);
-	ret =3D drm_fence_object_create(dev, fence_class, fence_type,
-				      fence_flags | DRM_FENCE_FLAG_EMIT,
-				      &bo->fence);
-	bo->fence_type =3D fence_type;
-	if (ret)
-		return ret;
-
-	if (evict || ((bo->mem.mm_node =3D=3D bo->pinned_node) &&
-		      bo->mem.mm_node !=3D NULL)) {
-		ret =3D drm_bo_wait(bo, 0, 1, 0);
-		if (ret)
-			return ret;
-
-		drm_bo_free_old_node(bo);
-
-		if ((man->flags & _DRM_FLAG_MEMTYPE_FIXED) && (bo->ttm !=3D NULL)) {
-			drm_ttm_unbind(bo->ttm);
-			drm_ttm_destroy(bo->ttm);
-			bo->ttm =3D NULL;
-		}
-	} else {
-
-		/* This should help pipeline ordinary buffer moves.
-		 *
-		 * Hang old buffer memory on a new buffer object,
-		 * and leave it to be released when the GPU
-		 * operation has completed.
-		 */
-
-		ret =3D drm_buffer_object_transfer(bo, &old_obj);
-
-		if (ret)
-			return ret;
-
-		if (!(man->flags & _DRM_FLAG_MEMTYPE_FIXED))
-			old_obj->ttm =3D NULL;
-		else
-			bo->ttm =3D NULL;
-
-		mutex_lock(&dev->struct_mutex);
-		list_del_init(&old_obj->lru);
-		DRM_FLAG_MASKED(bo->priv_flags, 0, _DRM_BO_FLAG_UNFENCED);
-		drm_bo_add_to_lru(old_obj);
-
-		drm_bo_usage_deref_locked(&old_obj);
-		mutex_unlock(&dev->struct_mutex);
-
-	}
-
-	*old_mem =3D *new_mem;
-	new_mem->mm_node =3D NULL;
-	old_mem->proposed_flags =3D save_proposed_flags;
-	DRM_FLAG_MASKED(save_flags, new_mem->flags, DRM_BO_MASK_MEMTYPE);
-	return 0;
-}
-EXPORT_SYMBOL(drm_bo_move_accel_cleanup);
-
-int drm_bo_same_page(unsigned long offset,
-		     unsigned long offset2)
-{
-	return (offset & PAGE_MASK) =3D=3D (offset2 & PAGE_MASK);
-}
-EXPORT_SYMBOL(drm_bo_same_page);
-
-unsigned long drm_bo_offset_end(unsigned long offset,
-				unsigned long end)
-{
-	offset =3D (offset + PAGE_SIZE) & PAGE_MASK;
-	return (end < offset) ? end : offset;
-}
-EXPORT_SYMBOL(drm_bo_offset_end);
-
-static pgprot_t drm_kernel_io_prot(uint32_t map_type)
-{
-	pgprot_t tmp =3D PAGE_KERNEL;
-
-#if defined(__i386__) || defined(__x86_64__)
-#ifdef USE_PAT_WC
-#warning using pat
-	if (drm_use_pat() && map_type =3D=3D _DRM_TTM) {
-		pgprot_val(tmp) |=3D _PAGE_PAT;
-		return tmp;
-	}
-#endif
-	if (boot_cpu_data.x86 > 3 && map_type !=3D _DRM_AGP) {
-		pgprot_val(tmp) |=3D _PAGE_PCD;
-		pgprot_val(tmp) &=3D ~_PAGE_PWT;
-	}
-#elif defined(__powerpc__)
-	pgprot_val(tmp) |=3D _PAGE_NO_CACHE;
-	if (map_type =3D=3D _DRM_REGISTERS)
-		pgprot_val(tmp) |=3D _PAGE_GUARDED;
-#endif
-#if defined(__ia64__)
-	if (map_type =3D=3D _DRM_TTM)
-		tmp =3D pgprot_writecombine(tmp);
-	else
-		tmp =3D pgprot_noncached(tmp);
-#endif
-	return tmp;
-}
-
-static int drm_bo_ioremap(struct drm_buffer_object *bo, unsigned long =
bus_base,
-			  unsigned long bus_offset, unsigned long bus_size,
-			  struct drm_bo_kmap_obj *map)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_bo_mem_reg *mem =3D &bo->mem;
-	struct drm_mem_type_manager *man =3D &dev->bm.man[mem->mem_type];
-
-	if (!(man->flags & _DRM_FLAG_NEEDS_IOREMAP)) {
-		map->bo_kmap_type =3D bo_map_premapped;
-		map->virtual =3D (void *)(((u8 *) man->io_addr) + bus_offset);
-	} else {
-		map->bo_kmap_type =3D bo_map_iomap;
-		map->virtual =3D ioremap_nocache(bus_base + bus_offset, bus_size);
-	}
-	return (!map->virtual) ? -ENOMEM : 0;
-}
-
-static int drm_bo_kmap_ttm(struct drm_buffer_object *bo,
-			   unsigned long start_page, unsigned long num_pages,
-			   struct drm_bo_kmap_obj *map)
-{
-	struct drm_device *dev =3D bo->dev;
-	struct drm_bo_mem_reg *mem =3D &bo->mem;
-	struct drm_mem_type_manager *man =3D &dev->bm.man[mem->mem_type];
-	pgprot_t prot;
-	struct drm_ttm *ttm =3D bo->ttm;
-	struct page *d;
-	int i;
-
-	BUG_ON(!ttm);
-
-	if (num_pages =3D=3D 1 && (mem->flags & DRM_BO_FLAG_CACHED)) {
-
-		/*
-		 * We're mapping a single page, and the desired
-		 * page protection is consistent with the bo.
-		 */
-
-		map->bo_kmap_type =3D bo_map_kmap;
-		map->page =3D drm_ttm_get_page(ttm, start_page);
-		map->virtual =3D kmap(map->page);
-	} else {
-		/*
-		 * Populate the part we're mapping;
-		 */
-
-		for (i =3D start_page; i < start_page + num_pages; ++i) {
-			d =3D drm_ttm_get_page(ttm, i);
-			if (!d)
-				return -ENOMEM;
-		}
-
-		/*
-		 * We need to use vmap to get the desired page protection
-		 * or to make the buffer object look contigous.
-		 */
-
-		prot =3D (mem->flags & DRM_BO_FLAG_CACHED) ?
-			PAGE_KERNEL :
-			drm_kernel_io_prot(man->drm_bus_maptype);
-		map->bo_kmap_type =3D bo_map_vmap;
-		map->virtual =3D vmap(ttm->pages + start_page,
-				    num_pages, 0, prot);
-	}
-	return (!map->virtual) ? -ENOMEM : 0;
-}
-
-/*
- * This function is to be used for kernel mapping of buffer objects.
- * It chooses the appropriate mapping method depending on the memory t=
ype
- * and caching policy the buffer currently has.
- * Mapping multiple pages or buffers that live in io memory is a bit s=
low and
- * consumes vmalloc space. Be restrictive with such mappings.
- * Mapping single pages usually returns the logical kernel address,
- * (which is fast)
- * BUG may use slower temporary mappings for high memory pages or
- * uncached / write-combined pages.
- *
- * The function fills in a drm_bo_kmap_obj which can be used to return=
 the
- * kernel virtual address of the buffer.
- *
- * Code servicing a non-priviliged user request is only allowed to map=
 one
- * page at a time. We might need to implement a better scheme to stop =
such
- * processes from consuming all vmalloc space.
- */
-
-int drm_bo_kmap(struct drm_buffer_object *bo, unsigned long start_page=
,
-		unsigned long num_pages, struct drm_bo_kmap_obj *map)
-{
-	int ret;
-	unsigned long bus_base;
-	unsigned long bus_offset;
-	unsigned long bus_size;
-
-	map->virtual =3D NULL;
-
-	if (num_pages > bo->num_pages)
-		return -EINVAL;
-	if (start_page > bo->num_pages)
-		return -EINVAL;
-	ret =3D drm_bo_pci_offset(bo->dev, &bo->mem, &bus_base,
-				&bus_offset, &bus_size);
-
-	if (ret)
-		return ret;
-
-	if (bus_size =3D=3D 0) {
-		return drm_bo_kmap_ttm(bo, start_page, num_pages, map);
-	} else {
-		bus_offset +=3D start_page << PAGE_SHIFT;
-		bus_size =3D num_pages << PAGE_SHIFT;
-		return drm_bo_ioremap(bo, bus_base, bus_offset, bus_size, map);
-	}
-}
-EXPORT_SYMBOL(drm_bo_kmap);
-
-void drm_bo_kunmap(struct drm_bo_kmap_obj *map)
-{
-	if (!map->virtual)
-		return;
-
-	switch (map->bo_kmap_type) {
-	case bo_map_iomap:
-		iounmap(map->virtual);
-		break;
-	case bo_map_vmap:
-		vunmap(map->virtual);
-		break;
-	case bo_map_kmap:
-		kunmap(map->page);
-		break;
-	case bo_map_premapped:
-		break;
-	default:
-		BUG();
-	}
-	map->virtual =3D NULL;
-	map->page =3D NULL;
-}
-EXPORT_SYMBOL(drm_bo_kunmap);
-
-int drm_bo_pfn_prot(struct drm_buffer_object *bo,
-		    unsigned long dst_offset,
-		    unsigned long *pfn,
-		    pgprot_t *prot)
-{
-	struct drm_bo_mem_reg *mem =3D &bo->mem;
-	struct drm_device *dev =3D bo->dev;
-	unsigned long bus_offset;
-	unsigned long bus_size;
-	unsigned long bus_base;
-	struct drm_mem_type_manager *man =3D &dev->bm.man[mem->mem_type];
-	int ret;
-
-	ret =3D drm_bo_pci_offset(dev, mem, &bus_base, &bus_offset,
-				&bus_size);
-	if (ret)
-		return -EINVAL;
-
-	if (bus_size !=3D 0)
-		*pfn =3D (bus_base + bus_offset + dst_offset) >> PAGE_SHIFT;
-	else if (!bo->ttm)
-		return -EINVAL;
-	else
-		*pfn =3D page_to_pfn(drm_ttm_get_page(bo->ttm, dst_offset >> PAGE_SH=
IFT));
-
-	*prot =3D (mem->flags & DRM_BO_FLAG_CACHED) ?
-		PAGE_KERNEL : drm_kernel_io_prot(man->drm_bus_maptype);
-
-	return 0;
-}
-EXPORT_SYMBOL(drm_bo_pfn_prot);
-
diff -puN drivers/char/drm/drm_bufs.c~revert-git-drm drivers/char/drm/d=
rm_bufs.c
--- a/drivers/char/drm/drm_bufs.c~revert-git-drm
+++ a/drivers/char/drm/drm_bufs.c
@@ -46,6 +46,7 @@ unsigned long drm_get_resource_len(struc
 {
 	return pci_resource_len(dev->pdev, resource);
 }
+
 EXPORT_SYMBOL(drm_get_resource_len);
=20
 static struct drm_map_list *drm_find_matching_map(struct drm_device *d=
ev,
@@ -55,7 +56,7 @@ static struct drm_map_list *drm_find_mat
 	list_for_each_entry(entry, &dev->maplist, head) {
 		if (entry->map && map->type =3D=3D entry->map->type &&
 		    ((entry->map->offset =3D=3D map->offset) ||
-		     (map->type =3D=3D _DRM_SHM && map->flags =3D=3D _DRM_CONTAINS_L=
OCK))) {
+		     (map->type =3D=3D _DRM_SHM && map->flags=3D=3D_DRM_CONTAINS_LOC=
K))) {
 			return entry;
 		}
 	}
@@ -100,10 +101,10 @@ static int drm_map_handle(struct drm_dev
  * type.  Adds the map to the map list drm_device::maplist. Adds MTRR'=
s where
  * applicable and if supported by the kernel.
  */
-static int drm_addmap_core(struct drm_device *dev, unsigned int offset=
,
+static int drm_addmap_core(struct drm_device * dev, unsigned int offse=
t,
 			   unsigned int size, enum drm_map_type type,
 			   enum drm_map_flags flags,
-			   struct drm_map_list **maplist)
+			   struct drm_map_list ** maplist)
 {
 	struct drm_map *map;
 	struct drm_map_list *list;
@@ -188,7 +189,7 @@ static int drm_addmap_core(struct drm_de
 	case _DRM_SHM:
 		list =3D drm_find_matching_map(dev, map);
 		if (list !=3D NULL) {
-			if (list->map->size !=3D map->size) {
+			if(list->map->size !=3D map->size) {
 				DRM_DEBUG("Matching maps of type %d with "
 					  "mismatched sizes, (%ld vs %ld)\n",
 					  map->type, map->size, list->map->size);
@@ -322,9 +323,9 @@ static int drm_addmap_core(struct drm_de
 	return 0;
 	}
=20
-int drm_addmap(struct drm_device *dev, unsigned int offset,
+int drm_addmap(struct drm_device * dev, unsigned int offset,
 	       unsigned int size, enum drm_map_type type,
-	       enum drm_map_flags flags, drm_local_map_t **map_ptr)
+	       enum drm_map_flags flags, drm_local_map_t ** map_ptr)
 {
 	struct drm_map_list *list;
 	int rc;
@@ -334,6 +335,7 @@ int drm_addmap(struct drm_device *dev, u
 		*map_ptr =3D list->map;
 	return rc;
 }
+
 EXPORT_SYMBOL(drm_addmap);
=20
 int drm_addmap_ioctl(struct drm_device *dev, void *data,
@@ -417,8 +419,6 @@ int drm_rmmap_locked(struct drm_device *
 		dmah.size =3D map->size;
 		__drm_pci_free(dev, &dmah);
 		break;
-	case _DRM_TTM:
-		BUG_ON(1);
 	}
 	drm_free(map, sizeof(*map), DRM_MEM_MAPS);
=20
@@ -493,15 +493,16 @@ int drm_rmmap_ioctl(struct drm_device *d
  *
  * Frees any pages and buffers associated with the given entry.
  */
-static void drm_cleanup_buf_error(struct drm_device *dev,
-				  struct drm_buf_entry *entry)
+static void drm_cleanup_buf_error(struct drm_device * dev,
+				  struct drm_buf_entry * entry)
 {
 	int i;
=20
 	if (entry->seg_count) {
 		for (i =3D 0; i < entry->seg_count; i++) {
-			if (entry->seglist[i])
+			if (entry->seglist[i]) {
 				drm_pci_free(dev, entry->seglist[i]);
+			}
 		}
 		drm_free(entry->seglist,
 			 entry->seg_count *
@@ -538,7 +539,7 @@ static void drm_cleanup_buf_error(struct
  * reallocates the buffer list of the same size order to accommodate t=
he new
  * buffers.
  */
-int drm_addbufs_agp(struct drm_device *dev, struct drm_buf_desc *reque=
st)
+int drm_addbufs_agp(struct drm_device * dev, struct drm_buf_desc * req=
uest)
 {
 	struct drm_device_dma *dma =3D dev->dma;
 	struct drm_buf_entry *entry;
@@ -683,8 +684,9 @@ int drm_addbufs_agp(struct drm_device *d
 	}
 	dma->buflist =3D temp_buflist;
=20
-	for (i =3D 0; i < entry->buf_count; i++)
+	for (i =3D 0; i < entry->buf_count; i++) {
 		dma->buflist[i + dma->buf_count] =3D &entry->buflist[i];
+	}
=20
 	dma->buf_count +=3D entry->buf_count;
 	dma->seg_count +=3D entry->seg_count;
@@ -707,7 +709,7 @@ int drm_addbufs_agp(struct drm_device *d
 EXPORT_SYMBOL(drm_addbufs_agp);
 #endif				/* __OS_HAS_AGP */
=20
-int drm_addbufs_pci(struct drm_device *dev, struct drm_buf_desc *reque=
st)
+int drm_addbufs_pci(struct drm_device * dev, struct drm_buf_desc * req=
uest)
 {
 	struct drm_device_dma *dma =3D dev->dma;
 	int count;
@@ -900,8 +902,9 @@ int drm_addbufs_pci(struct drm_device *d
 	}
 	dma->buflist =3D temp_buflist;
=20
-	for (i =3D 0; i < entry->buf_count; i++)
+	for (i =3D 0; i < entry->buf_count; i++) {
 		dma->buflist[i + dma->buf_count] =3D &entry->buflist[i];
+	}
=20
 	/* No allocations failed, so now we can replace the orginal pagelist
 	 * with the new one.
@@ -1094,7 +1097,7 @@ static int drm_addbufs_sg(struct drm_dev
 	return 0;
 }
=20
-static int drm_addbufs_fb(struct drm_device *dev, struct drm_buf_desc =
*request)
+static int drm_addbufs_fb(struct drm_device * dev, struct drm_buf_desc=
 * request)
 {
 	struct drm_device_dma *dma =3D dev->dma;
 	struct drm_buf_entry *entry;
@@ -1231,8 +1234,9 @@ static int drm_addbufs_fb(struct drm_dev
 	}
 	dma->buflist =3D temp_buflist;
=20
-	for (i =3D 0; i < entry->buf_count; i++)
+	for (i =3D 0; i < entry->buf_count; i++) {
 		dma->buflist[i + dma->buf_count] =3D &entry->buflist[i];
+	}
=20
 	dma->buf_count +=3D entry->buf_count;
 	dma->seg_count +=3D entry->seg_count;
@@ -1483,7 +1487,7 @@ int drm_freebufs(struct drm_device *dev,
  * drm_mmap_dma().
  */
 int drm_mapbufs(struct drm_device *dev, void *data,
-		struct drm_file *file_priv)
+	        struct drm_file *file_priv)
 {
 	struct drm_device_dma *dma =3D dev->dma;
 	int retcode =3D 0;
@@ -1566,7 +1570,7 @@ int drm_mapbufs(struct drm_device *dev,=20
 			}
 		}
 	}
-done:
+      done:
 	request->count =3D dma->buf_count;
 	DRM_DEBUG("%d buffers, retcode =3D %d\n", request->count, retcode);
=20
diff -puN drivers/char/drm/drm_context.c~revert-git-drm drivers/char/dr=
m/drm_context.c
--- a/drivers/char/drm/drm_context.c~revert-git-drm
+++ a/drivers/char/drm/drm_context.c
@@ -195,11 +195,11 @@ int drm_setsareactx(struct drm_device *d
 		    && r_list->user_token =3D=3D (unsigned long) request->handle)
 			goto found;
 	}
-bad:
+      bad:
 	mutex_unlock(&dev->struct_mutex);
 	return -EINVAL;
=20
-found:
+      found:
 	map =3D r_list->map;
 	if (!map)
 		goto bad;
diff -puN drivers/char/drm/drm_drv.c~revert-git-drm drivers/char/drm/dr=
m_drv.c
--- a/drivers/char/drm/drm_drv.c~revert-git-drm
+++ a/drivers/char/drm/drm_drv.c
@@ -117,34 +117,6 @@ static struct drm_ioctl_desc drm_ioctls[
 	DRM_IOCTL_DEF(DRM_IOCTL_WAIT_VBLANK, drm_wait_vblank, 0),
=20
 	DRM_IOCTL_DEF(DRM_IOCTL_UPDATE_DRAW, drm_update_drawable_info, DRM_AU=
TH|DRM_MASTER|DRM_ROOT_ONLY),
-
-	DRM_IOCTL_DEF(DRM_IOCTL_MM_INIT, drm_mm_init_ioctl,
-		      DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
-	DRM_IOCTL_DEF(DRM_IOCTL_MM_TAKEDOWN, drm_mm_takedown_ioctl,
-		      DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
-	DRM_IOCTL_DEF(DRM_IOCTL_MM_LOCK, drm_mm_lock_ioctl,
-		      DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
-	DRM_IOCTL_DEF(DRM_IOCTL_MM_UNLOCK, drm_mm_unlock_ioctl,
-		      DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
-
-	DRM_IOCTL_DEF(DRM_IOCTL_FENCE_CREATE, drm_fence_create_ioctl, DRM_AUT=
H),
-	DRM_IOCTL_DEF(DRM_IOCTL_FENCE_REFERENCE, drm_fence_reference_ioctl, D=
RM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_FENCE_UNREFERENCE, drm_fence_unreference_ioct=
l, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_FENCE_SIGNALED, drm_fence_signaled_ioctl, DRM=
_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_FENCE_FLUSH, drm_fence_flush_ioctl, DRM_AUTH)=
,
-	DRM_IOCTL_DEF(DRM_IOCTL_FENCE_WAIT, drm_fence_wait_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_FENCE_EMIT, drm_fence_emit_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_FENCE_BUFFERS, drm_fence_buffers_ioctl, DRM_A=
UTH),
-
-	DRM_IOCTL_DEF(DRM_IOCTL_BO_CREATE, drm_bo_create_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_BO_MAP, drm_bo_map_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_BO_UNMAP, drm_bo_unmap_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_BO_REFERENCE, drm_bo_reference_ioctl, DRM_AUT=
H),
-	DRM_IOCTL_DEF(DRM_IOCTL_BO_UNREFERENCE, drm_bo_unreference_ioctl, DRM=
_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_BO_SETSTATUS, drm_bo_setstatus_ioctl, DRM_AUT=
H),
-	DRM_IOCTL_DEF(DRM_IOCTL_BO_INFO, drm_bo_info_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_BO_WAIT_IDLE, drm_bo_wait_idle_ioctl, DRM_AUT=
H),
-	DRM_IOCTL_DEF(DRM_IOCTL_BO_VERSION, drm_bo_version_ioctl, 0),
 };
=20
 #define DRM_CORE_IOCTL_COUNT	ARRAY_SIZE( drm_ioctls )
@@ -167,8 +139,6 @@ int drm_lastclose(struct drm_device * de
=20
 	DRM_DEBUG("\n");
=20
-	drm_bo_driver_finish(dev);
-
 	if (dev->driver->lastclose)
 		dev->driver->lastclose(dev);
 	DRM_DEBUG("driver lastclose completed\n");
@@ -226,7 +196,7 @@ int drm_lastclose(struct drm_device * de
 	/* Clear vma list (only built for debugging) */
 	list_for_each_entry_safe(vma, vma_temp, &dev->vmalist, head) {
 		list_del(&vma->head);
-		drm_ctl_free(vma, sizeof(*vma), DRM_MEM_VMAS);
+		drm_free(vma, sizeof(*vma), DRM_MEM_VMAS);
 	}
=20
 	list_for_each_entry_safe(r_list, list_t, &dev->maplist, head) {
@@ -260,7 +230,6 @@ int drm_lastclose(struct drm_device * de
 		dev->lock.file_priv =3D NULL;
 		wake_up_interruptible(&dev->lock.lock_queue);
 	}
-	dev->dev_mapping =3D NULL;
 	mutex_unlock(&dev->struct_mutex);
=20
 	DRM_DEBUG("lastclose completed\n");
@@ -323,7 +292,6 @@ static void drm_cleanup(struct drm_devic
 	}
=20
 	drm_lastclose(dev);
-	drm_fence_manager_takedown(dev);
=20
 	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) &&
 	    dev->agp && dev->agp->agp_mtrr >=3D 0) {
@@ -343,8 +311,6 @@ static void drm_cleanup(struct drm_devic
 		dev->driver->unload(dev);
=20
 	drm_ht_remove(&dev->map_hash);
-	drm_mm_takedown(&dev->offset_manager);
-	drm_ht_remove(&dev->object_hash);
 	drm_ctxbitmap_cleanup(dev);
=20
 	drm_put_head(&dev->primary);
@@ -389,32 +355,8 @@ static const struct file_operations drm_
=20
 static int __init drm_core_init(void)
 {
-	int ret;
-	struct sysinfo si;
-	unsigned long avail_memctl_mem;
-	unsigned long max_memctl_mem;
-
-	si_meminfo(&si);
-
-	/*
-	 * AGP only allows low / DMA32 memory ATM.
-	 */
-
-	avail_memctl_mem =3D si.totalram - si.totalhigh;
+	int ret =3D -ENOMEM;
=20
-	/*
-	 * Avoid overflows
-	 */
-
-	max_memctl_mem =3D 1UL << (32 - PAGE_SHIFT);
-	max_memctl_mem =3D (max_memctl_mem / si.mem_unit) * PAGE_SIZE;
-
-	if (avail_memctl_mem >=3D max_memctl_mem)
-		avail_memctl_mem =3D max_memctl_mem;
-
-	drm_init_memctl(avail_memctl_mem/2, avail_memctl_mem*3/4, si.mem_unit=
);
-
-	ret =3D -ENOMEM;
 	drm_cards_limit =3D
 	    (drm_cards_limit <
 	     DRM_MAX_MINOR + 1 ? drm_cards_limit : DRM_MAX_MINOR + 1);
@@ -575,13 +517,15 @@ int drm_ioctl(struct inode *inode, struc
 		}
 	}
=20
-err_i1:
-	kfree(kdata);
+      err_i1:
+	if (kdata)
+		kfree(kdata);
 	atomic_dec(&dev->ioctl_count);
 	if (retcode)
 		DRM_DEBUG("ret =3D %x\n", retcode);
 	return retcode;
 }
+
 EXPORT_SYMBOL(drm_ioctl);
=20
 drm_local_map_t *drm_getsarea(struct drm_device *dev)
diff -puN drivers/char/drm/drm_fence.c~revert-git-drm /dev/null
--- a/drivers/char/drm/drm_fence.c
+++ /dev/null
@@ -1,824 +0,0 @@
-/*********************************************************************=
*****
- *
- * Copyright (c) 2006-2007 Tungsten Graphics, Inc., Cedar Park, TX., U=
SA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaini=
ng a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject =
to
- * the following conditions:
- *
- * The above copyright notice and this permission notice (including th=
e
- * next paragraph) shall be included in all copies or substantial port=
ions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT =
SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR A=
NY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT =
OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE =
OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- *********************************************************************=
*****/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#include "drmP.h"
-
-
-/*
- * Convenience function to be called by fence::wait methods that
- * need polling.
- */
-
-int drm_fence_wait_polling(struct drm_fence_object *fence, int lazy,
-			   int interruptible, uint32_t mask,
-			   unsigned long end_jiffies)
-{
-	struct drm_device *dev =3D fence->dev;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[fence->fence_=
class];
-	uint32_t count =3D 0;
-	int ret;
-
-	DECLARE_WAITQUEUE(entry, current);
-	add_wait_queue(&fc->fence_queue, &entry);
-
-	ret =3D 0;
-
-	for (;;) {
-		__set_current_state((interruptible) ?
-				    TASK_INTERRUPTIBLE :
-				    TASK_UNINTERRUPTIBLE);
-		if (drm_fence_object_signaled(fence, mask))
-			break;
-		if (time_after_eq(jiffies, end_jiffies)) {
-			ret =3D -EBUSY;
-			break;
-		}
-		if (lazy)
-			schedule_timeout(1);
-		else if ((++count & 0x0F) =3D=3D 0) {
-			__set_current_state(TASK_RUNNING);
-			schedule();
-			__set_current_state((interruptible) ?
-					    TASK_INTERRUPTIBLE :
-					    TASK_UNINTERRUPTIBLE);
-		}
-		if (interruptible && signal_pending(current)) {
-			ret =3D -EAGAIN;
-			break;
-		}
-	}
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&fc->fence_queue, &entry);
-	return ret;
-}
-EXPORT_SYMBOL(drm_fence_wait_polling);
-
-/*
- * Typically called by the IRQ handler.
- */
-
-void drm_fence_handler(struct drm_device *dev, uint32_t fence_class,
-		       uint32_t sequence, uint32_t type, uint32_t error)
-{
-	int wake =3D 0;
-	uint32_t diff;
-	uint32_t relevant_type;
-	uint32_t new_type;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[fence_class];
-	struct drm_fence_driver *driver =3D dev->driver->fence_driver;
-	struct list_head *head;
-	struct drm_fence_object *fence, *next;
-	int found =3D 0;
-
-	if (list_empty(&fc->ring))
-		return;
-
-	list_for_each_entry(fence, &fc->ring, ring) {
-		diff =3D (sequence - fence->sequence) & driver->sequence_mask;
-		if (diff > driver->wrap_diff) {
-			found =3D 1;
-			break;
-		}
-	}
-
-	fc->waiting_types &=3D ~type;
-	head =3D (found) ? &fence->ring : &fc->ring;
-
-	list_for_each_entry_safe_reverse(fence, next, head, ring) {
-		if (&fence->ring =3D=3D &fc->ring)
-			break;
-
-		if (error) {
-			fence->error =3D error;
-			fence->signaled_types =3D fence->type;
-			list_del_init(&fence->ring);
-			wake =3D 1;
-			break;
-		}
-
-		if (type & DRM_FENCE_TYPE_EXE)
-			type |=3D fence->native_types;
-
-		relevant_type =3D type & fence->type;
-		new_type =3D (fence->signaled_types | relevant_type) ^
-			fence->signaled_types;
-
-		if (new_type) {
-			fence->signaled_types |=3D new_type;
-			DRM_DEBUG("Fence 0x%08lx signaled 0x%08x\n",
-				  fence->base.hash.key, fence->signaled_types);
-
-			if (driver->needed_flush)
-				fc->pending_flush |=3D driver->needed_flush(fence);
-
-			if (new_type & fence->waiting_types)
-				wake =3D 1;
-		}
-
-		fc->waiting_types |=3D fence->waiting_types & ~fence->signaled_types=
;
-
-		if (!(fence->type & ~fence->signaled_types)) {
-			DRM_DEBUG("Fence completely signaled 0x%08lx\n",
-				  fence->base.hash.key);
-			list_del_init(&fence->ring);
-		}
-	}
-
-	/*
-	 * Reinstate lost waiting types.
-	 */
-
-	if ((fc->waiting_types & type) !=3D type) {
-		head =3D head->prev;
-		list_for_each_entry(fence, head, ring) {
-			if (&fence->ring =3D=3D &fc->ring)
-				break;
-			diff =3D (fc->highest_waiting_sequence - fence->sequence) &
-				driver->sequence_mask;
-			if (diff > driver->wrap_diff)
-				break;
-
-			fc->waiting_types |=3D fence->waiting_types & ~fence->signaled_type=
s;
-		}
-	}
-
-	if (wake)
-		wake_up_all(&fc->fence_queue);
-}
-EXPORT_SYMBOL(drm_fence_handler);
-
-static void drm_fence_unring(struct drm_device *dev, struct list_head =
*ring)
-{
-	struct drm_fence_manager *fm =3D &dev->fm;
-	unsigned long flags;
-
-	write_lock_irqsave(&fm->lock, flags);
-	list_del_init(ring);
-	write_unlock_irqrestore(&fm->lock, flags);
-}
-
-void drm_fence_usage_deref_locked(struct drm_fence_object **fence)
-{
-	struct drm_fence_object *tmp_fence =3D *fence;
-	struct drm_device *dev =3D tmp_fence->dev;
-	struct drm_fence_manager *fm =3D &dev->fm;
-
-	DRM_ASSERT_LOCKED(&dev->struct_mutex);
-	*fence =3D NULL;
-	if (atomic_dec_and_test(&tmp_fence->usage)) {
-		drm_fence_unring(dev, &tmp_fence->ring);
-		DRM_DEBUG("Destroyed a fence object 0x%08lx\n",
-			  tmp_fence->base.hash.key);
-		atomic_dec(&fm->count);
-		BUG_ON(!list_empty(&tmp_fence->base.list));
-		drm_ctl_free(tmp_fence, sizeof(*tmp_fence), DRM_MEM_FENCE);
-	}
-}
-EXPORT_SYMBOL(drm_fence_usage_deref_locked);
-
-void drm_fence_usage_deref_unlocked(struct drm_fence_object **fence)
-{
-	struct drm_fence_object *tmp_fence =3D *fence;
-	struct drm_device *dev =3D tmp_fence->dev;
-	struct drm_fence_manager *fm =3D &dev->fm;
-
-	*fence =3D NULL;
-	if (atomic_dec_and_test(&tmp_fence->usage)) {
-		mutex_lock(&dev->struct_mutex);
-		if (atomic_read(&tmp_fence->usage) =3D=3D 0) {
-			drm_fence_unring(dev, &tmp_fence->ring);
-			atomic_dec(&fm->count);
-			BUG_ON(!list_empty(&tmp_fence->base.list));
-			drm_ctl_free(tmp_fence, sizeof(*tmp_fence), DRM_MEM_FENCE);
-		}
-		mutex_unlock(&dev->struct_mutex);
-	}
-}
-EXPORT_SYMBOL(drm_fence_usage_deref_unlocked);
-
-struct drm_fence_object
-*drm_fence_reference_locked(struct drm_fence_object *src)
-{
-	DRM_ASSERT_LOCKED(&src->dev->struct_mutex);
-
-	atomic_inc(&src->usage);
-	return src;
-}
-
-void drm_fence_reference_unlocked(struct drm_fence_object **dst,
-				  struct drm_fence_object *src)
-{
-	mutex_lock(&src->dev->struct_mutex);
-	*dst =3D src;
-	atomic_inc(&src->usage);
-	mutex_unlock(&src->dev->struct_mutex);
-}
-EXPORT_SYMBOL(drm_fence_reference_unlocked);
-
-static void drm_fence_object_destroy(struct drm_file *priv,
-				     struct drm_user_object *base)
-{
-	struct drm_fence_object *fence =3D
-	    drm_user_object_entry(base, struct drm_fence_object, base);
-
-	drm_fence_usage_deref_locked(&fence);
-}
-
-int drm_fence_object_signaled(struct drm_fence_object *fence, uint32_t=
 mask)
-{
-	unsigned long flags;
-	int signaled;
-	struct drm_device *dev =3D fence->dev;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_driver *driver =3D dev->driver->fence_driver;
-
-	mask &=3D fence->type;
-	read_lock_irqsave(&fm->lock, flags);
-	signaled =3D (mask & fence->signaled_types) =3D=3D mask;
-	read_unlock_irqrestore(&fm->lock, flags);
-	if (!signaled && driver->poll) {
-		write_lock_irqsave(&fm->lock, flags);
-		driver->poll(dev, fence->fence_class, mask);
-		signaled =3D (mask & fence->signaled_types) =3D=3D mask;
-		write_unlock_irqrestore(&fm->lock, flags);
-	}
-	return signaled;
-}
-EXPORT_SYMBOL(drm_fence_object_signaled);
-
-
-int drm_fence_object_flush(struct drm_fence_object *fence,
-			   uint32_t type)
-{
-	struct drm_device *dev =3D fence->dev;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[fence->fence_=
class];
-	struct drm_fence_driver *driver =3D dev->driver->fence_driver;
-	unsigned long irq_flags;
-	uint32_t saved_pending_flush;
-	uint32_t diff;
-	int call_flush;
-
-	if (type & ~fence->type) {
-		DRM_ERROR("Flush trying to extend fence type, "
-			  "0x%x, 0x%x\n", type, fence->type);
-		return -EINVAL;
-	}
-
-	write_lock_irqsave(&fm->lock, irq_flags);
-	fence->waiting_types |=3D type;
-	fc->waiting_types |=3D fence->waiting_types;
-	diff =3D (fence->sequence - fc->highest_waiting_sequence) &
-		driver->sequence_mask;
-
-	if (diff < driver->wrap_diff)
-		fc->highest_waiting_sequence =3D fence->sequence;
-
-	/*
-	 * fence->waiting_types has changed. Determine whether
-	 * we need to initiate some kind of flush as a result of this.
-	 */
-
-	saved_pending_flush =3D fc->pending_flush;
-	if (driver->needed_flush)
-		fc->pending_flush |=3D driver->needed_flush(fence);
-
-	if (driver->poll)
-		driver->poll(dev, fence->fence_class, fence->waiting_types);
-
-	call_flush =3D fc->pending_flush;
-	write_unlock_irqrestore(&fm->lock, irq_flags);
-
-	if (call_flush && driver->flush)
-		driver->flush(dev, fence->fence_class);
-
-	return 0;
-}
-EXPORT_SYMBOL(drm_fence_object_flush);
-
-/*
- * Make sure old fence objects are signaled before their fence sequenc=
es are
- * wrapped around and reused.
- */
-
-void drm_fence_flush_old(struct drm_device *dev, uint32_t fence_class,
-			 uint32_t sequence)
-{
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[fence_class];
-	struct drm_fence_object *fence;
-	unsigned long irq_flags;
-	struct drm_fence_driver *driver =3D dev->driver->fence_driver;
-	int call_flush;
-
-	uint32_t diff;
-
-	write_lock_irqsave(&fm->lock, irq_flags);
-
-	list_for_each_entry_reverse(fence, &fc->ring, ring) {
-		diff =3D (sequence - fence->sequence) & driver->sequence_mask;
-		if (diff <=3D driver->flush_diff)
-			break;
-
-		fence->waiting_types =3D fence->type;
-		fc->waiting_types |=3D fence->type;
-
-		if (driver->needed_flush)
-			fc->pending_flush |=3D driver->needed_flush(fence);
-	}
-
-	if (driver->poll)
-		driver->poll(dev, fence_class, fc->waiting_types);
-
-	call_flush =3D fc->pending_flush;
-	write_unlock_irqrestore(&fm->lock, irq_flags);
-
-	if (call_flush && driver->flush)
-		driver->flush(dev, fence->fence_class);
-
-	/*
-	 * FIXME: Shold we implement a wait here for really old fences?
-	 */
-
-}
-EXPORT_SYMBOL(drm_fence_flush_old);
-
-int drm_fence_object_wait(struct drm_fence_object *fence,
-			  int lazy, int ignore_signals, uint32_t mask)
-{
-	struct drm_device *dev =3D fence->dev;
-	struct drm_fence_driver *driver =3D dev->driver->fence_driver;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[fence->fence_=
class];
-	int ret =3D 0;
-	unsigned long _end =3D 3 * DRM_HZ;
-
-	if (mask & ~fence->type) {
-		DRM_ERROR("Wait trying to extend fence type"
-			  " 0x%08x 0x%08x\n", mask, fence->type);
-		BUG();
-		return -EINVAL;
-	}
-
-	if (driver->wait)
-		return driver->wait(fence, lazy, !ignore_signals, mask);
-
-
-	drm_fence_object_flush(fence, mask);
-	if (driver->has_irq(dev, fence->fence_class, mask)) {
-		if (!ignore_signals)
-			ret =3D wait_event_interruptible_timeout
-				(fc->fence_queue,
-				 drm_fence_object_signaled(fence, mask),
-				 3 * DRM_HZ);
-		else
-			ret =3D wait_event_timeout
-				(fc->fence_queue,
-				 drm_fence_object_signaled(fence, mask),
-				 3 * DRM_HZ);
-
-		if (unlikely(ret =3D=3D -ERESTARTSYS))
-			return -EAGAIN;
-
-		if (unlikely(ret =3D=3D 0))
-			return -EBUSY;
-
-		return 0;
-	}
-
-	return drm_fence_wait_polling(fence, lazy, !ignore_signals, mask,
-				      _end);
-}
-EXPORT_SYMBOL(drm_fence_object_wait);
-
-
-
-int drm_fence_object_emit(struct drm_fence_object *fence, uint32_t fen=
ce_flags,
-			  uint32_t fence_class, uint32_t type)
-{
-	struct drm_device *dev =3D fence->dev;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_driver *driver =3D dev->driver->fence_driver;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[fence->fence_=
class];
-	unsigned long flags;
-	uint32_t sequence;
-	uint32_t native_types;
-	int ret;
-
-	drm_fence_unring(dev, &fence->ring);
-	ret =3D driver->emit(dev, fence_class, fence_flags, &sequence,
-			   &native_types);
-	if (ret)
-		return ret;
-
-	write_lock_irqsave(&fm->lock, flags);
-	fence->fence_class =3D fence_class;
-	fence->type =3D type;
-	fence->waiting_types =3D 0;
-	fence->signaled_types =3D 0;
-	fence->sequence =3D sequence;
-	fence->native_types =3D native_types;
-	if (list_empty(&fc->ring))
-		fc->highest_waiting_sequence =3D sequence - 1;
-	list_add_tail(&fence->ring, &fc->ring);
-	fc->latest_queued_sequence =3D sequence;
-	write_unlock_irqrestore(&fm->lock, flags);
-	return 0;
-}
-EXPORT_SYMBOL(drm_fence_object_emit);
-
-static int drm_fence_object_init(struct drm_device *dev, uint32_t fenc=
e_class,
-				 uint32_t type,
-				 uint32_t fence_flags,
-				 struct drm_fence_object *fence)
-{
-	int ret =3D 0;
-	unsigned long flags;
-	struct drm_fence_manager *fm =3D &dev->fm;
-
-	mutex_lock(&dev->struct_mutex);
-	atomic_set(&fence->usage, 1);
-	mutex_unlock(&dev->struct_mutex);
-
-	write_lock_irqsave(&fm->lock, flags);
-	INIT_LIST_HEAD(&fence->ring);
-
-	/*
-	 *  Avoid hitting BUG() for kernel-only fence objects.
-	 */
-
-	INIT_LIST_HEAD(&fence->base.list);
-	fence->fence_class =3D fence_class;
-	fence->type =3D type;
-	fence->signaled_types =3D 0;
-	fence->waiting_types =3D 0;
-	fence->sequence =3D 0;
-	fence->dev =3D dev;
-	write_unlock_irqrestore(&fm->lock, flags);
-	if (fence_flags & DRM_FENCE_FLAG_EMIT) {
-		ret =3D drm_fence_object_emit(fence, fence_flags,
-					    fence->fence_class, type);
-	}
-	return ret;
-}
-
-int drm_fence_add_user_object(struct drm_file *priv,
-			      struct drm_fence_object *fence, int shareable)
-{
-	struct drm_device *dev =3D priv->head->dev;
-	int ret;
-
-	mutex_lock(&dev->struct_mutex);
-	ret =3D drm_add_user_object(priv, &fence->base, shareable);
-	if (ret)
-		goto out;
-	atomic_inc(&fence->usage);
-	fence->base.type =3D drm_fence_type;
-	fence->base.remove =3D &drm_fence_object_destroy;
-	DRM_DEBUG("Fence 0x%08lx created\n", fence->base.hash.key);
-out:
-	mutex_unlock(&dev->struct_mutex);
-	return ret;
-}
-EXPORT_SYMBOL(drm_fence_add_user_object);
-
-int drm_fence_object_create(struct drm_device *dev, uint32_t fence_cla=
ss,
-			    uint32_t type, unsigned flags,
-			    struct drm_fence_object **c_fence)
-{
-	struct drm_fence_object *fence;
-	int ret;
-	struct drm_fence_manager *fm =3D &dev->fm;
-
-	fence =3D drm_ctl_calloc(1, sizeof(*fence), DRM_MEM_FENCE);
-	if (!fence)
-		return -ENOMEM;
-	ret =3D drm_fence_object_init(dev, fence_class, type, flags, fence);
-	if (ret) {
-		drm_fence_usage_deref_unlocked(&fence);
-		return ret;
-	}
-	*c_fence =3D fence;
-	atomic_inc(&fm->count);
-
-	return 0;
-}
-EXPORT_SYMBOL(drm_fence_object_create);
-
-void drm_fence_manager_init(struct drm_device *dev)
-{
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fence_class;
-	struct drm_fence_driver *fed =3D dev->driver->fence_driver;
-	int i;
-	unsigned long flags;
-
-	rwlock_init(&fm->lock);
-	write_lock_irqsave(&fm->lock, flags);
-	fm->initialized =3D 0;
-	if (!fed)
-	    goto out_unlock;
-
-	fm->initialized =3D 1;
-	fm->num_classes =3D fed->num_classes;
-	BUG_ON(fm->num_classes > _DRM_FENCE_CLASSES);
-
-	for (i =3D 0; i < fm->num_classes; ++i) {
-		fence_class =3D &fm->fence_class[i];
-		memset(fence_class, 0, sizeof(*fence_class));
-		INIT_LIST_HEAD(&fence_class->ring);
-		DRM_INIT_WAITQUEUE(&fence_class->fence_queue);
-	}
-
-	atomic_set(&fm->count, 0);
- out_unlock:
-	write_unlock_irqrestore(&fm->lock, flags);
-}
-
-void drm_fence_fill_arg(struct drm_fence_object *fence,
-			struct drm_fence_arg *arg)
-{
-	struct drm_device *dev =3D fence->dev;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	unsigned long irq_flags;
-
-	read_lock_irqsave(&fm->lock, irq_flags);
-	arg->handle =3D fence->base.hash.key;
-	arg->fence_class =3D fence->fence_class;
-	arg->type =3D fence->type;
-	arg->signaled =3D fence->signaled_types;
-	arg->error =3D fence->error;
-	arg->sequence =3D fence->sequence;
-	read_unlock_irqrestore(&fm->lock, irq_flags);
-}
-EXPORT_SYMBOL(drm_fence_fill_arg);
-
-void drm_fence_manager_takedown(struct drm_device *dev)
-{
-}
-
-struct drm_fence_object *drm_lookup_fence_object(struct drm_file *priv=
,
-						 uint32_t handle)
-{
-	struct drm_device *dev =3D priv->head->dev;
-	struct drm_user_object *uo;
-	struct drm_fence_object *fence;
-
-	mutex_lock(&dev->struct_mutex);
-	uo =3D drm_lookup_user_object(priv, handle);
-	if (!uo || (uo->type !=3D drm_fence_type)) {
-		mutex_unlock(&dev->struct_mutex);
-		return NULL;
-	}
-	fence =3D drm_fence_reference_locked(drm_user_object_entry(uo, struct=
 drm_fence_object, base));
-	mutex_unlock(&dev->struct_mutex);
-	return fence;
-}
-
-int drm_fence_create_ioctl(struct drm_device *dev, void *data, struct =
drm_file *file_priv)
-{
-	int ret;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_arg *arg =3D data;
-	struct drm_fence_object *fence;
-	ret =3D 0;
-
-	if (!fm->initialized) {
-		DRM_ERROR("The DRM driver does not support fencing.\n");
-		return -EINVAL;
-	}
-
-	if (arg->flags & DRM_FENCE_FLAG_EMIT)
-		LOCK_TEST_WITH_RETURN(dev, file_priv);
-	ret =3D drm_fence_object_create(dev, arg->fence_class,
-				      arg->type, arg->flags, &fence);
-	if (ret)
-		return ret;
-	ret =3D drm_fence_add_user_object(file_priv, fence,
-					arg->flags &
-					DRM_FENCE_FLAG_SHAREABLE);
-	if (ret) {
-		drm_fence_usage_deref_unlocked(&fence);
-		return ret;
-	}
-
-	/*
-	 * usage > 0. No need to lock dev->struct_mutex;
-	 */
-
-	arg->handle =3D fence->base.hash.key;
-
-	drm_fence_fill_arg(fence, arg);
-	drm_fence_usage_deref_unlocked(&fence);
-
-	return ret;
-}
-
-int drm_fence_reference_ioctl(struct drm_device *dev, void *data, stru=
ct drm_file *file_priv)
-{
-	int ret;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_arg *arg =3D data;
-	struct drm_fence_object *fence;
-	struct drm_user_object *uo;
-	ret =3D 0;
-
-	if (!fm->initialized) {
-		DRM_ERROR("The DRM driver does not support fencing.\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_user_object_ref(file_priv, arg->handle, drm_fence_type, &=
uo);
-	if (ret)
-		return ret;
-	fence =3D drm_lookup_fence_object(file_priv, arg->handle);
-	drm_fence_fill_arg(fence, arg);
-	drm_fence_usage_deref_unlocked(&fence);
-
-	return ret;
-}
-
-
-int drm_fence_unreference_ioctl(struct drm_device *dev, void *data, st=
ruct drm_file *file_priv)
-{
-	int ret;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_arg *arg =3D data;
-	ret =3D 0;
-
-	if (!fm->initialized) {
-		DRM_ERROR("The DRM driver does not support fencing.\n");
-		return -EINVAL;
-	}
-
-	return drm_user_object_unref(file_priv, arg->handle, drm_fence_type);
-}
-
-int drm_fence_signaled_ioctl(struct drm_device *dev, void *data, struc=
t drm_file *file_priv)
-{
-	int ret;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_arg *arg =3D data;
-	struct drm_fence_object *fence;
-	ret =3D 0;
-
-	if (!fm->initialized) {
-		DRM_ERROR("The DRM driver does not support fencing.\n");
-		return -EINVAL;
-	}
-
-	fence =3D drm_lookup_fence_object(file_priv, arg->handle);
-	if (!fence)
-		return -EINVAL;
-
-	drm_fence_fill_arg(fence, arg);
-	drm_fence_usage_deref_unlocked(&fence);
-
-	return ret;
-}
-
-int drm_fence_flush_ioctl(struct drm_device *dev, void *data, struct d=
rm_file *file_priv)
-{
-	int ret;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_arg *arg =3D data;
-	struct drm_fence_object *fence;
-	ret =3D 0;
-
-	if (!fm->initialized) {
-		DRM_ERROR("The DRM driver does not support fencing.\n");
-		return -EINVAL;
-	}
-
-	fence =3D drm_lookup_fence_object(file_priv, arg->handle);
-	if (!fence)
-		return -EINVAL;
-	ret =3D drm_fence_object_flush(fence, arg->type);
-
-	drm_fence_fill_arg(fence, arg);
-	drm_fence_usage_deref_unlocked(&fence);
-
-	return ret;
-}
-
-
-int drm_fence_wait_ioctl(struct drm_device *dev, void *data, struct dr=
m_file *file_priv)
-{
-	int ret;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_arg *arg =3D data;
-	struct drm_fence_object *fence;
-	ret =3D 0;
-
-	if (!fm->initialized) {
-		DRM_ERROR("The DRM driver does not support fencing.\n");
-		return -EINVAL;
-	}
-
-	fence =3D drm_lookup_fence_object(file_priv, arg->handle);
-	if (!fence)
-		return -EINVAL;
-	ret =3D drm_fence_object_wait(fence,
-				    arg->flags & DRM_FENCE_FLAG_WAIT_LAZY,
-				    0, arg->type);
-
-	drm_fence_fill_arg(fence, arg);
-	drm_fence_usage_deref_unlocked(&fence);
-
-	return ret;
-}
-
-
-int drm_fence_emit_ioctl(struct drm_device *dev, void *data, struct dr=
m_file *file_priv)
-{
-	int ret;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_arg *arg =3D data;
-	struct drm_fence_object *fence;
-	ret =3D 0;
-
-	if (!fm->initialized) {
-		DRM_ERROR("The DRM driver does not support fencing.\n");
-		return -EINVAL;
-	}
-
-	LOCK_TEST_WITH_RETURN(dev, file_priv);
-	fence =3D drm_lookup_fence_object(file_priv, arg->handle);
-	if (!fence)
-		return -EINVAL;
-	ret =3D drm_fence_object_emit(fence, arg->flags, arg->fence_class,
-				    arg->type);
-
-	drm_fence_fill_arg(fence, arg);
-	drm_fence_usage_deref_unlocked(&fence);
-
-	return ret;
-}
-
-int drm_fence_buffers_ioctl(struct drm_device *dev, void *data, struct=
 drm_file *file_priv)
-{
-	int ret;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_arg *arg =3D data;
-	struct drm_fence_object *fence;
-	ret =3D 0;
-
-	if (!fm->initialized) {
-		DRM_ERROR("The DRM driver does not support fencing.\n");
-		return -EINVAL;
-	}
-
-	if (!dev->bm.initialized) {
-		DRM_ERROR("Buffer object manager is not initialized\n");
-		return -EINVAL;
-	}
-	LOCK_TEST_WITH_RETURN(dev, file_priv);
-	ret =3D drm_fence_buffer_objects(dev, NULL, arg->flags,
-				       NULL, &fence);
-	if (ret)
-		return ret;
-
-	if (!(arg->flags & DRM_FENCE_FLAG_NO_USER)) {
-		ret =3D drm_fence_add_user_object(file_priv, fence,
-						arg->flags &
-						DRM_FENCE_FLAG_SHAREABLE);
-		if (ret)
-			return ret;
-	}
-
-	arg->handle =3D fence->base.hash.key;
-
-	drm_fence_fill_arg(fence, arg);
-	drm_fence_usage_deref_unlocked(&fence);
-
-	return ret;
-}
diff -puN drivers/char/drm/drm_fops.c~revert-git-drm drivers/char/drm/d=
rm_fops.c
--- a/drivers/char/drm/drm_fops.c~revert-git-drm
+++ a/drivers/char/drm/drm_fops.c
@@ -147,18 +147,11 @@ int drm_open(struct inode *inode, struct
 		spin_lock(&dev->count_lock);
 		if (!dev->open_count++) {
 			spin_unlock(&dev->count_lock);
-			retcode =3D drm_setup(dev);
-			goto out;
+			return drm_setup(dev);
 		}
 		spin_unlock(&dev->count_lock);
 	}
-out:
-	mutex_lock(&dev->struct_mutex);
-	BUG_ON((dev->dev_mapping !=3D NULL) &&
-	       (dev->dev_mapping !=3D inode->i_mapping));
-	if (dev->dev_mapping =3D=3D NULL)
-		dev->dev_mapping =3D inode->i_mapping;
-	mutex_unlock(&dev->struct_mutex);
+
 	return retcode;
 }
 EXPORT_SYMBOL(drm_open);
@@ -235,7 +228,6 @@ static int drm_open_helper(struct inode=20
 	int minor =3D iminor(inode);
 	struct drm_file *priv;
 	int ret;
-	int i, j;
=20
 	if (filp->f_flags & O_EXCL)
 		return -EBUSY;	/* No exclusive opens */
@@ -261,20 +253,6 @@ static int drm_open_helper(struct inode=20
 	priv->lock_count =3D 0;
=20
 	INIT_LIST_HEAD(&priv->lhead);
-	INIT_LIST_HEAD(&priv->refd_objects);
-
-	for (i =3D 0; i < _DRM_NO_REF_TYPES; ++i) {
-		ret =3D drm_ht_create(&priv->refd_object_hash[i],
-				    DRM_FILE_HASH_ORDER);
-		if (ret)
-			break;
-	}
-
-	if (ret) {
-		for (j =3D 0; j < i; ++j)
-			drm_ht_remove(&priv->refd_object_hash[j]);
-		goto out_free;
-	}
=20
 	if (dev->driver->open) {
 		ret =3D dev->driver->open(dev, priv);
@@ -309,7 +287,7 @@ static int drm_open_helper(struct inode=20
 #endif
=20
 	return 0;
-out_free:
+      out_free:
 	drm_free(priv, sizeof(*priv), DRM_MEM_FILES);
 	filp->private_data =3D NULL;
 	return ret;
@@ -331,32 +309,6 @@ int drm_fasync(int fd, struct file *filp
 }
 EXPORT_SYMBOL(drm_fasync);
=20
-static void drm_object_release(struct file *filp)
-{
-	struct drm_file *priv =3D filp->private_data;
-	struct list_head *head;
-	struct drm_ref_object *ref_object;
-	int i;
-
-	/*
-	 * Free leftover ref objects created by me. Note that we cannot use
-	 * list_for_each() here, as the struct_mutex may be temporarily
-	 * released by the remove_() functions, and thus the lists may be
-	 * altered.
-	 * Also, a drm_remove_ref_object() will not remove it
-	 * from the list unless its refcount is 1.
-	 */
-	head =3D &priv->refd_objects;
-	while (head->next !=3D head) {
-		ref_object =3D list_entry(head->next, struct drm_ref_object, list);
-		drm_remove_ref_object(priv, ref_object);
-		head =3D &priv->refd_objects;
-	}
-
-	for (i =3D 0; i < _DRM_NO_REF_TYPES; ++i)
-		drm_ht_remove(&priv->refd_object_hash[i]);
-}
-
 /**
  * Release file.
  *
@@ -396,7 +348,7 @@ int drm_release(struct inode *inode, str
 		if (drm_i_have_hw_lock(dev, file_priv)) {
 			dev->driver->reclaim_buffers_locked(dev, file_priv);
 		} else {
-			unsigned long _end =3D jiffies + 3*DRM_HZ;
+			unsigned long _end=3Djiffies + 3*DRM_HZ;
 			int locked =3D 0;
=20
 			drm_idlelock_take(&dev->lock);
@@ -405,14 +357,9 @@ int drm_release(struct inode *inode, str
 			 * Wait for a while.
 			 */
=20
-<<<<<<< HEAD:drivers/char/drm/drm_fops.c
 			do{
 				spin_lock_irqsave(&dev->lock.spinlock,
 						  irqflags);
-=3D=3D=3D=3D=3D=3D=3D
-			do {
-				spin_lock(&dev->lock.spinlock);
->>>>>>> FETCH_HEAD:drivers/char/drm/drm_fops.c
 				locked =3D dev->lock.idle_has_lock;
 				spin_unlock_irqrestore(&dev->lock.spinlock,
 						       irqflags);
@@ -478,7 +425,6 @@ int drm_release(struct inode *inode, str
 	mutex_unlock(&dev->ctxlist_mutex);
=20
 	mutex_lock(&dev->struct_mutex);
-	drm_object_release(filp);
 	if (file_priv->remove_auth_on_close =3D=3D 1) {
 		struct drm_file *temp;
=20
diff -puN drivers/char/drm/drm_hashtab.c~revert-git-drm drivers/char/dr=
m/drm_hashtab.c
--- a/drivers/char/drm/drm_hashtab.c~revert-git-drm
+++ a/drivers/char/drm/drm_hashtab.c
@@ -57,7 +57,7 @@ int drm_ht_create(struct drm_open_hash *
 		DRM_ERROR("Out of memory for hash table\n");
 		return -ENOMEM;
 	}
-	for (i =3D 0; i < ht->size; ++i) {
+	for (i=3D0; i< ht->size; ++i) {
 		INIT_HLIST_HEAD(&ht->table[i]);
 	}
 	return 0;
@@ -147,7 +147,7 @@ int drm_ht_just_insert_please(struct drm
 		ret =3D drm_ht_insert_item(ht, item);
 		if (ret)
 			unshifted_key =3D (unshifted_key + 1) & mask;
-	} while (ret && (unshifted_key !=3D first));
+	} while(ret && (unshifted_key !=3D first));
=20
 	if (ret) {
 		DRM_ERROR("Available key bit space exhausted\n");
diff -puN drivers/char/drm/drm_irq.c~revert-git-drm drivers/char/drm/dr=
m_irq.c
--- a/drivers/char/drm/drm_irq.c~revert-git-drm
+++ a/drivers/char/drm/drm_irq.c
@@ -340,7 +340,7 @@ int drm_wait_vblank(struct drm_device *d
 		vblwait->reply.tval_usec =3D now.tv_usec;
 	}
=20
-done:
+      done:
 	return ret;
 }
=20
diff -puN drivers/char/drm/drm_lock.c~revert-git-drm drivers/char/drm/d=
rm_lock.c
--- a/drivers/char/drm/drm_lock.c~revert-git-drm
+++ a/drivers/char/drm/drm_lock.c
@@ -176,7 +176,7 @@ int drm_unlock(struct drm_device *dev, v
 	if (dev->driver->kernel_context_switch_unlock)
 		dev->driver->kernel_context_switch_unlock(dev);
 	else {
-		if (drm_lock_free(&dev->lock, lock->context)) {
+		if (drm_lock_free(&dev->lock,lock->context)) {
 			/* FIXME: Should really bail out here. */
 		}
 	}
diff -puN drivers/char/drm/drm_memory.c~revert-git-drm drivers/char/drm=
/drm_memory.c
--- a/drivers/char/drm/drm_memory.c~revert-git-drm
+++ a/drivers/char/drm/drm_memory.c
@@ -36,75 +36,6 @@
 #include <linux/highmem.h>
 #include "drmP.h"
=20
-static struct {
-	spinlock_t lock;
-	uint64_t cur_used;
-	uint64_t low_threshold;
-	uint64_t high_threshold;
-} drm_memctl =3D {
-	.lock =3D __SPIN_LOCK_UNLOCKED(drm_memctl.lock)
-};
-
-static inline size_t drm_size_align(size_t size)
-{
-	size_t tmpSize =3D 4;
-	if (size > PAGE_SIZE)
-		return PAGE_ALIGN(size);
-
-	while (tmpSize < size)
-		tmpSize <<=3D 1;
-
-	return (size_t) tmpSize;
-}
-
-int drm_alloc_memctl(size_t size)
-{
-	int ret;
-	unsigned long a_size =3D drm_size_align(size);
-
-	spin_lock(&drm_memctl.lock);
-	ret =3D ((drm_memctl.cur_used + a_size) > drm_memctl.high_threshold) =
?
-		-ENOMEM : 0;
-	if (!ret)
-		drm_memctl.cur_used +=3D a_size;
-	spin_unlock(&drm_memctl.lock);
-	return ret;
-}
-EXPORT_SYMBOL(drm_alloc_memctl);
-
-void drm_free_memctl(size_t size)
-{
-	unsigned long a_size =3D drm_size_align(size);
-
-	spin_lock(&drm_memctl.lock);
-	drm_memctl.cur_used -=3D a_size;
-	spin_unlock(&drm_memctl.lock);
-}
-EXPORT_SYMBOL(drm_free_memctl);
-
-void drm_query_memctl(uint64_t *cur_used,
-		      uint64_t *low_threshold,
-		      uint64_t *high_threshold)
-{
-	spin_lock(&drm_memctl.lock);
-	*cur_used =3D drm_memctl.cur_used;
-	*low_threshold =3D drm_memctl.low_threshold;
-	*high_threshold =3D drm_memctl.high_threshold;
-	spin_unlock(&drm_memctl.lock);
-}
-EXPORT_SYMBOL(drm_query_memctl);
-
-void drm_init_memctl(size_t p_low_threshold,
-		     size_t p_high_threshold,
-		     size_t unit_size)
-{
-	spin_lock(&drm_memctl.lock);
-	drm_memctl.cur_used =3D 0;
-	drm_memctl.low_threshold =3D p_low_threshold * unit_size;
-	drm_memctl.high_threshold =3D p_high_threshold * unit_size;
-	spin_unlock(&drm_memctl.lock);
-}
-
 #ifdef DEBUG_MEMORY
 #include "drm_memory_debug.h"
 #else
diff -puN drivers/char/drm/drm_mm.c~revert-git-drm drivers/char/drm/drm=
_mm.c
--- a/drivers/char/drm/drm_mm.c~revert-git-drm
+++ a/drivers/char/drm/drm_mm.c
@@ -82,7 +82,7 @@ static int drm_mm_create_tail_node(struc
 	struct drm_mm_node *child;
=20
 	child =3D (struct drm_mm_node *)
-		drm_ctl_alloc(sizeof(*child), DRM_MEM_MM);
+		drm_alloc(sizeof(*child), DRM_MEM_MM);
 	if (!child)
 		return -ENOMEM;
=20
@@ -118,7 +118,7 @@ static struct drm_mm_node *drm_mm_split_
 	struct drm_mm_node *child;
=20
 	child =3D (struct drm_mm_node *)
-		drm_ctl_alloc(sizeof(*child), DRM_MEM_MM);
+		drm_alloc(sizeof(*child), DRM_MEM_MM);
 	if (!child)
 		return NULL;
=20
@@ -200,8 +200,8 @@ void drm_mm_put_block(struct drm_mm_node
 				prev_node->size +=3D next_node->size;
 				list_del(&next_node->ml_entry);
 				list_del(&next_node->fl_entry);
-				drm_ctl_free(next_node, sizeof(*next_node),
-					     DRM_MEM_MM);
+				drm_free(next_node, sizeof(*next_node),
+					 DRM_MEM_MM);
 			} else {
 				next_node->size +=3D cur->size;
 				next_node->start =3D cur->start;
@@ -214,7 +214,7 @@ void drm_mm_put_block(struct drm_mm_node
 		list_add(&cur->fl_entry, &mm->fl_entry);
 	} else {
 		list_del(&cur->ml_entry);
-		drm_ctl_free(cur, sizeof(*cur), DRM_MEM_MM);
+		drm_free(cur, sizeof(*cur), DRM_MEM_MM);
 	}
 }
=20
@@ -291,5 +291,5 @@ void drm_mm_takedown(struct drm_mm * mm)
 	list_del(&entry->fl_entry);
 	list_del(&entry->ml_entry);
=20
-	drm_ctl_free(entry, sizeof(*entry), DRM_MEM_MM);
+	drm_free(entry, sizeof(*entry), DRM_MEM_MM);
 }
diff -puN drivers/char/drm/drm_object.c~revert-git-drm /dev/null
--- a/drivers/char/drm/drm_object.c
+++ /dev/null
@@ -1,293 +0,0 @@
-/*********************************************************************=
*****
- *
- * Copyright (c) 2006-2007 Tungsten Graphics, Inc., Cedar Park, TX., U=
SA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaini=
ng a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject =
to
- * the following conditions:
- *
- * The above copyright notice and this permission notice (including th=
e
- * next paragraph) shall be included in all copies or substantial port=
ions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT =
SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR A=
NY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT =
OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE =
OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- *********************************************************************=
*****/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#include "drmP.h"
-
-int drm_add_user_object(struct drm_file *priv, struct drm_user_object =
*item,
-			int shareable)
-{
-	struct drm_device *dev =3D priv->head->dev;
-	int ret;
-
-	DRM_ASSERT_LOCKED(&dev->struct_mutex);
-
-	/* The refcount will be bumped to 1 when we add the ref object below.=
 */
-	atomic_set(&item->refcount, 0);
-	item->shareable =3D shareable;
-	item->owner =3D priv;
-
-	ret =3D drm_ht_just_insert_please(&dev->object_hash, &item->hash,
-					(unsigned long)item, 31, 0, 0);
-	if (ret)
-		return ret;
-
-	ret =3D drm_add_ref_object(priv, item, _DRM_REF_USE);
-	if (ret)
-		ret =3D drm_ht_remove_item(&dev->object_hash, &item->hash);
-
-	return ret;
-}
-EXPORT_SYMBOL(drm_add_user_object);
-
-struct drm_user_object *drm_lookup_user_object(struct drm_file *priv, =
uint32_t key)
-{
-	struct drm_device *dev =3D priv->head->dev;
-	struct drm_hash_item *hash;
-	int ret;
-	struct drm_user_object *item;
-
-	DRM_ASSERT_LOCKED(&dev->struct_mutex);
-
-	ret =3D drm_ht_find_item(&dev->object_hash, key, &hash);
-	if (ret)
-		return NULL;
-
-	item =3D drm_hash_entry(hash, struct drm_user_object, hash);
-
-	if (priv !=3D item->owner) {
-		struct drm_open_hash *ht =3D &priv->refd_object_hash[_DRM_REF_USE];
-		ret =3D drm_ht_find_item(ht, (unsigned long)item, &hash);
-		if (ret) {
-			DRM_ERROR("Object not registered for usage\n");
-			return NULL;
-		}
-	}
-	return item;
-}
-EXPORT_SYMBOL(drm_lookup_user_object);
-
-static void drm_deref_user_object(struct drm_file *priv, struct drm_us=
er_object *item)
-{
-	struct drm_device *dev =3D priv->head->dev;
-	int ret;
-
-	if (atomic_dec_and_test(&item->refcount)) {
-		ret =3D drm_ht_remove_item(&dev->object_hash, &item->hash);
-		BUG_ON(ret);
-		item->remove(priv, item);
-	}
-}
-
-static int drm_object_ref_action(struct drm_file *priv, struct drm_use=
r_object *ro,
-				 enum drm_ref_type action)
-{
-	int ret =3D 0;
-
-	switch (action) {
-	case _DRM_REF_USE:
-		atomic_inc(&ro->refcount);
-		break;
-	default:
-		if (!ro->ref_struct_locked) {
-			break;
-		} else {
-			ro->ref_struct_locked(priv, ro, action);
-		}
-	}
-	return ret;
-}
-
-int drm_add_ref_object(struct drm_file *priv, struct drm_user_object *=
referenced_object,
-		       enum drm_ref_type ref_action)
-{
-	int ret =3D 0;
-	struct drm_ref_object *item;
-	struct drm_open_hash *ht =3D &priv->refd_object_hash[ref_action];
-
-	DRM_ASSERT_LOCKED(&priv->head->dev->struct_mutex);
-	if (!referenced_object->shareable && priv !=3D referenced_object->own=
er) {
-		DRM_ERROR("Not allowed to reference this object\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * If this is not a usage reference, Check that usage has been regist=
ered
-	 * first. Otherwise strange things may happen on destruction.
-	 */
-
-	if ((ref_action !=3D _DRM_REF_USE) && priv !=3D referenced_object->ow=
ner) {
-		item =3D
-		    drm_lookup_ref_object(priv, referenced_object,
-					  _DRM_REF_USE);
-		if (!item) {
-			DRM_ERROR
-			    ("Object not registered for usage by this client\n");
-			return -EINVAL;
-		}
-	}
-
-	if (NULL !=3D
-	    (item =3D
-	     drm_lookup_ref_object(priv, referenced_object, ref_action))) {
-		atomic_inc(&item->refcount);
-		return drm_object_ref_action(priv, referenced_object,
-					     ref_action);
-	}
-
-	item =3D drm_ctl_calloc(1, sizeof(*item), DRM_MEM_OBJECTS);
-	if (item =3D=3D NULL) {
-		DRM_ERROR("Could not allocate reference object\n");
-		return -ENOMEM;
-	}
-
-	atomic_set(&item->refcount, 1);
-	item->hash.key =3D (unsigned long)referenced_object;
-	ret =3D drm_ht_insert_item(ht, &item->hash);
-	item->unref_action =3D ref_action;
-
-	if (ret)
-		goto out;
-
-	list_add(&item->list, &priv->refd_objects);
-	ret =3D drm_object_ref_action(priv, referenced_object, ref_action);
-out:
-	return ret;
-}
-
-struct drm_ref_object *drm_lookup_ref_object(struct drm_file *priv,
-					struct drm_user_object *referenced_object,
-					enum drm_ref_type ref_action)
-{
-	struct drm_hash_item *hash;
-	int ret;
-
-	DRM_ASSERT_LOCKED(&priv->head->dev->struct_mutex);
-	ret =3D drm_ht_find_item(&priv->refd_object_hash[ref_action],
-			       (unsigned long)referenced_object, &hash);
-	if (ret)
-		return NULL;
-
-	return drm_hash_entry(hash, struct drm_ref_object, hash);
-}
-EXPORT_SYMBOL(drm_lookup_ref_object);
-
-static void drm_remove_other_references(struct drm_file *priv,
-					struct drm_user_object *ro)
-{
-	int i;
-	struct drm_open_hash *ht;
-	struct drm_hash_item *hash;
-	struct drm_ref_object *item;
-
-	for (i =3D _DRM_REF_USE + 1; i < _DRM_NO_REF_TYPES; ++i) {
-		ht =3D &priv->refd_object_hash[i];
-		while (!drm_ht_find_item(ht, (unsigned long)ro, &hash)) {
-			item =3D drm_hash_entry(hash, struct drm_ref_object, hash);
-			drm_remove_ref_object(priv, item);
-		}
-	}
-}
-
-void drm_remove_ref_object(struct drm_file *priv, struct drm_ref_objec=
t *item)
-{
-	int ret;
-	struct drm_user_object *user_object =3D (struct drm_user_object *) it=
em->hash.key;
-	struct drm_open_hash *ht =3D &priv->refd_object_hash[item->unref_acti=
on];
-	enum drm_ref_type unref_action;
-
-	DRM_ASSERT_LOCKED(&priv->head->dev->struct_mutex);
-	unref_action =3D item->unref_action;
-	if (atomic_dec_and_test(&item->refcount)) {
-		ret =3D drm_ht_remove_item(ht, &item->hash);
-		BUG_ON(ret);
-		list_del_init(&item->list);
-		if (unref_action =3D=3D _DRM_REF_USE)
-			drm_remove_other_references(priv, user_object);
-		drm_ctl_free(item, sizeof(*item), DRM_MEM_OBJECTS);
-	}
-
-	switch (unref_action) {
-	case _DRM_REF_USE:
-		drm_deref_user_object(priv, user_object);
-		break;
-	default:
-		BUG_ON(!user_object->unref);
-		user_object->unref(priv, user_object, unref_action);
-		break;
-	}
-
-}
-
-int drm_user_object_ref(struct drm_file *priv, uint32_t user_token,
-			enum drm_object_type type, struct drm_user_object **object)
-{
-	struct drm_device *dev =3D priv->head->dev;
-	struct drm_user_object *uo;
-	struct drm_hash_item *hash;
-	int ret;
-
-	mutex_lock(&dev->struct_mutex);
-	ret =3D drm_ht_find_item(&dev->object_hash, user_token, &hash);
-	if (ret) {
-		DRM_ERROR("Could not find user object to reference.\n");
-		goto out_err;
-	}
-	uo =3D drm_hash_entry(hash, struct drm_user_object, hash);
-	if (uo->type !=3D type) {
-		ret =3D -EINVAL;
-		goto out_err;
-	}
-	ret =3D drm_add_ref_object(priv, uo, _DRM_REF_USE);
-	if (ret)
-		goto out_err;
-	mutex_unlock(&dev->struct_mutex);
-	*object =3D uo;
-	return 0;
-out_err:
-	mutex_unlock(&dev->struct_mutex);
-	return ret;
-}
-
-int drm_user_object_unref(struct drm_file *priv, uint32_t user_token,
-			  enum drm_object_type type)
-{
-	struct drm_device *dev =3D priv->head->dev;
-	struct drm_user_object *uo;
-	struct drm_ref_object *ro;
-	int ret;
-
-	mutex_lock(&dev->struct_mutex);
-	uo =3D drm_lookup_user_object(priv, user_token);
-	if (!uo || (uo->type !=3D type)) {
-		ret =3D -EINVAL;
-		goto out_err;
-	}
-	ro =3D drm_lookup_ref_object(priv, uo, _DRM_REF_USE);
-	if (!ro) {
-		ret =3D -EINVAL;
-		goto out_err;
-	}
-	drm_remove_ref_object(priv, ro);
-	mutex_unlock(&dev->struct_mutex);
-	return 0;
-out_err:
-	mutex_unlock(&dev->struct_mutex);
-	return ret;
-}
diff -puN drivers/char/drm/drm_objects.h~revert-git-drm /dev/null
--- a/drivers/char/drm/drm_objects.h
+++ /dev/null
@@ -1,760 +0,0 @@
-/*********************************************************************=
*****
- *
- * Copyright (c) 2006-2007 Tungsten Graphics, Inc., Cedar Park, TX., U=
SA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaini=
ng a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject =
to
- * the following conditions:
- *
- * The above copyright notice and this permission notice (including th=
e
- * next paragraph) shall be included in all copies or substantial port=
ions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT =
SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR A=
NY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT =
OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE =
OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- *********************************************************************=
*****/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#ifndef _DRM_OBJECTS_H
-#define _DRM_OBJECTS_H
-
-struct drm_device;
-struct drm_bo_mem_reg;
-
-/***************************************************
- * User space objects. (drm_object.c)
- */
-
-#define drm_user_object_entry(_ptr, _type, _member) container_of(_ptr,=
 _type, _member)
-
-enum drm_object_type {
-	drm_fence_type,
-	drm_buffer_type,
-	drm_lock_type,
-	    /*
-	     * Add other user space object types here.
-	     */
-	drm_driver_type0 =3D 256,
-	drm_driver_type1,
-	drm_driver_type2,
-	drm_driver_type3,
-	drm_driver_type4
-};
-
-/*
- * A user object is a structure that helps the drm give out user handl=
es
- * to kernel internal objects and to keep track of these objects so th=
at
- * they can be destroyed, for example when the user space process exit=
s.
- * Designed to be accessible using a user space 32-bit handle.
- */
-
-struct drm_user_object {
-	struct drm_hash_item hash;
-	struct list_head list;
-	enum drm_object_type type;
-	atomic_t refcount;
-	int shareable;
-	struct drm_file *owner;
-	void (*ref_struct_locked) (struct drm_file *priv,
-				   struct drm_user_object *obj,
-				   enum drm_ref_type ref_action);
-	void (*unref) (struct drm_file *priv, struct drm_user_object *obj,
-		       enum drm_ref_type unref_action);
-	void (*remove) (struct drm_file *priv, struct drm_user_object *obj);
-};
-
-/*
- * A ref object is a structure which is used to
- * keep track of references to user objects and to keep track of these
- * references so that they can be destroyed for example when the user =
space
- * process exits. Designed to be accessible using a pointer to the _us=
er_ object.
- */
-
-struct drm_ref_object {
-	struct drm_hash_item hash;
-	struct list_head list;
-	atomic_t refcount;
-	enum drm_ref_type unref_action;
-};
-
-/**
- * Must be called with the struct_mutex held.
- */
-
-extern int drm_add_user_object(struct drm_file *priv, struct drm_user_=
object *item,
-			       int shareable);
-/**
- * Must be called with the struct_mutex held.
- */
-
-extern struct drm_user_object *drm_lookup_user_object(struct drm_file =
*priv,
-						 uint32_t key);
-
-/*
- * Must be called with the struct_mutex held. May temporarily release =
it.
- */
-
-extern int drm_add_ref_object(struct drm_file *priv,
-			      struct drm_user_object *referenced_object,
-			      enum drm_ref_type ref_action);
-
-/*
- * Must be called with the struct_mutex held.
- */
-
-struct drm_ref_object *drm_lookup_ref_object(struct drm_file *priv,
-					struct drm_user_object *referenced_object,
-					enum drm_ref_type ref_action);
-/*
- * Must be called with the struct_mutex held.
- * If "item" has been obtained by a call to drm_lookup_ref_object. You=
 may not
- * release the struct_mutex before calling drm_remove_ref_object.
- * This function may temporarily release the struct_mutex.
- */
-
-extern void drm_remove_ref_object(struct drm_file *priv, struct drm_re=
f_object *item);
-extern int drm_user_object_ref(struct drm_file *priv, uint32_t user_to=
ken,
-			       enum drm_object_type type,
-			       struct drm_user_object **object);
-extern int drm_user_object_unref(struct drm_file *priv, uint32_t user_=
token,
-				 enum drm_object_type type);
-
-/***************************************************
- * Fence objects. (drm_fence.c)
- */
-
-struct drm_fence_object {
-	struct drm_user_object base;
-	struct drm_device *dev;
-	atomic_t usage;
-
-	/*
-	 * The below three fields are protected by the fence manager spinlock=
=2E
-	 */
-
-	struct list_head ring;
-	int fence_class;
-	uint32_t native_types;
-	uint32_t type;
-	uint32_t signaled_types;
-	uint32_t sequence;
-	uint32_t waiting_types;
-	uint32_t error;
-};
-
-#define _DRM_FENCE_CLASSES 8
-#define _DRM_FENCE_TYPE_EXE 0x00
-
-struct drm_fence_class_manager {
-	struct list_head ring;
-	uint32_t pending_flush;
-	uint32_t waiting_types;
-	wait_queue_head_t fence_queue;
-	uint32_t highest_waiting_sequence;
-	uint32_t latest_queued_sequence;
-};
-
-struct drm_fence_manager {
-	int initialized;
-	rwlock_t lock;
-	struct drm_fence_class_manager fence_class[_DRM_FENCE_CLASSES];
-	uint32_t num_classes;
-	atomic_t count;
-};
-
-struct drm_fence_driver {
-	unsigned long *waiting_jiffies;
-	uint32_t num_classes;
-	uint32_t wrap_diff;
-	uint32_t flush_diff;
-	uint32_t sequence_mask;
-
-	/*
-	 * Driver implemented functions:
-	 * has_irq() : 1 if the hardware can update the indicated type_flags =
using an
-	 * irq handler. 0 if polling is required.
-	 *
-	 * emit() : Emit a sequence number to the command stream.
-	 * Return the sequence number.
-	 *
-	 * flush() : Make sure the flags indicated in fc->pending_flush will =
eventually
-	 * signal for fc->highest_received_sequence and all preceding sequenc=
es.
-	 * Acknowledge by clearing the flags fc->pending_flush.
-	 *
-	 * poll() : Call drm_fence_handler with any new information.
-	 *
-	 * needed_flush() : Given the current state of the fence->type flags =
and previusly
-	 * executed or queued flushes, return the type_flags that need flushi=
ng.
-	 *
-	 * wait(): Wait for the "mask" flags to signal on a given fence, perf=
orming
-	 * whatever's necessary to make this happen.
-	 */
-
-	int (*has_irq) (struct drm_device *dev, uint32_t fence_class,
-			uint32_t flags);
-	int (*emit) (struct drm_device *dev, uint32_t fence_class,
-		     uint32_t flags, uint32_t *breadcrumb,
-		     uint32_t *native_type);
-	void (*flush) (struct drm_device *dev, uint32_t fence_class);
-	void (*poll) (struct drm_device *dev, uint32_t fence_class,
-		uint32_t types);
-	uint32_t (*needed_flush) (struct drm_fence_object *fence);
-	int (*wait) (struct drm_fence_object *fence, int lazy,
-		     int interruptible, uint32_t mask);
-};
-
-extern int drm_fence_wait_polling(struct drm_fence_object *fence, int =
lazy,
-				  int interruptible, uint32_t mask,
-				  unsigned long end_jiffies);
-extern void drm_fence_handler(struct drm_device *dev, uint32_t fence_c=
lass,
-			      uint32_t sequence, uint32_t type,
-			      uint32_t error);
-extern void drm_fence_manager_init(struct drm_device *dev);
-extern void drm_fence_manager_takedown(struct drm_device *dev);
-extern void drm_fence_flush_old(struct drm_device *dev, uint32_t fence=
_class,
-				uint32_t sequence);
-extern int drm_fence_object_flush(struct drm_fence_object *fence,
-				  uint32_t type);
-extern int drm_fence_object_signaled(struct drm_fence_object *fence,
-				     uint32_t type);
-extern void drm_fence_usage_deref_locked(struct drm_fence_object **fen=
ce);
-extern void drm_fence_usage_deref_unlocked(struct drm_fence_object **f=
ence);
-extern struct drm_fence_object *drm_fence_reference_locked(struct drm_=
fence_object *src);
-extern void drm_fence_reference_unlocked(struct drm_fence_object **dst=
,
-					 struct drm_fence_object *src);
-extern int drm_fence_object_wait(struct drm_fence_object *fence,
-				 int lazy, int ignore_signals, uint32_t mask);
-extern int drm_fence_object_create(struct drm_device *dev, uint32_t ty=
pe,
-				   uint32_t fence_flags, uint32_t fence_class,
-				   struct drm_fence_object **c_fence);
-extern int drm_fence_object_emit(struct drm_fence_object *fence,
-				 uint32_t fence_flags, uint32_t class,
-				 uint32_t type);
-extern void drm_fence_fill_arg(struct drm_fence_object *fence,
-			       struct drm_fence_arg *arg);
-
-extern int drm_fence_add_user_object(struct drm_file *priv,
-				     struct drm_fence_object *fence,
-				     int shareable);
-
-extern int drm_fence_create_ioctl(struct drm_device *dev, void *data,
-				  struct drm_file *file_priv);
-extern int drm_fence_destroy_ioctl(struct drm_device *dev, void *data,
-				   struct drm_file *file_priv);
-extern int drm_fence_reference_ioctl(struct drm_device *dev, void *dat=
a,
-				     struct drm_file *file_priv);
-extern int drm_fence_unreference_ioctl(struct drm_device *dev, void *d=
ata,
-				       struct drm_file *file_priv);
-extern int drm_fence_signaled_ioctl(struct drm_device *dev, void *data=
,
-				    struct drm_file *file_priv);
-extern int drm_fence_flush_ioctl(struct drm_device *dev, void *data,
-				 struct drm_file *file_priv);
-extern int drm_fence_wait_ioctl(struct drm_device *dev, void *data,
-				struct drm_file *file_priv);
-extern int drm_fence_emit_ioctl(struct drm_device *dev, void *data,
-				struct drm_file *file_priv);
-extern int drm_fence_buffers_ioctl(struct drm_device *dev, void *data,
-				   struct drm_file *file_priv);
-
-/**************************************************
- *TTMs
- */
-
-/*
- * The ttm backend GTT interface. (In our case AGP).
- * Any similar type of device (PCIE?)
- * needs only to implement these functions to be usable with the TTM i=
nterface.
- * The AGP backend implementation lives in drm_agpsupport.c
- * basically maps these calls to available functions in agpgart.
- * Each drm device driver gets an
- * additional function pointer that creates these types,
- * so that the device can choose the correct aperture.
- * (Multiple AGP apertures, etc.)
- * Most device drivers will let this point to the standard AGP impleme=
ntation.
- */
-
-#define DRM_BE_FLAG_NEEDS_FREE     0x00000001
-#define DRM_BE_FLAG_BOUND_CACHED   0x00000002
-
-struct drm_ttm_backend;
-struct drm_ttm_backend_func {
-	int (*needs_ub_cache_adjust) (struct drm_ttm_backend *backend);
-	int (*populate) (struct drm_ttm_backend *backend,
-			 unsigned long num_pages, struct page **pages,
-			 struct page *dummy_read_page);
-	void (*clear) (struct drm_ttm_backend *backend);
-	int (*bind) (struct drm_ttm_backend *backend,
-		     struct drm_bo_mem_reg *bo_mem);
-	int (*unbind) (struct drm_ttm_backend *backend);
-	void (*destroy) (struct drm_ttm_backend *backend);
-};
-
-
-struct drm_ttm_backend {
-	struct drm_device *dev;
-	uint32_t flags;
-	struct drm_ttm_backend_func *func;
-};
-
-struct drm_ttm {
-	struct page *dummy_read_page;
-	struct page **pages;
-	uint32_t page_flags;
-	unsigned long num_pages;
-	atomic_t vma_count;
-	struct drm_device *dev;
-	int destroy;
-	uint32_t mapping_offset;
-	struct drm_ttm_backend *be;
-	enum {
-		ttm_bound,
-		ttm_evicted,
-		ttm_unbound,
-		ttm_unpopulated,
-	} state;
-
-};
-
-extern struct drm_ttm *drm_ttm_create(struct drm_device *dev, unsigned=
 long size,
-				      uint32_t page_flags,
-				      struct page *dummy_read_page);
-extern int drm_ttm_bind(struct drm_ttm *ttm, struct drm_bo_mem_reg *bo=
_mem);
-extern void drm_ttm_unbind(struct drm_ttm *ttm);
-extern void drm_ttm_evict(struct drm_ttm *ttm);
-extern void drm_ttm_fixup_caching(struct drm_ttm *ttm);
-extern struct page *drm_ttm_get_page(struct drm_ttm *ttm, int index);
-extern void drm_ttm_cache_flush(void);
-extern int drm_ttm_populate(struct drm_ttm *ttm);
-extern int drm_ttm_set_user(struct drm_ttm *ttm,
-			    struct task_struct *tsk,
-			    unsigned long start,
-			    unsigned long num_pages);
-
-/*
- * Destroy a ttm. The user normally calls drmRmMap or a similar IOCTL =
to do
- * this which calls this function iff there are no vmas referencing it=
 anymore.
- * Otherwise it is called when the last vma exits.
- */
-
-extern int drm_ttm_destroy(struct drm_ttm *ttm);
-
-#define DRM_FLAG_MASKED(_old, _new, _mask) {\
-(_old) ^=3D (((_old) ^ (_new)) & (_mask)); \
-}
-
-#define DRM_TTM_MASK_FLAGS ((1 << PAGE_SHIFT) - 1)
-#define DRM_TTM_MASK_PFN (0xFFFFFFFFU - DRM_TTM_MASK_FLAGS)
-
-/*
- * Page flags.
- */
-
-/*
- * This ttm should not be cached by the CPU
- */
-#define DRM_TTM_PAGE_UNCACHED   (1 << 0)
-/*
- * This flat is not used at this time; I don't know what the
- * intent was
- */
-#define DRM_TTM_PAGE_USED       (1 << 1)
-/*
- * This flat is not used at this time; I don't know what the
- * intent was
- */
-#define DRM_TTM_PAGE_BOUND      (1 << 2)
-/*
- * This flat is not used at this time; I don't know what the
- * intent was
- */
-#define DRM_TTM_PAGE_PRESENT    (1 << 3)
-/*
- * The array of page pointers was allocated with vmalloc
- * instead of drm_calloc.
- */
-#define DRM_TTM_PAGE_VMALLOC    (1 << 4)
-/*
- * This ttm is mapped from user space
- */
-#define DRM_TTM_PAGE_USER       (1 << 5)
-/*
- * This ttm will be written to by the GPU
- */
-#define DRM_TTM_PAGE_WRITE	(1 << 6)
-/*
- * This ttm was mapped to the GPU, and so the contents may have
- * been modified
- */
-#define DRM_TTM_PAGE_USER_DIRTY (1 << 7)
-/*
- * This flag is not used at this time; I don't know what the
- * intent was.
- */
-#define DRM_TTM_PAGE_USER_DMA   (1 << 8)
-
-/***************************************************
- * Buffer objects. (drm_bo.c, drm_bo_move.c)
- */
-
-struct drm_bo_mem_reg {
-	struct drm_mm_node *mm_node;
-	unsigned long size;
-	unsigned long num_pages;
-	uint32_t page_alignment;
-	uint32_t mem_type;
-	/*
-	 * Current buffer status flags, indicating
-	 * where the buffer is located and which
-	 * access modes are in effect
-	 */
-	uint64_t flags;
-	/**
-	 * These are the flags proposed for
-	 * a validate operation. If the
-	 * validate succeeds, they'll get moved
-	 * into the flags field
-	 */
-	uint64_t proposed_flags;
-
-	uint32_t desired_tile_stride;
-	uint32_t hw_tile_stride;
-};
-
-enum drm_bo_type {
-	/*
-	 * drm_bo_type_device are 'normal' drm allocations,
-	 * pages are allocated from within the kernel automatically
-	 * and the objects can be mmap'd from the drm device. Each
-	 * drm_bo_type_device object has a unique name which can be
-	 * used by other processes to share access to the underlying
-	 * buffer.
-	 */
-	drm_bo_type_device,
-	/*
-	 * drm_bo_type_user are buffers of pages that already exist
-	 * in the process address space. They are more limited than
-	 * drm_bo_type_device buffers in that they must always
-	 * remain cached (as we assume the user pages are mapped cached),
-	 * and they are not sharable to other processes through DRM
-	 * (although, regular shared memory should still work fine).
-	 */
-	drm_bo_type_user,
-	/*
-	 * drm_bo_type_kernel are buffers that exist solely for use
-	 * within the kernel. The pages cannot be mapped into the
-	 * process. One obvious use would be for the ring
-	 * buffer where user access would not (ideally) be required.
-	 */
-	drm_bo_type_kernel,
-};
-
-struct drm_buffer_object {
-	struct drm_device *dev;
-	struct drm_user_object base;
-
-	/*
-	 * If there is a possibility that the usage variable is zero,
-	 * then dev->struct_mutext should be locked before incrementing it.
-	 */
-
-	atomic_t usage;
-	unsigned long buffer_start;
-	enum drm_bo_type type;
-	unsigned long offset;
-	atomic_t mapped;
-	struct drm_bo_mem_reg mem;
-
-	struct list_head lru;
-	struct list_head ddestroy;
-
-	uint32_t fence_type;
-	uint32_t fence_class;
-	uint32_t new_fence_type;
-	uint32_t new_fence_class;
-	struct drm_fence_object *fence;
-	uint32_t priv_flags;
-	wait_queue_head_t event_queue;
-	struct mutex mutex;
-	unsigned long num_pages;
-
-	/* For pinned buffers */
-	struct drm_mm_node *pinned_node;
-	uint32_t pinned_mem_type;
-	struct list_head pinned_lru;
-
-	/* For vm */
-	struct drm_ttm *ttm;
-	struct drm_map_list map_list;
-	uint32_t memory_type;
-	unsigned long bus_offset;
-	uint32_t vm_flags;
-	void *iomap;
-
-
-};
-
-#define _DRM_BO_FLAG_UNFENCED 0x00000001
-#define _DRM_BO_FLAG_EVICTED  0x00000002
-
-struct drm_mem_type_manager {
-	int has_type;
-	int use_type;
-	struct drm_mm manager;
-	struct list_head lru;
-	struct list_head pinned;
-	uint32_t flags;
-	uint32_t drm_bus_maptype;
-	unsigned long gpu_offset;
-	unsigned long io_offset;
-	unsigned long io_size;
-	void *io_addr;
-};
-
-struct drm_bo_lock {
-	struct drm_user_object base;
-	wait_queue_head_t queue;
-	atomic_t write_lock_pending;
-	atomic_t readers;
-};
-
-#define _DRM_FLAG_MEMTYPE_FIXED     0x00000001	/* Fixed (on-card) PCI =
memory */
-#define _DRM_FLAG_MEMTYPE_MAPPABLE  0x00000002	/* Memory mappable */
-#define _DRM_FLAG_MEMTYPE_CACHED    0x00000004	/* Cached binding */
-#define _DRM_FLAG_NEEDS_IOREMAP     0x00000008	/* Fixed memory needs i=
oremap
-						   before kernel access. */
-#define _DRM_FLAG_MEMTYPE_CMA       0x00000010	/* Can't map aperture *=
/
-#define _DRM_FLAG_MEMTYPE_CSELECT   0x00000020	/* Select caching */
-
-struct drm_buffer_manager {
-	struct drm_bo_lock bm_lock;
-	struct mutex evict_mutex;
-	int nice_mode;
-	int initialized;
-	struct drm_file *last_to_validate;
-	struct drm_mem_type_manager man[DRM_BO_MEM_TYPES];
-	struct list_head unfenced;
-	struct list_head ddestroy;
-	struct delayed_work wq;
-	uint32_t fence_type;
-	unsigned long cur_pages;
-	atomic_t count;
-	struct page *dummy_read_page;
-};
-
-struct drm_bo_driver {
-	const uint32_t *mem_type_prio;
-	const uint32_t *mem_busy_prio;
-	uint32_t num_mem_type_prio;
-	uint32_t num_mem_busy_prio;
-	struct drm_ttm_backend *(*create_ttm_backend_entry)
-	 (struct drm_device *dev);
-	int (*fence_type) (struct drm_buffer_object *bo, uint32_t *fclass,
-			   uint32_t *type);
-	int (*invalidate_caches) (struct drm_device *dev, uint64_t flags);
-	int (*init_mem_type) (struct drm_device *dev, uint32_t type,
-			      struct drm_mem_type_manager *man);
-	/*
-	 * evict_flags:
-	 *
-	 * @bo: the buffer object to be evicted
-	 *
-	 * Return the bo flags for a buffer which is not mapped to the hardwa=
re.
-	 * These will be placed in proposed_flags so that when the move is
-	 * finished, they'll end up in bo->mem.flags
-	 */
-	uint64_t(*evict_flags) (struct drm_buffer_object *bo);
-	/*
-	 * move:
-	 *
-	 * @bo: the buffer to move
-	 *
-	 * @evict: whether this motion is evicting the buffer from
-	 * the graphics address space
-	 *
-	 * @no_wait: whether this should give up and return -EBUSY
-	 * if this move would require sleeping
-	 *
-	 * @new_mem: the new memory region receiving the buffer
-	 *
-	 * Move a buffer between two memory regions.
-	 */
-	int (*move) (struct drm_buffer_object *bo,
-		     int evict, int no_wait, struct drm_bo_mem_reg *new_mem);
-	/*
-	 * ttm_cache_flush
-	 */
-	void (*ttm_cache_flush)(struct drm_ttm *ttm);
-
-	/*
-	 * command_stream_barrier
-	 *
-	 * @dev: The drm device.
-	 *
-	 * @bo: The buffer object to validate.
-	 *
-	 * @new_fence_class: The new fence class for the buffer object.
-	 *
-	 * @new_fence_type: The new fence type for the buffer object.
-	 *
-	 * @no_wait: whether this should give up and return -EBUSY
-	 * if this operation would require sleeping
-	 *
-	 * Insert a command stream barrier that makes sure that the
-	 * buffer is idle once the commands associated with the
-	 * current validation are starting to execute. If an error
-	 * condition is returned, or the function pointer is NULL,
-	 * the drm core will force buffer idle
-	 * during validation.
-	 */
-
-	int (*command_stream_barrier) (struct drm_buffer_object *bo,
-				       uint32_t new_fence_class,
-				       uint32_t new_fence_type,
-				       int no_wait);
-};
-
-/*
- * buffer objects (drm_bo.c)
- */
-
-extern int drm_bo_create_ioctl(struct drm_device *dev, void *data, str=
uct drm_file *file_priv);
-extern int drm_bo_destroy_ioctl(struct drm_device *dev, void *data, st=
ruct drm_file *file_priv);
-extern int drm_bo_map_ioctl(struct drm_device *dev, void *data, struct=
 drm_file *file_priv);
-extern int drm_bo_unmap_ioctl(struct drm_device *dev, void *data, stru=
ct drm_file *file_priv);
-extern int drm_bo_reference_ioctl(struct drm_device *dev, void *data, =
struct drm_file *file_priv);
-extern int drm_bo_unreference_ioctl(struct drm_device *dev, void *data=
, struct drm_file *file_priv);
-extern int drm_bo_wait_idle_ioctl(struct drm_device *dev, void *data, =
struct drm_file *file_priv);
-extern int drm_bo_info_ioctl(struct drm_device *dev, void *data, struc=
t drm_file *file_priv);
-extern int drm_bo_setstatus_ioctl(struct drm_device *dev, void *data, =
struct drm_file *file_priv);
-extern int drm_mm_init_ioctl(struct drm_device *dev, void *data, struc=
t drm_file *file_priv);
-extern int drm_mm_takedown_ioctl(struct drm_device *dev, void *data, s=
truct drm_file *file_priv);
-extern int drm_mm_lock_ioctl(struct drm_device *dev, void *data, struc=
t drm_file *file_priv);
-extern int drm_mm_unlock_ioctl(struct drm_device *dev, void *data, str=
uct drm_file *file_priv);
-extern int drm_bo_version_ioctl(struct drm_device *dev, void *data, st=
ruct drm_file *file_priv);
-extern int drm_bo_driver_finish(struct drm_device *dev);
-extern int drm_bo_driver_init(struct drm_device *dev);
-extern int drm_bo_pci_offset(struct drm_device *dev,
-			     struct drm_bo_mem_reg *mem,
-			     unsigned long *bus_base,
-			     unsigned long *bus_offset,
-			     unsigned long *bus_size);
-extern int drm_mem_reg_is_pci(struct drm_device *dev, struct drm_bo_me=
m_reg *mem);
-
-extern void drm_bo_usage_deref_locked(struct drm_buffer_object **bo);
-extern void drm_bo_usage_deref_unlocked(struct drm_buffer_object **bo)=
;
-extern void drm_putback_buffer_objects(struct drm_device *dev);
-extern int drm_fence_buffer_objects(struct drm_device *dev,
-				    struct list_head *list,
-				    uint32_t fence_flags,
-				    struct drm_fence_object *fence,
-				    struct drm_fence_object **used_fence);
-extern void drm_bo_add_to_lru(struct drm_buffer_object *bo);
-extern int drm_buffer_object_create(struct drm_device *dev, unsigned l=
ong size,
-				    enum drm_bo_type type, uint64_t flags,
-				    uint32_t hint, uint32_t page_alignment,
-				    unsigned long buffer_start,
-				    struct drm_buffer_object **bo);
-extern int drm_bo_wait(struct drm_buffer_object *bo, int lazy, int ign=
ore_signals,
-		       int no_wait);
-extern int drm_bo_mem_space(struct drm_buffer_object *bo,
-			    struct drm_bo_mem_reg *mem, int no_wait);
-extern int drm_bo_move_buffer(struct drm_buffer_object *bo,
-			      uint64_t new_mem_flags,
-			      int no_wait, int move_unfenced);
-extern int drm_bo_clean_mm(struct drm_device *dev, unsigned mem_type);
-extern int drm_bo_init_mm(struct drm_device *dev, unsigned type,
-			  unsigned long p_offset, unsigned long p_size);
-extern int drm_bo_handle_validate(struct drm_file *file_priv, uint32_t=
 handle,
-				  uint64_t flags, uint64_t mask, uint32_t hint,
-				  uint32_t fence_class, int use_old_fence_class,
-				  struct drm_bo_info_rep *rep,
-				  struct drm_buffer_object **bo_rep);
-extern struct drm_buffer_object *drm_lookup_buffer_object(struct drm_f=
ile *file_priv,
-							  uint32_t handle,
-							  int check_owner);
-extern int drm_bo_do_validate(struct drm_buffer_object *bo,
-			      uint64_t flags, uint64_t mask, uint32_t hint,
-			      uint32_t fence_class,
-			      struct drm_bo_info_rep *rep);
-
-/*
- * Buffer object memory move- and map helpers.
- * drm_bo_move.c
- */
-
-extern int drm_bo_move_ttm(struct drm_buffer_object *bo,
-			   int evict, int no_wait,
-			   struct drm_bo_mem_reg *new_mem);
-extern int drm_bo_move_memcpy(struct drm_buffer_object *bo,
-			      int evict,
-			      int no_wait, struct drm_bo_mem_reg *new_mem);
-extern int drm_bo_move_accel_cleanup(struct drm_buffer_object *bo,
-				     int evict, int no_wait,
-				     uint32_t fence_class, uint32_t fence_type,
-				     uint32_t fence_flags,
-				     struct drm_bo_mem_reg *new_mem);
-extern int drm_bo_same_page(unsigned long offset, unsigned long offset=
2);
-extern unsigned long drm_bo_offset_end(unsigned long offset,
-				       unsigned long end);
-
-struct drm_bo_kmap_obj {
-	void *virtual;
-	struct page *page;
-	enum {
-		bo_map_iomap,
-		bo_map_vmap,
-		bo_map_kmap,
-		bo_map_premapped,
-	} bo_kmap_type;
-};
-
-static inline void *drm_bmo_virtual(struct drm_bo_kmap_obj *map, int *=
is_iomem)
-{
-	*is_iomem =3D (map->bo_kmap_type =3D=3D bo_map_iomap ||
-		     map->bo_kmap_type =3D=3D bo_map_premapped);
-	return map->virtual;
-}
-extern void drm_bo_kunmap(struct drm_bo_kmap_obj *map);
-extern int drm_bo_kmap(struct drm_buffer_object *bo, unsigned long sta=
rt_page,
-		       unsigned long num_pages, struct drm_bo_kmap_obj *map);
-extern int drm_bo_pfn_prot(struct drm_buffer_object *bo,
-			   unsigned long dst_offset,
-			   unsigned long *pfn,
-			   pgprot_t *prot);
-
-/*
- * drm_bo_lock.c
- * Simple replacement for the hardware lock on buffer manager init and=
 clean.
- */
-
-
-extern void drm_bo_init_lock(struct drm_bo_lock *lock);
-extern void drm_bo_read_unlock(struct drm_bo_lock *lock);
-extern int drm_bo_read_lock(struct drm_bo_lock *lock);
-extern int drm_bo_write_lock(struct drm_bo_lock *lock,
-			     struct drm_file *file_priv);
-
-extern int drm_bo_write_unlock(struct drm_bo_lock *lock,
-			       struct drm_file *file_priv);
-
-#ifdef CONFIG_DEBUG_MUTEXES
-#define DRM_ASSERT_LOCKED(_mutex)					\
-	BUG_ON(!mutex_is_locked(_mutex) ||				\
-	       ((_mutex)->owner !=3D current_thread_info()))
-#else
-#define DRM_ASSERT_LOCKED(_mutex)
-#endif
-#endif
diff -puN drivers/char/drm/drm_proc.c~revert-git-drm drivers/char/drm/d=
rm_proc.c
--- a/drivers/char/drm/drm_proc.c~revert-git-drm
+++ a/drivers/char/drm/drm_proc.c
@@ -49,8 +49,6 @@ static int drm_queues_info(char *buf, ch
 			   int request, int *eof, void *data);
 static int drm_bufs_info(char *buf, char **start, off_t offset,
 			 int request, int *eof, void *data);
-static int drm_objects_info(char *buf, char **start, off_t offset,
-			 int request, int *eof, void *data);
 #if DRM_DEBUG_CODE
 static int drm_vma_info(char *buf, char **start, off_t offset,
 			int request, int *eof, void *data);
@@ -69,7 +67,6 @@ static struct drm_proc_list {
 	{"clients", drm_clients_info},
 	{"queues", drm_queues_info},
 	{"bufs", drm_bufs_info},
-	{"objects", drm_objects_info},
 #if DRM_DEBUG_CODE
 	{"vma", drm_vma_info},
 #endif
@@ -419,93 +416,6 @@ static int drm_bufs_info(char *buf, char
 }
=20
 /**
- * Called when "/proc/dri/.../objects" is read.
- *
- * \param buf output buffer.
- * \param start start of output data.
- * \param offset requested start offset.
- * \param request requested number of bytes.
- * \param eof whether there is no more data to return.
- * \param data private data.
- * \return number of written bytes.
- */
-static int drm__objects_info(char *buf, char **start, off_t offset, in=
t request,
-			  int *eof, void *data)
-{
-	struct drm_device *dev =3D (struct drm_device *) data;
-	int len =3D 0;
-	struct drm_buffer_manager *bm =3D &dev->bm;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	uint64_t used_mem;
-	uint64_t low_mem;
-	uint64_t high_mem;
-
-
-	if (offset > DRM_PROC_LIMIT) {
-		*eof =3D 1;
-		return 0;
-	}
-
-	*start =3D &buf[offset];
-	*eof =3D 0;
-
-	DRM_PROC_PRINT("Object accounting:\n\n");
-	if (fm->initialized) {
-		DRM_PROC_PRINT("Number of active fence objects: %d.\n",
-			       atomic_read(&fm->count));
-	} else {
-		DRM_PROC_PRINT("Fence objects are not supported by this driver\n");
-	}
-
-	if (bm->initialized) {
-		DRM_PROC_PRINT("Number of active buffer objects: %d.\n\n",
-			       atomic_read(&bm->count));
-	}
-	DRM_PROC_PRINT("Memory accounting:\n\n");
-	if (bm->initialized) {
-		DRM_PROC_PRINT("Number of locked GATT pages: %lu.\n", bm->cur_pages)=
;
-	} else {
-		DRM_PROC_PRINT("Buffer objects are not supported by this driver.\n")=
;
-	}
-
-	drm_query_memctl(&used_mem, &low_mem, &high_mem);
-
-	if (used_mem > 16*PAGE_SIZE) {
-		DRM_PROC_PRINT("Used object memory is %lu pages.\n",
-			       (unsigned long) (used_mem >> PAGE_SHIFT));
-	} else {
-		DRM_PROC_PRINT("Used object memory is %lu bytes.\n",
-			       (unsigned long) used_mem);
-	}
-	DRM_PROC_PRINT("Soft object memory usage threshold is %lu pages.\n",
-		       (unsigned long) (low_mem >> PAGE_SHIFT));
-	DRM_PROC_PRINT("Hard object memory usage threshold is %lu pages.\n",
-		       (unsigned long) (high_mem >> PAGE_SHIFT));
-
-	DRM_PROC_PRINT("\n");
-
-	if (len > request + offset)
-		return request;
-	*eof =3D 1;
-	return len - offset;
-}
-
-/**
- * Simply calls _objects_info() while holding the drm_device::struct_m=
utex lock.
- */
-static int drm_objects_info(char *buf, char **start, off_t offset, int=
 request,
-			 int *eof, void *data)
-{
-	struct drm_device *dev =3D (struct drm_device *) data;
-	int ret;
-
-	mutex_lock(&dev->struct_mutex);
-	ret =3D drm__objects_info(buf, start, offset, request, eof, data);
-	mutex_unlock(&dev->struct_mutex);
-	return ret;
-}
-
-/**
  * Called when "/proc/dri/.../clients" is read.
  *
  * \param buf output buffer.
diff -puN drivers/char/drm/drm_scatter.c~revert-git-drm drivers/char/dr=
m/drm_scatter.c
--- a/drivers/char/drm/drm_scatter.c~revert-git-drm
+++ a/drivers/char/drm/drm_scatter.c
@@ -188,7 +188,7 @@ int drm_sg_alloc(struct drm_device *dev,
=20
 	return 0;
=20
-failed:
+      failed:
 	drm_sg_cleanup(entry);
 	return -ENOMEM;
 }
diff -puN drivers/char/drm/drm_stub.c~revert-git-drm drivers/char/drm/d=
rm_stub.c
--- a/drivers/char/drm/drm_stub.c~revert-git-drm
+++ a/drivers/char/drm/drm_stub.c
@@ -71,7 +71,6 @@ static int drm_fill_in_dev(struct drm_de
 	init_timer(&dev->timer);
 	mutex_init(&dev->struct_mutex);
 	mutex_init(&dev->ctxlist_mutex);
-	mutex_init(&dev->bm.evict_mutex);
=20
 	idr_init(&dev->drw_idr);
=20
@@ -84,19 +83,7 @@ static int drm_fill_in_dev(struct drm_de
 #endif
 	dev->irq =3D pdev->irq;
=20
-	if (drm_ht_create(&dev->map_hash, DRM_MAP_HASH_ORDER)) {
-		return -ENOMEM;
-	}
-
-	if (drm_mm_init(&dev->offset_manager, DRM_FILE_PAGE_OFFSET_START,
-			DRM_FILE_PAGE_OFFSET_SIZE)) {
-		drm_ht_remove(&dev->map_hash);
-		return -ENOMEM;
-	}
-
-	if (drm_ht_create(&dev->object_hash, DRM_OBJECT_HASH_ORDER)) {
-		drm_ht_remove(&dev->map_hash);
-		drm_mm_takedown(&dev->offset_manager);
+	if (drm_ht_create(&dev->map_hash, 12)) {
 		return -ENOMEM;
 	}
=20
@@ -139,10 +126,9 @@ static int drm_fill_in_dev(struct drm_de
 		goto error_out_unreg;
 	}
=20
-	drm_fence_manager_init(dev);
 	return 0;
=20
-error_out_unreg:
+      error_out_unreg:
 	drm_lastclose(dev);
 	return retcode;
 }
@@ -196,9 +182,9 @@ static int drm_get_head(struct drm_devic
 	}
 	DRM_ERROR("out of minors\n");
 	return -ENOMEM;
-err_g2:
+      err_g2:
 	drm_proc_cleanup(minor, drm_proc_root, head->dev_root);
-err_g1:
+      err_g1:
 	*head =3D (struct drm_head) {
 	.dev =3D NULL};
 	return ret;
diff -puN drivers/char/drm/drm_ttm.c~revert-git-drm /dev/null
--- a/drivers/char/drm/drm_ttm.c
+++ /dev/null
@@ -1,464 +0,0 @@
-/*********************************************************************=
*****
- *
- * Copyright (c) 2006-2007 Tungsten Graphics, Inc., Cedar Park, TX., U=
SA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaini=
ng a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject =
to
- * the following conditions:
- *
- * The above copyright notice and this permission notice (including th=
e
- * next paragraph) shall be included in all copies or substantial port=
ions
- * of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT =
SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR A=
NY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT =
OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE =
OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- *********************************************************************=
*****/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#include "drmP.h"
-
-static void drm_ttm_ipi_handler(void *null)
-{
-	flush_agp_cache();
-}
-
-void drm_ttm_cache_flush(void)
-{
-	if (on_each_cpu(drm_ttm_ipi_handler, NULL, 1, 1) !=3D 0)
-		DRM_ERROR("Timed out waiting for drm cache flush.\n");
-}
-EXPORT_SYMBOL(drm_ttm_cache_flush);
-
-/*
- * Use kmalloc if possible. Otherwise fall back to vmalloc.
- */
-
-static void drm_ttm_alloc_pages(struct drm_ttm *ttm)
-{
-	unsigned long size =3D ttm->num_pages * sizeof(*ttm->pages);
-	ttm->pages =3D NULL;
-
-	if (drm_alloc_memctl(size))
-		return;
-
-	if (size <=3D PAGE_SIZE)
-		ttm->pages =3D drm_calloc(1, size, DRM_MEM_TTM);
-
-	if (!ttm->pages) {
-		ttm->pages =3D vmalloc_user(size);
-		if (ttm->pages)
-			ttm->page_flags |=3D DRM_TTM_PAGE_VMALLOC;
-	}
-	if (!ttm->pages)
-		drm_free_memctl(size);
-}
-
-static void drm_ttm_free_pages(struct drm_ttm *ttm)
-{
-	unsigned long size =3D ttm->num_pages * sizeof(*ttm->pages);
-
-	if (ttm->page_flags & DRM_TTM_PAGE_VMALLOC) {
-		vfree(ttm->pages);
-		ttm->page_flags &=3D ~DRM_TTM_PAGE_VMALLOC;
-	} else {
-		drm_free(ttm->pages, size, DRM_MEM_TTM);
-	}
-	drm_free_memctl(size);
-	ttm->pages =3D NULL;
-}
-
-static struct page *drm_ttm_alloc_page(void)
-{
-	struct page *page;
-
-	if (drm_alloc_memctl(PAGE_SIZE))
-		return NULL;
-
-	page =3D alloc_page(GFP_KERNEL | __GFP_ZERO | GFP_DMA32);
-	if (!page) {
-		drm_free_memctl(PAGE_SIZE);
-		return NULL;
-	}
-	return page;
-}
-
-/*
- * Change caching policy for the linear kernel map
- * for range of pages in a ttm.
- */
-
-static int drm_ttm_set_caching(struct drm_ttm *ttm, int noncached)
-{
-	int i;
-	struct page **cur_page;
-
-	if ((ttm->page_flags & DRM_TTM_PAGE_UNCACHED) =3D=3D noncached)
-		return 0;
-
-	if (noncached)
-		drm_ttm_cache_flush();
-
-	for (i =3D 0; i < ttm->num_pages; ++i) {
-		cur_page =3D ttm->pages + i;
-		if (*cur_page) {
-			if (!PageHighMem(*cur_page)) {
-				if (noncached) {
-					map_page_into_agp(*cur_page);
-				} else {
-					unmap_page_from_agp(*cur_page);
-				}
-			}
-		}
-	}
-
-	DRM_FLAG_MASKED(ttm->page_flags, noncached, DRM_TTM_PAGE_UNCACHED);
-
-	return 0;
-}
-
-
-static void drm_ttm_free_user_pages(struct drm_ttm *ttm)
-{
-	int write;
-	int dirty;
-	struct page *page;
-	int i;
-
-	BUG_ON(!(ttm->page_flags & DRM_TTM_PAGE_USER));
-	write =3D ((ttm->page_flags & DRM_TTM_PAGE_WRITE) !=3D 0);
-	dirty =3D ((ttm->page_flags & DRM_TTM_PAGE_USER_DIRTY) !=3D 0);
-
-	for (i =3D 0; i < ttm->num_pages; ++i) {
-		page =3D ttm->pages[i];
-		if (page =3D=3D NULL)
-			continue;
-
-		if (page =3D=3D ttm->dummy_read_page) {
-			BUG_ON(write);
-			continue;
-		}
-
-		if (write && dirty && !PageReserved(page))
-			set_page_dirty_lock(page);
-
-		ttm->pages[i] =3D NULL;
-		put_page(page);
-	}
-}
-
-static void drm_ttm_free_alloced_pages(struct drm_ttm *ttm)
-{
-	int i;
-	struct drm_buffer_manager *bm =3D &ttm->dev->bm;
-	struct page **cur_page;
-
-	for (i =3D 0; i < ttm->num_pages; ++i) {
-		cur_page =3D ttm->pages + i;
-		if (*cur_page) {
-			if (page_count(*cur_page) !=3D 1)
-				DRM_ERROR("Erroneous page count. Leaking pages.\n");
-			if (page_mapped(*cur_page))
-				DRM_ERROR("Erroneous map count. Leaking page mappings.\n");
-			__free_page(*cur_page);
-			drm_free_memctl(PAGE_SIZE);
-			--bm->cur_pages;
-		}
-	}
-}
-
-/*
- * Free all resources associated with a ttm.
- */
-
-int drm_ttm_destroy(struct drm_ttm *ttm)
-{
-	struct drm_ttm_backend *be;
-
-	if (!ttm)
-		return 0;
-
-	be =3D ttm->be;
-	if (be) {
-		be->func->destroy(be);
-		ttm->be =3D NULL;
-	}
-
-	if (ttm->pages) {
-		if (ttm->page_flags & DRM_TTM_PAGE_UNCACHED)
-			drm_ttm_set_caching(ttm, 0);
-
-		if (ttm->page_flags & DRM_TTM_PAGE_USER)
-			drm_ttm_free_user_pages(ttm);
-		else
-			drm_ttm_free_alloced_pages(ttm);
-
-		drm_ttm_free_pages(ttm);
-	}
-
-	drm_ctl_free(ttm, sizeof(*ttm), DRM_MEM_TTM);
-	return 0;
-}
-
-struct page *drm_ttm_get_page(struct drm_ttm *ttm, int index)
-{
-	struct page *p;
-	struct drm_buffer_manager *bm =3D &ttm->dev->bm;
-
-	p =3D ttm->pages[index];
-	if (!p) {
-		p =3D drm_ttm_alloc_page();
-		if (!p)
-			return NULL;
-		ttm->pages[index] =3D p;
-		++bm->cur_pages;
-	}
-	return p;
-}
-EXPORT_SYMBOL(drm_ttm_get_page);
-
-/**
- * drm_ttm_set_user:
- *
- * @ttm: the ttm to map pages to. This must always be
- * a freshly created ttm.
- *
- * @tsk: a pointer to the address space from which to map
- * pages.
- *
- * @write: a boolean indicating that write access is desired
- *
- * start: the starting address
- *
- * Map a range of user addresses to a new ttm object. This
- * provides access to user memory from the graphics device.
- */
-int drm_ttm_set_user(struct drm_ttm *ttm,
-		     struct task_struct *tsk,
-		     unsigned long start,
-		     unsigned long num_pages)
-{
-	struct mm_struct *mm =3D tsk->mm;
-	int ret;
-	int write =3D (ttm->page_flags & DRM_TTM_PAGE_WRITE) !=3D 0;
-
-	BUG_ON(num_pages !=3D ttm->num_pages);
-	BUG_ON((ttm->page_flags & DRM_TTM_PAGE_USER) =3D=3D 0);
-
-	down_read(&mm->mmap_sem);
-	ret =3D get_user_pages(tsk, mm, start, num_pages,
-			     write, 0, ttm->pages, NULL);
-	up_read(&mm->mmap_sem);
-
-	if (ret !=3D num_pages && write) {
-		drm_ttm_free_user_pages(ttm);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-
-
-/**
- * drm_ttm_populate:
- *
- * @ttm: the object to allocate pages for
- *
- * Allocate pages for all unset page entries, then
- * call the backend to create the hardware mappings
- */
-int drm_ttm_populate(struct drm_ttm *ttm)
-{
-	struct page *page;
-	unsigned long i;
-	struct drm_ttm_backend *be;
-
-	if (ttm->state !=3D ttm_unpopulated)
-		return 0;
-
-	be =3D ttm->be;
-	if (ttm->page_flags & DRM_TTM_PAGE_WRITE) {
-		for (i =3D 0; i < ttm->num_pages; ++i) {
-			page =3D drm_ttm_get_page(ttm, i);
-			if (!page)
-				return -ENOMEM;
-		}
-	}
-	be->func->populate(be, ttm->num_pages, ttm->pages, ttm->dummy_read_pa=
ge);
-	ttm->state =3D ttm_unbound;
-	return 0;
-}
-
-/**
- * drm_ttm_create:
- *
- * @dev: the drm_device
- *
- * @size: The size (in bytes) of the desired object
- *
- * @page_flags: various DRM_TTM_PAGE_* flags. See drm_object.h.
- *
- * Allocate and initialize a ttm, leaving it unpopulated at this time
- */
-
-struct drm_ttm *drm_ttm_create(struct drm_device *dev, unsigned long s=
ize,
-			       uint32_t page_flags, struct page *dummy_read_page)
-{
-	struct drm_bo_driver *bo_driver =3D dev->driver->bo_driver;
-	struct drm_ttm *ttm;
-
-	if (!bo_driver)
-		return NULL;
-
-	ttm =3D drm_ctl_calloc(1, sizeof(*ttm), DRM_MEM_TTM);
-	if (!ttm)
-		return NULL;
-
-	ttm->dev =3D dev;
-	atomic_set(&ttm->vma_count, 0);
-
-	ttm->destroy =3D 0;
-	ttm->num_pages =3D (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-
-	ttm->page_flags =3D page_flags;
-
-	ttm->dummy_read_page =3D dummy_read_page;
-
-	/*
-	 * Account also for AGP module memory usage.
-	 */
-
-	drm_ttm_alloc_pages(ttm);
-	if (!ttm->pages) {
-		drm_ttm_destroy(ttm);
-		DRM_ERROR("Failed allocating page table\n");
-		return NULL;
-	}
-	ttm->be =3D bo_driver->create_ttm_backend_entry(dev);
-	if (!ttm->be) {
-		drm_ttm_destroy(ttm);
-		DRM_ERROR("Failed creating ttm backend entry\n");
-		return NULL;
-	}
-	ttm->state =3D ttm_unpopulated;
-	return ttm;
-}
-
-/**
- * drm_ttm_evict:
- *
- * @ttm: the object to be unbound from the aperture.
- *
- * Transition a ttm from bound to evicted, where it
- * isn't present in the aperture, but various caches may
- * not be consistent.
- */
-void drm_ttm_evict(struct drm_ttm *ttm)
-{
-	struct drm_ttm_backend *be =3D ttm->be;
-	int ret;
-
-	if (ttm->state =3D=3D ttm_bound) {
-		ret =3D be->func->unbind(be);
-		BUG_ON(ret);
-	}
-
-	ttm->state =3D ttm_evicted;
-}
-
-/**
- * drm_ttm_fixup_caching:
- *
- * @ttm: the object to set unbound
- *
- * XXX this function is misnamed. Transition a ttm from evicted to
- * unbound, flushing caches as appropriate.
- */
-void drm_ttm_fixup_caching(struct drm_ttm *ttm)
-{
-
-	if (ttm->state =3D=3D ttm_evicted) {
-		struct drm_ttm_backend *be =3D ttm->be;
-		if (be->func->needs_ub_cache_adjust(be))
-			drm_ttm_set_caching(ttm, 0);
-		ttm->state =3D ttm_unbound;
-	}
-}
-
-/**
- * drm_ttm_unbind:
- *
- * @ttm: the object to unbind from the graphics device
- *
- * Unbind an object from the aperture. This removes the mappings
- * from the graphics device and flushes caches if necessary.
- */
-void drm_ttm_unbind(struct drm_ttm *ttm)
-{
-	if (ttm->state =3D=3D ttm_bound)
-		drm_ttm_evict(ttm);
-
-	drm_ttm_fixup_caching(ttm);
-}
-
-/**
- * drm_ttm_bind:
- *
- * @ttm: the ttm object to bind to the graphics device
- *
- * @bo_mem: the aperture memory region which will hold the object
- *
- * Bind a ttm object to the aperture. This ensures that the necessary
- * pages are allocated, flushes CPU caches as needed and marks the
- * ttm as DRM_TTM_PAGE_USER_DIRTY to indicate that it may have been
- * modified by the GPU
- */
-int drm_ttm_bind(struct drm_ttm *ttm, struct drm_bo_mem_reg *bo_mem)
-{
-	struct drm_bo_driver *bo_driver =3D ttm->dev->driver->bo_driver;
-	int ret =3D 0;
-	struct drm_ttm_backend *be;
-
-	if (!ttm)
-		return -EINVAL;
-	if (ttm->state =3D=3D ttm_bound)
-		return 0;
-
-	be =3D ttm->be;
-
-	ret =3D drm_ttm_populate(ttm);
-	if (ret)
-		return ret;
-
-	if (ttm->state =3D=3D ttm_unbound && !(bo_mem->flags & DRM_BO_FLAG_CA=
CHED))
-		drm_ttm_set_caching(ttm, DRM_TTM_PAGE_UNCACHED);
-	else if ((bo_mem->flags & DRM_BO_FLAG_CACHED_MAPPED) &&
-		   bo_driver->ttm_cache_flush)
-		bo_driver->ttm_cache_flush(ttm);
-
-	ret =3D be->func->bind(be, bo_mem);
-	if (ret) {
-		ttm->state =3D ttm_evicted;
-		DRM_ERROR("Couldn't bind backend.\n");
-		return ret;
-	}
-
-	ttm->state =3D ttm_bound;
-	if (ttm->page_flags & DRM_TTM_PAGE_USER)
-		ttm->page_flags |=3D DRM_TTM_PAGE_USER_DIRTY;
-	return 0;
-}
-EXPORT_SYMBOL(drm_ttm_bind);
diff -puN drivers/char/drm/drm_vm.c~revert-git-drm drivers/char/drm/drm=
_vm.c
--- a/drivers/char/drm/drm_vm.c~revert-git-drm
+++ a/drivers/char/drm/drm_vm.c
@@ -40,10 +40,6 @@
=20
 static void drm_vm_open(struct vm_area_struct *vma);
 static void drm_vm_close(struct vm_area_struct *vma);
-static int drm_bo_mmap_locked(struct vm_area_struct *vma,
-			      struct file *filp,
-			      drm_local_map_t *map);
-
=20
 static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *=
vma)
 {
@@ -229,7 +225,7 @@ static void drm_vm_shm_close(struct vm_a
 			found_maps++;
 		if (pt->vma =3D=3D vma) {
 			list_del(&pt->head);
-			drm_ctl_free(pt, sizeof(*pt), DRM_MEM_VMAS);
+			drm_free(pt, sizeof(*pt), DRM_MEM_VMAS);
 		}
 	}
=20
@@ -271,9 +267,6 @@ static void drm_vm_shm_close(struct vm_a
 				dmah.size =3D map->size;
 				__drm_pci_free(dev, &dmah);
 				break;
-			case _DRM_TTM:
-				BUG_ON(1);
-				break;
 			}
 			drm_free(map, sizeof(*map), DRM_MEM_MAPS);
 		}
@@ -416,7 +409,7 @@ static void drm_vm_open_locked(struct vm
 		  vma->vm_start, vma->vm_end - vma->vm_start);
 	atomic_inc(&dev->vma_count);
=20
-	vma_entry =3D drm_ctl_alloc(sizeof(*vma_entry), DRM_MEM_VMAS);
+	vma_entry =3D drm_alloc(sizeof(*vma_entry), DRM_MEM_VMAS);
 	if (vma_entry) {
 		vma_entry->vma =3D vma;
 		vma_entry->pid =3D current->pid;
@@ -456,7 +449,7 @@ static void drm_vm_close(struct vm_area_
 	list_for_each_entry_safe(pt, temp, &dev->vmalist, head) {
 		if (pt->vma =3D=3D vma) {
 			list_del(&pt->head);
-			drm_ctl_free(pt, sizeof(*pt), DRM_MEM_VMAS);
+			drm_free(pt, sizeof(*pt), DRM_MEM_VMAS);
 			break;
 		}
 	}
@@ -654,8 +647,6 @@ static int drm_mmap_locked(struct file *
 		vma->vm_private_data =3D (void *)map;
 		vma->vm_flags |=3D VM_RESERVED;
 		break;
-	case _DRM_TTM:
-		return drm_bo_mmap_locked(vma, filp, map);
 	default:
 		return -EINVAL;	/* This should never happen. */
 	}
@@ -680,186 +671,3 @@ int drm_mmap(struct file *filp, struct v
 	return ret;
 }
 EXPORT_SYMBOL(drm_mmap);
-
-/**
- * buffer object vm functions.
- */
-
-/**
- * \c Pagefault method for buffer objects.
- *
- * \param vma Virtual memory area.
- * \param vmf vm fault data
- * \return Error or VM_FAULT_NOPAGE: the pfn is manually inserted.
- *
- * It's important that pfns are inserted while holding the bo->mutex l=
ock.
- * otherwise we might race with unmap_mapping_range() which is always
- * called with the bo->mutex lock held.
- *
- * We're modifying the page attribute bits of the vma->vm_page_prot fi=
eld,
- * without holding the mmap_sem in write mode. Only in read mode.
- * These bits are not used by the mm subsystem code, and we consider t=
hem
- * protected by the bo->mutex lock.
- */
-
-static int drm_bo_vm_fault(struct vm_area_struct *vma, struct vm_fault=
 *vmf)
-{
-	struct drm_buffer_object *bo =3D (struct drm_buffer_object *) vma->vm=
_private_data;
-	unsigned long page_offset;
-	struct page *page =3D NULL;
-	struct drm_ttm *ttm;
-	struct drm_device *dev;
-	unsigned long pfn;
-	int err;
-	unsigned long bus_base;
-	unsigned long bus_offset;
-	unsigned long bus_size;
-	unsigned long ret =3D VM_FAULT_NOPAGE;
-
-	dev =3D bo->dev;
-	err =3D drm_bo_read_lock(&dev->bm.bm_lock);
-	if (err)
-		return VM_FAULT_NOPAGE;
-
-	err =3D mutex_lock_interruptible(&bo->mutex);
-	if (err) {
-		drm_bo_read_unlock(&dev->bm.bm_lock);
-		return VM_FAULT_NOPAGE;
-	}
-
-	err =3D drm_bo_wait(bo, 0, 0, 0);
-	if (err) {
-		ret =3D (err !=3D -EAGAIN) ? VM_FAULT_SIGBUS : VM_FAULT_NOPAGE;
-		goto out_unlock;
-	}
-
-	/*
-	 * If buffer happens to be in a non-mappable location,
-	 * move it to a mappable.
-	 */
-
-	if (!(bo->mem.flags & DRM_BO_FLAG_MAPPABLE)) {
-		uint32_t new_flags =3D bo->mem.proposed_flags |
-			DRM_BO_FLAG_MAPPABLE |
-			DRM_BO_FLAG_FORCE_MAPPABLE;
-		err =3D drm_bo_move_buffer(bo, new_flags, 0, 0);
-		if (err) {
-			ret =3D (err !=3D -EAGAIN) ? VM_FAULT_SIGBUS : VM_FAULT_NOPAGE;
-			goto out_unlock;
-		}
-	}
-
-	err =3D drm_bo_pci_offset(dev, &bo->mem, &bus_base, &bus_offset,
-				&bus_size);
-
-	if (err) {
-		ret =3D VM_FAULT_SIGBUS;
-		goto out_unlock;
-	}
-
-	/* XXX: vmf->pgoff may work here, but it adds on vma->vm_pgoff */
-	page_offset =3D ((unsigned long)vmf->virtual_address - vma->vm_start)=
 >> PAGE_SHIFT;
-
-	if (bus_size) {
-		struct drm_mem_type_manager *man =3D &dev->bm.man[bo->mem.mem_type];
-
-		pfn =3D ((bus_base + bus_offset) >> PAGE_SHIFT) + page_offset;
-		vma->vm_page_prot =3D drm_io_prot(man->drm_bus_maptype, vma);
-	} else {
-		ttm =3D bo->ttm;
-
-		drm_ttm_fixup_caching(ttm);
-		page =3D drm_ttm_get_page(ttm, page_offset);
-		if (!page) {
-			ret =3D VM_FAULT_OOM;
-			goto out_unlock;
-		}
-		pfn =3D page_to_pfn(page);
-		vma->vm_page_prot =3D (bo->mem.flags & DRM_BO_FLAG_CACHED) ?
-			vm_get_page_prot(vma->vm_flags) :
-			drm_io_prot(_DRM_TTM, vma);
-	}
-
-	err =3D vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
-	if (err) {
-		ret =3D (err !=3D -EAGAIN) ? VM_FAULT_OOM : VM_FAULT_NOPAGE;
-		goto out_unlock;
-	}
-out_unlock:
-	mutex_unlock(&bo->mutex);
-	drm_bo_read_unlock(&dev->bm.bm_lock);
-	return ret;
-}
-
-static void drm_bo_vm_open_locked(struct vm_area_struct *vma)
-{
-	struct drm_buffer_object *bo =3D (struct drm_buffer_object *) vma->vm=
_private_data;
-
-	drm_vm_open_locked(vma);
-	atomic_inc(&bo->usage);
-}
-
-/**
- * \c vma open method for buffer objects.
- *
- * \param vma virtual memory area.
- */
-
-static void drm_bo_vm_open(struct vm_area_struct *vma)
-{
-	struct drm_buffer_object *bo =3D (struct drm_buffer_object *) vma->vm=
_private_data;
-	struct drm_device *dev =3D bo->dev;
-
-	mutex_lock(&dev->struct_mutex);
-	drm_bo_vm_open_locked(vma);
-	mutex_unlock(&dev->struct_mutex);
-}
-
-/**
- * \c vma close method for buffer objects.
- *
- * \param vma virtual memory area.
- */
-
-static void drm_bo_vm_close(struct vm_area_struct *vma)
-{
-	struct drm_buffer_object *bo =3D (struct drm_buffer_object *) vma->vm=
_private_data;
-	struct drm_device *dev =3D bo->dev;
-
-	drm_vm_close(vma);
-	if (bo) {
-		mutex_lock(&dev->struct_mutex);
-		drm_bo_usage_deref_locked((struct drm_buffer_object **)
-					  &vma->vm_private_data);
-		mutex_unlock(&dev->struct_mutex);
-	}
-	return;
-}
-
-static struct vm_operations_struct drm_bo_vm_ops =3D {
-	.fault =3D drm_bo_vm_fault,
-	.open =3D drm_bo_vm_open,
-	.close =3D drm_bo_vm_close,
-};
-
-/**
- * mmap buffer object memory.
- *
- * \param vma virtual memory area.
- * \param file_priv DRM file private.
- * \param map The buffer object drm map.
- * \return zero on success or a negative number on failure.
- */
-
-int drm_bo_mmap_locked(struct vm_area_struct *vma,
-		       struct file *filp,
-		       drm_local_map_t *map)
-{
-	vma->vm_ops =3D &drm_bo_vm_ops;
-	vma->vm_private_data =3D map->handle;
-	vma->vm_file =3D filp;
-	vma->vm_flags |=3D VM_RESERVED | VM_IO;
-	vma->vm_flags |=3D VM_PFNMAP;
-	drm_bo_vm_open_locked(vma);
-	return 0;
-}
diff -puN drivers/char/drm/i915_buffer.c~revert-git-drm /dev/null
--- a/drivers/char/drm/i915_buffer.c
+++ /dev/null
@@ -1,195 +0,0 @@
-/*********************************************************************=
*****
- *
- * Copyright 2006 Tungsten Graphics, Inc., Bismarck, ND., USA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaini=
ng a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject =
to
- * the following conditions:
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT =
SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR A=
NY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT =
OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE =
OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- * The above copyright notice and this permission notice (including th=
e
- * next paragraph) shall be included in all copies or substantial port=
ions
- * of the Software.
- *
- *
- *********************************************************************=
*****/
-/*
- * Authors: Thomas Hellstr=F6m <thomas-at-tungstengraphics-dot-com>
- */
-
-#include "drmP.h"
-#include "i915_drm.h"
-#include "i915_drv.h"
-
-struct drm_ttm_backend *i915_create_ttm_backend_entry(struct drm_devic=
e *dev)
-{
-	return drm_agp_init_ttm(dev);
-}
-
-int i915_fence_type(struct drm_buffer_object *bo,
-		     uint32_t *fclass,
-		     uint32_t *type)
-{
-	if (bo->mem.proposed_flags & (DRM_BO_FLAG_READ | DRM_BO_FLAG_WRITE))
-		*type =3D 3;
-	else
-		*type =3D 1;
-	return 0;
-}
-
-int i915_invalidate_caches(struct drm_device *dev, uint64_t flags)
-{
-	/*
-	 * FIXME: Only emit once per batchbuffer submission.
-	 */
-
-	uint32_t flush_cmd =3D MI_NO_WRITE_FLUSH;
-
-	if (flags & DRM_BO_FLAG_READ)
-		flush_cmd |=3D MI_READ_FLUSH;
-	if (flags & DRM_BO_FLAG_EXE)
-		flush_cmd |=3D MI_EXE_FLUSH;
-
-	return i915_emit_mi_flush(dev, flush_cmd);
-}
-
-int i915_init_mem_type(struct drm_device *dev, uint32_t type,
-		       struct drm_mem_type_manager *man)
-{
-	switch (type) {
-	case DRM_BO_MEM_LOCAL:
-		man->flags =3D _DRM_FLAG_MEMTYPE_MAPPABLE |
-		    _DRM_FLAG_MEMTYPE_CACHED;
-		man->drm_bus_maptype =3D 0;
-		man->gpu_offset =3D 0;
-		break;
-	case DRM_BO_MEM_TT:
-		if (!(drm_core_has_AGP(dev) && dev->agp)) {
-			DRM_ERROR("AGP is not enabled for memory type %u\n",
-				  (unsigned)type);
-			return -EINVAL;
-		}
-		man->io_offset =3D dev->agp->agp_info.aper_base;
-		man->io_size =3D dev->agp->agp_info.aper_size * 1024 * 1024;
-		man->io_addr =3D NULL;
-		man->flags =3D _DRM_FLAG_MEMTYPE_MAPPABLE |
-		    _DRM_FLAG_MEMTYPE_CSELECT | _DRM_FLAG_NEEDS_IOREMAP;
-		man->drm_bus_maptype =3D _DRM_AGP;
-		man->gpu_offset =3D 0;
-		break;
-	case DRM_BO_MEM_PRIV0:
-		if (!(drm_core_has_AGP(dev) && dev->agp)) {
-			DRM_ERROR("AGP is not enabled for memory type %u\n",
-				  (unsigned)type);
-			return -EINVAL;
-		}
-		man->io_offset =3D dev->agp->agp_info.aper_base;
-		man->io_size =3D dev->agp->agp_info.aper_size * 1024 * 1024;
-		man->io_addr =3D NULL;
-		man->flags =3D  _DRM_FLAG_MEMTYPE_MAPPABLE |
-		    _DRM_FLAG_MEMTYPE_FIXED | _DRM_FLAG_NEEDS_IOREMAP;
-		man->drm_bus_maptype =3D _DRM_AGP;
-		man->gpu_offset =3D 0;
-		break;
-	default:
-		DRM_ERROR("Unsupported memory type %u\n", (unsigned)type);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-/*
- * i915_evict_flags:
- *
- * @bo: the buffer object to be evicted
- *
- * Return the bo flags for a buffer which is not mapped to the hardwar=
e.
- * These will be placed in proposed_flags so that when the move is
- * finished, they'll end up in bo->mem.flags
- */
-uint64_t i915_evict_flags(struct drm_buffer_object *bo)
-{
-	switch (bo->mem.mem_type) {
-	case DRM_BO_MEM_LOCAL:
-	case DRM_BO_MEM_TT:
-		return DRM_BO_FLAG_MEM_LOCAL;
-	default:
-		return DRM_BO_FLAG_MEM_TT | DRM_BO_FLAG_CACHED;
-	}
-}
-
-
-/*
- * Disable i915_move_flip for now, since we can't guarantee that the h=
ardware lock
- * is held here. To re-enable we need to make sure either
- * a) The X server is using DRM to submit commands to the ring, or
- * b) DRM can use the HP ring for these blits. This means i915 needs t=
o
- * implement a new ring submission mechanism and fence class.
- */
-
-int i915_move(struct drm_buffer_object *bo,
-	      int evict, int no_wait, struct drm_bo_mem_reg *new_mem)
-{
-	struct drm_bo_mem_reg *old_mem =3D &bo->mem;
-
-	if (old_mem->mem_type =3D=3D DRM_BO_MEM_LOCAL) {
-		return drm_bo_move_memcpy(bo, evict, no_wait, new_mem);
-	} else if (new_mem->mem_type =3D=3D DRM_BO_MEM_LOCAL) {
-		if (0 /*i915_move_flip(bo, evict, no_wait, new_mem)*/)
-			return drm_bo_move_memcpy(bo, evict, no_wait, new_mem);
-	} else {
-		if (0 /*i915_move_blit(bo, evict, no_wait, new_mem)*/)
-			return drm_bo_move_memcpy(bo, evict, no_wait, new_mem);
-	}
-	return 0;
-}
-
-
-static inline void drm_cache_flush_addr(void *virt)
-{
-	int i;
-
-	for (i =3D 0; i < PAGE_SIZE; i +=3D boot_cpu_data.x86_clflush_size)
-		clflush(virt+i);
-}
-
-static inline void drm_cache_flush_page(struct page *p)
-{
-	drm_cache_flush_addr(page_address(p));
-}
-
-void i915_flush_ttm(struct drm_ttm *ttm)
-{
-	int i;
-
-	if (!ttm)
-		return;
-
-	DRM_MEMORYBARRIER();
-
-#ifdef CONFIG_X86_32
-	/* Hopefully nobody has built an x86-64 processor without clflush */
-	if (!cpu_has_clflush) {
-		wbinvd();
-		DRM_MEMORYBARRIER();
-		return;
-	}
-#endif
-
-	for (i =3D ttm->num_pages - 1; i >=3D 0; i--)
-		drm_cache_flush_page(drm_ttm_get_page(ttm, i));
-
-	DRM_MEMORYBARRIER();
-}
diff -puN drivers/char/drm/i915_dma.c~revert-git-drm drivers/char/drm/i=
915_dma.c
--- a/drivers/char/drm/i915_dma.c~revert-git-drm
+++ a/drivers/char/drm/i915_dma.c
@@ -36,7 +36,7 @@
  * the head pointer changes, so that EBUSY only happens if the ring
  * actually stalls for (eg) 3 seconds.
  */
-int i915_wait_ring(struct drm_device *dev, int n, const char *caller)
+int i915_wait_ring(struct drm_device * dev, int n, const char *caller)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	drm_i915_ring_buffer_t *ring =3D &(dev_priv->ring);
@@ -62,7 +62,7 @@ int i915_wait_ring(struct drm_device *de
 	return -EBUSY;
 }
=20
-void i915_kernel_lost_context(struct drm_device *dev)
+void i915_kernel_lost_context(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	drm_i915_ring_buffer_t *ring =3D &(dev_priv->ring);
@@ -77,7 +77,7 @@ void i915_kernel_lost_context(struct drm
 		dev_priv->sarea_priv->perf_boxes |=3D I915_BOX_RING_EMPTY;
 }
=20
-static int i915_dma_cleanup(struct drm_device *dev)
+static int i915_dma_cleanup(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	/* Make sure interrupts are disabled here because the uninstall ioctl
@@ -110,71 +110,9 @@ static int i915_dma_cleanup(struct drm_d
 	return 0;
 }
=20
-#define DRI2_SAREA_BLOCK_TYPE(b) ((b) >> 16)
-#define DRI2_SAREA_BLOCK_SIZE(b) ((b) & 0xffff)
-#define DRI2_SAREA_BLOCK_NEXT(p)				\
-	((void *) ((unsigned char *) (p) +			\
-		   DRI2_SAREA_BLOCK_SIZE(*(unsigned int *) p)))
-
-#define DRI2_SAREA_BLOCK_END		0x0000
-#define DRI2_SAREA_BLOCK_LOCK		0x0001
-#define DRI2_SAREA_BLOCK_EVENT_BUFFER	0x0002
-
-static int
-setup_dri2_sarea(struct drm_device * dev,
-		 struct drm_file *file_priv,
-		 drm_i915_init_t * init)
+static int i915_initialize(struct drm_device * dev, drm_i915_init_t * =
init)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
-	int ret;
-	unsigned int *p, *end, *next;
-
-	mutex_lock(&dev->struct_mutex);
-	dev_priv->sarea_bo =3D
-		drm_lookup_buffer_object(file_priv,
-					 init->sarea_handle, 1);
-	mutex_unlock(&dev->struct_mutex);
-
-	if (!dev_priv->sarea_bo) {
-		DRM_ERROR("did not find sarea bo\n");
-		return -EINVAL;
-	}
-
-	ret =3D drm_bo_kmap(dev_priv->sarea_bo, 0,
-			  dev_priv->sarea_bo->num_pages,
-			  &dev_priv->sarea_kmap);
-	if (ret) {
-		DRM_ERROR("could not map sarea bo\n");
-		return ret;
-	}
-
-	p =3D dev_priv->sarea_kmap.virtual;
-	end =3D (void *) p + (dev_priv->sarea_bo->num_pages << PAGE_SHIFT);
-	while (p < end && DRI2_SAREA_BLOCK_TYPE(*p) !=3D DRI2_SAREA_BLOCK_END=
) {
-		switch (DRI2_SAREA_BLOCK_TYPE(*p)) {
-		case DRI2_SAREA_BLOCK_LOCK:
-			dev->lock.hw_lock =3D (void *) (p + 1);
-			dev->sigdata.lock =3D dev->lock.hw_lock;
-			break;
-		}
-		next =3D DRI2_SAREA_BLOCK_NEXT(p);
-		if (next <=3D p || end < next) {
-			DRM_ERROR("malformed dri2 sarea: next is %p should be within %p-%p\=
n",
-				  next, p, end);
-			return -EINVAL;
-		}
-		p =3D next;
-	}
-
-	return 0;
-}
-
-static int i915_initialize(struct drm_device *dev,
-			   struct drm_file *file_priv,
-			   drm_i915_init_t * init)
-{
-	drm_i915_private_t *dev_priv =3D dev->dev_private;
-	int ret;
=20
 	dev_priv->sarea =3D drm_getsarea(dev);
 	if (!dev_priv->sarea) {
@@ -183,24 +121,15 @@ static int i915_initialize(struct drm_de
 		return -EINVAL;
 	}
=20
-	if (init->mmio_offset !=3D 0)
-		dev_priv->mmio_map =3D drm_core_findmap(dev, init->mmio_offset);
+	dev_priv->mmio_map =3D drm_core_findmap(dev, init->mmio_offset);
 	if (!dev_priv->mmio_map) {
 		i915_dma_cleanup(dev);
 		DRM_ERROR("can not find mmio map!\n");
 		return -EINVAL;
 	}
=20
-	dev_priv->max_validate_buffers =3D I915_MAX_VALIDATE_BUFFERS;
-
-	if (init->sarea_priv_offset)
-		dev_priv->sarea_priv =3D (drm_i915_sarea_t *)
-			((u8 *) dev_priv->sarea->handle +
-			 init->sarea_priv_offset);
-	else {
-		/* No sarea_priv for you! */
-		dev_priv->sarea_priv =3D NULL;
-	}
+	dev_priv->sarea_priv =3D (drm_i915_sarea_t *)
+	    ((u8 *) dev_priv->sarea->handle + init->sarea_priv_offset);
=20
 	dev_priv->ring.Start =3D init->ring_start;
 	dev_priv->ring.End =3D init->ring_end;
@@ -225,9 +154,10 @@ static int i915_initialize(struct drm_de
 	dev_priv->ring.virtual_start =3D dev_priv->ring.map.handle;
=20
 	dev_priv->cpp =3D init->cpp;
-
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->pf_current_page =3D 0;
+	dev_priv->back_offset =3D init->back_offset;
+	dev_priv->front_offset =3D init->front_offset;
+	dev_priv->current_page =3D 0;
+	dev_priv->sarea_priv->pf_current_page =3D dev_priv->current_page;
=20
 	/* We are using separate values as placeholders for mechanisms for
 	 * private backbuffer/depthbuffer usage.
@@ -240,10 +170,6 @@ static int i915_initialize(struct drm_de
 	 */
 	dev_priv->allow_batchbuffer =3D 1;
=20
-	/* Enable vblank on pipe A for older X servers
-	 */
-	dev_priv->vblank_pipe =3D DRM_I915_VBLANK_PIPE_A;
-
 	/* Program Hardware Status Page */
 	if (!I915_NEED_GFX_HWS(dev)) {
 		dev_priv->status_page_dmah =3D
@@ -261,20 +187,10 @@ static int i915_initialize(struct drm_de
 		I915_WRITE(0x02080, dev_priv->dma_status_page);
 	}
 	DRM_DEBUG("Enabled hardware status page\n");
-	mutex_init(&dev_priv->cmdbuf_mutex);
-
-	if (init->func =3D=3D I915_INIT_DMA2) {
-		ret =3D setup_dri2_sarea(dev, file_priv, init);
-		if (ret) {
-			i915_dma_cleanup(dev);
-			DRM_ERROR("could not set up dri2 sarea\n");
-			return ret;
-		}
-	}
 	return 0;
 }
=20
-static int i915_dma_resume(struct drm_device *dev)
+static int i915_dma_resume(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
=20
@@ -320,8 +236,7 @@ static int i915_dma_init(struct drm_devi
=20
 	switch (init->func) {
 	case I915_INIT_DMA:
-	case I915_INIT_DMA2:
-		retcode =3D i915_initialize(dev, file_priv, init);
+		retcode =3D i915_initialize(dev, init);
 		break;
 	case I915_CLEANUP_DMA:
 		retcode =3D i915_dma_cleanup(dev);
@@ -413,7 +328,7 @@ static int validate_cmd(int cmd)
 	return ret;
 }
=20
-static int i915_emit_cmds(struct drm_device *dev, int __user * buffer,=
 int dwords)
+static int i915_emit_cmds(struct drm_device * dev, int __user * buffer=
, int dwords)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	int i;
@@ -452,7 +367,7 @@ static int i915_emit_cmds(struct drm_dev
 	return 0;
 }
=20
-static int i915_emit_box(struct drm_device *dev,
+static int i915_emit_box(struct drm_device * dev,
 			 struct drm_clip_rect __user * boxes,
 			 int i, int DR1, int DR4)
 {
@@ -495,18 +410,15 @@ static int i915_emit_box(struct drm_devi
  * emit. For now, do it in both places:
  */
=20
-void i915_emit_breadcrumb(struct drm_device *dev)
+static void i915_emit_breadcrumb(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	RING_LOCALS;
=20
-	if (++dev_priv->counter > BREADCRUMB_MASK) {
-		dev_priv->counter =3D 1;
-		DRM_DEBUG("Breadcrumb counter wrapped around\n");
-	}
+	dev_priv->sarea_priv->last_enqueue =3D ++dev_priv->counter;
=20
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->last_enqueue =3D dev_priv->counter;
+	if (dev_priv->counter > 0x7FFFFFFFUL)
+		dev_priv->sarea_priv->last_enqueue =3D dev_priv->counter =3D 1;
=20
 	BEGIN_LP_RING(4);
 	OUT_RING(CMD_STORE_DWORD_IDX);
@@ -516,32 +428,9 @@ void i915_emit_breadcrumb(struct drm_dev
 	ADVANCE_LP_RING();
 }
=20
-
-int i915_emit_mi_flush(struct drm_device *dev, uint32_t flush)
-{
-	drm_i915_private_t *dev_priv =3D dev->dev_private;
-	uint32_t flush_cmd =3D CMD_MI_FLUSH;
-	RING_LOCALS;
-
-	flush_cmd |=3D flush;
-
-	i915_kernel_lost_context(dev);
-
-	BEGIN_LP_RING(4);
-	OUT_RING(flush_cmd);
-	OUT_RING(0);
-	OUT_RING(0);
-	OUT_RING(0);
-	ADVANCE_LP_RING();
-
-	return 0;
-}
-
-
-static int i915_dispatch_cmdbuffer(struct drm_device *dev,
+static int i915_dispatch_cmdbuffer(struct drm_device * dev,
 				   drm_i915_cmdbuffer_t * cmd)
 {
-	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	int nbox =3D cmd->num_cliprects;
 	int i =3D 0, count, ret;
=20
@@ -568,12 +457,10 @@ static int i915_dispatch_cmdbuffer(struc
 	}
=20
 	i915_emit_breadcrumb(dev);
-	if (unlikely((dev_priv->counter & 0xFF) =3D=3D 0))
-		drm_fence_flush_old(dev, 0, dev_priv->counter);
 	return 0;
 }
=20
-static int i915_dispatch_batchbuffer(struct drm_device *dev,
+static int i915_dispatch_batchbuffer(struct drm_device * dev,
 				     drm_i915_batchbuffer_t * batch)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
@@ -620,85 +507,59 @@ static int i915_dispatch_batchbuffer(str
 	}
=20
 	i915_emit_breadcrumb(dev);
-	if (unlikely((dev_priv->counter & 0xFF) =3D=3D 0))
-		drm_fence_flush_old(dev, 0, dev_priv->counter);
=20
 	return 0;
 }
=20
-static void i915_do_dispatch_flip(struct drm_device *dev, int plane, i=
nt sync)
+static int i915_dispatch_flip(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
-	u32 num_pages, current_page, next_page, dspbase;
-	int shift =3D 2 * plane, x, y;
 	RING_LOCALS;
=20
-	/* Calculate display base offset */
-	num_pages =3D dev_priv->sarea_priv->third_handle ? 3 : 2;
-	current_page =3D (dev_priv->sarea_priv->pf_current_page >> shift) & 0=
x3;
-	next_page =3D (current_page + 1) % num_pages;
+	DRM_DEBUG("%s: page=3D%d pfCurrentPage=3D%d\n",
+		  __FUNCTION__,
+		  dev_priv->current_page,
+		  dev_priv->sarea_priv->pf_current_page);
=20
-	switch (next_page) {
-	default:
-	case 0:
-		dspbase =3D dev_priv->sarea_priv->front_offset;
-		break;
-	case 1:
-		dspbase =3D dev_priv->sarea_priv->back_offset;
-		break;
-	case 2:
-		dspbase =3D dev_priv->sarea_priv->third_offset;
-		break;
-	}
+	i915_kernel_lost_context(dev);
=20
-	if (plane =3D=3D 0) {
-		x =3D dev_priv->sarea_priv->planeA_x;
-		y =3D dev_priv->sarea_priv->planeA_y;
+	BEGIN_LP_RING(2);
+	OUT_RING(INST_PARSER_CLIENT | INST_OP_FLUSH | INST_FLUSH_MAP_CACHE);
+	OUT_RING(0);
+	ADVANCE_LP_RING();
+
+	BEGIN_LP_RING(6);
+	OUT_RING(CMD_OP_DISPLAYBUFFER_INFO | ASYNC_FLIP);
+	OUT_RING(0);
+	if (dev_priv->current_page =3D=3D 0) {
+		OUT_RING(dev_priv->back_offset);
+		dev_priv->current_page =3D 1;
 	} else {
-		x =3D dev_priv->sarea_priv->planeB_x;
-		y =3D dev_priv->sarea_priv->planeB_y;
+		OUT_RING(dev_priv->front_offset);
+		dev_priv->current_page =3D 0;
 	}
+	OUT_RING(0);
+	ADVANCE_LP_RING();
=20
-	dspbase +=3D (y * dev_priv->sarea_priv->pitch + x) * dev_priv->cpp;
+	BEGIN_LP_RING(2);
+	OUT_RING(MI_WAIT_FOR_EVENT | MI_WAIT_FOR_PLANE_A_FLIP);
+	OUT_RING(0);
+	ADVANCE_LP_RING();
=20
-	DRM_DEBUG("plane=3D%d current_page=3D%d dspbase=3D0x%x\n", plane, cur=
rent_page,
-		  dspbase);
+	dev_priv->sarea_priv->last_enqueue =3D dev_priv->counter++;
=20
 	BEGIN_LP_RING(4);
-	OUT_RING(sync ? 0 :
-		 (MI_WAIT_FOR_EVENT | (plane ? MI_WAIT_FOR_PLANE_B_FLIP :
-				       MI_WAIT_FOR_PLANE_A_FLIP)));
-	OUT_RING(CMD_OP_DISPLAYBUFFER_INFO | (sync ? 0 : ASYNC_FLIP) |
-		 (plane ? DISPLAY_PLANE_B : DISPLAY_PLANE_A));
-	OUT_RING(dev_priv->sarea_priv->pitch * dev_priv->cpp);
-	OUT_RING(dspbase);
+	OUT_RING(CMD_STORE_DWORD_IDX);
+	OUT_RING(20);
+	OUT_RING(dev_priv->counter);
+	OUT_RING(0);
 	ADVANCE_LP_RING();
=20
-	dev_priv->sarea_priv->pf_current_page &=3D ~(0x3 << shift);
-	dev_priv->sarea_priv->pf_current_page |=3D next_page << shift;
-}
-
-void i915_dispatch_flip(struct drm_device *dev, int planes, int sync)
-{
-	drm_i915_private_t *dev_priv =3D dev->dev_private;
-	int i;
-
-	DRM_DEBUG("%s: planes=3D0x%x pfCurrentPage=3D%d\n",
-		  __FUNCTION__,
-		  planes, dev_priv->sarea_priv->pf_current_page);
-
-	i915_emit_mi_flush(dev, MI_READ_FLUSH | MI_EXE_FLUSH);
-
-	for (i =3D 0; i < 2; i++)
-		if (planes & (1 << i))
-			i915_do_dispatch_flip(dev, i, sync);
-
-	i915_emit_breadcrumb(dev);
-	if (unlikely(!sync && ((dev_priv->counter & 0xFF) =3D=3D 0)))
-		drm_fence_flush_old(dev, 0, dev_priv->counter);
+	dev_priv->sarea_priv->pf_current_page =3D dev_priv->current_page;
+	return 0;
 }
=20
-static int i915_quiescent(struct drm_device *dev)
+static int i915_quiescent(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
=20
@@ -718,6 +579,7 @@ static int i915_batchbuffer(struct drm_d
 			    struct drm_file *file_priv)
 {
 	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
+	u32 *hw_status =3D dev_priv->hw_status_page;
 	drm_i915_sarea_t *sarea_priv =3D (drm_i915_sarea_t *)
 	    dev_priv->sarea_priv;
 	drm_i915_batchbuffer_t *batch =3D data;
@@ -740,7 +602,7 @@ static int i915_batchbuffer(struct drm_d
=20
 	ret =3D i915_dispatch_batchbuffer(dev, batch);
=20
-	sarea_priv->last_dispatch =3D READ_BREADCRUMB(dev_priv);
+	sarea_priv->last_dispatch =3D (int)hw_status[5];
 	return ret;
 }
=20
@@ -748,6 +610,7 @@ static int i915_cmdbuffer(struct drm_dev
 			  struct drm_file *file_priv)
 {
 	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
+	u32 *hw_status =3D dev_priv->hw_status_page;
 	drm_i915_sarea_t *sarea_priv =3D (drm_i915_sarea_t *)
 	    dev_priv->sarea_priv;
 	drm_i915_cmdbuffer_t *cmdbuf =3D data;
@@ -772,603 +635,18 @@ static int i915_cmdbuffer(struct drm_dev
 		return ret;
 	}
=20
-	sarea_priv->last_dispatch =3D READ_BREADCRUMB(dev_priv);
-	return 0;
-}
-
-#if DRM_DEBUG_CODE
-#define DRM_DEBUG_RELOCATION  (drm_debug !=3D 0)
-#else
-#define DRM_DEBUG_RELOCATION  0
-#endif
-
-struct i915_relocatee_info {
-	struct drm_buffer_object *buf;
-	unsigned long offset;
-	u32 *data_page;
-	unsigned page_offset;
-	struct drm_bo_kmap_obj kmap;
-	int is_iomem;
-	int idle;
-};
-
-struct drm_i915_validate_buffer {
-	struct drm_buffer_object *buffer;
-	struct drm_bo_info_rep rep;
-	int presumed_offset_correct;
-	void __user *data;
-	int ret;
-};
-
-static void i915_dereference_buffers_locked(struct drm_i915_validate_b=
uffer *buffers,
-					    unsigned num_buffers)
-{
-	while (num_buffers--)
-		drm_bo_usage_deref_locked(&buffers[num_buffers].buffer);
-}
-
-int i915_apply_reloc(struct drm_file *file_priv, int num_buffers,
-		     struct drm_i915_validate_buffer *buffers,
-		     struct i915_relocatee_info *relocatee,
-		     uint32_t *reloc)
-{
-	unsigned index;
-	unsigned long new_cmd_offset;
-	u32 val;
-	int ret, i;
-	int buf_index =3D -1;
-
-	/*
-	 * FIXME: O(relocs * buffers) complexity.
-	 */
-
-	for (i =3D 0; i <=3D num_buffers; i++)
-		if (buffers[i].buffer)
-			if (reloc[2] =3D=3D buffers[i].buffer->base.hash.key)
-				buf_index =3D i;
-
-	if (buf_index =3D=3D -1) {
-		DRM_ERROR("Illegal relocation buffer %08X\n", reloc[2]);
-		return -EINVAL;
-	}
-
-	/*
-	 * Short-circuit relocations that were correctly
-	 * guessed by the client
-	 */
-	if (buffers[buf_index].presumed_offset_correct && !DRM_DEBUG_RELOCATI=
ON)
-		return 0;
-
-	new_cmd_offset =3D reloc[0];
-	if (!relocatee->data_page ||
-	    !drm_bo_same_page(relocatee->offset, new_cmd_offset)) {
-		drm_bo_kunmap(&relocatee->kmap);
-		relocatee->data_page =3D NULL;
-		relocatee->offset =3D new_cmd_offset;
-	=09
-		if (unlikely(!relocatee->idle)) {
-			ret =3D drm_bo_wait(relocatee->buf, 0, 0, 0);
-			if (ret)
-				return ret;
-			relocatee->idle =3D 1;
-		}
-
-		ret =3D drm_bo_kmap(relocatee->buf, new_cmd_offset >> PAGE_SHIFT,
-				  1, &relocatee->kmap);
-		if (ret) {
-			DRM_ERROR("Could not map command buffer to apply relocs\n %08lx", n=
ew_cmd_offset);
-			return ret;
-		}
-		relocatee->data_page =3D drm_bmo_virtual(&relocatee->kmap,
-						       &relocatee->is_iomem);
-		relocatee->page_offset =3D (relocatee->offset & PAGE_MASK);
-	}
-
-	val =3D buffers[buf_index].buffer->offset;
-	index =3D (reloc[0] - relocatee->page_offset) >> 2;
-
-	/* add in validate */
-	val =3D val + reloc[1];
-
-	if (DRM_DEBUG_RELOCATION) {
-		if (buffers[buf_index].presumed_offset_correct &&
-		    relocatee->data_page[index] !=3D val) {
-			DRM_DEBUG ("Relocation mismatch source %d target %d buffer %d user =
%08x kernel %08x\n",
-				   reloc[0], reloc[1], buf_index, relocatee->data_page[index], val=
);
-		}
-	}
-
-	if (relocatee->is_iomem)
-		iowrite32(val, relocatee->data_page + index);
-	else
-		relocatee->data_page[index] =3D val;
-	return 0;
-}
-
-int i915_process_relocs(struct drm_file *file_priv,
-			uint32_t buf_handle,
-			uint32_t __user **reloc_user_ptr,
-			struct i915_relocatee_info *relocatee,
-			struct drm_i915_validate_buffer *buffers,
-			uint32_t num_buffers)
-{
-	int ret, reloc_stride;
-	uint32_t cur_offset;
-	uint32_t reloc_count;
-	uint32_t reloc_type;
-	uint32_t reloc_buf_size;
-	uint32_t *reloc_buf =3D NULL;
-	int i;
-
-	/* do a copy from user from the user ptr */
-	ret =3D get_user(reloc_count, *reloc_user_ptr);
-	if (ret) {
-		DRM_ERROR("Could not map relocation buffer.\n");
-		goto out;
-	}
-
-	ret =3D get_user(reloc_type, (*reloc_user_ptr)+1);
-	if (ret) {
-		DRM_ERROR("Could not map relocation buffer.\n");
-		goto out;
-	}
-
-	if (reloc_type !=3D 0) {
-		DRM_ERROR("Unsupported relocation type requested\n");
-		ret =3D -EINVAL;
-		goto out;
-	}
-
-	reloc_buf_size =3D (I915_RELOC_HEADER + (reloc_count * I915_RELOC0_ST=
RIDE)) * sizeof(uint32_t);
-	reloc_buf =3D kmalloc(reloc_buf_size, GFP_KERNEL);
-	if (!reloc_buf) {
-		DRM_ERROR("Out of memory for reloc buffer\n");
-		ret =3D -ENOMEM;
-		goto out;
-	}
-
-	if (copy_from_user(reloc_buf, *reloc_user_ptr, reloc_buf_size)) {
-		ret =3D -EFAULT;
-		goto out;
-	}
-
-	/* get next relocate buffer handle */
-	*reloc_user_ptr =3D (uint32_t *)*(unsigned long *)&reloc_buf[2];
-
-	reloc_stride =3D I915_RELOC0_STRIDE * sizeof(uint32_t); /* may be dif=
ferent for other types of relocs */
-
-	DRM_DEBUG("num relocs is %d, next is %p\n", reloc_count, *reloc_user_=
ptr);
-
-	for (i =3D 0; i < reloc_count; i++) {
-		cur_offset =3D I915_RELOC_HEADER + (i * I915_RELOC0_STRIDE);
-		 =20
-		ret =3D i915_apply_reloc(file_priv, num_buffers, buffers,
-				       relocatee, reloc_buf + cur_offset);
-		if (ret)
-			goto out;
-	}
-
-out:
-	if (reloc_buf)
-		kfree(reloc_buf);
-
-	if (relocatee->data_page) {	=09
-		drm_bo_kunmap(&relocatee->kmap);
-		relocatee->data_page =3D NULL;
-	}
-
-	return ret;
-}
-
-static int i915_exec_reloc(struct drm_file *file_priv, drm_handle_t bu=
f_handle,
-			   uint32_t __user *reloc_user_ptr,
-			   struct drm_i915_validate_buffer *buffers,
-			   uint32_t buf_count)
-{
-	struct drm_device *dev =3D file_priv->head->dev;
-	struct i915_relocatee_info relocatee;
-	int ret =3D 0;
-	int b;
-
-	/*
-	 * Short circuit relocations when all previous
-	 * buffers offsets were correctly guessed by
-	 * the client
-	 */
-	if (!DRM_DEBUG_RELOCATION) {
-		for (b =3D 0; b < buf_count; b++)
-			if (!buffers[b].presumed_offset_correct)
-				break;
-
-		if (b =3D=3D buf_count)
-			return 0;
-	}
-
-	memset(&relocatee, 0, sizeof(relocatee));
-
-	mutex_lock(&dev->struct_mutex);
-	relocatee.buf =3D drm_lookup_buffer_object(file_priv, buf_handle, 1);
-	mutex_unlock(&dev->struct_mutex);
-	if (!relocatee.buf) {
-		DRM_DEBUG("relocatee buffer invalid %08x\n", buf_handle);
-		ret =3D -EINVAL;
-		goto out_err;
-	}
-
-	mutex_lock (&relocatee.buf->mutex);
-	while (reloc_user_ptr) {
-		ret =3D i915_process_relocs(file_priv, buf_handle, &reloc_user_ptr, =
&relocatee, buffers, buf_count);
-		if (ret) {
-			DRM_ERROR("process relocs failed\n");
-			goto out_err1;
-		}
-	}
-
-out_err1:
-	mutex_unlock (&relocatee.buf->mutex);
-	drm_bo_usage_deref_unlocked(&relocatee.buf);
-out_err:
-	return ret;
-}
-
-static int i915_check_presumed(struct drm_i915_op_arg *arg,
-			       struct drm_buffer_object *bo,
-			       uint32_t __user *data,
-			       int *presumed_ok)
-{
-	struct drm_bo_op_req *req =3D &arg->d.req;
-	uint32_t hint_offset;
-	uint32_t hint =3D req->bo_req.hint;
-
-	*presumed_ok =3D 0;
-
-	if (!(hint & DRM_BO_HINT_PRESUMED_OFFSET))
-		return 0;
-	if (bo->offset =3D=3D req->bo_req.presumed_offset) {
-		*presumed_ok =3D 1;
-		return 0;
-	}
-
-	/*
-	 * We need to turn off the HINT_PRESUMED_OFFSET for this buffer in
-	 * the user-space IOCTL argument list, since the buffer has moved,
-	 * we're about to apply relocations and we might subsequently
-	 * hit an -EAGAIN. In that case the argument list will be reused by
-	 * user-space, but the presumed offset is no longer valid.
-	 *
-	 * Needless to say, this is a bit ugly.
-	 */
-
-       	hint_offset =3D (uint32_t *)&req->bo_req.hint - (uint32_t *)ar=
g;
-	hint &=3D ~DRM_BO_HINT_PRESUMED_OFFSET;
-	return __put_user(hint, data + hint_offset);
-}
-
-
-/*
- * Validate, add fence and relocate a block of bos from a userspace li=
st
- */
-int i915_validate_buffer_list(struct drm_file *file_priv,
-			      unsigned int fence_class, uint64_t data,
-			      struct drm_i915_validate_buffer *buffers,
-			      uint32_t *num_buffers)
-{
-	struct drm_i915_op_arg arg;
-	struct drm_bo_op_req *req =3D &arg.d.req;
-	int ret =3D 0;
-	unsigned buf_count =3D 0;
-	uint32_t buf_handle;
-	uint32_t __user *reloc_user_ptr;
-	struct drm_i915_validate_buffer *item =3D buffers;
-
-	do {
-		if (buf_count >=3D *num_buffers) {
-			DRM_ERROR("Buffer count exceeded %d\n.", *num_buffers);
-			ret =3D -EINVAL;
-			goto out_err;
-		}
-		item =3D buffers + buf_count;
-		item->buffer =3D NULL;
-		item->presumed_offset_correct =3D 0;
-
-		buffers[buf_count].buffer =3D NULL;
-
-		if (copy_from_user(&arg, (void __user *)(unsigned long)data, sizeof(=
arg))) {
-			ret =3D -EFAULT;
-			goto out_err;
-		}
-
-		ret =3D 0;
-		if (req->op !=3D drm_bo_validate) {
-			DRM_ERROR
-			    ("Buffer object operation wasn't \"validate\".\n");
-			ret =3D -EINVAL;
-			goto out_err;
-		}
-		item->ret =3D 0;
-		item->data =3D (void __user *) (unsigned long) data;
-
-		buf_handle =3D req->bo_req.handle;
-		reloc_user_ptr =3D (uint32_t *)(unsigned long)arg.reloc_ptr;
-
-		if (reloc_user_ptr) {
-			ret =3D i915_exec_reloc(file_priv, buf_handle, reloc_user_ptr, buff=
ers, buf_count);
-			if (ret)
-				goto out_err;
-			DRM_MEMORYBARRIER();
-		}
-
-		ret =3D drm_bo_handle_validate(file_priv, req->bo_req.handle,
-					     req->bo_req.flags, req->bo_req.mask,
-					     req->bo_req.hint,
-					     req->bo_req.fence_class, 0,
-					     &item->rep,
-					     &item->buffer);
-
-		if (ret) {
-			DRM_ERROR("error on handle validate %d\n", ret);
-			goto out_err;
-		}
-
-		buf_count++;
-
-		ret =3D i915_check_presumed(&arg, item->buffer,
-					  (uint32_t __user *)
-					  (unsigned long) data,
-					  &item->presumed_offset_correct);
-		if (ret)
-			goto out_err;
-
-		data =3D arg.next;
-	} while (data !=3D 0);
-	*num_buffers =3D buf_count;
-	return 0;
-out_err:
-	*num_buffers =3D 0;
-	item->ret =3D (ret !=3D -EAGAIN) ? ret : 0;
-	return ret;
-}
-
-/*
- * Remove all buffers from the unfenced list.
- * If the execbuffer operation was aborted, for example due to a signa=
l,
- * this also make sure that buffers retain their original state and
- * fence pointers.
- * Copy back buffer information to user-space unless we were interrupt=
ed
- * by a signal. In which case the IOCTL must be rerun.
- */
-
-static int i915_handle_copyback(struct drm_device *dev,
-				struct drm_i915_validate_buffer *buffers,
-				unsigned int num_buffers, int ret)
-{
-	int err =3D ret;
-	int i;
-	struct drm_i915_op_arg arg;
-
-	if (ret)
-		drm_putback_buffer_objects(dev);
-
-	if (ret !=3D -EAGAIN) {
-		for (i =3D 0; i < num_buffers; ++i) {
-			arg.handled =3D 1;
-			arg.d.rep.ret =3D buffers->ret;
-			arg.d.rep.bo_info =3D buffers->rep;
-			if (__copy_to_user(buffers->data, &arg, sizeof(arg)))
-				err =3D -EFAULT;
-			buffers++;
-		}
-	}
-
-	return err;
-}
-
-/*
- * Create a fence object, and if that fails, pretend that everything i=
s
- * OK and just idle the GPU.
- */
-
-void i915_fence_or_sync(struct drm_file *file_priv,
-			uint32_t fence_flags,
-			struct drm_fence_arg *fence_arg,
-			struct drm_fence_object **fence_p)
-{
-	struct drm_device *dev =3D file_priv->head->dev;
-	int ret;
-	struct drm_fence_object *fence;
-
-	ret =3D drm_fence_buffer_objects(dev, NULL, fence_flags,
-			 NULL, &fence);
-
-	if (ret) {
-
-		/*
-		 * Fence creation failed.
-		 * Fall back to synchronous operation and idle the engine.
-		 */
-
-		(void) i915_emit_mi_flush(dev, MI_READ_FLUSH);
-		(void) i915_quiescent(dev);
-
-		if (!(fence_flags & DRM_FENCE_FLAG_NO_USER)) {
-
-			/*
-			 * Communicate to user-space that
-			 * fence creation has failed and that
-			 * the engine is idle.
-			 */
-
-			fence_arg->handle =3D ~0;
-			fence_arg->error =3D ret;
-		}
-
-		drm_putback_buffer_objects(dev);
-		if (fence_p)
-		    *fence_p =3D NULL;
-		return;
-	}
-
-	if (!(fence_flags & DRM_FENCE_FLAG_NO_USER)) {
-
-		ret =3D drm_fence_add_user_object(file_priv, fence,
-						fence_flags &
-						DRM_FENCE_FLAG_SHAREABLE);
-		if (!ret)
-			drm_fence_fill_arg(fence, fence_arg);
-		else {
-			/*
-			 * Fence user object creation failed.
-			 * We must idle the engine here as well, as user-
-			 * space expects a fence object to wait on. Since we
-			 * have a fence object we wait for it to signal
-			 * to indicate engine "sufficiently" idle.
-			 */
-
-			(void) drm_fence_object_wait(fence, 0, 1,
-						     fence->type);
-			drm_fence_usage_deref_unlocked(&fence);
-			fence_arg->handle =3D ~0;
-			fence_arg->error =3D ret;
-		}
-	}
-
-	if (fence_p)
-		*fence_p =3D fence;
-	else if (fence)
-		drm_fence_usage_deref_unlocked(&fence);
-}
-
-static int i915_execbuffer(struct drm_device *dev, void *data,
-			   struct drm_file *file_priv)
-{
-	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
-	drm_i915_sarea_t *sarea_priv =3D (drm_i915_sarea_t *)
-		dev_priv->sarea_priv;
-	struct drm_i915_execbuffer *exec_buf =3D data;
-	struct drm_i915_batchbuffer *batch =3D &exec_buf->batch;
-	struct drm_fence_arg *fence_arg =3D &exec_buf->fence_arg;
-	int num_buffers;
-	int ret;
-	struct drm_i915_validate_buffer *buffers;
-
-	if (!dev_priv->allow_batchbuffer) {
-		DRM_ERROR("Batchbuffer ioctl disabled\n");
-		return -EINVAL;
-	}
-
-
-	if (batch->num_cliprects && DRM_VERIFYAREA_READ(batch->cliprects,
-							batch->num_cliprects *
-							sizeof(struct drm_clip_rect)))
-		return -EFAULT;
-
-	if (exec_buf->num_buffers > dev_priv->max_validate_buffers)
-		return -EINVAL;
-
-
-	ret =3D drm_bo_read_lock(&dev->bm.bm_lock);
-	if (ret)
-		return ret;
-
-	/*
-	 * The cmdbuf_mutex makes sure the validate-submit-fence
-	 * operation is atomic.
-	 */
-
-	ret =3D mutex_lock_interruptible(&dev_priv->cmdbuf_mutex);
-	if (ret) {
-		drm_bo_read_unlock(&dev->bm.bm_lock);
-		return -EAGAIN;
-	}
-
-	num_buffers =3D exec_buf->num_buffers;
-
-	buffers =3D drm_calloc(num_buffers, sizeof(struct drm_i915_validate_b=
uffer), DRM_MEM_DRIVER);
-	if (!buffers) {
-		drm_bo_read_unlock(&dev->bm.bm_lock);
-		mutex_unlock(&dev_priv->cmdbuf_mutex);
-		return -ENOMEM;
-	}
-
-	/* validate buffer list + fixup relocations */
-	ret =3D i915_validate_buffer_list(file_priv, 0, exec_buf->ops_list,
-					buffers, &num_buffers);
-	if (ret)
-		goto out_err0;
-
-	/* make sure all previous memory operations have passed */
-	DRM_MEMORYBARRIER();
-	drm_agp_chipset_flush(dev);
-
-	/* submit buffer */
-	batch->start =3D buffers[num_buffers-1].buffer->offset;
-
-	DRM_DEBUG("i915 exec batchbuffer, start %x used %d cliprects %d\n",
-		  batch->start, batch->used, batch->num_cliprects);
-
-	ret =3D i915_dispatch_batchbuffer(dev, batch);
-	if (ret)
-		goto out_err0;
-
-	if (sarea_priv)
-		sarea_priv->last_dispatch =3D READ_BREADCRUMB(dev_priv);
-
-	i915_fence_or_sync(file_priv, fence_arg->flags, fence_arg, NULL);
-out_err0:
-
-	/* handle errors */
-	ret =3D i915_handle_copyback(dev, buffers, num_buffers, ret);
-	mutex_lock(&dev->struct_mutex);
-	i915_dereference_buffers_locked(buffers, num_buffers);
-	mutex_unlock(&dev->struct_mutex);
-
-	drm_free(buffers, (exec_buf->num_buffers * sizeof(struct drm_buffer_o=
bject *)), DRM_MEM_DRIVER);
-
-	mutex_unlock(&dev_priv->cmdbuf_mutex);
-	drm_bo_read_unlock(&dev->bm.bm_lock);
-	return ret;
-}
-
-static int i915_do_cleanup_pageflip(struct drm_device *dev)
-{
-	drm_i915_private_t *dev_priv =3D dev->dev_private;
-	int i, planes, num_pages =3D dev_priv->sarea_priv->third_handle ? 3 :=
 2;
-
-	DRM_DEBUG("%s\n", __FUNCTION__);
-
-	for (i =3D 0, planes =3D 0; i < 2; i++)
-		if (dev_priv->sarea_priv->pf_current_page & (0x3 << (2 * i))) {
-			dev_priv->sarea_priv->pf_current_page =3D
-				(dev_priv->sarea_priv->pf_current_page &
-				 ~(0x3 << (2 * i))) | (num_pages - 1) << (2 * i);
-
-			planes |=3D 1 << i;
-		}
-
-	if (planes)
-		i915_dispatch_flip(dev, planes, 0);
-
+	sarea_priv->last_dispatch =3D (int)hw_status[5];
 	return 0;
 }
=20
-static int i915_flip_bufs(struct drm_device *dev, void *data, struct d=
rm_file *file_priv)
+static int i915_flip_bufs(struct drm_device *dev, void *data,
+			  struct drm_file *file_priv)
 {
-	drm_i915_flip_t *param =3D data;
-
 	DRM_DEBUG("%s\n", __FUNCTION__);
=20
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
=20
-	/* This is really planes */
-	if (param->pipes & ~0x3) {
-		DRM_ERROR("Invalid planes 0x%x, only <=3D 0x3 is valid\n",
-			  param->pipes);
-		return -EINVAL;
-	}
-
-	i915_dispatch_flip(dev, param->pipes, 0);
-
-	return 0;
+	return i915_dispatch_flip(dev);
 }
=20
 static int i915_getparam(struct drm_device *dev, void *data,
@@ -1393,9 +671,6 @@ static int i915_getparam(struct drm_devi
 	case I915_PARAM_LAST_DISPATCH:
 		value =3D READ_BREADCRUMB(dev_priv);
 		break;
-	case I915_PARAM_CHIPSET_ID:
-		value =3D dev->pci_device;
-		break;
 	default:
 		DRM_ERROR("Unknown parameter %d\n", param->param);
 		return -EINVAL;
@@ -1439,63 +714,6 @@ static int i915_setparam(struct drm_devi
 	return 0;
 }
=20
-drm_i915_mmio_entry_t mmio_table[] =3D {
-	[MMIO_REGS_PS_DEPTH_COUNT] =3D {
-		I915_MMIO_MAY_READ|I915_MMIO_MAY_WRITE,
-		0x2350,
-		8
-	}
-};
-
-static int mmio_table_size =3D sizeof(mmio_table)/sizeof(drm_i915_mmio=
_entry_t);
-
-static int i915_mmio(struct drm_device *dev, void *data,
-		     struct drm_file *file_priv)
-{
-	uint32_t buf[8];
-	drm_i915_private_t *dev_priv =3D dev->dev_private;
-	drm_i915_mmio_entry_t *e;
-	drm_i915_mmio_t *mmio =3D data;
-	void __iomem *base;
-	int i;
-
-	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
-		return -EINVAL;
-	}
-
-	if (mmio->reg >=3D mmio_table_size)
-		return -EINVAL;
-
-	e =3D &mmio_table[mmio->reg];
-	base =3D (u8 *) dev_priv->mmio_map->handle + e->offset;
-
-	switch (mmio->read_write) {
-	case I915_MMIO_READ:
-		if (!(e->flag & I915_MMIO_MAY_READ))
-			return -EINVAL;
-		for (i =3D 0; i < e->size / 4; i++)
-			buf[i] =3D I915_READ(e->offset + i * 4);
-		if (DRM_COPY_TO_USER(mmio->data, buf, e->size)) {
-			DRM_ERROR("DRM_COPY_TO_USER failed\n");
-			return -EFAULT;
-		}
-		break;
-
-	case I915_MMIO_WRITE:
-		if (!(e->flag & I915_MMIO_MAY_WRITE))
-			return -EINVAL;
-		if (DRM_COPY_FROM_USER(buf, mmio->data, e->size)) {
-			DRM_ERROR("DRM_COPY_TO_USER failed\n");
-			return -EFAULT;
-		}
-		for (i =3D 0; i < e->size / 4; i++)
-			I915_WRITE(e->offset + i * 4, buf[i]);
-		break;
-	}
-	return 0;
-}
-
 static int i915_set_status_page(struct drm_device *dev, void *data,
 				struct drm_file *file_priv)
 {
@@ -1582,39 +800,20 @@ int i915_driver_unload(struct drm_device
 	return 0;
 }
=20
-void i915_driver_lastclose(struct drm_device *dev)
+void i915_driver_lastclose(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
=20
-<<<<<<< HEAD:drivers/char/drm/i915_dma.c
 	if (!dev_priv)
 		return;
=20
-=3D=3D=3D=3D=3D=3D=3D
-	if (drm_getsarea(dev) && dev_priv->sarea_priv)
-		i915_do_cleanup_pageflip(dev);
->>>>>>> FETCH_HEAD:drivers/char/drm/i915_dma.c
 	if (dev_priv->agp_heap)
 		i915_mem_takedown(&(dev_priv->agp_heap));
=20
-	if (dev_priv->sarea_kmap.virtual) {
-		drm_bo_kunmap(&dev_priv->sarea_kmap);
-		dev_priv->sarea_kmap.virtual =3D NULL;
-		dev->lock.hw_lock =3D NULL;
-		dev->sigdata.lock =3D NULL;
-	}
-
-	if (dev_priv->sarea_bo) {
-		mutex_lock(&dev->struct_mutex);
-		drm_bo_usage_deref_locked(&dev_priv->sarea_bo);
-		mutex_unlock(&dev->struct_mutex);
-		dev_priv->sarea_bo =3D NULL;
-	}
-
 	i915_dma_cleanup(dev);
 }
=20
-void i915_driver_preclose(struct drm_device *dev, struct drm_file *fil=
e_priv)
+void i915_driver_preclose(struct drm_device * dev, struct drm_file *fi=
le_priv)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	i915_mem_release(dev, file_priv, dev_priv->agp_heap);
@@ -1637,9 +836,7 @@ struct drm_ioctl_desc i915_ioctls[] =3D {
 	DRM_IOCTL_DEF(DRM_I915_SET_VBLANK_PIPE,  i915_vblank_pipe_set, DRM_AU=
TH|DRM_MASTER|DRM_ROOT_ONLY ),
 	DRM_IOCTL_DEF(DRM_I915_GET_VBLANK_PIPE,  i915_vblank_pipe_get, DRM_AU=
TH ),
 	DRM_IOCTL_DEF(DRM_I915_VBLANK_SWAP, i915_vblank_swap, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I915_MMIO, i915_mmio, DRM_AUTH),
 	DRM_IOCTL_DEF(DRM_I915_HWS_ADDR, i915_set_status_page, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I915_EXECBUFFER, i915_execbuffer, DRM_AUTH),
 };
=20
 int i915_max_ioctl =3D DRM_ARRAY_SIZE(i915_ioctls);
@@ -1655,13 +852,7 @@ int i915_max_ioctl =3D DRM_ARRAY_SIZE(i915
  * \returns
  * A value of 1 is always retured to indictate every i9x5 is AGP.
  */
-int i915_driver_device_is_agp(struct drm_device *dev)
+int i915_driver_device_is_agp(struct drm_device * dev)
 {
 	return 1;
 }
-
-int i915_driver_firstopen(struct drm_device *dev)
-{
-	drm_bo_driver_init(dev);
-	return 0;
-}
diff -puN drivers/char/drm/i915_drm.h~revert-git-drm drivers/char/drm/i=
915_drm.h
--- a/drivers/char/drm/i915_drm.h~revert-git-drm
+++ a/drivers/char/drm/i915_drm.h
@@ -43,12 +43,7 @@ typedef struct _drm_i915_init {
 	enum {
 		I915_INIT_DMA =3D 0x01,
 		I915_CLEANUP_DMA =3D 0x02,
-		I915_RESUME_DMA =3D 0x03,
-
-		/* Since this struct isn't versioned, just used a new
-		 * 'func' code to indicate the presence of dri2 sarea
-		 * info. */
-		I915_INIT_DMA2 =3D 0x04
+		I915_RESUME_DMA =3D 0x03
 	} func;
 	unsigned int mmio_offset;
 	int sarea_priv_offset;
@@ -66,10 +61,9 @@ typedef struct _drm_i915_init {
 	unsigned int depth_pitch;
 	unsigned int cpp;
 	unsigned int chipset;
-	unsigned int sarea_handle;
 } drm_i915_init_t;
=20
-typedef struct drm_i915_sarea {
+typedef struct _drm_i915_sarea {
 	struct drm_tex_region texList[I915_NR_TEX_REGIONS + 1];
 	int last_upload;	/* last time texture was uploaded */
 	int last_enqueue;	/* last time a buffer was enqueued */
@@ -111,41 +105,16 @@ typedef struct drm_i915_sarea {
 	unsigned int rotated_tiled;
 	unsigned int rotated2_tiled;
=20
-	int planeA_x;
-	int planeA_y;
-	int planeA_w;
-	int planeA_h;
-	int planeB_x;
-	int planeB_y;
-	int planeB_w;
-	int planeB_h;
-
-	/* Triple buffering */
-	drm_handle_t third_handle;
-	int third_offset;
-	int third_size;
-	unsigned int third_tiled;
-
-	/* buffer object handles for the static buffers.  May change
-	 * over the lifetime of the client, though it doesn't in our current
-	 * implementation.
-	 */
-	unsigned int front_bo_handle;
-	unsigned int back_bo_handle;
-	unsigned int third_bo_handle;
-	unsigned int depth_bo_handle;
+	int pipeA_x;
+	int pipeA_y;
+	int pipeA_w;
+	int pipeA_h;
+	int pipeB_x;
+	int pipeB_y;
+	int pipeB_w;
+	int pipeB_h;
 } drm_i915_sarea_t;
=20
-/* Driver specific fence types and classes.
- */
-
-/* The only fence class we support */
-#define DRM_I915_FENCE_CLASS_ACCEL 0
-/* Fence type that guarantees read-write flush */
-#define DRM_I915_FENCE_TYPE_RW 2
-/* MI_FLUSH programmed just before the fence */
-#define DRM_I915_FENCE_FLAG_FLUSHED 0x01000000
-
 /* Flags for perf_boxes
  */
 #define I915_BOX_RING_EMPTY    0x1
@@ -173,13 +142,11 @@ typedef struct drm_i915_sarea {
 #define DRM_I915_SET_VBLANK_PIPE	0x0d
 #define DRM_I915_GET_VBLANK_PIPE	0x0e
 #define DRM_I915_VBLANK_SWAP	0x0f
-#define DRM_I915_MMIO		0x10
 #define DRM_I915_HWS_ADDR	0x11
-#define DRM_I915_EXECBUFFER	0x12
=20
 #define DRM_IOCTL_I915_INIT		DRM_IOW( DRM_COMMAND_BASE + DRM_I915_INIT=
, drm_i915_init_t)
 #define DRM_IOCTL_I915_FLUSH		DRM_IO ( DRM_COMMAND_BASE + DRM_I915_FLU=
SH)
-#define DRM_IOCTL_I915_FLIP		DRM_IOW( DRM_COMMAND_BASE + DRM_I915_FLIP=
, drm_i915_flip_t)
+#define DRM_IOCTL_I915_FLIP		DRM_IO ( DRM_COMMAND_BASE + DRM_I915_FLIP=
)
 #define DRM_IOCTL_I915_BATCHBUFFER	DRM_IOW( DRM_COMMAND_BASE + DRM_I91=
5_BATCHBUFFER, drm_i915_batchbuffer_t)
 #define DRM_IOCTL_I915_IRQ_EMIT         DRM_IOWR(DRM_COMMAND_BASE + DR=
M_I915_IRQ_EMIT, drm_i915_irq_emit_t)
 #define DRM_IOCTL_I915_IRQ_WAIT         DRM_IOW( DRM_COMMAND_BASE + DR=
M_I915_IRQ_WAIT, drm_i915_irq_wait_t)
@@ -193,25 +160,11 @@ typedef struct drm_i915_sarea {
 #define DRM_IOCTL_I915_SET_VBLANK_PIPE	DRM_IOW( DRM_COMMAND_BASE + DRM=
_I915_SET_VBLANK_PIPE, drm_i915_vblank_pipe_t)
 #define DRM_IOCTL_I915_GET_VBLANK_PIPE	DRM_IOR( DRM_COMMAND_BASE + DRM=
_I915_GET_VBLANK_PIPE, drm_i915_vblank_pipe_t)
 #define DRM_IOCTL_I915_VBLANK_SWAP	DRM_IOWR(DRM_COMMAND_BASE + DRM_I91=
5_VBLANK_SWAP, drm_i915_vblank_swap_t)
-#define DRM_IOCTL_I915_MMIO             DRM_IOWR(DRM_COMMAND_BASE + DR=
M_I915_MMIO, drm_i915_vblank_swap_t)
-#define DRM_IOCTL_I915_EXECBUFFER	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915=
_EXECBUFFER, struct drm_i915_execbuffer)
-
-/* Asynchronous page flipping:
- */
-typedef struct drm_i915_flip {
-	/*
-	 * This is really talking about planes, and we could rename it
-	 * except for the fact that some of the duplicated i915_drm.h files
-	 * out there check for HAVE_I915_FLIP and so might pick up this
-	 * version.
-	 */
-	int pipes;
-} drm_i915_flip_t;
=20
 /* Allow drivers to submit batchbuffers directly to hardware, relying
  * on the security mechanisms provided by hardware.
  */
-typedef struct drm_i915_batchbuffer {
+typedef struct _drm_i915_batchbuffer {
 	int start;		/* agp offset */
 	int used;		/* nr bytes in use */
 	int DR1;		/* hw flags for GFX_OP_DRAWRECT_INFO */
@@ -247,7 +200,6 @@ typedef struct drm_i915_irq_wait {
 #define I915_PARAM_IRQ_ACTIVE            1
 #define I915_PARAM_ALLOW_BATCHBUFFER     2
 #define I915_PARAM_LAST_DISPATCH         3
-#define I915_PARAM_CHIPSET_ID            4
=20
 typedef struct drm_i915_getparam {
 	int param;
@@ -311,73 +263,8 @@ typedef struct drm_i915_vblank_swap {
 	unsigned int sequence;
 } drm_i915_vblank_swap_t;
=20
-#define I915_MMIO_READ	0
-#define I915_MMIO_WRITE 1
-
-#define I915_MMIO_MAY_READ	0x1
-#define I915_MMIO_MAY_WRITE	0x2
-
-#define MMIO_REGS_IA_PRIMATIVES_COUNT		0
-#define MMIO_REGS_IA_VERTICES_COUNT		1
-#define MMIO_REGS_VS_INVOCATION_COUNT		2
-#define MMIO_REGS_GS_PRIMITIVES_COUNT		3
-#define MMIO_REGS_GS_INVOCATION_COUNT		4
-#define MMIO_REGS_CL_PRIMITIVES_COUNT		5
-#define MMIO_REGS_CL_INVOCATION_COUNT		6
-#define MMIO_REGS_PS_INVOCATION_COUNT		7
-#define MMIO_REGS_PS_DEPTH_COUNT		8
-
-typedef struct drm_i915_mmio_entry {
-	unsigned int flag;
-	unsigned int offset;
-	unsigned int size;
-} drm_i915_mmio_entry_t;
-
-typedef struct drm_i915_mmio {
-	unsigned int read_write:1;
-	unsigned int reg:31;
-	void __user *data;
-} drm_i915_mmio_t;
-
 typedef struct drm_i915_hws_addr {
 	uint64_t addr;
 } drm_i915_hws_addr_t;
=20
-/*
- * Relocation header is 4 uint32_ts
- * 0 - 32 bit reloc count
- * 1 - 32-bit relocation type
- * 2-3 - 64-bit user buffer handle ptr for another list of relocs.
- */
-#define I915_RELOC_HEADER 4
-
-/*
- * type 0 relocation has 4-uint32_t stride
- * 0 - offset into buffer
- * 1 - delta to add in
- * 2 - buffer handle
- * 3 - reserved (for optimisations later).
- */
-#define I915_RELOC_TYPE_0 0
-#define I915_RELOC0_STRIDE 4
-
-struct drm_i915_op_arg {
-	uint64_t next;
-	uint64_t reloc_ptr;
-	int handled;
-	union {
-		struct drm_bo_op_req req;
-		struct drm_bo_arg_rep rep;
-	} d;
-
-};
-
-struct drm_i915_execbuffer {
-	uint64_t ops_list;
-	uint32_t num_buffers;
-	struct drm_i915_batchbuffer batch;
-	drm_context_t context; /* for lockless use in the future */
-	struct drm_fence_arg fence_arg;
-};
-
 #endif				/* _I915_DRM_H_ */
diff -puN drivers/char/drm/i915_drv.c~revert-git-drm drivers/char/drm/i=
915_drv.c
--- a/drivers/char/drm/i915_drv.c~revert-git-drm
+++ a/drivers/char/drm/i915_drv.c
@@ -37,25 +37,6 @@
 static struct pci_device_id pciidlist[] =3D {
 	i915_PCI_IDS
 };
-extern struct drm_fence_driver i915_fence_driver;
-
-static uint32_t i915_mem_prios[] =3D {DRM_BO_MEM_PRIV0, DRM_BO_MEM_TT,=
 DRM_BO_MEM_LOCAL};
-static uint32_t i915_busy_prios[] =3D {DRM_BO_MEM_TT, DRM_BO_MEM_PRIV0=
, DRM_BO_MEM_LOCAL};
-
-static struct drm_bo_driver i915_bo_driver =3D {
-	.mem_type_prio =3D i915_mem_prios,
-	.mem_busy_prio =3D i915_busy_prios,
-	.num_mem_type_prio =3D sizeof(i915_mem_prios)/sizeof(uint32_t),
-	.num_mem_busy_prio =3D sizeof(i915_busy_prios)/sizeof(uint32_t),
-	.create_ttm_backend_entry =3D i915_create_ttm_backend_entry,
-	.fence_type =3D i915_fence_type,
-	.invalidate_caches =3D i915_invalidate_caches,
-	.init_mem_type =3D i915_init_mem_type,
-	.evict_flags =3D i915_evict_flags,
-	.move =3D i915_move,
-	.ttm_cache_flush =3D i915_flush_ttm,
-	.command_stream_barrier =3D NULL,
-};
=20
 enum pipe {
     PIPE_A =3D 0,
@@ -556,7 +537,6 @@ static struct drm_driver driver =3D {
 	    DRIVER_IRQ_VBL2,
 	.load =3D i915_driver_load,
 	.unload =3D i915_driver_unload,
-	.firstopen =3D i915_driver_firstopen,
 	.lastclose =3D i915_driver_lastclose,
 	.preclose =3D i915_driver_preclose,
 	.suspend =3D i915_suspend,
@@ -589,8 +569,7 @@ static struct drm_driver driver =3D {
 		 .name =3D DRIVER_NAME,
 		 .id_table =3D pciidlist,
 	},
-	.fence_driver =3D &i915_fence_driver,
-	.bo_driver =3D &i915_bo_driver,
+
 	.name =3D DRIVER_NAME,
 	.desc =3D DRIVER_DESC,
 	.date =3D DRIVER_DATE,
diff -puN drivers/char/drm/i915_drv.h~revert-git-drm drivers/char/drm/i=
915_drv.h
--- a/drivers/char/drm/i915_drv.h~revert-git-drm
+++ a/drivers/char/drm/i915_drv.h
@@ -37,7 +37,7 @@
=20
 #define DRIVER_NAME		"i915"
 #define DRIVER_DESC		"Intel Graphics"
-#define DRIVER_DATE		"20071122"
+#define DRIVER_DATE		"20060119"
=20
 /* Interface history:
  *
@@ -48,18 +48,11 @@
  * 1.5: Add vblank pipe configuration
  * 1.6: - New ioctl for scheduling buffer swaps on vertical blank
  *      - Support vertical blank on secondary display pipe
- * 1.8: New ioctl for ARB_Occlusion_Query
- * 1.9: Usable page flipping and triple buffering
- * 1.10: Plane/pipe disentangling
- * 1.11: TTM superioctl
- * 1.12: TTM relocation optimization
  */
 #define DRIVER_MAJOR		1
-#define DRIVER_MINOR		12
+#define DRIVER_MINOR		6
 #define DRIVER_PATCHLEVEL	0
=20
-#define I915_MAX_VALIDATE_BUFFERS 4096
-
 typedef struct _drm_i915_ring_buffer {
 	int tail_mask;
 	unsigned long Start;
@@ -83,9 +76,8 @@ struct mem_block {
 typedef struct _drm_i915_vbl_swap {
 	struct list_head head;
 	drm_drawable_t drw_id;
-	unsigned int plane;
+	unsigned int pipe;
 	unsigned int sequence;
-	int flip;
 } drm_i915_vbl_swap_t;
=20
 typedef struct drm_i915_private {
@@ -98,11 +90,15 @@ typedef struct drm_i915_private {
 	drm_dma_handle_t *status_page_dmah;
 	void *hw_status_page;
 	dma_addr_t dma_status_page;
-	uint32_t counter;
+	unsigned long counter;
 	unsigned int status_gfx_addr;
 	drm_local_map_t hws_map;
=20
 	unsigned int cpp;
+	int back_offset;
+	int front_offset;
+	int current_page;
+	int page_flipping;
 	int use_mi_batchbuffer_start;
=20
 	wait_queue_head_t irq_queue;
@@ -114,28 +110,11 @@ typedef struct drm_i915_private {
 	struct mem_block *agp_heap;
 	unsigned int sr01, adpa, ppcr, dvob, dvoc, lvds;
 	int vblank_pipe;
-	spinlock_t user_irq_lock;
-	int user_irq_refcount;
-	int fence_irq_on;
-	uint32_t irq_enable_reg;
-	int irq_enabled;
-
-	uint32_t flush_sequence;
-	uint32_t flush_flags;
-	uint32_t flush_pending;
-	uint32_t saved_flush_status;
-	void *agp_iomap;
-	unsigned int max_validate_buffers;
-	struct mutex cmdbuf_mutex;
=20
 	spinlock_t swaps_lock;
 	drm_i915_vbl_swap_t vbl_swaps;
 	unsigned int swaps_pending;
=20
-	/* DRI2 sarea */
-	struct drm_buffer_object *sarea_bo;
-	struct drm_bo_kmap_obj sarea_kmap;
-
 	/* Register state */
 	u8 saveLBB;
 	u32 saveDSPACNTR;
@@ -237,10 +216,6 @@ extern void i915_driver_preclose(struct=20
 extern int i915_driver_device_is_agp(struct drm_device * dev);
 extern long i915_compat_ioctl(struct file *filp, unsigned int cmd,
 			      unsigned long arg);
-extern void i915_emit_breadcrumb(struct drm_device *dev);
-extern void i915_dispatch_flip(struct drm_device * dev, int pipes, int=
 sync);
-extern int i915_emit_mi_flush(struct drm_device *dev, uint32_t flush);
-extern int i915_driver_firstopen(struct drm_device *dev);
=20
 /* i915_irq.c */
 extern int i915_irq_emit(struct drm_device *dev, void *data,
@@ -258,9 +233,6 @@ extern int i915_vblank_pipe_set(struct d
 				struct drm_file *file_priv);
 extern int i915_vblank_pipe_get(struct drm_device *dev, void *data,
 				struct drm_file *file_priv);
-extern int i915_emit_irq(struct drm_device *dev);
-extern void i915_user_irq_on(drm_i915_private_t *dev_priv);
-extern void i915_user_irq_off(drm_i915_private_t *dev_priv);
 extern int i915_vblank_swap(struct drm_device *dev, void *data,
 			    struct drm_file *file_priv);
=20
@@ -275,26 +247,7 @@ extern int i915_mem_destroy_heap(struct=20
 				 struct drm_file *file_priv);
 extern void i915_mem_takedown(struct mem_block **heap);
 extern void i915_mem_release(struct drm_device * dev,
-			     struct drm_file *file_priv,
-			     struct mem_block *heap);
-/* i915_fence.c */
-extern void i915_fence_handler(struct drm_device *dev);
-extern void i915_invalidate_reported_sequence(struct drm_device *dev);
-
-/* i915_buffer.c */
-extern struct drm_ttm_backend *i915_create_ttm_backend_entry(struct dr=
m_device *dev);
-extern int i915_fence_type(struct drm_buffer_object *bo, uint32_t *fcl=
ass,
-			   uint32_t *type);
-extern int i915_invalidate_caches(struct drm_device *dev, uint64_t buf=
fer_flags);
-extern int i915_init_mem_type(struct drm_device *dev, uint32_t type,
-			       struct drm_mem_type_manager *man);
-extern uint64_t i915_evict_flags(struct drm_buffer_object *bo);
-extern int i915_move(struct drm_buffer_object *bo, int evict,
-		int no_wait, struct drm_bo_mem_reg *new_mem);
-void i915_flush_ttm(struct drm_ttm *ttm);
-
-extern void intel_init_chipset_flush_compat(struct drm_device *dev);
-extern void intel_fini_chipset_flush_compat(struct drm_device *dev);
+			     struct drm_file *file_priv, struct mem_block *heap);
=20
 #define I915_READ(reg)          DRM_READ32(dev_priv->mmio_map, (reg))
 #define I915_WRITE(reg,val)     DRM_WRITE32(dev_priv->mmio_map, (reg),=
 (val))
@@ -384,16 +337,9 @@ extern int i915_wait_ring(struct drm_dev
 #define CMD_STORE_DWORD_IDX		((0x21<<23) | 0x1)
 #define CMD_OP_BATCH_BUFFER  ((0x0<<29)|(0x30<<23)|0x1)
=20
-#define CMD_MI_FLUSH         (0x04 << 23)
-#define MI_NO_WRITE_FLUSH    (1 << 2)
-#define MI_READ_FLUSH        (1 << 0)
-#define MI_EXE_FLUSH         (1 << 1)
-#define MI_END_SCENE         (1 << 4) /* flush binner and incr scene c=
ount */
-#define MI_SCENE_COUNT       (1 << 3) /* just increment scene count */
-
-/* Packet to load a register value from the ring/batch command stream:
- */
-#define CMD_MI_LOAD_REGISTER_IMM	((0x22 << 23)|0x1)
+#define INST_PARSER_CLIENT   0x00000000
+#define INST_OP_FLUSH        0x02000000
+#define INST_FLUSH_MAP_CACHE 0x00000001
=20
 #define BB1_START_ADDR_MASK   (~0x7)
 #define BB1_PROTECTED         (1<<0)
@@ -442,7 +388,6 @@ extern int i915_wait_ring(struct drm_dev
 #define I915REG_INT_IDENTITY_R	0x020a4
 #define I915REG_INT_MASK_R	0x020a8
 #define I915REG_INT_ENABLE_R	0x020a0
-#define I915REG_INSTPM	        0x020c0
=20
 #define I915REG_PIPEASTAT	0x70024
 #define I915REG_PIPEBSTAT	0x71024
@@ -615,7 +560,7 @@ extern int i915_wait_ring(struct drm_dev
 #define GFX_OP_DESTBUFFER_VARS   ((0x3<<29)|(0x1d<<24)|(0x85<<16)|0x0)
 #define GFX_OP_DRAWRECT_INFO     ((0x3<<29)|(0x1d<<24)|(0x80<<16)|(0x3=
))
=20
-#define GFX_OP_DRAWRECT_INFO_I965  ((0x7900<<16)|0x2)
+#define GFX_OP_DRAWRECT_INFO_I965 ((0x7900<<16)|0x2)
=20
 #define SRC_COPY_BLT_CMD                ((2<<29)|(0x43<<22)|4)
 #define XY_SRC_COPY_BLT_CMD		((2<<29)|(0x53<<22)|6)
@@ -651,6 +596,13 @@ extern int i915_wait_ring(struct drm_dev
=20
 #define CMD_OP_DESTBUFFER_INFO	 ((0x3<<29)|(0x1d<<24)|(0x8e<<16)|1)
=20
+#define CMD_MI_FLUSH         (0x04 << 23)
+#define MI_NO_WRITE_FLUSH    (1 << 2)
+#define MI_READ_FLUSH        (1 << 0)
+#define MI_EXE_FLUSH         (1 << 1)
+#define MI_END_SCENE         (1 << 4) /* flush binner and incr scene c=
ount */
+#define MI_SCENE_COUNT       (1 << 3) /* just increment scene count */
+
 #define BREADCRUMB_BITS 31
 #define BREADCRUMB_MASK ((1U << BREADCRUMB_BITS) - 1)
=20
diff -puN drivers/char/drm/i915_fence.c~revert-git-drm /dev/null
--- a/drivers/char/drm/i915_fence.c
+++ /dev/null
@@ -1,269 +0,0 @@
-/*********************************************************************=
*****
- *
- * Copyright 2006 Tungsten Graphics, Inc., Bismarck, ND., USA
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaini=
ng a
- * copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject =
to
- * the following conditions:
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT =
SHALL
- * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR A=
NY CLAIM,
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT =
OR
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE =
OR THE
- * USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- * The above copyright notice and this permission notice (including th=
e
- * next paragraph) shall be included in all copies or substantial port=
ions
- * of the Software.
- *
- *
- *********************************************************************=
*****/
-/*
- * Authors: Thomas Hellstr=F6m <thomas-at-tungstengraphics-dot-com>
- */
-
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
-#include "i915_drv.h"
-
-/*
- * Initiate a sync flush if it's not already pending.
- */
-
-static inline void i915_initiate_rwflush(struct drm_i915_private *dev_=
priv,
-					 struct drm_fence_class_manager *fc)
-{
-	if ((fc->pending_flush & DRM_I915_FENCE_TYPE_RW) &&
-	    !dev_priv->flush_pending) {
-		dev_priv->flush_sequence =3D (uint32_t) READ_BREADCRUMB(dev_priv);
-		dev_priv->flush_flags =3D fc->pending_flush;
-		dev_priv->saved_flush_status =3D READ_HWSP(dev_priv, 0);
-		I915_WRITE(I915REG_INSTPM, (1 << 5) | (1 << 21));
-		dev_priv->flush_pending =3D 1;
-		fc->pending_flush &=3D ~DRM_I915_FENCE_TYPE_RW;
-	}
-}
-
-static inline void i915_report_rwflush(struct drm_device *dev,
-				       struct drm_i915_private *dev_priv)
-{
-	if (unlikely(dev_priv->flush_pending)) {
-
-		uint32_t flush_flags;
-		uint32_t i_status;
-		uint32_t flush_sequence;
-
-		i_status =3D READ_HWSP(dev_priv, 0);
-		if ((i_status & (1 << 12)) !=3D
-		    (dev_priv->saved_flush_status & (1 << 12))) {
-			flush_flags =3D dev_priv->flush_flags;
-			flush_sequence =3D dev_priv->flush_sequence;
-			dev_priv->flush_pending =3D 0;
-			drm_fence_handler(dev, 0, flush_sequence,
-					  flush_flags, 0);
-		}
-	}
-}
-
-static void i915_fence_flush(struct drm_device *dev,
-			     uint32_t fence_class)
-{
-	struct drm_i915_private *dev_priv =3D
-		(struct drm_i915_private *) dev->dev_private;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[0];
-	unsigned long irq_flags;
-
-	if (unlikely(!dev_priv))
-		return;
-
-	write_lock_irqsave(&fm->lock, irq_flags);
-	i915_initiate_rwflush(dev_priv, fc);
-	write_unlock_irqrestore(&fm->lock, irq_flags);
-}
-
-
-static void i915_fence_poll(struct drm_device *dev, uint32_t fence_cla=
ss,
-			    uint32_t waiting_types)
-{
-	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[0];
-	uint32_t sequence;
-
-	if (unlikely(!dev_priv))
-		return;
-
-	/*
-	 * First, report any executed sync flush:
-	 */
-
-	i915_report_rwflush(dev, dev_priv);
-
-	/*
-	 * Report A new breadcrumb, and adjust IRQs.
-	 */
-
-	if (waiting_types & DRM_FENCE_TYPE_EXE) {
-
-		sequence =3D READ_BREADCRUMB(dev_priv);
-		drm_fence_handler(dev, 0, sequence,
-				  DRM_FENCE_TYPE_EXE, 0);
-
-		if (dev_priv->fence_irq_on &&
-		    !(fc->waiting_types & DRM_FENCE_TYPE_EXE)) {
-			i915_user_irq_off(dev_priv);
-			dev_priv->fence_irq_on =3D 0;
-		} else if (!dev_priv->fence_irq_on &&
-			   (fc->waiting_types & DRM_FENCE_TYPE_EXE)) {
-			i915_user_irq_on(dev_priv);
-			dev_priv->fence_irq_on =3D 1;
-		}
-	}
-
-	/*
-	 * There may be new RW flushes pending. Start them.
-	 */
-	i915_initiate_rwflush(dev_priv, fc);
-
-	/*
-	 * And possibly, but unlikely, they finish immediately.
-	 */
-
-	i915_report_rwflush(dev, dev_priv);
-
-}
-
-static int i915_fence_emit_sequence(struct drm_device *dev, uint32_t c=
lass,
-			     uint32_t flags, uint32_t *sequence,
-			     uint32_t *native_type)
-{
-	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
-	if (unlikely(!dev_priv))
-		return -EINVAL;
-
-	i915_emit_irq(dev);
-	*sequence =3D (uint32_t) dev_priv->counter;
-	*native_type =3D DRM_FENCE_TYPE_EXE;
-	if (flags & DRM_I915_FENCE_FLAG_FLUSHED)
-		*native_type |=3D DRM_I915_FENCE_TYPE_RW;
-
-	return 0;
-}
-
-void i915_fence_handler(struct drm_device *dev)
-{
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[0];
-
-	write_lock(&fm->lock);
-	i915_fence_poll(dev, 0, fc->waiting_types);
-	write_unlock(&fm->lock);
-}
-
-/*
- * We need a separate wait function since we need to poll for
- * sync flushes.
- */
-
-static int i915_fence_wait(struct drm_fence_object *fence,
-			   int lazy, int interruptible, uint32_t mask)
-{
-	struct drm_device *dev =3D fence->dev;
-	drm_i915_private_t *dev_priv =3D (struct drm_i915_private *) dev->dev=
_private;
-	struct drm_fence_manager *fm =3D &dev->fm;
-	struct drm_fence_class_manager *fc =3D &fm->fence_class[0];
-	int ret;
-	unsigned long  _end =3D jiffies + 3 * DRM_HZ;
-
-	drm_fence_object_flush(fence, mask);
-	if (likely(interruptible))
-		ret =3D wait_event_interruptible_timeout
-			(fc->fence_queue, drm_fence_object_signaled(fence, DRM_FENCE_TYPE_E=
XE),
-			 3 * DRM_HZ);
-	else
-		ret =3D wait_event_timeout
-			(fc->fence_queue, drm_fence_object_signaled(fence, DRM_FENCE_TYPE_E=
XE),
-			 3 * DRM_HZ);
-
-	if (unlikely(ret =3D=3D -ERESTARTSYS))
-		return -EAGAIN;
-
-	if (unlikely(ret =3D=3D 0))
-		return -EBUSY;
-
-	if (likely(mask =3D=3D DRM_FENCE_TYPE_EXE ||
-		   drm_fence_object_signaled(fence, mask)))
-		return 0;
-
-	/*
-	 * Remove this code snippet when fixed. HWSTAM doesn't let
-	 * flush info through...
-	 */
-
-	if (unlikely(dev_priv && !dev_priv->irq_enabled)) {
-		unsigned long irq_flags;
-
-		DRM_ERROR("X server disabled IRQs before releasing frame buffer.\n")=
;
-		msleep(100);
-		dev_priv->flush_pending =3D 0;
-		write_lock_irqsave(&fm->lock, irq_flags);
-		drm_fence_handler(dev, fence->fence_class,
-				  fence->sequence, fence->type, 0);
-		write_unlock_irqrestore(&fm->lock, irq_flags);
-	}
-
-	/*
-	 * Poll for sync flush completion.
-	 */
-
-	return drm_fence_wait_polling(fence, lazy, interruptible, mask, _end)=
;
-}
-
-static uint32_t i915_fence_needed_flush(struct drm_fence_object *fence=
)
-{
-	uint32_t flush_flags =3D fence->waiting_types &
-		~(DRM_FENCE_TYPE_EXE | fence->signaled_types);
-
-	if (likely(flush_flags =3D=3D 0 ||
-		   ((flush_flags & ~fence->native_types) =3D=3D 0) ||
-		   (fence->signaled_types !=3D DRM_FENCE_TYPE_EXE)))
-		return 0;
-	else {
-		struct drm_device *dev =3D fence->dev;
-		struct drm_i915_private *dev_priv =3D (struct drm_i915_private *) de=
v->dev_private;
-		struct drm_fence_driver *driver =3D dev->driver->fence_driver;
-
-		if (unlikely(!dev_priv))
-			return 0;
-
-		if (dev_priv->flush_pending) {
-			uint32_t diff =3D (dev_priv->flush_sequence - fence->sequence) & dr=
iver->sequence_mask;
-
-			if (diff < driver->wrap_diff)
-				return 0;
-		}
-	}
-	return flush_flags;
-}
-
-struct drm_fence_driver i915_fence_driver =3D {
-	.num_classes =3D 1,
-	.wrap_diff =3D (1U << (BREADCRUMB_BITS - 1)),
-	.flush_diff =3D (1U << (BREADCRUMB_BITS - 2)),
-	.sequence_mask =3D BREADCRUMB_MASK,
-	.has_irq =3D NULL,
-	.emit =3D i915_fence_emit_sequence,
-	.flush =3D i915_fence_flush,
-	.poll =3D i915_fence_poll,
-	.needed_flush =3D i915_fence_needed_flush,
-	.wait =3D i915_fence_wait,
-};
diff -puN drivers/char/drm/i915_ioc32.c~revert-git-drm drivers/char/drm=
/i915_ioc32.c
--- a/drivers/char/drm/i915_ioc32.c~revert-git-drm
+++ a/drivers/char/drm/i915_ioc32.c
@@ -182,70 +182,12 @@ static int compat_i915_alloc(struct file
 			 DRM_IOCTL_I915_ALLOC, (unsigned long)request);
 }
=20
-typedef struct drm_i915_execbuffer32 {
-	uint64_t ops_list;
-	uint32_t num_buffers;
-	struct _drm_i915_batchbuffer32 batch;
-	drm_context_t context;=20
-	struct drm_fence_arg fence_arg;
-} drm_i915_execbuffer32_t;
-
-static int compat_i915_execbuffer(struct file *file, unsigned int cmd,
-			     unsigned long arg)
-{
-	drm_i915_execbuffer32_t req32;
-	struct drm_i915_execbuffer __user *request;
-	int err;
-
-	if (copy_from_user(&req32, (void __user *) arg, sizeof(req32)))
-		return -EFAULT;
-
-	request =3D compat_alloc_user_space(sizeof(*request));
-
-	if (!access_ok(VERIFY_WRITE, request, sizeof(*request))
-       || __put_user(req32.ops_list, &request->ops_list)
-       || __put_user(req32.num_buffers, &request->num_buffers)
-       || __put_user(req32.context, &request->context)
-       || __copy_to_user(&request->fence_arg, &req32.fence_arg,=20
-                         sizeof(req32.fence_arg))
-       || __put_user(req32.batch.start, &request->batch.start)
-       || __put_user(req32.batch.used, &request->batch.used)
-       || __put_user(req32.batch.DR1, &request->batch.DR1)
-       || __put_user(req32.batch.DR4, &request->batch.DR4)
-       || __put_user(req32.batch.num_cliprects,
-                     &request->batch.num_cliprects)
-       || __put_user((int __user *)(unsigned long)req32.batch.cliprect=
s,
-                     &request->batch.cliprects))
-		return -EFAULT;
-
-	err =3D drm_ioctl(file->f_dentry->d_inode, file,
-			 DRM_IOCTL_I915_EXECBUFFER, (unsigned long)request);
-
-	if (err)
-		return err;
-
-	if (__get_user(req32.fence_arg.handle, &request->fence_arg.handle)
-	    || __get_user(req32.fence_arg.fence_class, &request->fence_arg.fe=
nce_class)
-	    || __get_user(req32.fence_arg.type, &request->fence_arg.type)
-	    || __get_user(req32.fence_arg.flags, &request->fence_arg.flags)
-	    || __get_user(req32.fence_arg.signaled, &request->fence_arg.signa=
led)
-	    || __get_user(req32.fence_arg.error, &request->fence_arg.error)
-	    || __get_user(req32.fence_arg.sequence, &request->fence_arg.seque=
nce))
-		return -EFAULT;
-
-	if (copy_to_user((void __user *)arg, &req32, sizeof(req32)))
-		return -EFAULT;
-
-	return 0;
-}
-
 drm_ioctl_compat_t *i915_compat_ioctls[] =3D {
 	[DRM_I915_BATCHBUFFER] =3D compat_i915_batchbuffer,
 	[DRM_I915_CMDBUFFER] =3D compat_i915_cmdbuffer,
 	[DRM_I915_GETPARAM] =3D compat_i915_getparam,
 	[DRM_I915_IRQ_EMIT] =3D compat_i915_irq_emit,
-	[DRM_I915_ALLOC] =3D compat_i915_alloc,
-	[DRM_I915_EXECBUFFER] =3D compat_i915_execbuffer,
+	[DRM_I915_ALLOC] =3D compat_i915_alloc
 };
=20
 /**
diff -puN drivers/char/drm/i915_irq.c~revert-git-drm drivers/char/drm/i=
915_irq.c
--- a/drivers/char/drm/i915_irq.c~revert-git-drm
+++ a/drivers/char/drm/i915_irq.c
@@ -38,71 +38,6 @@
 #define MAX_NOPID ((u32)~0)
=20
 /**
- * i915_get_pipe - return the the pipe associated with a given plane
- * @dev: DRM device
- * @plane: plane to look for
- *
- * We need to get the pipe associated with a given plane to correctly =
perform
- * vblank driven swapping, and they may not always be equal.  So look =
up the
- * pipe associated with @plane here.
- */
-static int
-i915_get_pipe(struct drm_device *dev, int plane)
-{
-	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
-	u32 dspcntr;
-
-	dspcntr =3D plane ? I915_READ(DSPBCNTR) : I915_READ(DSPACNTR);
-
-	return dspcntr & DISPPLANE_SEL_PIPE_MASK ? 1 : 0;
-}
-
-/**
- * Emit a synchronous flip.
- *
- * This function must be called with the drawable spinlock held.
- */
-static void
-i915_dispatch_vsync_flip(struct drm_device *dev, struct drm_drawable_i=
nfo *drw,
-			 int plane)
-{
-	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
-	drm_i915_sarea_t *sarea_priv =3D dev_priv->sarea_priv;
-	u16 x1, y1, x2, y2;
-	int pf_planes =3D 1 << plane;
-
-	/* If the window is visible on the other plane, we have to flip on th=
at
-	 * plane as well.
-	 */
-	if (plane =3D=3D 1) {
-		x1 =3D sarea_priv->planeA_x;
-		y1 =3D sarea_priv->planeA_y;
-		x2 =3D x1 + sarea_priv->planeA_w;
-		y2 =3D y1 + sarea_priv->planeA_h;
-	} else {
-		x1 =3D sarea_priv->planeB_x;
-		y1 =3D sarea_priv->planeB_y;
-		x2 =3D x1 + sarea_priv->planeB_w;
-		y2 =3D y1 + sarea_priv->planeB_h;
-	}
-
-	if (x2 > 0 && y2 > 0) {
-		int i, num_rects =3D drw->num_rects;
-		struct drm_clip_rect *rect =3D drw->rects;
-
-		for (i =3D 0; i < num_rects; i++)
-			if (!(rect[i].x1 >=3D x2 || rect[i].y1 >=3D y2 ||
-			      rect[i].x2 <=3D x1 || rect[i].y2 <=3D y1)) {
-				pf_planes =3D 0x3;
-
-				break;
-			}
-	}
-
-	i915_dispatch_flip(dev, pf_planes, 1);
-}
-
-/**
  * Emit blits for scheduled buffer swaps.
  *
  * This function will be called with the HW lock held.
@@ -110,13 +45,14 @@ i915_dispatch_vsync_flip(struct drm_devi
 static void i915_vblank_tasklet(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
+	unsigned long irqflags;
 	struct list_head *list, *tmp, hits, *hit;
-	int nhits, nrects, slice[2], upper[2], lower[2], i, num_pages;
+	int nhits, nrects, slice[2], upper[2], lower[2], i;
 	unsigned counter[2] =3D { atomic_read(&dev->vbl_received),
 				atomic_read(&dev->vbl_received2) };
 	struct drm_drawable_info *drw;
 	drm_i915_sarea_t *sarea_priv =3D dev_priv->sarea_priv;
-	u32 cpp =3D dev_priv->cpp,  offsets[3];
+	u32 cpp =3D dev_priv->cpp;
 	u32 cmd =3D (cpp =3D=3D 4) ? (XY_SRC_COPY_BLT_CMD |
 				XY_SRC_COPY_BLT_WRITE_ALPHA |
 				XY_SRC_COPY_BLT_WRITE_RGB)
@@ -131,20 +67,14 @@ static void i915_vblank_tasklet(struct d
=20
 	nhits =3D nrects =3D 0;
=20
-	/* No irqsave/restore necessary.  This tasklet may be run in an
-	 * interrupt context or normal context, but we don't have to worry
-	 * about getting interrupted by something acquiring the lock, because
-	 * we are the interrupt context thing that acquires the lock.
-	 */
-	spin_lock(&dev_priv->swaps_lock);
+	spin_lock_irqsave(&dev_priv->swaps_lock, irqflags);
=20
 	/* Find buffer swaps scheduled for this vertical blank */
 	list_for_each_safe(list, tmp, &dev_priv->vbl_swaps.head) {
 		drm_i915_vbl_swap_t *vbl_swap =3D
 			list_entry(list, drm_i915_vbl_swap_t, head);
-		int pipe =3D i915_get_pipe(dev, vbl_swap->plane);
=20
-		if ((counter[pipe] - vbl_swap->sequence) > (1<<23))
+		if ((counter[vbl_swap->pipe] - vbl_swap->sequence) > (1<<23))
 			continue;
=20
 		list_del(list);
@@ -186,22 +116,33 @@ static void i915_vblank_tasklet(struct d
 		spin_lock(&dev_priv->swaps_lock);
 	}
=20
-	spin_unlock(&dev_priv->swaps_lock);
-	if (nhits =3D=3D 0)
+	if (nhits =3D=3D 0) {
+		spin_unlock_irqrestore(&dev_priv->swaps_lock, irqflags);
 		return;
+	}
+
+	spin_unlock(&dev_priv->swaps_lock);
=20
 	i915_kernel_lost_context(dev);
=20
+	BEGIN_LP_RING(6);
+
+	OUT_RING(GFX_OP_DRAWRECT_INFO);
+	OUT_RING(0);
+	OUT_RING(0);
+	OUT_RING(sarea_priv->width | sarea_priv->height << 16);
+	OUT_RING(sarea_priv->width | sarea_priv->height << 16);
+	OUT_RING(0);
+
+	ADVANCE_LP_RING();
+
+	sarea_priv->ctxOwner =3D DRM_KERNEL_CONTEXT;
+
 	upper[0] =3D upper[1] =3D 0;
-	slice[0] =3D max(sarea_priv->planeA_h / nhits, 1);
-	slice[1] =3D max(sarea_priv->planeB_h / nhits, 1);
-	lower[0] =3D sarea_priv->planeA_y + slice[0];
-	lower[1] =3D sarea_priv->planeB_y + slice[0];
-
-	offsets[0] =3D sarea_priv->front_offset;
-	offsets[1] =3D sarea_priv->back_offset;
-	offsets[2] =3D sarea_priv->third_offset;
-	num_pages =3D sarea_priv->third_handle ? 3 : 2;
+	slice[0] =3D max(sarea_priv->pipeA_h / nhits, 1);
+	slice[1] =3D max(sarea_priv->pipeB_h / nhits, 1);
+	lower[0] =3D sarea_priv->pipeA_y + slice[0];
+	lower[1] =3D sarea_priv->pipeB_y + slice[0];
=20
 	spin_lock(&dev->drw_lock);
=20
@@ -213,8 +154,6 @@ static void i915_vblank_tasklet(struct d
 	for (i =3D 0; i++ < nhits;
 	     upper[0] =3D lower[0], lower[0] +=3D slice[0],
 	     upper[1] =3D lower[1], lower[1] +=3D slice[1]) {
-		int init_drawrect =3D 1;
-
 		if (i =3D=3D nhits)
 			lower[0] =3D lower[1] =3D sarea_priv->height;
=20
@@ -222,7 +161,7 @@ static void i915_vblank_tasklet(struct d
 			drm_i915_vbl_swap_t *swap_hit =3D
 				list_entry(hit, drm_i915_vbl_swap_t, head);
 			struct drm_clip_rect *rect;
-			int num_rects, plane, front, back;
+			int num_rects, pipe;
 			unsigned short top, bottom;
=20
 			drw =3D drm_get_drawable_info(dev, swap_hit->drw_id);
@@ -230,37 +169,10 @@ static void i915_vblank_tasklet(struct d
 			if (!drw)
 				continue;
=20
-			plane =3D swap_hit->plane;
-
-			if (swap_hit->flip) {
-				i915_dispatch_vsync_flip(dev, drw, plane);
-				continue;
-			}
-
-			if (init_drawrect) {
-				BEGIN_LP_RING(6);
-
-				OUT_RING(GFX_OP_DRAWRECT_INFO);
-				OUT_RING(0);
-				OUT_RING(0);
-				OUT_RING(sarea_priv->width | sarea_priv->height << 16);
-				OUT_RING(sarea_priv->width | sarea_priv->height << 16);
-				OUT_RING(0);
-
-				ADVANCE_LP_RING();
-
-				sarea_priv->ctxOwner =3D DRM_KERNEL_CONTEXT;
-
-				init_drawrect =3D 0;
-			}
-
 			rect =3D drw->rects;
-			top =3D upper[plane];
-			bottom =3D lower[plane];
-
-			front =3D (dev_priv->sarea_priv->pf_current_page >>
-				 (2 * plane)) & 0x3;
-			back =3D (front + 1) % num_pages;
+			pipe =3D swap_hit->pipe;
+			top =3D upper[pipe];
+			bottom =3D lower[pipe];
=20
 			for (num_rects =3D drw->num_rects; num_rects--; rect++) {
 				int y1 =3D max(rect->y1, top);
@@ -275,17 +187,17 @@ static void i915_vblank_tasklet(struct d
 				OUT_RING(pitchropcpp);
 				OUT_RING((y1 << 16) | rect->x1);
 				OUT_RING((y2 << 16) | rect->x2);
-				OUT_RING(offsets[front]);
+				OUT_RING(sarea_priv->front_offset);
 				OUT_RING((y1 << 16) | rect->x1);
 				OUT_RING(pitchropcpp & 0xffff);
-				OUT_RING(offsets[back]);
+				OUT_RING(sarea_priv->back_offset);
=20
 				ADVANCE_LP_RING();
 			}
 		}
 	}
=20
-	spin_unlock(&dev->drw_lock);
+	spin_unlock_irqrestore(&dev->drw_lock, irqflags);
=20
 	list_for_each_safe(hit, tmp, &hits) {
 		drm_i915_vbl_swap_t *swap_hit =3D
@@ -308,7 +220,10 @@ irqreturn_t i915_driver_irq_handler(DRM_
 	pipeb_stats =3D I915_READ(I915REG_PIPEBSTAT);
=20
 	temp =3D I915_READ16(I915REG_INT_IDENTITY_R);
-	temp &=3D (dev_priv->irq_enable_reg | USER_INT_FLAG);
+
+	temp &=3D (USER_INT_FLAG | VSYNC_PIPEA_FLAG | VSYNC_PIPEB_FLAG);
+
+	DRM_DEBUG("%s flag=3D%08x\n", __FUNCTION__, temp);
=20
 	if (temp =3D=3D 0)
 		return IRQ_NONE;
@@ -317,14 +232,10 @@ irqreturn_t i915_driver_irq_handler(DRM_
 	(void) I915_READ16(I915REG_INT_IDENTITY_R);
 	DRM_READMEMORYBARRIER();
=20
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->last_dispatch =3D
-			READ_BREADCRUMB(dev_priv);
+	dev_priv->sarea_priv->last_dispatch =3D READ_BREADCRUMB(dev_priv);
=20
-	if (temp & USER_INT_FLAG) {
+	if (temp & USER_INT_FLAG)
 		DRM_WAKEUP(&dev_priv->irq_queue);
-		i915_fence_handler(dev);
-	}
=20
 	if (temp & (VSYNC_PIPEA_FLAG | VSYNC_PIPEB_FLAG)) {
 		int vblank_pipe =3D dev_priv->vblank_pipe;
@@ -358,7 +269,7 @@ irqreturn_t i915_driver_irq_handler(DRM_
 	return IRQ_HANDLED;
 }
=20
-int i915_emit_irq(struct drm_device *dev)
+static int i915_emit_irq(struct drm_device * dev)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	RING_LOCALS;
@@ -367,9 +278,16 @@ int i915_emit_irq(struct drm_device *dev
=20
 	DRM_DEBUG("\n");
=20
-	i915_emit_breadcrumb(dev);
+	dev_priv->sarea_priv->last_enqueue =3D ++dev_priv->counter;
+
+	if (dev_priv->counter > 0x7FFFFFFFUL)
+		dev_priv->sarea_priv->last_enqueue =3D dev_priv->counter =3D 1;
=20
-	BEGIN_LP_RING(2);
+	BEGIN_LP_RING(6);
+	OUT_RING(CMD_STORE_DWORD_IDX);
+	OUT_RING(20);
+	OUT_RING(dev_priv->counter);
+	OUT_RING(0);
 	OUT_RING(0);
 	OUT_RING(GFX_OP_USER_INTERRUPT);
 	ADVANCE_LP_RING();
@@ -377,27 +295,6 @@ int i915_emit_irq(struct drm_device *dev
 	return dev_priv->counter;
 }
=20
-void i915_user_irq_on(drm_i915_private_t *dev_priv)
-{
-	spin_lock(&dev_priv->user_irq_lock);
-	if (dev_priv->irq_enabled && (++dev_priv->user_irq_refcount =3D=3D 1)=
) {
-		dev_priv->irq_enable_reg |=3D USER_INT_FLAG;
-		I915_WRITE16(I915REG_INT_ENABLE_R, dev_priv->irq_enable_reg);
-	}
-	spin_unlock(&dev_priv->user_irq_lock);
-}
-
-void i915_user_irq_off(drm_i915_private_t *dev_priv)
-{
-	spin_lock(&dev_priv->user_irq_lock);
-	if (dev_priv->irq_enabled && (--dev_priv->user_irq_refcount =3D=3D 0)=
) {
-		/*		dev_priv->irq_enable_reg &=3D ~USER_INT_FLAG;
-		  I915_WRITE16(I915REG_INT_ENABLE_R, dev_priv->irq_enable_reg);*/
-	}
-	spin_unlock(&dev_priv->user_irq_lock);
-}
-
-
 static int i915_wait_irq(struct drm_device * dev, int irq_nr)
 {
 	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
@@ -411,24 +308,19 @@ static int i915_wait_irq(struct drm_devi
=20
 	dev_priv->sarea_priv->perf_boxes |=3D I915_BOX_WAIT;
=20
-	i915_user_irq_on(dev_priv);
 	DRM_WAIT_ON(ret, dev_priv->irq_queue, 3 * DRM_HZ,
 		    READ_BREADCRUMB(dev_priv) >=3D irq_nr);
-	i915_user_irq_off(dev_priv);
=20
 	if (ret =3D=3D -EBUSY) {
 		DRM_ERROR("EBUSY -- rec: %d emitted: %d\n",
 			  READ_BREADCRUMB(dev_priv), (int)dev_priv->counter);
 	}
=20
-	if (dev_priv->sarea_priv)
-		dev_priv->sarea_priv->last_dispatch =3D
-			READ_BREADCRUMB(dev_priv);
+	dev_priv->sarea_priv->last_dispatch =3D READ_BREADCRUMB(dev_priv);
 	return ret;
 }
=20
-static int i915_driver_vblank_do_wait(struct drm_device *dev,
-				      unsigned int *sequence,
+static int i915_driver_vblank_do_wait(struct drm_device *dev, unsigned=
 int *sequence,
 				      atomic_t *counter)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
@@ -505,15 +397,15 @@ int i915_irq_wait(struct drm_device *dev
 static void i915_enable_interrupt (struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
+	u16 flag;
=20
-	dev_priv->irq_enable_reg =3D USER_INT_FLAG;
+	flag =3D 0;
 	if (dev_priv->vblank_pipe & DRM_I915_VBLANK_PIPE_A)
-		dev_priv->irq_enable_reg |=3D VSYNC_PIPEA_FLAG;
+		flag |=3D VSYNC_PIPEA_FLAG;
 	if (dev_priv->vblank_pipe & DRM_I915_VBLANK_PIPE_B)
-		dev_priv->irq_enable_reg |=3D VSYNC_PIPEB_FLAG;
+		flag |=3D VSYNC_PIPEB_FLAG;
=20
-	I915_WRITE16(I915REG_INT_ENABLE_R, dev_priv->irq_enable_reg);
-	dev_priv->irq_enabled =3D 1;
+	I915_WRITE16(I915REG_INT_ENABLE_R, USER_INT_FLAG | flag);
 }
=20
 /* Set the vblank monitor pipe
@@ -572,7 +464,7 @@ int i915_vblank_swap(struct drm_device *
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
 	drm_i915_vblank_swap_t *swap =3D data;
 	drm_i915_vbl_swap_t *vbl_swap;
-	unsigned int pipe, seqtype, curseq, plane;
+	unsigned int pipe, seqtype, curseq;
 	unsigned long irqflags;
 	struct list_head *list;
=20
@@ -581,20 +473,18 @@ int i915_vblank_swap(struct drm_device *
 		return -EINVAL;
 	}
=20
-	if (!dev_priv->sarea_priv || dev_priv->sarea_priv->rotation) {
+	if (dev_priv->sarea_priv->rotation) {
 		DRM_DEBUG("Rotation not supported\n");
 		return -EINVAL;
 	}
=20
 	if (swap->seqtype & ~(_DRM_VBLANK_RELATIVE | _DRM_VBLANK_ABSOLUTE |
-			     _DRM_VBLANK_SECONDARY | _DRM_VBLANK_NEXTONMISS |
-			     _DRM_VBLANK_FLIP)) {
+			     _DRM_VBLANK_SECONDARY | _DRM_VBLANK_NEXTONMISS)) {
 		DRM_ERROR("Invalid sequence type 0x%x\n", swap->seqtype);
 		return -EINVAL;
 	}
=20
-	plane =3D (swap->seqtype & _DRM_VBLANK_SECONDARY) ? 1 : 0;
-	pipe =3D i915_get_pipe(dev, plane);
+	pipe =3D (swap->seqtype & _DRM_VBLANK_SECONDARY) ? 1 : 0;
=20
 	seqtype =3D swap->seqtype & (_DRM_VBLANK_RELATIVE | _DRM_VBLANK_ABSOL=
UTE);
=20
@@ -605,11 +495,6 @@ int i915_vblank_swap(struct drm_device *
=20
 	spin_lock_irqsave(&dev->drw_lock, irqflags);
=20
-	/* It makes no sense to schedule a swap for a drawable that doesn't h=
ave
-	 * valid information at this point. E.g. this could mean that the X
-	 * server is too old to push drawable information to the DRM, in whic=
h
-	 * case all such swaps would become ineffective.
-	 */
 	if (!drm_get_drawable_info(dev, swap->drawable)) {
 		spin_unlock_irqrestore(&dev->drw_lock, irqflags);
 		DRM_DEBUG("Invalid drawable ID %d\n", swap->drawable);
@@ -632,43 +517,14 @@ int i915_vblank_swap(struct drm_device *
 		}
 	}
=20
-	if (swap->seqtype & _DRM_VBLANK_FLIP) {
-		swap->sequence--;
-
-		if ((curseq - swap->sequence) <=3D (1<<23)) {
-			struct drm_drawable_info *drw;
-
-			LOCK_TEST_WITH_RETURN(dev, file_priv);
-
-			spin_lock_irqsave(&dev->drw_lock, irqflags);
-
-			drw =3D drm_get_drawable_info(dev, swap->drawable);
-
-			if (!drw) {
-				spin_unlock_irqrestore(&dev->drw_lock,
-				    irqflags);
-				DRM_DEBUG("Invalid drawable ID %d\n",
-					  swap->drawable);
-				return -EINVAL;
-			}
-
-			i915_dispatch_vsync_flip(dev, drw, plane);
-
-			spin_unlock_irqrestore(&dev->drw_lock, irqflags);
-
-			return 0;
-		}
-	}
-
 	spin_lock_irqsave(&dev_priv->swaps_lock, irqflags);
=20
 	list_for_each(list, &dev_priv->vbl_swaps.head) {
 		vbl_swap =3D list_entry(list, drm_i915_vbl_swap_t, head);
=20
 		if (vbl_swap->drw_id =3D=3D swap->drawable &&
-		    vbl_swap->plane =3D=3D plane &&
+		    vbl_swap->pipe =3D=3D pipe &&
 		    vbl_swap->sequence =3D=3D swap->sequence) {
-			vbl_swap->flip =3D (swap->seqtype & _DRM_VBLANK_FLIP);
 			spin_unlock_irqrestore(&dev_priv->swaps_lock, irqflags);
 			DRM_DEBUG("Already scheduled\n");
 			return 0;
@@ -692,12 +548,8 @@ int i915_vblank_swap(struct drm_device *
 	DRM_DEBUG("\n");
=20
 	vbl_swap->drw_id =3D swap->drawable;
-	vbl_swap->plane =3D plane;
+	vbl_swap->pipe =3D pipe;
 	vbl_swap->sequence =3D swap->sequence;
-	vbl_swap->flip =3D (swap->seqtype & _DRM_VBLANK_FLIP);
-
-	if (vbl_swap->flip)
-		swap->sequence++;
=20
 	spin_lock_irqsave(&dev_priv->swaps_lock, irqflags);
=20
@@ -715,7 +567,7 @@ void i915_driver_irq_preinstall(struct d
 {
 	drm_i915_private_t *dev_priv =3D (drm_i915_private_t *) dev->dev_priv=
ate;
=20
-	I915_WRITE16(I915REG_HWSTAM, 0xeffe);
+	I915_WRITE16(I915REG_HWSTAM, 0xfffe);
 	I915_WRITE16(I915REG_INT_MASK_R, 0x0);
 	I915_WRITE16(I915REG_INT_ENABLE_R, 0x0);
 }
@@ -728,17 +580,10 @@ void i915_driver_irq_postinstall(struct=20
 	INIT_LIST_HEAD(&dev_priv->vbl_swaps.head);
 	dev_priv->swaps_pending =3D 0;
=20
-	spin_lock_init(&dev_priv->user_irq_lock);
-	dev_priv->user_irq_refcount =3D 0;
-
+	if (!dev_priv->vblank_pipe)
+		dev_priv->vblank_pipe =3D DRM_I915_VBLANK_PIPE_A;
 	i915_enable_interrupt(dev);
 	DRM_INIT_WAITQUEUE(&dev_priv->irq_queue);
-
-	/*
-	 * Initialize the hardware status page IRQ location.
-	 */
-
-	I915_WRITE(I915REG_INSTPM, (1 << 5) | (1 << 21));
 }
=20
 void i915_driver_irq_uninstall(struct drm_device * dev)
@@ -749,7 +594,6 @@ void i915_driver_irq_uninstall(struct dr
 	if (!dev_priv)
 		return;
=20
-	dev_priv->irq_enabled =3D 0;
 	I915_WRITE16(I915REG_HWSTAM, 0xffff);
 	I915_WRITE16(I915REG_INT_MASK_R, 0xffff);
 	I915_WRITE16(I915REG_INT_ENABLE_R, 0x0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
hotplug-memory-make-online_page-common-fix.patch
disable-the-memory-controller-by-default-v3-fix.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
x86-ptrace-pebs-support-warning-fix.patch
git-agpgart.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=3Dy.p=
atch
revert-git-drm.patch
git-dvb-kconfig-fix.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
git-dlm-vs-git-gfs2-nwm.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struc=
t-device.patch
gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-in=
finiband.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mmc.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
net-drivers-fix-platform-driver-hotplug-coldplug.patch
smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt.pat=
ch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex=
-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct=
-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct=
-class_device-fix.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
fix-gregkh-usb-wusb-add-the-wireless-usb-stack-to-linux.patch
uwb-seems-to-need-pci.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
git-xfs-fixups.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fix-conflict.patch
git-cryptodev-fix-conflict-hack.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-git-rejects.patch
ext4-is-busted-on-m68k.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.pat=
ch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patc=
h
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.pat=
ch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-t=
he-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.pa=
tch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.p=
atch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.=
patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkp=
atch-fixes.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=3Dn.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fi=
xes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-ha=
ndle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-ha=
ndle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-a=
nd-user_ns-fix.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.p=
atch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-v=
t-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zon=
e-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zon=
e-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.p=
atch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fix=
es.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=3Dn-override-with-edd=3Donoff-fix.p=
atch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.p=
atch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patc=
h
w1-build-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
