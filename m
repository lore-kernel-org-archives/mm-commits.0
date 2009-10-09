From: akpm@linux-foundation.org
Subject: + isp1362-hcd-use-bitmap_find_next_zero_area.patch added to -mm tree
Date: Fri, 09 Oct 2009 16:43:54 -0700
Message-ID: <200910092343.n99NhsgE030676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934613AbZJIXpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 19:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, LW@KARO-electronics.de, gregkh@suse.de


The patch titled
     isp1362-hcd: use bitmap_find_next_zero_area()
has been added to the -mm tree.  Its filename is
     isp1362-hcd-use-bitmap_find_next_zero_area.patch

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
Subject: isp1362-hcd: use bitmap_find_next_zero_area()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lothar Wassmann <LW@KARO-electronics.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/host/isp1362-hcd.c~isp1362-hcd-use-bitmap_find_next_zero_area drivers/usb/host/isp1362-hcd.c
--- a/drivers/usb/host/isp1362-hcd.c~isp1362-hcd-use-bitmap_find_next_zero_area
+++ a/drivers/usb/host/isp1362-hcd.c
@@ -80,7 +80,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/io.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 
 #include <asm/irq.h>
 #include <asm/system.h>
@@ -190,10 +190,8 @@ static int claim_ptd_buffers(struct isp1
 			     struct isp1362_ep *ep, u16 len)
 {
 	int ptd_offset = -EINVAL;
-	int index;
 	int num_ptds = ((len + PTD_HEADER_SIZE - 1) / epq->blk_size) + 1;
-	int found = -1;
-	int last = -1;
+	int found;
 
 	BUG_ON(len > epq->buf_size);
 
@@ -205,20 +203,9 @@ static int claim_ptd_buffers(struct isp1
 		    epq->name, len, epq->blk_size, num_ptds, epq->buf_map, epq->skip_map);
 	BUG_ON(ep->num_ptds != 0);
 
-	for (index = 0; index <= epq->buf_count - num_ptds; index++) {
-		if (test_bit(index, &epq->buf_map))
-			continue;
-		found = index;
-		for (last = index + 1; last < index + num_ptds; last++) {
-			if (test_bit(last, &epq->buf_map)) {
-				found = -1;
-				break;
-			}
-		}
-		if (found >= 0)
-			break;
-	}
-	if (found < 0)
+	found = bitmap_find_next_zero_area(&epq->buf_map, epq->buf_count, 0,
+						num_ptds, 0);
+	if (found >= epq->buf_count)
 		return -EOVERFLOW;
 
 	DBG(1, "%s: Found %d PTDs[%d] for %d/%d byte\n", __func__,
@@ -230,8 +217,7 @@ static int claim_ptd_buffers(struct isp1
 	epq->buf_avail -= num_ptds;
 	BUG_ON(epq->buf_avail > epq->buf_count);
 	ep->ptd_index = found;
-	for (index = found; index < last; index++)
-		__set_bit(index, &epq->buf_map);
+	bitmap_set(&epq->buf_map, found, num_ptds);
 	DBG(1, "%s: Done %s PTD[%d] $%04x, avail %d count %d claimed %d %08lx:%08lx\n",
 	    __func__, epq->name, ep->ptd_index, ep->ptd_offset,
 	    epq->buf_avail, epq->buf_count, num_ptds, epq->buf_map, epq->skip_map);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

iommu-helper-simplify-find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

