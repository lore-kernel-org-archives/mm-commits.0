From: akpm@linux-foundation.org
Subject: + w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:07 -0700
Message-ID: <200807310316.m6V3G7GQ001141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756389AbYGaDR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: feature, w1_therm.c use strong pullup and documentation
has been added to the -mm tree.  Its filename is
     w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: feature, w1_therm.c use strong pullup and documentation
From: David Fries <david@fries.net>

Added strong pullup to thermal sensor driver and general documentation on
the sensor.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/00-INDEX        |    2 +
 Documentation/w1/slaves/00-INDEX |    4 ++
 Documentation/w1/slaves/w1_therm |   41 +++++++++++++++++++++++++++++
 drivers/w1/slaves/w1_therm.c     |   15 +++++++++-
 4 files changed, 60 insertions(+), 2 deletions(-)

diff -puN Documentation/w1/00-INDEX~w1-feature-w1_thermc-use-strong-pullup-and-documentation Documentation/w1/00-INDEX
--- a/Documentation/w1/00-INDEX~w1-feature-w1_thermc-use-strong-pullup-and-documentation
+++ a/Documentation/w1/00-INDEX
@@ -1,5 +1,7 @@
 00-INDEX
 	- This file
+slaves/
+	- Drivers that provide support for specific family codes.
 masters/
 	- Individual chips providing 1-wire busses.
 w1.generic
diff -puN /dev/null Documentation/w1/slaves/00-INDEX
--- /dev/null
+++ a/Documentation/w1/slaves/00-INDEX
@@ -0,0 +1,4 @@
+00-INDEX
+	- This file
+w1_therm
+	- The Maxim/Dallas Semiconductor ds18*20 temperature sensor.
diff -puN /dev/null Documentation/w1/slaves/w1_therm
--- /dev/null
+++ a/Documentation/w1/slaves/w1_therm
@@ -0,0 +1,41 @@
+Kernel driver w1_therm
+====================
+
+Supported chips:
+  * Maxim ds18*20 based temperature sensors.
+
+Author: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+
+
+Description
+-----------
+
+w1_therm provides basic temperature conversion for ds18*20 devices.
+supported family codes:
+W1_THERM_DS18S20	0x10
+W1_THERM_DS1822		0x22
+W1_THERM_DS18B20	0x28
+
+Support is provided through the sysfs w1_slave file.  Each open and
+read sequence will initiate a temperature conversion then provide two
+lines of ASCII output.  The first line contains the nine hex bytes
+read along with a calculated crc value and YES or NO if it matched.
+If the crc matched the returned values are retained.  The second line
+displays the retained values along with a temperature in millidegrees
+Centigrade after t=.
+
+Parasite powered devices are limited to one slave performing a
+temperature conversion at a time.  If none of the devices are parasite
+powered it would be possible to convert all the devices at the same
+time and then go back to read individual sensors.  That isn't
+currently supported.  The driver also doesn't support reduced
+precision (which would also reduce the conversion time).
+
+The module parameter strong_pullup can be set to 0 to disable the
+strong pullup or 1 to enable.  If enabled the 5V strong pullup will be
+enabled when the conversion is taking place provided the master driver
+must support the strong pullup (or it falls back to a pullup
+resistor).  The DS18b20 temperature sensor specification lists a
+maximum current draw of 1.5mA and that a 5k pullup resistor is not
+sufficient.  The strong pullup is designed to provide the additional
+current required.
diff -puN drivers/w1/slaves/w1_therm.c~w1-feature-w1_thermc-use-strong-pullup-and-documentation drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-feature-w1_thermc-use-strong-pullup-and-documentation
+++ a/drivers/w1/slaves/w1_therm.c
@@ -37,6 +37,14 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol, temperature family.");
 
+/* Allow the strong pullup to be disabled, but default to enabled.
+ * If it was disabled a parasite powered device might not get the require
+ * current to do a temperature conversion.  If it is enabled parasite powered
+ * devices have a better chance of getting the current required.
+ */
+static int w1_strong_pullup = 1;
+module_param_named(strong_pullup, w1_strong_pullup, int, 0);
+
 static u8 bad_roms[][9] = {
 				{0xaa, 0x00, 0x4b, 0x46, 0xff, 0xff, 0x0c, 0x10, 0x87},
 				{}
@@ -192,9 +200,12 @@ static ssize_t w1_therm_read_bin(struct 
 			int count = 0;
 			unsigned int tm = 750;
 
+			/* 750ms strong pullup (or delay) after the convert */
+			if (w1_strong_pullup)
+				w1_next_pullup(dev, tm);
 			w1_write_8(dev, W1_CONVERT_TEMP);
-
-			msleep(tm);
+			if (!w1_strong_pullup)
+				msleep(tm);
 
 			if (!w1_reset_select_slave(sl)) {
 
_

Patches currently in -mm which might be from david@fries.net are

w1-fix-deadlocks-and-remove-w1_control_thread.patch
w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-recode-w1_slave_found-logic.patch
w1-new-module-parameter-search_count.patch
w1-document-add-remove-search_count-and-pullup.patch
w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch

