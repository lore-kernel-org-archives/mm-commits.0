From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:12:36 -0800
Message-ID: <200901301912.n0UJCaED025043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbZA3TOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, hugh@veritas.com, maksim.yevmenkin@gmail.com, nickpiggin@yahoo.com.au, riel@redhat.com, stable@kernel.org, torvalds@linux-foundation.org, mm


The patch titled
     mm/mmap.c: avoid referencing a freed vma in mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/mmap.c: avoid referencing a freed vma in mmap_region()
From: Andrew Morton <akpm@linux-foundation.org>

Fix regression which was (I _think_) added by

Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Sat Oct 18 20:26:50 2008 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Mon Oct 20 08:52:31 2008 -0700

    mmap: handle mlocked pages during map, remap, unmap

we need to reset local variable `vma' to point at the result of the merge,
because we're about to free the old VMA.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Greg KH <greg@kroah.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>
Reported-by: Maksim Yevmenkin <maksim.yevmenkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region
+++ a/mm/mmap.c
@@ -1094,6 +1094,7 @@ unsigned long mmap_region(struct file *f
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
+	struct vm_area_struct *merged_vma;
 	int correct_wcount = 0;
 	int error;
 	struct rb_node **rb_link, *rb_parent;
@@ -1206,13 +1207,17 @@ munmap_back:
 	if (vma_wants_writenotify(vma))
 		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
-	if (file && vma_merge(mm, prev, addr, vma->vm_end,
-			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
+	merged_vma = NULL;
+	if (file)
+		merged_vma = vma_merge(mm, prev, addr, vma->vm_end,
+			vma->vm_flags, NULL, file, pgoff, vma_policy(vma));
+	if (merged_vma) {
 		mpol_put(vma_policy(vma));
 		kmem_cache_free(vm_area_cachep, vma);
 		fput(file);
 		if (vm_flags & VM_EXECUTABLE)
 			removed_exe_file_vma(mm);
+		vma = merged_vma;
 	} else {
 		vma_link(mm, vma, prev, rb_link, rb_parent);
 		file = vma->vm_file;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch
drivers-ata-sata_silc-needs-dmih.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

