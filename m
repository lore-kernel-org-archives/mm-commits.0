From: akpm@linux-foundation.org
Subject: [merged] w1-coding-style-cleanups-in-w1_ioc.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:04 -0700
Message-ID: <200904061937.n36Jb4SU012746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbZDFUFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:05:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: coding style cleanups in w1_io.c
has been removed from the -mm tree.  Its filename was
     w1-coding-style-cleanups-in-w1_ioc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: coding style cleanups in w1_io.c
From: Daniel Mack <daniel@caiaq.de>

This fixes a number of coding style issues I stubled over.

Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_io.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/w1/w1_io.c~w1-coding-style-cleanups-in-w1_ioc drivers/w1/w1_io.c
--- a/drivers/w1/w1_io.c~w1-coding-style-cleanups-in-w1_ioc
+++ a/drivers/w1/w1_io.c
@@ -69,7 +69,7 @@ static u8 w1_touch_bit(struct w1_master 
 		return w1_read_bit(dev);
 	else {
 		w1_write_bit(dev, 0);
-		return(0);
+		return 0;
 	}
 }
 
@@ -184,17 +184,17 @@ static u8 w1_read_bit(struct w1_master *
  */
 u8 w1_triplet(struct w1_master *dev, int bdir)
 {
-	if ( dev->bus_master->triplet )
-		return(dev->bus_master->triplet(dev->bus_master->data, bdir));
+	if (dev->bus_master->triplet)
+		return dev->bus_master->triplet(dev->bus_master->data, bdir);
 	else {
 		u8 id_bit   = w1_touch_bit(dev, 1);
 		u8 comp_bit = w1_touch_bit(dev, 1);
 		u8 retval;
 
-		if ( id_bit && comp_bit )
-			return(0x03);  /* error */
+		if (id_bit && comp_bit)
+			return 0x03;  /* error */
 
-		if ( !id_bit && !comp_bit ) {
+		if (!id_bit && !comp_bit) {
 			/* Both bits are valid, take the direction given */
 			retval = bdir ? 0x04 : 0;
 		} else {
@@ -203,11 +203,11 @@ u8 w1_triplet(struct w1_master *dev, int
 			retval = id_bit ? 0x05 : 0x02;
 		}
 
-		if ( dev->bus_master->touch_bit )
+		if (dev->bus_master->touch_bit)
 			w1_touch_bit(dev, bdir);
 		else
 			w1_write_bit(dev, bdir);
-		return(retval);
+		return retval;
 	}
 }
 
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
linux-next.patch

