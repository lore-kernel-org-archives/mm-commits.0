From: akpm@linux-foundation.org
Subject: [merged] i2c-mpc-do-not-generate-stop-after-read.patch removed from -mm tree
Date: Tue, 03 Nov 2009 11:57:41 -0800
Message-ID: <200911031957.nA3JvfRp026832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbZKCT6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 14:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joakim.Tjernlund@transmode.se, ben-linux@fluff.org, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c-mpc: do not generate STOP after read
has been removed from the -mm tree.  Its filename was
     i2c-mpc-do-not-generate-stop-after-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c-mpc: do not generate STOP after read
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

The driver always ends a read with a STOP condition which breaks
subsequent I2C reads/writes in the same transaction as these expect to do
a repeated START(ReSTART).

This will also help I2C multimaster as the bus will not be released after
the first read, but when the whole transaction ends.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/i2c/busses/i2c-mpc.c~i2c-mpc-do-not-generate-stop-after-read drivers/i2c/busses/i2c-mpc.c
--- a/drivers/i2c/busses/i2c-mpc.c~i2c-mpc-do-not-generate-stop-after-read
+++ a/drivers/i2c/busses/i2c-mpc.c
@@ -365,9 +365,6 @@ static int mpc_write(struct mpc_i2c *i2c
 	unsigned timeout = i2c->adap.timeout;
 	u32 flags = restart ? CCR_RSTA : 0;
 
-	/* Start with MEN */
-	if (!restart)
-		writeccr(i2c, CCR_MEN);
 	/* Start as master */
 	writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_MTX | flags);
 	/* Write target byte */
@@ -396,9 +393,6 @@ static int mpc_read(struct mpc_i2c *i2c,
 	int i, result;
 	u32 flags = restart ? CCR_RSTA : 0;
 
-	/* Start with MEN */
-	if (!restart)
-		writeccr(i2c, CCR_MEN);
 	/* Switch to read - restart */
 	writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_MTX | flags);
 	/* Write target address byte - this time with the read flag set */
@@ -425,9 +419,9 @@ static int mpc_read(struct mpc_i2c *i2c,
 		/* Generate txack on next to last byte */
 		if (i == length - 2)
 			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_TXAK);
-		/* Generate stop on last byte */
+		/* Do not generate stop on last byte */
 		if (i == length - 1)
-			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_TXAK);
+			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_MTX);
 		data[i] = readb(i2c->base + MPC_I2C_DR);
 	}
 
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

origin.patch

