From: akpm@linux-foundation.org
Subject: + mmc-fixes-and-enhancements-for-the-mmc-spi-driver-fix.patch added to -mm tree
Date: Wed, 28 Jan 2009 17:02:10 -0800
Message-ID: <200901290102.n0T12B6n024175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755780AbZA2BC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 20:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wolfgang.mues@auerswald.de, dbrownell@users.sourceforge.net, drzeus-list@drzeus.cx, matt@console-pimps.org


The patch titled
     mmc-fixes-and-enhancements-for-the-mmc-spi-driver-fix
has been added to the -mm tree.  Its filename is
     mmc-fixes-and-enhancements-for-the-mmc-spi-driver-fix.patch

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
Subject: mmc-fixes-and-enhancements-for-the-mmc-spi-driver-fix
From: Wolfgang Muees <wolfgang.mues@auerswald.de>

thanks to all contributors who have reviewed my patch, especial to
Andrew Morton for pointing out some problems.

Here is a revised patch incl. changelog. I have though about putting
some warnings in the message log with printk, Pierre. But this is low-level
stuff and will likely flood the logfile.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mmc_spi.c |   38 ++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff -puN drivers/mmc/host/mmc_spi.c~mmc-fixes-and-enhancements-for-the-mmc-spi-driver-fix drivers/mmc/host/mmc_spi.c
--- a/drivers/mmc/host/mmc_spi.c~mmc-fixes-and-enhancements-for-the-mmc-spi-driver-fix
+++ a/drivers/mmc/host/mmc_spi.c
@@ -26,6 +26,7 @@
  */
 #include <linux/hrtimer.h>
 #include <linux/sched.h>
+#include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/bio.h>
 #include <linux/dma-mapping.h>
@@ -188,7 +189,8 @@ static int
 mmc_spi_skip(struct mmc_spi_host *host, ktime_t timeout, unsigned n, u8 byte)
 {
 	u8 *cp = host->data->status;
-	unsigned long timeout_jiffies = (unsigned long) ((ktime_to_us(timeout) * HZ) / 1000000);
+	struct timeval tv = ktime_to_timeval(timeout);
+	unsigned long timeout_jiffies = timeval_to_jiffies(&tv);
 	unsigned long starttime = jiffies;
 
 	while (1) {
@@ -204,12 +206,12 @@ mmc_spi_skip(struct mmc_spi_host *host, 
 				return cp[i];
 		}
 
-		if ((jiffies - starttime) > timeout_jiffies)
+		if (time_is_before_jiffies(starttime+timeout_jiffies))
 			break;
 		/* If we need long timeouts, we may release the CPU. */
-		/* We use jiffies here because we want to have a relation between
-                   elapsed time and the blocking of the scheduler. */
-		if ((jiffies - starttime) > 1)
+		/* We use jiffies here because we want to have a relation
+		   between elapsed time and the blocking of the scheduler. */
+		if (time_is_before_jiffies(starttime+1))
 			schedule();
 	}
 	return -ETIMEDOUT;
@@ -615,14 +617,17 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	int			status, i;
 	struct scratch		*scratch = host->data;
 	u32			pattern;
+	struct timeval 		tv;
 
-	/* The MMC framework does a good job of computing timeouts
-           according to the mmc/sd standard. However, we found that in
-           SPI mode, there are many cards which need a longer timeout
-           of 1s after receiving a long stream of write data. */
-	struct timeval tv = ktime_to_timeval(timeout);
+	/*
+	 * The MMC framework does a good job of computing timeouts
+	 * according to the mmc/sd standard. However, we found that in
+	 * SPI mode, there are many cards which need a longer timeout
+	 * of 1s after receiving a long stream of write data.
+	 */
+	tv = ktime_to_timeval(timeout);
 	if (tv.tv_sec == 0)
-		timeout = ktime_set(1,0);
+		timeout = ktime_set(1, 0);
 
 	if (host->mmc->use_spi_crc)
 		scratch->crc_val = cpu_to_be16(
@@ -699,7 +704,7 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	 */
 	for (i = 4; i < sizeof(scratch->status); i++) {
 		if (scratch->status[i] & 0x01)
- 			return 0;
+			return 0;
 	}
 	return mmc_spi_wait_unbusy(host, timeout);
 }
@@ -772,10 +777,11 @@ mmc_spi_readblock(struct mmc_spi_host *h
 		return -EIO;
 	}
 
-	/* Omitt the CRC check for CID and CSD reads. There are some SDHC
-	   cards which don't supply a valid CRC after CID reads.
-	   Note that the CID has it's own CRC7 value inside the data block.
-	*/
+	/*
+	 * Omit the CRC check for CID and CSD reads. There are some SDHC
+	 * cards which don't supply a valid CRC after CID reads.
+	 * Note that the CID has it's own CRC7 value inside the data block.
+	 */
 	if (host->mmc->use_spi_crc && (t->len == MMC_SPI_BLOCKSIZE)) {
 		u16 crc = crc_itu_t(0, t->rx_buf, t->len);
 
_

Patches currently in -mm which might be from wolfgang.mues@auerswald.de are

mmc-fixes-and-enhancements-for-the-mmc-spi-driver.patch
mmc-fixes-and-enhancements-for-the-mmc-spi-driver-fix.patch

