From: akpm@linux-foundation.org
Subject: [merged] hp_accel-add-axis-mapping-for-hp-probook-elitebook.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:17:10 -0700
Message-ID: <201111012117.pA1LHALd019379@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hp_accel: Add axis-mapping for HP ProBook / EliteBook
has been removed from the -mm tree.  Its filename was
     hp_accel-add-axis-mapping-for-hp-probook-elitebook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Takashi Iwai <tiwai@suse.de>
Subject: hp_accel: Add axis-mapping for HP ProBook / EliteBook

Add the corrected axis-mapping for some HP laptops.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp_accel.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/platform/x86/hp_accel.c~hp_accel-add-axis-mapping-for-hp-probook-elitebook drivers/platform/x86/hp_accel.c
--- a/drivers/platform/x86/hp_accel.c~hp_accel-add-axis-mapping-for-hp-probook-elitebook
+++ a/drivers/platform/x86/hp_accel.c
@@ -229,6 +229,10 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
 	AXIS_DMI_MATCH("HPB532x", "HP ProBook 532", y_inverted),
 	AXIS_DMI_MATCH("Mini510x", "HP Mini 510", xy_rotated_left_usd),
+	AXIS_DMI_MATCH("HPB63xx", "HP ProBook 63", xy_swap),
+	AXIS_DMI_MATCH("HPB64xx", "HP ProBook 64", xy_swap),
+	AXIS_DMI_MATCH("HPB64xx", "HP EliteBook 84", xy_swap),
+	AXIS_DMI_MATCH("HPB65xx", "HP ProBook 65", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch

