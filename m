From: akpm@linux-foundation.org
Subject: - sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 18 Apr 2008 13:47:45 -0700
Message-ID: <200804182047.m3IKlkYM014659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608AbYDRUsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Apr 2008 16:48:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbn.lists@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sundance-set-carrier-status-on-link-change-events-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch

This patch was dropped because it was folded into sundance-set-carrier-status-on-link-change-events.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sundance-set-carrier-status-on-link-change-events-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#25: FILE: drivers/net/sundance.c:412:
+static int  mdio_wait_link (struct net_device *dev, int wait);

WARNING: space prohibited between function name and open parenthesis '('
#33: FILE: drivers/net/sundance.c:789:
+static int mdio_wait_link (struct net_device *dev, int wait)

WARNING: space prohibited between function name and open parenthesis '('
#43: FILE: drivers/net/sundance.c:799:
+		bmsr = mdio_read (dev, phy_id, MII_BMSR);

WARNING: space prohibited between function name and open parenthesis '('
#46: FILE: drivers/net/sundance.c:802:
+		mdelay (1);

WARNING: space prohibited between function name and open parenthesis '('
#77: FILE: drivers/net/sundance.c:1415:
+		if (mdio_wait_link (dev, 10) == 0) {

WARNING: space prohibited between function name and open parenthesis '('
#78: FILE: drivers/net/sundance.c:1416:
+			printk (KERN_INFO "%s: Link up\n", dev->name);

WARNING: space prohibited between function name and open parenthesis '('
#80: FILE: drivers/net/sundance.c:1418:
+				mii_advertise = mdio_read (dev, np->phys[0],

WARNING: space prohibited between function name and open parenthesis '('
#82: FILE: drivers/net/sundance.c:1420:
+				mii_lpa= mdio_read (dev, np->phys[0], MII_LPA);

ERROR: spaces required around that '=' (ctx:VxW)
#82: FILE: drivers/net/sundance.c:1420:
+				mii_lpa= mdio_read (dev, np->phys[0], MII_LPA);
 				       ^

WARNING: space prohibited between function name and open parenthesis '('
#84: FILE: drivers/net/sundance.c:1422:
+				printk (KERN_INFO "%s: Link changed: ",

WARNING: space prohibited between function name and open parenthesis '('
#88: FILE: drivers/net/sundance.c:1426:
+					printk ("100Mbps, full duplex\n");

WARNING: space prohibited between function name and open parenthesis '('
#91: FILE: drivers/net/sundance.c:1429:
+					printk ("100Mbps, half duplex\n");

WARNING: space prohibited between function name and open parenthesis '('
#94: FILE: drivers/net/sundance.c:1432:
+					printk ("10Mbps, full duplex\n");

WARNING: space prohibited between function name and open parenthesis '('
#97: FILE: drivers/net/sundance.c:1435:
+					printk ("10Mbps, half duplex\n");

WARNING: space prohibited between function name and open parenthesis '('
#99: FILE: drivers/net/sundance.c:1437:
+					printk ("\n");

WARNING: line over 80 characters
#102: FILE: drivers/net/sundance.c:1440:
+				mii_ctl = mdio_read (dev, np->phys[0], MII_BMCR);

WARNING: space prohibited between function name and open parenthesis '('
#102: FILE: drivers/net/sundance.c:1440:
+				mii_ctl = mdio_read (dev, np->phys[0], MII_BMCR);

WARNING: space prohibited between function name and open parenthesis '('
#105: FILE: drivers/net/sundance.c:1443:
+				printk (KERN_INFO "%s: Link changed: %dMbps ,",

WARNING: line over 80 characters
#107: FILE: drivers/net/sundance.c:1445:
+				printk ("%s duplex.\n", (mii_ctl & BMCR_FULLDPLX) ?

WARNING: space prohibited between function name and open parenthesis '('
#107: FILE: drivers/net/sundance.c:1445:
+				printk ("%s duplex.\n", (mii_ctl & BMCR_FULLDPLX) ?

WARNING: space prohibited between function name and open parenthesis '('
#110: FILE: drivers/net/sundance.c:1448:
+			check_duplex (dev);

WARNING: line over 80 characters
#112: FILE: drivers/net/sundance.c:1450:
+				iowrite16(ioread16(ioaddr + MulticastFilter1+2) | 0x0200,

WARNING: line over 80 characters
#114: FILE: drivers/net/sundance.c:1452:
+				iowrite16(ioread16(ioaddr + MACCtrl0) | EnbFlowCtrl,

WARNING: space prohibited between function name and open parenthesis '('
#133: FILE: drivers/net/sundance.c:1457:
+			printk (KERN_INFO "%s: Link down\n", dev->name);

total: 1 errors, 23 warnings, 114 lines checked

./patches/sundance-set-carrier-status-on-link-change-events.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dan Nicholson <dbn.lists@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sundance.c |   41 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN drivers/net/sundance.c~sundance-set-carrier-status-on-link-change-events-checkpatch-fixes drivers/net/sundance.c
--- a/drivers/net/sundance.c~sundance-set-carrier-status-on-link-change-events-checkpatch-fixes
+++ a/drivers/net/sundance.c
@@ -409,7 +409,7 @@ static int  change_mtu(struct net_device
 static int  eeprom_read(void __iomem *ioaddr, int location);
 static int  mdio_read(struct net_device *dev, int phy_id, int location);
 static void mdio_write(struct net_device *dev, int phy_id, int location, int value);
-static int  mdio_wait_link (struct net_device *dev, int wait);
+static int  mdio_wait_link(struct net_device *dev, int wait);
 static int  netdev_open(struct net_device *dev);
 static void check_duplex(struct net_device *dev);
 static void netdev_timer(unsigned long data);
@@ -786,7 +786,7 @@ static void mdio_write(struct net_device
 	return;
 }
 
-static int mdio_wait_link (struct net_device *dev, int wait)
+static int mdio_wait_link(struct net_device *dev, int wait)
 {
 	int bmsr;
 	int phy_id;
@@ -796,10 +796,10 @@ static int mdio_wait_link (struct net_de
 	phy_id = np->phys[0];
 
 	do {
-		bmsr = mdio_read (dev, phy_id, MII_BMSR);
+		bmsr = mdio_read(dev, phy_id, MII_BMSR);
 		if (bmsr & 0x0004)
 			return 0;
-		mdelay (1);
+		mdelay(1);
 	} while (--wait > 0);
 	return -1;
 }
@@ -1412,40 +1412,41 @@ static void netdev_error(struct net_devi
 	int speed;
 
 	if (intr_status & LinkChange) {
-		if (mdio_wait_link (dev, 10) == 0) {
-			printk (KERN_INFO "%s: Link up\n", dev->name);
+		if (mdio_wait_link(dev, 10) == 0) {
+			printk(KERN_INFO "%s: Link up\n", dev->name);
 			if (np->an_enable) {
-				mii_advertise = mdio_read (dev, np->phys[0],
+				mii_advertise = mdio_read(dev, np->phys[0],
 							   MII_ADVERTISE);
-				mii_lpa= mdio_read (dev, np->phys[0], MII_LPA);
+				mii_lpa = mdio_read(dev, np->phys[0], MII_LPA);
 				mii_advertise &= mii_lpa;
-				printk (KERN_INFO "%s: Link changed: ",
+				printk(KERN_INFO "%s: Link changed: ",
 					dev->name);
 				if (mii_advertise & ADVERTISE_100FULL) {
 					np->speed = 100;
-					printk ("100Mbps, full duplex\n");
+					printk("100Mbps, full duplex\n");
 				} else if (mii_advertise & ADVERTISE_100HALF) {
 					np->speed = 100;
-					printk ("100Mbps, half duplex\n");
+					printk("100Mbps, half duplex\n");
 				} else if (mii_advertise & ADVERTISE_10FULL) {
 					np->speed = 10;
-					printk ("10Mbps, full duplex\n");
+					printk("10Mbps, full duplex\n");
 				} else if (mii_advertise & ADVERTISE_10HALF) {
 					np->speed = 10;
-					printk ("10Mbps, half duplex\n");
+					printk("10Mbps, half duplex\n");
 				} else
-					printk ("\n");
+					printk("\n");
 
 			} else {
-				mii_ctl = mdio_read (dev, np->phys[0], MII_BMCR);
+				mii_ctl = mdio_read(dev, np->phys[0], MII_BMCR);
 				speed = (mii_ctl & BMCR_SPEED100) ? 100 : 10;
 				np->speed = speed;
-				printk (KERN_INFO "%s: Link changed: %dMbps ,",
+				printk(KERN_INFO "%s: Link changed: %dMbps ,",
 					dev->name, speed);
-				printk ("%s duplex.\n", (mii_ctl & BMCR_FULLDPLX) ?
-					"full" : "half");
+				printk("%s duplex.\n",
+					(mii_ctl & BMCR_FULLDPLX) ?
+						"full" : "half");
 			}
-			check_duplex (dev);
+			check_duplex(dev);
 			if (np->flowctrl && np->mii_if.full_duplex) {
 				iowrite16(ioread16(ioaddr + MulticastFilter1+2) | 0x0200,
 					ioaddr + MulticastFilter1+2);
@@ -1454,7 +1455,7 @@ static void netdev_error(struct net_devi
 			}
 			netif_carrier_on(dev);
 		} else {
-			printk (KERN_INFO "%s: Link down\n", dev->name);
+			printk(KERN_INFO "%s: Link down\n", dev->name);
 			netif_carrier_off(dev);
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

disable-the-memory-controller-by-default-v3-fix.patch
hotplug-memory-make-online_page-common-fix.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86.patch
arch-x86-mm-ioremapc-fix-printk-warnings.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
arch-x86-video-fbdevc-add-module_license.patch
x86-ptrace-pebs-support-warning-fix.patch
git-kgdb-light.patch
git-x86-hack-around-to-make-git-kgdb-build.patch
git-x86-vs-git-kgdb-lite.patch
git-alsa-tiwai.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
git-arm-fix.patch
cifs-suppress-warning.patch
git-powerpc.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-drm.patch
revert-git-drm.patch
git-dvb.patch
git-dvb-kconfig-fix.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-dlm-vs-git-gfs2-nwm.patch
git-hid.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies.patch
git-ia64.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-infiniband.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-leds.patch
git-libata-all.patch
pata_atiixp-simplex-clear.patch
git-async-tx.patch
git-mips.patch
git-net.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
net-drivers-fix-platform-driver-hotplug-coldplug-sgiseeq-fix.patch
smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-s390.patch
git-sched.patch
add-rcu_assign_index-if-ever-needed.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-fix-platform-driver-hotplug-coldplug-sgiwd93-fix.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
fix-gregkh-usb-wusb-add-the-wireless-usb-stack-to-linux.patch
uwb-seems-to-need-pci.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
git-xfs-fixups.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fix-conflict.patch
git-cryptodev-fix-conflict-hack.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-git-rejects.patch
ext4-is-busted-on-m68k.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
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
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns-fix.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
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
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

