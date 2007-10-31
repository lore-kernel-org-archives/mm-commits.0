From: akpm@linux-foundation.org
Subject: - watchdog-add-nano-7240-driver-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 31 Oct 2007 14:44:53 -0700
Message-ID: <200710312144.l9VLirwD030304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbXJaVpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 17:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gilles.gigan@gmail.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog-add-nano-7240-driver-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     watchdog-add-nano-7240-driver-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: watchdog-add-nano-7240-driver-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#89: FILE: drivers/char/watchdog/sbc7240_wdt.c:66:
+^I^Iprintk(KERN_INFO SBC7240_PREFIX $

ERROR: trailing whitespace
#99: FILE: drivers/char/watchdog/sbc7240_wdt.c:76:
+^I^Iprintk(KERN_INFO SBC7240_PREFIX $

ERROR: trailing whitespace
#107: FILE: drivers/char/watchdog/sbc7240_wdt.c:84:
+^I^Iprintk(KERN_ERR SBC7240_PREFIX $

ERROR: need consistent spacing around '|' (ctx:WxV)
#171: FILE: drivers/char/watchdog/sbc7240_wdt.c:148:
+	.options = WDIOF_KEEPALIVEPING |WDIOF_SETTIMEOUT |
 	                               ^

WARNING: line over 80 characters
#271: FILE: drivers/char/watchdog/sbc7240_wdt.c:248:
+		printk(KERN_ERR SBC7240_PREFIX "I/O address 0x%04x already in use\n",

total: 4 errors, 1 warnings, 329 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Gilles Gigan <gilles.gigan@gmail.com>
Cc: Gilles Gigan<gilles.gigan@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/watchdog/sbc7240_wdt.c |   11 ++++++-----
 watchdog/Makefile                   |    0 
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/char/watchdog/sbc7240_wdt.c~watchdog-add-nano-7240-driver-checkpatch-fixes drivers/char/watchdog/sbc7240_wdt.c
--- a/drivers/char/watchdog/sbc7240_wdt.c~watchdog-add-nano-7240-driver-checkpatch-fixes
+++ a/drivers/char/watchdog/sbc7240_wdt.c
@@ -63,7 +63,7 @@ static void wdt_disable(void)
 	/* disable the watchdog */
 	if (test_and_clear_bit(ENABLED_STATUS_BIT, &wdt_status)) {
 		inb_p(SBC7240_DISABLE_PORT);
-		printk(KERN_INFO SBC7240_PREFIX 
+		printk(KERN_INFO SBC7240_PREFIX
 		       "Watchdog timer is now disabled.\n");
 	}
 }
@@ -73,7 +73,7 @@ static void wdt_enable(void)
 	/* enable the watchdog */
 	if (!test_and_set_bit(ENABLED_STATUS_BIT, &wdt_status)) {
 		inb_p(SBC7240_ENABLE_PORT);
-		printk(KERN_INFO SBC7240_PREFIX 
+		printk(KERN_INFO SBC7240_PREFIX
 		       "Watchdog timer is now enabled.\n");
 	}
 }
@@ -81,7 +81,7 @@ static void wdt_enable(void)
 static int wdt_set_timeout(int t)
 {
 	if (t < 1 || t > SBC7240_MAX_TIMEOUT) {
-		printk(KERN_ERR SBC7240_PREFIX 
+		printk(KERN_ERR SBC7240_PREFIX
 		       "timeout value must be 1<=x<=%d\n",
 		       SBC7240_MAX_TIMEOUT);
 		return -1;
@@ -145,7 +145,7 @@ static int fop_close(struct inode *inode
 }
 
 static struct watchdog_info ident = {
-	.options = WDIOF_KEEPALIVEPING |WDIOF_SETTIMEOUT |
+	.options = WDIOF_KEEPALIVEPING|WDIOF_SETTIMEOUT|
 		   WDIOF_MAGICCLOSE,
 	.firmware_version = 1,
 	.identity = "SBC7240",
@@ -245,7 +245,8 @@ static int __init sbc7240_wdt_init(void)
 	int rc = -EBUSY;
 
 	if (!request_region(SBC7240_ENABLE_PORT, 1, "SBC7240 WDT")) {
-		printk(KERN_ERR SBC7240_PREFIX "I/O address 0x%04x already in use\n",
+		printk(KERN_ERR SBC7240_PREFIX "I/O address 0x%04x already in "
+				"use\n",
 		       SBC7240_ENABLE_PORT);
 		rc = -EIO;
 		goto err_out;
diff -puN drivers/watchdog/Kconfig~watchdog-add-nano-7240-driver-checkpatch-fixes drivers/watchdog/Kconfig
diff -puN drivers/watchdog/Makefile~watchdog-add-nano-7240-driver-checkpatch-fixes drivers/watchdog/Makefile
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
git-nfsd-fixup.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int-checkpatch-fixes.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-rc-fixes.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
git-unionfs.patch
git-watchdog.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes-fix.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
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
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
mn10300-suppress-aout-library-support-in-elf-binfmt-if-fix.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
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
