From: akpm@linux-foundation.org
Subject: + fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes.patch added to -mm tree
Date: Mon, 15 Oct 2007 15:41:21 -0700
Message-ID: <200710152241.l9FMfMrB028989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763555AbXJOWlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 18:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adaplas@gmail.com, pisa@cmp.felk.cvut.cz


The patch titled
     fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use C99 // comments
#30: FILE: drivers/video/cfbcopyarea.c:97:
+		// Different alignment for source and dest

ERROR: no space after that open parenthesis '('
#63: FILE: drivers/video/cfbcopyarea.c:124:
+			FB_WRITEL( comp(d0, FB_READL(dst), first), dst);

ERROR: no space after that open parenthesis '('
#92: FILE: drivers/video/cfbcopyarea.c:151:
+			FB_WRITEL( comp(d0, FB_READL(dst), first), dst);

WARNING: line over 80 characters
#125: FILE: drivers/video/cfbcopyarea.c:189:
+					d1 = fb_rev_pixels_in_long(d1, bswapmask);

ERROR: no space after that open parenthesis '('
#129: FILE: drivers/video/cfbcopyarea.c:193:
+				FB_WRITEL( comp(d0, FB_READL(dst), last), dst);

ERROR: no space after that open parenthesis '('
#165: FILE: drivers/video/cfbcopyarea.c:292:
+			FB_WRITEL( comp(d0, FB_READL(dst), first), dst);

ERROR: no space after that open parenthesis '('
#193: FILE: drivers/video/cfbcopyarea.c:315:
+			FB_WRITEL( comp(d0, FB_READL(dst), first), dst);

WARNING: line over 80 characters
#228: FILE: drivers/video/cfbcopyarea.c:355:
+					d1 = fb_rev_pixels_in_long(d1, bswapmask);

ERROR: no space after that open parenthesis '('
#232: FILE: drivers/video/cfbcopyarea.c:359:
+				FB_WRITEL( comp(d0, FB_READL(dst), last), dst);

ERROR: need a space before the open parenthesis '('
#256: FILE: drivers/video/fb_draw.h:88:
+	if(bswapmask & 1)

ERROR: need a space before the open parenthesis '('
#258: FILE: drivers/video/fb_draw.h:90:
+	if(bswapmask & 2)

ERROR: need a space before the open parenthesis '('
#260: FILE: drivers/video/fb_draw.h:92:
+	if(bswapmask & 3)

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cfbcopyarea.c |   20 +++++++++++---------
 drivers/video/fb_draw.h     |    6 +++---
 2 files changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/video/cfbcopyarea.c~fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes drivers/video/cfbcopyarea.c
