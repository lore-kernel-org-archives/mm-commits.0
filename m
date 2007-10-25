From: akpm@linux-foundation.org
Subject: + ips-trim-trailing-whitespace-checkpatch-fixes.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:27:53 -0700
Message-ID: <200710250427.l9P4Rrda031736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979AbXJYE2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@steeleye.com, jeff@garzik.org, jgarzik@redhat.com


The patch titled
     ips-trim-trailing-whitespace-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ips-trim-trailing-whitespace-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ips-trim-trailing-whitespace-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#50: FILE: drivers/scsi/ips.c:2084:
+        if (ha->nvram->bios_low[3] == 0) {$

ERROR: use tabs not spaces
#60: FILE: drivers/scsi/ips.c:2785:
+        if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) && (scb->data_len == 0))$

ERROR: use tabs not spaces
#61: FILE: drivers/scsi/ips.c:2786:
+            scb->dcdb.cmd_attribute = 0;$

ERROR: use tabs not spaces
#116: FILE: drivers/scsi/ips.c:4723:
+^I           done = ips_poll_for_flush_complete(ha);$

ERROR: no space before that close parenthesis ')'
#135: FILE: drivers/scsi/ips.c:4760:
+	    if (cstatus.fields.command_id == IPS_MAX_CMDS )

WARNING: do not add new typedefs
#195: FILE: drivers/scsi/ips.h:555:
+typedef struct

WARNING: do not add new typedefs
#213: FILE: drivers/scsi/ips.h:793:
+typedef struct

total: 5 errors, 2 warnings, 181 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ips.c~ips-trim-trailing-whitespace-checkpatch-fixes drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~ips-trim-trailing-whitespace-checkpatch-fixes
+++ a/drivers/scsi/ips.c
@@ -2081,7 +2081,7 @@ ips_host_info(ips_ha_t * ha, char *ptr, 
     /* That keeps everything happy for "text" operations on the proc file.                    */
 
 	if (le32_to_cpu(ha->nvram->signature) == IPS_NVRAM_P5_SIG) {
-        if (ha->nvram->bios_low[3] == 0) {
+	if (ha->nvram->bios_low[3] == 0) {
             copy_info(&info,
 			          "\tBIOS Version                      : %c%c%c%c%c%c%c\n",
 			          ha->nvram->bios_high[0], ha->nvram->bios_high[1],
@@ -2780,10 +2780,11 @@ ips_next(ips_ha_t * ha, int intr)
 		scb->dcdb.cmd_attribute =
 		    ips_command_direction[scb->scsi_cmd->cmnd[0]];
 
-        /* Allow a WRITE BUFFER Command to Have no Data */
-        /* This is Used by Tape Flash Utilites          */
-        if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) && (scb->data_len == 0))
-            scb->dcdb.cmd_attribute = 0;
+	        /* Allow a WRITE BUFFER Command to Have no Data */
+		/* This is Used by Tape Flash Utilites          */
+		if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) &&
+				(scb->data_len == 0))
+			scb->dcdb.cmd_attribute = 0;
 
 		if (!(scb->dcdb.cmd_attribute & 0x3))
 			scb->dcdb.transfer_length = 0;
@@ -4720,7 +4721,7 @@ ips_flush_and_reset(ips_ha_t *ha)
 	        done = 0;
 
 	        while ((time > 0) && (!done)) {
-	           done = ips_poll_for_flush_complete(ha);
+		   done = ips_poll_for_flush_complete(ha);
 	           /* This may look evil, but it's only done during extremely rare start-up conditions ! */
 	           udelay(1000);
 	           time--;
@@ -4757,7 +4758,7 @@ ips_poll_for_flush_complete(ips_ha_t * h
 			break;
 
 	    /* Success is when we see the Flush Command ID */
-	    if (cstatus.fields.command_id == IPS_MAX_CMDS )
+	    if (cstatus.fields.command_id == IPS_MAX_CMDS)
 	        return 1;
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
