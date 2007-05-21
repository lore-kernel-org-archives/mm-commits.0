From: akpm@linux-foundation.org
Subject: + wistron_btns-reduce-polling-frequency-to-save-power.patch added to -mm tree
Date: Sun, 20 May 2007 21:12:37 -0700
Message-ID: <200705210412.l4L4Ca9v002083@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUEO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, dtor@mail.ru


The patch titled
     wistron_btns: reduce polling frequency (to save power)
has been added to the -mm tree.  Its filename is
     wistron_btns-reduce-polling-frequency-to-save-power.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wistron_btns: reduce polling frequency (to save power)
From: Eric Piel <eric.piel@tremplin-utc.net>

wriston_btns: Reduce polling frequency

Reduces the polling frequency from 10 Hz to 2 Hz, which should be less a
burden for laptops wrt energy saving.  As it is multimedia keys, 500ms
(maximum) of latency should be still fine for the user.  In order to keep
fluent the feeling when the user is pressing several keys in a raw (such as
changing the volume), the frequency is increased for a short duration after
a key is pressed.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/wistron_btns.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN drivers/input/misc/wistron_btns.c~wistron_btns-reduce-polling-frequency-to-save-power drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wistron_btns-reduce-polling-frequency-to-save-power
+++ a/drivers/input/misc/wistron_btns.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/mc146818rtc.h>
 #include <linux/module.h>
@@ -38,9 +39,10 @@
  */
 #define MAX_POLL_ITERATIONS 64
 
-#define POLL_FREQUENCY 10 /* Number of polls per second */
+#define POLL_FREQUENCY 2 /* Number of polls per second when idle */
+#define POLL_FREQUENCY_BURST 10 /* Polls per second when a key was recently pressed */
 
-#if POLL_FREQUENCY > HZ
+#if POLL_FREQUENCY_BURST > HZ
 #error "POLL_FREQUENCY too high"
 #endif
 
@@ -1161,6 +1163,8 @@ static void handle_key(u8 code)
 
 static void poll_bios(unsigned long discard)
 {
+	static unsigned long jiffies_last_press;
+	unsigned long jiffies_now = jiffies;
 	u8 qlen;
 	u16 val;
 
@@ -1169,11 +1173,17 @@ static void poll_bios(unsigned long disc
 		if (qlen == 0)
 			break;
 		val = bios_pop_queue();
-		if (val != 0 && !discard)
+		if (val != 0 && !discard) {
 			handle_key((u8)val);
+			jiffies_last_press = jiffies_now;
+		}
 	}
 
-	mod_timer(&poll_timer, jiffies + HZ / POLL_FREQUENCY);
+	/* Increase precision if user is currently pressing keys (< 2s ago) */
+	if (time_after(jiffies_last_press, jiffies_now - (HZ * 2)))
+		mod_timer(&poll_timer, jiffies_now + HZ / POLL_FREQUENCY_BURST);
+	else
+		mod_timer(&poll_timer, jiffies_now + HZ / POLL_FREQUENCY);
 }
 
 static int __devinit wistron_probe(struct platform_device *dev)
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

wistron_btns-add-led-support.patch
wistron_btns-reduce-polling-frequency-to-save-power.patch
