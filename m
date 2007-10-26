From: akpm@linux-foundation.org
Subject: - ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:33:45 -0700
Message-ID: <200710261833.l9QIXjXc008506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763891AbXJZSeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes.patch

This patch was dropped because of rejects

------------------------------------------------------
Subject: ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#77: FILE: drivers/ata/ahci.c:536:
+MODULE_PARM_DESC(ahci_em_messages, "Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED, 2 = SAF-TE, 3 = SES-2, 4 = SGPIO)");

ERROR: need space after that ',' (ctx:VxV)
#106: FILE: drivers/ata/ahci.c:939:
+	u32 message[] = {0,0};
 	                  ^

ERROR: use tabs not spaces
#109: FILE: drivers/ata/ahci.c:942:
+ ^I * if we are still busy transmitting a previous message,$

ERROR: use tabs not spaces
#110: FILE: drivers/ata/ahci.c:943:
+ ^I * do not allow$

ERROR: use tabs not spaces
#111: FILE: drivers/ata/ahci.c:944:
+ ^I */$

ERROR: use tabs not spaces
#117: FILE: drivers/ata/ahci.c:950:
+ ^I * create message header - this is all zero except for$

ERROR: use tabs not spaces
#118: FILE: drivers/ata/ahci.c:951:
+ ^I * the message size, which is 4 bytes.$

ERROR: use tabs not spaces
#119: FILE: drivers/ata/ahci.c:952:
+ ^I */$

ERROR: use tabs not spaces
#125: FILE: drivers/ata/ahci.c:958:
+ ^I * create the actual message$

ERROR: use tabs not spaces
#126: FILE: drivers/ata/ahci.c:959:
+ ^I * XXX will need Port Multiplier support$

ERROR: use tabs not spaces
#127: FILE: drivers/ata/ahci.c:960:
+ ^I */$

ERROR: use tabs not spaces
#141: FILE: drivers/ata/ahci.c:974:
+ ^I * tell hardware to transmit the message$

ERROR: use tabs not spaces
#142: FILE: drivers/ata/ahci.c:975:
+ ^I */$

ERROR: "foo * bar" should be "foo *bar"
#295: FILE: include/linux/libata.h:883:
+struct ata_device * ata_scsi_find_dev(struct ata_port *ap,

total: 13 errors, 1 warnings, 259 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c     |   21 ++++++++++-----------
 include/linux/libata.h |    2 +-
 2 files changed, 11 insertions(+), 12 deletions(-)

diff -puN drivers/ata/ahci.c~ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes
+++ a/drivers/ata/ahci.c
@@ -936,28 +936,27 @@ static int ahci_transmit_led_message(str
 	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
 	struct ahci_port_priv *pp = ap->private_data;
 	u32 em_ctl;
-	u32 message[] = {0,0};
+	u32 message[] = {0, 0};
 
 	/*
- 	 * if we are still busy transmitting a previous message,
- 	 * do not allow
- 	 */
+	 * if we are still busy transmitting a previous message, do not allow
+	 */
 	em_ctl = readl(mmio + HOST_EM_CTL);
 	if (em_ctl & EM_CTL_TM)
 		return -EINVAL;
 
 	/*
- 	 * create message header - this is all zero except for
- 	 * the message size, which is 4 bytes.
- 	 */
+	 * create message header - this is all zero except for
+	 * the message size, which is 4 bytes.
+	 */
 	message[0] |= (4 << 8);
 
 	pp->led_state &= ~(9 << (3*led_num));
 
 	/*
- 	 * create the actual message
- 	 * XXX will need Port Multiplier support
- 	 */
+	 * create the actual message
+	 * XXX will need Port Multiplier support
+	 */
 	message[1] = (ap->port_no | (pp->led_state << 16));
 
 	/* LED bit locations are determined by the led_num */
@@ -972,7 +971,7 @@ static int ahci_transmit_led_message(str
 
 	/*
  	 * tell hardware to transmit the message
- 	 */
+	 */
 	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
 	return 0;
 }
diff -puN include/linux/libata.h~ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes include/linux/libata.h
--- a/include/linux/libata.h~ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes
+++ a/include/linux/libata.h
@@ -880,7 +880,7 @@ extern int ata_scsi_slave_config(struct 
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
-struct ata_device * ata_scsi_find_dev(struct ata_port *ap,
+struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sunrpc-fix-rpc-debugging-checkpatch-fixes.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
git-unionfs.patch
git-v9fs-fixup.patch
git-watchdog.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
i386-and-x86_64-randomize-brk-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
