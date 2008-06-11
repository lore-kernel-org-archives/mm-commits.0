From: akpm@linux-foundation.org
Subject: + vmscan-fix-pagecache-reclaim-referenced-bit-check.patch added to -mm tree
Date: Wed, 11 Jun 2008 12:59:37 -0700
Message-ID: <200806111959.m5BJxcdd015187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754684AbYFKT76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com


The patch titled
     vmscan: fix pagecache reclaim referenced bit check
has been added to the -mm tree.  Its filename is
     vmscan-fix-pagecache-reclaim-referenced-bit-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
do not have their referenced bit set, and the next access to the page will
not get it moved back to the active list.  This patch sets the referenced
bit on pagecache pages that get deactivated, so the next access to the
page will promote it back to the active list.

This works because shrink_page_list() will reclaim unmapped pages with the
referenced bit set.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check
+++ a/mm/vmscan.c
@@ -1104,8 +1104,16 @@ static void shrink_active_list(unsigned 
 				/* Anonymous pages always get deactivated. */
 				list_add(&page->lru, &l_inactive);
 			}
-		} else
+		} else {
 			list_add(&page->lru, &l_inactive);
+			if (!page_mapping_inuse(page))
+				/*
+				 * Bypass use-once, make the next access
+				 * count. See mark_page_accessed and
+				 * shrink_page_list.
+				 */
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
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
more-aggressively-use-lumpy-reclaim.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
make-mm-rmapc-anon_vma_cachep-static.patch

