From: akpm@linux-foundation.org
Subject: + backlight-update-backlight-status-when-necessary.patch added to -mm tree
Date: Mon, 03 Feb 2014 16:49:38 -0800
Message-ID: <52f03922.+gsiWmjOnusRlAwp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaBDAtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 19:49:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, jg1.han@samsung.com, jani.nikula@linux.intel.com, Ying.Liu@freescale.com

Subject: + backlight-update-backlight-status-when-necessary.patch added to -mm tree
To: Ying.Liu@freescale.com,jani.nikula@linux.intel.com,jg1.han@samsung.com,plagnioj@jcrosoft.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 16:49:38 -0800


The patch titled
     Subject: backlight: update backlight status when necessary
has been added to the -mm tree.  Its filename is
     backlight-update-backlight-status-when-necessary.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-update-backlight-status-when-necessary.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-update-backlight-status-when-necessary.patch

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
Subject: backlight: update backlight status when necessary

We don't have to update a backlight status every time a blanking or
unblanking event comes because the backlight status may have already been
what we want.  Another thought is that one backlight device may be shared
by multiple framebuffers.  We don't hope blanking one of the framebuffers
may turn the backlight off for all the other framebuffers, since they are
likely being active to display something.

This patch makes the backlight status be updated only when the relevant
backlight device's use count changes from zero to one or from one to zero.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-update-backlight-status-when-necessary drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-update-backlight-status-when-necessary
+++ a/drivers/video/backlight/backlight.c
@@ -34,7 +34,7 @@ static const char *const backlight_types
 			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
 /* This callback gets called when something important happens inside a
  * framebuffer driver. We're looking if that important event is blanking,
- * and if it is, we're switching backlight power as well ...
+ * and if it is and necessary, we're switching backlight power as well ...
  */
 static int fb_notifier_callback(struct notifier_block *self,
 				unsigned long event, void *data)
@@ -60,6 +60,7 @@ static int fb_notifier_callback(struct n
 				if (!bd->use_count++) {
 					bd->props.state &= ~BL_CORE_FBBLANK;
 					bd->props.fb_blank = FB_BLANK_UNBLANK;
+					backlight_update_status(bd);
 				}
 			} else if (fb_blank != FB_BLANK_UNBLANK &&
 				   bd->fb_bl_on[node]) {
@@ -67,9 +68,9 @@ static int fb_notifier_callback(struct n
 				if (!(--bd->use_count)) {
 					bd->props.state |= BL_CORE_FBBLANK;
 					bd->props.fb_blank = fb_blank;
+					backlight_update_status(bd);
 				}
 			}
-			backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
 	return 0;
_

Patches currently in -mm which might be from Ying.Liu@freescale.com are

backlight-update-bd-state-fb_blank-properties-when-necessary.patch
backlight-update-backlight-status-when-necessary.patch
linux-next.patch

