From: akpm@linux-foundation.org
Subject: + revert-retrieve-vbe-edid-ddc-info-independent-of-used-video.patch added to -mm tree
Date: Sun, 08 Jul 2007 12:00:38 -0700
Message-ID: <200707081900.l68J0cvp016794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694AbXGHTBV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 15:01:21 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l68J0hdN003909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 8 Jul 2007 12:00:44 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     revert retrieve-vbe-edid-ddc-info-independent-of-used-video
has been added to the -mm tree.  Its filename is
     revert-retrieve-vbe-edid-ddc-info-independent-of-used-video.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert retrieve-vbe-edid-ddc-info-independent-of-used-video
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/video.S |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff -puN arch/i386/boot/video.S~revert-retrieve-vbe-edid-ddc-info-independent-of-used-video arch/i386/boot/video.S
--- a/arch/i386/boot/video.S~revert-retrieve-vbe-edid-ddc-info-independent-of-used-video
+++ a/arch/i386/boot/video.S
@@ -96,7 +96,6 @@
 #define PARAM_LFB_PAGES		0x32
 #define PARAM_VESA_ATTRIB	0x34
 #define PARAM_CAPABILITIES	0x36
-#define PARAM_EDID_INFO		0x140
 
 /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
 #ifdef CONFIG_VIDEO_RETAIN
@@ -133,8 +132,8 @@ vid1:
 #ifdef CONFIG_VIDEO_RETAIN
 	call	restore_screen			# Restore screen contents
 #endif /* CONFIG_VIDEO_RETAIN */
-#endif /* CONFIG_VIDEO_SELECT */
 	call	store_edid
+#endif /* CONFIG_VIDEO_SELECT */
 	call	mode_params			# Store mode parameters
 	popw	%ds				# Restore original DS
 	ret
@@ -572,12 +571,16 @@ setr1:	lodsw
 	jmp	_m_s
 
 check_vesa:
+#ifdef CONFIG_FIRMWARE_EDID
 	leaw	modelist+1024, %di
 	movw	$0x4f00, %ax
 	int	$0x10
 	cmpw	$0x004f, %ax
 	jnz	setbad
 
+	movw	4(%di), %ax
+	movw	%ax, vbe_version
+#endif
 	leaw	modelist+1024, %di
 	subb	$VIDEO_FIRST_VESA>>8, %bh
 	movw	%bx, %cx			# Get mode information structure
@@ -1932,7 +1935,6 @@ skip10:	movb	%ah, %al
 	popw	%cx
 	popw	%ax
 	ret
-#endif /* CONFIG_VIDEO_SELECT */
 
 store_edid:
 #ifdef CONFIG_FIRMWARE_EDID
@@ -1943,28 +1945,18 @@ store_edid:
 	pushw	%dx
 	pushw   %di
 
-	pushw	%ds
-	popw    %es
-	leaw	modelist, %di
-	movw	$0x4f00, %ax
-	int	$0x10
-	cmpw	$0x004f, %ax
-	setne	%dl
-	cmpw	$0x0200, 4(%di)			# only do EDID on >= VBE2.0
-	adc	%dl, %dl
-
 	pushw	%fs
 	popw    %es
 
 	movl	$0x13131313, %eax		# memset block with 0x13
 	movw    $32, %cx
-	movw	$PARAM_EDID_INFO, %di
+	movw	$0x140, %di
 	cld
 	rep
 	stosl
 
-	testb	%dl, %dl
-	jnz	no_edid
+	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
+	jl	no_edid
 
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
@@ -1986,7 +1978,7 @@ store_edid:
 	movw	$0x01, %bx
 	movw	$0x00, %cx
 	movw    $0x00, %dx
-	movw	$PARAM_EDID_INFO, %di
+	movw	$0x140, %di
 	int	$0x10
 
 no_edid:
@@ -1999,7 +1991,6 @@ no_edid:
 #endif
 	ret
 
-#ifdef CONFIG_VIDEO_SELECT
 # VIDEO_SELECT-only variables
 mt_end:		.word	0	# End of video mode table if built
 edit_buf:	.space	6	# Line editor buffer
