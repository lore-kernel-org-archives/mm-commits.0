From: akpm@linux-foundation.org
Subject: + pcf50633_charger-remove-mbc_set_status.patch added to -mm tree
Date: Mon, 02 Feb 2009 14:42:10 -0800
Message-ID: <200902022242.n12MgALA003254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092AbZBBWmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 17:42:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balajirrao@openmoko.org, andy@openmoko.com, cbou@mail.ru


The patch titled
     pcf50633_charger: remove mbc_set_status
has been added to the -mm tree.  Its filename is
     pcf50633_charger-remove-mbc_set_status.patch

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
Subject: pcf50633_charger: remove mbc_set_status
From: Balaji Rao <balajirrao@openmoko.org>

Remove unused 'pcf50633_mbc_set_status' function.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/pcf50633-charger.c |   15 ---------------
 include/linux/mfd/pcf50633/mbc.h |    1 -
 2 files changed, 16 deletions(-)

diff -puN drivers/power/pcf50633-charger.c~pcf50633_charger-remove-mbc_set_status drivers/power/pcf50633-charger.c
--- a/drivers/power/pcf50633-charger.c~pcf50633_charger-remove-mbc_set_status
+++ a/drivers/power/pcf50633-charger.c
@@ -84,21 +84,6 @@ int pcf50633_mbc_get_status(struct pcf50
 }
 EXPORT_SYMBOL_GPL(pcf50633_mbc_get_status);
 
-void pcf50633_mbc_set_status(struct pcf50633 *pcf, int what, int status)
-{
-	struct pcf50633_mbc *mbc = platform_get_drvdata(pcf->mbc_pdev);
-
-	if (what & PCF50633_MBC_USB_ONLINE)
-		mbc->usb_online = !!status;
-	if (what & PCF50633_MBC_USB_ACTIVE)
-		mbc->usb_active = !!status;
-	if (what & PCF50633_MBC_ADAPTER_ONLINE)
-		mbc->adapter_online = !!status;
-	if (what & PCF50633_MBC_ADAPTER_ACTIVE)
-		mbc->adapter_active = !!status;
-}
-EXPORT_SYMBOL_GPL(pcf50633_mbc_set_status);
