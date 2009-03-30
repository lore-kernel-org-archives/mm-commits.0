From: akpm@linux-foundation.org
Subject: [merged] hp-wmi-notify-of-a-potential-docking-state-change-on-resume.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:05:27 -0700
Message-ID: <200903301905.n2UJ5R7T018668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759342AbZC3TJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:09:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, lenb@kernel.org, mjg59@srcf.ucam.org, mm-commits@vger.kernel.org


The patch titled
     hp-wmi: notify of a potential docking state change on resume
has been removed from the -mm tree.  Its filename was
     hp-wmi-notify-of-a-potential-docking-state-change-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp-wmi: notify of a potential docking state change on resume
From: Frans Pop <elendil@planet.nl>

It is possible that the system gets docked or undocked while it's
suspended. Generate an input event on resume to notify user space
if there was a state change.

As it is a switch, we can generate the event unconditionally; the
input layer will only pass it on if there is an actual change.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-notify-of-a-potential-docking-state-change-on-resume drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-notify-of-a-potential-docking-state-change-on-resume
+++ a/drivers/platform/x86/hp-wmi.c
@@ -53,6 +53,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE9
 
 static int __init hp_wmi_bios_setup(struct platform_device *device);
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
+static int hp_wmi_resume_handler(struct platform_device *device);
 
 struct bios_args {
 	u32 signature;
@@ -101,6 +102,7 @@ static struct platform_driver hp_wmi_dri
 	},
 	.probe = hp_wmi_bios_setup,
 	.remove = hp_wmi_bios_remove,
+	.resume = hp_wmi_resume_handler,
 };
 
 static int hp_wmi_perform_query(int query, int write, int value)
@@ -487,6 +489,29 @@ static int __exit hp_wmi_bios_remove(str
 	return 0;
 }
 
+static int hp_wmi_resume_handler(struct platform_device *device)
+{
+	struct key_entry *key;
+
+	/*
+	 * Docking state may have changed while suspended, so trigger
+	 * an input event for the current state. As this is a switch,
+	 * the input layer will only actually pass it on if the state
+	 * changed.
+	 */
+	for (key = hp_wmi_keymap; key->type != KE_END; key++) {
+		switch (key->type) {
+		case KE_SW:
+			input_report_switch(hp_wmi_input_dev, key->keycode,
+					    hp_wmi_dock_state());
+			input_sync(hp_wmi_input_dev);
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static int __init hp_wmi_init(void)
 {
 	int err;
_

Patches currently in -mm which might be from elendil@planet.nl are

origin.patch
linux-next.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch

