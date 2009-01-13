From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-fix-light-sensor-readings-on-newer-macbooks.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:51:21 -0800
Message-ID: <200901132251.n0DMpLr3018714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbZAMWvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:51:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: murray.alex@gmail.com, nicolas@boichat.ch, rydberg@euromail.se


The patch titled
     hwmon: applesmc: fix light sensor readings on newer MacBooks
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-fix-light-sensor-readings-on-newer-macbooks.patch

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
Subject: hwmon: applesmc: fix light sensor readings on newer MacBooks
From: Alex Murray <murray.alex@gmail.com>

The light sensors ALV0 and ALV1 on newer MacBooks (early 2008 and later)
changed to report 10 bytes instead the earlier 6, and the sensor encoding
subsequently changed.  As a result, the reported light sensors readings
are much too low.

Via experiments leading up to this patch, it seems only the ALV0 is
reporting data, and the most useful value therein is a 10-bit big-endian
value at offset 6.  This suggests that a new protocol was added as a
backward-compatible replacement on top of the old one.

This patch makes applesmc report the improved light sensor reading for the
new machines, on a scale in conformance with earlier ones.

Signed-off-by: Alex Murray <murray.alex@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-fix-light-sensor-readings-on-newer-macbooks drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-fix-light-sensor-readings-on-newer-macbooks
+++ a/drivers/hwmon/applesmc.c
@@ -590,6 +590,11 @@ static ssize_t applesmc_light_show(struc
 	}
 
 	ret = applesmc_read_key(LIGHT_SENSOR_LEFT_KEY, buffer, data_length);
+	/* newer macbooks report a single 10-bit bigendian value */
+	if (data_length == 10) {
+		left = be16_to_cpu(*(__be16 *)(buffer + 6)) >> 2;
+		goto out;
+	}
 	left = buffer[2];
 	if (ret)
 		goto out;
_

Patches currently in -mm which might be from murray.alex@gmail.com are

hwmon-applesmc-fix-light-sensor-readings-on-newer-macbooks.patch

