From: akpm@linux-foundation.org
Subject: [merged] mm-mark-most-vm_operations_struct-const.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:13:46 -0700
Message-ID: <55f319da.vXmks2X5RYJqdOHI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbbIKSNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, luto@amacapital.net, minchan@kernel.org, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark most vm_operations_struct const
has been removed from the -mm tree.  Its filename was
     mm-mark-most-vm_operations_struct-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: mark most vm_operations_struct const

With two exceptions (drm/qxl and drm/radeon) all vm_operations_struct
structs should be constant.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/entry/vsyscall/vsyscall_64.c          |    2 +-
 drivers/android/binder.c                       |    2 +-
 drivers/gpu/drm/vgem/vgem_drv.c                |    2 +-
 drivers/hsi/clients/cmt_speech.c               |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c       |    2 +-
 drivers/infiniband/hw/qib/qib_mmap.c           |    2 +-
 drivers/media/platform/omap/omap_vout.c        |    2 +-
 drivers/misc/genwqe/card_dev.c                 |    2 +-
 drivers/staging/android/ion/ion.c              |    2 +-
 drivers/staging/comedi/comedi_fops.c           |    2 +-
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c |    2 +-
 drivers/xen/gntalloc.c                         |    2 +-
 drivers/xen/gntdev.c                           |    2 +-
 drivers/xen/privcmd.c                          |    4 ++--
 fs/ceph/addr.c                                 |    2 +-
 fs/cifs/file.c                                 |    2 +-
 security/selinux/selinuxfs.c                   |    2 +-
 17 files changed, 18 insertions(+), 18 deletions(-)

