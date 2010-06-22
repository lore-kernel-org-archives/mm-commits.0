From: akpm@linux-foundation.org
Subject: + drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update.patch added to -mm tree
Date: Tue, 22 Jun 2010 14:26:28 -0700
Message-ID: <201006222126.o5MLQSOl002994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab0FVV1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 17:27:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shubhrajyoti@ti.com, christoph.mair@gmail.com, jic23@cam.ac.uk, stefan@datenfreihafen.org


The patch titled
     drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update
has been added to the -mm tree.  Its filename is
     drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update.patch

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
Subject: drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update
From: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>

- Optimize the wait time for the pressure sensor
- Definition of long is arch dependent so make it u32.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: Christoph Mair <christoph.mair@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/bmp085.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/bmp085.c~drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update drivers/misc/bmp085.c
--- a/drivers/misc/bmp085.c~drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update
+++ a/drivers/misc/bmp085.c
@@ -60,7 +60,7 @@ struct bmp085_data {
 	u32 raw_temperature;
 	u32 raw_pressure;
 	unsigned char oversampling_setting;
-	unsigned long last_temp_measurement;
+	u32 last_temp_measurement;
 	s32 b6; /* calculated temperature correction coefficient */
 };
 
@@ -144,7 +144,7 @@ static s32 bmp085_update_raw_pressure(st
 	}
 
 	/* wait for the end of conversion */
-	msleep(2+(3 << data->oversampling_setting<<1));
+	msleep(2+(3 << data->oversampling_setting ));
 
 	/* copy data into a u32 (4 bytes), but skip the first byte. */
 	status = i2c_smbus_read_i2c_block_data(data->client,
_

Patches currently in -mm which might be from shubhrajyoti@ti.com are

linux-next.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update.patch

