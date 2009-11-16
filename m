From: akpm@linux-foundation.org
Subject: + mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable.patch added to -mm tree
Date: Mon, 16 Nov 2009 14:49:12 -0800
Message-ID: <200911162249.nAGMnCtv030639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754167AbZKPWtu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 17:49:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, linux-mmc@vger.kernel.org


The patch titled
     mmc: add module parameter to set whether cards are assumed removable
has been added to the -mm tree.  Its filename is
     mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable.patch

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
Subject: mmc: add module parameter to set whether cards are assumed removable
From: Ben Hutchings <ben@decadent.org.uk>

Some people run general-purpose distribution kernels on netbooks with
a card that is physically non-removable or logically non-removable
(e.g. used for /home) and cannot be cleanly unmounted during suspend.
Add a module parameter to set whether cards are assumed removable or
non-removable, with the default set by CONFIG_MMC_UNSAFE_RESUME.

In general, it is not possible to tell whether a card present in an MMC
slot after resume is the same that was there before suspend.  So there are
two possible behaviours, each of which will cause data loss in some cases:

CONFIG_MMC_UNSAFE_RESUME=n (default): Cards are assumed to be removed
during suspend.  Any filesystem on them must be unmounted before suspend;
otherwise, buffered writes will be lost.

CONFIG_MMC_UNSAFE_RESUME=y: Cards are assumed to remain present during
suspend.  They must not be swapped during suspend; otherwise, buffered
writes will be flushed to the wrong card.

Currently the choice is made at compile time and this allows that to be
overridden at module load time.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/Kconfig |    4 +++-
 drivers/mmc/core/core.c  |   16 ++++++++++++++++
 drivers/mmc/core/core.h  |    2 ++
 drivers/mmc/core/mmc.c   |   23 +----------------------
 drivers/mmc/core/sd.c    |   21 +--------------------
 5 files changed, 23 insertions(+), 43 deletions(-)

diff -puN drivers/mmc/core/Kconfig~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable drivers/mmc/core/Kconfig
--- a/drivers/mmc/core/Kconfig~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable
+++ a/drivers/mmc/core/Kconfig
@@ -3,7 +3,7 @@
 #
 
 config MMC_UNSAFE_RESUME
-	bool "Allow unsafe resume (DANGEROUS)"
+	bool "Assume MMC/SD cards are non-removable (DANGEROUS)"
 	help
 	  If you say Y here, the MMC layer will assume that all cards
 	  stayed in their respective slots during the suspend. The
@@ -14,3 +14,5 @@ config MMC_UNSAFE_RESUME
 	  This option is usually just for embedded systems which use
 	  a MMC/SD card for rootfs. Most people should say N here.
 
+	  This option sets a default which can be overridden by the
+	  module parameter "removable=0" or "removable=1".
diff -puN drivers/mmc/core/core.c~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable
+++ a/drivers/mmc/core/core.c
@@ -48,6 +48,22 @@ int use_spi_crc = 1;
 module_param(use_spi_crc, bool, 0);
 
 /*
+ * We normally treat cards as removed during suspend if they are not
+ * known to be on a non-removable bus, to avoid the risk of writing
+ * back data to a different card after resume.  Allow this to be
+ * overridden if necessary.
+ */
+#ifdef CONFIG_MMC_UNSAFE_RESUME
+int mmc_assume_removable;
+#else
+int mmc_assume_removable = 1;
+#endif
+module_param_named(removable, mmc_assume_removable, bool, 0644);
+MODULE_PARM_DESC(
+	removable,
+	"MMC/SD cards are removable and may be removed during suspend");
+
+/*
  * Internal function. Schedule delayed work in the MMC work queue.
  */
 static int mmc_schedule_delayed_work(struct delayed_work *work,
diff -puN drivers/mmc/core/core.h~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable drivers/mmc/core/core.h
--- a/drivers/mmc/core/core.h~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable
+++ a/drivers/mmc/core/core.h
@@ -64,7 +64,9 @@ int mmc_attach_mmc(struct mmc_host *host
 int mmc_attach_sd(struct mmc_host *host, u32 ocr);
 int mmc_attach_sdio(struct mmc_host *host, u32 ocr);
 
+/* Module parameters */
 extern int use_spi_crc;
+extern int mmc_assume_removable;
 
 /* Debugfs information for hosts and cards */
 void mmc_add_host_debugfs(struct mmc_host *host);
diff -puN drivers/mmc/core/mmc.c~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable
+++ a/drivers/mmc/core/mmc.c
@@ -602,25 +602,6 @@ static int mmc_awake(struct mmc_host *ho
 	return err;
 }
 
-#ifdef CONFIG_MMC_UNSAFE_RESUME
-
-static const struct mmc_bus_ops mmc_ops = {
-	.awake = mmc_awake,
-	.sleep = mmc_sleep,
-	.remove = mmc_remove,
-	.detect = mmc_detect,
-	.suspend = mmc_suspend,
-	.resume = mmc_resume,
-	.power_restore = mmc_power_restore,
-};
-
-static void mmc_attach_bus_ops(struct mmc_host *host)
-{
-	mmc_attach_bus(host, &mmc_ops);
-}
-
-#else
-
 static const struct mmc_bus_ops mmc_ops = {
 	.awake = mmc_awake,
 	.sleep = mmc_sleep,
@@ -645,15 +626,13 @@ static void mmc_attach_bus_ops(struct mm
 {
 	const struct mmc_bus_ops *bus_ops;
 
-	if (host->caps & MMC_CAP_NONREMOVABLE)
+	if (host->caps & MMC_CAP_NONREMOVABLE || !mmc_assume_removable)
 		bus_ops = &mmc_ops_unsafe;
 	else
 		bus_ops = &mmc_ops;
 	mmc_attach_bus(host, bus_ops);
 }
 
-#endif
-
 /*
  * Starting point for MMC card init.
  */
diff -puN drivers/mmc/core/sd.c~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable drivers/mmc/core/sd.c
--- a/drivers/mmc/core/sd.c~mmc-add-module-parameter-to-set-whether-cards-are-assumed-removable
+++ a/drivers/mmc/core/sd.c
@@ -606,23 +606,6 @@ static void mmc_sd_power_restore(struct 
 	mmc_release_host(host);
 }
 
-#ifdef CONFIG_MMC_UNSAFE_RESUME
-
-static const struct mmc_bus_ops mmc_sd_ops = {
-	.remove = mmc_sd_remove,
-	.detect = mmc_sd_detect,
-	.suspend = mmc_sd_suspend,
-	.resume = mmc_sd_resume,
-	.power_restore = mmc_sd_power_restore,
-};
-
-static void mmc_sd_attach_bus_ops(struct mmc_host *host)
-{
-	mmc_attach_bus(host, &mmc_sd_ops);
-}
-
-#else
-
 static const struct mmc_bus_ops mmc_sd_ops = {
 	.remove = mmc_sd_remove,
 	.detect = mmc_sd_detect,
@@ -643,15 +626,13 @@ static void mmc_sd_attach_bus_ops(struct
 {
 	const struct mmc_bus_ops *bus_ops;
 
-	if (host->caps & MMC_CAP_NONREMOVABLE)
+	if (host->caps & MMC_CAP_NONREMOVABLE || !mmc_assume_removable)
 		bus_ops = &mmc_sd_ops_unsafe;
 	else
 		bus_ops = &mmc_sd_ops;
 	mmc_attach_bus(host, bus_ops);
 }
 
-#endif
