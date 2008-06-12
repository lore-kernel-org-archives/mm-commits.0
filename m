From: akpm@linux-foundation.org
Subject: + input-fix-hp-2133-not-sending-release-event-for-video-switch.patch added to -mm tree
Date: Thu, 12 Jun 2008 11:00:05 -0700
Message-ID: <200806121800.m5CI05gp031613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbYFLSAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 14:00:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz


The patch titled
     input: fix HP 2133 not sending release event for video switch
has been added to the -mm tree.  Its filename is
     input-fix-hp-2133-not-sending-release-event-for-video-switch.patch

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
Subject: input: fix HP 2133 not sending release event for video switch
From: Jiri Kosina <jkosina@suse.cz>

Video switch key on HP 2133 doesn't send release event, so we have to
create workaround similar to what we do for Dell Latitude, i.e.  perform
DMI match for the system and generate 'false' release event ourselves, so
that userspace doesn't think that the key is stuck forever.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/atkbd.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN drivers/input/keyboard/atkbd.c~input-fix-hp-2133-not-sending-release-event-for-video-switch drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c~input-fix-hp-2133-not-sending-release-event-for-video-switch
+++ a/drivers/input/keyboard/atkbd.c
@@ -851,6 +851,23 @@ static void atkbd_latitude_keymap_fixup(
 }
 
 /*
+ * Perform fixup for HP system that doesn't generate release
+ * for its video switch
+ */
+static void atkbd_hp_keymap_fixup(struct atkbd *atkbd)
+{
+	const unsigned int forced_release_keys[] = {
+		0x94,
+	};
+	int i;
+
+	if (atkbd->set == 2)
+		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
+			__set_bit(forced_release_keys[i],
+					atkbd->force_release_mask);
+}
+
+/*
  * atkbd_set_keycode_table() initializes keyboard's keycode table
  * according to the selected scancode set
  */
@@ -1452,6 +1469,15 @@ static struct dmi_system_id atkbd_dmi_qu
 		.callback = atkbd_setup_fixup,
 		.driver_data = atkbd_latitude_keymap_fixup,
 	},
+	{
+		.ident = "HP 2133",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP 2133"),
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_hp_keymap_fixup,
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
elantech-touchpad-driver.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-fix-hp-2133-not-sending-release-event-for-video-switch.patch
input-add-retry-logic-to-resume-with-respect-to-ctr.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch

