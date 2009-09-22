From: akpm@linux-foundation.org
Subject: [folded] sdio-add-cd-disable-support-cleanup.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:40:28 -0700
Message-ID: <200909222140.n8MLeTQ4027255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbZIVVku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david.vrabel@csr.com, ian@mnementh.co.uk, matt@console-pimps.org, ohad@wizery.com, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com, mm-comm


The patch titled
     sdio-add-cd-disable-support-cleanup
has been removed from the -mm tree.  Its filename was
     sdio-add-cd-disable-support-cleanup.patch

This patch was dropped because it was folded into sdio-add-cd-disable-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio-add-cd-disable-support-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

simplify sdio_disable_cd() a bit

Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/mmc/core/sdio.c~sdio-add-cd-disable-support-cleanup drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~sdio-add-cd-disable-support-cleanup
+++ a/drivers/mmc/core/sdio.c
@@ -184,11 +184,7 @@ static int sdio_disable_cd(struct mmc_ca
 
 	ctrl |= SDIO_BUS_CD_DISABLE;
 
-	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
-	if (ret)
-		return ret;
-
-	return 0;
+	return mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
 }
 
 /*
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
sdio-add-cd-disable-support-cleanup.patch
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

