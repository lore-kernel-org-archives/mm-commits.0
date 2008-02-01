From: akpm@linux-foundation.org
Subject: - printk-trivial-optimizations-fix.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:20 -0800
Message-ID: <200802012230.m11MUKY3001903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761515AbYBAWk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:40:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     printk trivial optimizations fix
has been removed from the -mm tree.  Its filename was
     printk-trivial-optimizations-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk trivial optimizations fix
From: Hugh Dickins <hugh@veritas.com>

mm's printk has been showing "%p" in abominable upper case recently:
its trivial optimizations have changed the default from lower to upper,
so the 'p' case needs to enforce lower explicitly.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/vsprintf.c~printk-trivial-optimizations-fix lib/vsprintf.c
--- a/lib/vsprintf.c~printk-trivial-optimizations-fix
+++ a/lib/vsprintf.c
@@ -525,6 +525,7 @@ int vsnprintf(char *buf, size_t size, co
 				continue;
 
 			case 'p':
+				flags |= SMALL;
 				if (field_width == -1) {
 					field_width = 2*sizeof(void *);
 					flags |= ZEROPAD;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
tmpfs-move-swap_state-stats-update.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-move-swap-swizzling-into-shmem.patch
tmpfs-allow-filepage-alongside-swappage.patch
tmpfs-allocate-on-read-when-stacked.patch
tmpfs-make-shmem_unuse-more-preemptible.patch
tmpfs-open-a-window-in-shmem_unuse_inode.patch
tmpfs-radix_tree_preloading.patch
tmpfs-fix-shmem_swaplist-races.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
mm-dont-waste-swap-on-locked-pages.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
prio_tree-debugging-patch.patch
