From: akpm@linux-foundation.org
Subject: + remove-array_size-duplicates-checkpatch-fixes.patch added to -mm tree
Date: Fri, 28 Sep 2007 15:02:17 -0700
Message-ID: <200709282202.l8SM2HGV019608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752971AbXI1WDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 18:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, 12o3l@tiscali.nl, adaplas@pol.net, ak@suse.de, davem@davemloft.net, geert@linux-m68k.org, hpa@zytor.com, jeff@garzik.org, kaber@trash.net, lenb@kernel.org, linville@tuxdriver.com, zippel@linux-m68k.org


The patch titled
     remove-array_size-duplicates-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     remove-array_size-duplicates-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove-array_size-duplicates-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/m68k/amiga/amisound.c~remove-array_size-duplicates-checkpatch-fixes arch/m68k/amiga/amisound.c
--- a/arch/m68k/amiga/amisound.c~remove-array_size-duplicates-checkpatch-fixes
+++ a/arch/m68k/amiga/amisound.c
@@ -54,7 +54,8 @@ void __init amiga_init_sound(void)
 	memcpy (snd_data, sine_data, sizeof(sine_data));
 
 	/* setup divisor */
-	clock_constant = (amiga_colorclock + ARRAY_SIZE(sine_data) /2) / ARRAY_SIZE(sine_data);
+	clock_constant = (amiga_colorclock + ARRAY_SIZE(sine_data) / 2) /
+				ARRAY_SIZE(sine_data);
 
 	/* without amifb, turn video off and enable high quality sound */
 #ifndef CONFIG_FB_AMIGA
diff -puN drivers/net/skfp/smt.c~remove-array_size-duplicates-checkpatch-fixes drivers/net/skfp/smt.c
--- a/drivers/net/skfp/smt.c~remove-array_size-duplicates-checkpatch-fixes
+++ a/drivers/net/skfp/smt.c
@@ -1879,7 +1879,7 @@ void smt_swap_para(struct smt_header *sm
 		if (plen < 0)
 			break ;
 		plen += PARA_LEN ;
-		for (i = ARRAY_SIZE(smt_pdef), pd = smt_pdef; i ; i--,pd++) {
+		for (i = ARRAY_SIZE(smt_pdef), pd = smt_pdef; i ; i--, pd++) {
 			if (pd->ptype == type)
 				break ;
 		}
diff -puN drivers/net/skfp/srf.c~remove-array_size-duplicates-checkpatch-fixes drivers/net/skfp/srf.c
--- a/drivers/net/skfp/srf.c~remove-array_size-duplicates-checkpatch-fixes
+++ a/drivers/net/skfp/srf.c
@@ -96,9 +96,8 @@ void smt_init_evc(struct s_smc *smc)
 		init++ ;
 	}
 
-	if ((unsigned) (evc - smc->evcs) > ARRAY_SIZE(smc->evcs)) {
+	if ((unsigned)(evc - smc->evcs) > ARRAY_SIZE(smc->evcs))
 		SMT_PANIC(smc,SMT_E0127, SMT_E0127_MSG) ;
-	}
 
 	/*
 	 * conditions
@@ -137,7 +136,7 @@ void smt_init_evc(struct s_smc *smc)
 		offset++ ;
 	}
 #ifdef	DEBUG
-	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
+	for (i = 0, evc = smc->evcs; i < ARRAY_SIZE(smc->evcs); i++, evc++) {
 		if (SMT_IS_CONDITION(evc->evc_code)) {
 			if (!evc->evc_cond_state) {
 				SMT_PANIC(smc,SMT_E0128, SMT_E0128_MSG) ;
@@ -161,7 +160,7 @@ static struct s_srf_evc *smt_get_evc(str
 	int			i ;
 	struct s_srf_evc	*evc ;
 
-	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
+	for (i = 0, evc = smc->evcs; i < ARRAY_SIZE(smc->evcs); i++, evc++) {
 		if (evc->evc_code == code && evc->evc_index == index)
 			return(evc) ;
 	}
@@ -335,7 +334,7 @@ static void clear_all_rep(struct s_smc *
 	struct s_srf_evc	*evc ;
 	int			i ;
 
-	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
+	for (i = 0, evc = smc->evcs; i < ARRAY_SIZE(smc->evcs); i++, evc++) {
 		evc->evc_rep_required = FALSE ;
 		if (SMT_IS_CONDITION(evc->evc_code))
 			*evc->evc_cond_state = FALSE ;
@@ -349,7 +348,7 @@ static void clear_reported(struct s_smc 
 	int			i ;
 
 	smc->srf.any_report = FALSE ;
-	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
+	for (i = 0, evc = smc->evcs; i < ARRAY_SIZE(smc->evcs); i++, evc++) {
 		if (SMT_IS_CONDITION(evc->evc_code)) {
 			if (*evc->evc_cond_state == FALSE)
 				evc->evc_rep_required = FALSE ;
@@ -403,7 +402,7 @@ static void smt_send_srf(struct s_smc *s
 	smt_add_para(smc,&pcon,(u_short) SMT_P1033,0,0) ;
 	smt_add_para(smc,&pcon,(u_short) SMT_P1034,0,0) ;
 
-	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
+	for (i = 0, evc = smc->evcs; i < ARRAY_SIZE(smc->evcs); i++, evc++) {
 		if (evc->evc_rep_required) {
 			smt_add_para(smc,&pcon,evc->evc_para,
 				(int)evc->evc_index,0) ;
diff -puN drivers/net/wireless/ipw2100.c~remove-array_size-duplicates-checkpatch-fixes drivers/net/wireless/ipw2100.c
--- a/drivers/net/wireless/ipw2100.c~remove-array_size-duplicates-checkpatch-fixes
+++ a/drivers/net/wireless/ipw2100.c
@@ -6795,9 +6795,8 @@ static int ipw2100_wx_get_range(struct n
 
 	range->num_bitrates = ARRAY_SIZE(ipw2100_rates);
 
-	for (i = 0; i < ARRAY_SIZE(ipw2100_rates) && i < IW_MAX_BITRATES; i++) {
+	for (i = 0; i < ARRAY_SIZE(ipw2100_rates) && i < IW_MAX_BITRATES; i++)
 		range->bitrate[i] = ipw2100_rates_11b[i];
-	}
 
 	range->min_rts = MIN_RTS_THRESHOLD;
 	range->max_rts = MAX_RTS_THRESHOLD;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-oops-in-platform-uevent.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
acpi-add-reboot-mechanism.patch
acpi-suppress-uninitialized-var-warning.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
git-hwmon-fixup.patch
drivers-hid-hid-debugc-add-kern_debug-prefix-fix-typo-constify-fix.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch
git-jg-misc-fix.patch
git-jg-warning-fixes.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-kvm-warning-fix.patch
git-libata-all.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-mtd-vs-powerpc.patch
git-net.patch
git-net-fixup.patch
git-net-fix-wireless-kconfig.patch
net-atm-lecc-printk-warning-fix.patch
ipgc-doesnt-compile-with-with-config_highmem64g-fix.patch
git-net-sctp-hack.patch
git-backlight.patch
git-backlight-dependency-fix.patch
revert-git-battery.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-ocfs2.patch
git-r8169-fixup.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-misc-arcmsr-build-fix.patch
advansys-printk-fix.patch
git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
revert-x86_64-mm-cpa-einval.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
x86_64-cleanup-apic-c-fix.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
asm-i386-ioh-fix-constness.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
uml-clocksource-support-fix.patch
uml-tickless-support-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
remove-array_size-duplicates-checkpatch-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
hook-up-group-scheduler-with-control-groups-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
