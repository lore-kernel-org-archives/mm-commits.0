From: akpm@linux-foundation.org
Subject: [merged] mm-fix-slab-page-flags-corruption.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:33 -0700
Message-ID: <20120531191633.6ACC1A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37109 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab2EaTQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:35 -0400
Received: by mail-wi0-f202.google.com with SMTP id hn6so76973wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pshelar@nicira.com, aarcange@redhat.com, abhide@nicira.com, cl@linux.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix slab->page flags corruption
has been removed from the -mm tree.  Its filename was
     mm-fix-slab-page-flags-corruption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Pravin B Shelar <pshelar@nicira.com>
Subject: mm: fix slab->page flags corruption

Transparent huge pages can change page->flags (PG_compound_lock) without
taking Slab lock.  Since THP can not break slab pages we can safely access
compound page without taking compound lock.

Specifically this patch fixes a race between compound_unlock() and slab
functions which perform page-flags updates.  This can occur when
get_page()/put_page() is called on a page from slab.

[akpm@linux-foundation.org: tweak comment text, fix comment layout, fix label indenting]
Reported-by: Amey Bhide <abhide@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/swap.c          |   37 +++++++++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-fix-slab-page-flags-corruption include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-slab-page-flags-corruption
+++ a/include/linux/mm.h
@@ -321,6 +321,7 @@ static inline int is_vmalloc_or_module_a
 static inline void compound_lock(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	VM_BUG_ON(PageSlab(page));
 	bit_spin_lock(PG_compound_lock, &page->flags);
 #endif
 }
@@ -328,6 +329,7 @@ static inline void compound_lock(struct 
 static inline void compound_unlock(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	VM_BUG_ON(PageSlab(page));
 	bit_spin_unlock(PG_compound_lock, &page->flags);
 #endif
 }
diff -puN mm/swap.c~mm-fix-slab-page-flags-corruption mm/swap.c
--- a/mm/swap.c~mm-fix-slab-page-flags-corruption
+++ a/mm/swap.c
@@ -82,6 +82,25 @@ static void put_compound_page(struct pag
 		if (likely(page != page_head &&
 			   get_page_unless_zero(page_head))) {
 			unsigned long flags;
+
+			/*
+			 * THP can not break up slab pages so avoid taking
+			 * compound_lock().  Slab performs non-atomic bit ops
+			 * on page->flags for better performance.  In particular
+			 * slab_unlock() in slub used to be a hot path.  It is
+			 * still hot on arches that do not support
+			 * this_cpu_cmpxchg_double().
+			 */
+			if (PageSlab(page_head)) {
+				if (PageTail(page)) {
+					if (put_page_testzero(page_head))
+						VM_BUG_ON(1);
+
+					atomic_dec(&page->_mapcount);
+					goto skip_lock_tail;
+				} else
+					goto skip_lock;
+			}
 			/*
 			 * page_head wasn't a dangling pointer but it
 			 * may not be a head page anymore by the time
@@ -92,10 +111,10 @@ static void put_compound_page(struct pag
 			if (unlikely(!PageTail(page))) {
 				/* __split_huge_page_refcount run before us */
 				compound_unlock_irqrestore(page_head, flags);
-				VM_BUG_ON(PageHead(page_head));
+skip_lock:
 				if (put_page_testzero(page_head))
 					__put_single_page(page_head);
-			out_put_single:
+out_put_single:
 				if (put_page_testzero(page))
 					__put_single_page(page);
 				return;
@@ -115,6 +134,8 @@ static void put_compound_page(struct pag
 			VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
 			VM_BUG_ON(atomic_read(&page->_count) != 0);
 			compound_unlock_irqrestore(page_head, flags);
+
+skip_lock_tail:
 			if (put_page_testzero(page_head)) {
 				if (PageHead(page_head))
 					__put_compound_page(page_head);
@@ -162,6 +183,18 @@ bool __get_page_tail(struct page *page)
 	struct page *page_head = compound_trans_head(page);
 
 	if (likely(page != page_head && get_page_unless_zero(page_head))) {
+
+		/* Ref to put_compound_page() comment. */
+		if (PageSlab(page_head)) {
+			if (likely(PageTail(page))) {
+				__get_page_tail_foll(page, false);
+				return true;
+			} else {
+				put_page(page_head);
+				return false;
+			}
+		}
+
 		/*
 		 * page_head wasn't a dangling pointer but it
 		 * may not be a head page anymore by the time
_

Patches currently in -mm which might be from pshelar@nicira.com are

origin.patch

