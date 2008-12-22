From: akpm@linux-foundation.org
Subject: + i2c-fix-i2c-mpc-driver-for-multi-master-i2c-busses.patch added to -mm tree
Date: Mon, 22 Dec 2008 13:01:46 -0800
Message-ID: <200812222101.mBML1kn7021201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337AbYLVVCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 16:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clifford@clifford.at, khali@linux-fr.org


The patch titled
     i2c: fix i2c-mpc driver for multi-master i2c busses
has been added to the -mm tree.  Its filename is
     i2c-fix-i2c-mpc-driver-for-multi-master-i2c-busses.patch

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
Subject: i2c: fix i2c-mpc driver for multi-master i2c busses
From: Clifford Wolf <clifford@clifford.at>

Simply retry on arbitration lost until xfer is successfull, a
non-arbitration-lost error is triggered or the 1s timeout is hit.

Tested with a freescale MPC8349E host cpu.

Signed-off-by: Clifford Wolf <clifford@clifford.at>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-mpc.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN drivers/i2c/busses/i2c-mpc.c~i2c-fix-i2c-mpc-driver-for-multi-master-i2c-busses drivers/i2c/busses/i2c-mpc.c
--- a/drivers/i2c/busses/i2c-mpc.c~i2c-fix-i2c-mpc-driver-for-multi-master-i2c-busses
+++ a/drivers/i2c/busses/i2c-mpc.c
@@ -134,13 +134,13 @@ static int i2c_wait(struct mpc_i2c *i2c,
 	if (result < 0)
 		return result;
 
-	if (!(x & CSR_MCF)) {
-		pr_debug("I2C: unfinished\n");
-		return -EIO;
-	}
-
 	if (x & CSR_MAL) {
 		pr_debug("I2C: MAL\n");
+		return -EAGAIN;
+	}
+
+	if (!(x & CSR_MCF)) {
+		pr_debug("I2C: unfinished\n");
 		return -EIO;
 	}
 
@@ -257,11 +257,11 @@ static int mpc_read(struct mpc_i2c *i2c,
 static int mpc_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
 	struct i2c_msg *pmsg;
-	int i;
-	int ret = 0;
+	int i, ret;
 	unsigned long orig_jiffies = jiffies;
 	struct mpc_i2c *i2c = i2c_get_adapdata(adap);
 
+restart:
 	mpc_i2c_start(i2c);
 
 	/* Allow bus up to 1s to become not busy */
@@ -281,7 +281,7 @@ static int mpc_xfer(struct i2c_adapter *
 		schedule();
 	}
 
-	for (i = 0; ret >= 0 && i < num; i++) {
+	for (i = 0, ret = 0; ret >= 0 && i < num; i++) {
 		pmsg = &msgs[i];
 		pr_debug("Doing %s %d bytes to 0x%02x - %d of %d messages\n",
 			 pmsg->flags & I2C_M_RD ? "read" : "write",
@@ -292,7 +292,13 @@ static int mpc_xfer(struct i2c_adapter *
 		else
 			ret =
 			    mpc_write(i2c, pmsg->addr, pmsg->buf, pmsg->len, i);
+		if (ret == -EAGAIN) {
+			pr_debug("Lost i2c arbitration -> retry.\n");
+			mpc_i2c_stop(i2c);
+			goto restart;
+		}
 	}
+
 	mpc_i2c_stop(i2c);
 	return (ret < 0) ? ret : num;
 }
_

Patches currently in -mm which might be from clifford@clifford.at are

i2c-fix-i2c-mpc-driver-for-multi-master-i2c-busses.patch

