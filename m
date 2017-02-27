From: akpm@linux-foundation.org
Subject: [merged]
 mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:25:05 -0800
Message-ID: <58b48b21.hWuXiNX6Vc41Iyz0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbdB1BBJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 20:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, arnd@arndb.de, dan.j.williams@intel.com, darrick.wong@oracle.com, dave.hansen@intel.com, hch@lst.de, jack@suse.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf
has been removed from the -mm tree.  Its filename was
     mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jiang <dave.jiang@intel.com>
Subject: mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf

->fault(), ->page_mkwrite(), and ->pfn_mkwrite() calls do not need to take
a vma and vmf parameter when the vma already resides in vmf.  Remove the
vma parameter to simplify things.

[arnd@arndb.de: fix ARM build]
  Link: http://lkml.kernel.org/r/20170125223558.1451224-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/148521301778.19116.10840599906674778980.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_64_vio.c                 |    4 -
 arch/powerpc/platforms/cell/spufs/file.c         |   39 ++++++-------
 drivers/android/binder.c                         |    2 
 drivers/char/agp/alpha-agp.c                     |    5 -
 drivers/char/mspec.c                             |    6 +-
 drivers/dax/dax.c                                |   12 ++--
 drivers/gpu/drm/armada/armada_gem.c              |    9 +--
 drivers/gpu/drm/drm_vm.c                         |   32 +++++-----
 drivers/gpu/drm/etnaviv/etnaviv_drv.h            |    2 
 drivers/gpu/drm/etnaviv/etnaviv_gem.c            |    3 -
 drivers/gpu/drm/exynos/exynos_drm_gem.c          |    3 -
 drivers/gpu/drm/exynos/exynos_drm_gem.h          |    2 
 drivers/gpu/drm/gma500/framebuffer.c             |    3 -
 drivers/gpu/drm/gma500/gem.c                     |    3 -
 drivers/gpu/drm/gma500/psb_drv.h                 |    2 
 drivers/gpu/drm/i915/i915_drv.h                  |    2 
 drivers/gpu/drm/i915/i915_gem.c                  |    4 -
 drivers/gpu/drm/msm/msm_drv.h                    |    2 
 drivers/gpu/drm/msm/msm_gem.c                    |    3 -
 drivers/gpu/drm/omapdrm/omap_drv.h               |    2 
 drivers/gpu/drm/omapdrm/omap_gem.c               |    4 -
 drivers/gpu/drm/qxl/qxl_ttm.c                    |    6 +-
 drivers/gpu/drm/radeon/radeon_ttm.c              |    6 +-
 drivers/gpu/drm/tegra/gem.c                      |    3 -
 drivers/gpu/drm/ttm/ttm_bo_vm.c                  |   10 +--
 drivers/gpu/drm/udl/udl_drv.h                    |    2 
 drivers/gpu/drm/udl/udl_gem.c                    |    3 -
 drivers/gpu/drm/vgem/vgem_drv.c                  |    3 -
 drivers/gpu/drm/virtio/virtgpu_ttm.c             |    7 +-
 drivers/hsi/clients/cmt_speech.c                 |    4 -
 drivers/hwtracing/intel_th/msu.c                 |    6 +-
 drivers/infiniband/hw/hfi1/file_ops.c            |    4 -
 drivers/infiniband/hw/qib/qib_file_ops.c         |    2 
 drivers/media/v4l2-core/videobuf-dma-sg.c        |    3 -
 drivers/misc/cxl/context.c                       |    3 -
 drivers/misc/sgi-gru/grumain.c                   |    3 -
 drivers/misc/sgi-gru/grutables.h                 |    2 
 drivers/scsi/cxlflash/superpipe.c                |    6 +-
 drivers/scsi/sg.c                                |    3 -
 drivers/staging/android/ion/ion.c                |    6 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c |    7 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c     |    2 
 drivers/target/target_core_user.c                |    6 +-
 drivers/uio/uio.c                                |    6 +-
 drivers/usb/mon/mon_bin.c                        |    4 -
 drivers/video/fbdev/core/fb_defio.c              |   16 ++---
 drivers/xen/privcmd.c                            |    4 -
 fs/9p/vfs_file.c                                 |    4 -
 fs/btrfs/ctree.h                                 |    2 
 fs/btrfs/inode.c                                 |    6 +-
 fs/ceph/addr.c                                   |    8 +-
 fs/cifs/file.c                                   |    2 
 fs/dax.c                                         |   15 ++---
 fs/ext2/file.c                                   |   17 ++---
 fs/ext4/ext4.h                                   |    4 -
 fs/ext4/file.c                                   |   17 ++---
 fs/ext4/inode.c                                  |    9 +--
 fs/f2fs/file.c                                   |    7 +-
 fs/fuse/file.c                                   |    6 +-
 fs/gfs2/file.c                                   |    8 +-
 fs/iomap.c                                       |    5 -
 fs/kernfs/file.c                                 |   13 ++--
 fs/ncpfs/mmap.c                                  |    7 +-
 fs/nfs/file.c                                    |    4 -
 fs/nilfs2/file.c                                 |    3 -
 fs/ocfs2/mmap.c                                  |   15 ++---
 fs/proc/vmcore.c                                 |    4 -
 fs/ubifs/file.c                                  |    5 -
 fs/xfs/xfs_file.c                                |   25 +++-----
 include/linux/dax.h                              |    5 -
 include/linux/iomap.h                            |    3 -
 include/linux/mm.h                               |   10 +--
 ipc/shm.c                                        |    6 +-
 kernel/events/core.c                             |    6 +-
 kernel/relay.c                                   |    4 -
 mm/filemap.c                                     |   19 +++---
 mm/hugetlb.c                                     |    2 
 mm/memory.c                                      |    6 +-
 mm/mmap.c                                        |    9 +--
 mm/nommu.c                                       |    2 
 mm/shmem.c                                       |    3 -
 security/selinux/selinuxfs.c                     |    5 -
 sound/core/pcm_native.c                          |   15 ++---
 sound/usb/usx2y/us122l.c                         |    5 -
 sound/usb/usx2y/usX2Yhwdep.c                     |    7 +-
 sound/usb/usx2y/usx2yhwdeppcm.c                  |    5 -
 virt/kvm/kvm_main.c                              |    4 -
 87 files changed, 283 insertions(+), 290 deletions(-)

diff -puN arch/powerpc/kvm/book3s_64_vio.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf arch/powerpc/kvm/book3s_64_vio.c
--- a/arch/powerpc/kvm/book3s_64_vio.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/arch/powerpc/kvm/book3s_64_vio.c
@@ -102,9 +102,9 @@ static void release_spapr_tce_table(stru
 	kfree(stt);
 }
 
-static int kvm_spapr_tce_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int kvm_spapr_tce_fault(struct vm_fault *vmf)
 {
-	struct kvmppc_spapr_tce_table *stt = vma->vm_file->private_data;
+	struct kvmppc_spapr_tce_table *stt = vmf->vma->vm_file->private_data;
 	struct page *page;
 
 	if (vmf->pgoff >= kvmppc_tce_pages(stt->size))
diff -puN arch/powerpc/platforms/cell/spufs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -233,8 +233,9 @@ spufs_mem_write(struct file *file, const
 }
 
 static int
-spufs_mem_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+spufs_mem_mmap_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct spu_context *ctx	= vma->vm_file->private_data;
 	unsigned long pfn, offset;
 
@@ -311,12 +312,11 @@ static const struct file_operations spuf
 	.mmap			= spufs_mem_mmap,
 };
 
