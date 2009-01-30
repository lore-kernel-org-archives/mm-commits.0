From: akpm@linux-foundation.org
Subject: [merged] hp-wmi-set-initial-docking-state.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:14:23 -0800
Message-ID: <200901301914.n0UJENLx027308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbZA3TRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:17:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, mjg59@srcf.ucam.org, mm-commits@vger.kernel.org


The patch titled
     hp-wmi: set initial docking state
has been removed from the -mm tree.  Its filename was
     hp-wmi-set-initial-docking-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch

