From: akpm@linux-foundation.org
Subject: + slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch added to -mm tree
Date: Tue, 30 Oct 2007 11:59:14 -0700
Message-ID: <200710301859.l9UIxEPS022544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbXJ3S7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#627: FILE: mm/slub.c:2827:
+			if (!page->inuse && (state = slab_trylock(page))) {

total: 1 errors, 0 warnings, 611 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches


Seems nicer this way.

Should the `if (page->inuse)' test be marked unlikely()?

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN mm/slub.c~slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes mm/slub.c
--- a/mm/slub.c~slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes
+++ a/mm/slub.c
@@ -1540,7 +1540,7 @@ static noinline unsigned long get_new_sl
 		if (node_match(c, node)) {
 			/*
 			 * Current cpuslab is acceptable and we
-			 * want the current one since its cache hot
+			 * want the current one since it is cache hot
 			 */
 			discard_slab(s, page);
 			return slab_lock(c->page);
@@ -2824,20 +2824,23 @@ int kmem_cache_shrink(struct kmem_cache 
 		 * list_lock. page->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			if (!page->inuse && (state = slab_trylock(page))) {
-				/*
-				 * Must hold slab lock here because slab_free
-				 * may have freed the last object and be
-				 * waiting to release the slab.
-				 */
-				list_del(&page->lru);
-				n->nr_partial--;
-				slab_unlock(page, state);
-				discard_slab(s, page);
-			} else {
+			if (page->inuse) {
 				list_move(&page->lru,
 				slabs_by_inuse + page->inuse);
+				continue;
 			}
+			state = slab_trylock(page);
+			if (!state)
+				continue;
+			/*
+			 * Must hold slab lock here because slab_free may have
+			 * freed the last object and be waiting to release the
+			 * slab.
+			 */
+			list_del(&page->lru);
+			n->nr_partial--;
+			slab_unlock(page, state);
+			discard_slab(s, page);
 		}
 
 		/*
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
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
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
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
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
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
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
