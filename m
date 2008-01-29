From: akpm@linux-foundation.org
Subject: - tcm825xfix-logical-typo-error.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:48:39 -0800
Message-ID: <200801290148.m0T1mdUG027366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbYA2B7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, g.liakhovetski@pengutronix.de, mchehab@infradead.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     tcm825x:fix logical typo error
has been removed from the -mm tree.  Its filename was
     tcm825xfix-logical-typo-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-powerpc.patch
git-dvb.patch
wireless-iwlwifi3945-4965-fix-incorrect-counting-of-memory.patch
git-x86.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
