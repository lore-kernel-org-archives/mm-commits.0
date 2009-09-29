From: akpm@linux-foundation.org
Subject: + wistron_btnsc-add-dmi-entry-for-medion-wim2030-laptop.patch added to -mm tree
Date: Tue, 29 Sep 2009 14:51:37 -0700
Message-ID: <200909292151.n8TLpbgD023772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbZI2VwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dr.nop@gmx.net, dtor@mail.ru


The patch titled
     wistron_btns.c: add DMI entry for Medion WIM2030 laptop
has been added to the -mm tree.  Its filename is
     wistron_btnsc-add-dmi-entry-for-medion-wim2030-laptop.patch

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
Subject: wistron_btns.c: add DMI entry for Medion WIM2030 laptop
From: Sebastian Frei <dr.nop@gmx.net>

This patch adds a DMI entry for the Medion WIM2030 laptop.

Signed-off-by: Sebastian Frei <dr.nop@gmx.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/wistron_btns.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/input/misc/wistron_btns.c~wistron_btnsc-add-dmi-entry-for-medion-wim2030-laptop drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wistron_btnsc-add-dmi-entry-for-medion-wim2030-laptop
+++ a/drivers/input/misc/wistron_btns.c
@@ -683,6 +683,15 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Medion MD 42200",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Medion"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2030"),
+		},
+		.driver_data = keymap_fs_amilo_pro_v2000
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Fujitsu N3510",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
_

Patches currently in -mm which might be from dr.nop@gmx.net are

wistron_btnsc-add-dmi-entry-for-medion-wim2030-laptop.patch

