From: akpm@linux-foundation.org
Subject: [obsolete] virtio-fix-bad_ring-start_us-and-end_use-macros.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:30:49 -0800
Message-ID: <200902021930.n12JUne6005402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbZBBTbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:31:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     virtio: fix BAD_RING, START_US and END_USE macros
has been removed from the -mm tree.  Its filename was
     virtio-fix-bad_ring-start_us-and-end_use-macros.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: virtio: fix BAD_RING, START_US and END_USE macros
From: Roel Kluin <roel.kluin@gmail.com>

When these macros aren't called with a variable named vq as first
argument, this would result in a build failure.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_ring.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/virtio/virtio_ring.c~virtio-fix-bad_ring-start_us-and-end_use-macros drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c~virtio-fix-bad_ring-start_us-and-end_use-macros
+++ a/drivers/virtio/virtio_ring.c
@@ -23,15 +23,15 @@
 
 #ifdef DEBUG
 /* For development, we want to crash whenever the ring is screwed. */
-#define BAD_RING(vq, fmt...)			\
-	do { dev_err(&vq->vq.vdev->dev, fmt); BUG(); } while(0)
-#define START_USE(vq) \
-	do { if ((vq)->in_use) panic("in_use = %i\n", (vq)->in_use); (vq)->in_use = __LINE__; mb(); } while(0)
-#define END_USE(vq) \
-	do { BUG_ON(!(vq)->in_use); (vq)->in_use = 0; mb(); } while(0)
+#define BAD_RING(_vq, fmt...)			\
+	do { dev_err(&_vq->vq.vdev->dev, fmt); BUG(); } while(0)
+#define START_USE(_vq) \
+	do { if ((_vq)->in_use) panic("in_use = %i\n", (_vq)->in_use); (_vq)->in_use = __LINE__; mb(); } while(0)
+#define END_USE(_vq) \
+	do { BUG_ON(!(_vq)->in_use); (_vq)->in_use = 0; mb(); } while(0)
 #else
-#define BAD_RING(vq, fmt...)			\
-	do { dev_err(&vq->vq.vdev->dev, fmt); (vq)->broken = true; } while(0)
+#define BAD_RING(_vq, fmt...)			\
+	do { dev_err(&_vq->vq.vdev->dev, fmt); (_vq)->broken = true; } while(0)
 #define START_USE(vq)
 #define END_USE(vq)
 #endif
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
paride-pgc-xs-confusion.patch
virtio-fix-bad_ring-start_us-and-end_use-macros.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
rtc-wm8350-retries-will-reach-1.patch
ufs-sector_t-cannot-be-negative.patch

