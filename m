From: akpm@linux-foundation.org
Subject: +
 backlight-update-bd-state-fb_blank-properties-when-necessary.patch added to -mm tree
Date: Mon, 03 Feb 2014 16:49:37 -0800
Message-ID: <52f03921.qyQOHDv50UaXLn3q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaBDAti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 19:49:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, jg1.han@samsung.com, jani.nikula@linux.intel.com, Ying.Liu@freescale.com

Subject: + backlight-update-bd-state-fb_blank-properties-when-necessary.patch added to -mm tree
To: Ying.Liu@freescale.com,jani.nikula@linux.intel.com,jg1.han@samsung.com,plagnioj@jcrosoft.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 16:49:37 -0800


The patch titled
     Subject: backlight: update bd state & fb_blank properties when necessary
has been added to the -mm tree.  Its filename is
     backlight-update-bd-state-fb_blank-properties-when-necessary.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-update-bd-state-fb_blank-properties-when-necessary.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-update-bd-state-fb_blank-properties-when-necessary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Ying <Ying.Liu@freescale.com>
Subject: backlight: update bd state & fb_blank properties when necessary

We don't have to update the state and fb_blank properties of a backlight
device every time a blanking or unblanking event comes because they may
have already been what we want.  Another thought is that one backlight
device may be shared by multiple framebuffers.  The backlight driver
should take the backlight device as a resource shared by all the
associated framebuffers.

This patch adds some logic to record each framebuffer's backlight usage to
determine the backlight device use count and whether the two properties
should be updated or not.  To be more specific, only one unblank operation
on a certain blanked framebuffer may increase the backlight device's use
count by one, while one blank operation on a certain unblanked framebuffer
may decrease the use count by one, because the userspace is likely to
unblank an unblanked framebuffer or blank a blanked framebuffer.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |   23 ++++++++++++++++++-----
 include/linux/backlight.h           |    6 ++++++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-update-bd-state-fb_blank-properties-when-necessary drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-update-bd-state-fb_blank-properties-when-necessary
+++ a/drivers/video/backlight/backlight.c
@@ -41,6 +41,8 @@ static int fb_notifier_callback(struct n
 {
 	struct backlight_device *bd;
 	struct fb_event *evdata = data;
+	int node = evdata->info->node;
+	int fb_blank = 0;
 
 	/* If we aren't interested in this event, skip it immediately ... */
 	if (event != FB_EVENT_BLANK && event != FB_EVENT_CONBLANK)
@@ -51,11 +53,22 @@ static int fb_notifier_callback(struct n
 	if (bd->ops)
 		if (!bd->ops->check_fb ||
 		    bd->ops->check_fb(bd, evdata->info)) {
-			bd->props.fb_blank = *(int *)evdata->data;
-			if (bd->props.fb_blank == FB_BLANK_UNBLANK)
-				bd->props.state &= ~BL_CORE_FBBLANK;
-			else
-				bd->props.state |= BL_CORE_FBBLANK;
+			fb_blank = *(int *)evdata->data;
+			if (fb_blank == FB_BLANK_UNBLANK &&
+			    !bd->fb_bl_on[node]) {
+				bd->fb_bl_on[node] = true;
+				if (!bd->use_count++) {
+					bd->props.state &= ~BL_CORE_FBBLANK;
+					bd->props.fb_blank = FB_BLANK_UNBLANK;
+				}
+			} else if (fb_blank != FB_BLANK_UNBLANK &&
+				   bd->fb_bl_on[node]) {
+				bd->fb_bl_on[node] = false;
+				if (!(--bd->use_count)) {
+					bd->props.state |= BL_CORE_FBBLANK;
+					bd->props.fb_blank = fb_blank;
+				}
+			}
 			backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
diff -puN include/linux/backlight.h~backlight-update-bd-state-fb_blank-properties-when-necessary include/linux/backlight.h
--- a/include/linux/backlight.h~backlight-update-bd-state-fb_blank-properties-when-necessary
+++ a/include/linux/backlight.h
@@ -9,6 +9,7 @@
 #define _LINUX_BACKLIGHT_H
 
 #include <linux/device.h>
+#include <linux/fb.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 
@@ -104,6 +105,11 @@ struct backlight_device {
 	struct list_head entry;
 
 	struct device dev;
+
+	/* Multiple framebuffers may share one backlight device */
+	bool fb_bl_on[FB_MAX];
+
+	int use_count;
 };
 
 static inline void backlight_update_status(struct backlight_device *bd)
_

Patches currently in -mm which might be from Ying.Liu@freescale.com are

backlight-update-bd-state-fb_blank-properties-when-necessary.patch
backlight-update-backlight-status-when-necessary.patch
linux-next.patch

