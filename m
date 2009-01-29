From: akpm@linux-foundation.org
Subject: + hp-wmi-set-initial-docking-state.patch added to -mm tree
Date: Wed, 28 Jan 2009 17:03:06 -0800
Message-ID: <200901290103.n0T136qF025245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757909AbZA2BDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 20:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, mjg59@srcf.ucam.org


The patch titled
     hp-wmi: set initial docking state
has been added to the -mm tree.  Its filename is
     hp-wmi-set-initial-docking-state.patch

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
Subject: hp-wmi: set initial docking state
From: Frans Pop <elendil@planet.nl>

If the initial state is not set when the input device is set up, the first
docking event after the module is loaded will be lost.

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-set-initial-docking-state drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-set-initial-docking-state
+++ a/drivers/platform/x86/hp-wmi.c
@@ -382,6 +382,11 @@ static int __init hp_wmi_input_setup(voi
 		case KE_SW:
 			set_bit(EV_SW, hp_wmi_input_dev->evbit);
 			set_bit(key->keycode, hp_wmi_input_dev->swbit);
+
+			/* Set initial dock state */
+			input_report_switch(hp_wmi_input_dev, key->keycode,
+					    hp_wmi_dock_state());
+			input_sync(hp_wmi_input_dev);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from elendil@planet.nl are

hp-wmi-fix-regressions-caused-by-missing-if-statement.patch
hp-wmi-set-initial-docking-state.patch
input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
sata-ahci-blacklist-system-that-spins-off-disks-during-acpi-power-off.patch

