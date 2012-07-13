From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 13 Jul 2012 12:48:18 -0700
Message-ID: <20120713194819.58FC41E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57553 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2GMTsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 15:48:21 -0400
Received: by qcqs25 with SMTP id s25so377751qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 12:48:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/s5p-fimc/fimc-capture.c |    7 --
 drivers/mfd/mc13xxx-spi.c                   |    6 -
 drivers/usb/host/ehci-omap.c                |   61 ------------------
 3 files changed, 74 deletions(-)

diff -puN drivers/media/video/s5p-fimc/fimc-capture.c~linux-next-git-rejects drivers/media/video/s5p-fimc/fimc-capture.c
--- a/drivers/media/video/s5p-fimc/fimc-capture.c~linux-next-git-rejects
+++ a/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -495,17 +495,10 @@ static int fimc_capture_open(struct file
 	ret = v4l2_fh_open(file);
 	if (ret)
 		return ret;
-<<<<<<< HEAD
 
 	if (++fimc->vid_cap.refcnt != 1)
 		return 0;
 
-=======
-
-	if (++fimc->vid_cap.refcnt != 1)
-		return 0;
-
->>>>>>> linux-next/akpm-base
 	ret = fimc_pipeline_initialize(&fimc->pipeline,
 				       &fimc->vid_cap.vfd->entity, true);
 	if (ret < 0) {
diff -puN drivers/mfd/mc13xxx-spi.c~linux-next-git-rejects drivers/mfd/mc13xxx-spi.c
--- a/drivers/mfd/mc13xxx-spi.c~linux-next-git-rejects
+++ a/drivers/mfd/mc13xxx-spi.c
@@ -139,15 +139,9 @@ static int mc13xxx_spi_probe(struct spi_
 	mc13xxx->dev = &spi->dev;
 	mutex_init(&mc13xxx->lock);
 
-<<<<<<< HEAD
-	mc13xxx->regmap = regmap_init(&spi->dev, &regmap_mc13xxx_bus, &spi->dev,
-					&mc13xxx_regmap_spi_config);
-
-=======
 	mc13xxx->regmap = devm_regmap_init(&spi->dev, &regmap_mc13xxx_bus,
 					   &spi->dev,
 					   &mc13xxx_regmap_spi_config);
->>>>>>> linux-next/akpm-base
 	if (IS_ERR(mc13xxx->regmap)) {
 		ret = PTR_ERR(mc13xxx->regmap);
 		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
diff -puN drivers/usb/host/ehci-omap.c~linux-next-git-rejects drivers/usb/host/ehci-omap.c
--- a/drivers/usb/host/ehci-omap.c~linux-next-git-rejects
+++ a/drivers/usb/host/ehci-omap.c
@@ -330,21 +330,6 @@ static int ehci_hcd_omap_probe(struct pl
 		}
 	}
 
-<<<<<<< HEAD
-	/* Hold PHYs in reset while initializing EHCI controller */
-	if (pdata->phy_reset) {
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_set_value_cansleep(pdata->reset_gpio_port[0], 0);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_set_value_cansleep(pdata->reset_gpio_port[1], 0);
-
-		/* Hold the PHY in RESET for enough time till DIR is high */
-		udelay(10);
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
@@ -360,58 +345,12 @@ static int ehci_hcd_omap_probe(struct pl
 	ehci_write(regs, EHCI_INSNREG04,
 				EHCI_INSNREG04_DISABLE_UNSUSPEND);
 
-<<<<<<< HEAD
-	/* Soft reset the PHY using PHY reset command over ULPI */
-	if (pdata->port_mode[0] == OMAP_EHCI_PORT_MODE_PHY)
-		omap_ehci_soft_phy_reset(pdev, 0);
-	if (pdata->port_mode[1] == OMAP_EHCI_PORT_MODE_PHY)
-		omap_ehci_soft_phy_reset(pdev, 1);
-
-	omap_ehci = hcd_to_ehci(hcd);
-	omap_ehci->sbrn = 0x20;
-
-	/* we know this is the memory we want, no need to ioremap again */
-	omap_ehci->caps = hcd->regs;
-	omap_ehci->regs = hcd->regs
-		+ HC_LENGTH(ehci, readl(&omap_ehci->caps->hc_capbase));
-
-	dbg_hcs_params(omap_ehci, "reset");
-	dbg_hcc_params(omap_ehci, "reset");
-
-	/* cache this readonly data; minimize chip reads */
-	omap_ehci->hcs_params = readl(&omap_ehci->caps->hcs_params);
-
-	ehci_reset(omap_ehci);
-	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (ret) {
-		dev_err(dev, "failed to add hcd with err %d\n", ret);
-		goto err_add_hcd;
-	}
-
-	if (pdata->phy_reset) {
-		/* Hold the PHY in RESET for enough time till
-		 * PHY is settled and ready
-		 */
-		udelay(10);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_set_value_cansleep(pdata->reset_gpio_port[0], 1);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_set_value_cansleep(pdata->reset_gpio_port[1], 1);
-	}
-
-	/* root ports should always stay powered */
-	ehci_port_power(omap_ehci, 1);
-
-=======
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret) {
 		dev_err(dev, "failed to add hcd with err %d\n", ret);
 		goto err_pm_runtime;
 	}
 
->>>>>>> linux-next/akpm-base
 	/* get clocks */
 	utmi_p1_fck = clk_get(dev, "utmi_p1_gfclk");
 	if (IS_ERR(utmi_p1_fck)) {
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

