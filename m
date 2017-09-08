From: akpm@linux-foundation.org
Subject: [patch 115/126] drivers/pps: aesthetic tweaks to
 PPS-related content
Date: Fri, 08 Sep 2017 16:17:19 -0700
Message-ID: <20170908231719.VOSH9nOHN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757003AbdIHXRU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, giometti@enneenne.com, mm-commits@vger.kernel.org, rpjday@crashcourse.ca, torvalds@linux-foundation.org

From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: drivers/pps: aesthetic tweaks to PPS-related content

Collection of aesthetic adjustments to various PPS-related files,
directories and Documentation, some quite minor just for the sake of
consistency, including:

 * Updated example of pps device tree node (courtesy Rodolfo G.)
 * "PPS-API" -> "PPS API"
 * "pps_source_info_s" -> "pps_source_info"
 * "ktimer driver" -> "pps-ktimer driver"
 * "ppstest /dev/pps0" -> "ppstest /dev/pps1" to match example
 * Add missing PPS-related entries to MAINTAINERS file
 * Other trivialities

Link: http://lkml.kernel.org/r/alpine.LFD.2.20.1708261048220.8106@localhost.localdomain
Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/pps/pps-gpio.txt |    8 +-
 Documentation/pps/pps.txt                          |   44 +++++------
 MAINTAINERS                                        |    3 
 include/linux/pps-gpio.h                           |    2 
 include/linux/pps_kernel.h                         |   16 +---
 include/uapi/linux/pps.h                           |    4 -
 kernel/time/timekeeping.c                          |    2 
 7 files changed, 43 insertions(+), 36 deletions(-)

diff -puN Documentation/devicetree/bindings/pps/pps-gpio.txt~pps-aesthetic-tweaks-to-pps-related-content Documentation/devicetree/bindings/pps/pps-gpio.txt
--- a/Documentation/devicetree/bindings/pps/pps-gpio.txt~pps-aesthetic-tweaks-to-pps-related-content
+++ a/Documentation/devicetree/bindings/pps/pps-gpio.txt
@@ -13,8 +13,12 @@ Optional properties:
 
 Example:
 	pps {
-		compatible = "pps-gpio";
-		gpios = <&gpio2 6 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_pps>;
 
+		gpios = <&gpio1 26 GPIO_ACTIVE_HIGH>;
 		assert-falling-edge;
+
+		compatible = "pps-gpio";
+		status = "okay";
 	};
diff -puN Documentation/pps/pps.txt~pps-aesthetic-tweaks-to-pps-related-content Documentation/pps/pps.txt
--- a/Documentation/pps/pps.txt~pps-aesthetic-tweaks-to-pps-related-content
+++ a/Documentation/pps/pps.txt
@@ -48,12 +48,12 @@ problem:
    time_pps_create().
 
 This implies that the source has a /dev/... entry. This assumption is
-ok for the serial and parallel port, where you can do something
+OK for the serial and parallel port, where you can do something
 useful besides(!) the gathering of timestamps as it is the central
-task for a PPS-API. But this assumption does not work for a single
+task for a PPS API. But this assumption does not work for a single
 purpose GPIO line. In this case even basic file-related functionality
 (like read() and write()) makes no sense at all and should not be a
-precondition for the use of a PPS-API.
+precondition for the use of a PPS API.
 
 The problem can be simply solved if you consider that a PPS source is
 not always connected with a GPS data source.
@@ -88,13 +88,13 @@ Coding example
 --------------
 
 To register a PPS source into the kernel you should define a struct
-pps_source_info_s as follows:
+pps_source_info as follows:
 
     static struct pps_source_info pps_ktimer_info = {
 	    .name         = "ktimer",
 	    .path         = "",
-	    .mode         = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
-			    PPS_ECHOASSERT | \
+	    .mode         = PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
+			    PPS_ECHOASSERT |
 			    PPS_CANWAIT | PPS_TSFMT_TSPEC,
 	    .echo         = pps_ktimer_echo,
 	    .owner        = THIS_MODULE,
@@ -108,13 +108,13 @@ initialization routine as follows:
 
 The pps_register_source() prototype is:
 
-  int pps_register_source(struct pps_source_info_s *info, int default_params)
+  int pps_register_source(struct pps_source_info *info, int default_params)
 
 where "info" is a pointer to a structure that describes a particular
 PPS source, "default_params" tells the system what the initial default
 parameters for the device should be (it is obvious that these parameters
 must be a subset of ones defined in the struct
-pps_source_info_s which describe the capabilities of the driver).
+pps_source_info which describe the capabilities of the driver).
 
 Once you have registered a new PPS source into the system you can
 signal an assert event (for example in the interrupt handler routine)
