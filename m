From: akpm@linux-foundation.org
Subject: - swap-cull-unevictable-pages-in-fault-path-fix.patch removed from -mm tree
Date: Mon, 28 Jul 2008 17:28:43 -0700
Message-ID: <200807290028.m6T0ShPU004255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbYG2A3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:29:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     fix lru_cache_add_active_or_unevictable
has been removed from the -mm tree.  Its filename was
     swap-cull-unevictable-pages-in-fault-path-fix.patch

This patch was dropped because it was folded into swap-cull-unevictable-pages-in-fault-path.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix lru_cache_add_active_or_unevictable
From: Rik van Riel <riel@redhat.com>

Undo an overzealous code cleanup to lru_cache_add_active_or_unevictable. 
The callers do not set PageActive so the page would get added to the wrong
list.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap.c~swap-cull-unevictable-pages-in-fault-path-fix mm/swap.c
--- a/mm/swap.c~swap-cull-unevictable-pages-in-fault-path-fix
+++ a/mm/swap.c
@@ -260,7 +260,7 @@ void lru_cache_add_active_or_unevictable
 					struct vm_area_struct *vma)
 {
 	if (page_evictable(page, vma))
-		lru_cache_add_lru(page, page_lru(page));
+		lru_cache_add_lru(page, LRU_ACTIVE + page_is_file_cache(page));
 	else
 		add_page_to_unevictable_list(page);
 }
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
ecryptfs-use-page_alloc-not-kmalloc-to-get-a-page-of-memory.patch
ntp-let-update_persistent_clock-sleep.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
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
introduce-__get_user_pages.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

