From: akpm@linux-foundation.org
Subject: + drm-fix-for-non-coherent-dma-powerpc.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:07:38 -0800
Message-ID: <200803060007.m2607cXZ028840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbYCFAIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:08:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, airlied@linux.ie, davem@davemloft.net, tony.luck@intel.com


The patch titled
     drm: fix for non-coherent DMA PowerPC
has been added to the -mm tree.  Its filename is
     drm-fix-for-non-coherent-dma-powerpc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: fix for non-coherent DMA PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This patch fixes bits of the DRM so to make the radeon DRI work on
non-cache coherent PCI DMA variants of the PowerPC processors.

It moves the few places that needs change to wrappers to that
other architectures with similar issues can easily add their
own changes to those wrappers, at least until we have more useful
generic kernel API.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/ati_pcigart.c |    6 ++++++
 drivers/char/drm/drm_scatter.c |   11 ++++++++++-
 drivers/char/drm/drm_vm.c      |   20 +++++++++++++++-----
 3 files changed, 31 insertions(+), 6 deletions(-)

diff -puN drivers/char/drm/ati_pcigart.c~drm-fix-for-non-coherent-dma-powerpc drivers/char/drm/ati_pcigart.c
--- a/drivers/char/drm/ati_pcigart.c~drm-fix-for-non-coherent-dma-powerpc
+++ a/drivers/char/drm/ati_pcigart.c
@@ -213,6 +213,12 @@ int drm_ati_pcigart_init(struct drm_devi
 		}
 	}
 
+	if (gart_info->gart_table_location == DRM_ATI_GART_MAIN)
+		dma_sync_single_for_device(&dev->pdev->dev,
+					   bus_address,
+					   max_pages * sizeof(u32),
+					   PCI_DMA_TODEVICE);
+
 	ret = 1;
 
 #if defined(__i386__) || defined(__x86_64__)
diff -puN drivers/char/drm/drm_scatter.c~drm-fix-for-non-coherent-dma-powerpc drivers/char/drm/drm_scatter.c
--- a/drivers/char/drm/drm_scatter.c~drm-fix-for-non-coherent-dma-powerpc
+++ a/drivers/char/drm/drm_scatter.c
@@ -36,6 +36,15 @@
 
 #define DEBUG_SCATTER 0
 
+static inline void *drm_vmalloc_dma(unsigned long size)
+{
+#if defined(__powerpc__) && defined(CONFIG_NOT_COHERENT_CACHE)
+	return __vmalloc(size, GFP_KERNEL, PAGE_KERNEL | _PAGE_NO_CACHE);
+#else
+	return vmalloc_32(size);
+#endif
+}
+
 void drm_sg_cleanup(struct drm_sg_mem * entry)
 {
 	struct page *page;
@@ -104,7 +113,7 @@ int drm_sg_alloc(struct drm_device *dev,
 	}
 	memset((void *)entry->busaddr, 0, pages * sizeof(*entry->busaddr));
 
-	entry->virtual = vmalloc_32(pages << PAGE_SHIFT);
+	entry->virtual = drm_vmalloc_dma(pages << PAGE_SHIFT);
 	if (!entry->virtual) {
 		drm_free(entry->busaddr,
 			 entry->pages * sizeof(*entry->busaddr), DRM_MEM_PAGES);
diff -puN drivers/char/drm/drm_vm.c~drm-fix-for-non-coherent-dma-powerpc drivers/char/drm/drm_vm.c
--- a/drivers/char/drm/drm_vm.c~drm-fix-for-non-coherent-dma-powerpc
+++ a/drivers/char/drm/drm_vm.c
@@ -58,13 +58,24 @@ static pgprot_t drm_io_prot(uint32_t map
 	pgprot_val(tmp) |= _PAGE_NO_CACHE;
 	if (map_type == _DRM_REGISTERS)
 		pgprot_val(tmp) |= _PAGE_GUARDED;
-#endif
-#if defined(__ia64__)
+#elif defined(__ia64__)
 	if (efi_range_is_wc(vma->vm_start, vma->vm_end -
 				    vma->vm_start))
 		tmp = pgprot_writecombine(tmp);
 	else
 		tmp = pgprot_noncached(tmp);
+#elif defined(__sparc__)
+	tmp = pgprot_noncached(tmp);
+#endif
+	return tmp;
+}
+
+static pgprot_t drm_dma_prot(uint32_t map_type, struct vm_area_struct *vma)
+{
+	pgprot_t tmp = vm_get_page_prot(vma->vm_flags);
+
+#if defined(__powerpc__) && defined(CONFIG_NOT_COHERENT_CACHE)
+	tmp |= _PAGE_NO_CACHE;
 #endif
 	return tmp;
 }
@@ -610,9 +621,6 @@ static int drm_mmap_locked(struct file *
 		offset = dev->driver->get_reg_ofs(dev);
 		vma->vm_flags |= VM_IO;	/* not in core dump */
 		vma->vm_page_prot = drm_io_prot(map->type, vma);
-#ifdef __sparc__
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#endif
 		if (io_remap_pfn_range(vma, vma->vm_start,
 				       (map->offset + offset) >> PAGE_SHIFT,
 				       vma->vm_end - vma->vm_start,
@@ -631,6 +639,7 @@ static int drm_mmap_locked(struct file *
 		    page_to_pfn(virt_to_page(map->handle)),
 		    vma->vm_end - vma->vm_start, vma->vm_page_prot))
 			return -EAGAIN;
+		vma->vm_page_prot = drm_dma_prot(map->type, vma);
 	/* fall through to _DRM_SHM */
 	case _DRM_SHM:
 		vma->vm_ops = &drm_vm_shm_ops;
@@ -643,6 +652,7 @@ static int drm_mmap_locked(struct file *
 		vma->vm_ops = &drm_vm_sg_ops;
 		vma->vm_private_data = (void *)map;
 		vma->vm_flags |= VM_RESERVED;
+		vma->vm_page_prot = drm_dma_prot(map->type, vma);
 		break;
 	case _DRM_TTM:
 		return drm_bo_mmap_locked(vma, filp, map);
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

of_serial-fix-section-mismatch-warnings.patch
git-powerpc.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-ieee1394.patch
git-md-accel.patch
drm-fix-for-non-coherent-dma-powerpc.patch
iomap-fix-64-bits-resources-on-32-bits.patch
fb-add-support-for-foreign-endianness.patch
fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
powerpc-offb-add-support-for-foreign-endianness.patch
asm-futexh-should-include-linux-uaccessh.patch
basic-braille-screen-reader-support-ppc-fix.patch

