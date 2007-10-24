From: akpm@linux-foundation.org
Subject: + watchdog-add-nano-7240-driver-checkpatch-fixes.patch added to -mm tree
Date: Tue, 23 Oct 2007 19:32:25 -0700
Message-ID: <200710240232.l9O2WPHR018355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbXJXCcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 22:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gilles.gigan@gmail.com, wim@iguana.be


The patch titled
     watchdog-add-nano-7240-driver-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     watchdog-add-nano-7240-driver-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog-fixup.patch
documentation-watchdog-src-watchdog-simplec-improve-this-code-checkpatch-fixes.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
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
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
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
