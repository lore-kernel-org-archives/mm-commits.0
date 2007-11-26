From: akpm@linux-foundation.org
Subject: + fb_ddc-fix-ddc-lines-quirk.patch added to -mm tree
Date: Mon, 26 Nov 2007 14:30:23 -0800
Message-ID: <200711262230.lAQMUP1W026401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55550 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753AbXKZWbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 17:31:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, adaplas@pol.net, benh@kernel.crashing.org, mb@bu3sch.de, rleigh@whinlatter.ukfsn.org


The patch titled
     fb_ddc: fix DDC lines quirk
has been added to the -mm tree.  Its filename is
     fb_ddc-fix-ddc-lines-quirk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fb_ddc: fix DDC lines quirk
From: Jean Delvare <khali@linux-fr.org>

The code in fb_ddc_read() is said to be based on the implementation of the
radeon driver:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fc5891c8a3ba284f13994d7bc1f1bfa8283982de

However, comparing the old radeon driver code with the new fb_ddc code
reveals some differences.  Most notably, the I2C bus lines are held at the
end of the function, while the original code was releasing them (as the
comment above correctly says.)

There are a few other differences, which appear to be responsible for read
failures on my system.  While tracing low-level I2C code in i2c-algo-bit, I
noticed that the initial attempt to read the EDID always failed.  It takes
one retry for the read to succeed.  As we are about to remove this
automatic retry property from i2c-algo-bit, reading the EDID would really
fail.

As a summary, the I2C lines quirk which is supposedly needed to read EDID
on some older monitors is currently breaking the (first) read on all other
monitors (and might not even work with older ones - did anyone try since
October 2006?)

After applying the patch below, which makes the code in fb_ddc_read()
really similar to what the radeon driver used to have, the first EDID read
succeeds again.

On top of that, as it appears that this code has been broken for one year
now and nobody seems to have complained, I'm curious if it makes sense to
keep this quirk in place.  It makes the code more complex and slower just
for the sake of monitors which I guess nobody uses anymore.  Can't we just
get rid of it?

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Roger Leigh <rleigh@whinlatter.ukfsn.org>
Tested-by: Michael Buesch <mb@bu3sch.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fb_ddc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/fb_ddc.c~fb_ddc-fix-ddc-lines-quirk drivers/video/fb_ddc.c
--- a/drivers/video/fb_ddc.c~fb_ddc-fix-ddc-lines-quirk
+++ a/drivers/video/fb_ddc.c
@@ -56,13 +56,12 @@ unsigned char *fb_ddc_read(struct i2c_ad
 	int i, j;
 
 	algo_data->setscl(algo_data->data, 1);
-	algo_data->setscl(algo_data->data, 0);
 
 	for (i = 0; i < 3; i++) {
 		/* For some old monitors we need the
 		 * following process to initialize/stop DDC
 		 */
-		algo_data->setsda(algo_data->data, 0);
+		algo_data->setsda(algo_data->data, 1);
 		msleep(13);
 
 		algo_data->setscl(algo_data->data, 1);
@@ -97,14 +96,15 @@ unsigned char *fb_ddc_read(struct i2c_ad
 		algo_data->setsda(algo_data->data, 1);
 		msleep(15);
 		algo_data->setscl(algo_data->data, 0);
+		algo_data->setsda(algo_data->data, 0);
 		if (edid)
 			break;
 	}
 	/* Release the DDC lines when done or the Apple Cinema HD display
 	 * will switch off
 	 */
-	algo_data->setsda(algo_data->data, 0);
-	algo_data->setscl(algo_data->data, 0);
+	algo_data->setsda(algo_data->data, 1);
+	algo_data->setscl(algo_data->data, 1);
 
 	return edid;
 }
_

Patches currently in -mm which might be from khali@linux-fr.org are

fb_ddc-fix-ddc-lines-quirk.patch
git-acpi.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
git-hwmon.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
