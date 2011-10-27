From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-vmwgfx-memory-leaks-caused-by-double-allocation.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:26 -0700
Message-ID: <201110272308.p9RN8QfW014175@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:22290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1J0XIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:08:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, airlied@linux.ie, thellstrom@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/vmwgfx: memory leaks caused by double allocation
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-vmwgfx-memory-leaks-caused-by-double-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/gpu/drm/vmwgfx: memory leaks caused by double allocation

These variables get allocated twice so the first allocation is a memory
leak.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Airlie <airlied@linux.ie>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c    |    3 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/gpu/drm/vmwgfx/vmwgfx_fence.c~drivers-gpu-drm-vmwgfx-memory-leaks-caused-by-double-allocation drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c~drivers-gpu-drm-vmwgfx-memory-leaks-caused-by-double-allocation
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -953,8 +953,7 @@ int vmw_event_fence_action_create(struct
 				  uint32_t *tv_usec,
 				  bool interruptible)
 {
-	struct vmw_event_fence_action *eaction =
-		kzalloc(sizeof(*eaction), GFP_KERNEL);
+	struct vmw_event_fence_action *eaction;
 	struct ttm_mem_global *mem_glob =
 		vmw_mem_glob(fence->fman->dev_priv);
 	struct vmw_fence_manager *fman = fence->fman;
diff -puN drivers/gpu/drm/vmwgfx/vmwgfx_resource.c~drivers-gpu-drm-vmwgfx-memory-leaks-caused-by-double-allocation drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c~drivers-gpu-drm-vmwgfx-memory-leaks-caused-by-double-allocation
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -1255,8 +1255,7 @@ int vmw_surface_define_ioctl(struct drm_
 			     struct drm_file *file_priv)
 {
 	struct vmw_private *dev_priv = vmw_priv(dev);
-	struct vmw_user_surface *user_srf =
-	    kmalloc(sizeof(*user_srf), GFP_KERNEL);
+	struct vmw_user_surface *user_srf;
 	struct vmw_surface *srf;
 	struct vmw_resource *res;
 	struct vmw_resource *tmp;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
bio-change-some-signed-vars-to-unsigned.patch
paride-fix-potential-information-leak-in-pg_read.patch

