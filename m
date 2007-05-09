From: akpm@linux-foundation.org
Subject: - intelfb-fix-ring-space-calculation.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:17 -0700
Message-ID: <200705090259.l492xHrB010379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970185AbXEIC7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juergen.orczykowski@siemens.com, adaplas@gmail.com, airlied@gmail.com, mm-commits@vger.kernel.org


The patch titled
     intelfb: fix ring space calculation
has been removed from the -mm tree.  Its filename was
     intelfb-fix-ring-space-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intelfb: fix ring space calculation
From: Orczykowski, Juergen <juergen.orczykowski@siemens.com>

If there is less then RING_MIN_FREE available in the ring buffer,
dinfo->ring_space is set to a big value forcing wait_ring to return.

Fix by making ring space = 0 if ring space < RING_MIN_FREE.

Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfbhw.c |   34 +++++++++++++++++-----------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff -puN drivers/video/intelfb/intelfbhw.c~intelfb-fix-ring-space-calculation drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c~intelfb-fix-ring-space-calculation
+++ a/drivers/video/intelfb/intelfbhw.c
@@ -1428,6 +1428,24 @@ static void refresh_ring(struct intelfb_
 static void reset_state(struct intelfb_info *dinfo);
 static void do_flush(struct intelfb_info *dinfo);
 
+static  u32 get_ring_space(struct intelfb_info *dinfo)
+{
+	u32 ring_space;
+
+	if (dinfo->ring_tail >= dinfo->ring_head)
+		ring_space = dinfo->ring.size -
+			(dinfo->ring_tail - dinfo->ring_head);
+	else
+		ring_space = dinfo->ring_head - dinfo->ring_tail;
+
+	if (ring_space > RING_MIN_FREE)
+		ring_space -= RING_MIN_FREE;
+	else
+		ring_space = 0;
+
+	return ring_space;
+}
+
 static int
 wait_ring(struct intelfb_info *dinfo, int n)
 {
@@ -1442,13 +1460,8 @@ wait_ring(struct intelfb_info *dinfo, in
 	end = jiffies + (HZ * 3);
 	while (dinfo->ring_space < n) {
 		dinfo->ring_head = INREG(PRI_RING_HEAD) & RING_HEAD_MASK;
-		if (dinfo->ring_tail + RING_MIN_FREE < dinfo->ring_head)
-			dinfo->ring_space = dinfo->ring_head
-				- (dinfo->ring_tail + RING_MIN_FREE);
-		else
-			dinfo->ring_space = (dinfo->ring.size +
-					     dinfo->ring_head)
-				- (dinfo->ring_tail + RING_MIN_FREE);
+		dinfo->ring_space = get_ring_space(dinfo);
+
 		if (dinfo->ring_head != last_head) {
 			end = jiffies + (HZ * 3);
 			last_head = dinfo->ring_head;
@@ -1513,12 +1526,7 @@ refresh_ring(struct intelfb_info *dinfo)
 
 	dinfo->ring_head = INREG(PRI_RING_HEAD) & RING_HEAD_MASK;
 	dinfo->ring_tail = INREG(PRI_RING_TAIL) & RING_TAIL_MASK;
-	if (dinfo->ring_tail + RING_MIN_FREE < dinfo->ring_head)
-		dinfo->ring_space = dinfo->ring_head
-			- (dinfo->ring_tail + RING_MIN_FREE);
-	else
-		dinfo->ring_space = (dinfo->ring.size + dinfo->ring_head)
-			- (dinfo->ring_tail + RING_MIN_FREE);
+	dinfo->ring_space = get_ring_space(dinfo);
 }
 
 static void
_

Patches currently in -mm which might be from juergen.orczykowski@siemens.com are

origin.patch
