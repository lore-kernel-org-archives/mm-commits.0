From: akpm@linux-foundation.org
Subject: + git-x86-fixup.patch added to -mm tree
Date: Wed, 24 Oct 2007 14:37:57 -0700
Message-ID: <200710242137.l9OLbvpZ013706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760330AbXJXViT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     git-x86-fixup
has been added to the -mm tree.  Its filename is
     git-x86-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-x86-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Fix rejects in git-x86.    Don't know what I'm doing, might be wrong.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/tsc_32.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

diff -puN arch/x86/kernel/tsc_32.c~git-x86-fixup arch/x86/kernel/tsc_32.c
--- a/arch/x86/kernel/tsc_32.c~git-x86-fixup
+++ a/arch/x86/kernel/tsc_32.c
@@ -143,8 +143,6 @@ unsigned long native_calculate_cpu_khz(v
 		rdtscll(start);
 		mach_countup(&count);
 		rdtscll(end);
-<<<<<<< HEAD:arch/x86/kernel/tsc_32.c
-=======
 		delta64 = min(delta64, (end - start));
 	}
 	/*
@@ -155,33 +153,8 @@ unsigned long native_calculate_cpu_khz(v
 	 */
 	if (count <= 1)
 		goto err;
->>>>>>> FETCH_HEAD:arch/x86/kernel/tsc_32.c
 
-<<<<<<< HEAD:arch/x86/kernel/tsc_32.c
-		/*
-		 * Error: ECTCNEVERSET
-		 * The CTC wasn't reliable: we got a hit on the very first read,
-		 * or the CPU was so fast/slow that the quotient wouldn't fit in
-		 * 32 bits..
-		 */
-		if (count <= 1)
-			continue;
-
-		/* cpu freq too slow: */
-		if ((end - start) <= CALIBRATE_TIME_MSEC)
-			continue;
-
-		/*
-		 * We want the minimum time of all runs in case one of them
-		 * is inaccurate due to SMI or other delay
-		 */
-		delta64 = min(delta64, (end - start));
-	}
-
-	/* cpu freq too fast (or every run was bad): */
-=======
 	/* cpu freq too fast: */
->>>>>>> FETCH_HEAD:arch/x86/kernel/tsc_32.c
 	if (delta64 > (1ULL<<32))
 		goto err;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
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
