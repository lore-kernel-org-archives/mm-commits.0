From: akpm@linux-foundation.org
Subject: [patch 070/124] drm: remove unnecessary fault wrappers
Date: Fri, 24 Feb 2017 14:59:04 -0800
Message-ID: <58b0bab8.2AsbuAIWnD1DME5U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38624 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdBXW7G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, daniel.vetter@ffwll.ch, dave.jiang@intel.com, seanpaul@chromium.org

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: drm: remove unnecessary fault wrappers

The fault wrappers drm_vm_fault(), drm_vm_shm_fault(), drm_vm_dma_fault()
and drm_vm_sg_fault() used to provide extra logic beyond what was in the
"drm_do_*" versions of these functions, but as of this commit:

commit ca0b07d9a969 ("drm: convert drm from nopage to fault.")

They are just unnecessary wrappers that do nothing.  Remove them, and
rename the the drm_do_* fault handlers to remove the "do_" since they no
longer have corresponding wrappers.

Link: http://lkml.kernel.org/r/1486155698-25717-1-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_vm.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff -puN drivers/gpu/drm/drm_vm.c~drm-remove-unnecessary-fault-wrappers drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c~drm-remove-unnecessary-fault-wrappers
+++ a/drivers/gpu/drm/drm_vm.c
@@ -96,7 +96,7 @@ static pgprot_t drm_dma_prot(uint32_t ma
  * map, get the page, increment the use count and return it.
  */
 #if IS_ENABLED(CONFIG_AGP)
-static int drm_do_vm_fault(struct vm_fault *vmf)
+static int drm_vm_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_file *priv = vma->vm_file->private_data;
@@ -169,7 +169,7 @@ vm_fault_error:
 	return VM_FAULT_SIGBUS;	/* Disallow mremap */
 }
 #else
-static int drm_do_vm_fault(struct vm_fault *vmf)
+static int drm_vm_fault(struct vm_fault *vmf)
 {
 	return VM_FAULT_SIGBUS;
 }
@@ -185,7 +185,7 @@ static int drm_do_vm_fault(struct vm_fau
  * Get the mapping, find the real physical page to map, get the page, and
  * return it.
  */
-static int drm_do_vm_shm_fault(struct vm_fault *vmf)
+static int drm_vm_shm_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_local_map *map = vma->vm_private_data;
@@ -287,7 +287,7 @@ static void drm_vm_shm_close(struct vm_a
  *
  * Determine the page number from the page offset and get it from drm_device_dma::pagelist.
  */
-static int drm_do_vm_dma_fault(struct vm_fault *vmf)
+static int drm_vm_dma_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_file *priv = vma->vm_file->private_data;
@@ -322,7 +322,7 @@ static int drm_do_vm_dma_fault(struct vm
  *
  * Determine the map offset from the page offset and get it from drm_sg_mem::pagelist.
  */
-static int drm_do_vm_sg_fault(struct vm_fault *vmf)
+static int drm_vm_sg_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct drm_local_map *map = vma->vm_private_data;
@@ -349,26 +349,6 @@ static int drm_do_vm_sg_fault(struct vm_
 	return 0;
 }
 
-static int drm_vm_fault(struct vm_fault *vmf)
-{
-	return drm_do_vm_fault(vmf);
-}
-
-static int drm_vm_shm_fault(struct vm_fault *vmf)
-{
-	return drm_do_vm_shm_fault(vmf);
-}
-
-static int drm_vm_dma_fault(struct vm_fault *vmf)
-{
-	return drm_do_vm_dma_fault(vmf);
-}
-
-static int drm_vm_sg_fault(struct vm_fault *vmf)
-{
-	return drm_do_vm_sg_fault(vmf);
-}
