From: akpm@linux-foundation.org
Subject: [merged] mtd-fix-timeout-in-m25p80-driver.patch removed from -mm tree
Date: Mon, 11 May 2009 11:54:23 -0700
Message-ID: <200905111854.n4BIsNQG000349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523AbZEKS63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 14:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zero@colonel-panic.org, dwmw2@infradead.org, sfalco@harris.com, tbm@cyrius.com, mm-commits@vger.kernel.org


The patch titled
     mtd: fix timeout in M25P80 driver
has been removed from the -mm tree.  Its filename was
     mtd-fix-timeout-in-m25p80-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: fix timeout in M25P80 driver
From: Peter Horton <zero@colonel-panic.org>

Change the timeout from a simple loop count to a suitable number of
seconds, to make it more predictable.

Signed-off-by: Peter Horton <zero@colonel-panic.org>
Tested-by: Martin Michlmayr <tbm@cyrius.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Steven A. Falco <sfalco@harris.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-fix-timeout-in-m25p80-driver drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-fix-timeout-in-m25p80-driver
+++ a/drivers/mtd/devices/m25p80.c
@@ -54,7 +54,7 @@
 #define	SR_SRWD			0x80	/* SR write protect */
 
 /* Define max times to check status register before we give up. */
-#define	MAX_READY_WAIT_COUNT	1000000
+#define	MAX_READY_WAIT_COUNT	(10 * HZ) /* eg. M25P128 specs 6s max sector erase */
 #define	CMD_SIZE		4
 
 #ifdef CONFIG_M25PXX_USE_FAST_READ
@@ -139,20 +139,20 @@ static inline int write_enable(struct m2
  */
 static int wait_till_ready(struct m25p *flash)
 {
-	int count;
+	unsigned long deadline;
 	int sr;
 
-	/* one chip guarantees max 5 msec wait here after page writes,
-	 * but potentially three seconds (!) after page erase.
-	 */
-	for (count = 0; count < MAX_READY_WAIT_COUNT; count++) {
+	deadline = jiffies + MAX_READY_WAIT_JIFFIES;
+
+	do {
 		if ((sr = read_sr(flash)) < 0)
 			break;
 		else if (!(sr & SR_WIP))
 			return 0;
 
-		/* REVISIT sometimes sleeping would be best */
-	}
+		cond_resched();
+
+	} while (!time_after_eq(jiffies, deadline));
 
 	return 1;
 }
_

Patches currently in -mm which might be from zero@colonel-panic.org are


