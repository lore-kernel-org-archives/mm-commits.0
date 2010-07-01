From: akpm@linux-foundation.org
Subject: + add-abi-documentation-for-the-bmp085-digital-pressure-sensor.patch added to -mm tree
Date: Thu, 01 Jul 2010 14:09:00 -0700
Message-ID: <201007012109.o61L9002027337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932544Ab0GAVKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 17:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christoph.mair@gmail.com, jic23@cam.ac.uk, shubhrajyoti@ti.com, stefan@datenfreihafen.org


The patch titled
     Add ABI documentation for the bmp085 digital pressure sensor.
has been added to the -mm tree.  Its filename is
     add-abi-documentation-for-the-bmp085-digital-pressure-sensor.patch

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
Subject: Add ABI documentation for the bmp085 digital pressure sensor.
From: Christoph Mair <christoph.mair@gmail.com>

Signed-off-by: Christoph Mair <christoph.mair@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Datta Shubhrajyoti <shubhrajyoti@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-i2c-bmp085 |   31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-i2c-bmp085
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-i2c-bmp085
@@ -0,0 +1,31 @@
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/pressure0_input
+Date:		June 2010
+Contact:	Christoph Mair <christoph.mair@gmail.com>
+Description:	Start a pressure measurement and read the result. Values
+		represent the ambient air pressure in pascal (0.01 millibar).
+
+		Reading: returns the current air pressure.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/temp0_input
+Date:		June 2010
+Contact:	Christoph Mair <christoph.mair@gmail.com>
+Description:	Measure the ambient temperature. The returned value represents
+		the ambient temperature in units of 0.1 degree celsius.
+
+		Reading: returns the current temperature.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/oversampling
+Date:		June 2010
+Contact:	Christoph Mair <christoph.mair@gmail.com>
+Description:	Tell the bmp085 to use more samples to calculate a pressure
+		value. When writing to this file the chip will use 2^x samples
+		to calculate the next pressure value with x being the value
+		written. Using this feature will decrease RMS noise and
+		increase the measurement time.
+
+		Reading: returns the current oversampling setting.
+
+		Writing: sets a new oversampling setting.
+		Accepted values: 0..3.
_

Patches currently in -mm which might be from christoph.mair@gmail.com are

drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update.patch
add-abi-documentation-for-the-bmp085-digital-pressure-sensor.patch
bmp085-add-interface-documentation-and-link-to-datasheet.patch

