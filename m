From: akpm@linux-foundation.org
Subject: + mm-introduce-page_lru_base_type-fix.patch added to -mm tree
Date: Wed, 26 Aug 2009 16:27:12 -0700
Message-ID: <200908262327.n7QNRC3v019361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbZHZX1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 19:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: introduce page_lru_base_type fix
has been added to the -mm tree.  Its filename is
     mm-introduce-page_lru_base_type-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce page_lru_base_type fix
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

My usual tmpfs swapping loads on recent mmotms have oddly aroused the OOM
killer after an hour or two.  Bisection led to
mm-return-boolean-from-page_is_file_cache.patch, but really it's the prior
mm-introduce-page_lru_base_type.patch that's at fault.

It converted page_lru() to use page_lru_base_type(), but forgot to convert
del_page_from_lru() - which then decremented the wrong stats once
page_is_file_cache() was changed to a boolean.

Fix that, move page_lru_base_type() before del_page_from_lru(), and mark
it "inline" like the other mm_inline.h functions.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN include/linux/mm_inline.h~mm-introduce-page_lru_base_type-fix include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-introduce-page_lru_base_type-fix
+++ a/include/linux/mm_inline.h
@@ -39,42 +39,42 @@ del_page_from_lru_list(struct zone *zone
 	mem_cgroup_del_lru_list(page, l);
 }
 
+/**
+ * page_lru_base_type - which LRU list type should a page be on?
+ * @page: the page to test
+ *
+ * Used for LRU list index arithmetic.
+ *
+ * Returns the base LRU type - file or anon - @page should be on.
+ */
+static inline enum lru_list page_lru_base_type(struct page *page)
+{
+	if (page_is_file_cache(page))
+		return LRU_INACTIVE_FILE;
+	return LRU_INACTIVE_ANON;
+}
+
 static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
-	enum lru_list l = LRU_BASE;
+	enum lru_list l;
 
 	list_del(&page->lru);
 	if (PageUnevictable(page)) {
 		__ClearPageUnevictable(page);
 		l = LRU_UNEVICTABLE;
 	} else {
+		l = page_lru_base_type(page);
 		if (PageActive(page)) {
 			__ClearPageActive(page);
 			l += LRU_ACTIVE;
 		}
-		l += page_is_file_cache(page);
 	}
 	__dec_zone_state(zone, NR_LRU_BASE + l);
 	mem_cgroup_del_lru_list(page, l);
 }
 
 /**
- * page_lru_base_type - which LRU list type should a page be on?
- * @page: the page to test
- *
- * Used for LRU list index arithmetic.
- *
- * Returns the base LRU type - file or anon - @page should be on.
- */
-static enum lru_list page_lru_base_type(struct page *page)
-{
-	if (page_is_file_cache(page))
-		return LRU_INACTIVE_FILE;
-	return LRU_INACTIVE_ANON;
-}
-
-/**
  * page_lru - which LRU list should a page be on?
  * @page: the page to test
  *
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
acpi-fix-null-bug-for-hid-uid-string-2.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-introduce-page_lru_base_type-fix.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

