From: akpm@linux-foundation.org
Subject: + i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses.patch added to -mm tree
Date: Mon, 12 Jan 2009 14:12:05 -0800
Message-ID: <200901122212.n0CMC5Yb013291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbZALWNV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 17:13:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clifford@clifford.at, ben-linux@fluff.org, khali@linux-fr.org


The patch titled
     i2c: incremental i2c-mpc driver fix for multi-master i2c busses
has been added to the -mm tree.  Its filename is
     i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses.patch

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
Subject: i2c: incremental i2c-mpc driver fix for multi-master i2c busses
From: Clifford Wolf <clifford@clifford.at>

Retry on arbitration lost until xfer is successful, a non-arbitration-lost
error is triggered or the 1s timeout is hit.

Tested with a freescale MPC8349E host cpu.

Signed-off-by: Clifford Wolf <clifford@clifford.at>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-mpc.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/i2c/busses/i2c-mpc.c~i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses drivers/i2c/busses/i2c-mpc.c
--- a/drivers/i2c/busses/i2c-mpc.c~i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses
+++ a/drivers/i2c/busses/i2c-mpc.c
@@ -106,7 +106,7 @@ static int i2c_wait(struct mpc_i2c *i2c,
 			schedule();
 			if (time_after(jiffies, orig_jiffies + timeout)) {
 				pr_debug("I2C: timeout\n");
-				writeccr(i2c, 0);
+				writeccr(i2c, CCR_MEN);
 				result = -EIO;
 				break;
 			}
@@ -120,10 +120,10 @@ static int i2c_wait(struct mpc_i2c *i2c,
 
 		if (unlikely(result < 0)) {
 			pr_debug("I2C: wait interrupted\n");
-			writeccr(i2c, 0);
+			writeccr(i2c, CCR_MEN);
 		} else if (unlikely(!(i2c->interrupt & CSR_MIF))) {
 			pr_debug("I2C: wait timeout\n");
-			writeccr(i2c, 0);
+			writeccr(i2c, CCR_MEN);
 			result = -ETIMEDOUT;
 		}
 
@@ -268,7 +268,7 @@ static int mpc_xfer(struct i2c_adapter *
 	while (readb(i2c->base + MPC_I2C_SR) & CSR_MBB) {
 		if (signal_pending(current)) {
 			pr_debug("I2C: Interrupted\n");
-			writeccr(i2c, 0);
+			writeccr(i2c, CCR_MEN);
 			return -EINTR;
 		}
 		if (time_after(jiffies, orig_jiffies + HZ)) {
@@ -365,6 +365,15 @@ static int __devinit fsl_i2c_probe(struc
 	}
 	of_register_i2c_devices(&i2c->adap, op->node);
 
+	/* Make sure the adapter is already in master mode some time before
+	 * the first xfer to make sure arbitration control had enough time
+	 * to monitor the bus. The CCR_MEN flag should never be cleared without
+	 * makeing sure there is some delay between setting it again and
+	 * starting the first transfer..
+	 */
+	writeccr(i2c, CCR_MEN);
+	udelay(100);
+
 	return result;
 
  fail_add:
_

Patches currently in -mm which might be from clifford@clifford.at are

linux-next.patch
i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses.patch
i2c-fix-i2c-mpc-driver-for-multi-master-i2c-busses.patch

