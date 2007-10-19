From: akpm@linux-foundation.org
Subject: - memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch removed from -mm tree
Date: Fri, 19 Oct 2007 16:27:14 -0700
Message-ID: <200710192327.l9JNRE8q025675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160AbXJSX1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch

This patch was dropped because it was folded into memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch

------------------------------------------------------
Subject: memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix mm/slub.c
--- a/mm/slub.c~memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix
+++ a/mm/slub.c
@@ -2749,6 +2749,7 @@ static int slab_mem_going_online_callbac
 	struct kmem_cache *s;
 	struct memory_notify *marg = arg;
 	int nid = marg->status_change_nid;
+	int ret = 0;
 
 	/*
 	 * If the node's memory is already available, then kmem_cache_node is
@@ -2770,14 +2771,16 @@ static int slab_mem_going_online_callbac
 		 *      is brought up.
 		 */
 		n = kmem_cache_alloc(kmalloc_caches, GFP_KERNEL);
-		if (!n)
-			return -ENOMEM;
+		if (!n) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		init_kmem_cache_node(n);
 		s->node[nid] = n;
 	}
+out:
 	up_read(&slub_lock);
-
-	return 0;
+	return ret;
 }
 
 static int slab_memory_callback(struct notifier_block *self,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
