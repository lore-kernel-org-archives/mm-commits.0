From: akpm@linux-foundation.org
Subject: + loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit.patch added to -mm tree
Date: Mon, 12 Jan 2009 16:46:20 -0800
Message-ID: <200901130046.n0D0kKrU016879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbZAMAqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 19:46:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hooanon05@yahoo.co.jp


The patch titled
     LOOP_SET_CAPACITY sector_t may be narrow for bit-shfit
has been added to the -mm tree.  Its filename is
     loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit.patch

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
loop-add-ioctl-to-resize-a-loop-device-security-check-for-loop_set_capacity.patch
loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit.patch

