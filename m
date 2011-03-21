From: akpm@linux-foundation.org
Subject: + rapidio-fix-potential-null-deref-on-failure-path.patch added to -mm tree
Date: Mon, 21 Mar 2011 12:33:53 -0700
Message-ID: <201103211933.p2LJXs94020932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541Ab1CUTeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 15:34:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, @vger.kernel.org


The patch titled
     rapidio: fix potential null deref on failure path
has been added to the -mm tree.  Its filename is
     rapidio-fix-potential-null-deref-on-failure-path.patch

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
Subject: rapidio: fix potential null deref on failure path
From: Dan Carpenter <[error27@gmail.com]>

If rio is not a switch then "rswitch" is null.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-fix-potential-null-deref-on-failure-path drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-fix-potential-null-deref-on-failure-path
+++ a/drivers/rapidio/rio-scan.c
@@ -517,7 +517,7 @@ static struct rio_dev __devinit *rio_set
 	return rdev;
 
 cleanup:
-	if (rswitch->route_table)
+	if (rio_is_switch(rdev))
 		kfree(rswitch->route_table);
 
 	kfree(rdev);
_

Patches currently in -mm which might be from [error27@gmail.com] are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
mm-swap-unlock-swapfile-inode-mutex-before-closing-file-on-bad-swapfiles.patch
oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
oom-skip-zombies-when-iterating-tasklist.patch
oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced.patch
cgroups-if-you-list_empty-a-head-then-dont-list_del-it.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
linux-next.patch
next-remove-localversion.patch
revert-kbuild-reenable-section-mismatch-analysis.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-asm-generic-vmlinuxldsh-fix-__modver-section-warnings.patch
drivers-usb-serial-usb_wwanc-unbork.patch
drivers-media-video-tlg2300-pd-videoc-fix-double-mutex_unlock-in-pd_vidioc_s_fmt.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
arch-x86-kernel-microcode_corec-do-not-warn_oncpu-=-0-during-resume.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
x86-fix-mmap-random-address-range.patch
msm-timer-migrate-to-timer-based-__delay.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
audit-always-follow-va_copy-with-va_end.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
drivers-dma-ipu-ipu_irqc-irq_data-conversion.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch
cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-add-driver-for-lm3530-als.patch
leds-add-driver-for-lm3530-als-update.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-make-struct-gpio_led_platform_dataleds-const.patch
drivers-vidfeo-backlight-ld9040-amoled-driver-support.patch
drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files.patch
drivers-leds-leds-lp5523c-world-writable-engine-sysfs-files.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
net-convert-%p-usage-to-%pk.patch
backlight-add-backlight-type.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
i915-add-native-backlight-control.patch
radeon-expose-backlight-class-device-for-legacy-lvds-encoder.patch
radeon-expose-backlight-class-device-for-legacy-lvds-encoder-update.patch
nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev.patch
acpi-tie-acpi-backlight-devices-to-pci-devices-if-possible.patch
mbp_nvidia_bl-remove-dmi-dependency.patch
mbp_nvidia_bl-check-that-the-backlight-control-functions.patch
mbp_nvidia_bl-rename-to-apple_bl.patch
backlight-apple_bl-depends-on-acpi.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch
pwm_backlight-add-check_fb-hook.patch
btusb-patch-add_apple_macbookpro62.patch
drivers-message-fusion-mptsasc-fix-warning.patch
scsi-fix-a-header-to-include-linux-typesh.patch
aic94xx-world-writable-sysfs-update_bios-file.patch
drbd-fix-warning.patch
usb-yurex-recognize-generalkeys-wireless-presenter-as-generic-hid.patch
mm.patch
mm-vmap-area-cache.patch
mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-notifier_from_errno-cleanup.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-add-replace_page_cache_page-function.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
mm-debug-pagealloc-fix-kconfig-dependency-warning.patch
mm-rename-drop_anon_vma-to-put_anon_vma.patch
mm-move-anon_vma-ref-out-from-under-config_foo.patch
mm-simplify-anon_vma-refcounts.patch
mm-remove-unused-testsetpagelocked-interface.patch
mm-mm_struct-remove-16-bytes-of-alignment-padding-on-64-bit-builds.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mempolicy-remove-redundant-check-in-__mpol_equal.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages.patch
mm-remove-worrying-dead-code-from-find_get_pages.patch
mm-dont-return-0-too-early-from-find_get_pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-free-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-__gfp_other_node-flag.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch
sys_swapon-remove-changelog-from-function-comment.patch
sys_swapon-do-not-depend-on-type-after-allocation.patch
sys_swapon-separate-swap_info-allocation.patch
sys_swapon-simplify-error-return-from-swap_info-allocation.patch
sys_swapon-simplify-error-flow-in-alloc_swap_info.patch
sys_swapon-remove-initial-value-of-name-variable.patch
sys_swapon-move-setting-of-error-nearer-use.patch
sys_swapon-remove-did_down-variable.patch
sys_swapon-remove-bdev-variable.patch
sys_swapon-do-only-cleanup-in-the-cleanup-blocks.patch
sys_swapon-use-a-single-error-label.patch
sys_swapon-separate-bdev-claim-and-inode-lock.patch
sys_swapon-simplify-error-flow-in-claim_swapfile.patch
sys_swapon-move-setting-of-swapfilepages-near-use.patch
sys_swapon-separate-parsing-of-swapfile-header.patch
sys_swapon-simplify-error-flow-in-read_swap_header.patch
sys_swapon-call-swap_cgroup_swapon-earlier.patch
sys_swapon-separate-parsing-of-bad-blocks-and-extents.patch
sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents.patch
sys_swapon-remove-nr_good_pages-variable.patch
sys_swapon-move-printk-outside-lock.patch
sys_swapoff-change-order-to-match-sys_swapon.patch
sys_swapon-separate-final-enabling-of-the-swapfile.patch
mm-remove-inline-from-scan_swap_map.patch
memsw-remove-noswapaccount-kernel-parameter.patch
writeback-make-mapping-writeback_index-to-point-to-the-last-written-page.patch
vmalloc-remove-confusing-comment-on-vwrite.patch
mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination.patch
mm-memblock-properly-handle-overlaps-and-fix-error-path.patch
shmem-let-shared-anonymous-be-nonlinear-again.patch
mm-simplify-code-of-swapc.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
xattrh-expose-string-defines-to-userspace.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
uml-kernels-on-i386x86_64-produce-bad-coredumps.patch
um-remove-file-pointer-from-ioctl.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
fs-use-appropriate-printk-priority-level.patch
include-linux-compiler-gcch-unify-macro-definitions.patch
fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds.patch
bh1780gli-convert-to-dev-pm-ops.patch
bh1780gli-convert-to-dev-pm-ops-update.patch
drivers-misc-bmp085c-free-initmem-memory.patch
st-spear-pcie-gadget-suppport.patch
st-spear-pcie-gadget-documentation-for-support-of-multiple-device.patch
drivers-misc-apds9802alsc-put-the-device-into-runtime-suspend-after-resume-probe-is-handled.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
drivers-misc-atmel_tclibc-fix-a-memory-leak.patch
drivers-misc-ep93xx_pwmc-world-writable-sysfs-files.patch
drivers-misc-pch_phubc-add-module_device_table.patch
move-x86-specific-oops=panic-to-generic-code.patch
include-linux-errh-add-a-function-to-cast-error-pointers-to-a-return-value.patch
smp-move-smp-setup-functions-to-kernel-smpc.patch
kernel-cpuc-fix-many-errors-related-to-style.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
sys_unshare-remove-the-dead-clone_thread-sighand-vm-code.patch
calibrate-extract-fall-back-calculation-into-own-helper.patch
calibrate-home-in-on-correct-lpj-value-more-quickly.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
kernel-watchdogc-always-return-notify_ok-during-cpu-up-down-events.patch
drivers-dca-dca-corec-use-list_move-instead-of-list_del-list_add-combination.patch
vsprintf-neaten-%pk-kptr_restrict-save-a-bit-of-code-space.patch
console-allow-to-retain-boot-console-via-boot-option-keep_bootcon.patch
console-prevent-registered-consoles-from-dumping-old-kernel-message-over-again.patch
printk-use-%pk-for-proc-kallsyms-and-proc-modules.patch
printk-allow-setting-default_message_level-via-kconfig.patch
get_maintainerpl-allow-k-pattern-tests-to-match-non-patch-text.patch
maintainers-add-topgit-for-t.patch
maintainers-quote-non-alphanumeric-email-addresses.patch
maintainers-update-adp5520-pattern.patch
maintainers-change-web-links-from-wiki-analog-to-wikianalog.patch
maintainers-remove-asoc-codec-drivers-files-not-in-tree.patch
maintainers-add-missing-after-hr-timers-f-tag.patch
maintainers-remove-unnecessary-linux-kernel-vgerkernelorg-entries.patch
maintainers-update-clkdev-location.patch
maintainers-update-media-path.patch
maintainers-remove-ieee1394-entry.patch
maintainers-remove-unused-timekeeping-timekeepingh.patch
maintainers-update-scx200-file-pattern.patch
maintainers-remove-sharp-lh7a40x-section.patch
maintainers-update-sfi-pattern.patch
maintainers-usb-se401-moved-to-staging-update-pattern.patch
maintainers-update-winbond-cir-pattern.patch
maintainers-add-drivers-platform-msm-to-msm-subsystem.patch
kstrto-converting-strings-to-integers-done-hopefully-right.patch
sigma-firmware-loader-for-analog-devices-sigmastudio.patch
sigma-firmware-loader-for-analog-devices-sigmastudio-v2.patch
drivers-mmc-host-omapc-use-resource_size.patch
drivers-mmc-host-omap_hsmmcc-use-resource_size.patch
scripts-checkpatchpl-reset-rpt_cleaners-warnings.patch
checkpatch-warn-about-memset-with-swapped-arguments.patch
crc32-add-missed-brackets-in-macro.patch
epoll-move-ready-event-check-into-proper-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
listh-add-debug-version-of-list_empty.patch
init-return-proper-error-code-in-do_mounts_rd.patch
rtc-add-support-for-the-rtc-in-via-vt8500-and-compatibles.patch
rtc-convert-ds1374-to-dev_pm_ops.patch
rtc-isl1208-add-alarm-support.patch
rtc-driver-for-pt7c4338-chip.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-ds1511c-world-writable-sysfs-nvram-file.patch
rtc-add-real-time-clock-driver-for-nvidia-tegra.patch
gpio-add-new-altera-pio-driver.patch
gpio-add-new-altera-pio-driver-update.patch
gpio-make-gpio_requestfree_array-gpio-array-parameter-const.patch
pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-floppy-driver-if-config_isa_dma_api-is-enabled.patch
x86-allow-config_isa_dma_api-to-be-disabled.patch
jbd-remove-dependency-on-__gfp_nofail.patch
fs-coda-fix-compile-warning-when-config_sysctl=n.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-codingstyle-flesh-out-if-else-examples.patch
documentation-changes-minor-corrections.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
cgroup-remove-the-ns_cgroup.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-keep-only-one-charge-cancelling-function-fix.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch
memcg-page_cgroup-array-is-never-stored-on-reserved-pages.patch
memcg-fix-leak-on-wrong-lru-with-fuse.patch
memcg-give-current-access-to-memory-reserves-if-its-trying-to-die.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch
proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch
proc-document-why-writing-to-proc-pid-mem-is-a-security-hazard.patch
procfs-fix-proc-pid-maps-heap-check.patch
procfs-fix-some-wrong-error-code-usage.patch
proc-make-struct-proc_dir_entry-namelen-unsigned-int.patch
proc-protect-mm-start_code-end_code-in-proc-pid-stat.patch
char-ipmi-fix-cleanup_one_si-section-mismatch.patch
drivers-char-add-msm-smd_pkt-driver.patch
drivers-char-bfin_jtag_commc-avoid-calling-put_tty_driver-on-null.patch
drivers-char-specialixc-convert-func_enter-to-func_exit.patch
drivers-char-memc-clean-up-the-code.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-sysfs-attributes-v2.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch
rapidio-add-architecture-specific-callbacks.patch
rapidio-modify-configuration-to-support-pci-srio-controller.patch
rapidio-modify-configuration-to-support-pci-srio-controller-fix-configuration-option.patch
rapidio-modify-subsystem-and-driver-initialization-sequence.patch
rapidio-modify-mport-id-assignment.patch
rapidio-remove-mport-resource-reservation-from-common-rio-code.patch
rapidio-fix-potential-null-deref-on-failure-path.patch
sysctl_check-drop-table-procname-checks.patch
sysctl_check-drop-dead-code.patch
sysctl-add-proc_dointvec_bool-handler.patch
sysctl-use-proc_dointvec_bool-where-appropriate.patch
sysctl-add-proc_dointvec_unsigned-handler.patch
sysctl-use-proc_dointvec_unsigned-where-appropriate.patch
sysctl-add-some-missing-input-constraint-checks.patch
sysctl-restrict-write-access-to-dmesg_restrict.patch
pid-remove-the-child_reaper-special-case-in-init-mainc.patch
pidns-call-pid_ns_prepare_proc-from-create_pid_namespace.patch
procfs-kill-the-global-proc_mnt-variable.patch
userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-remove-unneeded-extra-argument-in-selinuxs-task_has_capability.patch
userns-allow-sethostname-in-a-container.patch
userns-allow-killing-tasks-in-your-own-or-child-userns.patch
userns-allow-ptrace-from-non-init-user-namespaces.patch
userns-make-has_capability-into-real-functions.patch
userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch
userns-add-a-user-namespace-owner-of-ipc-ns.patch
userns-add-a-user-namespace-owner-of-ipc-ns-dont-define-init_user_ns-in-ipc_namespaceh.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch
taskstats-use-appropriate-printk-priority-level.patch
remove-dma64_addr_t.patch
adfs-fix-e-f-dir-size-2048-crashing-kernel.patch
adfs-improve-timestamp-precision.patch
adfs-add-hexadecimal-filetype-suffix-option.patch
pps-remove-unreachable-code.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-support-for-legacy-memorysticks-update-2.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
kexec-remove-kmsg_dump_kexec.patch
aio-wake-all-waiters-when-destroying-ctx.patch
fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new.patch
zlib-slim-down-zlib_deflate-workspace-when-possible.patch
bloat-o-meter-include-read-only-data-section-in-report.patch
kvm-stop-including-asm-generic-bitops-leh-directly.patch
rds-stop-including-asm-generic-bitops-leh-directly.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
asm-generic-rename-generic-little-endian-bitops-functions.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types-convert-little-endian-bitops-macros-to-static-inline-functions.patch
powerpc-introduce-little-endian-bitops.patch
powerpc-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
s390-introduce-little-endian-bitops.patch
s390-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
arm-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
m68k-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
bitops-introduce-config_generic_find_bit_le.patch
m68knommu-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
asm-generic-use-little-endian-bitops.patch
kvm-use-little-endian-bitops.patch
rds-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bitops.patch
dm-use-little-endian-bitops.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch
make-sure-nobodys-leaking-resources.patch
journal_add_journal_head-debug.patch
releasing-resources-with-children.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
add-debugging-aid-for-memory-initialisation-problems.patch
workaround-for-a-pci-restoring-bug.patch
prio_tree-debugging-patch.patch
single_open-seq_release-leak-diagnostics.patch
add-a-refcount-check-in-dput.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

