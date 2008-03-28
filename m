From: akpm@linux-foundation.org
Subject: - drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 28 Mar 2008 14:38:29 -0700
Message-ID: <200803282138.m2SLcTnR011724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085AbYC1VjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 17:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, caglar@pardus.org.tr, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-net-tokenring-3c359c-use-time_-macros.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required before the open parenthesis '('
#33: FILE: drivers/net/tokenring/3c359.c:412:
+		if(time_after(jiffies, t + 40 * HZ)) {

ERROR: space required before the open parenthesis '('
#42: FILE: drivers/net/tokenring/3c359.c:523:
+		if(time_after(jiffies, t + 15 * HZ)) {

ERROR: space required before the open parenthesis '('
#51: FILE: drivers/net/tokenring/3c359.c:794:
+		if(time_after(jiffies, t + 40 * HZ)) {

ERROR: space required before the open parenthesis '('
#60: FILE: drivers/net/tokenring/3c359.c:1007:
+		if(time_after(jiffies, t + 40 * HZ)) {

ERROR: space required before the open parenthesis '('
#69: FILE: drivers/net/tokenring/3c359.c:1274:
+		if(time_after(jiffies, t + 10 * HZ)) {

ERROR: space required before the open parenthesis '('
#78: FILE: drivers/net/tokenring/3c359.c:1283:
+		if(time_after(jiffies, t + 10 * HZ)) {

ERROR: space required before the open parenthesis '('
#87: FILE: drivers/net/tokenring/3c359.c:1292:
+		if(time_after(jiffies, t + 10 * HZ)) {

ERROR: space required before the open parenthesis '('
#96: FILE: drivers/net/tokenring/3c359.c:1309:
+		if(time_after(jiffies, t + 10 * HZ)) {

ERROR: space required before the open parenthesis '('
#105: FILE: drivers/net/tokenring/3c359.c:1338:
+		if(time_after(jiffies, t + 10 * HZ)) {

ERROR: space required before the open parenthesis '('
#114: FILE: drivers/net/tokenring/3c359.c:1347:
+		if(time_after(jiffies, t + 10 * HZ)) {

total: 10 errors, 0 warnings, 87 lines checked

./patches/drivers-net-tokenring-3c359c-use-time_-macros.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jeff Garzik <jeff@garzik.org>
Cc: S.Caglar Onur <caglar@pardus.org.tr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/3c359.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/net/tokenring/3c359.c~drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c~drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes
+++ a/drivers/net/tokenring/3c359.c
@@ -409,7 +409,7 @@ static int xl_hw_reset(struct net_device
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(time_after(jiffies, t + 40 * HZ)) {
+		if (time_after(jiffies, t + 40 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL  card not responding to global reset.\n", dev->name);
 			return -ENODEV;
 		}
@@ -520,7 +520,7 @@ static int xl_hw_reset(struct net_device
 	t=jiffies;
 	while ( !(readw(xl_mmio + MMIO_INTSTATUS_AUTO) & INTSTAT_SRB) ) { 
 		schedule();		
-		if(time_after(jiffies, t + 15 * HZ)) {
+		if (time_after(jiffies, t + 15 * HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			return -ENODEV; 
 		}
@@ -791,7 +791,7 @@ static int xl_open_hw(struct net_device 
 	t=jiffies;
 	while (! (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_SRB)) { 
 		schedule();		
-		if(time_after(jiffies, t + 40 * HZ)) {
+		if (time_after(jiffies, t + 40 * HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			break ; 
 		}
@@ -1004,7 +1004,7 @@ static void xl_reset(struct net_device *
 
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
-		if(time_after(jiffies, t + 40 * HZ)) {
+		if (time_after(jiffies, t + 40 * HZ)) {
 			printk(KERN_ERR "3COM 3C359 Velocity XL  card not responding.\n");
 			break ; 
 		}
@@ -1271,7 +1271,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(time_after(jiffies, t + 10 * HZ)) {
+		if (time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNSTALL not responding.\n", dev->name);
 			break ; 
 		}
@@ -1280,7 +1280,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(time_after(jiffies, t + 10 * HZ)) {
+		if (time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNDISABLE not responding.\n", dev->name);
 			break ;
 		}
@@ -1289,7 +1289,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(time_after(jiffies, t + 10 * HZ)) {
+		if (time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-UPSTALL not responding.\n", dev->name);
 			break ; 
 		}
@@ -1306,7 +1306,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (!(readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_SRB)) { 
 		schedule();		
-		if(time_after(jiffies, t + 10 * HZ)) {
+		if (time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-CLOSENIC not responding.\n", dev->name);
 			break ; 
 		}
@@ -1335,7 +1335,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(time_after(jiffies, t + 10 * HZ)) {
+		if (time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-UPRESET not responding.\n", dev->name);
 			break ; 
 		}
@@ -1344,7 +1344,7 @@ static int xl_close(struct net_device *d
 	t=jiffies;
 	while (readw(xl_mmio + MMIO_INTSTATUS) & INTSTAT_CMD_IN_PROGRESS) { 
 		schedule();		
-		if(time_after(jiffies, t + 10 * HZ)) {
+		if (time_after(jiffies, t + 10 * HZ)) {
 			printk(KERN_ERR "%s: 3COM 3C359 Velocity XL-DNRESET not responding.\n", dev->name);
 			break ; 
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-drm-drivers-char-drm-ati_pcigartc-fix-printk-warning.patch
net-9p-trans_fdc-p9_trans_fd_init-module_init-functions-should-return-0-on-success.patch
memstick-suppress-uninitialized-var-warning.patch
x86-kmap_atomic-debugging-only-run-debug_kmap_atomic_prot-for-highmem-pages.patch
alpha-get_current-dont-add-zero-to-current_thread_info-task.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
git-x86-fix-printk-warning.patch
i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
git-kgdb-light.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
pm-remove-destroy_suspended_device.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
arch-ia64-kernel-use-time_-macros.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-kvm-fixup.patch
git-kvm-vs-git-s390.patch
git-leds.patch
git-libata-fix-config_pci=n-build.patch
git-async-tx.patch
git-net.patch
net-mac80211-debugfs_netdevc-use-of-bool-triggers-a-gcc-bug.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
net-ehea-port_lock-semaphore-to-mutex-fix.patch
tulip-tulip_read_eeprom-fixes-for-bug-4420-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
git-s390-git-rejects.patch
git-sh.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
scsi-add-iscsi-ibft-support-fix.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-fixup.patch
git-xtensa.patch
git-semaphore-git-rejects.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-allocate-section_map-for-sparse_init-update-fix.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
clocksource-introduce-clock_monotonic_raw-fix-checkpatch-fixes.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch
w1-build-fix.patch

