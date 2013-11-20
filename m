From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch added to -mm tree
Date: Wed, 20 Nov 2013 13:29:15 -0800
Message-ID: <528d29ab.4yRBgbHKDG9T/hOM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3KTV3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 16:29:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com

Subject: + mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch added to -mm tree
To: aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 13:29:15 -0800


The patch titled
     Subject: mm: hugetlbfs: move the put/get_page slab and hugetlbfs optimization in a faster path
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: hugetlbfs: move the put/get_page slab and hugetlbfs optimization in a faster path

We don't actually need a reference on the head page in the slab and
hugetlbfs paths, as long as we add a smp_rmb() which should be faster
than get_page_unless_zero.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |  140 ++++++++++++++++++++++++++++------------------------
 1 file changed, 78 insertions(+), 62 deletions(-)

diff -puN mm/swap.c~mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path mm/swap.c
--- a/mm/swap.c~mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path
+++ a/mm/swap.c
@@ -86,46 +86,62 @@ static void put_compound_page(struct pag
 		/* __split_huge_page_refcount can run under us */
 		struct page *page_head = compound_trans_head(page);
 
+		/*
+		 * THP can not break up slab pages so avoid taking
+		 * compound_lock(). Slab performs non-atomic bit ops
+		 * on page->flags for better performance. In
+		 * particular slab_unlock() in slub used to be a hot
+		 * path. It is still hot on arches that do not support
+		 * this_cpu_cmpxchg_double().
+		 *
+		 * If "page" is part of a slab or hugetlbfs page it
+		 * cannot be splitted and the head page cannot change
+		 * from under us. And if "page" is part of a THP page
+		 * under splitting, if the head page pointed by the
+		 * THP tail isn't a THP head anymore, we'll find
+		 * PageTail clear after smp_rmb() and we'll threat it
+		 * as a single page.
+		 */
+		if (PageSlab(page_head) || PageHeadHuge(page_head)) {
+			/*
+			 * If "page" is a THP tail, we must read the tail page
+			 * flags after the head page flags. The
+			 * split_huge_page side enforces write memory
+			 * barriers between clearing PageTail and before the
+			 * head page can be freed and reallocated.
+			 */
+			smp_rmb();
+			if (likely(PageTail(page))) {
+				/*
+				 * __split_huge_page_refcount
+				 * cannot race here.
+				 */
+				VM_BUG_ON(!PageHead(page_head));
+				VM_BUG_ON(page_mapcount(page) <= 0);
+				atomic_dec(&page->_mapcount);
+				if (put_page_testzero(page_head))
+					__put_compound_page(page_head);
+				return;
+			} else
+				/*
+				 * __split_huge_page_refcount
+				 * run before us, "page" was a
+				 * THP tail. The split
+				 * page_head has been freed
+				 * and reallocated as slab or
+				 * hugetlbfs page of smaller
+				 * order (only possible if
+				 * reallocated as slab on
+				 * x86).
+				 */
+				goto out_put_single;
+		}
+
 		if (likely(page != page_head &&
 			   get_page_unless_zero(page_head))) {
 			unsigned long flags;
 
 			/*
-			 * THP can not break up slab pages so avoid taking
-			 * compound_lock().  Slab performs non-atomic bit ops
-			 * on page->flags for better performance.  In particular
-			 * slab_unlock() in slub used to be a hot path.  It is
-			 * still hot on arches that do not support
-			 * this_cpu_cmpxchg_double().
-			 */
-			if (PageSlab(page_head) || PageHeadHuge(page_head)) {
-				if (likely(PageTail(page))) {
-					/*
-					 * __split_huge_page_refcount
-					 * cannot race here.
-					 */
-					VM_BUG_ON(!PageHead(page_head));
-					atomic_dec(&page->_mapcount);
-					if (put_page_testzero(page_head))
-						VM_BUG_ON(1);
-					if (put_page_testzero(page_head))
-						__put_compound_page(page_head);
-					return;
-				} else
-					/*
-					 * __split_huge_page_refcount
-					 * run before us, "page" was a
-					 * THP tail. The split
-					 * page_head has been freed
-					 * and reallocated as slab or
-					 * hugetlbfs page of smaller
-					 * order (only possible if
-					 * reallocated as slab on
-					 * x86).
-					 */
-					goto skip_lock;
-			}
-			/*
 			 * page_head wasn't a dangling pointer but it
 			 * may not be a head page anymore by the time
 			 * we obtain the lock. That is ok as long as it
@@ -135,7 +151,6 @@ static void put_compound_page(struct pag
 			if (unlikely(!PageTail(page))) {
 				/* __split_huge_page_refcount run before us */
 				compound_unlock_irqrestore(page_head, flags);
-skip_lock:
 				if (put_page_testzero(page_head)) {
 					/*
 					 * The head page may have been
@@ -221,36 +236,37 @@ bool __get_page_tail(struct page *page)
 	 * split_huge_page().
 	 */
 	unsigned long flags;
-	bool got = false;
+	bool got;
 	struct page *page_head = compound_trans_head(page);
 
-	if (likely(page != page_head && get_page_unless_zero(page_head))) {
-		/* Ref to put_compound_page() comment. */
-		if (PageSlab(page_head) || PageHeadHuge(page_head)) {
-			if (likely(PageTail(page))) {
-				/*
-				 * This is a hugetlbfs page or a slab
-				 * page. __split_huge_page_refcount
-				 * cannot race here.
-				 */
-				VM_BUG_ON(!PageHead(page_head));
-				__get_page_tail_foll(page, false);
-				return true;
-			} else {
-				/*
-				 * __split_huge_page_refcount run
-				 * before us, "page" was a THP
-				 * tail. The split page_head has been
-				 * freed and reallocated as slab or
-				 * hugetlbfs page of smaller order
-				 * (only possible if reallocated as
-				 * slab on x86).
-				 */
-				put_page(page_head);
-				return false;
-			}
+	/* Ref to put_compound_page() comment. */
+	if (PageSlab(page_head) || PageHeadHuge(page_head)) {
+		smp_rmb();
+		if (likely(PageTail(page))) {
+			/*
+			 * This is a hugetlbfs page or a slab
+			 * page. __split_huge_page_refcount
+			 * cannot race here.
+			 */
+			VM_BUG_ON(!PageHead(page_head));
+			__get_page_tail_foll(page, true);
+			return true;
+		} else {
+			/*
+			 * __split_huge_page_refcount run
+			 * before us, "page" was a THP
+			 * tail. The split page_head has been
+			 * freed and reallocated as slab or
+			 * hugetlbfs page of smaller order
+			 * (only possible if reallocated as
+			 * slab on x86).
+			 */
+			return false;
 		}
+	}
 
+	got = false;
+	if (likely(page != page_head && get_page_unless_zero(page_head))) {
 		/*
 		 * page_head wasn't a dangling pointer but it
 		 * may not be a head page anymore by the time
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
mm-hugetlbfs-fix-hugetlbfs-optimization.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch

