From: akpm@linux-foundation.org
Subject: [merged] watchdog-fsl_get_sys_freq-failure-not-noticed.patch removed from -mm tree
Date: Thu, 05 Mar 2009 11:56:16 -0800
Message-ID: <200903051956.n25JuGcC027234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754813AbZCET4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 14:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: fsl_get_sys_freq() failure not noticed
has been removed from the -mm tree.  Its filename was
     watchdog-fsl_get_sys_freq-failure-not-noticed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: fsl_get_sys_freq() failure not noticed
From: Roel Kluin <roel.kluin@gmail.com>

fsl_get_sys_freq() may return -1 when 'soc' isn't found, but in
gef_wdt_probe() 'freq' is unsigned, so the test doesn't catch that.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/gef_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/gef_wdt.c~watchdog-fsl_get_sys_freq-failure-not-noticed drivers/watchdog/gef_wdt.c
--- a/drivers/watchdog/gef_wdt.c~watchdog-fsl_get_sys_freq-failure-not-noticed
+++ a/drivers/watchdog/gef_wdt.c
@@ -269,7 +269,7 @@ static int __devinit gef_wdt_probe(struc
 	bus_clk = 133; /* in MHz */
 
 	freq = fsl_get_sys_freq();
-	if (freq > 0)
+	if (freq != -1)
 		bus_clk = freq;
 
 	/* Map devices registers into memory */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

mm-get_nid_for_pfn-returns-int.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
acpi-wmic-unsigned-cannot-be-less-than-0.patch
powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
jffs2_acl_count-tests-0-on-unsigned.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
cfg80211-test-before-subtraction-on-unsigned.patch
hugetlb-chg-cannot-become-less-than-0.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
rtc-test-before-subtraction-on-unsigned.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch
rio-addition-has-higher-precedence-than.patch
aoe-error-printed-1-too-early.patch
loop-dont-increment-p-offset-with-size_t-einval.patch

