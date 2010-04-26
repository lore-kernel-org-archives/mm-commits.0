From: akpm@linux-foundation.org
Subject: [merged] lis3-add-support-for-hp-probook-432x-442x-452x-522x.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:26:16 -0400
Message-ID: <201004261727.o3QHRoDV009077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045Ab0DZR16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:27:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, eric.piel@tremplin-utc.net, mm-commits@vger.kernel.org


The patch titled
     lis3: add support for HP ProBook 432x/442x/452x/522x
has been removed from the -mm tree.  Its filename was
     lis3-add-support-for-hp-probook-432x-442x-452x-522x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

