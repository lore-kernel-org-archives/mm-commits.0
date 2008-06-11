From: akpm@linux-foundation.org
Subject: - vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:15 -0700
Message-ID: <200806111946.m5BJkFNH014565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbYFKTq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: add newly swapped in pages to the inactive list
has been removed from the -mm tree.  Its filename was
     vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: add newly swapped in pages to the inactive list
From: Rik van Riel <riel@redhat.com>

Swapin_readahead can read in a lot of data that the processes in memory
never need.  Adding swap cache pages to the inactive list prevents them
from putting too much pressure on the working set.

This has the potential to help the programs that are already in memory,
but it could also be a disadvantage to processes that are trying to get
swapped in.

In short, this patch needs testing.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_state.c~vmscan-add-newly-swapped-in-pages-to-the-inactive-list mm/swap_state.c
--- a/mm/swap_state.c~vmscan-add-newly-swapped-in-pages-to-the-inactive-list
+++ a/mm/swap_state.c
@@ -310,7 +310,7 @@ struct page *read_swap_cache_async(swp_e
 			/*
 			 * Initiate read into locked page and return.
 			 */
-			lru_cache_add_active_anon(new_page);
+			lru_cache_add_anon(new_page);
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}
_

Patches currently in -mm which might be from riel@redhat.com are

ntp-let-update_persistent_clock-sleep.patch
access_process_vm-device-memory-infrastructure.patch
access_process_vm-device-memory-infrastructure-fix.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
vmscan-more-aggressively-use-lumpy-reclaim.patch
vmscan-pageflag-helpers-for-configed-out-flags.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-cull-non-reclaimable-pages-in-fault-path.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl-fix.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch
make-mm-rmapc-anon_vma_cachep-static.patch

