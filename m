From: akpm@linux-foundation.org
Subject: + mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch added to -mm tree
Date: Wed, 01 Aug 2012 15:29:11 -0700
Message-ID: <20120801222912.3AE041E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:59553 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2HAW3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 18:29:14 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5494219obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 15:29:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, suresh.b.siddha@intel.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm: kill vma flag VM_RESERVED and mm->reserved_vm counter
has been added to the -mm tree.  Its filename is
     mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: kill vma flag VM_RESERVED and mm->reserved_vm counter

A long time ago, in v2.4, VM_RESERVED kept swapout process off VMA,
currently it lost original meaning but still has some effects:

 | effect                 | alternative flags
-+------------------------+---------------------------------------------
1| account as reserved_vm | VM_IO
2| skip in core dump      | VM_IO, VM_DONTDUMP
3| do not merge or expand | VM_IO, VM_DONTEXPAND, VM_HUGETLB, VM_PFNMAP
4| do not mlock           | VM_IO, VM_DONTEXPAND, VM_HUGETLB, VM_PFNMAP

This patch removes reserved_vm counter from mm_struct.  Seems like nobody
cares about it, it does not exported into userspace directly, it only
reduces total_vm showed in proc.

Thus VM_RESERVED can be replaced with VM_IO or pair VM_DONTEXPAND | VM_DONTDUMP.

remap_pfn_range() and io_remap_pfn_range() set VM_IO|VM_DONTEXPAND|VM_DONTDUMP.
remap_vmalloc_range() set VM_DONTEXPAND | VM_DONTDUMP.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Venkatesh Pallipadi <venki@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt             |    4 ++--
 arch/alpha/kernel/pci-sysfs.c                    |    2 +-
 arch/ia64/kernel/perfmon.c                       |    2 +-
 arch/ia64/mm/init.c                              |    3 ++-
 arch/powerpc/kvm/book3s_hv.c                     |    2 +-
 arch/sparc/kernel/pci.c                          |    2 +-
 arch/unicore32/kernel/process.c                  |    2 +-
 arch/x86/xen/mmu.c                               |    3 +--
 drivers/char/mbcs.c                              |    2 +-
 drivers/char/mem.c                               |    2 +-
 drivers/char/mspec.c                             |    2 +-
 drivers/gpu/drm/drm_gem.c                        |    2 +-
 drivers/gpu/drm/drm_vm.c                         |   10 ++--------
 drivers/gpu/drm/exynos/exynos_drm_gem.c          |    2 +-
 drivers/gpu/drm/gma500/framebuffer.c             |    3 +--
 drivers/gpu/drm/ttm/ttm_bo_vm.c                  |    4 ++--
 drivers/gpu/drm/udl/udl_fb.c                     |    2 +-
 drivers/infiniband/hw/ehca/ehca_uverbs.c         |    4 ++--
 drivers/infiniband/hw/ipath/ipath_file_ops.c     |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c         |    2 +-
 drivers/media/video/meye.c                       |    2 +-
 drivers/media/video/omap/omap_vout.c             |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c       |    3 +--
 drivers/media/video/usbvision/usbvision-video.c  |    3 +--
 drivers/media/video/videobuf-dma-sg.c            |    2 +-
 drivers/media/video/videobuf-vmalloc.c           |    2 +-
 drivers/media/video/videobuf2-memops.c           |    2 +-
 drivers/media/video/vino.c                       |    2 +-
 drivers/misc/carma/carma-fpga.c                  |    2 --
 drivers/misc/sgi-gru/grufile.c                   |    5 ++---
 drivers/mtd/mtdchar.c                            |    2 +-
 drivers/scsi/sg.c                                |    2 +-
 drivers/staging/media/easycap/easycap_main.c     |    2 +-
 drivers/staging/omapdrm/omap_gem_dmabuf.c        |    2 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    2 +-
 drivers/uio/uio.c                                |    4 +---
 drivers/usb/mon/mon_bin.c                        |    2 +-
 drivers/video/68328fb.c                          |    2 +-
 drivers/video/aty/atyfb_base.c                   |    3 +--
 drivers/video/fb-puv3.c                          |    3 +--
 drivers/video/fb_defio.c                         |    2 +-
 drivers/video/fbmem.c                            |    3 +--
 drivers/video/gbefb.c                            |    2 +-
 drivers/video/omap2/omapfb/omapfb-main.c         |    2 +-
 drivers/video/sbuslib.c                          |    5 ++---
 drivers/video/smscufx.c                          |    1 -
 drivers/video/udlfb.c                            |    1 -
 drivers/video/vermilion/vermilion.c              |    1 -
 drivers/video/vfb.c                              |    1 -
 drivers/xen/gntalloc.c                           |    2 +-
 drivers/xen/gntdev.c                             |    2 +-
 drivers/xen/privcmd.c                            |    3 ++-
 fs/binfmt_elf.c                                  |    2 +-
 fs/binfmt_elf_fdpic.c                            |    2 +-
 fs/hugetlbfs/inode.c                             |    2 +-
 fs/proc/task_mmu.c                               |    2 +-
 include/linux/mempolicy.h                        |    2 +-
 include/linux/mm.h                               |    3 +--
 include/linux/mm_types.h                         |    1 -
 kernel/events/core.c                             |    2 +-
 mm/ksm.c                                         |    3 +--
 mm/memory.c                                      |   11 +++++------
 mm/mlock.c                                       |    2 +-
 mm/mmap.c                                        |    2 --
 mm/nommu.c                                       |    2 +-
 mm/vmalloc.c                                     |    3 +--
 security/selinux/selinuxfs.c                     |    2 +-
 sound/core/pcm_native.c                          |    6 +++---
 sound/usb/usx2y/us122l.c                         |    2 +-
 sound/usb/usx2y/usX2Yhwdep.c                     |    2 +-
 sound/usb/usx2y/usx2yhwdeppcm.c                  |    2 +-
 71 files changed, 78 insertions(+), 106 deletions(-)

