From: akpm@linux-foundation.org
Subject: + sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:30:15 -0700
Message-ID: <200710250430.l9P4UFxW031890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41439 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233AbXJYEac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:30:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeff@garzik.org, jgarzik@redhat.com


The patch titled
     sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need a space before the open parenthesis '('
#35: FILE: sound/oss/pss.c:678:
+	else if(check_region(pss_cdrom_port, 2)) {

ERROR: else should follow close brace '}'
#35: FILE: sound/oss/pss.c:678:
 	}
+	else if(check_region(pss_cdrom_port, 2)) {

WARNING: braces {} are not necessary for single statement blocks
#35: FILE: sound/oss/pss.c:678:
+	else if(check_region(pss_cdrom_port, 2)) {
 		printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
 	}

ERROR: else should follow close brace '}'
#44: FILE: sound/oss/pss.c:681:
 	}
+	else {

total: 3 errors, 1 warnings, 56 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/pss.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN sound/oss/pss.c~sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes sound/oss/pss.c
--- a/sound/oss/pss.c~sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes
+++ a/sound/oss/pss.c
@@ -671,14 +671,11 @@ static void configure_nonsound_component
 
 	/* Configure CDROM port */
 
-	if(pss_cdrom_port == -1)	/* If cdrom port enablation wasn't requested */
-	{
+	if (pss_cdrom_port == -1) {	/* If cdrom port enablation wasn't requested */
 		printk(KERN_INFO "PSS: CDROM port not enabled.\n");
-	}
-	else if(check_region(pss_cdrom_port, 2)) {
+	} else if (check_region(pss_cdrom_port, 2)) {
 		printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
-	}
-	else {
+	} else {
 		set_io_base(devc, CONF_CDROM, pss_cdrom_port);
 		printk(KERN_INFO "PSS: CDROM I/O port set to 0x%x.\n", pss_cdrom_port);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sunrpc-fix-rpc-debugging-checkpatch-fixes.patch
acpi-add-reboot-mechanism.patch
provide-acpi_check_mem_region-checkpatch-fixes.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ata-ahci-enable-enclosure-management-via-led-checkpatch-fixes.patch
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
