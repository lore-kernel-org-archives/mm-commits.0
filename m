From: akpm@linux-foundation.org
Subject: [to-be-updated] early-platform-drivers-v2.patch removed from -mm tree
Date: Wed, 28 Jan 2009 16:41:15 -0800
Message-ID: <200901290041.n0T0fG5g030936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756176AbZA2AmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 19:42:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, greg@kroah.com, kay.sievers@vrfy.org, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     early platform drivers
has been removed from the -mm tree.  Its filename was
     early-platform-drivers-v2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: early platform drivers
From: Magnus Damm <damm@igel.co.jp>

Platform drivers are great for embedded platforms because we can separate
driver configuration from the actual driver.  So base addresses,
interrupts and other configuration can be kept with the processor or board
code, and the platform driver can be reused by many different platforms.

For early devices we have nothing today.  For instance, to configure early
timers and early serial ports we cannot use platform devices.  This
because the setup order during boot.  Timers are needed before the
platform driver core code is available.  The same goes for early printk
support.  Early in this case means before initcalls.

These early drivers today have their configuration either hard coded or
they receive it using some special configuration method.  This is working
quite well, but if we want to support both regular kernel modules and
early devices then we need to have two ways of configuring the same
driver.  A single way would be better.

The early platform driver patch is basically a set of functions that allow
drivers to register themselves and architecture code to locate them and
probe.  Registration happens through early_param().  The time for the
probe is decided by the architecture code.

The drivers are regular compiled-in modules with the exception that they
also register themselves using early_platform_init():

 +static int __init sh_cmt_init(void)
 +{
 +       return platform_driver_register(&sh_cmt_device_driver);
 +}
 +
 +static void __exit sh_cmt_exit(void)
 +{
 +       platform_driver_unregister(&sh_cmt_device_driver);
 +}
 +
 +early_platform_init("earlytimer", &sh_cmt_device_driver);
 +module_init(sh_cmt_init);
 +module_exit(sh_cmt_exit);

The architecture code can then decide whenever it wants to probe for early
platform devices.  The architecture code simply does:

 +void __init time_init(void)
 +{
 +       early_platform_driver_probe("earlytimer", sh_timer_pdevs,
 +                                   sh_timer_nr_pdevs, 1);

This will first make sure that all compiled-in early platform drivers
belonging to the class "earlytimer" get registered.  After that the
platform devices passed to the function are scanned through and matched
against the registered early platform drivers.  The user can select which
device that should be prioritized by specifying the classname and platform
device name together with id on the kernel commandline.  For instance the
string "earlytimer=cmt0" will match the driver named "cmt" with id 0.

Later when the platform device core code is up and running the driver can
turn itself into a regular platform device in the regular probe()
callback.

More:

Say that your architecture wants to use early platform drivers for timers
and early serial console output.  Those two types of drivers result in two
classes: "earlytimer" and "earlyprintk".  Any class name that doesn't
collide with existng kernel command line parameters should be fine.  Write
your timer and serial drivers as regular platform drivers, use one
platform device instance per hardware device to allow the user to specify
early platform device on the command line.  Let your board/cpu code
provide platform device instances for the platform drivers as usual.

Each platform driver should add a line of "early_platform_init()" together
with the class string it belongs to.  So our first timer driver - the cmt
driver - adds "early_platform_init("earlytimer", &sh_cmt_timer_driver)"
where sh_cmt_timer_driver contains the driver name "cmt".  The second
timer driver adds a "early_platform_init("earlytimer",
&sh_tmu_timer_driver)" - the same as the cmt but pointing to a different
platform driver which has the name "tmu".  Same thing for serial drivers
using the "earlyprintk" class.

The architecture code then simply adds calls to
early_platform_driver_probe() wherever needed.  For timers we do a
early_platform_driver_probe("earlytimer"...) inside time_init() on SuperH.
 This call makes sure that all early platform drivers register themselves
and tries to match them against the platform devices provided as an
argument to the function.  If a match is found, the probe() method of the
platform driver will be called, and it's up to the driver to do whatever
it needs to do to setup the hardware.

The user may specify which device to use for a certain class on the kernel
command line.  For example, passing "earlytimer=cmt0" will make sure the
early platform driver with name "cmt" belonging to the class "earlytimer"
will be registered first within it's class as long as platform device data
with "cmt" and id=0 is present.

