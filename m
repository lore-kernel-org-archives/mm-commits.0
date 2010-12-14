From: akpm@linux-foundation.org
Subject: + backlight-cr_bllcdc-fix-a-memory-leak.patch added to -mm tree
Date: Mon, 13 Dec 2010 16:50:49 -0800
Message-ID: <201012140050.oBE0onO4022242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757983Ab0LNAvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 19:51:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, alanh@tungstengraphics.com, rpurdie@rpsys.net, thomas@tungstengraphics.com


The patch titled
     backlight: cr_bllcd.c: fix a memory leak
has been added to the -mm tree.  Its filename is
     backlight-cr_bllcdc-fix-a-memory-leak.patch

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
Subject: backlight: cr_bllcd.c: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: Alan Hourihane <alanh@tungstengraphics.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/cr_bllcd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/cr_bllcd.c~backlight-cr_bllcdc-fix-a-memory-leak drivers/video/backlight/cr_bllcd.c
--- a/drivers/video/backlight/cr_bllcd.c~backlight-cr_bllcdc-fix-a-memory-leak
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -242,6 +242,7 @@ static int cr_backlight_remove(struct pl
 	backlight_device_unregister(crp->cr_backlight_device);
 	lcd_device_unregister(crp->cr_lcd_device);
 	pci_dev_put(lpc_dev);
+	kfree(crp);
 
 	return 0;
 }
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
backlight-cr_bllcdc-fix-a-memory-leak.patch
drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable.patch
drivers-rtc-rtc-omapc-fix-a-memory-leak.patch

