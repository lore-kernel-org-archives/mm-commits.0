From: akpm@linux-foundation.org
Subject: + parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch added to -mm tree
Date: Mon, 29 Oct 2007 15:14:44 -0700
Message-ID: <200710292214.l9TMEiei028492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572AbXJ2WOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 18:14:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, matthias.kaehlcke@gmail.com


The patch titled
     parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: no space between function name and open parenthesis '('
#21: FILE: drivers/char/lp.c:315:
+	if (mutex_lock_interruptible (&lp_table[minor].port_mutex))

WARNING: no space between function name and open parenthesis '('
#30: FILE: drivers/char/lp.c:402:
+	mutex_unlock (&lp_table[minor].port_mutex);

WARNING: no space between function name and open parenthesis '('
#39: FILE: drivers/char/lp.c:424:
+	if (mutex_lock_interruptible (&lp_table[minor].port_mutex))

WARNING: no space between function name and open parenthesis '('
#48: FILE: drivers/char/lp.c:482:
+	mutex_unlock (&lp_table[minor].port_mutex);

WARNING: no space between function name and open parenthesis '('
#57: FILE: drivers/char/lp.c:891:
+		mutex_init (&lp_table[i].port_mutex);

total: 0 errors, 5 warnings, 56 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/lp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/lp.c~parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes drivers/char/lp.c
--- a/drivers/char/lp.c~parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes
+++ a/drivers/char/lp.c
@@ -312,7 +312,7 @@ static ssize_t lp_write(struct file * fi
 	if (copy_size > LP_BUFFER_SIZE)
 		copy_size = LP_BUFFER_SIZE;
 
-	if (mutex_lock_interruptible (&lp_table[minor].port_mutex))
+	if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
 		return -EINTR;
 
 	if (copy_from_user (kbuf, buf, copy_size)) {
@@ -399,7 +399,7 @@ static ssize_t lp_write(struct file * fi
 		lp_release_parport (&lp_table[minor]);
 	}
 out_unlock:
-	mutex_unlock (&lp_table[minor].port_mutex);
+	mutex_unlock(&lp_table[minor].port_mutex);
 
  	return retv;
 }
@@ -421,7 +421,7 @@ static ssize_t lp_read(struct file * fil
 	if (count > LP_BUFFER_SIZE)
 		count = LP_BUFFER_SIZE;
 
-	if (mutex_lock_interruptible (&lp_table[minor].port_mutex))
+	if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
 		return -EINTR;
 
 	lp_claim_parport_or_block (&lp_table[minor]);
@@ -479,7 +479,7 @@ static ssize_t lp_read(struct file * fil
 	if (retval > 0 && copy_to_user (buf, kbuf, retval))
 		retval = -EFAULT;
 
-	mutex_unlock (&lp_table[minor].port_mutex);
+	mutex_unlock(&lp_table[minor].port_mutex);
 
 	return retval;
 }
@@ -888,7 +888,7 @@ static int __init lp_init (void)
 		lp_table[i].last_error = 0;
 		init_waitqueue_head (&lp_table[i].waitq);
 		init_waitqueue_head (&lp_table[i].dataq);
-		mutex_init (&lp_table[i].port_mutex);
+		mutex_init(&lp_table[i].port_mutex);
 		lp_table[i].timeout = 10 * HZ;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sunrpc-fix-rpc-debugging.patch
revert-ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
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
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc-vs-git-libata-all.patch
git-scsi-rc-fixes.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
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
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
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
