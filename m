From: akpm@linux-foundation.org
Subject: - mm-fix-incorrect-variable-type-in-do_try_to_free_pages.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:02 -0700
Message-ID: <200806160603.m5G632fJ010569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbYFPGDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix incorrect variable type in do_try_to_free_pages()
has been removed from the -mm tree.  Its filename was
     mm-fix-incorrect-variable-type-in-do_try_to_free_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix incorrect variable type in do_try_to_free_pages()
From: kosaki.motohiro@jp.fujitsu.com

"Smarter retry of costly-order allocations" patch series change behaver of
do_try_to_free_pages().  But unfortunately ret variable type was
unchanged.

Thus an overflow is possible.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-fix-incorrect-variable-type-in-do_try_to_free_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-incorrect-variable-type-in-do_try_to_free_pages
+++ a/mm/vmscan.c
@@ -1307,7 +1307,7 @@ static unsigned long do_try_to_free_page
 					struct scan_control *sc)
 {
 	int priority;
-	int ret = 0;
+	unsigned long ret = 0;
 	unsigned long total_scanned = 0;
 	unsigned long nr_reclaimed = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmstat-mlocked-pages-statistics.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