@@ -142,8 +142,10 @@ If the SYSFS filesystem is enabled in th
 Every directory is the ID of a PPS sources defined in the system and
 inside you find several files:
 
-   $ ls /sys/class/pps/pps0/
-   assert	clear  echo  mode  name  path  subsystem@  uevent
+   $ ls -F /sys/class/pps/pps0/
+   assert     dev        mode       path       subsystem@
+   clear      echo       name       power/     uevent
+
 
 Inside each "assert" and "clear" file you can find the timestamp and a
 sequence number:
@@ -154,32 +156,32 @@ sequence number:
 Where before the "#" is the timestamp in seconds; after it is the
 sequence number. Other files are:
 
-* echo: reports if the PPS source has an echo function or not;
+ * echo: reports if the PPS source has an echo function or not;
 
-* mode: reports available PPS functioning modes;
+ * mode: reports available PPS functioning modes;
 
-* name: reports the PPS source's name;
+ * name: reports the PPS source's name;
 
-* path: reports the PPS source's device path, that is the device the
-  PPS source is connected to (if it exists).
+ * path: reports the PPS source's device path, that is the device the
+   PPS source is connected to (if it exists).
 
 
 Testing the PPS support
 -----------------------
 
 In order to test the PPS support even without specific hardware you can use
-the ktimer driver (see the client subsection in the PPS configuration menu)
+the pps-ktimer driver (see the client subsection in the PPS configuration menu)
 and the userland tools available in your distribution's pps-tools package,
-http://linuxpps.org , or https://github.com/ago/pps-tools .
+http://linuxpps.org , or https://github.com/redlab-i/pps-tools.
 
