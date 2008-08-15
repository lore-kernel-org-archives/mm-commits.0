From: akpm@linux-foundation.org
Subject: + kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix.patch added to -mm tree
Date: Thu, 14 Aug 2008 17:46:57 -0700
Message-ID: <200808150100.m7F106I0006447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbYHOBBv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 21:01:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, rmk@arm.linux.org.uk, vgoyal@redhat.com, ying.huang@intel.com


The patch titled
     kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix
has been added to the -mm tree.  Its filename is
     kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix.patch

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
Subject: kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix
From: Andrew Morton <akpm@linux-foundation.org>

- unbreak powerpc and arm

- use grep

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/machine_kexec.c        |    2 +-
 arch/powerpc/kernel/machine_kexec_32.c |    2 +-
 arch/x86/kernel/machine_kexec_32.c     |    2 +-
 kernel/kexec.c                         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arm/kernel/machine_kexec.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix arch/arm/kernel/machine_kexec.c
--- a/arch/arm/kernel/machine_kexec.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix
+++ a/arch/arm/kernel/machine_kexec.c
@@ -71,7 +71,7 @@ void machine_kexec(struct kimage *image)
 
 
 	flush_icache_range((unsigned long) reboot_code_buffer,
-			   (unsigned long) reboot_code_buffer + KEXEC_CONTROL_CODE_SIZE);
+			   (unsigned long) reboot_code_buffer + KEXEC_CONTROL_PAGE_SIZE);
 	printk(KERN_INFO "Bye!\n");
 
 	cpu_proc_fin();
diff -puN arch/powerpc/kernel/machine_kexec_32.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix arch/powerpc/kernel/machine_kexec_32.c
--- a/arch/powerpc/kernel/machine_kexec_32.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix
+++ a/arch/powerpc/kernel/machine_kexec_32.c
@@ -51,7 +51,7 @@ void default_machine_kexec(struct kimage
 						relocate_new_kernel_size);
 
 	flush_icache_range(reboot_code_buffer,
-				reboot_code_buffer + KEXEC_CONTROL_CODE_SIZE);
+				reboot_code_buffer + KEXEC_CONTROL_PAGE_SIZE);
 	printk(KERN_INFO "Bye!\n");
 
 	/* now call it */
diff -puN arch/x86/kernel/machine_kexec_32.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -78,7 +78,7 @@ static void load_segments(void)
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
- * as needed.  The pages for KEXEC_CONTROL_CODE_SIZE
+ * as needed.  The pages for KEXEC_CONTROL_PAGE_SIZE
  * have been allocated, but the segments have yet
  * been copied into the kernel.
  *
diff -puN kernel/kexec.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix kernel/kexec.c
--- a/kernel/kexec.c~kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix
+++ a/kernel/kexec.c
@@ -77,7 +77,7 @@ int kexec_should_crash(struct task_struc
  *
  * The code for the transition from the current kernel to the
  * the new kernel is placed in the control_code_buffer, whose size
- * is given by KEXEC_CONTROL_CODE_SIZE.  In the best case only a single
+ * is given by KEXEC_CONTROL_PAGE_SIZE.  In the best case only a single
  * page of memory is necessary, but some architectures require more.
  * Because this memory must be identity mapped in the transition from
  * virtual to physical addresses it must live in the range
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size-fix.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-use-a-bitop-for-locking-rather-than-xchg.patch
hwmon-adc124s501-generic-driver.patch
spi-bugfix-spi_add_device-with-duplicate-chipselects.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
next-git-rejects.patch
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
git-net.patch
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
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
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