Later on the regular platform driver probe() call will happen.  This call
converts the early platform device to a regular platform device.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c         |  139 ++++++++++++++++++++++++++++++
 include/linux/init.h            |    1 
 include/linux/platform_device.h |   29 ++++++
 init/main.c                     |    7 +
 4 files changed, 175 insertions(+), 1 deletion(-)

diff -puN drivers/base/platform.c~early-platform-drivers-v2 drivers/base/platform.c
--- a/drivers/base/platform.c~early-platform-drivers-v2
+++ a/drivers/base/platform.c
@@ -986,3 +986,142 @@ u64 dma_get_required_mask(struct device 
 }
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 #endif
+
+static LIST_HEAD(early_platform_driver_list);
+
+/**
+ * early_platform_driver_register
+ * @edrv: early_platform driver structure
+ * @buf: string passed from early_param()
+ */
+int __init early_platform_driver_register(struct early_platform_driver *epdrv,
+					  char *buf)
+{
+	int id = -1;
+
+	/* Simply add the driver to the end of the global list.
+	 * Drivers will by default be put on the list in compiled-in order.
+	 */
+	if (!epdrv->list.next) {
+		INIT_LIST_HEAD(&epdrv->list);
+		list_add_tail(&epdrv->list, &early_platform_driver_list);
+	}
+
+	/* If the user has specified device then make sure the driver
+	 * gets prioritized. The driver of the last device specified on
+	 * command line will be put first on the list.
+	 */
+	if (buf && !strncmp(buf, epdrv->pdrv->driver.name, strlen(buf))) {
+		list_move(&epdrv->list, &early_platform_driver_list);
+		if (strcmp(buf, epdrv->pdrv->driver.name))
+			id = simple_strtoul(buf +
+					    strlen(epdrv->pdrv->driver.name),
+					    NULL, 0);
+	}
+
+	epdrv->requested_id = id;
+	return 0;
+}
+
+/**
+ * early_platform_match
+ * @edrv: early platform driver structure
+ * @pdevs: platform devices to match against
+ * @nr_pdevs: number of platform devices to match against
+ * @id: id to match against
+ * @match: matching platform device
+ */
+static int __init early_platform_match(struct early_platform_driver *epdrv,
+				       struct platform_device **pdevs,
+				       int nr_pdevs, int id,
+				       struct platform_device **match)
+{
+	struct platform_device *pdev;
+	int k, n, match_id;
+
+	if (id == -2)
+		match_id = epdrv->requested_id;
+	else
+		match_id = id;
+
+	n = 0;
+	*match = NULL;
+	for (k = 0; k < nr_pdevs; k++) {
+		pdev = pdevs[k];
+		if (platform_match(&pdev->dev, &epdrv->pdrv->driver)) {
+			if (id != -2) /* skip previously checked device */
+				if (match_id == epdrv->requested_id)
+					goto skip;
+
+			if (pdev->id == match_id)
+				*match = pdev;
+
+skip:
+			if (pdev->id > match_id)
+				n++;
+		}
+	}
+
+	return n;
+}
+
+/**
+ * early_platform_driver_probe
+ * @class_str: string to identify early platform driver class
+ * @pdevs: platform devices to match against
+ * @nr_pdevs: number of platform devices to match against
+ * @nr_probe: number of platform devices to successfully probe before exiting
+ */
+int __init early_platform_driver_probe(char *class_str,
+				       struct platform_device **pdevs,
+				       int nr_pdevs, int nr_probe)
+{
+	struct early_platform_driver *epdrv;
+	struct platform_device *match;
+	int k, n, i;
+
+	/* The "class_str" parameter may or may not be present on the kernel
+	 * command line. If it is present then there may be more than one
+	 * matching parameter.
+	 *
+	 * Since we register our early platform drivers using early_param()
+	 * we need to make sure that they also get registered in the case
+	 * when the parameter is missing from the kernel command line.
+	 *
+	 * We use parse_early_options() to make sure the early_param() gets
+	 * called at least once. The early_param() may be called more than
+	 * once since the name of the preferred device may be specified on
+	 * the kernel command line. early_platform_driver_register() handles
+	 * this case for us.
+	 */
+	parse_early_options(class_str);
+
+	n = 0;
+	list_for_each_entry(epdrv, &early_platform_driver_list, list) {
+		/* only use drivers matching our class_str */
+		if (strcmp(class_str, epdrv->class_str))
+			continue;
+
+		/* start with exact device match, continue with any device */
+		k = 1;
+		for (i = -2; k && n < nr_probe; i++) {
+			k = early_platform_match(epdrv, pdevs, nr_pdevs,
+						 i, &match);
+			if (!match)
+				continue;
+
+			if (epdrv->pdrv->probe(match)) {
+				pr_warning("%s: unable to probe %s early.\n",
+					   class_str, match->name);
+				continue;
+			}
+			n++;
+		}
+	}
+
+	if (!n)
+		pr_warning("%s: no early platform devices found.\n", class_str);
+
+	return n;
+}
+
diff -puN include/linux/init.h~early-platform-drivers-v2 include/linux/init.h
--- a/include/linux/init.h~early-platform-drivers-v2
+++ a/include/linux/init.h
@@ -247,6 +247,7 @@ struct obs_kernel_param {
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
+void __init parse_early_options(char *cmdline);
 #endif /* __ASSEMBLY__ */
 
 /**
diff -puN include/linux/platform_device.h~early-platform-drivers-v2 include/linux/platform_device.h
--- a/include/linux/platform_device.h~early-platform-drivers-v2
+++ a/include/linux/platform_device.h
@@ -70,4 +70,33 @@ extern int platform_driver_probe(struct 
 #define platform_get_drvdata(_dev)	dev_get_drvdata(&(_dev)->dev)
 #define platform_set_drvdata(_dev,data)	dev_set_drvdata(&(_dev)->dev, (data))
 
+/* early platform driver interface */
+struct early_platform_driver {
+	const char *class_str;
+	struct platform_driver *pdrv;
+	struct list_head list;
+	int requested_id;
+};
+
+extern int early_platform_driver_register(struct early_platform_driver *epdrv,
+					  char *buf);
+extern int early_platform_driver_probe(char *class_str,
+				       struct platform_device **pdevs,
+				       int nr_pdevs, int nr_probe);
+
+#ifndef MODULE
+#define early_platform_init(class_string, platform_driver)		\
+static __initdata struct early_platform_driver early_driver = {		\
+	.class_str = class_string,					\
+	.pdrv = platform_driver,					\
+};									\
+static int __init early_platform_driver_setup_func(char *buf)		\
+{									\
+	return early_platform_driver_register(&early_driver, buf);	\
+}									\
+early_param(class_string, early_platform_driver_setup_func)
+#else /* MODULE */
+#define early_platform_init(class_string, platform_driver)
+#endif /* MODULE */
+
 #endif /* _PLATFORM_DEVICE_H_ */
diff -puN init/main.c~early-platform-drivers-v2 init/main.c
--- a/init/main.c~early-platform-drivers-v2
+++ a/init/main.c
@@ -490,6 +490,11 @@ static int __init do_early_param(char *p
 	return 0;
 }
 
+void __init parse_early_options(char *cmdline)
+{
+	parse_args("early options", cmdline, NULL, 0, do_early_param);
+}
+
 /* Arch code calls this early on, or if not, just before other parsing. */
 void __init parse_early_param(void)
 {
@@ -501,7 +506,7 @@ void __init parse_early_param(void)
 
 	/* All fall through to do_early_param. */
 	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-	parse_args("early options", tmp_cmdline, NULL, 0, do_early_param);
+	parse_early_options(tmp_cmdline);
 	done = 1;
 }
 
_

Patches currently in -mm which might be from damm@igel.co.jp are

gpiolib-fix-request-related-issue.patch
linux-next.patch
early-platform-drivers-v2.patch
early-platform-driver-v3.patch
sh-add-plat_early_device_setup-function.patch
sh-plat_early_device_setup-for-sh2.patch
sh-plat_early_device_setup-for-sh2a.patch
sh-plat_early_device_setup-for-sh3.patch
sh-plat_early_device_setup-for-sh4.patch
sh-plat_early_device_setup-for-sh4a.patch
sh-add-early-platform-support-for-earlyprintk.patch
sh-sci-add-early-platform-support.patch
sh-add-early-platform-support-for-earlytimer.patch
sh_cmt-add-early-platform-support.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
irq-free-setup_irq-interrupt-using-free_irq.patch

