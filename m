From: akpm@linux-foundation.org
Subject: + i915-signedness-bugs-in-i915-ring-buffer.patch added to -mm tree
Date: Mon, 27 Sep 2010 14:46:55 -0700
Message-ID: <201009272146.o8RLktpr018495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196Ab0I0Vr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 17:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, airlied@linux.ie, chris@chris-wilson.co.uk, eric@anholt.net, haihao.xiang@intel.com, nanhai.zou@intel.com, zhenyuw@linux.intel.com


The patch titled
     drivers/gpu/drm/i915/: fix signedness bugs in i915 ring buffer
has been added to the -mm tree.  Its filename is
     i915-signedness-bugs-in-i915-ring-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/i915/: fix signedness bugs in i915 ring buffer
From: Dan Carpenter <error27@gmail.com>

"ring->space" is unsigned so it's never less than zero.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Zou Nan hai <nanhai.zou@intel.com>
Cc: Xiang Hai hao <haihao.xiang@intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_dma.c         |    7 ++++---
 drivers/gpu/drm/i915/intel_ringbuffer.c |   21 ++++++++++++---------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_dma.c~i915-signedness-bugs-in-i915-ring-buffer drivers/gpu/drm/i915/i915_dma.c
--- a/drivers/gpu/drm/i915/i915_dma.c~i915-signedness-bugs-in-i915-ring-buffer
+++ a/drivers/gpu/drm/i915/i915_dma.c
@@ -109,9 +109,10 @@ void i915_kernel_lost_context(struct drm
 
 	ring->head = I915_READ(PRB0_HEAD) & HEAD_ADDR;
 	ring->tail = I915_READ(PRB0_TAIL) & TAIL_ADDR;
-	ring->space = ring->head - (ring->tail + 8);
-	if (ring->space < 0)
-		ring->space += ring->size;
+	if (ring->head >= ring->tail + 8)
+		ring->space = ring->head - (ring->tail + 8);
+	else
+		ring->space = ring->head - (ring->tail + 8) + ring->size;
 
 	if (!dev->primary->master)
 		return;
diff -puN drivers/gpu/drm/i915/intel_ringbuffer.c~i915-signedness-bugs-in-i915-ring-buffer drivers/gpu/drm/i915/intel_ringbuffer.c
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c~i915-signedness-bugs-in-i915-ring-buffer
+++ a/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -208,9 +208,10 @@ static int init_ring_common(struct drm_d
 	else {
 		ring->head = ring->get_head(dev, ring);
 		ring->tail = ring->get_tail(dev, ring);
-		ring->space = ring->head - (ring->tail + 8);
-		if (ring->space < 0)
-			ring->space += ring->size;
+		if (ring->head >= ring->tail + 8)
+			ring->space = ring->head - (ring->tail + 8);
+		else
+			ring->space = ring->head - (ring->tail + 8) + ring->size;
 	}
 	return 0;
 }
@@ -670,9 +671,10 @@ int intel_init_ring_buffer(struct drm_de
 	else {
 		ring->head = ring->get_head(dev, ring);
 		ring->tail = ring->get_tail(dev, ring);
-		ring->space = ring->head - (ring->tail + 8);
-		if (ring->space < 0)
-			ring->space += ring->size;
+		if (ring->head >= ring->tail + 8)
+			ring->space = ring->head - (ring->tail + 8);
+		else
+			ring->space = ring->head - (ring->tail + 8) + ring->size;
 	}
 	INIT_LIST_HEAD(&ring->active_list);
 	INIT_LIST_HEAD(&ring->request_list);
@@ -739,9 +741,10 @@ int intel_wait_ring_buffer(struct drm_de
 	end = jiffies + 3 * HZ;
 	do {
 		ring->head = ring->get_head(dev, ring);
-		ring->space = ring->head - (ring->tail + 8);
-		if (ring->space < 0)
-			ring->space += ring->size;
+		if (ring->head >= ring->tail + 8)
+			ring->space = ring->head - (ring->tail + 8);
+		else
+			ring->space = ring->head - (ring->tail + 8) + ring->size;
 		if (ring->space >= n) {
 			trace_i915_ring_wait_end (dev);
 			return 0;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
drivers-char-agp-parisc-agpc-eliminate-memory-leak.patch
i915-signedness-bugs-in-i915-ring-buffer.patch
rocket-release_region-or-error-path.patch
affs-testing-the-wrong-variable.patch

