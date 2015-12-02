From: akpm@linux-foundation.org
Subject: + thp-introduce-deferred_split_huge_page-fix.patch added to -mm
 tree
Date: Tue, 01 Dec 2015 16:10:31 -0800
Message-ID: <565e36f7.zO6wbEAthW/4X8bX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbbLBAKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 19:10:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix split_huge_page vs. deferred_split_scan race
has been added to the -mm tree.  Its filename is
     thp-introduce-deferred_split_huge_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-introduce-deferred_split_huge_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-introduce-deferred_split_huge_page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix split_huge_page vs. deferred_split_scan race

Minchan[1] and Sasha[2] had reported crash in split_huge_page_to_list()
called from deferred_split_scan() due VM_BUG_ON_PAGE(!PageLocked(page)).

This can happen because race between deferred_split_scan() and
split_huge_page(). The result of the race is that the page can be split
under deferred_split_scan().

The patch prevents this by taking split_queue_lock in
split_huge_page_to_list() when we check if the page can be split.
If the page is suitable for splitting, we remove page from splitting
queue under the same lock, before splitting starts.

[1] http://lkml.kernel.org/g/20151117073539.GB32578@bbox
[2] http://lkml.kernel.org/g/565C5F2D.5060003@oracle.com

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Tested-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN mm/huge_memory.c~thp-introduce-deferred_split_huge_page-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-introduce-deferred_split_huge_page-fix
+++ a/mm/huge_memory.c
@@ -3217,13 +3217,6 @@ static void __split_huge_page(struct pag
 	spin_lock_irq(&zone->lru_lock);
 	lruvec = mem_cgroup_page_lruvec(head, zone);
 
-	spin_lock(&split_queue_lock);
-	if (!list_empty(page_deferred_list(head))) {
-		split_queue_len--;
-		list_del(page_deferred_list(head));
-	}
-	spin_unlock(&split_queue_lock);
-
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
 
@@ -3311,12 +3304,20 @@ int split_huge_page_to_list(struct page
 	freeze_page(anon_vma, head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
+	/* Prevent deferred_split_scan() touching ->_count */
+	spin_lock(&split_queue_lock);
 	count = page_count(head);
 	mapcount = total_mapcount(head);
 	if (mapcount == count - 1) {
+		if (!list_empty(page_deferred_list(head))) {
+			split_queue_len--;
+			list_del(page_deferred_list(head));
+		}
+		spin_unlock(&split_queue_lock);
 		__split_huge_page(page, list);
 		ret = 0;
 	} else if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount > count - 1) {
+		spin_unlock(&split_queue_lock);
 		pr_alert("total_mapcount: %u, page_count(): %u\n",
 				mapcount, count);
 		if (PageTail(page))
@@ -3324,6 +3325,7 @@ int split_huge_page_to_list(struct page
 		dump_page(page, "total_mapcount(head) > page_count(head) - 1");
 		BUG();
 	} else {
+		spin_unlock(&split_queue_lock);
 		unfreeze_page(anon_vma, head);
 		ret = -EBUSY;
 	}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
page-flags-drop-__testclearpage-helpers.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-3.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix-3.patch
thp-reintroduce-split_huge_page-fix-4.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
thp-introduce-deferred_split_huge_page-fix.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix-fix.patch
mm-kernel-bug-at-mm-huge_memoryc-3272.patch

