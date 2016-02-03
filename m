From: akpm@linux-foundation.org
Subject: + thp-cleanup-split_huge_page.patch added to -mm tree
Date: Wed, 03 Feb 2016 15:02:28 -0800
Message-ID: <56b28704.SyOQFTI+VHZ9LdaL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbcBCXC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 18:02:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: cleanup split_huge_page()
has been added to the -mm tree.  Its filename is
     thp-cleanup-split_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-cleanup-split_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-cleanup-split_huge_page.patch

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
Subject: thp: cleanup split_huge_page()

After one of bugfixes to freeze_page(), we don't have freezed pages in
rmap, therefore mapcount of all subpages of freezed THP is zero.  And we
have assert for that.

Let's drop code which deal with non-zero mapcount of subpages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN mm/huge_memory.c~thp-cleanup-split_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-cleanup-split_huge_page
+++ a/mm/huge_memory.c
@@ -3217,28 +3217,26 @@ static void unfreeze_page(struct anon_vm
 	}
 }
 
-static int __split_huge_page_tail(struct page *head, int tail,
+static void __split_huge_page_tail(struct page *head, int tail,
 		struct lruvec *lruvec, struct list_head *list)
 {
-	int mapcount;
 	struct page *page_tail = head + tail;
 
-	mapcount = atomic_read(&page_tail->_mapcount) + 1;
+	VM_BUG_ON_PAGE(atomic_read(&page_tail->_mapcount) != -1, page_tail);
 	VM_BUG_ON_PAGE(atomic_read(&page_tail->_count) != 0, page_tail);
 
 	/*
 	 * tail_page->_count is zero and not changing from under us. But
 	 * get_page_unless_zero() may be running from under us on the
-	 * tail_page. If we used atomic_set() below instead of atomic_add(), we
+	 * tail_page. If we used atomic_set() below instead of atomic_inc(), we
 	 * would then run atomic_set() concurrently with
 	 * get_page_unless_zero(), and atomic_set() is implemented in C not
 	 * using locked ops. spin_unlock on x86 sometime uses locked ops
 	 * because of PPro errata 66, 92, so unless somebody can guarantee
 	 * atomic_set() here would be safe on all archs (and not only on x86),
-	 * it's safer to use atomic_add().
+	 * it's safer to use atomic_inc().
 	 */
-	atomic_add(mapcount + 1, &page_tail->_count);
-
+	atomic_inc(&page_tail->_count);
 
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
@@ -3272,8 +3270,6 @@ static int __split_huge_page_tail(struct
 	page_tail->index = head->index + tail;
 	page_cpupid_xchg_last(page_tail, page_cpupid_last(head));
 	lru_add_page_tail(head, page_tail, lruvec, list);
-
-	return mapcount;
 }
 
 static void __split_huge_page(struct page *page, struct list_head *list)
@@ -3281,7 +3277,7 @@ static void __split_huge_page(struct pag
 	struct page *head = compound_head(page);
 	struct zone *zone = page_zone(head);
 	struct lruvec *lruvec;
-	int i, tail_mapcount;
+	int i;
 
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
 	spin_lock_irq(&zone->lru_lock);
@@ -3290,10 +3286,8 @@ static void __split_huge_page(struct pag
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
 
-	tail_mapcount = 0;
 	for (i = HPAGE_PMD_NR - 1; i >= 1; i--)
-		tail_mapcount += __split_huge_page_tail(head, i, lruvec, list);
-	atomic_sub(tail_mapcount, &head->_count);
+		__split_huge_page_tail(head, i, lruvec, list);
 
 	ClearPageCompound(head);
 	spin_unlock_irq(&zone->lru_lock);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mempolicy-do-not-try-to-queue-pages-from-vma_migratable.patch
mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
thp-cleanup-split_huge_page.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

