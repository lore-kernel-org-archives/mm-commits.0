From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:30 -0700
Message-ID: <20120731185231.1E85B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:59062 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2GaSwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:33 -0400
Received: by mail-fa0-f74.google.com with SMTP id 25so290609fat.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, agust@denx.de, andreas.dumberger@tqs.de, devendra.aaru@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-r9701.c: check that r9701_set_datetime() succeeded
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/rtc/rtc-r9701.c: check that r9701_set_datetime() succeeded

When the driver detects that the clock time is invalid, it attempts to
write a sane time into the hardware.  We curently assume that everything
is OK is those writes succeeded.  But it is better to re-read the time
from the hardware to ensure that the new settings got there OK.

Cc: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Andreas Dumberger <andreas.dumberger@tqs.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded
+++ a/drivers/rtc/rtc-r9701.c
@@ -147,7 +147,8 @@ static int __devinit r9701_probe(struct 
 		dt.tm_mon  = 0;
 		dt.tm_year = 100;
 
-		if (r9701_set_datetime(&spi->dev, &dt)) {
+		if (r9701_set_datetime(&spi->dev, &dt) ||
+				r9701_get_datetime(&spi->dev, &dt)) {
 			dev_err(&spi->dev, "cannot repair RTC register\n");
 			return -ENODEV;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

