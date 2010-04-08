From: akpm@linux-foundation.org
Subject: + lis3-add-support-for-hp-probook-432x-442x-452x-522x.patch added to -mm tree
Date: Thu, 08 Apr 2010 12:49:36 -0700
Message-ID: <201004081949.o38JnbOc004963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933211Ab0DHTuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 15:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, eric.piel@tremplin-utc.net


The patch titled
     lis3: add support for HP ProBook 432x/442x/452x/522x
has been added to the -mm tree.  Its filename is
     lis3-add-support-for-hp-probook-432x-442x-452x-522x.patch

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
Subject: lis3: add support for HP ProBook 432x/442x/452x/522x
From: Takashi Iwai <tiwai@suse.de>

Correct axis-mappings for new HP ProBook laptops.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/hwmon/hp_accel.c~lis3-add-support-for-hp-probook-432x-442x-452x-522x drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-add-support-for-hp-probook-432x-442x-452x-522x
+++ a/drivers/hwmon/hp_accel.c
@@ -217,6 +217,10 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("DV7", "HP Pavilion dv7", x_inverted),
 	AXIS_DMI_MATCH("HP8710", "HP Compaq 8710", y_inverted),
 	AXIS_DMI_MATCH("HDX18", "HP HDX 18", x_inverted),
+	AXIS_DMI_MATCH("HPB432x", "HP ProBook 432", xy_rotated_left),
+	AXIS_DMI_MATCH("HPB442x", "HP ProBook 442", xy_rotated_left),
+	AXIS_DMI_MATCH("HPB452x", "HP ProBook 452", y_inverted),
+	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
lis3-add-support-for-hp-probook-432x-442x-452x-522x.patch

