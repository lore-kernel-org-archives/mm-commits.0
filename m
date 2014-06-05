From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:58 -0700
Message-ID: <5390ca22.BIT7UKaAJT34rV0Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaFETu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, peterz@infradead.org, mgorman@suse.de, liwanp@linux.vnet.ibm.com, liuj97@gmail.com, kirill.shutemov@linux.intel.com, hughd@google.com, hannes@cmpxchg.org, aarcange@redhat.com, nasa4836@gmail.com

Subject: [merged] mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch removed from -mm tree
To: nasa4836@gmail.com,aarcange@redhat.com,hannes@cmpxchg.org,hughd@google.com,kirill.shutemov@linux.intel.com,liuj97@gmail.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,peterz@infradead.org,riel@redhat.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:58 -0700


The patch titled
     Subject: mm/swap.c: introduce put_[un]refcounted_compound_page helpers for splitting put_compound_page()
has been removed from the -mm tree.  Its filename was
     mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm/swap.c: introduce put_[un]refcounted_compound_page helpers for splitting put_compound_page()

Currently, put_compound_page() carefully handles tricky cases to avoid
racing with compound page releasing or splitting, which makes it quite
lenthy (about 200+ lines) and needs deep tab indention, which makes it
quite hard to follow and maintain.

This patch and the next patch refactor this function.

Based on the code skeleton of put_compound_page:

put_compound_pge:
        if !PageTail(page)
        	put head page fastpath;
		return;

        /* else PageTail */
        page_head = compound_head(page)
        if !__compound_tail_refcounted(page_head)
		put head page optimal path; <---(1)
		return;
        else
		put head page slowpath; <--- (2)
                return;

This patch introduces two helpers, put_[un]refcounted_compound_page,
handling the code path (1) and code path (2), respectively.  They both are
tagged __always_inline, thus elmiating function call overhead, making them
operating the same way as before.

They are almost copied verbatim(except one place, a "goto out_put_single"
is expanded), with some comments rephrasing.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |  142 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)

diff -puN mm/swap.c~mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page mm/swap.c
--- a/mm/swap.c~mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page
+++ a/mm/swap.c
@@ -79,6 +79,148 @@ static void __put_compound_page(struct p
 	(*dtor)(page);
 }
 
+/**
+ * Two special cases here: we could avoid taking compound_lock_irqsave
+ * and could skip the tail refcounting(in _mapcount).
+ *
+ * 1. Hugetlbfs page:
+ *
+ *    PageHeadHuge will remain true until the compound page
+ *    is released and enters the buddy allocator, and it could
+ *    not be split by __split_huge_page_refcount().
+ *
+ *    So if we see PageHeadHuge set, and we have the tail page pin,
+ *    then we could safely put head page.
+ *
+ * 2. Slab THP page:
+ *
+ *    PG_slab is cleared before the slab frees the head page, and
+ *    tail pin cannot be the last reference left on the head page,
+ *    because the slab code is free to reuse the compound page
+ *    after a kfree/kmem_cache_free without having to check if
+ *    there's any tail pin left.  In turn all tail pinsmust be always
+ *    released while the head is still pinned by the slab code
+ *    and so we know PG_slab will be still set too.
+ *
+ *    So if we see PageSlab set, and we have the tail page pin,
+ *    then we could safely put head page.
+ */
+static __always_inline
+void put_unrefcounted_compound_page(struct page *page_head, struct page *page)
+{
+	/*
+	 * If @page is a THP tail, we must read the tail page
+	 * flags after the head page flags. The
+	 * __split_huge_page_refcount side enforces write memory barriers
+	 * between clearing PageTail and before the head page
+	 * can be freed and reallocated.
+	 */
+	smp_rmb();
+	if (likely(PageTail(page))) {
+		/*
+		 * __split_huge_page_refcount cannot race
+		 * here, see the comment above this function.
+		 */
+		VM_BUG_ON_PAGE(!PageHead(page_head), page_head);
+		VM_BUG_ON_PAGE(page_mapcount(page) != 0, page);
+		if (put_page_testzero(page_head)) {
+			/*
+			 * If this is the tail of a slab THP page,
+			 * the tail pin must not be the last reference
+			 * held on the page, because the PG_slab cannot
+			 * be cleared before all tail pins (which skips
+			 * the _mapcount tail refcounting) have been
+			 * released.
+			 *
+			 * If this is the tail of a hugetlbfs page,
+			 * the tail pin may be the last reference on
+			 * the page instead, because PageHeadHuge will
+			 * not go away until the compound page enters
+			 * the buddy allocator.
+			 */
+			VM_BUG_ON_PAGE(PageSlab(page_head), page_head);
+			__put_compound_page(page_head);
+		}
+	} else
+		/*
+		 * __split_huge_page_refcount run before us,
+		 * @page was a THP tail. The split @page_head
+		 * has been freed and reallocated as slab or
+		 * hugetlbfs page of smaller order (only
+		 * possible if reallocated as slab on x86).
+		 */
+		if (put_page_testzero(page))
+			__put_single_page(page);
+}
+
+static __always_inline
+void put_refcounted_compound_page(struct page *page_head, struct page *page)
+{
+	if (likely(page != page_head && get_page_unless_zero(page_head))) {
+		unsigned long flags;
+
+		/*
+		 * @page_head wasn't a dangling pointer but it may not
+		 * be a head page anymore by the time we obtain the
+		 * lock. That is ok as long as it can't be freed from
+		 * under us.
+		 */
+		flags = compound_lock_irqsave(page_head);
+		if (unlikely(!PageTail(page))) {
+			/* __split_huge_page_refcount run before us */
+			compound_unlock_irqrestore(page_head, flags);
+			if (put_page_testzero(page_head)) {
+				/*
+				 * The @page_head may have been freed
+				 * and reallocated as a compound page
+				 * of smaller order and then freed
+				 * again.  All we know is that it
+				 * cannot have become: a THP page, a
+				 * compound page of higher order, a
+				 * tail page.  That is because we
+				 * still hold the refcount of the
+				 * split THP tail and page_head was
+				 * the THP head before the split.
+				 */
+				if (PageHead(page_head))
+					__put_compound_page(page_head);
+				else
+					__put_single_page(page_head);
+			}
+out_put_single:
+			if (put_page_testzero(page))
+				__put_single_page(page);
+			return;
+		}
+		VM_BUG_ON_PAGE(page_head != page->first_page, page);
+		/*
+		 * We can release the refcount taken by
+		 * get_page_unless_zero() now that
+		 * __split_huge_page_refcount() is blocked on the
+		 * compound_lock.
+		 */
+		if (put_page_testzero(page_head))
+			VM_BUG_ON_PAGE(1, page_head);
+		/* __split_huge_page_refcount will wait now */
+		VM_BUG_ON_PAGE(page_mapcount(page) <= 0, page);
+		atomic_dec(&page->_mapcount);
+		VM_BUG_ON_PAGE(atomic_read(&page_head->_count) <= 0, page_head);
+		VM_BUG_ON_PAGE(atomic_read(&page->_count) != 0, page);
+		compound_unlock_irqrestore(page_head, flags);
+
+		if (put_page_testzero(page_head)) {
+			if (PageHead(page_head))
+				__put_compound_page(page_head);
+			else
+				__put_single_page(page_head);
+		}
+	} else {
+		/* @page_head is a dangling pointer */
+		VM_BUG_ON_PAGE(PageTail(page), page);
+		goto out_put_single;
+	}
+}
+
 static void put_compound_page(struct page *page)
 {
 	struct page *page_head;
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch
linux-next.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch

