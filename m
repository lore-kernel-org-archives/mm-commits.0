From: akpm@linux-foundation.org
Subject: + fbcon-delete-unneeded-function-fbcon_takeover.patch added to
 -mm tree
Date: Tue, 21 May 2013 15:27:35 -0700
Message-ID: <519bf4d7.0rGQ5n/kcT0uEtW2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3EUW1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 18:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, tiwai@suse.de, sedat.dilek@gmail.com, maarten.lankhorst@canonical.com, jslaby@suse.cz, huax.lu@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, airlied@linux.ie, FlorianSchandinat@gmx.de, udknight@gmail.com

Subject: + fbcon-delete-unneeded-function-fbcon_takeover.patch added to -mm tree
To: udknight@gmail.com,FlorianSchandinat@gmx.de,airlied@linux.ie,daniel.vetter@ffwll.ch,greg@kroah.com,huax.lu@intel.com,jslaby@suse.cz,maarten.lankhorst@canonical.com,sedat.dilek@gmail.com,tiwai@suse.de,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 15:27:35 -0700


The patch titled
     Subject: fbcon: delete unneeded function fbcon_takeover
has been added to the -mm tree.  Its filename is
     fbcon-delete-unneeded-function-fbcon_takeover.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: fbcon: delete unneeded function fbcon_takeover

Now there is no place use fbcon_takeover, and fbcon_takeover has huge
duplication code with do_fbcon_takeover, we can achieve fbcon_takeover's
function with do_fbcon_takeover easily, so we can just delete it.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Lu Hua <huax.lu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-delete-unneeded-function-fbcon_takeover drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-delete-unneeded-function-fbcon_takeover
+++ a/drivers/video/console/fbcon.c
@@ -556,34 +556,6 @@ static int do_fbcon_takeover(int show_lo
 	return err;
 }
 
-static int fbcon_takeover(int show_logo)
-{
-	int err, i;
-
-	if (!num_registered_fb)
-		return -ENODEV;
-
-	if (!show_logo)
-		logo_shown = FBCON_LOGO_DONTSHOW;
-
-	for (i = first_fb_vc; i <= last_fb_vc; i++)
-		con2fb_map[i] = info_idx;
-
-	err = take_over_console(&fb_con, first_fb_vc, last_fb_vc,
-				fbcon_is_default);
-
-	if (err) {
-		for (i = first_fb_vc; i <= last_fb_vc; i++) {
-			con2fb_map[i] = -1;
-		}
-		info_idx = -1;
-	} else {
-		fbcon_has_console_bind = 1;
-	}
-
-	return err;
-}
