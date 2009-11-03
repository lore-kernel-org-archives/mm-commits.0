From: akpm@linux-foundation.org
Subject: + block-ps3-fix-slow-vram-io.patch added to -mm tree
Date: Tue, 03 Nov 2009 00:24:29 -0800
Message-ID: <200911030824.nA38OTRO019584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbZKCI0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 03:26:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Hideyuki_Sasaki@hq.scei.sony.co.jp, Geert.Uytterhoeven@sonycom.com, geoffrey.levand@am.sony.com, jens.axboe@oracle.com, jim@jtan.com, xhide@rd.scei.sony.co.jp


The patch titled
     block/ps3: fix slow VRAM IO
has been added to the -mm tree.  Its filename is
     block-ps3-fix-slow-vram-io.patch

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
Subject: block/ps3: fix slow VRAM IO
From: Hideyuki Sasaki <Hideyuki_Sasaki@hq.scei.sony.co.jp>

The current PS3 VRAM driver uses msleep() to wait for completion of RSX
DMA transfers between system memory and VRAM.  Depending on the system
timing, the processing delay and overhead of this msleep() call can
significantly impact VRAM driver IO.

To avoid the condition, add a short duration (200 usec max) udelay()
polling loop before entering the msleep() polling loop.

Signed-off-by: Hideyuki Sasaki <xhide@rd.scei.sony.co.jp>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-by: Jim Paris <jim@jtan.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/ps3vram.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/block/ps3vram.c~block-ps3-fix-slow-vram-io drivers/block/ps3vram.c
--- a/drivers/block/ps3vram.c~block-ps3-fix-slow-vram-io
+++ a/drivers/block/ps3vram.c
@@ -123,7 +123,15 @@ static int ps3vram_notifier_wait(struct 
 {
 	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
 	u32 *notify = ps3vram_get_notifier(priv->reports, NOTIFIER);
-	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
+	unsigned long timeout;
+
+	for (timeout = 20; timeout; timeout--) {
+		if (!notify[3])
+			return 0;
+		udelay(10);
+	}
+
+	timeout = jiffies + msecs_to_jiffies(timeout_ms);
 
 	do {
 		if (!notify[3])
_

Patches currently in -mm which might be from Hideyuki_Sasaki@hq.scei.sony.co.jp are

block-ps3-fix-slow-vram-io.patch

