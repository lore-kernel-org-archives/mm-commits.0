From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-fix-the-wait-status-failed-c-=-8-problem.patch added to -mm tree
Date: Fri, 19 Sep 2008 15:55:37 -0700
Message-ID: <200809192255.m8JMtcjn010701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbYISWz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, rkoktarianto@gmail.com


The patch titled
     hwmon: applesmc: fix the 'wait status failed: c != 8' problem
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-fix-the-wait-status-failed-c-=-8-problem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: fix the 'wait status failed: c != 8' problem
From: Henrik Rydberg <rydberg@euromail.se>

On many Macbooks since mid 2007, the Pro, C2D and Air models, applesmc
fails to read some or all SMC ports.  This problem has various effects,
such as flooded logfiles, malfunctioning temperature sensors,
accelerometers failing to initialize, and difficulties getting backlight
functionality to work properly.

The root of the problem seems to be the command protocol.  The current
code sends out a command byte, then repeatedly polls for an ack before
continuing to send or recieve data.  From experiments leading to this
patch, it seems the command protocol never quite worked or changed so that
one now sends a command byte, waits a little bit, polls for an ack, and if
it fails, repeats the whole thing by sending the command byte again.

This patch implements a send_command function according to the new
interpretation of the protocol, and should work also for earlier models.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-fix-the-wait-status-failed-c-=-8-problem drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-fix-the-wait-status-failed-c-=-8-problem
+++ a/drivers/hwmon/applesmc.c
@@ -191,6 +191,26 @@ static int __wait_status(u8 val)
 }
 
 /*
+ * special treatment of command port - on newer macbooks, it seems necessary
+ * to resend the command byte before polling the status again. Callers must
+ * hold applesmc_lock.
+ */
+static int send_command(u8 cmd)
+{
+	int i;
+	for (i = 0; i < 1000; i++) {
+		outb(cmd, APPLESMC_CMD_PORT);
+		udelay(5);
+		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == 0x0c)
+			return 0;
+		udelay(5);
+	}
+	printk(KERN_WARNING "applesmc: command failed: %x -> %x\n",
+		cmd, inb(APPLESMC_CMD_PORT));
+	return -EIO;
+}
+
+/*
  * applesmc_read_key - reads len bytes from a given key, and put them in buffer.
  * Returns zero on success or a negative error on failure. Callers must
  * hold applesmc_lock.
@@ -205,8 +225,7 @@ static int applesmc_read_key(const char*
 		return -EINVAL;
 	}
 
-	outb(APPLESMC_READ_CMD, APPLESMC_CMD_PORT);
-	if (__wait_status(0x0c))
+	if (send_command(APPLESMC_READ_CMD))
 		return -EIO;
 
 	for (i = 0; i < 4; i++) {
@@ -249,8 +268,7 @@ static int applesmc_write_key(const char
 		return -EINVAL;
 	}
 
-	outb(APPLESMC_WRITE_CMD, APPLESMC_CMD_PORT);
-	if (__wait_status(0x0c))
+	if (send_command(APPLESMC_WRITE_CMD))
 		return -EIO;
 
 	for (i = 0; i < 4; i++) {
@@ -284,8 +302,7 @@ static int applesmc_get_key_at_index(int
 	readkey[2] = index >> 8;
 	readkey[3] = index;
 
-	outb(APPLESMC_GET_KEY_BY_INDEX_CMD, APPLESMC_CMD_PORT);
-	if (__wait_status(0x0c))
+	if (send_command(APPLESMC_GET_KEY_BY_INDEX_CMD))
 		return -EIO;
 
 	for (i = 0; i < 4; i++) {
@@ -315,8 +332,7 @@ static int applesmc_get_key_type(char* k
 {
 	int i;
 
-	outb(APPLESMC_GET_KEY_TYPE_CMD, APPLESMC_CMD_PORT);
-	if (__wait_status(0x0c))
+	if (send_command(APPLESMC_GET_KEY_TYPE_CMD))
 		return -EIO;
 
 	for (i = 0; i < 4; i++) {
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual.patch
hwmon-applesmc-fix-the-wait-status-failed-c-=-8-problem.patch
hwmon-applesmc-prolong-status-wait.patch
hwmon-applesmc-allow-for-variable-alv0-and-alv1-package-length.patch
hwmon-applesmc-add-support-for-macbook-air.patch

