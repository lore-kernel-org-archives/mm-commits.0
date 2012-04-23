From: akpm@linux-foundation.org
Subject: + drm-i915-fix-integer-overflow-in-i915_gem_do_execbuffer.patch added to -mm tree
Date: Mon, 23 Apr 2012 14:22:14 -0700
Message-ID: <20120423212214.3F502A038B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:64244 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2DWVWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Apr 2012 17:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xi.wang@gmail.com, chris@chris-wilson.co.uk, stable@vger.kernel.org


The patch titled
     Subject: drm/i915: fix integer overflow in i915_gem_do_execbuffer()
has been added to the -mm tree.  Its filename is
     drm-i915-fix-integer-overflow-in-i915_gem_do_execbuffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drm/i915: fix integer overflow in i915_gem_do_execbuffer()

Patches currently in -mm which might be from xi.wang@gmail.com are

linux-next.patch
drm-i915-fix-integer-overflow-in-i915_gem_execbuffer2.patch
drm-i915-fix-integer-overflow-in-i915_gem_do_execbuffer.patch
codingstyle-add-kmalloc_array-to-memory-allocators.patch
introduce-size_max.patch

