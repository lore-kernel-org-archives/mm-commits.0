From: akpm@linux-foundation.org
Subject: + x86-microcode-patch-loader-style-corrections-fix.patch added to -mm tree
Date: Wed, 13 Aug 2008 19:04:04 -0700
Message-ID: <200808140204.m7E244UW017881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbYHNCJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 22:09:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, peter.oruba@amd.com, tglx@linutronix.de, tigran@aivazian.fsnet.co.uk


The patch titled
     x86-microcode-patch-loader-style-corrections-fix
has been added to the -mm tree.  Its filename is
     x86-microcode-patch-loader-style-corrections-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-microcode-patch-loader-style-corrections-fix
From: Andrew Morton <akpm@linux-foundation.org>

spell "matching" correctly.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/microcode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/microcode.c~x86-microcode-patch-loader-style-corrections-fix arch/x86/kernel/microcode.c
--- a/arch/x86/kernel/microcode.c~x86-microcode-patch-loader-style-corrections-fix
+++ a/arch/x86/kernel/microcode.c
@@ -264,7 +264,7 @@ static int microcode_sanity_check(void *
  * return 1 - found update
  * return < 0 - error
  */
-static int get_maching_microcode(void *mc, int cpu)
+static int get_matching_microcode(void *mc, int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	microcode_header_t *mc_header = mc;
@@ -405,7 +405,7 @@ static int do_microcode_update(void)
 			if (!uci->valid)
 				continue;
 			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-			error = get_maching_microcode(new_mc, cpu);
+			error = get_matching_microcode(new_mc, cpu);
 			if (error < 0)
 				goto out;
 			if (error == 1)
@@ -549,7 +549,7 @@ static int cpu_request_microcode(int cpu
 		error = microcode_sanity_check(mc);
 		if (error)
 			break;
-		error = get_maching_microcode(mc, cpu);
+		error = get_matching_microcode(mc, cpu);
 		if (error < 0)
 			break;
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-jump-check-code-size-in-control-page-fix.patch
kexec-use-a-bitop-for-locking-rather-than-xchg.patch
hwmon-adc124s501-generic-driver.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
acpi-trivial-cleanups-fix.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-microcode-patch-loader-style-corrections-fix.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
drivers-ata-pata_it821xc-fix-warning.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-tweaks.patch
ftrace-printk-formatting-infrastructure-fix-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
h8300-generic_bug-support-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
net-tipc-subscrc-dont-use-___constant_swab32.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

