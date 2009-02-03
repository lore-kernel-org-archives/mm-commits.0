From: akpm@linux-foundation.org
Subject: [merged] pcf50633_charger-remove-mbc_set_status.patch removed from -mm tree
Date: Tue, 03 Feb 2009 11:54:42 -0800
Message-ID: <200902031954.n13JsgXS027328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbZBCTzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 14:55:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balajirrao@openmoko.org, andy@openmoko.com, cbou@mail.ru, mm-commits@vger.kernel.org


The patch titled
     pcf50633_charger: remove mbc_set_status
has been removed from the -mm tree.  Its filename was
     pcf50633_charger-remove-mbc_set_status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
