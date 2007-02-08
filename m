From: akpm@linux-foundation.org
Subject: - rtc-pcf8563-detect-polarity-of-century-bit-automatically-fix.patch removed from -mm tree
Date: Thu, 08 Feb 2007 14:17:03 -0800
Message-ID: <200702082217.l18MH3BU028381@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42793 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423489AbXBHWZC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 17:25:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, dbrownell@users.sourceforge.net, jean-baptiste.maneyrol@teamlog.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc-pcf8563: detect polarity of century bit automatically: fix
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-detect-polarity-of-century-bit-automatically-fix.patch

This patch was dropped because it was folded into rtc-pcf8563-detect-polarity-of-century-bit-automatically.patch

------------------------------------------------------
Subject: rtc-pcf8563: detect polarity of century bit automatically: fix
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Sorry, I forgot to change an argument of kfree() in pcf8563_detach().
Though it should work while "client" is a first member in struct
pcf8563, it should be changed to pass "pcf8563" instead of "client".

Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@teamlog.com>
Cc: <stable@kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-pcf8563.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-detect-polarity-of-century-bit-automatically-fix drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-detect-polarity-of-century-bit-automatically-fix
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -336,6 +336,7 @@ exit:
 
 static int pcf8563_detach(struct i2c_client *client)
 {
+	struct pcf8563 *pcf8563 = container_of(client, struct pcf8563, client);
 	int err;
 	struct rtc_device *rtc = i2c_get_clientdata(client);
 
@@ -345,7 +346,7 @@ static int pcf8563_detach(struct i2c_cli
 	if ((err = i2c_detach_client(client)))
 		return err;
 
-	kfree(client);
+	kfree(pcf8563);
 
 	return 0;
 }
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
rtc-pcf8563-detect-polarity-of-century-bit-automatically.patch
rtc-pcf8563-detect-polarity-of-century-bit-automatically-fix.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
serial-serial_txx9-driver-update.patch
