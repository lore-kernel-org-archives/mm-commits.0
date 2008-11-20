From: akpm@linux-foundation.org
Subject: - drivers-hwmon-applesmcc-add-generic-macpro-support.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:16 -0800
Message-ID: <200811202043.mAKKhG6u007388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755408AbYKTUn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     drivers/hwmon/applesmc.c: add generic MacPro support
has been removed from the -mm tree.  Its filename was
     drivers-hwmon-applesmcc-add-generic-macpro-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/hwmon/applesmc.c: add generic MacPro support
From: Henrik Rydberg <rydberg@euromail.se>

In order to analyze the SMC of the newer MacPros, applesmc needs to
recognize the machine.  This patch adds the missing generic dmi_match
entry for MacPro models.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/hwmon/applesmc.c~drivers-hwmon-applesmcc-add-generic-macpro-support drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~drivers-hwmon-applesmcc-add-generic-macpro-support
+++ a/drivers/hwmon/applesmc.c
@@ -1354,6 +1354,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple MacPro", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
+		&applesmc_dmi_data[4]},
 	{ applesmc_dmi_match, "Apple iMac 8", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac8") },
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

