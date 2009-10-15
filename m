From: akpm@linux-foundation.org
Subject: [merged] watchdog-fix-rio-watchdog-probe-function.patch removed from -mm tree
Date: Thu, 15 Oct 2009 11:43:52 -0700
Message-ID: <200910151843.n9FIhqaT024085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935250AbZJOSor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 14:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, davem@davemloft.net, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: fix rio watchdog probe function
has been removed from the -mm tree.  Its filename was
     watchdog-fix-rio-watchdog-probe-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: fix rio watchdog probe function
From: Thomas Gleixner <tglx@linutronix.de>

After sucessfully registering the misc device the driver iounmaps the
hardware registers and kfree's the device data structure.  Ouch !

This was introduced with commit e42311d75 (riowatchdog: Convert to
pure OF driver) and went unnoticed for more than a year :)

Return success instead of dropping into the error cleanup code path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/watchdog/riowd.c~watchdog-fix-rio-watchdog-probe-function drivers/watchdog/riowd.c
--- a/drivers/watchdog/riowd.c~watchdog-fix-rio-watchdog-probe-function
+++ a/drivers/watchdog/riowd.c
@@ -206,7 +206,7 @@ static int __devinit riowd_probe(struct 
 
 	dev_set_drvdata(&op->dev, p);
 	riowd_device = p;
-	err = 0;
+	return 0;
 
 out_iounmap:
 	of_iounmap(&op->resource[0], p->regs, 2);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
powernow-k8-fix-test-in-get_transition_latency.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
rtc-disable-hpet-emulation-on-suspend.patch
hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics.patch
timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

