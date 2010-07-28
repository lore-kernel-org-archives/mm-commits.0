From: akpm@linux-foundation.org
Subject: + staging-iio-lis3l02dq-add-a-thresh_timestamp-field-to-state-for-no-ring-case.patch added to -mm tree
Date: Wed, 28 Jul 2010 15:59:16 -0700
Message-ID: <201007282259.o6SMxGFk007442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691Ab0G1W7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 18:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk


The patch titled
     staging:iio:lis3l02dq add a thresh_timestamp field to state for no ring case
has been added to the -mm tree.  Its filename is
     staging-iio-lis3l02dq-add-a-thresh_timestamp-field-to-state-for-no-ring-case.patch

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
Subject: staging:iio:lis3l02dq add a thresh_timestamp field to state for no ring case
From: Jonathan Cameron <jic23@cam.ac.uk>

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/iio/accel/lis3l02dq.h      |    2 ++
 drivers/staging/iio/accel/lis3l02dq_core.c |   14 +++++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/staging/iio/accel/lis3l02dq.h~staging-iio-lis3l02dq-add-a-thresh_timestamp-field-to-state-for-no-ring-case drivers/staging/iio/accel/lis3l02dq.h
--- a/drivers/staging/iio/accel/lis3l02dq.h~staging-iio-lis3l02dq-add-a-thresh_timestamp-field-to-state-for-no-ring-case
+++ a/drivers/staging/iio/accel/lis3l02dq.h
@@ -151,6 +151,7 @@ Form of high byte dependant on justifica
  * @helper:		data and func pointer allowing generic functions
  * @us:			actual spi_device
  * @work_thresh:	bh for threshold events
+ * @thresh_timestamp:	timestamp for threshold interrupts.
  * @inter:		used to check if new interrupt has been triggered
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
@@ -161,6 +162,7 @@ struct lis3l02dq_state {
 	struct iio_sw_ring_helper_state	help;
 	struct spi_device		*us;
 	struct work_struct		work_thresh;
+	s64				thresh_timestamp;
 	bool				inter;
 	struct iio_trigger		*trig;
 	u8				*tx;
diff -puN drivers/staging/iio/accel/lis3l02dq_core.c~staging-iio-lis3l02dq-add-a-thresh_timestamp-field-to-state-for-no-ring-case drivers/staging/iio/accel/lis3l02dq_core.c
--- a/drivers/staging/iio/accel/lis3l02dq_core.c~staging-iio-lis3l02dq-add-a-thresh_timestamp-field-to-state-for-no-ring-case
+++ a/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -615,7 +615,7 @@ static int lis3l02dq_thresh_handler_th(s
 	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 
 	/* Stash the timestamp somewhere convenient for the bh */
-	h->last_timestamp = timestamp;
+	st->thresh_timestamp = timestamp;
 	schedule_work(&st->work_thresh);
 
 	return 0;
@@ -640,32 +640,32 @@ static void lis3l02dq_thresh_handler_bh_
 	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH)
 		iio_push_event(st->help.indio_dev, 0,
 			       IIO_EVENT_CODE_ACCEL_Z_HIGH,
-			       st->help.last_timestamp);
+			       st->thresh_timestamp);
 
 	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW)
 		iio_push_event(st->help.indio_dev, 0,
 			       IIO_EVENT_CODE_ACCEL_Z_LOW,
-			       st->help.last_timestamp);
+			       st->thresh_timestamp);
 
 	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH)
 		iio_push_event(st->help.indio_dev, 0,
 			       IIO_EVENT_CODE_ACCEL_Y_HIGH,
-			       st->help.last_timestamp);
+			       st->thresh_timestamp);
 
 	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_LOW)
 		iio_push_event(st->help.indio_dev, 0,
 			       IIO_EVENT_CODE_ACCEL_Y_LOW,
-			       st->help.last_timestamp);
+			       st->thresh_timestamp);
 
 	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_HIGH)
 		iio_push_event(st->help.indio_dev, 0,
 			       IIO_EVENT_CODE_ACCEL_X_HIGH,
-			       st->help.last_timestamp);
+			       st->thresh_timestamp);
 
 	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_LOW)
 		iio_push_event(st->help.indio_dev, 0,
 			       IIO_EVENT_CODE_ACCEL_X_LOW,
-			       st->help.last_timestamp);
+			       st->thresh_timestamp);
 	/* reenable the irq */
 	enable_irq(st->us->irq);
 	/* Ack and allow for new interrupts */
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