diff -puN arch/x86/entry/vsyscall/vsyscall_64.c~mm-mark-most-vm_operations_struct-const arch/x86/entry/vsyscall/vsyscall_64.c
--- a/arch/x86/entry/vsyscall/vsyscall_64.c~mm-mark-most-vm_operations_struct-const
+++ a/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -277,7 +277,7 @@ static const char *gate_vma_name(struct
 {
 	return "[vsyscall]";
 }
-static struct vm_operations_struct gate_vma_ops = {
+static const struct vm_operations_struct gate_vma_ops = {
 	.name = gate_vma_name,
 };
 static struct vm_area_struct gate_vma = {
diff -puN drivers/android/binder.c~mm-mark-most-vm_operations_struct-const drivers/android/binder.c
--- a/drivers/android/binder.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/android/binder.c
@@ -2834,7 +2834,7 @@ static int binder_vm_fault(struct vm_are
 	return VM_FAULT_SIGBUS;
 }
 
-static struct vm_operations_struct binder_vm_ops = {
+static const struct vm_operations_struct binder_vm_ops = {
 	.open = binder_vma_open,
 	.close = binder_vma_close,
 	.fault = binder_vm_fault,
diff -puN drivers/gpu/drm/vgem/vgem_drv.c~mm-mark-most-vm_operations_struct-const drivers/gpu/drm/vgem/vgem_drv.c
--- a/drivers/gpu/drm/vgem/vgem_drv.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/gpu/drm/vgem/vgem_drv.c
@@ -125,7 +125,7 @@ static int vgem_gem_fault(struct vm_area
 	}
 }
 
-static struct vm_operations_struct vgem_gem_vm_ops = {
+static const struct vm_operations_struct vgem_gem_vm_ops = {
 	.fault = vgem_gem_fault,
 	.open = drm_gem_vm_open,
 	.close = drm_gem_vm_close,
diff -puN drivers/hsi/clients/cmt_speech.c~mm-mark-most-vm_operations_struct-const drivers/hsi/clients/cmt_speech.c
--- a/drivers/hsi/clients/cmt_speech.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/hsi/clients/cmt_speech.c
@@ -1110,7 +1110,7 @@ static int cs_char_vma_fault(struct vm_a
 	return 0;
 }
 
-static struct vm_operations_struct cs_char_vm_ops = {
+static const struct vm_operations_struct cs_char_vm_ops = {
 	.fault	= cs_char_vma_fault,
 };
 
diff -puN drivers/infiniband/hw/qib/qib_file_ops.c~mm-mark-most-vm_operations_struct-const drivers/infiniband/hw/qib/qib_file_ops.c
--- a/drivers/infiniband/hw/qib/qib_file_ops.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -908,7 +908,7 @@ static int qib_file_vma_fault(struct vm_
 	return 0;
 }
 
-static struct vm_operations_struct qib_file_vm_ops = {
+static const struct vm_operations_struct qib_file_vm_ops = {
 	.fault = qib_file_vma_fault,
 };
 
diff -puN drivers/infiniband/hw/qib/qib_mmap.c~mm-mark-most-vm_operations_struct-const drivers/infiniband/hw/qib/qib_mmap.c
--- a/drivers/infiniband/hw/qib/qib_mmap.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/infiniband/hw/qib/qib_mmap.c
@@ -75,7 +75,7 @@ static void qib_vma_close(struct vm_area
 	kref_put(&ip->ref, qib_release_mmap_info);
 }
 
-static struct vm_operations_struct qib_vm_ops = {
+static const struct vm_operations_struct qib_vm_ops = {
 	.open =     qib_vma_open,
 	.close =    qib_vma_close,
 };
diff -puN drivers/media/platform/omap/omap_vout.c~mm-mark-most-vm_operations_struct-const drivers/media/platform/omap/omap_vout.c
--- a/drivers/media/platform/omap/omap_vout.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/media/platform/omap/omap_vout.c
@@ -872,7 +872,7 @@ static void omap_vout_vm_close(struct vm
 	vout->mmap_count--;
 }
 
-static struct vm_operations_struct omap_vout_vm_ops = {
+static const struct vm_operations_struct omap_vout_vm_ops = {
 	.open	= omap_vout_vm_open,
 	.close	= omap_vout_vm_close,
 };
diff -puN drivers/misc/genwqe/card_dev.c~mm-mark-most-vm_operations_struct-const drivers/misc/genwqe/card_dev.c
--- a/drivers/misc/genwqe/card_dev.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/misc/genwqe/card_dev.c
@@ -418,7 +418,7 @@ static void genwqe_vma_close(struct vm_a
 	kfree(dma_map);
 }
 
-static struct vm_operations_struct genwqe_vma_ops = {
+static const struct vm_operations_struct genwqe_vma_ops = {
 	.open   = genwqe_vma_open,
 	.close  = genwqe_vma_close,
 };
diff -puN drivers/staging/android/ion/ion.c~mm-mark-most-vm_operations_struct-const drivers/staging/android/ion/ion.c
--- a/drivers/staging/android/ion/ion.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/staging/android/ion/ion.c
@@ -997,7 +997,7 @@ static void ion_vm_close(struct vm_area_
 	mutex_unlock(&buffer->lock);
 }
 
-static struct vm_operations_struct ion_vma_ops = {
+static const struct vm_operations_struct ion_vma_ops = {
 	.open = ion_vm_open,
 	.close = ion_vm_close,
 	.fault = ion_vm_fault,
diff -puN drivers/staging/comedi/comedi_fops.c~mm-mark-most-vm_operations_struct-const drivers/staging/comedi/comedi_fops.c
--- a/drivers/staging/comedi/comedi_fops.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/staging/comedi/comedi_fops.c
@@ -2156,7 +2156,7 @@ static void comedi_vm_close(struct vm_ar
 	comedi_buf_map_put(bm);
 }
 
-static struct vm_operations_struct comedi_vm_ops = {
+static const struct vm_operations_struct comedi_vm_ops = {
 	.open = comedi_vm_open,
 	.close = comedi_vm_close,
 };
diff -puN drivers/video/fbdev/omap2/omapfb/omapfb-main.c~mm-mark-most-vm_operations_struct-const drivers/video/fbdev/omap2/omapfb/omapfb-main.c
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1091,7 +1091,7 @@ static void mmap_user_close(struct vm_ar
 	omapfb_put_mem_region(rg);
 }
 
-static struct vm_operations_struct mmap_user_ops = {
+static const struct vm_operations_struct mmap_user_ops = {
 	.open = mmap_user_open,
 	.close = mmap_user_close,
 };
diff -puN drivers/xen/gntalloc.c~mm-mark-most-vm_operations_struct-const drivers/xen/gntalloc.c
--- a/drivers/xen/gntalloc.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/xen/gntalloc.c
@@ -493,7 +493,7 @@ static void gntalloc_vma_close(struct vm
 	mutex_unlock(&gref_mutex);
 }
 
-static struct vm_operations_struct gntalloc_vmops = {
+static const struct vm_operations_struct gntalloc_vmops = {
 	.open = gntalloc_vma_open,
 	.close = gntalloc_vma_close,
 };
diff -puN drivers/xen/gntdev.c~mm-mark-most-vm_operations_struct-const drivers/xen/gntdev.c
--- a/drivers/xen/gntdev.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/xen/gntdev.c
@@ -433,7 +433,7 @@ static struct page *gntdev_vma_find_spec
 	return map->pages[(addr - map->pages_vm_start) >> PAGE_SHIFT];
 }
 
-static struct vm_operations_struct gntdev_vmops = {
+static const struct vm_operations_struct gntdev_vmops = {
 	.open = gntdev_vma_open,
 	.close = gntdev_vma_close,
 	.find_special_page = gntdev_vma_find_special_page,
diff -puN drivers/xen/privcmd.c~mm-mark-most-vm_operations_struct-const drivers/xen/privcmd.c
--- a/drivers/xen/privcmd.c~mm-mark-most-vm_operations_struct-const
+++ a/drivers/xen/privcmd.c
@@ -414,7 +414,7 @@ static int alloc_empty_pages(struct vm_a
 	return 0;
 }
 
-static struct vm_operations_struct privcmd_vm_ops;
+static const struct vm_operations_struct privcmd_vm_ops;
 
 static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
 {
@@ -605,7 +605,7 @@ static int privcmd_fault(struct vm_area_
 	return VM_FAULT_SIGBUS;
 }
 
-static struct vm_operations_struct privcmd_vm_ops = {
+static const struct vm_operations_struct privcmd_vm_ops = {
 	.close = privcmd_close,
 	.fault = privcmd_fault
 };
diff -puN fs/ceph/addr.c~mm-mark-most-vm_operations_struct-const fs/ceph/addr.c
--- a/fs/ceph/addr.c~mm-mark-most-vm_operations_struct-const
+++ a/fs/ceph/addr.c
@@ -1593,7 +1593,7 @@ out:
 	return err;
 }
 
-static struct vm_operations_struct ceph_vmops = {
+static const struct vm_operations_struct ceph_vmops = {
 	.fault		= ceph_filemap_fault,
 	.page_mkwrite	= ceph_page_mkwrite,
 };
diff -puN fs/cifs/file.c~mm-mark-most-vm_operations_struct-const fs/cifs/file.c
--- a/fs/cifs/file.c~mm-mark-most-vm_operations_struct-const
+++ a/fs/cifs/file.c
@@ -3216,7 +3216,7 @@ cifs_page_mkwrite(struct vm_area_struct
 	return VM_FAULT_LOCKED;
 }
 
-static struct vm_operations_struct cifs_file_vm_ops = {
+static const struct vm_operations_struct cifs_file_vm_ops = {
 	.fault = filemap_fault,
 	.map_pages = filemap_map_pages,
 	.page_mkwrite = cifs_page_mkwrite,
diff -puN security/selinux/selinuxfs.c~mm-mark-most-vm_operations_struct-const security/selinux/selinuxfs.c
--- a/security/selinux/selinuxfs.c~mm-mark-most-vm_operations_struct-const
+++ a/security/selinux/selinuxfs.c
@@ -472,7 +472,7 @@ static int sel_mmap_policy_fault(struct
 	return 0;
 }
 
-static struct vm_operations_struct sel_mmap_policy_ops = {
+static const struct vm_operations_struct sel_mmap_policy_ops = {
 	.fault = sel_mmap_policy_fault,
 	.page_mkwrite = sel_mmap_policy_fault,
 };
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

