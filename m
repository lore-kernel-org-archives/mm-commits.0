From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch added
 to -mm tree
Date: Tue, 21 May 2013 14:42:43 -0700
Message-ID: <519bea53.CtLanD1rQwj8KsJC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3EUVmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 17:42:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lars@metafoo.de, john.stultz@linaro.org, jkosina@suse.cz, jic23@cam.ac.uk, jg1.han@samsung.com, a.zummo@towertech.it, holler@ahsoftware.de

Subject: + rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch added to -mm tree
To: holler@ahsoftware.de,a.zummo@towertech.it,jg1.han@samsung.com,jic23@cam.ac.uk,jkosina@suse.cz,john.stultz@linaro.org,lars@metafoo.de
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 14:42:43 -0700


The patch titled
     Subject: rtc: rtc-hid-sensor-time: add option hctosys to set time at boot
has been added to the -mm tree.  Its filename is
     rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Holler <holler@ahsoftware.de>
Subject: rtc: rtc-hid-sensor-time: add option hctosys to set time at boot

drivers/rtc/hctosys (CONFIG_RTC_HCTOSYS) doesn't work for
rtc-hid-sensor-time because it will be called in late_init, and thus before
rtc-hid-sensor-time gets loaded. To set the time through
rtc-hid-sensor-time at startup, the module now checks by default if the
system time is before 1970-01-02 and sets the system time (once) if this is
the case.

To disable this behaviour, set the module option hctosys to zero, e.g. by
using rtc-hid-sensor-time.hctosys=0 at the kernel command line if the
driver is statically linked into the kernel.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |   94 ++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -27,6 +27,12 @@
 /* Usage ID from spec for Time: 0x2000A0 */
 #define DRIVER_NAME "HID-SENSOR-2000a0" /* must be lowercase */
 
+static bool hid_time_hctosys_enabled = 1;
+module_param_named(hctosys, hid_time_hctosys_enabled, bool, 0644);
+MODULE_PARM_DESC(hctosys,
+	"set the system time (once) if it is before 1970-01-02");
+static bool hid_time_time_set_once;
+
 enum hid_time_channel {
 	CHANNEL_SCAN_INDEX_YEAR,
 	CHANNEL_SCAN_INDEX_MONTH,
@@ -37,6 +43,11 @@ enum hid_time_channel {
 	TIME_RTC_CHANNEL_MAX,
 };
 
+struct hid_time_workts {
+	struct work_struct work;
+	struct hid_time_state *time_state;
+};
+
 struct hid_time_state {
 	struct hid_sensor_hub_callbacks callbacks;
 	struct hid_sensor_common common_attributes;
@@ -46,6 +57,7 @@ struct hid_time_state {
 	struct completion comp_last_time;
 	struct rtc_time time_buf;
 	struct rtc_device *rtc;
+	struct hid_time_workts *workts;
 };
 
 static const u32 hid_time_addresses[TIME_RTC_CHANNEL_MAX] = {
@@ -62,6 +74,49 @@ static const char * const hid_time_chann
 	"year", "month", "day", "hour", "minute", "second",
 };
 
+static void hid_time_hctosys(struct hid_time_state *time_state)
+{
+	struct timespec ts;
+	int rc = rtc_valid_tm(&time_state->last_time);
+
+	if (rc) {
+		dev_err(time_state->rtc->dev.parent,
+			"hctosys: invalid date/time\n");
+		return;
+	}
+
+	getnstimeofday(&ts);
+	if (ts.tv_sec >= 86400) /* 1970-01-02 00:00:00 UTC */
+		/*
+		 * Security: don't let a hot-pluggable device change
+		 * a valid system time.
+		 * In absence of a kernel-wide flag like 'systime_was_set',
+		 * we check if the system time is earlier than 1970-01-02.
+		 * Just using a flag inside the RTC subsystem (e.g. from
+		 * hctosys) doesn't work, because the time could be set
+		 * by userspace (NTP, date, user, ...) or something else
+		 * in the kernel too.
+		 * Using a whole day to decide if something else has set the
+		 * time should be enough for even the longest boot to complete
+		 * (including possible forced fscks) and load this module.
+		 */
+		return;
+
+	ts.tv_nsec = NSEC_PER_SEC >> 1;
+	rtc_tm_to_time(&time_state->last_time, &ts.tv_sec);
+	rc = do_settimeofday(&ts);
+	dev_info(time_state->rtc->dev.parent,
+		"hctosys: setting system clock to "
+		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+		time_state->last_time.tm_year + 1900,
+		time_state->last_time.tm_mon + 1,
+		time_state->last_time.tm_mday,
+		time_state->last_time.tm_hour,
+		time_state->last_time.tm_min,
+		time_state->last_time.tm_sec,
+		(unsigned int) ts.tv_sec);
+}
+
 /* Callback handler to send event after all samples are received and captured */
 static int hid_time_proc_event(struct hid_sensor_hub_device *hsdev,
 				unsigned usage_id, void *priv)
@@ -73,6 +128,10 @@ static int hid_time_proc_event(struct hi
 	time_state->last_time = time_state->time_buf;
 	spin_unlock_irqrestore(&time_state->lock_last_time, flags);
 	complete(&time_state->comp_last_time);
+	if (unlikely(!hid_time_time_set_once && hid_time_hctosys_enabled)) {
+		hid_time_time_set_once = 1;
+		hid_time_hctosys(time_state);
+	}
 	return 0;
 }
 
@@ -237,6 +296,19 @@ static const struct rtc_class_ops hid_ti
 	.read_time = hid_rtc_read_time,
 };
 
+static void hid_time_request_report_work(struct work_struct *work)
+{
+	struct hid_time_state *time_state =
+		container_of(work, struct hid_time_workts, work)
+			->time_state;
+	/* get a report with all values through requesting one value */
+	sensor_hub_input_attr_get_raw_value(
+		time_state->common_attributes.hsdev, HID_USAGE_SENSOR_TIME,
+		hid_time_addresses[0], time_state->info[0].report_id);
+	time_state->workts = NULL;
+	kfree(work);
+}
+
 static int hid_time_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -288,13 +360,35 @@ static int hid_time_probe(struct platfor
 		return PTR_ERR(time_state->rtc);
 	}
 
+	if (!hid_time_time_set_once && hid_time_hctosys_enabled) {
+		/*
+		 * Request a HID report to set the time.
+		 * Calling sensor_hub_..._get_raw_value() here directly
+		 * doesn't work, therefor we have to use a work.
+		 */
+		time_state->workts = kmalloc(sizeof(struct hid_time_workts),
+			GFP_KERNEL);
+		if (time_state->workts == NULL)
+			return -ENOMEM;
+		time_state->workts->time_state = time_state;
+		INIT_WORK(&time_state->workts->work,
+			hid_time_request_report_work);
+		schedule_work(&time_state->workts->work);
+	}
+
 	return ret;
 }
 
 static int hid_time_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_time_state *time_state = platform_get_drvdata(pdev);
 
+	if (time_state->workts) {
+		cancel_work_sync(&time_state->workts->work);
+		kfree(time_state->workts);
+		time_state->workts = NULL;
+	}
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
 	return 0;
_

Patches currently in -mm which might be from holler@ahsoftware.de are

rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch

