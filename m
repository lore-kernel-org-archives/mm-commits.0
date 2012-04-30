From: akpm@linux-foundation.org
Subject: [merged] drm-i915-fix-integer-overflow-in-i915_gem_do_execbuffer.patch removed from -mm tree
Date: Mon, 30 Apr 2012 13:00:21 -0700
Message-ID: <20120430200021.6359BA02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33414 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2D3UAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 16:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xi.wang@gmail.com, chris@chris-wilson.co.uk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: fix integer overflow in i915_gem_do_execbuffer()
has been removed from the -mm tree.  Its filename was
     drm-i915-fix-integer-overflow-in-i915_gem_do_execbuffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: drm/i915: fix integer overflow in i915_gem_do_execbuffer()

On 32-bit systems, a large args->num_cliprects from userspace via ioctl
may overflow the allocation size, leading to out-of-bounds access.

This vulnerability was introduced in commit 432e58ed ("drm/i915: Avoid
allocation for execbuffer object list").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/gpu/drm/i915/i915_gem_execbuffer.c~drm-i915-fix-integer-overflow-in-i915_gem_do_execbuffer drivers/gpu/drm/i915/i915_gem_execbuffer.c
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c~drm-i915-fix-integer-overflow-in-i915_gem_do_execbuffer
+++ a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1175,6 +1175,11 @@ i915_gem_do_execbuffer(struct drm_device
 			return -EINVAL;
 		}
 
+		if (args->num_cliprects > UINT_MAX / sizeof(*cliprects)) {
+			DRM_DEBUG("execbuf with %u cliprects\n",
+				  args->num_cliprects);
+			return -EINVAL;
+		}
 		cliprects = kmalloc(args->num_cliprects * sizeof(*cliprects),
 				    GFP_KERNEL);
 		if (cliprects == NULL) {
_

Patches currently in -mm which might be from xi.wang@gmail.com are

linux-next.patch
codingstyle-add-kmalloc_array-to-memory-allocators.patch
introduce-size_max.patch

