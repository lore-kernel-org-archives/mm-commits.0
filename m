From: akpm@linux-foundation.org
Subject: [merged] drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:13 -0800
Message-ID: <200903061928.n26JSDh9022662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318AbZCFT2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:28:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: impulze@impulze.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/input/keyboard/atkbd.c: Fujitsu Siemens Amilo PA 1510 quirks
has been removed from the -mm tree.  Its filename was
     drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -924,6 +924,20 @@ static void atkbd_samsung_keymap_fixup(s
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
@@ -1560,6 +1574,15 @@ static struct dmi_system_id atkbd_dmi_qu
 		.callback = atkbd_setup_fixup,
 		.driver_data = atkbd_samsung_keymap_fixup,
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

linux-next.patch

