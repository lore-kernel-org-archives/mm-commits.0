From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 hugetlbfs-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch added
 to -mm tree
Date: Wed, 18 Mar 2020 14:30:07 -0700
Message-ID: <20200318213007.UraObrN7X%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbgCRVaJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 17:30:09 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, prakash.sangappa@oracle.com


The patch titled
     Subject: hugetlbfs: Use i_mmap_rwsem to address page fault/truncate race
has been added to the -mm tree.  Its filename is
     hugetlbfs-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: Use i_mmap_rwsem to address page fault/truncate race

hugetlbfs page faults can race with truncate and hole punch operations.
Current code in the page fault path attempts to handle this by 'backing
out' operations if we encounter the race.  One obvious omission in the
current code is removing a page newly added to the page cache.  This is
pretty straight forward to address, but there is a more subtle and
difficult issue of backing out hugetlb reservations.  To handle this
correctly, the 'reservation state' before page allocation needs to be
noted so that it can be properly backed out.  There are four distinct
possibilities for reservation state: shared/reserved, shared/no-resv,
private/reserved and private/no-resv.  Backing out a reservation may
require memory allocation which could fail so that needs to be taken
into account as well.

Instead of writing the required complicated code for this rare
occurrence, just eliminate the race.  i_mmap_rwsem is now held in read
mode for the duration of page fault processing.  Hold i_mmap_rwsem in
write mode when modifying i_size.  In this way, truncation can not
proceed when page faults are being processed.  In addition, i_size
will not change during fault processing so a single check can be made
to ensure faults are not beyond (proposed) end of file.  Faults can
still race with hole punch, but that race is handled by existing code
and the use of hugetlb_fault_mutex.

With this modification, checks for races with truncation in the page
fault path can be simplified and removed.  remove_inode_hugepages no
longer needs to take hugetlb_fault_mutex in the case of truncation.
Comments are expanded to explain reasoning behind locking.

Link: http://lkml.kernel.org/r/20200316205756.146666-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   28 ++++++++++++++++++++--------
 mm/hugetlb.c         |   23 +++++++++++------------
 2 files changed, 31 insertions(+), 20 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-use-i_mmap_rwsem-to-address-page-fault-truncate-race
+++ a/fs/hugetlbfs/inode.c
@@ -393,10 +393,9 @@ hugetlb_vmdelete_list(struct rb_root_cac
  *	In this case, we first scan the range and release found pages.
  *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserv
  *	maps and global counts.  Page faults can not race with truncation
- *	in this routine.  hugetlb_no_page() prevents page faults in the
- *	truncated range.  It checks i_size before allocation, and again after
- *	with the page table lock for the page held.  The same lock must be
- *	acquired to unmap a page.
+ *	in this routine.  hugetlb_no_page() holds i_mmap_rwsem and prevents
+ *	page faults in the truncated range by checking i_size.  i_size is
+ *	modified while holding i_mmap_rwsem.
  * hole punch is indicated if end is not LLONG_MAX
  *	In the hole punch case we scan the range and release found pages.
  *	Only when releasing a page is the associated region/reserv map
@@ -436,7 +435,15 @@ static void remove_inode_hugepages(struc
 
 			index = page->index;
 			hash = hugetlb_fault_mutex_hash(mapping, index);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+			if (!truncate_op) {
+				/*
+				 * Only need to hold the fault mutex in the
+				 * hole punch case.  This prevents races with
+				 * page faults.  Races are not possible in the
+				 * case of truncation.
+				 */
+				mutex_lock(&hugetlb_fault_mutex_table[hash]);
+			}
 
 			/*
 			 * If page is mapped, it was faulted in after being
@@ -479,7 +486,8 @@ static void remove_inode_hugepages(struc
 			}
 
 			unlock_page(page);
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			if (!truncate_op)
+				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
 		huge_pagevec_release(&pvec);
 		cond_resched();
@@ -517,8 +525,8 @@ static int hugetlb_vmtruncate(struct ino
 	BUG_ON(offset & ~huge_page_mask(h));
 	pgoff = offset >> PAGE_SHIFT;
 
-	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
+	i_size_write(inode, offset);
 	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0);
 	i_mmap_unlock_write(mapping);
@@ -640,7 +648,11 @@ static long hugetlbfs_fallocate(struct f
 		/* addr is the offset within the file (zero based) */
 		addr = index * hpage_size;
 
-		/* mutex taken here, fault path and hole punch */
+		/*
+		 * fault mutex taken here, protects against fault path
+		 * and hole punch.  inode_lock previously taken protects
+		 * against truncation.
+		 */
 		hash = hugetlb_fault_mutex_hash(mapping, index);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
--- a/mm/hugetlb.c~hugetlbfs-use-i_mmap_rwsem-to-address-page-fault-truncate-race
+++ a/mm/hugetlb.c
@@ -3929,16 +3929,17 @@ static vm_fault_t hugetlb_no_page(struct
 	}
 
 	/*
-	 * Use page lock to guard against racing truncation
-	 * before we get page_table_lock.
+	 * We can not race with truncation due to holding i_mmap_rwsem.
+	 * i_size is modified when holding i_mmap_rwsem, so check here
+	 * once for faults beyond end of file.
 	 */
+	size = i_size_read(mapping->host) >> huge_page_shift(h);
+	if (idx >= size)
+		goto out;
+
 retry:
 	page = find_lock_page(mapping, idx);
 	if (!page) {
-		size = i_size_read(mapping->host) >> huge_page_shift(h);
-		if (idx >= size)
-			goto out;
-
 		/*
 		 * Check for page in userfault range
 		 */
@@ -4044,10 +4045,6 @@ retry:
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
-	size = i_size_read(mapping->host) >> huge_page_shift(h);
-	if (idx >= size)
-		goto backout;
