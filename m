From: akpm@linux-foundation.org
Subject: - i2c-pasemi-fixes.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:16 -0700
Message-ID: <200704192002.l3JK2GPD029372@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766989AbXDSUCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     Minor bug fixes to i2c-pasemi
has been removed from the -mm tree.  Its filename was
     i2c-pasemi-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Minor bug fixes to i2c-pasemi
From: Olof Johansson <olof@lixom.net>

* Last write during i2c_xfer is of the wrong byte (off-by-1).
* Read length is wrong for some of the reads (mistakenly used the PEC
  version)

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-pasemi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/i2c/busses/i2c-pasemi.c~i2c-pasemi-fixes drivers/i2c/busses/i2c-pasemi.c
--- a/drivers/i2c/busses/i2c-pasemi.c~i2c-pasemi-fixes
+++ a/drivers/i2c/busses/i2c-pasemi.c
@@ -141,7 +141,7 @@ static int pasemi_i2c_xfer_msg(struct i2
 		for (i = 0; i < msg->len - 1; i++)
 			TXFIFO_WR(smbus, msg->buf[i]);
 
-		TXFIFO_WR(smbus, msg->buf[msg->len] |
+		TXFIFO_WR(smbus, msg->buf[msg->len-1] |
 			  (stop ? MTXFIFO_STOP : 0));
 	}
 
@@ -226,7 +226,7 @@ static int pasemi_smb_xfer(struct i2c_ad
 			rd = RXFIFO_RD(smbus);
 			len = min_t(u8, (rd & MRXFIFO_DATA_M),
 				    I2C_SMBUS_BLOCK_MAX);
-			TXFIFO_WR(smbus, (len + 1) | MTXFIFO_READ |
+			TXFIFO_WR(smbus, len | MTXFIFO_READ |
 					 MTXFIFO_STOP);
 		} else {
 			len = min_t(u8, data->block[0], I2C_SMBUS_BLOCK_MAX);
@@ -258,7 +258,7 @@ static int pasemi_smb_xfer(struct i2c_ad
 		rd = RXFIFO_RD(smbus);
 		len = min_t(u8, (rd & MRXFIFO_DATA_M),
 			    I2C_SMBUS_BLOCK_MAX - len);
-		TXFIFO_WR(smbus, (len + 1) | MTXFIFO_READ | MTXFIFO_STOP);
+		TXFIFO_WR(smbus, len | MTXFIFO_READ | MTXFIFO_STOP);
 		break;
 
 	default:
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
git-powerpc.patch
