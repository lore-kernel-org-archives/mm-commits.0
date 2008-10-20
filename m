From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-lighter-wait-mechanism-drastic-improvement.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:21 -0700
Message-ID: <200810202035.m9KKZLv9011134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbYJTUrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, bob@mcelrath.org, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: lighter wait mechanism, drastic improvement
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-lighter-wait-mechanism-drastic-improvement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: lighter wait mechanism, drastic improvement
From: Henrik Rydberg <rydberg@euromail.se>

The read fail ratio is sensitive to the delay between the first byte
written and the first byte read; apparently the sensors cannot be rushed. 
Increasing the minimum wait time, without changing the total wait time,
improves the fail ratio from a 8% chance that any of the sensors fails in
one read, down to 0.4%, on a Macbook Air.  On a Macbook Pro 3,1, the
effect is even more apparent.  By reducing the number of status polls, the
ratio is further improved to below 0.1%.  Finally, increasing the total
wait time brings the fail ratio down to virtually zero.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Bob McElrath <bob@mcelrath.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-lighter-wait-mechanism-drastic-improvement drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-lighter-wait-mechanism-drastic-improvement
+++ a/drivers/hwmon/applesmc.c
@@ -49,6 +49,9 @@
 
 #define APPLESMC_MAX_DATA_LENGTH 32
 
+#define APPLESMC_MIN_WAIT	0x0040
+#define APPLESMC_MAX_WAIT	0x8000
+
 #define APPLESMC_STATUS_MASK	0x0f
 #define APPLESMC_READ_CMD	0x10
 #define APPLESMC_WRITE_CMD	0x11
@@ -172,25 +175,25 @@ static unsigned int key_at_index;
 static struct workqueue_struct *applesmc_led_wq;
 
 /*
- * __wait_status - Wait up to 10ms for the status port to get a certain value
+ * __wait_status - Wait up to 32ms for the status port to get a certain value
  * (masked with 0x0f), returning zero if the value is obtained.  Callers must
  * hold applesmc_lock.
  */
 static int __wait_status(u8 val)
 {
-	unsigned int i;
+	int us;
 
 	val = val & APPLESMC_STATUS_MASK;
 
-	for (i = 0; i < 1000; i++) {
+	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
+		udelay(us);
 		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
 			if (debug)
 				printk(KERN_DEBUG
-						"Waited %d us for status %x\n",
-						i*10, val);
+					"Waited %d us for status %x\n",
+					2 * us - APPLESMC_MIN_WAIT, val);
 			return 0;
 		}
-		udelay(10);
 	}
 
 	printk(KERN_WARNING "applesmc: wait status failed: %x != %x\n",
@@ -206,13 +209,12 @@ static int __wait_status(u8 val)
  */
 static int send_command(u8 cmd)
 {
-	int i;
-	for (i = 0; i < 1000; i++) {
+	int us;
+	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
 		outb(cmd, APPLESMC_CMD_PORT);
-		udelay(5);
+		udelay(us);
 		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == 0x0c)
 			return 0;
-		udelay(5);
 	}
 	printk(KERN_WARNING "applesmc: command failed: %x -> %x\n",
 		cmd, inb(APPLESMC_CMD_PORT));
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

