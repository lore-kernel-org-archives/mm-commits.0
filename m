From: akpm@linux-foundation.org
Subject: + rtc-fixes-and-new-functionality-for-fm3130-fix.patch added to -mm tree
Date: Mon, 07 Jun 2010 13:33:27 -0700
Message-ID: <201006072033.o57KXRR8026776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab0FGUeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jun 2010 16:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, geomatsi@gmail.com, mcuos.com@gmail.com, slapin@ossfans.org


The patch titled
     rtc-fixes-and-new-functionality-for-fm3130-fix
has been added to the -mm tree.  Its filename is
     rtc-fixes-and-new-functionality-for-fm3130-fix.patch

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
Subject: rtc-fixes-and-new-functionality-for-fm3130-fix
From: Andrew Morton <akpm@linux-foundation.org>

make fm3130_alarm_irq_enable() static, fix comment layout

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sergey Lapin <slapin@ossfans.org>
Cc: Sergey Matyukevich <geomatsi@gmail.com>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-fm3130.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-fm3130.c~rtc-fixes-and-new-functionality-for-fm3130-fix drivers/rtc/rtc-fm3130.c
--- a/drivers/rtc/rtc-fm3130.c~rtc-fixes-and-new-functionality-for-fm3130-fix
+++ a/drivers/rtc/rtc-fm3130.c
@@ -206,10 +206,12 @@ static int fm3130_read_alarm(struct devi
 	struct rtc_time *tm = &alrm->time;
 
 	if (!fm3130->alarm_valid) {
-		/* We have invalid alarm in RTC, probably due
-		to battery faults or other problems. Return EIO
-		for now, it will allow us to set alarm value later
-		instead of error during probing which disables device */
+		/*
+		 * We have invalid alarm in RTC, probably due to battery faults
+		 * or other problems. Return EIO for now, it will allow us to
+		 * set alarm value later instead of error during probing which
+		 * disables device
+		 */
 		return -EIO;
 	}
 
@@ -317,7 +319,7 @@ static int fm3130_set_alarm(struct devic
 	return 0;
 }
 
-int fm3130_alarm_irq_enable(struct device *dev, unsigned int enabled)
+static int fm3130_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct fm3130 *fm3130 = dev_get_drvdata(dev);
 	int ret = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
mmc-recognize-csd-structure-fix.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

