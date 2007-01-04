From: akpm@osdl.org
Subject: + i2c-m41t00-do-not-forget-to-write-year.patch added to -mm tree
Date: Thu, 04 Jan 2007 15:29:24 -0800
Message-ID: <200701042329.l04NTOTT002506@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:35954 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030272AbXADX3l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:29:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phdm@macqel.be, khali@linux-fr.org


The patch titled
     i2c/m41t00 do not forget to write year
has been added to the -mm tree.  Its filename is
     i2c-m41t00-do-not-forget-to-write-year.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2c/m41t00 do not forget to write year
From: Philippe De Muyter <phdm@macqel.be>

m41t00.c forgets to set the year field in set_rtc_time; fix that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/i2c/chips/m41t00.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/i2c/chips/m41t00.c~i2c-m41t00-do-not-forget-to-write-year drivers/i2c/chips/m41t00.c
--- a/drivers/i2c/chips/m41t00.c~i2c-m41t00-do-not-forget-to-write-year
+++ a/drivers/i2c/chips/m41t00.c
@@ -209,6 +209,7 @@ m41t00_set(void *arg)
 	buf[m41t00_chip->hour] = (buf[m41t00_chip->hour] & ~0x3f) | (hour& 0x3f);
 	buf[m41t00_chip->day] = (buf[m41t00_chip->day] & ~0x3f) | (day & 0x3f);
 	buf[m41t00_chip->mon] = (buf[m41t00_chip->mon] & ~0x1f) | (mon & 0x1f);
+	buf[m41t00_chip->year] = year;
 
 	if (i2c_master_send(save_client, wbuf, 9) < 0)
 		dev_err(&save_client->dev, "m41t00_set: Write error\n");
_

Patches currently in -mm which might be from phdm@macqel.be are

i2c-m41t00-do-not-forget-to-write-year.patch