--- a/drivers/video/cfbcopyarea.c~fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes
+++ a/drivers/video/cfbcopyarea.c
@@ -94,7 +94,7 @@ bitcpy(unsigned long __iomem *dst, int d
 				FB_WRITEL( comp( FB_READL(src), FB_READL(dst), last), dst);
 		}
 	} else {
-		// Different alignment for source and dest
+		/* Different alignment for source and dest */
 		unsigned long d0, d1;
 		int m;
 
@@ -121,7 +121,7 @@ bitcpy(unsigned long __iomem *dst, int d
 				d0 = d0<<left | d1>>right;
 			}
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
-			FB_WRITEL( comp(d0, FB_READL(dst), first), dst);
+			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
 		} else {
 			// Multiple destination words
 			/** We must always remember the last value read, because in case
@@ -148,7 +148,7 @@ bitcpy(unsigned long __iomem *dst, int d
 				n -= bits - dst_idx;
 			}
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
-			FB_WRITEL( comp(d0, FB_READL(dst), first), dst);
+			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
 			d0 = d1;
 
 			// Main chunk
@@ -186,11 +186,12 @@ bitcpy(unsigned long __iomem *dst, int d
 				} else {
 					// 2 source words
 					d1 = FB_READL(src);
-					d1 = fb_rev_pixels_in_long(d1, bswapmask);
+					d1 = fb_rev_pixels_in_long(d1,
+								bswapmask);
 					d0 = d0<<left | d1>>right;
 				}
 				d0 = fb_rev_pixels_in_long(d0, bswapmask);
-				FB_WRITEL( comp(d0, FB_READL(dst), last), dst);
+				FB_WRITEL(comp(d0, FB_READL(dst), last), dst);
 			}
 		}
 	}
@@ -289,7 +290,7 @@ bitcpy_rev(unsigned long __iomem *dst, i
 				d0 = d0>>right | d1<<left;
 			}
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
-			FB_WRITEL( comp(d0, FB_READL(dst), first), dst);
+			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
 		} else {
 			// Multiple destination words
 			/** We must always remember the last value read, because in case
@@ -312,7 +313,7 @@ bitcpy_rev(unsigned long __iomem *dst, i
 				d0 = d0>>right | d1<<left;
 			}
 			d0 = fb_rev_pixels_in_long(d0, bswapmask);
-			FB_WRITEL( comp(d0, FB_READL(dst), first), dst);
+			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
 			d0 = d1;
 			dst--;
 			n -= dst_idx+1;
@@ -352,11 +353,12 @@ bitcpy_rev(unsigned long __iomem *dst, i
 				} else {
 					// 2 source words
 					d1 = FB_READL(src);
-					d1 = fb_rev_pixels_in_long(d1, bswapmask);
+					d1 = fb_rev_pixels_in_long(d1,
+								bswapmask);
 					d0 = d0>>right | d1<<left;
 				}
 				d0 = fb_rev_pixels_in_long(d0, bswapmask);
-				FB_WRITEL( comp(d0, FB_READL(dst), last), dst);
+				FB_WRITEL(comp(d0, FB_READL(dst), last), dst);
 			}
 		}
 	}
diff -puN drivers/video/fb_draw.h~fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes drivers/video/fb_draw.h
--- a/drivers/video/fb_draw.h~fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes
+++ a/drivers/video/fb_draw.h
@@ -85,11 +85,11 @@ pixel_to_pat( u32 bpp, u32 pixel)
 static inline unsigned long fb_rev_pixels_in_long(unsigned long val,
 						  u32 bswapmask)
 {
-	if(bswapmask & 1)
+	if (bswapmask & 1)
 		val = comp(val >> 1, val << 1, REV_PIXELS_MASK1);
-	if(bswapmask & 2)
+	if (bswapmask & 2)
 		val = comp(val >> 2, val << 2, REV_PIXELS_MASK2);
-	if(bswapmask & 3)
+	if (bswapmask & 3)
 		val = comp(val >> 4, val << 4, REV_PIXELS_MASK4);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-arm-fixup.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
applesmc-for-mac-pro-2-x-quad-core-fix.patch
git-input.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-jg-warning-fixes.patch
git-jg-misc-powernow-fix.patch
git-kbuild.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ata_piix-sata-2port-controller-port-map-fix-checkpatch-fixes.patch
ide-arm-hack.patch
git-md-accel-fixup.patch
git-mips.patch
git-mips-fixup.patch
forcedeth-power-down-phy-when-interface-is-down-checkpatch-fixes.patch
git-nfs-fixup.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-nfsd-fixup.patch
git-sched.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
qla2xxx-printk-fixes.patch
git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-v9fs-fixup.patch
git-watchdog-fixup.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-ath5k-broke.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
asm-i386-ioh-fix-constness.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
git-xfs.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-sparc64-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
fs-restore-nobh-checkpatch-fixes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
writeback-dont-propagate-aop_writepage_activate.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
uml-clocksource-support-fix.patch
uml-tickless-support-fix.patch
uml-fix-stub-address-calculations-checkpatch-fixes.patch
uml-arch-um-drivers-formatting-checkpatch-fixes.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
f_dupfd_cloexec-implementation-fix-2.patch
ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
lockdep-annotate-kprobes-irq-fiddling-fix.patch
ecryptfs-printk-warning-fixes.patch
rtc-cmos-probe-cleanup-checkpatch-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
fbcon-logo-disable-logo-at-boot-fix.patch
fbdev-copyarea-function-taught-to-fully-support-swapped-pixel-order-in-byte-checkpatch-fixes.patch
md-software-raid-autodetect-dev-list-not-array.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
pnp-use-dev_info-dev_err-etc-in-core-fix.patch
pnp-add-debug-message-for-adding-new-device-fix-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch
