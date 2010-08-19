From: akpm@linux-foundation.org
Subject: + hp_accel-add-quirks-for-hp-probook-532x-and-hp-mini-5102.patch added to -mm tree
Date: Thu, 19 Aug 2010 16:19:23 -0700
Message-ID: <201008192319.o7JNJNDk014339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133Ab0HSXTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 19:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, eric.piel@tremplin-utc.net, stable@kernel.org


The patch titled
     hp_accel: add quirks for HP ProBook 532x and HP Mini 5102
has been added to the -mm tree.  Its filename is
     hp_accel-add-quirks-for-hp-probook-532x-and-hp-mini-5102.patch

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
Subject: hp_accel: add quirks for HP ProBook 532x and HP Mini 5102
From: Takashi Iwai <tiwai@suse.de>

Added missing axis-mapping for HP ProBook 532x and HP Mini 5102.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/hwmon/hp_accel.c~hp_accel-add-quirks-for-hp-probook-532x-and-hp-mini-5102 drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~hp_accel-add-quirks-for-hp-probook-532x-and-hp-mini-5102
+++ a/drivers/hwmon/hp_accel.c
@@ -221,6 +221,8 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("HPB442x", "HP ProBook 442", xy_rotated_left),
 	AXIS_DMI_MATCH("HPB452x", "HP ProBook 452", y_inverted),
 	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
+	AXIS_DMI_MATCH("HPB532x", "HP ProBook 532", y_inverted),
+	AXIS_DMI_MATCH("Mini5102", "HP Mini 5102", xy_rotated_left_usd),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
hp_accel-add-quirks-for-hp-probook-532x-and-hp-mini-5102.patch

