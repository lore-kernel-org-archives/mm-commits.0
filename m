From: akpm@linux-foundation.org
Subject: + drivers-hwmon-applesmcc-add-generic-macpro-support.patch added to -mm tree
Date: Tue, 18 Nov 2008 16:44:23 -0800
Message-ID: <200811190044.mAJ0iNah031510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbYKSApF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 19:45:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, nicolas@boichat.ch


The patch titled
     drivers/hwmon/applesmc.c: add generic MacPro support
has been added to the -mm tree.  Its filename is
     drivers-hwmon-applesmcc-add-generic-macpro-support.patch

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
hwmon-applesmc-add-support-for-imac-6.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
drivers-hwmon-applesmcc-add-generic-macpro-support.patch

