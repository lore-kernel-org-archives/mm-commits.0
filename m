From: akpm@linux-foundation.org
Subject: +
 mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch
 added to -mm tree
Date: Wed, 25 Jan 2017 14:49:35 -0800
Message-ID: <58892b7f.KWoBGBruRhEw2giZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdAYWtg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 17:49:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dave.jiang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fixup! mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf
has been added to the -mm tree.  Its filename is
     mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fixup! mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf

I ran into a couple of build problems on ARM, these are the changes that
should be folded into the original patch that changed all the ->fault()
prototypes

Fixes: mmtom ("mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf")
Link: http://lkml.kernel.org/r/20170125223558.1451224-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/armada/armada_gem.c   |    9 +++++----
 drivers/gpu/drm/etnaviv/etnaviv_drv.h |    2 +-
 drivers/gpu/drm/omapdrm/omap_drv.h    |    2 +-
 drivers/hsi/clients/cmt_speech.c      |    4 ++--
 4 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/gpu/drm/armada/armada_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix drivers/gpu/drm/armada/armada_gem.c
--- a/drivers/gpu/drm/armada/armada_gem.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix
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
diff -puN drivers/gpu/drm/etnaviv/etnaviv_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix drivers/gpu/drm/etnaviv/etnaviv_drv.h
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix
+++ a/drivers/gpu/drm/etnaviv/etnaviv_drv.h
@@ -73,7 +73,7 @@ int etnaviv_ioctl_gem_submit(struct drm_
 		struct drm_file *file);
 
 int etnaviv_gem_mmap(struct file *filp, struct vm_area_struct *vma);
-int etnaviv_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+int etnaviv_gem_fault(struct vm_fault *vmf);
 int etnaviv_gem_mmap_offset(struct drm_gem_object *obj, u64 *offset);
 struct sg_table *etnaviv_gem_prime_get_sg_table(struct drm_gem_object *obj);
 void *etnaviv_gem_prime_vmap(struct drm_gem_object *obj);
diff -puN drivers/gpu/drm/omapdrm/omap_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix drivers/gpu/drm/omapdrm/omap_drv.h
--- a/drivers/gpu/drm/omapdrm/omap_drv.h~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix
+++ a/drivers/gpu/drm/omapdrm/omap_drv.h
@@ -204,7 +204,7 @@ int omap_gem_dumb_create(struct drm_file
 int omap_gem_mmap(struct file *filp, struct vm_area_struct *vma);
 int omap_gem_mmap_obj(struct drm_gem_object *obj,
 		struct vm_area_struct *vma);
-int omap_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+int omap_gem_fault(struct vm_fault *vmf);
 int omap_gem_op_start(struct drm_gem_object *obj, enum omap_gem_op op);
 int omap_gem_op_finish(struct drm_gem_object *obj, enum omap_gem_op op);
 int omap_gem_op_sync(struct drm_gem_object *obj, enum omap_gem_op op);
diff -puN drivers/hsi/clients/cmt_speech.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix drivers/hsi/clients/cmt_speech.c
--- a/drivers/hsi/clients/cmt_speech.c~mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix
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
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-track-active-portions-of-a-section-at-boot-fix-fix.patch
mm-support-section-unaligned-zone_device-memory-ranges-fix.patch
mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch

