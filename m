From: akpm@linux-foundation.org
Subject: + watchdog-core-make-use-of-devm_register_reboot_notifier.patch
 added to -mm tree
Date: Tue, 17 Oct 2017 15:02:57 -0700
Message-ID: <59e67e11.MwL/wivMTuc4b1BK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52112 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbdJQWC7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:02:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.smirnov@gmail.com, andy.shevchenko@gmail.com, cphealy@gmail.com, linux@roeck-us.net, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/watchdog: make use of devm_register_reboot_notifier()
has been added to the -mm tree.  Its filename is
     watchdog-core-make-use-of-devm_register_reboot_notifier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-core-make-use-of-devm_register_reboot_notifier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-core-make-use-of-devm_register_reboot_notifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: drivers/watchdog: make use of devm_register_reboot_notifier()

Save a bit of cleanup code by leveraging newly added
devm_register_reboot_notifier().

Link: http://lkml.kernel.org/r/20170411160615.9784-1-andrew.smirnov@gmail.com
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/watchdog_core.c |   35 -----------------------------
 drivers/watchdog/watchdog_dev.c  |   32 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 35 deletions(-)

diff -puN drivers/watchdog/watchdog_core.c~watchdog-core-make-use-of-devm_register_reboot_notifier drivers/watchdog/watchdog_core.c
--- a/drivers/watchdog/watchdog_core.c~watchdog-core-make-use-of-devm_register_reboot_notifier
+++ a/drivers/watchdog/watchdog_core.c
@@ -137,25 +137,6 @@ int watchdog_init_timeout(struct watchdo
 }
 EXPORT_SYMBOL_GPL(watchdog_init_timeout);
 
-static int watchdog_reboot_notifier(struct notifier_block *nb,
-				    unsigned long code, void *data)
-{
-	struct watchdog_device *wdd = container_of(nb, struct watchdog_device,
-						   reboot_nb);
-
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		if (watchdog_active(wdd)) {
-			int ret;
-
-			ret = wdd->ops->stop(wdd);
-			if (ret)
-				return NOTIFY_BAD;
-		}
-	}
-
-	return NOTIFY_DONE;
-}
-
 static int watchdog_restart_notifier(struct notifier_block *nb,
 				     unsigned long action, void *data)
 {
@@ -244,19 +225,6 @@ static int __watchdog_register_device(st
 		}
 	}
 
-	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status)) {
-		wdd->reboot_nb.notifier_call = watchdog_reboot_notifier;
-
-		ret = register_reboot_notifier(&wdd->reboot_nb);
-		if (ret) {
-			pr_err("watchdog%d: Cannot register reboot notifier (%d)\n",
-			       wdd->id, ret);
-			watchdog_dev_unregister(wdd);
-			ida_simple_remove(&watchdog_ida, wdd->id);
-			return ret;
-		}
-	}
-
 	if (wdd->ops->restart) {
 		wdd->restart_nb.notifier_call = watchdog_restart_notifier;
 
@@ -302,9 +270,6 @@ static void __watchdog_unregister_device
 	if (wdd->ops->restart)
 		unregister_restart_handler(&wdd->restart_nb);
 
-	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status))
-		unregister_reboot_notifier(&wdd->reboot_nb);
-
 	watchdog_dev_unregister(wdd);
 	ida_simple_remove(&watchdog_ida, wdd->id);
 }
diff -puN drivers/watchdog/watchdog_dev.c~watchdog-core-make-use-of-devm_register_reboot_notifier drivers/watchdog/watchdog_dev.c
--- a/drivers/watchdog/watchdog_dev.c~watchdog-core-make-use-of-devm_register_reboot_notifier
+++ a/drivers/watchdog/watchdog_dev.c
@@ -42,6 +42,7 @@
 #include <linux/miscdevice.h>	/* For handling misc devices */
 #include <linux/module.h>	/* For module stuff/... */
 #include <linux/mutex.h>	/* For mutexes */
+#include <linux/reboot.h>	/* For reboot notifier */
 #include <linux/slab.h>		/* For memory functions */
 #include <linux/types.h>	/* For standard types (like size_t) */
 #include <linux/watchdog.h>	/* For watchdog specific items */
@@ -1016,6 +1017,25 @@ static struct class watchdog_class = {
 	.dev_groups =	wdt_groups,
 };
 
+static int watchdog_reboot_notifier(struct notifier_block *nb,
+				    unsigned long code, void *data)
+{
+	struct watchdog_device *wdd = container_of(nb, struct watchdog_device,
+						   reboot_nb);
+
+	if (code == SYS_DOWN || code == SYS_HALT) {
+		if (watchdog_active(wdd)) {
+			int ret;
+
+			ret = wdd->ops->stop(wdd);
+			if (ret)
+				return NOTIFY_BAD;
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
 /*
  *	watchdog_dev_register: register a watchdog device
  *	@wdd: watchdog device
@@ -1049,6 +1069,18 @@ int watchdog_dev_register(struct watchdo
 	if (ret) {
 		device_destroy(&watchdog_class, devno);
 		watchdog_cdev_unregister(wdd);
+		return ret;
+	}
+
+	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status)) {
+		wdd->reboot_nb.notifier_call = watchdog_reboot_notifier;
+
+		ret = devm_register_reboot_notifier(dev, &wdd->reboot_nb);
+		if (ret) {
+			pr_err("watchdog%d: Cannot register reboot notifier (%d)\n",
+			       wdd->id, ret);
+			watchdog_dev_unregister(wdd);
+		}
 	}
 
 	return ret;
_

Patches currently in -mm which might be from andrew.smirnov@gmail.com are

kernel-reboot-add-devm_register_reboot_notifier.patch
watchdog-core-make-use-of-devm_register_reboot_notifier.patch

