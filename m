From: akpm@linux-foundation.org
Subject: + virtio-fix-bad_ring-start_us-and-end_use-macros.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:05:23 -0800
Message-ID: <200901302005.n0UK5NV9025976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbZA3UF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     virtio: fix BAD_RING, START_US and END_USE macros
has been added to the -mm tree.  Its filename is
     virtio-fix-bad_ring-start_us-and-end_use-macros.patch

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
dvb-negative-internal-sub_range-wont-get-noticed.patch
paride-pgc-xs-confusion.patch
virtio-fix-bad_ring-start_us-and-end_use-macros.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
ufs-sector_t-cannot-be-negative.patch

