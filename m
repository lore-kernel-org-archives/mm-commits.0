From: akpm@linux-foundation.org
Subject: - arch-x86-kernel-cpu-amdc-amd_fixup_dcm-is-unused-if-config_x86_ht=n.patch removed from -mm tree
Date: Fri, 07 Aug 2009 12:42:35 -0700
Message-ID: <200908071942.n77JgZic011018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754927AbZHGTmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2009 15:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, robert.richter@amd.com, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/cpu/amd.c: amd_fixup_dcm() is unused if CONFIG_X86_HT=n
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-cpu-amdc-amd_fixup_dcm-is-unused-if-config_x86_ht=n.patch

This patch was dropped because a more stupid patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/cpu/amd.c: amd_fixup_dcm() is unused if CONFIG_X86_HT=n
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/cpu/amd.c:262: warning: 'amd_fixup_dcm' defined but not used

Cc: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/amd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/amd.c~arch-x86-kernel-cpu-amdc-amd_fixup_dcm-is-unused-if-config_x86_ht=n arch/x86/kernel/cpu/amd.c
--- a/arch/x86/kernel/cpu/amd.c~arch-x86-kernel-cpu-amdc-amd_fixup_dcm-is-unused-if-config_x86_ht=n
+++ a/arch/x86/kernel/cpu/amd.c
@@ -252,6 +252,7 @@ static int __cpuinit nearby_node(int api
 }
 #endif
 
+#ifdef CONFIG_X86_HT
 /*
  * Fixup core topology information for AMD multi-node processors.
  * Assumption 1: Number of cores in each internal node is the same.
@@ -308,7 +309,6 @@ static void __cpuinit amd_fixup_dcm(stru
  */
 static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_HT
 	unsigned bits;
 	int cpu = smp_processor_id();
 
@@ -322,8 +322,12 @@ static void __cpuinit amd_detect_cmp(str
 	/* fixup topology information on multi-node processors */
 	if ((c->x86 == 0x10) && (c->x86_model == 9))
 		amd_fixup_dcm(c);
-#endif
 }
+#else
+static inline void amd_detect_cmp(struct cpuinfo_x86 *c)
+{
+}
+#endif
 
 static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-amdc-fix-x86_64-allnoconfig-build.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-cpu-amdc-amd_fixup_dcm-is-unused-if-config_x86_ht=n.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
leds-gpio-leds-fix-typographics-fault.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch
slram-read-buffer-overflow.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimize-touch_time-too.patch
lguest-cleanup-for-map_switcher.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ummunotify-userspace-support-for-mmu-notifications.patch
ummunotify-userspace-support-for-mmu-notifications-v3-fix.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers-checkpatch-fixes.patch
oom-fix-oom_adjust_write-input-sanity-check-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

