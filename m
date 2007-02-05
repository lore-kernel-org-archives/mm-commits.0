From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-detect-polarity-of-century-bit-automatically-fix.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:13:33 -0800
Message-ID: <200702052113.l15LDXDu031301@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34233 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933461AbXBEVWC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:22:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, dbrownell@users.sourceforge.net, jean-baptiste.maneyrol@teamlog.com, stable@kernel.org


The patch titled
     rtc-pcf8563: detect polarity of century bit automatically: fix
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-detect-polarity-of-century-bit-automatically-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-pcf8563-detect-polarity-of-century-bit-automatically.patch
rtc-pcf8563-detect-polarity-of-century-bit-automatically-fix.patch
git-mips.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
serial-serial_txx9-driver-update.patch
