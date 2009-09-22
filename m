From: akpm@linux-foundation.org
Subject: [folded] sdio-add-mmc_quirk_lenient_fn0-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:40:58 -0700
Message-ID: <200909222140.n8MLewPn028199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbZIVVk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org, ohad@wizery.com, mm-commits@vger.kernel.org


The patch titled
     sdio-add-mmc_quirk_lenient_fn0-fix
has been removed from the -mm tree.  Its filename was
     sdio-add-mmc_quirk_lenient_fn0-fix.patch

This patch was dropped because it was folded into sdio-add-mmc_quirk_lenient_fn0.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio-add-mmc_quirk_lenient_fn0-fix
From: Andrew Morton <akpm@linux-foundation.org>

Code in C, not cpp!

Cc: <linux-mmc@vger.kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmc/card.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/mmc/card.h~sdio-add-mmc_quirk_lenient_fn0-fix include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~sdio-add-mmc_quirk_lenient_fn0-fix
+++ a/include/linux/mmc/card.h
@@ -134,7 +134,10 @@ struct mmc_card {
 #define mmc_card_set_highspeed(c) ((c)->state |= MMC_STATE_HIGHSPEED)
 #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
 
-#define mmc_card_lenient_fn0(c)	((c)->quirks & MMC_QUIRK_LENIENT_FN0)
+static inline int mmc_card_lenient_fn0(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_LENIENT_FN0;
+}
 
 #define mmc_card_name(c)	((c)->cid.prod_name)
 #define mmc_card_id(c)		(dev_name(&(c)->dev))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support.patch
sdio-add-mmc_quirk_lenient_fn0.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch

