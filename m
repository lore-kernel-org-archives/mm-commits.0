From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch.patch added to -mm tree
Date: Mon, 11 Jan 2016 14:35:52 -0800
Message-ID: <56942e48.0h2nGWyjKoBjaAyT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760825AbcAKWfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:35:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlbfs: unmap pages if page fault raced with hole punch
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlbfs: unmap pages if page fault raced with hole punch

Page faults can race with fallocate hole punch.  If a page fault happens
between the unmap and remove operations, the page is not removed and
remains within the hole.  This is not the desired behavior.  The race is
difficult to detect in user level code as even in the non-race case, a
page within the hole could be faulted back in before fallocate returns. 
If userfaultfd is expanded to support hugetlbfs in the future, this race
will be easier to observe.

If this race is detected and a page is mapped, the remove operation
(remove_inode_hugepages) will unmap the page before removing.  The unmap
within remove_inode_hugepages occurs with the hugetlb_fault_mutex held so
that no other faults will be processed until the page is removed.

The (unmodified) routine hugetlb_vmdelete_list was moved ahead of
remove_inode_hugepages to satisfy the new reference.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   70 ++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch
+++ a/fs/hugetlbfs/inode.c
@@ -324,11 +324,10 @@ static void remove_huge_page(struct page
 	delete_from_page_cache(page);
 }
 
-
 /*
  * remove_inode_hugepages handles two distinct cases: truncation and hole
  * punch.  There are subtle differences in operation for each case.
-
+ *
  * truncation is indicated by end of range being LLONG_MAX
  *	In this case, we first scan the range and release found pages.
  *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserv
@@ -379,6 +378,7 @@ static void remove_inode_hugepages(struc
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
+			bool rsv_on_error;
 			u32 hash;
 
 			/*
@@ -395,37 +395,43 @@ static void remove_inode_hugepages(struc
 							mapping, next, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
-			lock_page(page);
-			if (likely(!page_mapped(page))) {
-				bool rsv_on_error = !PagePrivate(page);
-				/*
-				 * We must free the huge page and remove
-				 * from page cache (remove_huge_page) BEFORE
-				 * removing the region/reserve map
-				 * (hugetlb_unreserve_pages).  In rare out
-				 * of memory conditions, removal of the
-				 * region/reserve map could fail.  Before
-				 * free'ing the page, note PagePrivate which
-				 * is used in case of error.
-				 */
-				remove_huge_page(page);
-				freed++;
-				if (!truncate_op) {
-					if (unlikely(hugetlb_unreserve_pages(
-							inode, next,
-							next + 1, 1)))
-						hugetlb_fix_reserve_counts(
-							inode, rsv_on_error);
-				}
-			} else {
-				/*
-				 * If page is mapped, it was faulted in after
-				 * being unmapped.  It indicates a race between
-				 * hole punch and page fault.  Do nothing in
-				 * this case.  Getting here in a truncate
-				 * operation is a bug.
-				 */
+			/*
+			 * If page is mapped, it was faulted in after being
+			 * unmapped in caller.  Unmap (again) now after taking
+			 * the fault mutex.  The mutex will prevent faults
+			 * until we finish removing the page.
+			 *
+			 * This race can only happen in the hole punch case.
+			 * Getting here in a truncate operation is a bug.
+			 */
+			if (unlikely(page_mapped(page))) {
 				BUG_ON(truncate_op);
+
+				i_mmap_lock_write(mapping);
+				hugetlb_vmdelete_list(&mapping->i_mmap,
+					next * pages_per_huge_page(h),
+					(next + 1) * pages_per_huge_page(h));
+				i_mmap_unlock_write(mapping);
+			}
+
+			lock_page(page);
+			/*
+			 * We must free the huge page and remove from page
+			 * cache (remove_huge_page) BEFORE removing the
+			 * region/reserve map (hugetlb_unreserve_pages).  In
+			 * rare out of memory conditions, removal of the
+			 * region/reserve map could fail.  Before free'ing
+			 * the page, note PagePrivate which is used in case
+			 * of error.
+			 */
+			rsv_on_error = !PagePrivate(page);
+			remove_huge_page(page);
+			freed++;
+			if (!truncate_op) {
+				if (unlikely(hugetlb_unreserve_pages(inode,
+							next, next + 1, 1)))
+					hugetlb_fix_reserve_counts(inode,
+								rsv_on_error);
 			}
 
 			unlock_page(page);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlbfs-fix-bugs-in-hugetlb_vmtruncate_list.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch.patch

