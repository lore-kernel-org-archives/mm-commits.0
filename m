From: akpm@linux-foundation.org
Subject: + vmscam-kill-unused-lru-functions.patch added to -mm tree
Date: Tue, 01 Jul 2008 17:28:28 -0700
Message-ID: <200807020028.m620SS6n022693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757196AbYGBA2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 20:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscam: kill unused lru functions
has been added to the -mm tree.  Its filename is
     vmscam-kill-unused-lru-functions.patch

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
Subject: vmscam: kill unused lru functions
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Several LRU manupuration function are not used now.  So they can be
removed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   48 ------------------------------------
 1 file changed, 48 deletions(-)

diff -puN include/linux/mm_inline.h~vmscam-kill-unused-lru-functions include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~vmscam-kill-unused-lru-functions
+++ a/include/linux/mm_inline.h
@@ -38,54 +38,6 @@ del_page_from_lru_list(struct zone *zone
 }
 
 static inline void
-add_page_to_inactive_anon_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_INACTIVE_ANON);
-}
-
-static inline void
-add_page_to_active_anon_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_ACTIVE_ANON);
-}
-
-static inline void
-add_page_to_inactive_file_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_INACTIVE_FILE);
-}
-
-static inline void
-add_page_to_active_file_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_ACTIVE_FILE);
-}
-
-static inline void
-del_page_from_inactive_anon_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_INACTIVE_ANON);
-}
-
-static inline void
-del_page_from_active_anon_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_ACTIVE_ANON);
-}
-
-static inline void
-del_page_from_inactive_file_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_INACTIVE_FILE);
-}
-
-static inline void
-del_page_from_active_file_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_INACTIVE_FILE);
-}
-
-static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
 	enum lru_list l = LRU_BASE;
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
cgroup-anotate-two-variables-with-__read_mostly.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
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
vmscam-kill-unused-lru-functions.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

