From: akpm@linux-foundation.org
Subject: + synclink_gt-add-rx-dma-buffer-fill-level-control-fix-locking-in-error-path-of-rx-enable.patch added to -mm tree
Date: Fri, 18 Jul 2008 14:46:49 -0700
Message-ID: <200807182146.m6ILknup032430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499AbYGRVrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 17:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk


The patch titled
     synclink_gt fix locking in error path of rx enable
has been added to the -mm tree.  Its filename is
     synclink_gt-add-rx-dma-buffer-fill-level-control-fix-locking-in-error-path-of-rx-enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt fix locking in error path of rx enable
From: Paul Fulghum <paulkf@microgate.com>

Fix locking in error path of rx_enable() introduced by
synclink_gt-add-rx-dma-buffer-fill-level-control patch.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-add-rx-dma-buffer-fill-level-control-fix-locking-in-error-path-of-rx-enable drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-add-rx-dma-buffer-fill-level-control-fix-locking-in-error-path-of-rx-enable
+++ a/drivers/char/synclink_gt.c
@@ -2693,8 +2693,10 @@ static int rx_enable(struct slgt_info *i
 	 */
 	rbuf_fill_level = ((unsigned int)enable) >> 16;
 	if (rbuf_fill_level) {
-		if ((rbuf_fill_level > DMABUFSIZE) || (rbuf_fill_level % 4))
+		if ((rbuf_fill_level > DMABUFSIZE) || (rbuf_fill_level % 4)) {
+			spin_unlock_irqrestore(&info->lock, flags);
 			return -EINVAL;
+		}
 		info->rbuf_fill_level = rbuf_fill_level;
 		rx_stop(info); /* restart receiver to use new fill level */
 	}
_

Patches currently in -mm which might be from paulkf@microgate.com are

n_hdlc-honor-o_nonblock-on-write.patch
synclink_gt-leave-transmitter-in-reset-state-after-configuration.patch
synclink_gt-add-rx-dma-buffer-fill-level-control.patch
synclink_gt-add-rx-dma-buffer-fill-level-control-fix-locking-in-error-path-of-rx-enable.patch
synclink_gt-add-serial-bit-order-control.patch
synclink_gt-improve-tiocoutq-accuracy.patch
synclink_gt-improve-and-simplify-write-method.patch

