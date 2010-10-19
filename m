From: akpm@linux-foundation.org
Subject: + documentation-short-descriptions-for-bh1770glc-and-apds990x-drivers.patch added to -mm tree
Date: Tue, 19 Oct 2010 16:21:02 -0700
Message-ID: <201010192321.o9JNL2M9012487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab0JSXVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Oct 2010 19:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, jic23@cam.ac.uk


The patch titled
     Documentation: short descriptions for bh1770glc and apds990x drivers
has been added to the -mm tree.  Its filename is
     documentation-short-descriptions-for-bh1770glc-and-apds990x-drivers.patch

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
Subject: Documentation: short descriptions for bh1770glc and apds990x drivers
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Add short documentation for two ALS / proximity chip drivers.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/misc-devices/apds990x.txt  |  111 ++++++++++++++++++++
 Documentation/misc-devices/bh1770glc.txt |  116 +++++++++++++++++++++
 2 files changed, 227 insertions(+)

diff -puN /dev/null Documentation/misc-devices/apds990x.txt
--- /dev/null
+++ a/Documentation/misc-devices/apds990x.txt
@@ -0,0 +1,111 @@
+Kernel driver apds990x
+======================
+
+Supported chips:
+Avago APDS990X
+
+Data sheet:
+Not freely available
+
+Author:
+Samu Onkalo <samu.p.onkalo@nokia.com>
+
+Description
+-----------
+
+APDS990x is a combined ambient light and proximity sensor. ALS and proximity
+functionality are highly connected. ALS measurement path must be running
+while the proximity functionality is enabled.
+
+ALS produces raw measurement values for two channels: Clear channel
+(infrared + visible light) and IR only. However, threshold comparisons happen
+using clear channel only. Lux value and the threshold level on the HW
+might vary quite much depending the spectrum of the light source.
+
+Driver makes necessary conversions to both directions so that user handles
+only lux values. Lux value is calculated using information from the both
+channels. HW threshold level is calculated from the given lux value to match
+with current type of the lightning. Sometimes inaccuracy of the estimations
+lead to false interrupt, but that doesn't harm.
+
+ALS contains 4 different gain steps. Driver automatically
+selects suitable gain step. After each measurement, reliability of the results
+is estimated and new measurement is trigged if necessary.
+
+Platform data can provide tuned values to the conversion formulas if
+values are known. Otherwise plain sensor default values are used.
+
+Proximity side is little bit simpler. There is no need for complex conversions.
+It produces directly usable values.
+
+Driver controls chip operational state using pm_runtime framework.
+Voltage regulators are controlled based on chip operational state.
+
+SYSFS
+-----
+
+
+chip_id
+	RO - shows detected chip type and version
+
+power_state
+	RW - enable / disable chip. Uses counting logic
+	     1 enables the chip
+	     0 disables the chip
+lux0_input
+	RO - measured lux value
+	     sysfs_notify called when threshold interrupt occurs
+
+lux0_sensor_range
+	RO - lux0_input max value. Actually never reaches since sensor tends
+	     to saturate much before that. Real max value varies depending
+	     on the light spectrum etc.
+
+lux0_rate
+	RW - measurement rate in Hz
+
+lux0_rate_avail
+	RO - supported measurement rates
+
+lux0_calibscale
+	RW - calibration value. Set to neutral value by default.
+	     Output results are multiplied with calibscale / calibscale_default
+	     value.
+
+lux0_calibscale_default
+	RO - neutral calibration value
+
+lux0_thresh_above_value
+	RW - HI level threshold value. All results above the value
+	     trigs an interrupt. 65535 (i.e. sensor_range) disables the above
+	     interrupt.
+
+lux0_thresh_below_value
+	RW - LO level threshold value. All results below the value
+	     trigs an interrupt. 0 disables the below interrupt.
+
+prox0_raw
+	RO - measured proximity value
+	     sysfs_notify called when threshold interrupt occurs
+
+prox0_sensor_range
+	RO - prox0_raw max value (1023)
+
+prox0_raw_en
+	RW - enable / disable proximity - uses counting logic
+	     1 enables the proximity
+	     0 disables the proximity
+
+prox0_reporting_mode
+	RW - trigger / periodic. In "trigger" mode the driver tells two possible
+	     values: 0 or prox0_sensor_range value. 0 means no proximity,
+	     1023 means proximity. This causes minimal number of interrupts.
+	     In "periodic" mode the driver reports all values above
+	     prox0_thresh_above. This causes more interrupts, but it can give
+	     _rough_ estimate about the distance.
+
+prox0_reporting_mode_avail
+	RO - accepted values to prox0_reporting_mode (trigger, periodic)
+
+prox0_thresh_above_value
+	RW - threshold level which trigs proximity events.
diff -puN /dev/null Documentation/misc-devices/bh1770glc.txt
--- /dev/null
+++ a/Documentation/misc-devices/bh1770glc.txt
@@ -0,0 +1,116 @@
+Kernel driver bh1770glc
+=======================
+
+Supported chips:
+ROHM BH1770GLC
+OSRAM SFH7770
+
+Data sheet:
+Not freely available
+
+Author:
+Samu Onkalo <samu.p.onkalo@nokia.com>
+
+Description
+-----------
+BH1770GLC and SFH7770 are combined ambient light and proximity sensors.
+ALS and proximity parts operates on their own, but they shares common I2C
+interface and interrupt logic. In principle they can run on their own,
+but ALS side results are used to estimate reliability of the proximity sensor.
+
+ALS produces 16 bit lux values. The chip contains interrupt logic to produce
+low and high threshold interrupts.
+
+Proximity part contains IR-led driver up to 3 IR leds. The chip measures
+amount of reflected IR light and produces proximity result. Resolution is
+8 bit. Driver supports only one channel. Driver uses ALS results to estimate
+reliability of the proximity results. Thus ALS is always running while
+proximity detection is needed.
+
+Driver uses threshold interrupts to avoid need for polling the values.
+Proximity low interrupt doesn't exists in the chip. This is simulated
+by using a delayed work. As long as there is proximity threshold above
+interrupts the delayed work is pushed forward. So, when proximity level goes
+below the threshold value, there is no interrupt and the delayed work will
+finally run. This is handled as no proximity indication.
+
+Chip state is controlled via runtime pm framework when enabled in config.
+
+Calibscale factor is used to hide differences between the chips. By default
+value set to neutral state meaning factor of 1.00. To get proper values,
+calibrated source of light is needed as a reference. Calibscale factor is set
+so that measurement produces about the expected lux value.
+
+SYSFS
+-----
+
+chip_id
+	RO - shows detected chip type and version
+
+power_state
+	RW - enable / disable chip. Uses counting logic
+	     1 enables the chip
+	     0 disables the chip
+
+lux0_input
+	RO - measured lux value
+	     sysfs_notify called when threshold interrupt occurs
+
+lux0_sensor_range
+	RO - lux0_input max value
+
+lux0_rate
+	RW - measurement rate in Hz
+
+lux0_rate_avail
+	RO - supported measurement rates
+
+lux0_thresh_above_value
+	RW - HI level threshold value. All results above the value
+	     trigs an interrupt. 65535 (i.e. sensor_range) disables the above
+	     interrupt.
+
+lux0_thresh_below_value
+	RW - LO level threshold value. All results below the value
+	     trigs an interrupt. 0 disables the below interrupt.
+
+lux0_calibscale
+	RW - calibration value. Set to neutral value by default.
+	     Output results are multiplied with calibscale / calibscale_default
+	     value.
+
+lux0_calibscale_default
+	RO - neutral calibration value
+
+prox0_raw
+	RO - measured proximity value
+	     sysfs_notify called when threshold interrupt occurs
+
+prox0_sensor_range
+	RO - prox0_raw max value
+
+prox0_raw_en
+	RW - enable / disable proximity - uses counting logic
+	     1 enables the proximity
+	     0 disables the proximity
+
+prox0_thresh_above_count
+	RW - number of proximity interrupts needed before triggering the event
+
+prox0_rate_above
+	RW - Measurement rate (in Hz) when the level is above threshold
+	     i.e. when proximity on has been reported.
+
+prox0_rate_below
+	RW - Measurement rate (in Hz) when the level is below threshold
+	     i.e. when proximity off has been reported.
+
+prox0_rate_avail
+	RO - Supported proximity measurement rates in Hz
+
+prox0_thresh_above0_value
+	RW - threshold level which trigs proximity events.
+	     Filtered by persistence filter (prox0_thresh_above_count)
+
+prox0_thresh_above1_value
+	RW - threshold level which trigs event immediately
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

linux-next.patch
leds-driver-for-national-semiconductor-lp5521-chip.patch
leds-driver-for-national-semiconductors-lp5523-chip.patch
leds-update-lp552x-support-kconfig-and-makefile.patch
documentation-led-drivers-lp5521-and-lp5523.patch
misc-driver-for-bh1770glc-sfh7770-als-and-proximity-sensor.patch
misc-update-bh1770glc-driver-to-kconfig-and-makefile.patch
misc-driver-for-apds990x-als-and-proximity-sensors.patch
misc-update-apds990x-driver-to-kconfig-and-makefile.patch
documentation-short-descriptions-for-bh1770glc-and-apds990x-drivers.patch

