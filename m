From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-gspca-cpia1c-fix-error-check.patch removed from -mm tree
Date: Tue, 23 Nov 2010 12:05:20 -0800
Message-ID: <201011232009.oANK9VmI003405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab0KWUJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Nov 2010 15:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nikai@nikai.net, mchehab@infradead.org, moinejf@free.fr, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/gspca/cpia1.c: fix error check
has been removed from the -mm tree.  Its filename was
     drivers-media-video-gspca-cpia1c-fix-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/gspca/cpia1.c: fix error check
From: Nicolas Kaiser <nikai@nikai.net>

It looks to me like it was intended to check the return value at this
point.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/cpia1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/gspca/cpia1.c~drivers-media-video-gspca-cpia1c-fix-error-check drivers/media/video/gspca/cpia1.c
--- a/drivers/media/video/gspca/cpia1.c~drivers-media-video-gspca-cpia1c-fix-error-check
+++ a/drivers/media/video/gspca/cpia1.c
@@ -829,7 +829,7 @@ static int goto_low_power(struct gspca_d
 	if (ret)
 		return ret;
 
-	do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
+	ret = do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from nikai@nikai.net are

linux-next.patch