-Once you have enabled the compilation of ktimer just modprobe it (if
+Once you have enabled the compilation of pps-ktimer just modprobe it (if
 not statically compiled):
 
-   # modprobe ktimer
+   # modprobe pps-ktimer
 
 and the run ppstest as follow:
 
-   $ ./ppstest /dev/pps0
+   $ ./ppstest /dev/pps1
    trying PPS source "/dev/pps1"
    found PPS source "/dev/pps1"
    ok, found 1 source(s), now start fetching data...
@@ -187,7 +189,7 @@ and the run ppstest as follow:
    source 0 - assert 1186592700.388931295, sequence: 365 - clear  0.000000000, sequence: 0
    source 0 - assert 1186592701.389032765, sequence: 366 - clear  0.000000000, sequence: 0
 
-Please, note that to compile userland programs you need the file timepps.h .
+Please note that to compile userland programs, you need the file timepps.h.
 This is available in the pps-tools repository mentioned above.
 
 
diff -puN MAINTAINERS~pps-aesthetic-tweaks-to-pps-related-content MAINTAINERS
--- a/MAINTAINERS~pps-aesthetic-tweaks-to-pps-related-content
+++ a/MAINTAINERS
@@ -10725,8 +10725,11 @@ W:	http://wiki.enneenne.com/index.php/Li
 L:	linuxpps@ml.enneenne.com (subscribers-only)
 S:	Maintained
 F:	Documentation/pps/
+F:	Documentation/devicetree/bindings/pps/pps-gpio.txt
+F:	Documentation/ABI/testing/sysfs-pps
 F:	drivers/pps/
 F:	include/linux/pps*.h
+F:	include/uapi/linux/pps.h
 
 PPTP DRIVER
 M:	Dmitry Kozlov <xeb@mail.ru>
diff -puN include/linux/pps-gpio.h~pps-aesthetic-tweaks-to-pps-related-content include/linux/pps-gpio.h
--- a/include/linux/pps-gpio.h~pps-aesthetic-tweaks-to-pps-related-content
+++ a/include/linux/pps-gpio.h
@@ -29,4 +29,4 @@ struct pps_gpio_platform_data {
 	const char *gpio_label;
 };
 
-#endif
+#endif /* _PPS_GPIO_H */
diff -puN include/linux/pps_kernel.h~pps-aesthetic-tweaks-to-pps-related-content include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-aesthetic-tweaks-to-pps-related-content
+++ a/include/linux/pps_kernel.h
@@ -22,7 +22,6 @@
 #define LINUX_PPS_KERNEL_H
 
 #include <linux/pps.h>
-
 #include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/time.h>
@@ -35,9 +34,9 @@ struct pps_device;
 
 /* The specific PPS source info */
 struct pps_source_info {
-	char name[PPS_MAX_NAME_LEN];		/* simbolic name */
+	char name[PPS_MAX_NAME_LEN];		/* symbolic name */
 	char path[PPS_MAX_NAME_LEN];		/* path of connected device */
-	int mode;				/* PPS's allowed mode */
+	int mode;				/* PPS allowed mode */
 
 	void (*echo)(struct pps_device *pps,
 			int event, void *data);	/* PPS echo function */
@@ -57,10 +56,10 @@ struct pps_event_time {
 struct pps_device {
 	struct pps_source_info info;		/* PSS source info */
 
-	struct pps_kparams params;		/* PPS's current params */
+	struct pps_kparams params;		/* PPS current params */
 
-	__u32 assert_sequence;			/* PPS' assert event seq # */
-	__u32 clear_sequence;			/* PPS' clear event seq # */
+	__u32 assert_sequence;			/* PPS assert event seq # */
+	__u32 clear_sequence;			/* PPS clear event seq # */
 	struct pps_ktime assert_tu;
 	struct pps_ktime clear_tu;
 	int current_mode;			/* PPS mode at event time */
@@ -69,7 +68,7 @@ struct pps_device {
 	wait_queue_head_t queue;		/* PPS event queue */
 
 	unsigned int id;			/* PPS source unique ID */
-	void const *lookup_cookie;		/* pps_lookup_dev only */
+	void const *lookup_cookie;		/* For pps_lookup_dev() only */
 	struct cdev cdev;
 	struct device *dev;
 	struct fasync_struct *async_queue;	/* fasync method */
@@ -101,7 +100,7 @@ extern struct pps_device *pps_register_s
 extern void pps_unregister_source(struct pps_device *pps);
 extern void pps_event(struct pps_device *pps,
 		struct pps_event_time *ts, int event, void *data);
-/* Look up a pps device by magic cookie */
+/* Look up a pps_device by magic cookie */
 struct pps_device *pps_lookup_dev(void const *cookie);
 
 static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
@@ -132,4 +131,3 @@ static inline void pps_sub_ts(struct pps
 }
 
 #endif /* LINUX_PPS_KERNEL_H */
-
diff -puN include/uapi/linux/pps.h~pps-aesthetic-tweaks-to-pps-related-content include/uapi/linux/pps.h
--- a/include/uapi/linux/pps.h~pps-aesthetic-tweaks-to-pps-related-content
+++ a/include/uapi/linux/pps.h
@@ -95,8 +95,8 @@ struct pps_kparams {
 #define PPS_CAPTURECLEAR	0x02	/* capture clear events */
 #define PPS_CAPTUREBOTH		0x03	/* capture assert and clear events */
 
-#define PPS_OFFSETASSERT	0x10	/* apply compensation for assert ev. */
-#define PPS_OFFSETCLEAR		0x20	/* apply compensation for clear ev. */
+#define PPS_OFFSETASSERT	0x10	/* apply compensation for assert event */
+#define PPS_OFFSETCLEAR		0x20	/* apply compensation for clear event */
 
 #define PPS_CANWAIT		0x100	/* can we wait for an event? */
 #define PPS_CANPOLL		0x200	/* bit reserved for future use */
diff -puN kernel/time/timekeeping.c~pps-aesthetic-tweaks-to-pps-related-content kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~pps-aesthetic-tweaks-to-pps-related-content
+++ a/kernel/time/timekeeping.c
@@ -2316,7 +2316,7 @@ void hardpps(const struct timespec64 *ph
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
-#endif
+#endif /* CONFIG_NTP_PPS */
 
 /**
  * xtime_update() - advances the timekeeping infrastructure
_
