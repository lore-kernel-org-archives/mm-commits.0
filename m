From: akpm@linux-foundation.org
Subject: + rtc-da9063-rtc-driver-fix.patch added to -mm tree
Date: Wed, 07 May 2014 13:01:22 -0700
Message-ID: <536a9112.fm2zZkFFfe2v7zp0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaEGUBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 16:01:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stwiss.opensource@diasemi.com, sameo@linux.intel.com, p.zabel@pengutronix.de, lee.jones@linaro.org, david.chen@diasemi.com, broonie@linaro.org, a.zummo@towertech.it, akpm@linux-foundation.org

Subject: + rtc-da9063-rtc-driver-fix.patch added to -mm tree
To: akpm@linux-foundation.org,a.zummo@towertech.it,broonie@linaro.org,david.chen@diasemi.com,lee.jones@linaro.org,p.zabel@pengutronix.de,sameo@linux.intel.com,stwiss.opensource@diasemi.com
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 13:01:22 -0700


The patch titled
     Subject: rtc-da9063-rtc-driver-fix
has been added to the -mm tree.  Its filename is
     rtc-da9063-rtc-driver-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-da9063-rtc-driver-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-da9063-rtc-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-da9063-rtc-driver-fix

coding-style tweaks

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Dajun Chen <david.chen@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@linaro.org>
Cc: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9063.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-da9063.c~rtc-da9063-rtc-driver-fix drivers/rtc/rtc-da9063.c
--- a/drivers/rtc/rtc-da9063.c~rtc-da9063-rtc-driver-fix
+++ a/drivers/rtc/rtc-da9063.c
@@ -82,6 +82,7 @@ static void da9063_tm_to_data(struct rtc
 static int da9063_rtc_stop_alarm(struct device *dev)
 {
 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+
 	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
 				  DA9063_ALARM_ON, 0);
 }
@@ -89,6 +90,7 @@ static int da9063_rtc_stop_alarm(struct
 static int da9063_rtc_start_alarm(struct device *dev)
 {
 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+
 	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
 				  DA9063_ALARM_ON, DA9063_ALARM_ON);
 }
@@ -115,13 +117,12 @@ static int da9063_rtc_read_time(struct d
 
 	da9063_data_to_tm(data, tm);
 
-	(void)rtc_tm_to_time(tm, &tm_secs);
-	(void)rtc_tm_to_time(&rtc->alarm_time, &al_secs);
+	rtc_tm_to_time(tm, &tm_secs);
+	rtc_tm_to_time(&rtc->alarm_time, &al_secs);
 
 	/* handle the rtc synchronisation delay */
 	if (rtc->rtc_sync == true && al_secs - tm_secs == 1)
-		(void)memcpy((void *)tm, (const void *)&rtc->alarm_time,
-			     sizeof(struct rtc_time));
+		memcpy(tm, &rtc->alarm_time, sizeof(struct rtc_time));
 	else
 		rtc->rtc_sync = false;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
rtc-da9063-rtc-driver-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