-static int spufs_ps_fault(struct vm_area_struct *vma,
-				    struct vm_fault *vmf,
+static int spufs_ps_fault(struct vm_fault *vmf,
 				    unsigned long ps_offs,
 				    unsigned long ps_size)
 {
-	struct spu_context *ctx = vma->vm_file->private_data;
+	struct spu_context *ctx = vmf->vma->vm_file->private_data;
 	unsigned long area, offset = vmf->pgoff << PAGE_SHIFT;
 	int ret = 0;
 
@@ -354,7 +354,7 @@ static int spufs_ps_fault(struct vm_area
 		down_read(&current->mm->mmap_sem);
 	} else {
 		area = ctx->spu->problem_phys + ps_offs;
-		vm_insert_pfn(vma, vmf->address, (area + offset) >> PAGE_SHIFT);
+		vm_insert_pfn(vmf->vma, vmf->address, (area + offset) >> PAGE_SHIFT);
 		spu_context_trace(spufs_ps_fault__insert, ctx, ctx->spu);
 	}
 
@@ -367,10 +367,9 @@ refault:
 }
 
 #if SPUFS_MMAP_4K
-static int spufs_cntl_mmap_fault(struct vm_area_struct *vma,
-					   struct vm_fault *vmf)
+static int spufs_cntl_mmap_fault(struct vm_fault *vmf)
 {
-	return spufs_ps_fault(vma, vmf, 0x4000, SPUFS_CNTL_MAP_SIZE);
+	return spufs_ps_fault(vmf, 0x4000, SPUFS_CNTL_MAP_SIZE);
 }
 
 static const struct vm_operations_struct spufs_cntl_mmap_vmops = {
@@ -1067,15 +1066,15 @@ static ssize_t spufs_signal1_write(struc
 }
 
 static int
-spufs_signal1_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+spufs_signal1_mmap_fault(struct vm_fault *vmf)
 {
 #if SPUFS_SIGNAL_MAP_SIZE == 0x1000
-	return spufs_ps_fault(vma, vmf, 0x14000, SPUFS_SIGNAL_MAP_SIZE);
+	return spufs_ps_fault(vmf, 0x14000, SPUFS_SIGNAL_MAP_SIZE);
 #elif SPUFS_SIGNAL_MAP_SIZE == 0x10000
 	/* For 64k pages, both signal1 and signal2 can be used to mmap the whole
 	 * signal 1 and 2 area
 	 */
-	return spufs_ps_fault(vma, vmf, 0x10000, SPUFS_SIGNAL_MAP_SIZE);
+	return spufs_ps_fault(vmf, 0x10000, SPUFS_SIGNAL_MAP_SIZE);
 #else
 #error unsupported page size
 #endif
@@ -1205,15 +1204,15 @@ static ssize_t spufs_signal2_write(struc
 
 #if SPUFS_MMAP_4K
 static int
-spufs_signal2_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+spufs_signal2_mmap_fault(struct vm_fault *vmf)
 {
 #if SPUFS_SIGNAL_MAP_SIZE == 0x1000
-	return spufs_ps_fault(vma, vmf, 0x1c000, SPUFS_SIGNAL_MAP_SIZE);
+	return spufs_ps_fault(vmf, 0x1c000, SPUFS_SIGNAL_MAP_SIZE);
 #elif SPUFS_SIGNAL_MAP_SIZE == 0x10000
 	/* For 64k pages, both signal1 and signal2 can be used to mmap the whole
 	 * signal 1 and 2 area
 	 */
-	return spufs_ps_fault(vma, vmf, 0x10000, SPUFS_SIGNAL_MAP_SIZE);
+	return spufs_ps_fault(vmf, 0x10000, SPUFS_SIGNAL_MAP_SIZE);
 #else
 #error unsupported page size
 #endif
@@ -1334,9 +1333,9 @@ DEFINE_SPUFS_ATTRIBUTE(spufs_signal2_typ
 
 #if SPUFS_MMAP_4K
 static int
-spufs_mss_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+spufs_mss_mmap_fault(struct vm_fault *vmf)
 {
-	return spufs_ps_fault(vma, vmf, 0x0000, SPUFS_MSS_MAP_SIZE);
+	return spufs_ps_fault(vmf, 0x0000, SPUFS_MSS_MAP_SIZE);
 }
 
 static const struct vm_operations_struct spufs_mss_mmap_vmops = {
@@ -1396,9 +1395,9 @@ static const struct file_operations spuf
 };
 
 static int
-spufs_psmap_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+spufs_psmap_mmap_fault(struct vm_fault *vmf)
 {
-	return spufs_ps_fault(vma, vmf, 0x0000, SPUFS_PS_MAP_SIZE);
+	return spufs_ps_fault(vmf, 0x0000, SPUFS_PS_MAP_SIZE);
 }
 
 static const struct vm_operations_struct spufs_psmap_mmap_vmops = {
@@ -1456,9 +1455,9 @@ static const struct file_operations spuf
 
 #if SPUFS_MMAP_4K
 static int
-spufs_mfc_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+spufs_mfc_mmap_fault(struct vm_fault *vmf)
 {
-	return spufs_ps_fault(vma, vmf, 0x3000, SPUFS_MFC_MAP_SIZE);
+	return spufs_ps_fault(vmf, 0x3000, SPUFS_MFC_MAP_SIZE);
 }
 
 static const struct vm_operations_struct spufs_mfc_mmap_vmops = {
diff -puN drivers/android/binder.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/android/binder.c
--- a/drivers/android/binder.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/android/binder.c
@@ -3342,7 +3342,7 @@ static void binder_vma_close(struct vm_a
 	binder_defer_work(proc, BINDER_DEFERRED_PUT_FILES);
 }
 
-static int binder_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int binder_vm_fault(struct vm_fault *vmf)
 {
 	return VM_FAULT_SIGBUS;
 }
diff -puN drivers/char/agp/alpha-agp.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/char/agp/alpha-agp.c
--- a/drivers/char/agp/alpha-agp.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/char/agp/alpha-agp.c
@@ -11,15 +11,14 @@
 
 #include "agp.h"
 
-static int alpha_core_agp_vm_fault(struct vm_area_struct *vma,
-					struct vm_fault *vmf)
+static int alpha_core_agp_vm_fault(struct vm_fault *vmf)
 {
 	alpha_agp_info *agp = agp_bridge->dev_private_data;
 	dma_addr_t dma_addr;
 	unsigned long pa;
 	struct page *page;
 
-	dma_addr = vmf->address - vma->vm_start + agp->aperture.bus_base;
+	dma_addr = vmf->address - vmf->vma->vm_start + agp->aperture.bus_base;
 	pa = agp->ops->translate(agp, dma_addr);
 
 	if (pa == (unsigned long)-EINVAL)
diff -puN drivers/char/mspec.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/char/mspec.c
--- a/drivers/char/mspec.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/char/mspec.c
@@ -191,12 +191,12 @@ mspec_close(struct vm_area_struct *vma)
  * Creates a mspec page and maps it to user space.
  */
 static int
-mspec_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+mspec_fault(struct vm_fault *vmf)
 {
 	unsigned long paddr, maddr;
 	unsigned long pfn;
 	pgoff_t index = vmf->pgoff;
-	struct vma_data *vdata = vma->vm_private_data;
+	struct vma_data *vdata = vmf->vma->vm_private_data;
 
 	maddr = (volatile unsigned long) vdata->maddr[index];
 	if (maddr == 0) {
@@ -227,7 +227,7 @@ mspec_fault(struct vm_area_struct *vma,
 	 * be because another thread has installed the pte first, so it
 	 * is no problem.
 	 */
-	vm_insert_pfn(vma, vmf->address, pfn);
+	vm_insert_pfn(vmf->vma, vmf->address, pfn);
 
 	return VM_FAULT_NOPAGE;
 }
diff -puN drivers/dax/dax.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/dax/dax.c
--- a/drivers/dax/dax.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/dax/dax.c
@@ -419,8 +419,7 @@ static phys_addr_t pgoff_to_phys(struct
 	return -1;
 }
 
-static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_area_struct *vma,
-		struct vm_fault *vmf)
+static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 {
 	struct device *dev = &dax_dev->dev;
 	struct dax_region *dax_region;
@@ -428,7 +427,7 @@ static int __dax_dev_fault(struct dax_de
 	phys_addr_t phys;
 	pfn_t pfn;
 
-	if (check_vma(dax_dev, vma, __func__))
+	if (check_vma(dax_dev, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
 
 	dax_region = dax_dev->region;
@@ -446,7 +445,7 @@ static int __dax_dev_fault(struct dax_de
 
 	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
 
-	rc = vm_insert_mixed(vma, vmf->address, pfn);
+	rc = vm_insert_mixed(vmf->vma, vmf->address, pfn);
 
 	if (rc == -ENOMEM)
 		return VM_FAULT_OOM;
@@ -456,8 +455,9 @@ static int __dax_dev_fault(struct dax_de
 	return VM_FAULT_NOPAGE;
 }
 
-static int dax_dev_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int dax_dev_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	int rc;
 	struct file *filp = vma->vm_file;
 	struct dax_dev *dax_dev = filp->private_data;
@@ -466,7 +466,7 @@ static int dax_dev_fault(struct vm_area_
 			current->comm, (vmf->flags & FAULT_FLAG_WRITE)
 			? "write" : "read", vma->vm_start, vma->vm_end);
 	rcu_read_lock();
-	rc = __dax_dev_fault(dax_dev, vma, vmf);
+	rc = __dax_dev_fault(dax_dev, vmf);
 	rcu_read_unlock();
 
 	return rc;
diff -puN drivers/gpu/drm/armada/armada_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/armada/armada_gem.c
--- a/drivers/gpu/drm/armada/armada_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/armada/armada_gem.c
@@ -14,14 +14,15 @@
 #include <drm/armada_drm.h>
 #include "armada_ioctlP.h"
 
-static int armada_gem_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int armada_gem_vm_fault(struct vm_fault *vmf)
 {
-	struct armada_gem_object *obj = drm_to_armada_gem(vma->vm_private_data);
+	struct drm_gem_object *gobj = vmf->vma->vm_private_data;
+	struct armada_gem_object *obj = drm_to_armada_gem(gobj);
 	unsigned long pfn = obj->phys_addr >> PAGE_SHIFT;
 	int ret;
 
-	pfn += (vmf->address - vma->vm_start) >> PAGE_SHIFT;
-	ret = vm_insert_pfn(vma, vmf->address, pfn);
+	pfn += (vmf->address - vmf->vma->vm_start) >> PAGE_SHIFT;
+	ret = vm_insert_pfn(vmf->vma, vmf->address, pfn);
 
 	switch (ret) {
 	case 0:
diff -puN drivers/gpu/drm/drm_vm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/drm_vm.c
@@ -96,8 +96,9 @@ static pgprot_t drm_dma_prot(uint32_t ma
  * map, get the page, increment the use count and return it.
  */
 #if IS_ENABLED(CONFIG_AGP)
-static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_do_vm_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_file *priv = vma->vm_file->private_data;
 	struct drm_device *dev = priv->minor->dev;
 	struct drm_local_map *map = NULL;
@@ -168,7 +169,7 @@ vm_fault_error:
 	return VM_FAULT_SIGBUS;	/* Disallow mremap */
 }
 #else
-static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_do_vm_fault(struct vm_fault *vmf)
 {
 	return VM_FAULT_SIGBUS;
 }
@@ -184,8 +185,9 @@ static int drm_do_vm_fault(struct vm_are
  * Get the mapping, find the real physical page to map, get the page, and
  * return it.
  */
-static int drm_do_vm_shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_do_vm_shm_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_local_map *map = vma->vm_private_data;
 	unsigned long offset;
 	unsigned long i;
@@ -280,14 +282,14 @@ static void drm_vm_shm_close(struct vm_a
 /**
  * \c fault method for DMA virtual memory.
  *
- * \param vma virtual memory area.
  * \param address access address.
  * \return pointer to the page structure.
  *
  * Determine the page number from the page offset and get it from drm_device_dma::pagelist.
  */
-static int drm_do_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_do_vm_dma_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_file *priv = vma->vm_file->private_data;
 	struct drm_device *dev = priv->minor->dev;
 	struct drm_device_dma *dma = dev->dma;
@@ -315,14 +317,14 @@ static int drm_do_vm_dma_fault(struct vm
 /**
  * \c fault method for scatter-gather virtual memory.
  *
- * \param vma virtual memory area.
  * \param address access address.
  * \return pointer to the page structure.
  *
  * Determine the map offset from the page offset and get it from drm_sg_mem::pagelist.
  */
-static int drm_do_vm_sg_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_do_vm_sg_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_local_map *map = vma->vm_private_data;
 	struct drm_file *priv = vma->vm_file->private_data;
 	struct drm_device *dev = priv->minor->dev;
@@ -347,24 +349,24 @@ static int drm_do_vm_sg_fault(struct vm_
 	return 0;
 }
 
-static int drm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_vm_fault(struct vm_fault *vmf)
 {
-	return drm_do_vm_fault(vma, vmf);
+	return drm_do_vm_fault(vmf);
 }
 
-static int drm_vm_shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_vm_shm_fault(struct vm_fault *vmf)
 {
-	return drm_do_vm_shm_fault(vma, vmf);
+	return drm_do_vm_shm_fault(vmf);
 }
 
-static int drm_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_vm_dma_fault(struct vm_fault *vmf)
 {
-	return drm_do_vm_dma_fault(vma, vmf);
+	return drm_do_vm_dma_fault(vmf);
 }
 
-static int drm_vm_sg_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_vm_sg_fault(struct vm_fault *vmf)
 {
-	return drm_do_vm_sg_fault(vma, vmf);
+	return drm_do_vm_sg_fault(vmf);
 }
 
 /** AGP virtual memory operations */
diff -puN drivers/gpu/drm/etnaviv/etnaviv_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/etnaviv/etnaviv_drv.h
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/etnaviv/etnaviv_drv.h
@@ -73,7 +73,7 @@ int etnaviv_ioctl_gem_submit(struct drm_
 		struct drm_file *file);
 
 int etnaviv_gem_mmap(struct file *filp, struct vm_area_struct *vma);
-int etnaviv_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+int etnaviv_gem_fault(struct vm_fault *vmf);
 int etnaviv_gem_mmap_offset(struct drm_gem_object *obj, u64 *offset);
 struct sg_table *etnaviv_gem_prime_get_sg_table(struct drm_gem_object *obj);
 void *etnaviv_gem_prime_vmap(struct drm_gem_object *obj);
diff -puN drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/etnaviv/etnaviv_gem.c
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -175,8 +175,9 @@ int etnaviv_gem_mmap(struct file *filp,
 	return obj->ops->mmap(obj, vma);
 }
 
-int etnaviv_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int etnaviv_gem_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct etnaviv_gem_object *etnaviv_obj = to_etnaviv_bo(obj);
 	struct page **pages, *page;
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -447,8 +447,9 @@ int exynos_drm_gem_dumb_map_offset(struc
 	return ret;
 }
 
-int exynos_drm_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int exynos_drm_gem_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct exynos_drm_gem *exynos_gem = to_exynos_gem(obj);
 	unsigned long pfn;
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/exynos/exynos_drm_gem.h
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.h
@@ -116,7 +116,7 @@ int exynos_drm_gem_dumb_map_offset(struc
 				   uint64_t *offset);
 
 /* page fault handler and mmap fault address(virtual) to physical memory. */
-int exynos_drm_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+int exynos_drm_gem_fault(struct vm_fault *vmf);
 
 /* set vm_flags and we can change the vm attribute to other one at here. */
 int exynos_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
diff -puN drivers/gpu/drm/gma500/framebuffer.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/gma500/framebuffer.c
--- a/drivers/gpu/drm/gma500/framebuffer.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/gma500/framebuffer.c
@@ -111,8 +111,9 @@ static int psbfb_pan(struct fb_var_scree
         return 0;
 }
 
-static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int psbfb_vm_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct psb_framebuffer *psbfb = vma->vm_private_data;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
diff -puN drivers/gpu/drm/gma500/gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/gma500/gem.c
--- a/drivers/gpu/drm/gma500/gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/gma500/gem.c
@@ -164,8 +164,9 @@ int psb_gem_dumb_create(struct drm_file
  *	vma->vm_private_data points to the GEM object that is backing this
  *	mapping.
  */
-int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int psb_gem_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj;
 	struct gtt_range *r;
 	int ret;
diff -puN drivers/gpu/drm/gma500/psb_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/gma500/psb_drv.h
--- a/drivers/gpu/drm/gma500/psb_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/gma500/psb_drv.h
@@ -752,7 +752,7 @@ extern int psb_gem_dumb_create(struct dr
 			struct drm_mode_create_dumb *args);
 extern int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
 			uint32_t handle, uint64_t *offset);
-extern int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+extern int psb_gem_fault(struct vm_fault *vmf);
 
 /* psb_device.c */
 extern const struct psb_ops psb_chip_ops;
diff -puN drivers/gpu/drm/i915/i915_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/i915/i915_drv.h
--- a/drivers/gpu/drm/i915/i915_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/i915/i915_drv.h
@@ -3352,7 +3352,7 @@ int __must_check i915_gem_wait_for_idle(
 					unsigned int flags);
 int __must_check i915_gem_suspend(struct drm_i915_private *dev_priv);
 void i915_gem_resume(struct drm_i915_private *dev_priv);
-int i915_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+int i915_gem_fault(struct vm_fault *vmf);
 int i915_gem_object_wait(struct drm_i915_gem_object *obj,
 			 unsigned int flags,
 			 long timeout,
diff -puN drivers/gpu/drm/i915/i915_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -1772,7 +1772,6 @@ compute_partial_view(struct drm_i915_gem
 
 /**
  * i915_gem_fault - fault a page into the GTT
- * @area: CPU VMA in question
  * @vmf: fault info
  *
  * The fault handler is set up by drm_gem_mmap() when a object is GTT mapped
@@ -1789,9 +1788,10 @@ compute_partial_view(struct drm_i915_gem
  * The current feature set supported by i915_gem_fault() and thus GTT mmaps
  * is exposed via I915_PARAM_MMAP_GTT_VERSION (see i915_gem_mmap_gtt_version).
  */
-int i915_gem_fault(struct vm_area_struct *area, struct vm_fault *vmf)
+int i915_gem_fault(struct vm_fault *vmf)
 {
 #define MIN_CHUNK_PAGES ((1 << 20) >> PAGE_SHIFT) /* 1 MiB */
+	struct vm_area_struct *area = vmf->vma;
 	struct drm_i915_gem_object *obj = to_intel_bo(area->vm_private_data);
 	struct drm_device *dev = obj->base.dev;
 	struct drm_i915_private *dev_priv = to_i915(dev);
diff -puN drivers/gpu/drm/msm/msm_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/msm/msm_drv.h
--- a/drivers/gpu/drm/msm/msm_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/msm/msm_drv.h
@@ -206,7 +206,7 @@ void msm_gem_shrinker_cleanup(struct drm
 int msm_gem_mmap_obj(struct drm_gem_object *obj,
 			struct vm_area_struct *vma);
 int msm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
-int msm_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+int msm_gem_fault(struct vm_fault *vmf);
 uint64_t msm_gem_mmap_offset(struct drm_gem_object *obj);
 int msm_gem_get_iova_locked(struct drm_gem_object *obj, int id,
 		uint64_t *iova);
diff -puN drivers/gpu/drm/msm/msm_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/msm/msm_gem.c
--- a/drivers/gpu/drm/msm/msm_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/msm/msm_gem.c
@@ -191,8 +191,9 @@ int msm_gem_mmap(struct file *filp, stru
 	return msm_gem_mmap_obj(vma->vm_private_data, vma);
 }
 
-int msm_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int msm_gem_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_device *dev = obj->dev;
 	struct msm_drm_private *priv = dev->dev_private;
diff -puN drivers/gpu/drm/omapdrm/omap_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/omapdrm/omap_drv.h
--- a/drivers/gpu/drm/omapdrm/omap_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/omapdrm/omap_drv.h
@@ -188,7 +188,7 @@ int omap_gem_dumb_create(struct drm_file
 int omap_gem_mmap(struct file *filp, struct vm_area_struct *vma);
 int omap_gem_mmap_obj(struct drm_gem_object *obj,
 		struct vm_area_struct *vma);
-int omap_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+int omap_gem_fault(struct vm_fault *vmf);
 int omap_gem_op_start(struct drm_gem_object *obj, enum omap_gem_op op);
 int omap_gem_op_finish(struct drm_gem_object *obj, enum omap_gem_op op);
 int omap_gem_op_sync(struct drm_gem_object *obj, enum omap_gem_op op);
diff -puN drivers/gpu/drm/omapdrm/omap_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/omapdrm/omap_gem.c
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -518,7 +518,6 @@ static int fault_2d(struct drm_gem_objec
 
 /**
  * omap_gem_fault		-	pagefault handler for GEM objects
- * @vma: the VMA of the GEM object
  * @vmf: fault detail
  *
  * Invoked when a fault occurs on an mmap of a GEM managed area. GEM
@@ -529,8 +528,9 @@ static int fault_2d(struct drm_gem_objec
  * vma->vm_private_data points to the GEM object that is backing this
  * mapping.
  */
-int omap_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int omap_gem_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct omap_gem_object *omap_obj = to_omap_bo(obj);
 	struct drm_device *dev = obj->dev;
diff -puN drivers/gpu/drm/qxl/qxl_ttm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/qxl/qxl_ttm.c
--- a/drivers/gpu/drm/qxl/qxl_ttm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -105,15 +105,15 @@ static void qxl_ttm_global_fini(struct q
 static struct vm_operations_struct qxl_ttm_vm_ops;
 static const struct vm_operations_struct *ttm_vm_ops;
 
-static int qxl_ttm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int qxl_ttm_fault(struct vm_fault *vmf)
 {
 	struct ttm_buffer_object *bo;
 	int r;
 
-	bo = (struct ttm_buffer_object *)vma->vm_private_data;
+	bo = (struct ttm_buffer_object *)vmf->vma->vm_private_data;
 	if (bo == NULL)
 		return VM_FAULT_NOPAGE;
-	r = ttm_vm_ops->fault(vma, vmf);
+	r = ttm_vm_ops->fault(vmf);
 	return r;
 }
 
diff -puN drivers/gpu/drm/radeon/radeon_ttm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/radeon/radeon_ttm.c
--- a/drivers/gpu/drm/radeon/radeon_ttm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -979,19 +979,19 @@ void radeon_ttm_set_active_vram_size(str
 static struct vm_operations_struct radeon_ttm_vm_ops;
 static const struct vm_operations_struct *ttm_vm_ops = NULL;
 
-static int radeon_ttm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int radeon_ttm_fault(struct vm_fault *vmf)
 {
 	struct ttm_buffer_object *bo;
 	struct radeon_device *rdev;
 	int r;
 
-	bo = (struct ttm_buffer_object *)vma->vm_private_data;	
+	bo = (struct ttm_buffer_object *)vmf->vma->vm_private_data;
 	if (bo == NULL) {
 		return VM_FAULT_NOPAGE;
 	}
 	rdev = radeon_get_rdev(bo->bdev);
 	down_read(&rdev->pm.mclk_lock);
-	r = ttm_vm_ops->fault(vma, vmf);
+	r = ttm_vm_ops->fault(vmf);
 	up_read(&rdev->pm.mclk_lock);
 	return r;
 }
diff -puN drivers/gpu/drm/tegra/gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/tegra/gem.c
--- a/drivers/gpu/drm/tegra/gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/tegra/gem.c
@@ -441,8 +441,9 @@ int tegra_bo_dumb_map_offset(struct drm_
 	return 0;
 }
 
-static int tegra_bo_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int tegra_bo_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_gem_object *gem = vma->vm_private_data;
 	struct tegra_bo *bo = to_tegra_bo(gem);
 	struct page *page;
diff -puN drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/ttm/ttm_bo_vm.c
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -43,7 +43,6 @@
 #define TTM_BO_VM_NUM_PREFAULT 16
 
 static int ttm_bo_vm_fault_idle(struct ttm_buffer_object *bo,
-				struct vm_area_struct *vma,
 				struct vm_fault *vmf)
 {
 	int ret = 0;
@@ -67,7 +66,7 @@ static int ttm_bo_vm_fault_idle(struct t
 			goto out_unlock;
 
 		ttm_bo_reference(bo);
-		up_read(&vma->vm_mm->mmap_sem);
+		up_read(&vmf->vma->vm_mm->mmap_sem);
 		(void) dma_fence_wait(bo->moving, true);
 		ttm_bo_unreserve(bo);
 		ttm_bo_unref(&bo);
@@ -92,8 +91,9 @@ out_unlock:
 	return ret;
 }
 
-static int ttm_bo_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ttm_bo_vm_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct ttm_buffer_object *bo = (struct ttm_buffer_object *)
 	    vma->vm_private_data;
 	struct ttm_bo_device *bdev = bo->bdev;
@@ -124,7 +124,7 @@ static int ttm_bo_vm_fault(struct vm_are
 		if (vmf->flags & FAULT_FLAG_ALLOW_RETRY) {
 			if (!(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
 				ttm_bo_reference(bo);
-				up_read(&vma->vm_mm->mmap_sem);
+				up_read(&vmf->vma->vm_mm->mmap_sem);
 				(void) ttm_bo_wait_unreserved(bo);
 				ttm_bo_unref(&bo);
 			}
@@ -168,7 +168,7 @@ static int ttm_bo_vm_fault(struct vm_are
 	 * Wait for buffer data in transit, due to a pipelined
 	 * move.
 	 */
-	ret = ttm_bo_vm_fault_idle(bo, vma, vmf);
+	ret = ttm_bo_vm_fault_idle(bo, vmf);
 	if (unlikely(ret != 0)) {
 		retval = ret;
 
diff -puN drivers/gpu/drm/udl/udl_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/udl/udl_drv.h
--- a/drivers/gpu/drm/udl/udl_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/udl/udl_drv.h
@@ -134,7 +134,7 @@ void udl_gem_put_pages(struct udl_gem_ob
 int udl_gem_vmap(struct udl_gem_object *obj);
 void udl_gem_vunmap(struct udl_gem_object *obj);
 int udl_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
-int udl_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+int udl_gem_fault(struct vm_fault *vmf);
 
 int udl_handle_damage(struct udl_framebuffer *fb, int x, int y,
 		      int width, int height);
diff -puN drivers/gpu/drm/udl/udl_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/udl/udl_gem.c
--- a/drivers/gpu/drm/udl/udl_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/udl/udl_gem.c
@@ -100,8 +100,9 @@ int udl_drm_gem_mmap(struct file *filp,
 	return ret;
 }
 
-int udl_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int udl_gem_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct udl_gem_object *obj = to_udl_bo(vma->vm_private_data);
 	struct page *page;
 	unsigned int page_offset;
diff -puN drivers/gpu/drm/vgem/vgem_drv.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/vgem/vgem_drv.c
--- a/drivers/gpu/drm/vgem/vgem_drv.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/vgem/vgem_drv.c
@@ -50,8 +50,9 @@ static void vgem_gem_free_object(struct
 	kfree(vgem_obj);
 }
 
-static int vgem_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int vgem_gem_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct drm_vgem_gem_object *obj = vma->vm_private_data;
 	/* We don't use vmf->pgoff since that has the fake offset */
 	unsigned long vaddr = vmf->address;
diff -puN drivers/gpu/drm/virtio/virtgpu_ttm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/gpu/drm/virtio/virtgpu_ttm.c
--- a/drivers/gpu/drm/virtio/virtgpu_ttm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/gpu/drm/virtio/virtgpu_ttm.c
@@ -114,18 +114,17 @@ static void virtio_gpu_ttm_global_fini(s
 static struct vm_operations_struct virtio_gpu_ttm_vm_ops;
 static const struct vm_operations_struct *ttm_vm_ops;
 
-static int virtio_gpu_ttm_fault(struct vm_area_struct *vma,
-				struct vm_fault *vmf)
+static int virtio_gpu_ttm_fault(struct vm_fault *vmf)
 {
 	struct ttm_buffer_object *bo;
 	struct virtio_gpu_device *vgdev;
 	int r;
 
-	bo = (struct ttm_buffer_object *)vma->vm_private_data;
+	bo = (struct ttm_buffer_object *)vmf->vma->vm_private_data;
 	if (bo == NULL)
 		return VM_FAULT_NOPAGE;
 	vgdev = virtio_gpu_get_vgdev(bo->bdev);
-	r = ttm_vm_ops->fault(vma, vmf);
+	r = ttm_vm_ops->fault(vmf);
 	return r;
 }
 #endif
diff -puN drivers/hsi/clients/cmt_speech.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/hsi/clients/cmt_speech.c
--- a/drivers/hsi/clients/cmt_speech.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/hsi/clients/cmt_speech.c
@@ -1098,9 +1098,9 @@ static void cs_hsi_stop(struct cs_hsi_if
 	kfree(hi);
 }
 
-static int cs_char_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int cs_char_vma_fault(struct vm_fault *vmf)
 {
-	struct cs_char *csdata = vma->vm_private_data;
+	struct cs_char *csdata = vmf->vma->vm_private_data;
 	struct page *page;
 
 	page = virt_to_page(csdata->mmap_base);
diff -puN drivers/hwtracing/intel_th/msu.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/hwtracing/intel_th/msu.c
--- a/drivers/hwtracing/intel_th/msu.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/hwtracing/intel_th/msu.c
@@ -1188,9 +1188,9 @@ static void msc_mmap_close(struct vm_are
 	mutex_unlock(&msc->buf_mutex);
 }
 
-static int msc_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int msc_mmap_fault(struct vm_fault *vmf)
 {
-	struct msc_iter *iter = vma->vm_file->private_data;
+	struct msc_iter *iter = vmf->vma->vm_file->private_data;
 	struct msc *msc = iter->msc;
 
 	vmf->page = msc_buffer_get_page(msc, vmf->pgoff);
@@ -1198,7 +1198,7 @@ static int msc_mmap_fault(struct vm_area
 		return VM_FAULT_SIGBUS;
 
 	get_page(vmf->page);
-	vmf->page->mapping = vma->vm_file->f_mapping;
+	vmf->page->mapping = vmf->vma->vm_file->f_mapping;
 	vmf->page->index = vmf->pgoff;
 
 	return 0;
diff -puN drivers/infiniband/hw/hfi1/file_ops.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/infiniband/hw/hfi1/file_ops.c
--- a/drivers/infiniband/hw/hfi1/file_ops.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/infiniband/hw/hfi1/file_ops.c
@@ -92,7 +92,7 @@ static unsigned int poll_next(struct fil
 static int user_event_ack(struct hfi1_ctxtdata *, int, unsigned long);
 static int set_ctxt_pkey(struct hfi1_ctxtdata *, unsigned, u16);
 static int manage_rcvq(struct hfi1_ctxtdata *, unsigned, int);
-static int vma_fault(struct vm_area_struct *, struct vm_fault *);
+static int vma_fault(struct vm_fault *);
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			    unsigned long arg);
 
@@ -695,7 +695,7 @@ done:
  * Local (non-chip) user memory is not mapped right away but as it is
  * accessed by the user-level code.
  */
-static int vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int vma_fault(struct vm_fault *vmf)
 {
 	struct page *page;
 
diff -puN drivers/infiniband/hw/qib/qib_file_ops.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/infiniband/hw/qib/qib_file_ops.c
--- a/drivers/infiniband/hw/qib/qib_file_ops.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -893,7 +893,7 @@ bail:
 /*
  * qib_file_vma_fault - handle a VMA page fault.
  */
-static int qib_file_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int qib_file_vma_fault(struct vm_fault *vmf)
 {
 	struct page *page;
 
diff -puN drivers/media/v4l2-core/videobuf-dma-sg.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/media/v4l2-core/videobuf-dma-sg.c
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -434,8 +434,9 @@ static void videobuf_vm_close(struct vm_
  * now ...).  Bounce buffers don't work very well for the data rates
  * video capture has.
  */
-static int videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int videobuf_vm_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
 
 	dprintk(3, "fault: fault @ %08lx [vma %08lx-%08lx]\n",
diff -puN drivers/misc/cxl/context.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/misc/cxl/context.c
--- a/drivers/misc/cxl/context.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/misc/cxl/context.c
@@ -121,8 +121,9 @@ void cxl_context_set_mapping(struct cxl_
 	mutex_unlock(&ctx->mapping_lock);
 }
 
-static int cxl_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int cxl_mmap_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct cxl_context *ctx = vma->vm_file->private_data;
 	u64 area, offset;
 
diff -puN drivers/misc/sgi-gru/grumain.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -926,8 +926,9 @@ again:
  *
  * 	Note: gru segments alway mmaped on GRU_GSEG_PAGESIZE boundaries.
  */
-int gru_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int gru_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct gru_thread_state *gts;
 	unsigned long paddr, vaddr;
 	unsigned long expires;
diff -puN drivers/misc/sgi-gru/grutables.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -665,7 +665,7 @@ extern unsigned long gru_reserve_cb_reso
 		int cbr_au_count, char *cbmap);
 extern unsigned long gru_reserve_ds_resources(struct gru_state *gru,
 		int dsr_au_count, char *dsmap);
-extern int gru_fault(struct vm_area_struct *, struct vm_fault *vmf);
+extern int gru_fault(struct vm_fault *vmf);
 extern struct gru_mm_struct *gru_register_mmu_notifier(void);
 extern void gru_drop_mmu_notifier(struct gru_mm_struct *gms);
 
diff -puN drivers/scsi/cxlflash/superpipe.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/scsi/cxlflash/superpipe.c
--- a/drivers/scsi/cxlflash/superpipe.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/scsi/cxlflash/superpipe.c
@@ -1053,7 +1053,6 @@ out:
 
 /**
  * cxlflash_mmap_fault() - mmap fault handler for adapter file descriptor
- * @vma:	VM area associated with mapping.
  * @vmf:	VM fault associated with current fault.
  *
  * To support error notification via MMIO, faults are 'caught' by this routine
@@ -1067,8 +1066,9 @@ out:
  *
  * Return: 0 on success, VM_FAULT_SIGBUS on failure
  */
-static int cxlflash_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int cxlflash_mmap_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct file *file = vma->vm_file;
 	struct cxl_context *ctx = cxl_fops_get_context(file);
 	struct cxlflash_cfg *cfg = container_of(file->f_op, struct cxlflash_cfg,
@@ -1097,7 +1097,7 @@ static int cxlflash_mmap_fault(struct vm
 
 	if (likely(!ctxi->err_recovery_active)) {
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-		rc = ctxi->cxl_mmap_vmops->fault(vma, vmf);
+		rc = ctxi->cxl_mmap_vmops->fault(vmf);
 	} else {
 		dev_dbg(dev, "%s: err recovery active, use err_page\n",
 			__func__);
diff -puN drivers/scsi/sg.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/scsi/sg.c
@@ -1185,8 +1185,9 @@ sg_fasync(int fd, struct file *filp, int
 }
 
 static int
-sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+sg_vma_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	Sg_fd *sfp;
 	unsigned long offset, len, sa;
 	Sg_scatter_hold *rsv_schp;
diff -puN drivers/staging/android/ion/ion.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/staging/android/ion/ion.c
--- a/drivers/staging/android/ion/ion.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/staging/android/ion/ion.c
@@ -870,9 +870,9 @@ static void ion_buffer_sync_for_device(s
 	mutex_unlock(&buffer->lock);
 }
 
-static int ion_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ion_vm_fault(struct vm_fault *vmf)
 {
-	struct ion_buffer *buffer = vma->vm_private_data;
+	struct ion_buffer *buffer = vmf->vma->vm_private_data;
 	unsigned long pfn;
 	int ret;
 
@@ -881,7 +881,7 @@ static int ion_vm_fault(struct vm_area_s
 	BUG_ON(!buffer->pages || !buffer->pages[vmf->pgoff]);
 
 	pfn = page_to_pfn(ion_buffer_page(buffer->pages[vmf->pgoff]));
-	ret = vm_insert_pfn(vma, vmf->address, pfn);
+	ret = vm_insert_pfn(vmf->vma, vmf->address, pfn);
 	mutex_unlock(&buffer->lock);
 	if (ret)
 		return VM_FAULT_ERROR;
diff -puN drivers/staging/lustre/lustre/llite/llite_mmap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/staging/lustre/lustre/llite/llite_mmap.c
--- a/drivers/staging/lustre/lustre/llite/llite_mmap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/staging/lustre/lustre/llite/llite_mmap.c
@@ -321,7 +321,7 @@ out:
 	return fault_ret;
 }
 
-static int ll_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ll_fault(struct vm_fault *vmf)
 {
 	int count = 0;
 	bool printed = false;
@@ -335,7 +335,7 @@ static int ll_fault(struct vm_area_struc
 	set = cfs_block_sigsinv(sigmask(SIGKILL) | sigmask(SIGTERM));
 
 restart:
-	result = ll_fault0(vma, vmf);
+	result = ll_fault0(vmf->vma, vmf);
 	LASSERT(!(result & VM_FAULT_LOCKED));
 	if (result == 0) {
 		struct page *vmpage = vmf->page;
@@ -362,8 +362,9 @@ restart:
 	return result;
 }
 
-static int ll_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ll_page_mkwrite(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	int count = 0;
 	bool printed = false;
 	bool retry;
diff -puN drivers/staging/lustre/lustre/llite/vvp_io.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/staging/lustre/lustre/llite/vvp_io.c
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -1014,7 +1014,7 @@ static int vvp_io_kernel_fault(struct vv
 {
 	struct vm_fault *vmf = cfio->ft_vmf;
 
-	cfio->ft_flags = filemap_fault(cfio->ft_vma, vmf);
+	cfio->ft_flags = filemap_fault(vmf);
 	cfio->ft_flags_valid = 1;
 
 	if (vmf->page) {
diff -puN drivers/target/target_core_user.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/target/target_core_user.c
--- a/drivers/target/target_core_user.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/target/target_core_user.c
@@ -783,15 +783,15 @@ static int tcmu_find_mem_index(struct vm
 	return -1;
 }
 
-static int tcmu_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int tcmu_vma_fault(struct vm_fault *vmf)
 {
-	struct tcmu_dev *udev = vma->vm_private_data;
+	struct tcmu_dev *udev = vmf->vma->vm_private_data;
 	struct uio_info *info = &udev->uio_info;
 	struct page *page;
 	unsigned long offset;
 	void *addr;
 
-	int mi = tcmu_find_mem_index(vma);
+	int mi = tcmu_find_mem_index(vmf->vma);
 	if (mi < 0)
 		return VM_FAULT_SIGBUS;
 
diff -puN drivers/uio/uio.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/uio/uio.c
--- a/drivers/uio/uio.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/uio/uio.c
@@ -597,14 +597,14 @@ static int uio_find_mem_index(struct vm_
 	return -1;
 }
 
-static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int uio_vma_fault(struct vm_fault *vmf)
 {
-	struct uio_device *idev = vma->vm_private_data;
+	struct uio_device *idev = vmf->vma->vm_private_data;
 	struct page *page;
 	unsigned long offset;
 	void *addr;
 
-	int mi = uio_find_mem_index(vma);
+	int mi = uio_find_mem_index(vmf->vma);
 	if (mi < 0)
 		return VM_FAULT_SIGBUS;
 
diff -puN drivers/usb/mon/mon_bin.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/usb/mon/mon_bin.c
--- a/drivers/usb/mon/mon_bin.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/usb/mon/mon_bin.c
@@ -1223,9 +1223,9 @@ static void mon_bin_vma_close(struct vm_
 /*
  * Map ring pages to user space.
  */
-static int mon_bin_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int mon_bin_vma_fault(struct vm_fault *vmf)
 {
-	struct mon_reader_bin *rp = vma->vm_private_data;
+	struct mon_reader_bin *rp = vmf->vma->vm_private_data;
 	unsigned long offset, chunk_idx;
 	struct page *pageptr;
 
diff -puN drivers/video/fbdev/core/fb_defio.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/video/fbdev/core/fb_defio.c
--- a/drivers/video/fbdev/core/fb_defio.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -37,12 +37,11 @@ static struct page *fb_deferred_io_page(
 }
 
 /* this is to find and return the vmalloc-ed fb pages */
-static int fb_deferred_io_fault(struct vm_area_struct *vma,
-				struct vm_fault *vmf)
+static int fb_deferred_io_fault(struct vm_fault *vmf)
 {
 	unsigned long offset;
 	struct page *page;
-	struct fb_info *info = vma->vm_private_data;
+	struct fb_info *info = vmf->vma->vm_private_data;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= info->fix.smem_len)
@@ -54,8 +53,8 @@ static int fb_deferred_io_fault(struct v
 
 	get_page(page);
 
-	if (vma->vm_file)
-		page->mapping = vma->vm_file->f_mapping;
+	if (vmf->vma->vm_file)
+		page->mapping = vmf->vma->vm_file->f_mapping;
 	else
 		printk(KERN_ERR "no mapping available\n");
 
@@ -91,11 +90,10 @@ int fb_deferred_io_fsync(struct file *fi
 EXPORT_SYMBOL_GPL(fb_deferred_io_fsync);
 
 /* vm_ops->page_mkwrite handler */
-static int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
-				  struct vm_fault *vmf)
+static int fb_deferred_io_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct fb_info *info = vma->vm_private_data;
+	struct fb_info *info = vmf->vma->vm_private_data;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 	struct page *cur;
 
@@ -105,7 +103,7 @@ static int fb_deferred_io_mkwrite(struct
 	deferred framebuffer IO. then if userspace touches a page
 	again, we repeat the same scheme */
 
-	file_update_time(vma->vm_file);
+	file_update_time(vmf->vma->vm_file);
 
 	/* protect against the workqueue changing the page list */
 	mutex_lock(&fbdefio->lock);
diff -puN drivers/xen/privcmd.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf drivers/xen/privcmd.c
--- a/drivers/xen/privcmd.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/drivers/xen/privcmd.c
@@ -804,10 +804,10 @@ static void privcmd_close(struct vm_area
 	kfree(pages);
 }
 
-static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int privcmd_fault(struct vm_fault *vmf)
 {
 	printk(KERN_DEBUG "privcmd_fault: vma=%p %lx-%lx, pgoff=%lx, uv=%p\n",
-	       vma, vma->vm_start, vma->vm_end,
+	       vmf->vma, vmf->vma->vm_start, vmf->vma->vm_end,
 	       vmf->pgoff, (void *)vmf->address);
 
 	return VM_FAULT_SIGBUS;
diff -puN fs/9p/vfs_file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/9p/vfs_file.c
@@ -534,11 +534,11 @@ v9fs_mmap_file_mmap(struct file *filp, s
 }
 
 static int
-v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+v9fs_vm_page_mkwrite(struct vm_fault *vmf)
 {
 	struct v9fs_inode *v9inode;
 	struct page *page = vmf->page;
-	struct file *filp = vma->vm_file;
+	struct file *filp = vmf->vma->vm_file;
 	struct inode *inode = file_inode(filp);
 
 
diff -puN fs/btrfs/ctree.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/btrfs/ctree.h
@@ -3147,7 +3147,7 @@ int btrfs_create_subvol_root(struct btrf
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio,
 			 unsigned long bio_flags);
-int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
+int btrfs_page_mkwrite(struct vm_fault *vmf);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_evict_inode(struct inode *inode);
 int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc);
diff -puN fs/btrfs/inode.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/btrfs/inode.c
@@ -8964,10 +8964,10 @@ again:
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
  */
-int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+int btrfs_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
@@ -9000,7 +9000,7 @@ int btrfs_page_mkwrite(struct vm_area_st
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
 					   reserved_space);
 	if (!ret) {
-		ret = file_update_time(vma->vm_file);
+		ret = file_update_time(vmf->vma->vm_file);
 		reserved = 1;
 	}
 	if (ret) {
diff -puN fs/ceph/addr.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/ceph/addr.c
--- a/fs/ceph/addr.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/ceph/addr.c
@@ -1386,8 +1386,9 @@ static void ceph_restore_sigs(sigset_t *
 /*
  * vm ops
  */
-static int ceph_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ceph_filemap_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = file_inode(vma->vm_file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_info *fi = vma->vm_file->private_data;
@@ -1416,7 +1417,7 @@ static int ceph_filemap_fault(struct vm_
 	if ((got & (CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO)) ||
 	    ci->i_inline_version == CEPH_INLINE_NONE) {
 		current->journal_info = vma->vm_file;
-		ret = filemap_fault(vma, vmf);
+		ret = filemap_fault(vmf);
 		current->journal_info = NULL;
 	} else
 		ret = -EAGAIN;
@@ -1477,8 +1478,9 @@ out_restore:
 /*
  * Reuse write_begin here for simplicity.
  */
-static int ceph_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ceph_page_mkwrite(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = file_inode(vma->vm_file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_info *fi = vma->vm_file->private_data;
diff -puN fs/cifs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/cifs/file.c
--- a/fs/cifs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/cifs/file.c
@@ -3282,7 +3282,7 @@ cifs_read(struct file *file, char *read_
  * sure that it doesn't change while being written back.
  */
 static int
-cifs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+cifs_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
 
diff -puN fs/dax.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/dax.c
--- a/fs/dax.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/dax.c
@@ -925,12 +925,11 @@ static int dax_insert_mapping(struct add
 
 /**
  * dax_pfn_mkwrite - handle first write to DAX page
- * @vma: The virtual memory area where the fault occurred
  * @vmf: The description of the fault
  */
-int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+int dax_pfn_mkwrite(struct vm_fault *vmf)
 {
-	struct file *file = vma->vm_file;
+	struct file *file = vmf->vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
 	void *entry, **slot;
 	pgoff_t index = vmf->pgoff;
@@ -1121,7 +1120,6 @@ static int dax_fault_return(int error)
 
 /**
  * dax_iomap_fault - handle a page fault on a DAX file
- * @vma: The virtual memory area where the fault occurred
  * @vmf: The description of the fault
  * @ops: iomap ops passed from the file system
  *
@@ -1129,10 +1127,9 @@ static int dax_fault_return(int error)
  * or mkwrite handler for DAX files. Assumes the caller has done all the
  * necessary locking for the page fault to proceed successfully.
  */
-int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
-			const struct iomap_ops *ops)
+int dax_iomap_fault(struct vm_fault *vmf, const struct iomap_ops *ops)
 {
-	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
@@ -1205,11 +1202,11 @@ int dax_iomap_fault(struct vm_area_struc
 	case IOMAP_MAPPED:
 		if (iomap.flags & IOMAP_F_NEW) {
 			count_vm_event(PGMAJFAULT);
-			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+			mem_cgroup_count_vm_event(vmf->vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
 		error = dax_insert_mapping(mapping, iomap.bdev, sector,
-				PAGE_SIZE, &entry, vma, vmf);
+				PAGE_SIZE, &entry, vmf->vma, vmf);
 		/* -EBUSY is fine, somebody else faulted on the same PTE */
 		if (error == -EBUSY)
 			error = 0;
diff -puN fs/ext2/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/ext2/file.c
--- a/fs/ext2/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/ext2/file.c
@@ -87,19 +87,19 @@ out_unlock:
  * The default page_lock and i_size verification done by non-DAX fault paths
  * is sufficient because ext2 doesn't support hole punching.
  */
-static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ext2_dax_fault(struct vm_fault *vmf)
 {
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	int ret;
 
 	if (vmf->flags & FAULT_FLAG_WRITE) {
 		sb_start_pagefault(inode->i_sb);
-		file_update_time(vma->vm_file);
+		file_update_time(vmf->vma->vm_file);
 	}
 	down_read(&ei->dax_sem);
 
-	ret = dax_iomap_fault(vma, vmf, &ext2_iomap_ops);
+	ret = dax_iomap_fault(vmf, &ext2_iomap_ops);
 
 	up_read(&ei->dax_sem);
 	if (vmf->flags & FAULT_FLAG_WRITE)
@@ -107,16 +107,15 @@ static int ext2_dax_fault(struct vm_area
 	return ret;
 }
 
-static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
-		struct vm_fault *vmf)
+static int ext2_dax_pfn_mkwrite(struct vm_fault *vmf)
 {
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	loff_t size;
 	int ret;
 
 	sb_start_pagefault(inode->i_sb);
-	file_update_time(vma->vm_file);
+	file_update_time(vmf->vma->vm_file);
 	down_read(&ei->dax_sem);
 
 	/* check that the faulting page hasn't raced with truncate */
@@ -124,7 +123,7 @@ static int ext2_dax_pfn_mkwrite(struct v
 	if (vmf->pgoff >= size)
 		ret = VM_FAULT_SIGBUS;
 	else
-		ret = dax_pfn_mkwrite(vma, vmf);
+		ret = dax_pfn_mkwrite(vmf);
 
 	up_read(&ei->dax_sem);
 	sb_end_pagefault(inode->i_sb);
diff -puN fs/ext4/ext4.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/ext4/ext4.h
@@ -2483,8 +2483,8 @@ extern int ext4_writepage_trans_blocks(s
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
-extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
-extern int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+extern int ext4_page_mkwrite(struct vm_fault *vmf);
+extern int ext4_filemap_fault(struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
 extern void ext4_da_update_reserve_space(struct inode *inode,
diff -puN fs/ext4/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/ext4/file.c
--- a/fs/ext4/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/ext4/file.c
@@ -253,19 +253,19 @@ out:
 }
 
 #ifdef CONFIG_FS_DAX
-static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ext4_dax_fault(struct vm_fault *vmf)
 {
 	int result;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct super_block *sb = inode->i_sb;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 
 	if (write) {
 		sb_start_pagefault(sb);
-		file_update_time(vma->vm_file);
+		file_update_time(vmf->vma->vm_file);
 	}
 	down_read(&EXT4_I(inode)->i_mmap_sem);
-	result = dax_iomap_fault(vma, vmf, &ext4_iomap_ops);
+	result = dax_iomap_fault(vmf, &ext4_iomap_ops);
 	up_read(&EXT4_I(inode)->i_mmap_sem);
 	if (write)
 		sb_end_pagefault(sb);
@@ -303,22 +303,21 @@ ext4_dax_pmd_fault(struct vm_fault *vmf)
  * wp_pfn_shared() fails. Thus fault gets retried and things work out as
  * desired.
  */
-static int ext4_dax_pfn_mkwrite(struct vm_area_struct *vma,
-				struct vm_fault *vmf)
+static int ext4_dax_pfn_mkwrite(struct vm_fault *vmf)
 {
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct super_block *sb = inode->i_sb;
 	loff_t size;
 	int ret;
 
 	sb_start_pagefault(sb);
-	file_update_time(vma->vm_file);
+	file_update_time(vmf->vma->vm_file);
 	down_read(&EXT4_I(inode)->i_mmap_sem);
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (vmf->pgoff >= size)
 		ret = VM_FAULT_SIGBUS;
 	else
-		ret = dax_pfn_mkwrite(vma, vmf);
+		ret = dax_pfn_mkwrite(vmf);
 	up_read(&EXT4_I(inode)->i_mmap_sem);
 	sb_end_pagefault(sb);
 
diff -puN fs/ext4/inode.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/ext4/inode.c
--- a/fs/ext4/inode.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/ext4/inode.c
@@ -5821,8 +5821,9 @@ static int ext4_bh_unmapped(handle_t *ha
 	return !buffer_mapped(bh);
 }
 
-int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+int ext4_page_mkwrite(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = vmf->page;
 	loff_t size;
 	unsigned long len;
@@ -5912,13 +5913,13 @@ out:
 	return ret;
 }
 
-int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int ext4_filemap_fault(struct vm_fault *vmf)
 {
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	int err;
 
 	down_read(&EXT4_I(inode)->i_mmap_sem);
-	err = filemap_fault(vma, vmf);
+	err = filemap_fault(vmf);
 	up_read(&EXT4_I(inode)->i_mmap_sem);
 
 	return err;
diff -puN fs/f2fs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/f2fs/file.c
--- a/fs/f2fs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/f2fs/file.c
@@ -32,11 +32,10 @@
 #include "trace.h"
 #include <trace/events/f2fs.h>
 
-static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
-						struct vm_fault *vmf)
+static int f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dnode_of_data dn;
 	int err;
@@ -58,7 +57,7 @@ static int f2fs_vm_page_mkwrite(struct v
 
 	f2fs_balance_fs(sbi, dn.node_changed);
 
-	file_update_time(vma->vm_file);
+	file_update_time(vmf->vma->vm_file);
 	lock_page(page);
 	if (unlikely(page->mapping != inode->i_mapping ||
 			page_offset(page) > i_size_read(inode) ||
diff -puN fs/fuse/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/fuse/file.c
--- a/fs/fuse/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/fuse/file.c
@@ -2043,12 +2043,12 @@ static void fuse_vma_close(struct vm_are
  * - sync(2)
  * - try_to_free_pages() with order > PAGE_ALLOC_COSTLY_ORDER
  */
-static int fuse_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int fuse_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 
-	file_update_time(vma->vm_file);
+	file_update_time(vmf->vma->vm_file);
 	lock_page(page);
 	if (page->mapping != inode->i_mapping) {
 		unlock_page(page);
diff -puN fs/gfs2/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/gfs2/file.c
--- a/fs/gfs2/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/gfs2/file.c
@@ -379,10 +379,10 @@ static int gfs2_allocate_page_backing(st
  * blocks allocated on disk to back that page.
  */
 
-static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int gfs2_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_alloc_parms ap = { .aflags = 0, };
@@ -399,7 +399,7 @@ static int gfs2_page_mkwrite(struct vm_a
 	if (ret)
 		goto out;
 
-	gfs2_size_hint(vma->vm_file, pos, PAGE_SIZE);
+	gfs2_size_hint(vmf->vma->vm_file, pos, PAGE_SIZE);
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	ret = gfs2_glock_nq(&gh);
@@ -407,7 +407,7 @@ static int gfs2_page_mkwrite(struct vm_a
 		goto out_uninit;
 
 	/* Update file times before taking page lock */
-	file_update_time(vma->vm_file);
+	file_update_time(vmf->vma->vm_file);
 
 	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
 	set_bit(GIF_SW_PAGED, &ip->i_flags);
diff -puN fs/iomap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/iomap.c
--- a/fs/iomap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/iomap.c
@@ -445,11 +445,10 @@ iomap_page_mkwrite_actor(struct inode *i
 	return length;
 }
 
-int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
-		const struct iomap_ops *ops)
+int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	unsigned long length;
 	loff_t offset, size;
 	ssize_t ret;
diff -puN fs/kernfs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/kernfs/file.c
--- a/fs/kernfs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/kernfs/file.c
@@ -348,9 +348,9 @@ static void kernfs_vma_open(struct vm_ar
 	kernfs_put_active(of->kn);
 }
 
-static int kernfs_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int kernfs_vma_fault(struct vm_fault *vmf)
 {
-	struct file *file = vma->vm_file;
+	struct file *file = vmf->vma->vm_file;
 	struct kernfs_open_file *of = kernfs_of(file);
 	int ret;
 
@@ -362,16 +362,15 @@ static int kernfs_vma_fault(struct vm_ar
 
 	ret = VM_FAULT_SIGBUS;
 	if (of->vm_ops->fault)
-		ret = of->vm_ops->fault(vma, vmf);
+		ret = of->vm_ops->fault(vmf);
 
 	kernfs_put_active(of->kn);
 	return ret;
 }
 
-static int kernfs_vma_page_mkwrite(struct vm_area_struct *vma,
-				   struct vm_fault *vmf)
+static int kernfs_vma_page_mkwrite(struct vm_fault *vmf)
 {
-	struct file *file = vma->vm_file;
+	struct file *file = vmf->vma->vm_file;
 	struct kernfs_open_file *of = kernfs_of(file);
 	int ret;
 
@@ -383,7 +382,7 @@ static int kernfs_vma_page_mkwrite(struc
 
 	ret = 0;
 	if (of->vm_ops->page_mkwrite)
-		ret = of->vm_ops->page_mkwrite(vma, vmf);
+		ret = of->vm_ops->page_mkwrite(vmf);
 	else
 		file_update_time(file);
 
diff -puN fs/ncpfs/mmap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/ncpfs/mmap.c
--- a/fs/ncpfs/mmap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/ncpfs/mmap.c
@@ -27,10 +27,9 @@
  * XXX: how are we excluding truncate/invalidate here? Maybe need to lock
  * page?
  */
-static int ncp_file_mmap_fault(struct vm_area_struct *area,
-					struct vm_fault *vmf)
+static int ncp_file_mmap_fault(struct vm_fault *vmf)
 {
-	struct inode *inode = file_inode(area->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	char *pg_addr;
 	unsigned int already_read;
 	unsigned int count;
@@ -90,7 +89,7 @@ static int ncp_file_mmap_fault(struct vm
 	 * -- nyc
 	 */
 	count_vm_event(PGMAJFAULT);
-	mem_cgroup_count_vm_event(area->vm_mm, PGMAJFAULT);
+	mem_cgroup_count_vm_event(vmf->vma->vm_mm, PGMAJFAULT);
 	return VM_FAULT_MAJOR;
 }
 
diff -puN fs/nfs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/nfs/file.c
--- a/fs/nfs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/nfs/file.c
@@ -528,10 +528,10 @@ const struct address_space_operations nf
  * writable, implying that someone is about to modify the page through a
  * shared-writable mapping
  */
-static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int nfs_vm_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct file *filp = vma->vm_file;
+	struct file *filp = vmf->vma->vm_file;
 	struct inode *inode = file_inode(filp);
 	unsigned pagelen;
 	int ret = VM_FAULT_NOPAGE;
diff -puN fs/nilfs2/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/nilfs2/file.c
@@ -51,8 +51,9 @@ int nilfs_sync_file(struct file *file, l
 	return err;
 }
 
-static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int nilfs_page_mkwrite(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vma->vm_file);
 	struct nilfs_transaction_info ti;
diff -puN fs/ocfs2/mmap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/ocfs2/mmap.c
--- a/fs/ocfs2/mmap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/ocfs2/mmap.c
@@ -44,17 +44,18 @@
 #include "ocfs2_trace.h"
 
 
-static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
+static int ocfs2_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	sigset_t oldset;
 	int ret;
 
 	ocfs2_block_signals(&oldset);
-	ret = filemap_fault(area, vmf);
+	ret = filemap_fault(vmf);
 	ocfs2_unblock_signals(&oldset);
 
-	trace_ocfs2_fault(OCFS2_I(area->vm_file->f_mapping->host)->ip_blkno,
-			  area, vmf->page, vmf->pgoff);
+	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
+			  vma, vmf->page, vmf->pgoff);
 	return ret;
 }
 
@@ -127,10 +128,10 @@ out:
 	return ret;
 }
 
-static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ocfs2_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct buffer_head *di_bh = NULL;
 	sigset_t oldset;
 	int ret;
@@ -160,7 +161,7 @@ static int ocfs2_page_mkwrite(struct vm_
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = __ocfs2_page_mkwrite(vma->vm_file, di_bh, page);
+	ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, page);
 
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
diff -puN fs/proc/vmcore.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/proc/vmcore.c
@@ -265,10 +265,10 @@ static ssize_t read_vmcore(struct file *
  * On s390 the fault handler is used for memory regions that can't be mapped
  * directly with remap_pfn_range().
  */
-static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int mmap_vmcore_fault(struct vm_fault *vmf)
 {
 #ifdef CONFIG_S390
-	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	pgoff_t index = vmf->pgoff;
 	struct page *page;
 	loff_t offset;
diff -puN fs/ubifs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/ubifs/file.c
--- a/fs/ubifs/file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/ubifs/file.c
@@ -1506,11 +1506,10 @@ static int ubifs_releasepage(struct page
  * mmap()d file has taken write protection fault and is being made writable.
  * UBIFS must ensure page is budgeted for.
  */
-static int ubifs_vm_page_mkwrite(struct vm_area_struct *vma,
-				 struct vm_fault *vmf)
+static int ubifs_vm_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct timespec now = ubifs_current_time(inode);
 	struct ubifs_budget_req req = { .new_page = 1 };
diff -puN fs/xfs/xfs_file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/fs/xfs/xfs_file.c
@@ -1379,22 +1379,21 @@ xfs_file_llseek(
  */
 STATIC int
 xfs_filemap_page_mkwrite(
-	struct vm_area_struct	*vma,
 	struct vm_fault		*vmf)
 {
-	struct inode		*inode = file_inode(vma->vm_file);
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	int			ret;
 
 	trace_xfs_filemap_page_mkwrite(XFS_I(inode));
 
 	sb_start_pagefault(inode->i_sb);
-	file_update_time(vma->vm_file);
+	file_update_time(vmf->vma->vm_file);
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (IS_DAX(inode)) {
-		ret = dax_iomap_fault(vma, vmf, &xfs_iomap_ops);
+		ret = dax_iomap_fault(vmf, &xfs_iomap_ops);
 	} else {
-		ret = iomap_page_mkwrite(vma, vmf, &xfs_iomap_ops);
+		ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
 		ret = block_page_mkwrite_return(ret);
 	}
 
@@ -1406,23 +1405,22 @@ xfs_filemap_page_mkwrite(
 
 STATIC int
 xfs_filemap_fault(
-	struct vm_area_struct	*vma,
 	struct vm_fault		*vmf)
 {
-	struct inode		*inode = file_inode(vma->vm_file);
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	int			ret;
 
 	trace_xfs_filemap_fault(XFS_I(inode));
 
 	/* DAX can shortcut the normal fault path on write faults! */
 	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(inode))
-		return xfs_filemap_page_mkwrite(vma, vmf);
+		return xfs_filemap_page_mkwrite(vmf);
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	if (IS_DAX(inode))
-		ret = dax_iomap_fault(vma, vmf, &xfs_iomap_ops);
+		ret = dax_iomap_fault(vmf, &xfs_iomap_ops);
 	else
-		ret = filemap_fault(vma, vmf);
+		ret = filemap_fault(vmf);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	return ret;
@@ -1471,11 +1469,10 @@ xfs_filemap_pmd_fault(
  */
 static int
 xfs_filemap_pfn_mkwrite(
-	struct vm_area_struct	*vma,
 	struct vm_fault		*vmf)
 {
 
-	struct inode		*inode = file_inode(vma->vm_file);
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			ret = VM_FAULT_NOPAGE;
 	loff_t			size;
@@ -1483,7 +1480,7 @@ xfs_filemap_pfn_mkwrite(
 	trace_xfs_filemap_pfn_mkwrite(ip);
 
 	sb_start_pagefault(inode->i_sb);
-	file_update_time(vma->vm_file);
+	file_update_time(vmf->vma->vm_file);
 
 	/* check if the faulting page hasn't raced with truncate */
 	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
@@ -1491,7 +1488,7 @@ xfs_filemap_pfn_mkwrite(
 	if (vmf->pgoff >= size)
 		ret = VM_FAULT_SIGBUS;
 	else if (IS_DAX(inode))
-		ret = dax_pfn_mkwrite(vma, vmf);
+		ret = dax_pfn_mkwrite(vmf);
 	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
diff -puN include/linux/dax.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf include/linux/dax.h
--- a/include/linux/dax.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/include/linux/dax.h
@@ -38,8 +38,7 @@ static inline void *dax_radix_locked_ent
 
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
-int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
-			const struct iomap_ops *ops);
+int dax_iomap_fault(struct vm_fault *vmf, const struct iomap_ops *ops);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
@@ -83,7 +82,7 @@ static inline int dax_iomap_pmd_fault(st
 	return VM_FAULT_FALLBACK;
 }
 #endif
-int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
+int dax_pfn_mkwrite(struct vm_fault *vmf);
 
 static inline bool vma_is_dax(struct vm_area_struct *vma)
 {
diff -puN include/linux/iomap.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf include/linux/iomap.h
--- a/include/linux/iomap.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/include/linux/iomap.h
@@ -79,8 +79,7 @@ int iomap_zero_range(struct inode *inode
 		bool *did_zero, const struct iomap_ops *ops);
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 		const struct iomap_ops *ops);
-int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
-		const struct iomap_ops *ops);
+int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops);
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		loff_t start, loff_t len, const struct iomap_ops *ops);
 
diff -puN include/linux/mm.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf include/linux/mm.h
--- a/include/linux/mm.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/include/linux/mm.h
@@ -350,17 +350,17 @@ struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
 	int (*mremap)(struct vm_area_struct * area);
-	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
+	int (*fault)(struct vm_fault *vmf);
 	int (*pmd_fault)(struct vm_fault *vmf);
 	void (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
-	int (*page_mkwrite)(struct vm_area_struct *vma, struct vm_fault *vmf);
+	int (*page_mkwrite)(struct vm_fault *vmf);
 
 	/* same as page_mkwrite when using VM_PFNMAP|VM_MIXEDMAP */
-	int (*pfn_mkwrite)(struct vm_area_struct *vma, struct vm_fault *vmf);
+	int (*pfn_mkwrite)(struct vm_fault *vmf);
 
 	/* called by access_process_vm when get_user_pages() fails, typically
 	 * for use by special VMAs that can switch between memory and hardware
@@ -2124,10 +2124,10 @@ extern void truncate_inode_pages_range(s
 extern void truncate_inode_pages_final(struct address_space *);
 
 /* generic vm_area_ops exported for stackable file systems */
-extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
+extern int filemap_fault(struct vm_fault *vmf);
 extern void filemap_map_pages(struct vm_fault *vmf,
 		pgoff_t start_pgoff, pgoff_t end_pgoff);
-extern int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
+extern int filemap_page_mkwrite(struct vm_fault *vmf);
 
 /* mm/page-writeback.c */
 int write_one_page(struct page *page, int wait);
diff -puN ipc/shm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf ipc/shm.c
--- a/ipc/shm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/ipc/shm.c
@@ -374,12 +374,12 @@ void exit_shm(struct task_struct *task)
 	up_write(&shm_ids(ns).rwsem);
 }
 
-static int shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int shm_fault(struct vm_fault *vmf)
 {
-	struct file *file = vma->vm_file;
+	struct file *file = vmf->vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
 
-	return sfd->vm_ops->fault(vma, vmf);
+	return sfd->vm_ops->fault(vmf);
 }
 
 #ifdef CONFIG_NUMA
diff -puN kernel/events/core.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf kernel/events/core.c
--- a/kernel/events/core.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/kernel/events/core.c
@@ -4925,9 +4925,9 @@ unlock:
 	rcu_read_unlock();
 }
 
-static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int perf_mmap_fault(struct vm_fault *vmf)
 {
-	struct perf_event *event = vma->vm_file->private_data;
+	struct perf_event *event = vmf->vma->vm_file->private_data;
 	struct ring_buffer *rb;
 	int ret = VM_FAULT_SIGBUS;
 
@@ -4950,7 +4950,7 @@ static int perf_mmap_fault(struct vm_are
 		goto unlock;
 
 	get_page(vmf->page);
-	vmf->page->mapping = vma->vm_file->f_mapping;
+	vmf->page->mapping = vmf->vma->vm_file->f_mapping;
 	vmf->page->index   = vmf->pgoff;
 
 	ret = 0;
diff -puN kernel/relay.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf kernel/relay.c
--- a/kernel/relay.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/kernel/relay.c
@@ -39,10 +39,10 @@ static void relay_file_mmap_close(struct
 /*
  * fault() vm_op implementation for relay file mapping.
  */
-static int relay_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int relay_buf_fault(struct vm_fault *vmf)
 {
 	struct page *page;
-	struct rchan_buf *buf = vma->vm_private_data;
+	struct rchan_buf *buf = vmf->vma->vm_private_data;
 	pgoff_t pgoff = vmf->pgoff;
 
 	if (!buf)
diff -puN mm/filemap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf mm/filemap.c
--- a/mm/filemap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/mm/filemap.c
@@ -2169,7 +2169,6 @@ static void do_async_mmap_readahead(stru
 
 /**
  * filemap_fault - read in file data for page fault handling
- * @vma:	vma in which the fault was taken
  * @vmf:	struct vm_fault containing details of the fault
  *
  * filemap_fault() is invoked via the vma operations vector for a
@@ -2191,10 +2190,10 @@ static void do_async_mmap_readahead(stru
  *
  * We never return with VM_FAULT_RETRY and a bit from VM_FAULT_ERROR set.
  */
-int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int filemap_fault(struct vm_fault *vmf)
 {
 	int error;
-	struct file *file = vma->vm_file;
+	struct file *file = vmf->vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
@@ -2216,12 +2215,12 @@ int filemap_fault(struct vm_area_struct
 		 * We found the page, so try async readahead before
 		 * waiting for the lock.
 		 */
-		do_async_mmap_readahead(vma, ra, file, page, offset);
+		do_async_mmap_readahead(vmf->vma, ra, file, page, offset);
 	} else if (!page) {
 		/* No page in the page cache at all */
-		do_sync_mmap_readahead(vma, ra, file, offset);
+		do_sync_mmap_readahead(vmf->vma, ra, file, offset);
 		count_vm_event(PGMAJFAULT);
-		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+		mem_cgroup_count_vm_event(vmf->vma->vm_mm, PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
 retry_find:
 		page = find_get_page(mapping, offset);
@@ -2229,7 +2228,7 @@ retry_find:
 			goto no_cached_page;
 	}
 
-	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
+	if (!lock_page_or_retry(page, vmf->vma->vm_mm, vmf->flags)) {
 		put_page(page);
 		return ret | VM_FAULT_RETRY;
 	}
@@ -2396,14 +2395,14 @@ next:
 }
 EXPORT_SYMBOL(filemap_map_pages);
 
-int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+int filemap_page_mkwrite(struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
-	struct inode *inode = file_inode(vma->vm_file);
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	int ret = VM_FAULT_LOCKED;
 
 	sb_start_pagefault(inode->i_sb);
-	file_update_time(vma->vm_file);
+	file_update_time(vmf->vma->vm_file);
 	lock_page(page);
 	if (page->mapping != inode->i_mapping) {
 		unlock_page(page);
diff -puN mm/hugetlb.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf mm/hugetlb.c
--- a/mm/hugetlb.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/mm/hugetlb.c
@@ -3142,7 +3142,7 @@ static void hugetlb_vm_op_close(struct v
  * hugegpage VMA.  do_page_fault() is supposed to trap this, so BUG is we get
  * this far.
  */
-static int hugetlb_vm_op_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int hugetlb_vm_op_fault(struct vm_fault *vmf)
 {
 	BUG();
 	return 0;
diff -puN mm/memory.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf mm/memory.c
--- a/mm/memory.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/mm/memory.c
@@ -2035,7 +2035,7 @@ static int do_page_mkwrite(struct vm_fau
 
 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 
-	ret = vmf->vma->vm_ops->page_mkwrite(vmf->vma, vmf);
+	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
 	/* Restore original flags so that caller is not surprised */
 	vmf->flags = old_flags;
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
@@ -2307,7 +2307,7 @@ static int wp_pfn_shared(struct vm_fault
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		vmf->flags |= FAULT_FLAG_MKWRITE;
-		ret = vma->vm_ops->pfn_mkwrite(vma, vmf);
+		ret = vma->vm_ops->pfn_mkwrite(vmf);
 		if (ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))
 			return ret;
 		return finish_mkwrite_fault(vmf);
@@ -2861,7 +2861,7 @@ static int __do_fault(struct vm_fault *v
 	struct vm_area_struct *vma = vmf->vma;
 	int ret;
 
-	ret = vma->vm_ops->fault(vma, vmf);
+	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
 			    VM_FAULT_DONE_COW)))
 		return ret;
diff -puN mm/mmap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf mm/mmap.c
--- a/mm/mmap.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/mm/mmap.c
@@ -3125,8 +3125,7 @@ void vm_stat_account(struct mm_struct *m
 		mm->data_vm += npages;
 }
 
-static int special_mapping_fault(struct vm_area_struct *vma,
-				 struct vm_fault *vmf);
+static int special_mapping_fault(struct vm_fault *vmf);
 
 /*
  * Having a close hook prevents vma merging regardless of flags.
@@ -3161,9 +3160,9 @@ static const struct vm_operations_struct
 	.fault = special_mapping_fault,
 };
 
-static int special_mapping_fault(struct vm_area_struct *vma,
-				struct vm_fault *vmf)
+static int special_mapping_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	pgoff_t pgoff;
 	struct page **pages;
 
@@ -3173,7 +3172,7 @@ static int special_mapping_fault(struct
 		struct vm_special_mapping *sm = vma->vm_private_data;
 
 		if (sm->fault)
-			return sm->fault(sm, vma, vmf);
+			return sm->fault(sm, vmf->vma, vmf);
 
 		pages = sm->pages;
 	}
diff -puN mm/nommu.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf mm/nommu.c
--- a/mm/nommu.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/mm/nommu.c
@@ -1794,7 +1794,7 @@ void unmap_mapping_range(struct address_
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int filemap_fault(struct vm_fault *vmf)
 {
 	BUG();
 	return 0;
diff -puN mm/shmem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf mm/shmem.c
--- a/mm/shmem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/mm/shmem.c
@@ -1908,8 +1908,9 @@ static int synchronous_wake_function(wai
 	return ret;
 }
 
-static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int shmem_fault(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = file_inode(vma->vm_file);
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 	enum sgp_type sgp;
diff -puN security/selinux/selinuxfs.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf security/selinux/selinuxfs.c
--- a/security/selinux/selinuxfs.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/security/selinux/selinuxfs.c
@@ -424,10 +424,9 @@ out:
 	return ret;
 }
 
-static int sel_mmap_policy_fault(struct vm_area_struct *vma,
-				 struct vm_fault *vmf)
+static int sel_mmap_policy_fault(struct vm_fault *vmf)
 {
-	struct policy_load_memory *plm = vma->vm_file->private_data;
+	struct policy_load_memory *plm = vmf->vma->vm_file->private_data;
 	unsigned long offset;
 	struct page *page;
 
diff -puN sound/core/pcm_native.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/sound/core/pcm_native.c
@@ -3245,10 +3245,9 @@ static unsigned int snd_pcm_capture_poll
 /*
  * mmap status record
  */
-static int snd_pcm_mmap_status_fault(struct vm_area_struct *area,
-						struct vm_fault *vmf)
+static int snd_pcm_mmap_status_fault(struct vm_fault *vmf)
 {
-	struct snd_pcm_substream *substream = area->vm_private_data;
+	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
 	struct snd_pcm_runtime *runtime;
 	
 	if (substream == NULL)
@@ -3282,10 +3281,9 @@ static int snd_pcm_mmap_status(struct sn
 /*
  * mmap control record
  */
-static int snd_pcm_mmap_control_fault(struct vm_area_struct *area,
-						struct vm_fault *vmf)
+static int snd_pcm_mmap_control_fault(struct vm_fault *vmf)
 {
-	struct snd_pcm_substream *substream = area->vm_private_data;
+	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
 	struct snd_pcm_runtime *runtime;
 	
 	if (substream == NULL)
@@ -3341,10 +3339,9 @@ snd_pcm_default_page_ops(struct snd_pcm_
 /*
  * fault callback for mmapping a RAM page
  */
-static int snd_pcm_mmap_data_fault(struct vm_area_struct *area,
-						struct vm_fault *vmf)
+static int snd_pcm_mmap_data_fault(struct vm_fault *vmf)
 {
-	struct snd_pcm_substream *substream = area->vm_private_data;
+	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
 	struct snd_pcm_runtime *runtime;
 	unsigned long offset;
 	struct page * page;
diff -puN sound/usb/usx2y/us122l.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf sound/usb/usx2y/us122l.c
--- a/sound/usb/usx2y/us122l.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/sound/usb/usx2y/us122l.c
@@ -137,13 +137,12 @@ static void usb_stream_hwdep_vm_open(str
 	snd_printdd(KERN_DEBUG "%i\n", atomic_read(&us122l->mmap_count));
 }
 
-static int usb_stream_hwdep_vm_fault(struct vm_area_struct *area,
-				     struct vm_fault *vmf)
+static int usb_stream_hwdep_vm_fault(struct vm_fault *vmf)
 {
 	unsigned long offset;
 	struct page *page;
 	void *vaddr;
-	struct us122l *us122l = area->vm_private_data;
+	struct us122l *us122l = vmf->vma->vm_private_data;
 	struct usb_stream *s;
 
 	mutex_lock(&us122l->mutex);
diff -puN sound/usb/usx2y/usX2Yhwdep.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf sound/usb/usx2y/usX2Yhwdep.c
--- a/sound/usb/usx2y/usX2Yhwdep.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/sound/usb/usx2y/usX2Yhwdep.c
@@ -31,19 +31,18 @@
 #include "usbusx2y.h"
 #include "usX2Yhwdep.h"
 
-static int snd_us428ctls_vm_fault(struct vm_area_struct *area,
-				  struct vm_fault *vmf)
+static int snd_us428ctls_vm_fault(struct vm_fault *vmf)
 {
 	unsigned long offset;
 	struct page * page;
 	void *vaddr;
 
 	snd_printdd("ENTER, start %lXh, pgoff %ld\n",
-		   area->vm_start,
+		   vmf->vma->vm_start,
 		   vmf->pgoff);
 	
 	offset = vmf->pgoff << PAGE_SHIFT;
-	vaddr = (char*)((struct usX2Ydev *)area->vm_private_data)->us428ctls_sharedmem + offset;
+	vaddr = (char *)((struct usX2Ydev *)vmf->vma->vm_private_data)->us428ctls_sharedmem + offset;
 	page = virt_to_page(vaddr);
 	get_page(page);
 	vmf->page = page;
diff -puN sound/usb/usx2y/usx2yhwdeppcm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf sound/usb/usx2y/usx2yhwdeppcm.c
--- a/sound/usb/usx2y/usx2yhwdeppcm.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -652,14 +652,13 @@ static void snd_usX2Y_hwdep_pcm_vm_close
 }
 
 
-static int snd_usX2Y_hwdep_pcm_vm_fault(struct vm_area_struct *area,
-					struct vm_fault *vmf)
+static int snd_usX2Y_hwdep_pcm_vm_fault(struct vm_fault *vmf)
 {
 	unsigned long offset;
 	void *vaddr;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
-	vaddr = (char*)((struct usX2Ydev *)area->vm_private_data)->hwdep_pcm_shm + offset;
+	vaddr = (char *)((struct usX2Ydev *)vmf->vma->vm_private_data)->hwdep_pcm_shm + offset;
 	vmf->page = virt_to_page(vaddr);
 	get_page(vmf->page);
 	return 0;
diff -puN virt/kvm/kvm_main.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf
+++ a/virt/kvm/kvm_main.c
@@ -2350,9 +2350,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *m
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 
-static int kvm_vcpu_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int kvm_vcpu_fault(struct vm_fault *vmf)
 {
-	struct kvm_vcpu *vcpu = vma->vm_file->private_data;
+	struct kvm_vcpu *vcpu = vmf->vma->vm_file->private_data;
 	struct page *page;
 
 	if (vmf->pgoff == 0)
_

Patches currently in -mm which might be from dave.jiang@intel.com are


