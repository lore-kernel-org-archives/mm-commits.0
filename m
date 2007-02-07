From: akpm@linux-foundation.org
Subject: + input-schedule-removal-of-compaq-touchscreen.patch added to -mm tree
Date: Wed, 07 Feb 2007 14:38:19 -0800
Message-ID: <200702072238.l17McJdd029502@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161124AbXBGWiz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 17:38:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpurdie@rpsys.net, dtor@mail.ru, jsimmons@infradead.org


The patch titled
     input: schedule removal of compaq touchscreen emulation (tsdev.c)
has been added to the -mm tree.  Its filename is
     input-schedule-removal-of-compaq-touchscreen.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: input: schedule removal of compaq touchscreen emulation (tsdev.c)
From: Richard Purdie <rpurdie@rpsys.net>

Schedule removal of Compaq touchscreen emulation (drivers/input/tsdev.c)

Its old, was obsolete when it was written by the authors own admission
and much better userspace solutions like tslib now exist. The name is
also confusing.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
 drivers/input/tsdev.c                      |    4 ++++
 2 files changed, 18 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~input-schedule-removal-of-compaq-touchscreen Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~input-schedule-removal-of-compaq-touchscreen
+++ a/Documentation/feature-removal-schedule.txt
@@ -324,3 +324,17 @@ Why:   OSS drivers with ALSA replacement
 Who:   Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
+
+What:   Compaq touchscreen device emulation
+When:   Oct 2007
+Files:  drivers/input/tsdev.c
+Why:    The code says it was obsolete when it was written in 2001.
+        tslib is a userspace library which does anything tsdev can do and
+	much more besides in userspace where this code belongs. There is no
+	longer any need for tsdev and applications should have converted to
+	use tslib by now.
+        The name "tsdev" is also extremely confusing and lots of people have
+	it loaded when they don't need/use it.
+Who:    Richard Purdie <rpurdie@rpsys.net>
+
+---------------------------
diff -puN drivers/input/tsdev.c~input-schedule-removal-of-compaq-touchscreen drivers/input/tsdev.c
--- a/drivers/input/tsdev.c~input-schedule-removal-of-compaq-touchscreen
+++ a/drivers/input/tsdev.c
@@ -151,6 +151,10 @@ static int tsdev_open(struct inode *inod
 	int i = iminor(inode) - TSDEV_MINOR_BASE;
 	struct tsdev_list *list;
 
+	printk(KERN_WARNING "tsdev (compaq touchscreen emulation) is scheduled "
+		"for removal.\nSee Documentation/feature-removal-schedule.txt "
+		"for details.\n");
+
 	if (i >= TSDEV_MINORS || !tsdev_table[i & TSDEV_MINOR_MASK])
 		return -ENODEV;
 
_

Patches currently in -mm which might be from rpurdie@rpsys.net are

acpi-add-backlight-support-to-the-sony_acpi.patch
git-alsa.patch
input-schedule-removal-of-compaq-touchscreen.patch
