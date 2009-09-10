From: akpm@linux-foundation.org
Subject: + input-add-keyboard-quirk-for-samsung-r59p-r60p-r61p-laptops.patch added to -mm tree
Date: Thu, 10 Sep 2009 14:33:55 -0700
Message-ID: <200909102133.n8ALXtBV002926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbZIJVec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 17:34:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keng-yu.lin@canonical.com, cdb@linkycat.com, dtor@mail.ru, sancheolz@gmail.com


The patch titled
     input: add keyboard quirk for Samsung R59P/R60P/R61P laptops
has been added to the -mm tree.  Its filename is
     input-add-keyboard-quirk-for-samsung-r59p-r60p-r61p-laptops.patch

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
Subject: input: add keyboard quirk for Samsung R59P/R60P/R61P laptops
From: Keng-Yu Lin <keng-yu.lin@canonical.com>

Add quirk for Samsung R59P/R60P/R61P to make the hotkeys work

Original Authors: Moiseev Vladimir, Alexander Huhlaev.

Addresses http://bugs.launchpad.net/bugs/253874

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
Cc: Moiseev Vladimir <cdb@linkycat.com>
Cc: Alexander Huhlaev <sancheolz@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/atkbd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/input/keyboard/atkbd.c~input-add-keyboard-quirk-for-samsung-r59p-r60p-r61p-laptops drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c~input-add-keyboard-quirk-for-samsung-r59p-r60p-r61p-laptops
+++ a/drivers/input/keyboard/atkbd.c
@@ -1639,6 +1639,15 @@ static struct dmi_system_id atkbd_dmi_qu
 		.driver_data = atkbd_samsung_forced_release_keys,
 	},
 	{
+		.ident = "Samsung R59P/R60P/R61P",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "R59P/R60P/R61P"),
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_samsung_keymap_fixup,
+	},
+	{
 		.ident = "Fujitsu Amilo PA 1510",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
_

Patches currently in -mm which might be from keng-yu.lin@canonical.com are

input-add-keyboard-quirk-for-samsung-r59p-r60p-r61p-laptops.patch

