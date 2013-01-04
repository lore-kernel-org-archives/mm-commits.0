From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 04 Jan 2013 13:56:18 -0800
Message-ID: <20130104224713.C1DEC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40403 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3ADWrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jan 2013 17:47:14 -0500
Received: by mail-yh0-f74.google.com with SMTP id w68so765585yhw.5
        for <mm-commits@vger.kernel.org>; Fri, 04 Jan 2013 14:47:14 -0800 (PST)
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

 arch/arm64/Kconfig                |    3 ---
 arch/s390/kernel/smp.c            |   10 ----------
 drivers/dma/ioat/dma_v3.c         |    3 ---
 drivers/media/pci/dm1105/dm1105.c |    3 ---
 drivers/pinctrl/pinctrl-nomadik.c |    3 ---
 5 files changed, 22 deletions(-)

diff -puN arch/arm64/Kconfig~linux-next-git-rejects arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~linux-next-git-rejects
+++ a/arch/arm64/Kconfig
@@ -2,10 +2,7 @@ config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
-<<<<<<< HEAD
 	select ARM_AMBA
-=======
->>>>>>> linux-next/akpm-base
 	select CLONE_BACKWARDS
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
diff -puN arch/s390/kernel/smp.c~linux-next-git-rejects arch/s390/kernel/smp.c
--- a/arch/s390/kernel/smp.c~linux-next-git-rejects
+++ a/arch/s390/kernel/smp.c
@@ -623,16 +623,10 @@ static struct sclp_cpu_info *smp_get_cpu
 	return info;
 }
 
-<<<<<<< HEAD
-static int smp_add_present_cpu(int cpu);
-
-static int __smp_rescan_cpus(struct sclp_cpu_info *info, int sysfs_add)
-=======
 static int __cpuinit smp_add_present_cpu(int cpu);
 
 static int __cpuinit __smp_rescan_cpus(struct sclp_cpu_info *info,
 				       int sysfs_add)
->>>>>>> linux-next/akpm-base
 {
 	struct pcpu *pcpu;
 	cpumask_t avail;
@@ -993,11 +987,7 @@ static int __cpuinit smp_cpu_notify(stru
 	return notifier_from_errno(err);
 }
 
-<<<<<<< HEAD
-static int smp_add_present_cpu(int cpu)
-=======
 static int __cpuinit smp_add_present_cpu(int cpu)
->>>>>>> linux-next/akpm-base
 {
 	struct cpu *c = &pcpu_devices[cpu].cpu;
 	struct device *s = &c->dev;
diff -puN drivers/dma/ioat/dma_v3.c~linux-next-git-rejects drivers/dma/ioat/dma_v3.c
--- a/drivers/dma/ioat/dma_v3.c~linux-next-git-rejects
+++ a/drivers/dma/ioat/dma_v3.c
@@ -1224,8 +1224,6 @@ static bool is_snb_ioat(struct pci_dev *
 	}
 }
 
-<<<<<<< HEAD
-=======
 static bool is_ivb_ioat(struct pci_dev *pdev)
 {
 	switch (pdev->device) {
@@ -1246,7 +1244,6 @@ static bool is_ivb_ioat(struct pci_dev *
 
 }
 
->>>>>>> linux-next/akpm-base
 int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
diff -puN drivers/media/pci/dm1105/dm1105.c~linux-next-git-rejects drivers/media/pci/dm1105/dm1105.c
--- a/drivers/media/pci/dm1105/dm1105.c~linux-next-git-rejects
+++ a/drivers/media/pci/dm1105/dm1105.c
@@ -850,13 +850,10 @@ static struct ds3000_config dvbworld_ds3
 	.demod_address = 0x68,
 };
 
-<<<<<<< HEAD
-=======
 static struct ts2020_config dvbworld_ts2020_config  = {
 	.tuner_address = 0x60,
 };
 
->>>>>>> linux-next/akpm-base
 static int frontend_init(struct dm1105_dev *dev)
 {
 	int ret;
diff -puN drivers/pinctrl/pinctrl-nomadik.c~linux-next-git-rejects drivers/pinctrl/pinctrl-nomadik.c
--- a/drivers/pinctrl/pinctrl-nomadik.c~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-nomadik.c
@@ -2112,8 +2112,6 @@ static const struct of_device_id nmk_pin
 	{},
 };
 
-<<<<<<< HEAD
-=======
 static int nmk_pinctrl_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct nmk_pinctrl *npct;
@@ -2136,7 +2134,6 @@ static int nmk_pinctrl_resume(struct pla
 	return pinctrl_force_default(npct->pctl);
 }
 
->>>>>>> linux-next/akpm-base
 static int nmk_pinctrl_probe(struct platform_device *pdev)
 {
 	const struct platform_device_id *platid = platform_get_device_id(pdev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
rtc-add-rtc-driver-for-tps6586x-fix2.patch
linux-next.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
kernel-auditc-avoid-negative-sleep-durations.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
aio-smoosh-struct-kiocb-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

