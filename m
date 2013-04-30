From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1307-long-block-operations-bugfix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:50 -0700
Message-ID: <20130430185650.751745A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:44084 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347Ab3D3S4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:51 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86833vbe.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ba@cykian.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1307.c: long block operations bugfix
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-long-block-operations-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Bertrand Achard" <ba@cykian.net>
Subject: drivers/rtc/rtc-ds1307.c: long block operations bugfix

The rtc-ds1307 driver does not properly handle block operations bigger
than 32 bytes in either of the two modes supported (SMbus native, or
emulated if not supported by the SMbus platform driver).

It also does not properly handle userland-supplied input (block operation
length) through sysfs and may suffer a type of buffer overrun.

The driver has been modified with proper input validation, buffer sizes,
and now splits block transfers bigger than 32 bytes into separate
transfers.

Explanation : Buffer size allocated is I2C_SMBUS_BLOCK_MAX which equals to
32 as per the SMbus spec.  Reads and write may be up to 56 bytes (to the
NVRAM).  This patch allocated a 255 byte buffer, the maximum allowable
(address is an u8).  It's not only a buffer problem, SMbus only supports
up to 32 bytes transfer at once, so it's needed to split bigger transfers.

Patch successfully tested on 3.2.27; cleanly applies on 3.7-rc4.

[akpm@linux-foundation.org: rework code to avoid 80-column overflows]
Signed-off-by: Bertrand Achard <ba@cykian.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   60 ++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-long-block-operations-bugfix drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-long-block-operations-bugfix
+++ a/drivers/rtc/rtc-ds1307.c
@@ -4,6 +4,7 @@
  *  Copyright (C) 2005 James Chapman (ds1337 core)
  *  Copyright (C) 2006 David Brownell
  *  Copyright (C) 2009 Matthias Fuchs (rx8025 support)
+ *  Copyright (C) 2012 Bertrand Achard (nvram access fixes)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -196,7 +197,7 @@ static s32 ds1307_read_block_data_once(c
 static s32 ds1307_read_block_data(const struct i2c_client *client, u8 command,
 				  u8 length, u8 *values)
 {
-	u8 oldvalues[I2C_SMBUS_BLOCK_MAX];
+	u8 oldvalues[255];
 	s32 ret;
 	int tries = 0;
 
@@ -222,7 +223,7 @@ static s32 ds1307_read_block_data(const
 static s32 ds1307_write_block_data(const struct i2c_client *client, u8 command,
 				   u8 length, const u8 *values)
 {
-	u8 currvalues[I2C_SMBUS_BLOCK_MAX];
+	u8 currvalues[255];
 	int tries = 0;
 
 	dev_dbg(&client->dev, "ds1307_write_block_data (length=%d)\n", length);
@@ -250,6 +251,57 @@ static s32 ds1307_write_block_data(const
 
 /*----------------------------------------------------------------------*/
 
+/* These RTC devices are not designed to be connected to a SMbus adapter.
+   SMbus limits block operations length to 32 bytes, whereas it's not
+   limited on I2C buses. As a result, accesses may exceed 32 bytes;
+   in that case, split them into smaller blocks */
+
+static s32 ds1307_native_smbus_write_block_data(const struct i2c_client *client,
+				u8 command, u8 length, const u8 *values)
+{
+	u8 suboffset = 0;
+
+	if (length <= I2C_SMBUS_BLOCK_MAX)
+		return i2c_smbus_write_i2c_block_data(client,
+					command, length, values);
+
+	while (suboffset < length) {
+		s32 retval = i2c_smbus_write_i2c_block_data(client,
+				command + suboffset,
+				min(I2C_SMBUS_BLOCK_MAX, length - suboffset),
+				values + suboffset);
+		if (retval < 0)
+			return retval;
+
+		suboffset += I2C_SMBUS_BLOCK_MAX;
+	}
+	return length;
+}
+
+static s32 ds1307_native_smbus_read_block_data(const struct i2c_client *client,
+				u8 command, u8 length, u8 *values)
+{
+	u8 suboffset = 0;
+
+	if (length <= I2C_SMBUS_BLOCK_MAX)
+		return i2c_smbus_read_i2c_block_data(client,
+					command, length, values);
+
+	while (suboffset < length) {
+		s32 retval = i2c_smbus_read_i2c_block_data(client,
+				command + suboffset,
+				min(I2C_SMBUS_BLOCK_MAX, length - suboffset),
+				values + suboffset);
+		if (retval < 0)
+			return retval;
+
+		suboffset += I2C_SMBUS_BLOCK_MAX;
+	}
+	return length;
+}
+
+/*----------------------------------------------------------------------*/
+
 /*
  * The IRQ logic includes a "real" handler running in IRQ context just
  * long enough to schedule this workqueue entry.   We need a task context
@@ -646,8 +698,8 @@ static int ds1307_probe(struct i2c_clien
 
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
-		ds1307->read_block_data = i2c_smbus_read_i2c_block_data;
-		ds1307->write_block_data = i2c_smbus_write_i2c_block_data;
+		ds1307->read_block_data = ds1307_native_smbus_read_block_data;
+		ds1307->write_block_data = ds1307_native_smbus_write_block_data;
 	} else {
 		ds1307->read_block_data = ds1307_read_block_data;
 		ds1307->write_block_data = ds1307_write_block_data;
_

Patches currently in -mm which might be from ba@cykian.net are

origin.patch

