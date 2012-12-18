From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-lm3639_blc-fix-up-world-writable-sysfs-file.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:30 -0800
Message-ID: <20121218200530.AAFB782004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:63873 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUFb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:31 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so158565qad.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@ingics.com, gshark.jeong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lm3639_bl.c: fix up world writable sysfs file
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lm3639_blc-fix-up-world-writable-sysfs-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: drivers/video/backlight/lm3639_bl.c: fix up world writable sysfs file

We don't need the sysfs file to be world writable or group writable.
This file is write-only, change it to S_IWUSR (0200).

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: "G.Shark Jeong" <gshark.jeong@gmail.com>
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

origin.patch
linux-next.patch

