From: akpm@linux-foundation.org
Subject: + bmp085-add-interface-documentation-and-link-to-datasheet.patch added to -mm tree
Date: Thu, 01 Jul 2010 14:09:03 -0700
Message-ID: <201007012109.o61L93aw027341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932576Ab0GAVKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 17:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christoph.mair@gmail.com, jic23@cam.ac.uk, shubhrajyoti@ti.com, stefan@datenfreihafen.org


The patch titled
     bmp085: Add interface documentation and link to datasheet.
has been added to the -mm tree.  Its filename is
     bmp085-add-interface-documentation-and-link-to-datasheet.patch

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
Subject: bmp085: Add interface documentation and link to datasheet.
From: Christoph Mair <christoph.mair@gmail.com>

Signed-off-by: Christoph Mair <christoph.mair@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Datta Shubhrajyoti <shubhrajyoti@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/bmp085.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN drivers/misc/bmp085.c~bmp085-add-interface-documentation-and-link-to-datasheet drivers/misc/bmp085.c
--- a/drivers/misc/bmp085.c~bmp085-add-interface-documentation-and-link-to-datasheet
+++ a/drivers/misc/bmp085.c
@@ -1,5 +1,32 @@
 /*  Copyright (c) 2010  Christoph Mair <christoph.mair@gmail.com>
 
+    This driver supports the bmp085 digital barometric pressure
+    and temperature sensor from Bosch Sensortec. The datasheet
+    is avaliable from their website:
+    http://www.bosch-sensortec.com/content/language1/downloads/BST-BMP085-DS000-05.pdf
+
+    A pressure measurement is issued by reading from pressure0_input.
+    The return value ranges from 30000 to 110000 pascal with a resulution
+    of 1 pascal (0.01 millibar) which enables measurements from 9000m above
+    to 500m below sea level.
+
+    The temperature can be read from temp0_input. Values range from
+    -400 to 850 representing the ambient temperature in degree celsius
+    multiplied by 10.The resolution is 0.1 celsius.
+
+    Because ambient pressure is temperature dependent, a temperature
+    measurement will be executed automatically even if the user is reading
+    from pressure0_input. This happens if the last temperature measurement
+    has been executed more then one second ago.
+
+    To decrease RMS noise from pressure measurements, the bmp085 can
+    autonomously calculate the average of up to eight samples. This is
+    set up by writing to the oversampling sysfs file. Accepted values
+    are 0, 1, 2 and 3. 2^x when x is the value written to this file
+    specifies the number of samples used to calculate the ambient pressure.
+    RMS noise is specified with six pascal (without averaging) and decreases
+    down to 3 pascal when using an oversampling setting of 3.
+
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
_

Patches currently in -mm which might be from christoph.mair@gmail.com are

drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update.patch
add-abi-documentation-for-the-bmp085-digital-pressure-sensor.patch
bmp085-add-interface-documentation-and-link-to-datasheet.patch

