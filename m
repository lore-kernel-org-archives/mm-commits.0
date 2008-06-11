From: akpm@linux-foundation.org
Subject: - vmscan-fix-pagecache-reclaim-referenced-bit-check.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:13 -0700
Message-ID: <200806111946.m5BJkDl4014562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbYFKTq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:46:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: fix pagecache reclaim referenced bit check
has been removed from the -mm tree.  Its filename was
     vmscan-fix-pagecache-reclaim-referenced-bit-check.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: fix pagecache reclaim referenced bit check
From: Rik van Riel <riel@redhat.com>

The -mm tree contains the patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
which gives referenced pagecache pages another trip around the active
list.  This seems to help keep frequently accessed pagecache pages in
memory.

However, it means that pagecache pages that get moved to the inactive list
do not have their referenced bit set, and a reference to the page will not
get it moved back to the active list.  This patch sets the referenced bit
on pagecache pages that get deactivated, so the next access to the page
will promote it back to the active list.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check
+++ a/mm/vmscan.c
@@ -1088,8 +1088,13 @@ static void shrink_active_list(unsigned 
 				list_add(&page->lru, &l_inactive);
 				pgmoved++;
 			}
-		} else
+		} else {
 			list_add(&page->lru, &l_inactive);
+			if (file && !page_mapped(page))
+				/* Bypass use-once, make the next access count.
+				 * See mark_page_accessed. */
+				SetPageReferenced(page);
+		}
 	}
 
 	/*
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
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
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

