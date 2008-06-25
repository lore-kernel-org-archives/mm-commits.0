From: akpm@linux-foundation.org
Subject: + vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:59:15 -0700
Message-ID: <200806252159.m5PLxFb7028821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbYFYV7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     prevent incorrect oom under split_lru
has been added to the -mm tree.  Its filename is
     vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch

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
Subject: prevent incorrect oom under split_lru
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If zone->recent_scanned parameter become inbalanceing anon and file, OOM
killer can happened although swappable page exist.

So, if priority==0, We should try to reclaim all page for prevent OOM.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru mm/vmscan.c
--- a/mm/vmscan.c~vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru
+++ a/mm/vmscan.c
@@ -1292,8 +1292,10 @@ static unsigned long shrink_zone(int pri
 			 * kernel will slowly sift through each list.
 			 */
 			scan = zone_page_state(zone, NR_LRU_BASE + l);
-			scan >>= priority;
-			scan = (scan * percent[file]) / 100;
+			if (priority) {
+				scan >>= priority;
+				scan = (scan * percent[file]) / 100;
+			}
 			zone->lru[l].nr_scan += scan + 1;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= sc->swap_cluster_max)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

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
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

