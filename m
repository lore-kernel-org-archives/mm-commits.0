From: akpm@linux-foundation.org
Subject: + ramoops-use-the-platform-data-structure-instead-of-module-params.patch added to -mm tree
Date: Wed, 18 Aug 2010 15:59:01 -0700
Message-ID: <201008182259.o7IMx14o016875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab0HRW7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 18:59:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, marco.stornelli@gmail.com


The patch titled
     ramoops: use the platform data structure instead of module params
has been added to the -mm tree.  Its filename is
     ramoops-use-the-platform-data-structure-instead-of-module-params.patch

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
Subject: ramoops: use the platform data structure instead of module params
From: Kyungmin Park <kyungmin.park@samsung.com>

As each board and system has different memory for ramoops.  It's better to
define the platform data instead of module params.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c  |   29 +++++++++++++++++++++++++++--
 include/linux/ramoops.h |   15 +++++++++++++++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-use-the-platform-data-structure-instead-of-module-params drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-use-the-platform-data-structure-instead-of-module-params
+++ a/drivers/char/ramoops.c
@@ -25,6 +25,8 @@
 #include <linux/time.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/ramoops.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define RAMOOPS_HEADER_SIZE   (5 + sizeof(struct timeval))
@@ -91,11 +93,17 @@ static void ramoops_do_dump(struct kmsg_
 	cxt->count = (cxt->count + 1) % cxt->max_count;
 }
 
-static int __init ramoops_init(void)
+static int __init ramoops_probe(struct platform_device *pdev)
 {
+	struct ramoops_platform_data *pdata = pdev->dev.platform_data;
 	struct ramoops_context *cxt = &oops_cxt;
 	int err = -EINVAL;
 
+	if (pdata) {
+		mem_size = pdata->mem_size;
+		mem_address = pdata->mem_address;
+	}
+
 	if (!mem_size) {
 		printk(KERN_ERR "ramoops: invalid size specification");
 		goto fail3;
@@ -142,7 +150,7 @@ fail3:
 	return err;
 }
 
-static void __exit ramoops_exit(void)
+static void __exit ramoops_remove(void)
 {
 	struct ramoops_context *cxt = &oops_cxt;
 
@@ -153,6 +161,23 @@ static void __exit ramoops_exit(void)
 	release_mem_region(cxt->phys_addr, cxt->size);
 }
 
+static struct platform_driver ramoops_driver = {
+	.remove		= __exit_p(ramoops_remove),
+	.driver		= {
+		.name	= "ramoops",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init ramoops_init(void)
+{
+	return platform_driver_probe(&ramoops_driver, ramoops_probe);
+}
+
+static void __exit ramoops_exit(void)
+{
+	platform_driver_unregister(&ramoops_driver);
+}
 
 module_init(ramoops_init);
 module_exit(ramoops_exit);
diff -puN /dev/null include/linux/ramoops.h
--- /dev/null
+++ a/include/linux/ramoops.h
@@ -0,0 +1,15 @@
+#ifndef __RAMOOPS_H
+#define __RAMOOPS_H
+
+/*
+ * Ramoops platform data
+ * @mem_size	memory size for ramoops
+ * @mem_address	physical memory address to contain ramoops
+ */
+
+struct ramoops_platform_data {
+	unsigned long	mem_size;
+	unsigned long	mem_address;
+};
+
+#endif
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

linux-next.patch
s5pc110-sdhci-s3c-can-override-host-capabilities.patch
s5pc110-sdhci-s3c-support-on-s5pc110.patch
sdhci-add-no-hi-speed-bit-quirk-support.patch
ramoops-use-the-platform-data-structure-instead-of-module-params.patch

