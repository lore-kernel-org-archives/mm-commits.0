From: akpm@linux-foundation.org
Subject: [folded] loop-add-ioctl-to-resize-a-loop-device-security-check-for-loop_set_capacity.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:03:01 -0700
Message-ID: <200903312203.n2VM31st016315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758258AbZCaWEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:04:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hooanon05@yahoo.co.jp, mm-commits@vger.kernel.org


The patch titled
     security check for LOOP_SET_CAPACITY
has been removed from the -mm tree.  Its filename was
     loop-add-ioctl-to-resize-a-loop-device-security-check-for-loop_set_capacity.patch

This patch was dropped because it was folded into loop-add-ioctl-to-resize-a-loop-device.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security check for LOOP_SET_CAPACITY
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>

Respoding the comment from Linus Torvalds, LOOP_SET_CAPACITY now
requires the device file to be opened for write or CAP_SYS_ADMIN.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/block/loop.c~loop-add-ioctl-to-resize-a-loop-device-security-check-for-loop_set_capacity drivers/block/loop.c
--- a/drivers/block/loop.c~loop-add-ioctl-to-resize-a-loop-device-security-check-for-loop_set_capacity
+++ a/drivers/block/loop.c
@@ -1210,7 +1210,9 @@ static int lo_ioctl(struct block_device 
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
 		break;
 	case LOOP_SET_CAPACITY:
-		err = loop_set_capacity(lo, bdev);
+		err = -EPERM;
+		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_capacity(lo, bdev);
 		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
_

Patches currently in -mm which might be from hooanon05@yahoo.co.jp are

loop-add-ioctl-to-resize-a-loop-device.patch
loop-add-ioctl-to-resize-a-loop-device-security-check-for-loop_set_capacity.patch
loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit.patch

