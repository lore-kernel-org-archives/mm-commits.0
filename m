From: akpm@linux-foundation.org
Subject: - revert-x86_64-mm-less-stack-alignment.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:48:51 -0700
Message-ID: <200708242048.l7OKmpuJ013725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756377AbXHXUtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     revert x86_64-mm-less-stack-alignment
has been removed from the -mm tree.  Its filename was
     revert-x86_64-mm-less-stack-alignment.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert x86_64-mm-less-stack-alignment
From: Andrew Morton <akpm@linux-foundation.org>

> > >From elm3b6 on test.kernel.org, we get the following build error
> > 
> > 08/22/07-07:01:07 building kernel - make bzImage
> >   CHK     include/linux/version.h
> >   UPD     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   UPD     include/linux/utsrelease.h
> >   SYMLINK include/asm -> include/asm-x86_64
> >   CC      arch/x86_64/kernel/asm-offsets.s
> > arch/x86_64/kernel/asm-offsets.c:1: error: -mpreferred-stack-boundary=3
> > is not between 4 and 12
> > make[1]: *** [arch/x86_64/kernel/asm-offsets.s] Error 1
> > make: *** [prepare0] Error 2
> > 08/22/07-07:01:08 Build the kernel. Failed rc = 2
> > 08/22/07-07:01:08 build: Building kernel... Failed rc = 1
> > Failed and terminated the run
> > 08/22/07-07:01:08 command complete: (1) rc=126 (TEST ABORT)
> >  Fatal error, aborting autorun
> > 
> > config file at: http://test.kernel.org/abat/107411/build/dotconfig
> > gcc version is 3.4.4
> > 
> > This does not occur when using a cross-compiler gcc 3.4.0
> > 

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Makefile |    2 --
 1 files changed, 2 deletions(-)

diff -puN arch/x86_64/Makefile~revert-x86_64-mm-less-stack-alignment arch/x86_64/Makefile
--- a/arch/x86_64/Makefile~revert-x86_64-mm-less-stack-alignment
+++ a/arch/x86_64/Makefile
@@ -58,8 +58,6 @@ cflags-y += $(call cc-option,-mno-sse -m
 # newer gccs do it by default
 cflags-y += -maccumulate-outgoing-args
 
-cflags-y += $(call cc-option,-mpreferred-stack-boundary=3)
-
 # do binutils support CFI?
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-ecryptfs-fix-lookup-error-for-special-files.patch
process_zones-fix-recovery-code.patch
remove-bdput-from-do_open-in-fs-block_devc.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
git-dma.patch
git-dma-makefile-fix.patch
disable-ioat.patch
git-dvb.patch
git-dvb-fixup-2.patch
infiniband-work-around-gcc-slub-problem.patch
adbhid-produce-all-capslock-key-events.patch
iforce-warning-fix.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kvm.patch
git-libata-all.patch
ide-arm-hack.patch
git-mmc.patch
git-mmc-fixup.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net.patch
git-backlight.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
git-s390.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
git-wireless-printk-fixes.patch
net-add-ath5k-wireless-driver-fix.patch
revert-x86_64-mm-less-stack-alignment.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
git-xfs.patch
git-kgdb-fixup.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
alloc_pages-permit-get_zeroed_pagegfp_atomic-from-interrupt-context.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
