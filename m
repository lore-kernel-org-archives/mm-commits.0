From: akpm@linux-foundation.org
Subject: [merged] drm-i915-fix-integer-overflow-in-i915_gem_execbuffer2.patch removed from -mm tree
Date: Mon, 30 Apr 2012 13:00:14 -0700
Message-ID: <20120430200017.6E75BA02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:65366 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2D3UAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 16:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xi.wang@gmail.com, chris@chris-wilson.co.uk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: fix integer overflow in i915_gem_execbuffer2()
has been removed from the -mm tree.  Its filename was
     drm-i915-fix-integer-overflow-in-i915_gem_execbuffer2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: drm/i915: fix integer overflow in i915_gem_execbuffer2()

On 32-bit systems, a large args->buffer_count from userspace via ioctl may
overflow the allocation size, leading to out-of-bounds access.

This vulnerability was introduced in commit 8408c282 ("drm/i915: First try
a normal large kmalloc for the temporary exec buffers").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/i915_gem_execbuffer.c~drm-i915-fix-integer-overflow-in-i915_gem_execbuffer2 drivers/gpu/drm/i915/i915_gem_execbuffer.c
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c~drm-i915-fix-integer-overflow-in-i915_gem_execbuffer2
+++ a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1446,7 +1446,8 @@ i915_gem_execbuffer2(struct drm_device *
 	struct drm_i915_gem_exec_object2 *exec2_list = NULL;
 	int ret;
 
-	if (args->buffer_count < 1) {
+	if (args->buffer_count < 1 ||
+	    args->buffer_count > UINT_MAX / sizeof(*exec2_list)) {
 		DRM_DEBUG("execbuf2 with %d buffers\n", args->buffer_count);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from xi.wang@gmail.com are

linux-next.patch
codingstyle-add-kmalloc_array-to-memory-allocators.patch
introduce-size_max.patch

