From: akpm@linux-foundation.org
Subject: [folded] printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:36:34 -0700
Message-ID: <200909222136.n8MLaYfd019445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbZIVVgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:36:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hidave.darkstar@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup
has been removed from the -mm tree.  Its filename was
     printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch

This patch was dropped because it was folded into printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup kernel/printk.c
--- a/kernel/printk.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup
+++ a/kernel/printk.c
@@ -653,12 +653,13 @@ static int recursion_bug;
 static int new_text_line = 1;
 static char printk_buf[1024];
 
-int printk_delay_msec;
+int printk_delay_msec __read_mostly;
 
 static inline void printk_delay(void)
 {
 	if (unlikely(printk_delay_msec)) {
 		int m = printk_delay_msec;
+
 		while (m--) {
 			mdelay(1);
 			touch_nmi_watchdog();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
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

