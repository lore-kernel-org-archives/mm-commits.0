From: akpm@linux-foundation.org
Subject: + drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks.patch added to -mm tree
Date: Tue, 02 Dec 2008 22:12:24 -0800
Message-ID: <200812030612.mB36COH2004970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbYLCGMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 01:12:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: impulze@impulze.org, dtor@mail.ru


The patch titled
     drivers/input/keyboard/atkbd.c: Fujitsu Siemens Amilo PA 1510 quirks
has been added to the -mm tree.  Its filename is
     drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks.patch

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
Subject: drivers/input/keyboard/atkbd.c: Fujitsu Siemens Amilo PA 1510 quirks
From: Daniel Mierswa <impulze@impulze.org>

The volume up and down keys on the Fujitsu Siemens Amilo PA 1510 laptop
won't generate release events, so we have to do that. Use the same
way that is already used with other models.

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/atkbd.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN drivers/input/keyboard/atkbd.c~drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c~drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks
+++ a/drivers/input/keyboard/atkbd.c
@@ -891,6 +891,20 @@ static void atkbd_inventec_keymap_fixup(
 }
 
 /*
+ * The volume up and volume down special keys on a Fujitsu Amilo PA 1510 laptop
+ * do not generate release events so we have to do it ourselves.
+ */
+static void atkbd_amilopa1510_keymap_fixup(struct atkbd *atkbd)
+{
+	static const unsigned int forced_release_keys[] = {
+		0xb0, 0xae,
+	};
+
+	atkbd_gen_release_event(atkbd, forced_release_keys,
+		ARRAY_SIZE(forced_release_keys));
+}
+
+/*
  * atkbd_set_keycode_table() initializes keyboard's keycode table
  * according to the selected scancode set
  */
@@ -1500,6 +1514,15 @@ static struct dmi_system_id atkbd_dmi_qu
 		.callback = atkbd_setup_fixup,
 		.driver_data = atkbd_inventec_keymap_fixup,
 	},
+	{
+		.ident = "Fujitsu Amilo PA 1510",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pa 1510"),
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_amilopa1510_keymap_fixup,
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from impulze@impulze.org are

drivers-input-keyboard-atkbdc-use-function-for-generation-of-keyrelease-events.patch
drivers-input-keyboard-atkbdc-make-forced_release_keys-static.patch
drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks.patch

