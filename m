From: akpm@linux-foundation.org
Subject: - restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch removed from -mm tree
Date: Mon, 28 Jul 2008 17:30:23 -0700
Message-ID: <200807290030.m6T0UNeY004327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbYG2Aan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     vmstat-unevictable-and-mlocked-pages-vm-events: restore patch failure of vmstat-unevictable-and-mlocked-pages-vm-events.patch
has been removed from the -mm tree.  Its filename was
     restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch

This patch was dropped because it was folded into unevictable-lru-infrastructure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstat-unevictable-and-mlocked-pages-vm-events: restore patch failure of vmstat-unevictable-and-mlocked-pages-vm-events.patch
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This patch restore it properly.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch mm/vmscan.c
--- a/mm/vmscan.c~restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch
+++ a/mm/vmscan.c
@@ -483,7 +483,7 @@ int remove_mapping(struct address_space 
 void putback_lru_page(struct page *page)
 {
 	int lru;
-	int ret = 1;
+	int was_unevictable = PageUnevictable(page);
 
 	VM_BUG_ON(PageLRU(page));
 
@@ -526,6 +526,11 @@ redo:
 		 */
 	}
 
+	if (was_unevictable && lru != LRU_UNEVICTABLE)
+		count_vm_event(NORECL_PGRESCUED);
+	else if (!was_unevictable && lru == LRU_UNEVICTABLE)
+		count_vm_event(NORECL_PGCULLED);
+
 	put_page(page);		/* drop ref from isolate */
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
introduce-__get_user_pages.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

