From: akpm@linux-foundation.org
Subject: + rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices.patch added to -mm tree
Date: Tue, 14 Aug 2012 15:57:09 -0700
Message-ID: <20120814225709.B12F91E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:40103 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2HNW5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 18:57:11 -0400
Received: by obbwc20 with SMTP id wc20so726377obb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 15:57:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, a.zummo@towertech.it, milo.kim@ti.com


The patch titled
     Subject: rtc-proc: permit the /proc/driver/rtc device to use other devices
has been added to the -mm tree.  Its filename is
     rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: rtc-proc: permit the /proc/driver/rtc device to use other devices

To get time information via /proc/driver/rtc, only the first device (rtc0)
is used.  If the rtcN (eg.  rtc1 or rtc2) is used for the system clock,
there is no way to get information of rtcN via /proc/driver/rtc.  With
this patch, the time data can be retrieved from the system clock RTC.

If the RTC_HCTOSYS_DEVICE is not defined, then rtc0 is used by default.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt  |    5 +++--
 drivers/rtc/Kconfig    |   10 ++++++----
 drivers/rtc/rtc-proc.c |   24 ++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 8 deletions(-)

diff -puN Documentation/rtc.txt~rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices
+++ a/Documentation/rtc.txt
@@ -119,8 +119,9 @@ three different userspace interfaces:
     *	/sys/class/rtc/rtcN ... sysfs attributes support readonly
 	access to some RTC attributes.
 
-    *	/proc/driver/rtc ... the first RTC (rtc0) may expose itself
-	using a procfs interface.  More information is (currently) shown
+    *	/proc/driver/rtc ... the system clock RTC may expose itself
+	using a procfs interface. If there is no RTC for the system clock,
+	rtc0 is used by default. More information is (currently) shown
 	here than through sysfs.
 
 The RTC Class framework supports a wide variety of RTCs, ranging from those
diff -puN drivers/rtc/Kconfig~rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices
+++ a/drivers/rtc/Kconfig
@@ -69,13 +69,15 @@ config RTC_INTF_SYSFS
 	  If unsure, say Y.
 
 config RTC_INTF_PROC
-	boolean "/proc/driver/rtc (procfs for rtc0)"
+	boolean "/proc/driver/rtc (procfs for rtcN)"
 	depends on PROC_FS
 	default RTC_CLASS
 	help
-	  Say yes here if you want to use your first RTC through the proc
-	  interface, /proc/driver/rtc. Other RTCs will not be available
-	  through that API.
+	  Say yes here if you want to use your system clock RTC through
+	  the proc interface, /proc/driver/rtc.
+	  Other RTCs will not be available through that API.
+	  If there is no RTC for the system clock, then the first RTC(rtc0)
+	  is used by default.
 
 	  If unsure, say Y.
 
diff -puN drivers/rtc/rtc-proc.c~rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices drivers/rtc/rtc-proc.c
--- a/drivers/rtc/rtc-proc.c~rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices
+++ a/drivers/rtc/rtc-proc.c
@@ -18,6 +18,26 @@
 
 #include "rtc-core.h"
 
+#define NAME_SIZE	10
+
+#if defined(CONFIG_RTC_HCTOSYS_DEVICE)
+static bool is_rtc_hctosys(struct rtc_device *rtc)
+{
+	int size;
+	char name[NAME_SIZE];
+
+	size = scnprintf(name, NAME_SIZE, "rtc%d", rtc->id);
+	if (size > NAME_SIZE)
+		return false;
+
+	return !strncmp(name, CONFIG_RTC_HCTOSYS_DEVICE, NAME_SIZE);
+}
+#else
+static bool is_rtc_hctosys(struct rtc_device *rtc)
+{
+	return (rtc->id == 0);
+}
+#endif
 
 static int rtc_proc_show(struct seq_file *seq, void *offset)
 {
@@ -117,12 +137,12 @@ static const struct file_operations rtc_
 
 void rtc_proc_add_device(struct rtc_device *rtc)
 {
-	if (rtc->id == 0)
+	if (is_rtc_hctosys(rtc))
 		proc_create_data("driver/rtc", 0, NULL, &rtc_proc_fops, rtc);
 }
 
 void rtc_proc_del_device(struct rtc_device *rtc)
 {
-	if (rtc->id == 0)
+	if (is_rtc_hctosys(rtc))
 		remove_proc_entry("driver/rtc", NULL);
 }
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices.patch