@@ -2009,6 +2000,7 @@ do_restore:	.byte	0	# Screen contents al
 svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
 graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
 dac_size:	.byte	6	# DAC bit depth
+vbe_version:	.word	0	# VBE bios version
 
 # Status messages
 keymsg:		.ascii	"Press <RETURN> to see video modes available, "
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
bugfix-cpufreq-in-combination-with-performance-governor-fix.patch
8xx-mpc885ads-pcmcia-support.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
revert-saa7134-fix-thread-shutdown-handling.patch
git-dvb.patch
applesmc-add-temperature-sensors-set-for-macbook-fix.patch
git-gfs2-nmw.patch
git-infiniband.patch
git-input.patch
serio_raw_read-warning-fix.patch
tsdev-fix-broken-usecto-millisecs-conversion.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-leds.patch
led_colour_show-warning-fix.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-md-accel.patch
git-mips-fixup.patch
git-mtd.patch
mtd-onenand-build-fix.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-fixup.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-battery-vs-git-acpi.patch
git-ioat-vs-git-md-accel.patch
pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used-fix-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
fix-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
pci-x-pci-express-read-control-interfaces-fix.patch
revert-acpi-change-for-scsi.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
restore-acpi-change-for-scsi.patch
git-scsi-misc-vs-greg-sysfs-stuff.patch
aacraid-rename-check_reset.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-scsi-target-fixup.patch
splicec-revert-git-selinux-changes-so-that-git-block-will-apply.patch
git-block-fixup.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
mmconfig-validate-against-acpi-motherboard-resources-fix.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-3.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2-3.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-trim-memory-not-covered-by-wb-mtrrs-fix.patch
i386-show-unhandled-signals-fix.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh-fix.patch
i386-add-cpu_relax-to-cmos_lock-fix.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
x86_64-add-ioapic-nmi-support-fix.patch
x86_64-add-ioapic-nmi-support-fix-2.patch
highres-improve-debug-output-fix.patch
ntp-move-the-cmos-update-code-into-ntpc-fix.patch
ntp-move-the-cmos-update-code-into-ntpc-fix-fix.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early-fix.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
revert-retrieve-vbe-edid-ddc-info-independent-of-used-video.patch
git-newsetup-fixup.patch
git-xfs.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-kgdb-fixup.patch
kgdb-warning-fix.patch
kgdb-kconfig-fix.patch
kgdb-use-new-style-interrupt-flags.patch
kgdb-section-fix.patch
kgdb_skipexception-warning-fix.patch
kgdb-ia64-fixes.patch
kgdb-bust-on-ia64.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
create-the-zone_movable-zone-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-3.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
fix-alpha-isa-support-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each-fix.patch
ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
taskstats-add-context-switch-counters-fix.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
audit-add-tty-input-auditing-fix-2.patch
revert-vanishing-ioctl-handler-debugging.patch
binfmt_elf-warning-fix.patch
dirty_writeback_centisecs_handler-cleanup.patch
diskquota-32bit-quota-tools-on-64bit-architectures-fix-fix.patch
sys_time-speedup-build-fixes.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
hfs-refactor-ascii-to-unicode-conversion-routine-fix.patch
sprint_symbol-cleanup.patch
replace-obscure-constructs-in-fs-block_devc-fix.patch
bd_claim_by_disk-fix-warning.patch
uninline-check_signature.patch
uninline-check_signature-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
spi-master-driver-for-xilinx-virtex-fix.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
rtc-add-rtc-m41t80-driver-take-2-fix.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch
rtc-driver-for-ds1216-chips-fix.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
lguest-the-host-code.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code-fix.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-iommu-floppy-workaround-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
cfs-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockdep-various-fixes-checkpatch.patch
lockstat-measure-lock-bouncing-checkpatch.patch
reiser4.patch
reiser4-fix.patch
git-block-vs-reiser4.patch
allow-page_owner-to-be-set-on-any-architecture-fix.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
revert-retrieve-vbe-edid-ddc-info-independent-of-used-video.patch
