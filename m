From: akpm@google.com
Subject: + backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity.patch added to -mm tree
Date: Mon, 26 Sep 2011 16:25:42 -0700
Message-ID: <201109262325.p8QNPgvO029347@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29339 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1IZXZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2011 19:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: rename corgibl_limit_intensity() to genericbl_limit_intensity()
has been added to the -mm tree.  Its filename is
     backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity.patch

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
From: Axel Lin <axel.lin@gmail.com>
Subject: backlight: rename corgibl_limit_intensity() to genericbl_limit_intensity()

The rename of corgibl_limit_intensity is missed in commit d00ba726
("backlight: Rename the corgi backlight driver to generic").  Let's fix it
now.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: backlight: rename corgibl_limit_intensity() to genericbl_limit_intensity()

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

