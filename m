From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 01 Dec 2011 12:31:18 -0800
Message-ID: <201112012031.pB1KVJ5I019770@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:62850 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1LAUbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 15:31:21 -0500
Received: by vcbfl11 with SMTP id fl11so296580vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 12:31:20 -0800 (PST)
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

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-imx/Kconfig                 |    3 ---
 arch/arm/mach-mmp/include/mach/gpio-pxa.h |    3 ---
 arch/arm/tools/mach-types                 |    3 ---
 kernel/power/hibernate.c                  |   11 -----------
 mm/slub.c                                 |    6 ------
 5 files changed, 26 deletions(-)

diff -puN arch/arm/mach-imx/Kconfig~linux-next-git-rejects arch/arm/mach-imx/Kconfig
--- a/arch/arm/mach-imx/Kconfig~linux-next-git-rejects
+++ a/arch/arm/mach-imx/Kconfig
@@ -22,8 +22,6 @@ config ARCH_MX25
 config MACH_MX27
 	bool
 
-<<<<<<< HEAD
-=======
 config ARCH_MX5
 	bool
 
@@ -36,7 +34,6 @@ config ARCH_MX51
 config ARCH_MX53
 	bool
 
->>>>>>> linux-next/akpm-end
 config SOC_IMX1
 	bool
 	select ARCH_MX1
diff -puN arch/arm/mach-mmp/include/mach/gpio-pxa.h~linux-next-git-rejects arch/arm/mach-mmp/include/mach/gpio-pxa.h
--- a/arch/arm/mach-mmp/include/mach/gpio-pxa.h~linux-next-git-rejects
+++ a/arch/arm/mach-mmp/include/mach/gpio-pxa.h
@@ -9,11 +9,8 @@
 
 #define BANK_OFF(n)	(((n) < 3) ? (n) << 2 : 0x100 + (((n) - 3) << 2))
 #define GPIO_REG(x)	(*(volatile u32 *)(GPIO_REGS_VIRT + (x)))
-<<<<<<< HEAD
 
 #define NR_BUILTIN_GPIO		IRQ_GPIO_NUM
-=======
->>>>>>> linux-next/akpm-end
 
 #define gpio_to_bank(gpio)	((gpio) >> 5)
 
diff -puN arch/arm/tools/mach-types~linux-next-git-rejects arch/arm/tools/mach-types
--- a/arch/arm/tools/mach-types~linux-next-git-rejects
+++ a/arch/arm/tools/mach-types
@@ -836,9 +836,7 @@ blissc			MACH_BLISSC		BLISSC			3491
 thales_adc		MACH_THALES_ADC		THALES_ADC		3492
 ubisys_p9d_evp		MACH_UBISYS_P9D_EVP	UBISYS_P9D_EVP		3493
 atdgp318		MACH_ATDGP318		ATDGP318		3494
-<<<<<<< HEAD
 m28evk			MACH_M28EVK		M28EVK			3613
-=======
 dma210u			MACH_DMA210U		DMA210U			3495
 em_t3			MACH_EM_T3		EM_T3			3496
 htx3250			MACH_HTX3250		HTX3250			3497
@@ -976,7 +974,6 @@ coreware_sam9260_	MACH_COREWARE_SAM9260_
 marmaduke		MACH_MARMADUKE		MARMADUKE		3635
 amg_xlcore_camera	MACH_AMG_XLCORE_CAMERA	AMG_XLCORE_CAMERA	3636
 omap3_egf		MACH_OMAP3_EGF		OMAP3_EGF		3637
->>>>>>> linux-next/akpm-end
 smdk4212		MACH_SMDK4212		SMDK4212		3638
 dnp9200			MACH_DNP9200		DNP9200			3639
 tf101			MACH_TF101		TF101			3640
diff -puN kernel/power/hibernate.c~linux-next-git-rejects kernel/power/hibernate.c
--- a/kernel/power/hibernate.c~linux-next-git-rejects
+++ a/kernel/power/hibernate.c
@@ -362,11 +362,7 @@ int hibernation_snapshot(int platform_mo
 
 	error = dpm_prepare(PMSG_FREEZE);
 	if (error) {
-<<<<<<< HEAD
-		dpm_complete(msg);
-=======
 		dpm_complete(PMSG_RECOVER);
->>>>>>> linux-next/akpm-end
 		goto Cleanup;
 	}
 
@@ -403,13 +399,6 @@ int hibernation_snapshot(int platform_mo
 	platform_end(platform_mode);
 	return error;
 
-<<<<<<< HEAD
- Recover_platform:
-	platform_recover(platform_mode);
-	goto Resume_devices;
-
-=======
->>>>>>> linux-next/akpm-end
  Cleanup:
 	swsusp_free();
 	goto Close;
diff -puN mm/slub.c~linux-next-git-rejects mm/slub.c
--- a/mm/slub.c~linux-next-git-rejects
+++ a/mm/slub.c
@@ -1903,18 +1903,12 @@ static void unfreeze_partials(struct kme
 			if (l != m) {
 				if (l == M_PARTIAL) {
 					remove_partial(n, page);
-<<<<<<< HEAD
-				else
-					add_partial(n, page,
-						DEACTIVATE_TO_TAIL);
-=======
 					stat(s, FREE_REMOVE_PARTIAL);
 				} else {
 					add_partial(n, page,
 						DEACTIVATE_TO_TAIL);
 					stat(s, FREE_ADD_PARTIAL);
 				}
->>>>>>> linux-next/akpm-end
 
 				l = m;
 			}
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode-fix.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

