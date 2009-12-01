From: akpm@linux-foundation.org
Subject: + driver-core-early-platform-driver-buffer.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:58:26 -0800
Message-ID: <200912012258.nB1MwQHW025273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbZLAW6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:58:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, greg@kroah.com, kay.sievers@vrfy.org, lethal@linux-sh.org, tglx@linutronix.de


The patch titled
     driver core: early platform driver buffer
has been added to the -mm tree.  Its filename is
     driver-core-early-platform-driver-buffer.patch

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
Subject: driver core: early platform driver buffer
From: Magnus Damm <damm@opensource.se>

Add early_platform_init_buffer() support and update the early platform
driver code to allow passing parameters to the driver on the kernel
command line.

early_platform_init_buffer() simply allows early platform drivers to
provide a pointer and length to a memory area where the remaining part of
the kernel command line option will be stored.

Needed to pass baud rate and other serial port options to the reworked
early serial console code on SuperH.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c         |   29 ++++++++++++++++++++++-------
 include/linux/platform_device.h |   20 +++++++++++++++-----
 2 files changed, 37 insertions(+), 12 deletions(-)

diff -puN drivers/base/platform.c~driver-core-early-platform-driver-buffer drivers/base/platform.c
--- a/drivers/base/platform.c~driver-core-early-platform-driver-buffer
+++ a/drivers/base/platform.c
@@ -1000,7 +1000,7 @@ static __initdata LIST_HEAD(early_platfo
 int __init early_platform_driver_register(struct early_platform_driver *epdrv,
 					  char *buf)
 {
-	unsigned long index;
+	char *tmp;
 	int n;
 
 	/* Simply add the driver to the end of the global list.
@@ -1019,13 +1019,28 @@ int __init early_platform_driver_registe
 	if (buf && !strncmp(buf, epdrv->pdrv->driver.name, n)) {
 		list_move(&epdrv->list, &early_platform_driver_list);
 
-		if (!strcmp(buf, epdrv->pdrv->driver.name))
+		/* Allow passing parameters after device name */
+		if (buf[n] == '\0' || buf[n] == ',')
 			epdrv->requested_id = -1;
-		else if (buf[n] == '.' && strict_strtoul(&buf[n + 1], 10,
-							 &index) == 0)
-			epdrv->requested_id = index;
-		else
-			epdrv->requested_id = EARLY_PLATFORM_ID_ERROR;
+		else {
+			epdrv->requested_id = simple_strtoul(&buf[n + 1],
+							     &tmp, 10);
+
+			if (buf[n] != '.' || (tmp == &buf[n + 1])) {
+				epdrv->requested_id = EARLY_PLATFORM_ID_ERROR;
+				n = 0;
+			} else
+				n += strcspn(&buf[n + 1], ",") + 1;
+		}
+
+		if (buf[n] == ',')
+			n++;
+
+		if (epdrv->bufsize) {
+			memcpy(epdrv->buffer, &buf[n],
+			       min_t(int, epdrv->bufsize, strlen(&buf[n]) + 1));
+			epdrv->buffer[epdrv->bufsize - 1] = '\0';
+		}
 	}
 
 	return 0;
diff -puN include/linux/platform_device.h~driver-core-early-platform-driver-buffer include/linux/platform_device.h
--- a/include/linux/platform_device.h~driver-core-early-platform-driver-buffer
+++ a/include/linux/platform_device.h
@@ -83,6 +83,8 @@ struct early_platform_driver {
 	struct platform_driver *pdrv;
 	struct list_head list;
 	int requested_id;
+	char *buffer;
+	int bufsize;
 };
 
 #define EARLY_PLATFORM_ID_UNSET -2
@@ -102,21 +104,29 @@ extern int early_platform_driver_probe(c
 				       int nr_probe, int user_only);
 extern void early_platform_cleanup(void);
 
+#define early_platform_init(class_string, platdrv)		\
+	early_platform_init_buffer(class_string, platdrv, NULL, 0)
 
 #ifndef MODULE
-#define early_platform_init(class_string, platform_driver)		\
+#define early_platform_init_buffer(class_string, platdrv, buf, bufsiz)	\
 static __initdata struct early_platform_driver early_driver = {		\
 	.class_str = class_string,					\
-	.pdrv = platform_driver,					\
+	.buffer = buf,							\
+	.bufsize = bufsiz,						\
+	.pdrv = platdrv,						\
 	.requested_id = EARLY_PLATFORM_ID_UNSET,			\
 };									\
-static int __init early_platform_driver_setup_func(char *buf)		\
+static int __init early_platform_driver_setup_func(char *buffer)	\
 {									\
-	return early_platform_driver_register(&early_driver, buf);	\
+	return early_platform_driver_register(&early_driver, buffer);	\
 }									\
 early_param(class_string, early_platform_driver_setup_func)
 #else /* MODULE */
-#define early_platform_init(class_string, platform_driver)
+#define early_platform_init_buffer(class_string, platdrv, buf, bufsiz)	\
+static inline char *early_platform_driver_setup_func(void)		\
+{									\
+	return bufsiz ? buf : NULL;					\
+}
 #endif /* MODULE */
 
 #endif /* _PLATFORM_DEVICE_H_ */
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch
driver-core-early-platform-driver-buffer.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
mm-uncached-vma-support-with-writenotify.patch
mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch
mmc-remove-const-from-tmio-mmc-platform-data-v2.patch
mmc-balance-tmio-mmc-cell-enable-disable-calls.patch
spi-superh-msiof-spi-master-driver.patch
spi-superh-msiof-spi-master-driver-update.patch

