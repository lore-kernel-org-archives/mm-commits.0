From: akpm@linux-foundation.org
Subject: + sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch added to -mm tree
Date: Tue, 08 Apr 2008 00:12:44 -0700
Message-ID: <200804080712.m387CibH013706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbYDHHNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 03:13:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dbn.lists@gmail.com, jeff@garzik.org


The patch titled
     sundance-set-carrier-status-on-link-change-events-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch

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

origin.patch
es1968-fix-sleep-while-holding-lock-bug-checkpatch-fixes.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
git-x86.patch
git-x86-fix-printk-warning.patch
i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
git-kgdb-light.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
es1968-fix-jitter-on-some-maestro-cards-checkpatch-fixes.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
git-powerpc.patch
fix-gregkh-driver-kobject-replace-list_for_each-with-list_for_each_entry.patch
pm-remove-destroy_suspended_device.patch
scsi-add-iscsi-ibft-support.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch
arch-ia64-kernel-use-time_-macros.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
maple-add-driver-for-sega-dreamcast-controller.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch
git-leds.patch
git-libata-all.patch
drivers-ata-sata_fslc-fix-warnings-small-memory-leak.patch
git-async-tx.patch
git-mips.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fixup.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-git-rejects.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch
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
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
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
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
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
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
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
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

