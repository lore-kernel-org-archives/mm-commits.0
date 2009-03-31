From: akpm@linux-foundation.org
Subject: [folded] loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:03:03 -0700
Message-ID: <200903312203.n2VM33rT016324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762316AbZCaWEu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:04:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hooanon05@yahoo.co.jp, mm-commits@vger.kernel.org


The patch titled
     LOOP_SET_CAPACITY sector_t may be narrow for bit-shfit
has been removed from the -mm tree.  Its filename was
     loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit.patch

This patch was dropped because it was folded into loop-add-ioctl-to-resize-a-loop-device.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: LOOP_SET_CAPACITY sector_t may be narrow for bit-shfit
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>

Fixing the bug pointed out by Andrew Morton, shift loff_t instead of
sector_t since sector_t may be 32-bit.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/block/loop.c~loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit drivers/block/loop.c
--- a/drivers/block/loop.c~loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit
+++ a/drivers/block/loop.c
@@ -1171,7 +1171,9 @@ static int loop_set_capacity(struct loop
 	if (unlikely(err))
 		goto out;
 	sec = get_capacity(lo->lo_disk);
-	sz = sec << 9;
+	/* the width of sector_t may be narrow for bit-shift */
+	sz = sec;
+	sz <<= 9;
 	mutex_lock(&bdev->bd_mutex);
 	bd_set_size(bdev, sz);
 	mutex_unlock(&bdev->bd_mutex);
_

Patches currently in -mm which might be from hooanon05@yahoo.co.jp are

loop-add-ioctl-to-resize-a-loop-device.patch
loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit.patch

