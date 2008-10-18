From: akpm@linux-foundation.org
Subject: - mm-rewrite-vmap-layer-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 15:58:53 -0700
Message-ID: <200810182258.m9IMwrNL025959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbYJRW7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 18:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeremy@goop.org, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm-rewrite-vmap-layer-fix
has been removed from the -mm tree.  Its filename was
     mm-rewrite-vmap-layer-fix.patch

This patch was dropped because it was folded into mm-rewrite-vmap-layer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-rewrite-vmap-layer-fix
From: Andrew Morton <akpm@linux-foundation.org>

- no externs in C.

- avoid ifdefs-in-C.

- Get the vmalloc_init() declaration's section right (sometimes it matters)

Cc: Nick Piggin <npiggin@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    9 +++++++++
 init/main.c             |    6 ------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff -puN include/linux/vmalloc.h~mm-rewrite-vmap-layer-fix include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-rewrite-vmap-layer-fix
+++ a/include/linux/vmalloc.h
@@ -2,6 +2,7 @@
 #define _LINUX_VMALLOC_H
 
 #include <linux/spinlock.h>
+#include <linux/init.h>
 #include <asm/page.h>		/* pgprot_t */
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
@@ -41,6 +42,14 @@ extern void *vm_map_ram(struct page **pa
 				int node, pgprot_t prot);
 extern void vm_unmap_aliases(void);
 
+#ifdef CONFIG_MMU
+extern void __init vmalloc_init(void);
+#else
+static inline void vmalloc_init(void)
+{
+}
+#endif
+
 extern void *vmalloc(unsigned long size);
 extern void *vmalloc_user(unsigned long size);
 extern void *vmalloc_node(unsigned long size, int node);
diff -puN init/main.c~mm-rewrite-vmap-layer-fix init/main.c
--- a/init/main.c~mm-rewrite-vmap-layer-fix
+++ a/init/main.c
@@ -92,9 +92,6 @@ extern void mca_init(void);
 extern void sbus_init(void);
 extern void prio_tree_init(void);
 extern void radix_tree_init(void);
-#ifdef CONFIG_MMU
-extern void vmalloc_init(void);
-#endif
 extern void free_initmem(void);
 #ifdef	CONFIG_ACPI
 extern void acpi_early_init(void);
@@ -662,9 +659,6 @@ asmlinkage void __init start_kernel(void
 		initrd_start = 0;
 	}
 #endif
-#ifdef CONFIG_MMU
-	vmalloc_init();
-#endif
 	vfs_caches_init_early();
 	cpuset_init_early();
 	mem_init();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
revert-mm-vmallocc-revert-git-tip-change.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

