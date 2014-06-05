From: akpm@linux-foundation.org
Subject: [merged] mm-introdule-compound_head_by_tail.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:51:02 -0700
Message-ID: <5390ca26.+g+EgAssYeqYLEfD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaFETvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, peterz@infradead.org, mgorman@suse.de, liwanp@linux.vnet.ibm.com, liuj97@gmail.com, kirill.shutemov@linux.intel.com, hughd@google.com, hannes@cmpxchg.org, aarcange@redhat.com, nasa4836@gmail.com

Subject: [merged] mm-introdule-compound_head_by_tail.patch removed from -mm tree
To: nasa4836@gmail.com,aarcange@redhat.com,hannes@cmpxchg.org,hughd@google.com,kirill.shutemov@linux.intel.com,liuj97@gmail.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,peterz@infradead.org,riel@redhat.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:02 -0700


The patch titled
     Subject: mm: introdule compound_head_by_tail()
has been removed from the -mm tree.  Its filename was
     mm-introdule-compound_head_by_tail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm: introdule compound_head_by_tail()

Currently, in put_compound_page(), we have

======
if (likely(!PageTail(page))) {                  <------  (1)
        if (put_page_testzero(page)) {
                 /*
                 ¦* By the time all refcounts have been released
                 ¦* split_huge_page cannot run anymore from under us.
                 ¦*/
                 if (PageHead(page))
                         __put_compound_page(page);
                 else
                         __put_single_page(page);
         }
         return;
}

/* __split_huge_page_refcount can run under us */
page_head = compound_head(page);        <------------ (2)
======

if at (1) ,  we fail the check, this means page is *likely* a tail page.

Then at (2), as compoud_head(page) is inlined, it is :

======
static inline struct page *compound_head(struct page *page)
{
          if (unlikely(PageTail(page))) {           <----------- (3)
              struct page *head = page->first_page;

                smp_rmb();
                if (likely(PageTail(page)))
                        return head;
        }
        return page;
}
======

here, the (3) unlikely in the case is a negative hint, because it is
*likely* a tail page.  So the check (3) in this case is not good, so I
introduce a helper for this case.

So this patch introduces compound_head_by_tail() which deals with a
possible tail page(though it could be spilt by a racy thread), and make
compound_head() a wrapper on it.

This patch has no functional change, and it reduces the object
size slightly:
   text    data     bss     dec     hex  filename
  11003    1328      16   12347    303b  mm/swap.o.orig
  10971    1328      16   12315    301b  mm/swap.o.patched

I've ran "perf top -e branch-miss" to observe branch-miss in this case. 
As Michael points out, it's a slow path, so only very few times this case
happens.  But I grep'ed the code base, and found there still are some
other call sites could be benifited from this helper.  And given that it
only bloating up the source by only 5 lines, but with a reduced object
size.  I still believe this helper deserves to exsit.

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

 include/linux/mm.h |   29 +++++++++++++++++------------
 mm/swap.c          |    2 +-
 2 files changed, 18 insertions(+), 13 deletions(-)

diff -puN include/linux/mm.h~mm-introdule-compound_head_by_tail include/linux/mm.h
--- a/include/linux/mm.h~mm-introdule-compound_head_by_tail
+++ a/include/linux/mm.h
@@ -407,20 +407,25 @@ static inline void compound_unlock_irqre
 #endif
 }
 
-static inline struct page *compound_head(struct page *page)
+static inline struct page *compound_head_by_tail(struct page *tail)
 {
-	if (unlikely(PageTail(page))) {
-		struct page *head = page->first_page;
+	struct page *head = tail->first_page;
+
+	/*
+	 * page->first_page may be a dangling pointer to an old
+	 * compound page, so recheck that it is still a tail
+	 * page before returning.
+	 */
+	smp_rmb();
+	if (likely(PageTail(tail)))
+		return head;
+	return tail;
+}
 
-		/*
-		 * page->first_page may be a dangling pointer to an old
-		 * compound page, so recheck that it is still a tail
-		 * page before returning.
-		 */
-		smp_rmb();
-		if (likely(PageTail(page)))
-			return head;
-	}
+static inline struct page *compound_head(struct page *page)
+{
+	if (unlikely(PageTail(page)))
+		return compound_head_by_tail(page);
 	return page;
 }
 
diff -puN mm/swap.c~mm-introdule-compound_head_by_tail mm/swap.c
--- a/mm/swap.c~mm-introdule-compound_head_by_tail
+++ a/mm/swap.c
@@ -253,7 +253,7 @@ static void put_compound_page(struct pag
 	 *  Case 3 is possible, as we may race with
 	 *  __split_huge_page_refcount tearing down a THP page.
 	 */
-	page_head = compound_head(page);
+	page_head = compound_head_by_tail(page);
 	if (!__compound_tail_refcounted(page_head))
 		put_unrefcounted_compound_page(page_head, page);
 	else
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch
linux-next.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch

