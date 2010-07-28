From: akpm@linux-foundation.org
Subject: + staging-iio-adis16350-add-dummy-ring-functions-for-no-ring-build-case.patch added to -mm tree
Date: Wed, 28 Jul 2010 16:18:29 -0700
Message-ID: <201007282318.o6SNITPI008347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212Ab0G1XSh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 19:18:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk


The patch titled
     staging:iio:adis16350 add dummy ring functions for no ring build case
has been added to the -mm tree.  Its filename is
     staging-iio-adis16350-add-dummy-ring-functions-for-no-ring-build-case.patch

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
Subject: staging:iio:adis16350 add dummy ring functions for no ring build case
From: Jonathan Cameron <jic23@cam.ac.uk>

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/iio/imu/adis16350.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/staging/iio/imu/adis16350.h~staging-iio-adis16350-add-dummy-ring-functions-for-no-ring-build-case drivers/staging/iio/imu/adis16350.h
--- a/drivers/staging/iio/imu/adis16350.h~staging-iio-adis16350-add-dummy-ring-functions-for-no-ring-build-case
+++ a/drivers/staging/iio/imu/adis16350.h
@@ -165,5 +165,13 @@ adis16350_read_data_from_ring(struct dev
 	return 0;
 }
 
+int adis16350_configure_ring(struct iio_dev *indio_dev)
+{
+	return 0;
+}
+
+void adis16350_unconfigure_ring(struct iio_dev *indio_dev)
+{
+}
 #endif /* CONFIG_IIO_RING_BUFFER */
 #endif /* SPI_ADIS16350_H_ */
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

linux-next.patch
staging-iio-iio_sw_ring_helper_state-add-dummy-case-for-no-buffer-builds.patch
staging-iio-lis3l02dq-add-a-thresh_timestamp-field-to-state-for-no-ring-case.patch
staging-iio-adis16350-add-dummy-ring-functions-for-no-ring-build-case.patch
misc-rohm-bh1780gli-ambient-light-sensor-driver.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update.patch
add-abi-documentation-for-the-bmp085-digital-pressure-sensor.patch
bmp085-add-interface-documentation-and-link-to-datasheet.patch
hmc6352-add-driver-for-the-hmc6352-compass.patch
hwmon-driver-for-smm665-six-channel-active-dc-output-controller-monitor.patch
hwmon-smm665-driver-documentation.patch

