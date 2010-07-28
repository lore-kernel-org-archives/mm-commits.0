From: akpm@linux-foundation.org
Subject: + staging-iio-iio_sw_ring_helper_state-add-dummy-case-for-no-buffer-builds.patch added to -mm tree
Date: Wed, 28 Jul 2010 15:59:14 -0700
Message-ID: <201007282259.o6SMxErw007439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234Ab0G1W7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 18:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk


The patch titled
     staging:iio: iio_sw_ring_helper_state - add dummy case for no buffer builds.
has been added to the -mm tree.  Its filename is
     staging-iio-iio_sw_ring_helper_state-add-dummy-case-for-no-buffer-builds.patch

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
Subject: staging:iio: iio_sw_ring_helper_state - add dummy case for no buffer builds.
From: Jonathan Cameron <jic23@cam.ac.uk>

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/iio/ring_sw.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/staging/iio/ring_sw.h~staging-iio-iio_sw_ring_helper_state-add-dummy-case-for-no-buffer-builds drivers/staging/iio/ring_sw.h
--- a/drivers/staging/iio/ring_sw.h~staging-iio-iio_sw_ring_helper_state-add-dummy-case-for-no-buffer-builds
+++ a/drivers/staging/iio/ring_sw.h
@@ -222,5 +222,8 @@ void iio_sw_trigger_bh_to_ring(struct wo
 #else /* CONFIG_IIO_RING_BUFFER*/
 static inline void iio_ring_sw_register_funcs(struct iio_ring_access_funcs *ra)
 {};
+struct iio_sw_ring_helper_state {
+	struct iio_dev			*indio_dev;
+};
 #endif /* !CONFIG_IIO_RING_BUFFER */
 #endif /* _IIO_RING_SW_H_ */
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

linux-next.patch
staging-iio-iio_sw_ring_helper_state-add-dummy-case-for-no-buffer-builds.patch
staging-iio-lis3l02dq-add-a-thresh_timestamp-field-to-state-for-no-ring-case.patch
misc-rohm-bh1780gli-ambient-light-sensor-driver.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update.patch
add-abi-documentation-for-the-bmp085-digital-pressure-sensor.patch
bmp085-add-interface-documentation-and-link-to-datasheet.patch
hmc6352-add-driver-for-the-hmc6352-compass.patch
hwmon-driver-for-smm665-six-channel-active-dc-output-controller-monitor.patch
hwmon-smm665-driver-documentation.patch

