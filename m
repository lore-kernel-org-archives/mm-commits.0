From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 22 Mar 2012 12:42:50 -0700
Message-ID: <20120322194252.947F9A033B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37778 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2CVTm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 15:42:56 -0400
Received: by wibhj13 with SMTP id hj13so58436wib.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 12:42:54 -0700 (PDT)
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

 arch/x86/Kconfig                 |    3 -
 arch/x86/kernel/setup.c          |    8 ---
 arch/x86/platform/efi/efi.c      |   62 -----------------------------
 arch/x86/platform/geode/Makefile |    3 -
 arch/x86/platform/mrst/mrst.c    |    3 -
 5 files changed, 79 deletions(-)

diff -puN arch/x86/Kconfig~linux-next-git-rejects arch/x86/Kconfig
--- a/arch/x86/Kconfig~linux-next-git-rejects
+++ a/arch/x86/Kconfig
@@ -2158,8 +2158,6 @@ config NET5501
 	---help---
 	  This option enables system support for the Soekris Engineering net5501.
 
-<<<<<<< HEAD
-=======
 config GEOS
 	bool "Traverse Technologies GEOS System Support (LEDS, GPIO, etc)"
 	select GPIOLIB
@@ -2167,7 +2165,6 @@ config GEOS
 	---help---
 	  This option enables system support for the Traverse Technologies GEOS.
 
->>>>>>> linux-next/akpm-end
 endif # X86_32
 
 config AMD_NB
diff -puN arch/x86/kernel/setup.c~linux-next-git-rejects arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~linux-next-git-rejects
+++ a/arch/x86/kernel/setup.c
@@ -752,19 +752,11 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL32", 4)) {
-<<<<<<< HEAD
 		efi_enabled = 1;
 		efi_64bit = false;
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL64", 4)) {
 		efi_enabled = 1;
-=======
-		efi_enabled = 1;
-		efi_64bit = false;
-	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL64", 4)) {
-		efi_enabled = 1;
->>>>>>> linux-next/akpm-end
 		efi_64bit = true;
 	}
 	if (efi_enabled && efi_memblock_x86_reserve_range())
diff -puN arch/x86/platform/efi/efi.c~linux-next-git-rejects arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~linux-next-git-rejects
+++ a/arch/x86/platform/efi/efi.c
@@ -669,7 +669,6 @@ void __init efi_init(void)
 	int i = 0;
 	void *tmp;
 
-<<<<<<< HEAD
 #ifdef CONFIG_X86_32
 	if (boot_params.efi_info.efi_systab_hi ||
 	    boot_params.efi_info.efi_memmap_hi) {
@@ -729,67 +728,6 @@ void __init efi_init(void)
 		return;
 	}
 #ifdef CONFIG_X86_32
-=======
-#ifdef CONFIG_X86_32
-	if (boot_params.efi_info.efi_systab_hi ||
-	    boot_params.efi_info.efi_memmap_hi) {
-		pr_info("Table located above 4GB, disabling EFI.\n");
-		efi_enabled = 0;
-		return;
-	}
-	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
-	efi_native = !efi_64bit;
-#else
-	efi_phys.systab = (efi_system_table_t *)
-			  (boot_params.efi_info.efi_systab |
-			  ((__u64)boot_params.efi_info.efi_systab_hi<<32));
-	efi_native = efi_64bit;
-#endif
-
-	if (efi_systab_init(efi_phys.systab)) {
-		efi_enabled = 0;
-		return;
-	}
-
-	/*
-	 * Show what we know for posterity
-	 */
-	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
-	if (c16) {
-		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] = *c16++;
-		vendor[i] = '\0';
-	} else
-		pr_err("Could not map the firmware vendor!\n");
-	early_iounmap(tmp, 2);
-
-	pr_info("EFI v%u.%.02u by %s\n",
-		efi.systab->hdr.revision >> 16,
-		efi.systab->hdr.revision & 0xffff, vendor);
-
-	if (efi_config_init(efi.systab->tables, efi.systab->nr_tables)) {
-		efi_enabled = 0;
-		return;
-	}
-
-	/*
-	 * Note: We currently don't support runtime services on an EFI
-	 * that doesn't match the kernel 32/64-bit mode.
-	 */
-
-	if (!efi_native)
-		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
-	else if (efi_runtime_init()) {
-		efi_enabled = 0;
-		return;
-	}
-
-	if (efi_memmap_init()) {
-		efi_enabled = 0;
-		return;
-	}
-#ifdef CONFIG_X86_32
->>>>>>> linux-next/akpm-end
 	if (efi_native) {
 		x86_platform.get_wallclock = efi_get_time;
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
diff -puN arch/x86/platform/geode/Makefile~linux-next-git-rejects arch/x86/platform/geode/Makefile
--- a/arch/x86/platform/geode/Makefile~linux-next-git-rejects
+++ a/arch/x86/platform/geode/Makefile
@@ -1,6 +1,3 @@
 obj-$(CONFIG_ALIX)		+= alix.o
 obj-$(CONFIG_NET5501)		+= net5501.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_GEOS)		+= geos.o
->>>>>>> linux-next/akpm-end
diff -puN arch/x86/platform/mrst/mrst.c~linux-next-git-rejects arch/x86/platform/mrst/mrst.c
--- a/arch/x86/platform/mrst/mrst.c~linux-next-git-rejects
+++ a/arch/x86/platform/mrst/mrst.c
@@ -672,8 +672,6 @@ static void *msic_ocd_platform_data(void
 	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_OCD);
 }
 
-<<<<<<< HEAD
-=======
 /* tc35876x DSI-LVDS bridge chip and panel platform data */
 static void *tc35876x_platform_data(void *data)
 {
@@ -687,7 +685,6 @@ static void *tc35876x_platform_data(void
        return &pdata;
 }
 
->>>>>>> linux-next/akpm-end
 static void *msic_thermal_platform_data(void *info)
 {
 	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_THERMAL);
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
drivers-platform-x86-samsung-laptopc-fix-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
sched-fix-compiler-warning-about-declared-inline-after-use.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

