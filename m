From: akpm@linux-foundation.org
Subject: + rtc-ds1307-ds_1340-change-init.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:09 -0800
Message-ID: <200801270514.m0R5E6Am030963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbYA0FOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: f.rodo@til-technologies.fr, dbrownell@users.sourceforge.net


The patch titled
     rtc ds1307: ds_1340 change init
has been added to the -mm tree.  Its filename is
     rtc-ds1307-ds_1340-change-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc ds1307: ds_1340 change init
From: frederic Rodo <f.rodo@til-technologies.fr>

For DS140, clear the oscillator fault flag as needed.

Signed-off-by: Frederic RODO <f.rodo@til-technologies.fr>
[ And remove some "sparse" warnings. ]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-ds_1340-change-init drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-ds_1340-change-init
+++ a/drivers/rtc/rtc-ds1307.c
@@ -256,7 +256,7 @@ ds1307_nvram_read(struct kobject *kobj, 
 	struct i2c_msg		msg[2];
 	int			result;
 
-	client = to_i2c_client(container_of(kobj, struct device, kobj));
+	client = kobj_to_i2c_client(kobj);
 	ds1307 = i2c_get_clientdata(client);
 
 	if (unlikely(off >= NVRAM_SIZE))
@@ -294,7 +294,7 @@ ds1307_nvram_write(struct kobject *kobj,
 	u8			buffer[NVRAM_SIZE + 1];
 	int			ret;
 
-	client = to_i2c_client(container_of(kobj, struct device, kobj));
+	client = kobj_to_i2c_client(kobj);
 
 	if (unlikely(off >= NVRAM_SIZE))
 		return -EFBIG;
@@ -412,11 +412,6 @@ read_rtc:
 	 */
 	tmp = ds1307->regs[DS1307_REG_SECS];
 	switch (ds1307->type) {
-	case ds_1340:
-		/* FIXME read register with DS1340_BIT_OSF, use that to
-		 * trigger the "set time" warning (*after* restarting the
-		 * oscillator!) instead of this weaker ds1307/m41t00 test.
-		 */
 	case ds_1307:
 	case m41t00:
 		/* clock halted?  turn it on, so clock can tick. */
@@ -440,6 +435,24 @@ read_rtc:
 			goto read_rtc;
 		}
 		break;
+	case ds_1340:
+		/* clock halted?  turn it on, so clock can tick. */
+		if (tmp & DS1340_BIT_nEOSC)
+			i2c_smbus_write_byte_data(client, DS1307_REG_SECS, 0);
+
+		tmp = i2c_smbus_read_byte_data(client, DS1340_REG_FLAG);
+		if (tmp < 0) {
+			pr_debug("read error %d\n", tmp);
+			err = -EIO;
+			goto exit_free;
+		}
+
+		/* oscillator fault?  clear flag, and warn */
+		if (tmp & DS1340_BIT_OSF) {
+			i2c_smbus_write_byte_data(client, DS1340_REG_FLAG, 0);
+			dev_warn(&client->dev, "SET TIME!\n");
+		}
+		break;
 	case ds_1337:
 	case ds_1339:
 		break;
_

Patches currently in -mm which might be from f.rodo@til-technologies.fr are

rtc-ds1307-ds_1340-change-init.patch
