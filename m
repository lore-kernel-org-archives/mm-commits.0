From: akpm@linux-foundation.org
Subject: + viafb-fix-i2c_transfer-error-handling.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:11 -0700
Message-ID: <201009212237.o8LMbBnl006793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0IUWhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net, stable@kernel.org


The patch titled
     viafb: fix i2c_transfer error handling
has been added to the -mm tree.  Its filename is
     viafb-fix-i2c_transfer-error-handling.patch

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
Subject: viafb: fix i2c_transfer error handling
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

i2c_transfer returns negative errno on error and number of messages
processed on success.  Just returning this value would give a poor
interface as it is not obvious that you must compare with 2 after reading
1 or n bytes and with 1 after writing 1 byte to determine if it was
successful.  To avoid this error prone interface convert the error code of
a successful read/write to zero and all other non-negative values to an
negative error code.

This fixes a regression introduced by

	via: Rationalize vt1636 detection

which resulted in no longer detecting a VT1636 chip and therefore has
broken the output in configurations wich contain this chip.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/via_i2c.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff -puN drivers/video/via/via_i2c.c~viafb-fix-i2c_transfer-error-handling drivers/video/via/via_i2c.c
--- a/drivers/video/via/via_i2c.c~viafb-fix-i2c_transfer-error-handling
+++ a/drivers/video/via/via_i2c.c
@@ -114,6 +114,7 @@ static void via_i2c_setsda(void *data, i
 
 int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata)
 {
+	int ret;
 	u8 mm1[] = {0x00};
 	struct i2c_msg msgs[2];
 
@@ -126,11 +127,18 @@ int viafb_i2c_readbyte(u8 adap, u8 slave
 	mm1[0] = index;
 	msgs[0].len = 1; msgs[1].len = 1;
 	msgs[0].buf = mm1; msgs[1].buf = pdata;
-	return i2c_transfer(&via_i2c_par[adap].adapter, msgs, 2);
+	ret = i2c_transfer(&via_i2c_par[adap].adapter, msgs, 2);
+	if (ret == 2)
+		ret = 0;
+	else if (ret >= 0)
+		ret = -EIO;
+
+	return ret;
 }
 
 int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data)
 {
+	int ret;
 	u8 msg[2] = { index, data };
 	struct i2c_msg msgs;
 
@@ -140,11 +148,18 @@ int viafb_i2c_writebyte(u8 adap, u8 slav
 	msgs.addr = slave_addr / 2;
 	msgs.len = 2;
 	msgs.buf = msg;
-	return i2c_transfer(&via_i2c_par[adap].adapter, &msgs, 1);
+	ret = i2c_transfer(&via_i2c_par[adap].adapter, &msgs, 1);
+	if (ret == 1)
+		ret = 0;
+	else if (ret >= 0)
+		ret = -EIO;
+
+	return ret;
 }
 
 int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len)
 {
+	int ret;
 	u8 mm1[] = {0x00};
 	struct i2c_msg msgs[2];
 
@@ -156,7 +171,13 @@ int viafb_i2c_readbytes(u8 adap, u8 slav
 	mm1[0] = index;
 	msgs[0].len = 1; msgs[1].len = buff_len;
 	msgs[0].buf = mm1; msgs[1].buf = buff;
-	return i2c_transfer(&via_i2c_par[adap].adapter, msgs, 2);
+	ret = i2c_transfer(&via_i2c_par[adap].adapter, msgs, 2);
+	if (ret == 2)
+		ret = 0;
+	else if (ret >= 0)
+		ret = -EIO;
+
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

linux-next.patch
viafb-add-interface-for-output-device-configuration.patch
viafb-limit-lcd-code-impact.patch
viafb-introduce-per-output-device-power-management.patch
viafb-vt1636-cleanup.patch
viafb-fix-i2c_transfer-error-handling.patch
viafb-enable-i2c-for-crt.patch
viafb-reduce-i2c-timeout-and-delay.patch
viafb-add-function-to-change-sync-polarity-per-device.patch
viafb-set-sync-polarity-for-all-output-devices.patch
viafb-add-a-mapping-of-supported-output-devices.patch
viafb-rename-output-devices.patch
viafb-add-documentation-for-proc-interface.patch

