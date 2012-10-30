From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-lm3639_blc-fix-up-world-writable-sysfs-file.patch added to -mm tree
Date: Tue, 30 Oct 2012 15:05:23 -0700
Message-ID: <20121030220524.02456200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:47076 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272Ab2J3WFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 18:05:25 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so50796wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 15:05:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@ingics.com, gshark.jeong@gmail.com


The patch titled
     Subject: drivers/video/backlight/lm3639_bl.c: fix up world writable sysfs file
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-lm3639_blc-fix-up-world-writable-sysfs-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: drivers/video/backlight/lm3639_bl.c: fix up world writable sysfs file

We don't need the sysfs file to be world writable or group writable.
This file is write-only, change it to S_IWUSR (0200).

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: G.Shark Jeong<gshark.jeong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3639_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lm3639_bl.c~drivers-video-backlight-lm3639_blc-fix-up-world-writable-sysfs-file drivers/video/backlight/lm3639_bl.c
--- a/drivers/video/backlight/lm3639_bl.c~drivers-video-backlight-lm3639_blc-fix-up-world-writable-sysfs-file
+++ a/drivers/video/backlight/lm3639_bl.c
@@ -214,7 +214,7 @@ out_input:
 
 }
 
-static DEVICE_ATTR(bled_mode, 0666, NULL, lm3639_bled_mode_store);
+static DEVICE_ATTR(bled_mode, S_IWUSR, NULL, lm3639_bled_mode_store);
 
 /* torch */
 static void lm3639_torch_brightness_set(struct led_classdev *cdev,
_

Patches currently in -mm which might be from axel.lin@ingics.com are

linux-next.patch
drivers-video-backlight-lm3639_blc-fix-up-world-writable-sysfs-file.patch