diff -puN Documentation/vm/unevictable-lru.txt~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/Documentation/vm/unevictable-lru.txt
@@ -371,8 +371,8 @@ mlock_fixup() filters several classes of
    mlock_fixup() will call make_pages_present() in the hugetlbfs VMA range to
    allocate the huge pages and populate the ptes.
 
-3) VMAs with VM_DONTEXPAND or VM_RESERVED are generally userspace mappings of
-   kernel pages, such as the VDSO page, relay channel pages, etc.  These pages
+3) VMAs with VM_DONTEXPAND are generally userspace mappings of kernel pages,
+   such as the VDSO page, relay channel pages, etc. These pages
    are inherently unevictable and are not managed on the LRU lists.
    mlock_fixup() treats these VMAs the same as hugetlbfs VMAs.  It calls
    make_pages_present() to populate the ptes.
diff -puN arch/alpha/kernel/pci-sysfs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter arch/alpha/kernel/pci-sysfs.c
--- a/arch/alpha/kernel/pci-sysfs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/arch/alpha/kernel/pci-sysfs.c
@@ -26,7 +26,7 @@ static int hose_mmap_page_range(struct p
 		base = sparse ? hose->sparse_io_base : hose->dense_io_base;
 
 	vma->vm_pgoff += base >> PAGE_SHIFT;
-	vma->vm_flags |= (VM_IO | VM_RESERVED);
+	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 
 	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 				  vma->vm_end - vma->vm_start,
diff -puN arch/ia64/kernel/perfmon.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/arch/ia64/kernel/perfmon.c
@@ -2307,7 +2307,7 @@ pfm_smpl_buffer_alloc(struct task_struct
 	 */
 	vma->vm_mm	     = mm;
 	vma->vm_file	     = filp;
-	vma->vm_flags	     = VM_READ| VM_MAYREAD |VM_RESERVED;
+	vma->vm_flags	     = VM_READ | VM_MAYREAD | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_page_prot    = PAGE_READONLY; /* XXX may need to change */
 
 	/*
diff -puN arch/ia64/mm/init.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/arch/ia64/mm/init.c
@@ -138,7 +138,8 @@ ia64_init_addr_space (void)
 			vma->vm_mm = current->mm;
 			vma->vm_end = PAGE_SIZE;
 			vma->vm_page_prot = __pgprot(pgprot_val(PAGE_READONLY) | _PAGE_MA_NAT);
-			vma->vm_flags = VM_READ | VM_MAYREAD | VM_IO | VM_RESERVED;
+			vma->vm_flags = VM_READ | VM_MAYREAD | VM_IO |
+					VM_DONTEXPAND | VM_DONTDUMP;
 			down_write(&current->mm->mmap_sem);
 			if (insert_vm_struct(current->mm, vma)) {
 				up_write(&current->mm->mmap_sem);
diff -puN arch/powerpc/kvm/book3s_hv.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter arch/powerpc/kvm/book3s_hv.c
--- a/arch/powerpc/kvm/book3s_hv.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/arch/powerpc/kvm/book3s_hv.c
@@ -1183,7 +1183,7 @@ static const struct vm_operations_struct
 
 static int kvm_rma_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &kvm_rma_vm_ops;
 	return 0;
 }
diff -puN arch/sparc/kernel/pci.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter arch/sparc/kernel/pci.c
--- a/arch/sparc/kernel/pci.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/arch/sparc/kernel/pci.c
@@ -783,7 +783,7 @@ static int __pci_mmap_make_offset(struct
 static void __pci_mmap_set_flags(struct pci_dev *dev, struct vm_area_struct *vma,
 					    enum pci_mmap_state mmap_state)
 {
-	vma->vm_flags |= (VM_IO | VM_RESERVED);
+	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 }
 
 /* Set vm_page_prot of VMA, as appropriate for this architecture, for a pci
diff -puN arch/unicore32/kernel/process.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter arch/unicore32/kernel/process.c
--- a/arch/unicore32/kernel/process.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/arch/unicore32/kernel/process.c
@@ -380,7 +380,7 @@ int vectors_user_mapping(void)
 	return install_special_mapping(mm, 0xffff0000, PAGE_SIZE,
 				       VM_READ | VM_EXEC |
 				       VM_MAYREAD | VM_MAYEXEC |
-				       VM_RESERVED,
+				       VM_DONTEXPAND | VM_DONTDUMP,
 				       NULL);
 }
 
diff -puN arch/x86/xen/mmu.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/arch/x86/xen/mmu.c
@@ -2339,8 +2339,7 @@ int xen_remap_domain_mfn_range(struct vm
 
 	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
 
-	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_RESERVED | VM_IO)) ==
-				(VM_PFNMAP | VM_RESERVED | VM_IO)));
+	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_IO)) == (VM_PFNMAP | VM_IO)));
 
 	rmd.mfn = mfn;
 	rmd.prot = prot;
diff -puN drivers/char/mbcs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/char/mbcs.c
--- a/drivers/char/mbcs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/char/mbcs.c
@@ -507,7 +507,7 @@ static int mbcs_gscr_mmap(struct file *f
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
-	/* Remap-pfn-range will mark the range VM_IO and VM_RESERVED */
+	/* Remap-pfn-range will mark the range VM_IO */
 	if (remap_pfn_range(vma,
 			    vma->vm_start,
 			    __pa(soft->gscr_addr) >> PAGE_SHIFT,
diff -puN drivers/char/mem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/char/mem.c
--- a/drivers/char/mem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/char/mem.c
@@ -322,7 +322,7 @@ static int mmap_mem(struct file *file, s
 
 	vma->vm_ops = &mmap_mem_ops;
 
-	/* Remap-pfn-range will mark the range VM_IO and VM_RESERVED */
+	/* Remap-pfn-range will mark the range VM_IO */
 	if (remap_pfn_range(vma,
 			    vma->vm_start,
 			    vma->vm_pgoff,
diff -puN drivers/char/mspec.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/char/mspec.c
--- a/drivers/char/mspec.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/char/mspec.c
@@ -286,7 +286,7 @@ mspec_mmap(struct file *file, struct vm_
 	atomic_set(&vdata->refcnt, 1);
 	vma->vm_private_data = vdata;
 
-	vma->vm_flags |= (VM_IO | VM_RESERVED | VM_PFNMAP | VM_DONTEXPAND);
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	if (vdata->type == MSPEC_FETCHOP || vdata->type == MSPEC_UNCACHED)
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_ops = &mspec_vm_ops;
diff -puN drivers/gpu/drm/drm_gem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/gpu/drm/drm_gem.c
@@ -706,7 +706,7 @@ int drm_gem_mmap(struct file *filp, stru
 		goto out_unlock;
 	}
 
-	vma->vm_flags |= VM_RESERVED | VM_IO | VM_PFNMAP | VM_DONTEXPAND;
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = obj->dev->driver->gem_vm_ops;
 	vma->vm_private_data = map->handle;
 	vma->vm_page_prot =  pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
diff -puN drivers/gpu/drm/drm_vm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/gpu/drm/drm_vm.c
@@ -514,8 +514,7 @@ static int drm_mmap_dma(struct file *fil
 
 	vma->vm_ops = &drm_vm_dma_ops;
 
-	vma->vm_flags |= VM_RESERVED;	/* Don't swap */
-	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 
 	drm_vm_open_locked(dev, vma);
 	return 0;
@@ -652,21 +651,16 @@ int drm_mmap_locked(struct file *filp, s
 	case _DRM_SHM:
 		vma->vm_ops = &drm_vm_shm_ops;
 		vma->vm_private_data = (void *)map;
-		/* Don't let this area swap.  Change when
-		   DRM_KERNEL advisory is supported. */
-		vma->vm_flags |= VM_RESERVED;
 		break;
 	case _DRM_SCATTER_GATHER:
 		vma->vm_ops = &drm_vm_sg_ops;
 		vma->vm_private_data = (void *)map;
-		vma->vm_flags |= VM_RESERVED;
 		vma->vm_page_prot = drm_dma_prot(map->type, vma);
 		break;
 	default:
 		return -EINVAL;	/* This should never happen. */
 	}
-	vma->vm_flags |= VM_RESERVED;	/* Don't swap */
-	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 
 	drm_vm_open_locked(dev, vma);
 	return 0;
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -501,7 +501,7 @@ static int exynos_drm_gem_mmap_buffer(st
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	vma->vm_flags |= (VM_IO | VM_RESERVED);
+	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 
 	update_vm_cache_attr(exynos_gem_obj, vma);
 
diff -puN drivers/gpu/drm/gma500/framebuffer.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/gpu/drm/gma500/framebuffer.c
--- a/drivers/gpu/drm/gma500/framebuffer.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/gpu/drm/gma500/framebuffer.c
@@ -178,8 +178,7 @@ static int psbfb_mmap(struct fb_info *in
 	 */
 	vma->vm_ops = &psbfb_vm_ops;
 	vma->vm_private_data = (void *)psbfb;
-	vma->vm_flags |= VM_RESERVED | VM_IO |
-					VM_MIXEDMAP | VM_DONTEXPAND;
+	vma->vm_flags |= VM_IO | VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	return 0;
 }
 
diff -puN drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/gpu/drm/ttm/ttm_bo_vm.c
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -285,7 +285,7 @@ int ttm_bo_mmap(struct file *filp, struc
 	 */
 
 	vma->vm_private_data = bo;
-	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
+	vma->vm_flags |= VM_IO | VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	return 0;
 out_unref:
 	ttm_bo_unref(&bo);
@@ -300,7 +300,7 @@ int ttm_fbdev_mmap(struct vm_area_struct
 
 	vma->vm_ops = &ttm_bo_vm_ops;
 	vma->vm_private_data = ttm_bo_reference(bo);
-	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
+	vma->vm_flags |= VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
 	return 0;
 }
 EXPORT_SYMBOL(ttm_fbdev_mmap);
diff -puN drivers/gpu/drm/udl/udl_fb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/gpu/drm/udl/udl_fb.c
--- a/drivers/gpu/drm/udl/udl_fb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/gpu/drm/udl/udl_fb.c
@@ -243,7 +243,7 @@ static int udl_fb_mmap(struct fb_info *i
 			size = 0;
 	}
 
-	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
+	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 	return 0;
 }
 
diff -puN drivers/infiniband/hw/ehca/ehca_uverbs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/infiniband/hw/ehca/ehca_uverbs.c
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -117,7 +117,7 @@ static int ehca_mmap_fw(struct vm_area_s
 	physical = galpas->user.fw_handle;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	ehca_gen_dbg("vsize=%llx physical=%llx", vsize, physical);
-	/* VM_IO | VM_RESERVED are set by remap_pfn_range() */
+	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 	ret = remap_4k_pfn(vma, vma->vm_start, physical >> EHCA_PAGESHIFT,
 			   vma->vm_page_prot);
 	if (unlikely(ret)) {
@@ -139,7 +139,7 @@ static int ehca_mmap_queue(struct vm_are
 	u64 start, ofs;
 	struct page *page;
 
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	start = vma->vm_start;
 	for (ofs = 0; ofs < queue->queue_length; ofs += PAGE_SIZE) {
 		u64 virt_addr = (u64)ipz_qeit_calc(queue, ofs);
diff -puN drivers/infiniband/hw/ipath/ipath_file_ops.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1225,7 +1225,7 @@ static int mmap_kvaddr(struct vm_area_st
 
 	vma->vm_pgoff = (unsigned long) addr >> PAGE_SHIFT;
 	vma->vm_ops = &ipath_file_vm_ops;
-	vma->vm_flags |= VM_RESERVED | VM_DONTEXPAND;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	ret = 1;
 
 bail:
diff -puN drivers/infiniband/hw/qib/qib_file_ops.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/infiniband/hw/qib/qib_file_ops.c
--- a/drivers/infiniband/hw/qib/qib_file_ops.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -971,7 +971,7 @@ static int mmap_kvaddr(struct vm_area_st
 
 	vma->vm_pgoff = (unsigned long) addr >> PAGE_SHIFT;
 	vma->vm_ops = &qib_file_vm_ops;
-	vma->vm_flags |= VM_RESERVED | VM_DONTEXPAND;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	ret = 1;
 
 bail:
diff -puN drivers/media/video/meye.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/media/video/meye.c
--- a/drivers/media/video/meye.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/media/video/meye.c
@@ -1647,7 +1647,7 @@ static int meye_mmap(struct file *file, 
 
 	vma->vm_ops = &meye_vm_ops;
 	vma->vm_flags &= ~VM_IO;	/* not I/O memory */
-	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = (void *) (offset / gbufsize);
 	meye_vm_open(vma);
 
diff -puN drivers/media/video/omap/omap_vout.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/media/video/omap/omap_vout.c
--- a/drivers/media/video/omap/omap_vout.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/media/video/omap/omap_vout.c
@@ -910,7 +910,7 @@ static int omap_vout_mmap(struct file *f
 
 	q->bufs[i]->baddr = vma->vm_start;
 
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	vma->vm_ops = &omap_vout_vm_ops;
 	vma->vm_private_data = (void *) vout;
diff -puN drivers/media/video/sn9c102/sn9c102_core.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/media/video/sn9c102/sn9c102_core.c
--- a/drivers/media/video/sn9c102/sn9c102_core.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/media/video/sn9c102/sn9c102_core.c
@@ -2126,8 +2126,7 @@ static int sn9c102_mmap(struct file* fil
 		return -EINVAL;
 	}
 
-	vma->vm_flags |= VM_IO;
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 
 	pos = cam->frame[i].bufmem;
 	while (size > 0) { /* size is page-aligned */
diff -puN drivers/media/video/usbvision/usbvision-video.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -1090,8 +1090,7 @@ static int usbvision_v4l2_mmap(struct fi
 	}
 
 	/* VM_IO is eventually going to replace PageReserved altogether */
-	vma->vm_flags |= VM_IO;
-	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
+	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 
 	pos = usbvision->frame[i].data;
 	while (size > 0) {
diff -puN drivers/media/video/videobuf-dma-sg.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/media/video/videobuf-dma-sg.c
--- a/drivers/media/video/videobuf-dma-sg.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/media/video/videobuf-dma-sg.c
@@ -582,7 +582,7 @@ static int __videobuf_mmap_mapper(struct
 	map->count    = 1;
 	map->q        = q;
 	vma->vm_ops   = &videobuf_vm_ops;
-	vma->vm_flags |= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_flags &= ~VM_IO; /* using shared anonymous pages */
 	vma->vm_private_data = map;
 	dprintk(1, "mmap %p: q=%p %08lx-%08lx pgoff %08lx bufs %d-%d\n",
diff -puN drivers/media/video/videobuf-vmalloc.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/media/video/videobuf-vmalloc.c
--- a/drivers/media/video/videobuf-vmalloc.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/media/video/videobuf-vmalloc.c
@@ -270,7 +270,7 @@ static int __videobuf_mmap_mapper(struct
 	}
 
 	vma->vm_ops          = &videobuf_vm_ops;
-	vma->vm_flags       |= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_flags       |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = map;
 
 	dprintk(1, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
diff -puN drivers/media/video/videobuf2-memops.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/media/video/videobuf2-memops.c
--- a/drivers/media/video/videobuf2-memops.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/media/video/videobuf2-memops.c
@@ -163,7 +163,7 @@ int vb2_mmap_pfn_range(struct vm_area_st
 		return ret;
 	}
 
-	vma->vm_flags		|= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_flags		|= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data	= priv;
 	vma->vm_ops		= vm_ops;
 
diff -puN drivers/media/video/vino.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/media/video/vino.c
--- a/drivers/media/video/vino.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/media/video/vino.c
@@ -3950,7 +3950,7 @@ found:
 
 	fb->map_count = 1;
 
-	vma->vm_flags |= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_flags &= ~VM_IO;
 	vma->vm_private_data = fb;
 	vma->vm_file = file;
diff -puN drivers/misc/carma/carma-fpga.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/misc/carma/carma-fpga.c
--- a/drivers/misc/carma/carma-fpga.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/misc/carma/carma-fpga.c
@@ -1243,8 +1243,6 @@ static int data_mmap(struct file *filp, 
 		return -EINVAL;
 	}
 
-	/* IO memory (stop cacheing) */
-	vma->vm_flags |= VM_IO | VM_RESERVED;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	return io_remap_pfn_range(vma, vma->vm_start, addr, vsize,
diff -puN drivers/misc/sgi-gru/grufile.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -108,9 +108,8 @@ static int gru_file_mmap(struct file *fi
 				vma->vm_end & (GRU_GSEG_PAGESIZE - 1))
 		return -EINVAL;
 
-	vma->vm_flags |=
-	    (VM_IO | VM_DONTCOPY | VM_LOCKED | VM_DONTEXPAND | VM_PFNMAP |
-			VM_RESERVED);
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_LOCKED |
+			 VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_page_prot = PAGE_SHARED;
 	vma->vm_ops = &gru_vm_ops;
 
diff -puN drivers/mtd/mtdchar.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/mtd/mtdchar.c
@@ -1146,7 +1146,7 @@ static int mtdchar_mmap(struct file *fil
 
 		off += start;
 		vma->vm_pgoff = off >> PAGE_SHIFT;
-		vma->vm_flags |= VM_IO | VM_RESERVED;
+		vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 
 #ifdef pgprot_noncached
 		if (file->f_flags & O_DSYNC || off >= __pa(high_memory))
diff -puN drivers/scsi/sg.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/scsi/sg.c
@@ -1257,7 +1257,7 @@ sg_mmap(struct file *filp, struct vm_are
 	}
 
 	sfp->mmap_called = 1;
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = sfp;
 	vma->vm_ops = &sg_mmap_vm_ops;
 	return 0;
diff -puN drivers/staging/media/easycap/easycap_main.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/staging/media/easycap/easycap_main.c
--- a/drivers/staging/media/easycap/easycap_main.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/staging/media/easycap/easycap_main.c
@@ -2246,7 +2246,7 @@ static int easycap_mmap(struct file *fil
 	JOT(8, "\n");
 
 	pvma->vm_ops = &easycap_vm_ops;
-	pvma->vm_flags |= VM_RESERVED;
+	pvma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	if (file)
 		pvma->vm_private_data = file->private_data;
 	easycap_vma_open(pvma);
diff -puN drivers/staging/omapdrm/omap_gem_dmabuf.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/staging/omapdrm/omap_gem_dmabuf.c
--- a/drivers/staging/omapdrm/omap_gem_dmabuf.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/staging/omapdrm/omap_gem_dmabuf.c
@@ -160,7 +160,7 @@ static int omap_gem_dmabuf_mmap(struct d
 		goto out_unlock;
 	}
 
-	vma->vm_flags |= VM_RESERVED | VM_IO | VM_PFNMAP | VM_DONTEXPAND;
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = obj->dev->driver->gem_vm_ops;
 	vma->vm_private_data = obj;
 	vma->vm_page_prot =  pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
diff -puN drivers/staging/tidspbridge/rmgr/drv_interface.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/staging/tidspbridge/rmgr/drv_interface.c
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -261,7 +261,7 @@ static int bridge_mmap(struct file *filp
 {
 	u32 status;
 
-	vma->vm_flags |= VM_RESERVED | VM_IO;
+	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	dev_dbg(bridge, "%s: vm filp %p start %lx end %lx page_prot %ulx "
diff -puN drivers/uio/uio.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/uio/uio.c
--- a/drivers/uio/uio.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/uio/uio.c
@@ -653,8 +653,6 @@ static int uio_mmap_physical(struct vm_a
 	if (mi < 0)
 		return -EINVAL;
 
-	vma->vm_flags |= VM_IO | VM_RESERVED;
-
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	return remap_pfn_range(vma,
@@ -666,7 +664,7 @@ static int uio_mmap_physical(struct vm_a
 
 static int uio_mmap_logical(struct vm_area_struct *vma)
 {
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &uio_vm_ops;
 	uio_vma_open(vma);
 	return 0;
diff -puN drivers/usb/mon/mon_bin.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/usb/mon/mon_bin.c
--- a/drivers/usb/mon/mon_bin.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/usb/mon/mon_bin.c
@@ -1247,7 +1247,7 @@ static int mon_bin_mmap(struct file *fil
 {
 	/* don't do anything here: "fault" will set up page table entries */
 	vma->vm_ops = &mon_bin_vm_ops;
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = filp->private_data;
 	mon_bin_vma_open(vma);
 	return 0;
diff -puN drivers/video/68328fb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/68328fb.c
--- a/drivers/video/68328fb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/68328fb.c
@@ -400,7 +400,7 @@ static int mc68x328fb_mmap(struct fb_inf
 #ifndef MMU
 	/* this is uClinux (no MMU) specific code */
 
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_start = videomemory;
 
 	return 0;
diff -puN drivers/video/aty/atyfb_base.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/aty/atyfb_base.c
@@ -1942,8 +1942,7 @@ static int atyfb_mmap(struct fb_info *in
 	off = vma->vm_pgoff << PAGE_SHIFT;
 	size = vma->vm_end - vma->vm_start;
 
-	/* To stop the swapper from even considering these pages. */
-	vma->vm_flags |= (VM_IO | VM_RESERVED);
+	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 
 	if (((vma->vm_pgoff == 0) && (size == info->fix.smem_len)) ||
 	    ((off == info->fix.smem_len) && (size == PAGE_SIZE)))
diff -puN drivers/video/fb-puv3.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/fb-puv3.c
--- a/drivers/video/fb-puv3.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/fb-puv3.c
@@ -653,9 +653,8 @@ int unifb_mmap(struct fb_info *info,
 				vma->vm_page_prot))
 		return -EAGAIN;
 
-	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
+	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 	return 0;
-
 }
 
 static struct fb_ops unifb_ops = {
diff -puN drivers/video/fb_defio.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/fb_defio.c
@@ -166,7 +166,7 @@ static const struct address_space_operat
 static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_ops = &fb_deferred_io_vm_ops;
-	vma->vm_flags |= ( VM_RESERVED | VM_DONTEXPAND );
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	if (!(info->flags & FBINFO_VIRTFB))
 		vma->vm_flags |= VM_IO;
 	vma->vm_private_data = info;
diff -puN drivers/video/fbmem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/fbmem.c
@@ -1410,8 +1410,7 @@ fb_mmap(struct file *file, struct vm_are
 		return -EINVAL;
 	off += start;
 	vma->vm_pgoff = off >> PAGE_SHIFT;
-	/* This is an IO map - tell maydump to skip this VMA */
-	vma->vm_flags |= VM_IO | VM_RESERVED;
+	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by io_remap_pfn_range()*/
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	fb_pgprotect(file, vma, off);
 	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
diff -puN drivers/video/gbefb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/gbefb.c
--- a/drivers/video/gbefb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/gbefb.c
@@ -1024,7 +1024,7 @@ static int gbefb_mmap(struct fb_info *in
 	pgprot_val(vma->vm_page_prot) =
 		pgprot_fb(pgprot_val(vma->vm_page_prot));
 
-	vma->vm_flags |= VM_IO | VM_RESERVED;
+	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 
 	/* look for the starting tile */
 	tile = &gbe_tiles.cpu[offset >> TILE_SHIFT];
diff -puN drivers/video/omap2/omapfb/omapfb-main.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/omap2/omapfb/omapfb-main.c
--- a/drivers/video/omap2/omapfb/omapfb-main.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/omap2/omapfb/omapfb-main.c
@@ -1127,7 +1127,7 @@ static int omapfb_mmap(struct fb_info *f
 	DBG("user mmap region start %lx, len %d, off %lx\n", start, len, off);
 
 	vma->vm_pgoff = off >> PAGE_SHIFT;
-	vma->vm_flags |= VM_IO | VM_RESERVED;
+	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	vma->vm_ops = &mmap_user_ops;
 	vma->vm_private_data = rg;
diff -puN drivers/video/sbuslib.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/sbuslib.c
--- a/drivers/video/sbuslib.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/sbuslib.c
@@ -57,9 +57,8 @@ int sbusfb_mmap_helper(struct sbus_mmap_
 
 	off = vma->vm_pgoff << PAGE_SHIFT;
 
-	/* To stop the swapper from even considering these pages */
-	vma->vm_flags |= (VM_IO | VM_RESERVED);
-	
+	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
+
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	/* Each page, see which map applies */
diff -puN drivers/video/smscufx.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/smscufx.c
--- a/drivers/video/smscufx.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/smscufx.c
@@ -803,7 +803,6 @@ static int ufx_ops_mmap(struct fb_info *
 			size = 0;
 	}
 
-	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
 	return 0;
 }
 
diff -puN drivers/video/udlfb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/udlfb.c
--- a/drivers/video/udlfb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/udlfb.c
@@ -345,7 +345,6 @@ static int dlfb_ops_mmap(struct fb_info 
 			size = 0;
 	}
 
-	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
 	return 0;
 }
 
diff -puN drivers/video/vermilion/vermilion.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/vermilion/vermilion.c
--- a/drivers/video/vermilion/vermilion.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/vermilion/vermilion.c
@@ -1018,7 +1018,6 @@ static int vmlfb_mmap(struct fb_info *in
 	offset += vinfo->vram_start;
 	pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
 	pgprot_val(vma->vm_page_prot) &= ~_PAGE_PWT;
-	vma->vm_flags |= VM_RESERVED | VM_IO;
 	if (remap_pfn_range(vma, vma->vm_start, offset >> PAGE_SHIFT,
 						size, vma->vm_page_prot))
 		return -EAGAIN;
diff -puN drivers/video/vfb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/video/vfb.c
--- a/drivers/video/vfb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/video/vfb.c
@@ -439,7 +439,6 @@ static int vfb_mmap(struct fb_info *info
 			size = 0;
 	}
 
-	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
 	return 0;
 
 }
diff -puN drivers/xen/gntalloc.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/xen/gntalloc.c
--- a/drivers/xen/gntalloc.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/xen/gntalloc.c
@@ -535,7 +535,7 @@ static int gntalloc_mmap(struct file *fi
 
 	vma->vm_private_data = vm_priv;
 
-	vma->vm_flags |= VM_RESERVED | VM_DONTEXPAND;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 
 	vma->vm_ops = &gntalloc_vmops;
 
diff -puN drivers/xen/gntdev.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/xen/gntdev.c
--- a/drivers/xen/gntdev.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/xen/gntdev.c
@@ -719,7 +719,7 @@ static int gntdev_mmap(struct file *flip
 
 	vma->vm_ops = &gntdev_vmops;
 
-	vma->vm_flags |= VM_RESERVED|VM_DONTEXPAND;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 
 	if (use_ptemod)
 		vma->vm_flags |= VM_DONTCOPY;
diff -puN drivers/xen/privcmd.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter drivers/xen/privcmd.c
--- a/drivers/xen/privcmd.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/drivers/xen/privcmd.c
@@ -386,7 +386,8 @@ static int privcmd_mmap(struct file *fil
 
 	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
 	 * how to recreate these mappings */
-	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTCOPY |
+			 VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &privcmd_vm_ops;
 	vma->vm_private_data = NULL;
 
diff -puN fs/binfmt_elf.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/fs/binfmt_elf.c
@@ -1127,7 +1127,7 @@ static unsigned long vma_dump_size(struc
 	}
 
 	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & (VM_IO | VM_RESERVED))
+	if (vma->vm_flags & VM_IO)
 		return 0;
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
diff -puN fs/binfmt_elf_fdpic.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/fs/binfmt_elf_fdpic.c
@@ -1205,7 +1205,7 @@ static int maydump(struct vm_area_struct
 	int dump_ok;
 
 	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & (VM_IO | VM_RESERVED)) {
+	if (vma->vm_flags & VM_IO) {
 		kdcore("%08lx: %08lx: no (IO)", vma->vm_start, vma->vm_flags);
 		return 0;
 	}
diff -puN fs/hugetlbfs/inode.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/fs/hugetlbfs/inode.c
@@ -110,7 +110,7 @@ static int hugetlbfs_file_mmap(struct fi
 	 * way when do_mmap_pgoff unwinds (may be important on powerpc
 	 * and ia64).
 	 */
-	vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
+	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &hugetlb_vm_ops;
 
 	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
diff -puN fs/proc/task_mmu.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/fs/proc/task_mmu.c
@@ -54,7 +54,7 @@ void task_mem(struct seq_file *m, struct
 		"VmPTE:\t%8lu kB\n"
 		"VmSwap:\t%8lu kB\n",
 		hiwater_vm << (PAGE_SHIFT-10),
-		(total_vm - mm->reserved_vm) << (PAGE_SHIFT-10),
+		total_vm << (PAGE_SHIFT-10),
 		mm->locked_vm << (PAGE_SHIFT-10),
 		mm->pinned_vm << (PAGE_SHIFT-10),
 		hiwater_rss << (PAGE_SHIFT-10),
diff -puN include/linux/mempolicy.h~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/include/linux/mempolicy.h
@@ -239,7 +239,7 @@ extern int mpol_to_str(char *buffer, int
 /* Check if a vma is migratable */
 static inline int vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
+	if (vma->vm_flags & (VM_IO | VM_HUGETLB | VM_PFNMAP))
 		return 0;
 	/*
 	 * Migration allocates pages in the highest zone. If we cannot
diff -puN include/linux/mm.h~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter include/linux/mm.h
--- a/include/linux/mm.h~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/include/linux/mm.h
@@ -96,7 +96,6 @@ extern unsigned int kobjsize(const void 
 
 #define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
 #define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
-#define VM_RESERVED	0x00080000	/* Count as reserved_vm like IO */
 #define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
@@ -148,7 +147,7 @@ extern unsigned int kobjsize(const void 
  * Special vmas that are non-mergable, non-mlock()able.
  * Note: mm/huge_memory.c VM_NO_THP depends on this definition.
  */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_RESERVED | VM_PFNMAP)
+#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff -puN include/linux/mm_types.h~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/include/linux/mm_types.h
@@ -349,7 +349,6 @@ struct mm_struct {
 	unsigned long shared_vm;	/* Shared pages (files) */
 	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
 	unsigned long stack_vm;		/* VM_GROWSUP/DOWN */
-	unsigned long reserved_vm;	/* VM_RESERVED|VM_IO pages */
 	unsigned long def_flags;
 	unsigned long nr_ptes;		/* Page table pages */
 	unsigned long start_code, end_code, start_data, end_data;
diff -puN kernel/events/core.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter kernel/events/core.c
--- a/kernel/events/core.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/kernel/events/core.c
@@ -3669,7 +3669,7 @@ unlock:
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
diff -puN mm/ksm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter mm/ksm.c
--- a/mm/ksm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/mm/ksm.c
@@ -1469,8 +1469,7 @@ int ksm_madvise(struct vm_area_struct *v
 		 */
 		if (*vm_flags & (VM_MERGEABLE | VM_SHARED  | VM_MAYSHARE   |
 				 VM_PFNMAP    | VM_IO      | VM_DONTEXPAND |
-				 VM_RESERVED  | VM_HUGETLB |
-				 VM_NONLINEAR | VM_MIXEDMAP))
+				 VM_HUGETLB | VM_NONLINEAR | VM_MIXEDMAP))
 			return 0;		/* just ignore the advice */
 
 #ifdef VM_SAO
diff -puN mm/memory.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter mm/memory.c
--- a/mm/memory.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/mm/memory.c
@@ -2297,14 +2297,13 @@ int remap_pfn_range(struct vm_area_struc
 	 * rest of the world about it:
 	 *   VM_IO tells people not to look at these pages
 	 *	(accesses can have side effects).
-	 *   VM_RESERVED is specified all over the place, because
-	 *	in 2.4 it kept swapout's vma scan off this vma; but
-	 *	in 2.6 the LRU scan won't even find its pages, so this
-	 *	flag means no more than count its pages in reserved_vm,
-	 * 	and omit it from core dump, even when VM_IO turned off.
 	 *   VM_PFNMAP tells the core MM that the base pages are just
 	 *	raw PFN mappings, and do not have a "struct page" associated
 	 *	with them.
+	 *   VM_DONTEXPAND
+	 *      Disable vma merging and expanding with mremap().
+	 *   VM_DONTDUMP
+	 *      Omit vma from core dump, even when VM_IO turned off.
 	 *
 	 * There's a horrible special case to handle copy-on-write
 	 * behaviour that some programs depend on. We mark the "original"
@@ -2321,7 +2320,7 @@ int remap_pfn_range(struct vm_area_struc
 	if (err)
 		return -EINVAL;
 
-	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 
 	BUG_ON(addr >= end);
 	pfn -= addr >> PAGE_SHIFT;
diff -puN mm/mlock.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter mm/mlock.c
--- a/mm/mlock.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/mm/mlock.c
@@ -227,7 +227,7 @@ long mlock_vma_pages_range(struct vm_are
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		goto no_mlock;
 
-	if (!((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
+	if (!((vma->vm_flags & VM_DONTEXPAND) ||
 			is_vm_hugetlb_page(vma) ||
 			vma == get_gate_vma(current->mm))) {
 
diff -puN mm/mmap.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter mm/mmap.c
--- a/mm/mmap.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/mm/mmap.c
@@ -945,8 +945,6 @@ void vm_stat_account(struct mm_struct *m
 			mm->exec_vm += pages;
 	} else if (flags & stack_flags)
 		mm->stack_vm += pages;
-	if (flags & (VM_RESERVED|VM_IO))
-		mm->reserved_vm += pages;
 }
 #endif /* CONFIG_PROC_FS */
 
diff -puN mm/nommu.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter mm/nommu.c
--- a/mm/nommu.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/mm/nommu.c
@@ -1813,7 +1813,7 @@ int remap_pfn_range(struct vm_area_struc
 	if (addr != (pfn << PAGE_SHIFT))
 		return -EINVAL;
 
-	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	return 0;
 }
 EXPORT_SYMBOL(remap_pfn_range);
diff -puN mm/vmalloc.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter mm/vmalloc.c
--- a/mm/vmalloc.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/mm/vmalloc.c
@@ -2163,8 +2163,7 @@ int remap_vmalloc_range(struct vm_area_s
 		usize -= PAGE_SIZE;
 	} while (usize > 0);
 
-	/* Prevent "things" like memory migration? VM_flags need a cleanup... */
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 
 	return 0;
 }
diff -puN security/selinux/selinuxfs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter security/selinux/selinuxfs.c
--- a/security/selinux/selinuxfs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/security/selinux/selinuxfs.c
@@ -485,7 +485,7 @@ static int sel_mmap_policy(struct file *
 			return -EACCES;
 	}
 
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &sel_mmap_policy_ops;
 
 	return 0;
diff -puN sound/core/pcm_native.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/sound/core/pcm_native.c
@@ -3038,7 +3038,7 @@ static int snd_pcm_mmap_status(struct sn
 		return -EINVAL;
 	area->vm_ops = &snd_pcm_vm_ops_status;
 	area->vm_private_data = substream;
-	area->vm_flags |= VM_RESERVED;
+	area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	return 0;
 }
 
@@ -3075,7 +3075,7 @@ static int snd_pcm_mmap_control(struct s
 		return -EINVAL;
 	area->vm_ops = &snd_pcm_vm_ops_control;
 	area->vm_private_data = substream;
-	area->vm_flags |= VM_RESERVED;
+	area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	return 0;
 }
 #else /* ! coherent mmap */
@@ -3169,7 +3169,7 @@ static const struct vm_operations_struct
 int snd_pcm_lib_default_mmap(struct snd_pcm_substream *substream,
 			     struct vm_area_struct *area)
 {
-	area->vm_flags |= VM_RESERVED;
+	area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 #ifdef ARCH_HAS_DMA_MMAP_COHERENT
 	if (!substream->ops->page &&
 	    substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV)
diff -puN sound/usb/usx2y/us122l.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter sound/usb/usx2y/us122l.c
--- a/sound/usb/usx2y/us122l.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/sound/usb/usx2y/us122l.c
@@ -262,7 +262,7 @@ static int usb_stream_hwdep_mmap(struct 
 	}
 
 	area->vm_ops = &usb_stream_hwdep_vm_ops;
-	area->vm_flags |= VM_RESERVED;
+	area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	area->vm_private_data = us122l;
 	atomic_inc(&us122l->mmap_count);
 out:
diff -puN sound/usb/usx2y/usX2Yhwdep.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter sound/usb/usx2y/usX2Yhwdep.c
--- a/sound/usb/usx2y/usX2Yhwdep.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/sound/usb/usx2y/usX2Yhwdep.c
@@ -82,7 +82,7 @@ static int snd_us428ctls_mmap(struct snd
 		us428->us428ctls_sharedmem->CtlSnapShotLast = -2;
 	}
 	area->vm_ops = &us428ctls_vm_ops;
-	area->vm_flags |= VM_RESERVED | VM_DONTEXPAND;
+	area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	area->vm_private_data = hw->private_data;
 	return 0;
 }
diff -puN sound/usb/usx2y/usx2yhwdeppcm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter sound/usb/usx2y/usx2yhwdeppcm.c
--- a/sound/usb/usx2y/usx2yhwdeppcm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter
+++ a/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -723,7 +723,7 @@ static int snd_usX2Y_hwdep_pcm_mmap(stru
 		return -ENODEV;
 	}
 	area->vm_ops = &snd_usX2Y_hwdep_pcm_vm_ops;
-	area->vm_flags |= VM_RESERVED | VM_DONTEXPAND;
+	area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	area->vm_private_data = hw->private_data;
 	return 0;
 }
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch

