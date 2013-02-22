From: akpm@linux-foundation.org
Subject: [merged] fbcon-clear-the-logo-bitmap-from-the-margin-area.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:51 -0800
Message-ID: <20130222203751.B983E31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34317 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab3BVUhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:52 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103228vbi.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamal@whence.com, FlorianSchandinat@gmx.de, tomi.valkeinen@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fbcon: clear the logo bitmap from the margin area
has been removed from the -mm tree.  Its filename was
     fbcon-clear-the-logo-bitmap-from-the-margin-area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kamal Mostafa <kamal@whence.com>
Subject: fbcon: clear the logo bitmap from the margin area

Explicitly clear_margins when clearing the logo, in case the font dimensions
are non-integral to the framebuffer dimensions.

Signed-off-by: Kamal Mostafa <kamal@whence.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-clear-the-logo-bitmap-from-the-margin-area drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-clear-the-logo-bitmap-from-the-margin-area
+++ a/drivers/video/console/fbcon.c
@@ -1242,8 +1242,16 @@ static void fbcon_clear(struct vc_data *
 	if (!height || !width)
 		return;
 
-	if (sy < vc->vc_top && vc->vc_top == logo_lines)
+	if (sy < vc->vc_top && vc->vc_top == logo_lines) {
 		vc->vc_top = 0;
+		/*
+		 * If the font dimensions are not an integral of the display
+		 * dimensions then the ops->clear below won't end up clearing
+		 * the margins.  Call clear_margins here in case the logo
+		 * bitmap stretched into the margin area.
+		 */
+		fbcon_clear_margins(vc, 0);
+	}
 
 	/* Split blits that cross physical y_wrap boundary */
 
_

Patches currently in -mm which might be from kamal@whence.com are

origin.patch

