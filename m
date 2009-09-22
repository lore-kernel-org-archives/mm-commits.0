From: akpm@linux-foundation.org
Subject: [folded] drivers-video-add-kmalloc-null-tests-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:53:56 -0700
Message-ID: <200909222153.n8MLrvUn021334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085AbZIVVx7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:53:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, julia@diku.dk, tom.leiming@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers-video-add-kmalloc-null-tests-fix
has been removed from the -mm tree.  Its filename was
     drivers-video-add-kmalloc-null-tests-fix.patch

This patch was dropped because it was folded into drivers-video-add-kmalloc-null-tests.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-video-add-kmalloc-null-tests-fix
From: Andrew Morton <akpm@linux-foundation.org>

convert to kstrdup() as well.

Cc: Julia Lawall <julia@diku.dk>
Cc: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/au1100fb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/au1100fb.c~drivers-video-add-kmalloc-null-tests-fix drivers/video/au1100fb.c
--- a/drivers/video/au1100fb.c~drivers-video-add-kmalloc-null-tests-fix
+++ a/drivers/video/au1100fb.c
@@ -715,12 +715,11 @@ int au1100fb_setup(char *options)
 			}
 			/* Mode option (only option that start with digit) */
 			else if (isdigit(this_opt[0])) {
-				mode = kmalloc(strlen(this_opt) + 1, GFP_KERNEL);
+				mode = kstrdup(this_opt, GFP_KERNEL);
 				if (!mode) {
 					print_err("memory allocation failed");
 					return -ENOMEM;
 				}
-				strncpy(mode, this_opt, strlen(this_opt) + 1);
 			}
 			/* Unsupported option */
 			else {
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
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch
mmc-core-sdio-suspend-resume-support.patch
procfs-provide-stack-information-for-threads-v08.patch
kcore-register-vmemmap-range.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch

