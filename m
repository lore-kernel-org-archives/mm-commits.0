From: akpm@linux-foundation.org
Subject: [merged] backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:00 -0700
Message-ID: <201111012115.pA1LF0pi015037@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29920 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1KAVPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: rename corgibl_limit_intensity() to genericbl_limit_intensity()
has been removed from the -mm tree.  Its filename was
     backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: backlight: rename corgibl_limit_intensity() to genericbl_limit_intensity()

The rename of corgibl_limit_intensity is missed in commit d00ba726
("backlight: Rename the corgi backlight driver to generic").  Let's fix it
now.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/generic_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/generic_bl.c~backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity drivers/video/backlight/generic_bl.c
--- a/drivers/video/backlight/generic_bl.c~backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity
+++ a/drivers/video/backlight/generic_bl.c
@@ -56,7 +56,7 @@ static int genericbl_get_intensity(struc
  * Called when the battery is low to limit the backlight intensity.
  * If limit==0 clear any limit, otherwise limit the intensity
  */
-void corgibl_limit_intensity(int limit)
+void genericbl_limit_intensity(int limit)
 {
 	struct backlight_device *bd = generic_backlight_device;
 
@@ -68,7 +68,7 @@ void corgibl_limit_intensity(int limit)
 	backlight_update_status(generic_backlight_device);
 	mutex_unlock(&bd->ops_lock);
 }
-EXPORT_SYMBOL(corgibl_limit_intensity);
+EXPORT_SYMBOL(genericbl_limit_intensity);
 
 static const struct backlight_ops genericbl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

