From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes.patch
 added to -mm tree
Date: Mon, 02 Nov 2015 13:39:39 -0800
Message-ID: <5637d81b.ZTstRqj6Uw3BbmjE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbbKBVjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 16:39:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlbfs fix bugs in fallocate hole punch of areas with holes
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes.patch

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
Subject: mm/hugetlbfs fix bugs in fallocate hole punch of areas with holes

Hugh Dickins pointed out problems with the new hugetlbfs fallocate hole
punch code.  These problems are in the routine remove_inode_hugepages and
mostly occur in the case where there are holes in the range of pages to be
removed.  These holes could be the result of a previous hole punch or
simply sparse allocation.

remove_inode_hugepages handles both hole punch and truncate operations. 
Page index handling was fixed/cleaned up so that holes are properly
handled.  In addition, code was changed to ensure multiple passes of the
address range only happens in the truncate case.  More comments were added
to explain the different actions in each case.  A cond_resched() was added
after removing up to PAGEVEC_SIZE pages.

Some totally unnecessary code in hugetlbfs_fallocate() that remained from
early development was also removed.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   44 +++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes
+++ a/fs/hugetlbfs/inode.c
@@ -368,10 +368,25 @@ static void remove_inode_hugepages(struc
 			lookup_nr = end - next;
 
 		/*
-		 * This pagevec_lookup() may return pages past 'end',
-		 * so we must check for page->index > end.
+		 * When no more pages are found, take different action for
+		 * hole punch and truncate.
+		 *
+		 * For hole punch, this indicates we have removed each page
+		 * within the range and are done.  Note that pages may have
+		 * been faulted in after being removed in the hole punch case.
+		 * This is OK as long as each page in the range was removed
+		 * once.
+		 *
+		 * For truncate, we need to make sure all pages within the
+		 * range are removed when exiting this routine.  We could
+		 * have raced with a fault that brought in a page after it
+		 * was first removed.  Check the range again until no pages
+		 * are found.
 		 */
 		if (!pagevec_lookup(&pvec, mapping, next, lookup_nr)) {
+			if (!truncate_op)
+				break;
+
 			if (next == start)
 				break;
 			next = start;
@@ -382,19 +397,23 @@ static void remove_inode_hugepages(struc
 			struct page *page = pvec.pages[i];
 			u32 hash;
 
+			/*
+			 * The page (index) could be beyond end.  This is
+			 * only possible in the punch hole case as end is
+			 * LLONG_MAX for truncate.
+			 */
+			if (page->index >= end) {
+				next = end;	/* we are done */
+				break;
+			}
+			next = page->index;
+
 			hash = hugetlb_fault_mutex_hash(h, current->mm,
 							&pseudo_vma,
 							mapping, next, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			lock_page(page);
-			if (page->index >= end) {
-				unlock_page(page);
-				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-				next = end;	/* we are done */
-				break;
-			}
-
 			/*
 			 * If page is mapped, it was faulted in after being
 			 * unmapped.  Do nothing in this race case.  In the
@@ -423,15 +442,13 @@ static void remove_inode_hugepages(struc
 				}
 			}
 
-			if (page->index > next)
-				next = page->index;
-
 			++next;
 			unlock_page(page);
 
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
 		huge_pagevec_release(&pvec);
+		cond_resched();
 	}
 
 	if (truncate_op)
@@ -647,9 +664,6 @@ static long hugetlbfs_fallocate(struct f
 	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
 		i_size_write(inode, offset + len);
 	inode->i_ctime = CURRENT_TIME;
-	spin_lock(&inode->i_lock);
-	inode->i_private = NULL;
-	spin_unlock(&inode->i_lock);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return error;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlbfs-fix-bugs-in-fallocate-hole-punch-of-areas-with-holes.patch

