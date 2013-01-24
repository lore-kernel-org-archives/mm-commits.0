From: akpm@linux-foundation.org
Subject: + fbcon-clear-the-logo-bitmap-from-the-margin-area.patch added to -mm tree
Date: Thu, 24 Jan 2013 15:37:11 -0800
Message-ID: <20130124233711.E06D95A4129@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:33394 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3AXXhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 18:37:13 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so1141542yen.3
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 15:37:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamal@whence.com, FlorianSchandinat@gmx.de, tomi.valkeinen@ti.com


The patch titled
     Subject: fbcon: clear the logo bitmap from the margin area
has been added to the -mm tree.  Its filename is
     fbcon-clear-the-logo-bitmap-from-the-margin-area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1269,8 +1269,16 @@ static void fbcon_clear(struct vc_data *
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

fbcon-clear-the-logo-bitmap-from-the-margin-area.patch

