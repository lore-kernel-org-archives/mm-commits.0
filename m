From: akpm@linux-foundation.org
Subject: + tcm825xfix-logical-typo-error.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:08:22 -0800
Message-ID: <200801270508.m0R58J79030747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbYA0FJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:09:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, g.liakhovetski@pengutronix.de, mchehab@infradead.org, stable@kernel.org


The patch titled
     tcm825x:fix logical typo error
has been added to the -mm tree.  Its filename is
     tcm825xfix-logical-typo-error.patch

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
Subject: tcm825x:fix logical typo error
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix potential NULL pointer dereference due to logical typo error.

The issue is pointed out by Guennadi Liakhovetski.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/tcm825x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/tcm825x.c~tcm825xfix-logical-typo-error drivers/media/video/tcm825x.c
--- a/drivers/media/video/tcm825x.c~tcm825xfix-logical-typo-error
+++ a/drivers/media/video/tcm825x.c
@@ -851,7 +851,7 @@ static int tcm825x_probe(struct i2c_clie
 	sensor->platform_data = client->dev.platform_data;
 
 	if (sensor->platform_data == NULL
-	    && !sensor->platform_data->is_okay())
+	    || !sensor->platform_data->is_okay())
 		return -ENODEV;
 
 	sensor->v4l2_int_device = &tcm825x_int_device;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

cris-add-missed-local_irq_restore-call.patch
git-powerpc.patch
tcm825xfix-logical-typo-error.patch
git-x86.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
