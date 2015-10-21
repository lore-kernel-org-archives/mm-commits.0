From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch.patch added to
 -mm tree
Date: Wed, 21 Oct 2015 13:39:41 -0700
Message-ID: <5627f80d.N38any5IHYz4ltb7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbbJUUjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:39:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: setup hugetlb_falloc during fallocate hole punch
has been added to the -mm tree.  Its filename is
     mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch.patch

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
Subject: mm/hugetlb: setup hugetlb_falloc during fallocate hole punch

When performing a fallocate hole punch, set up a hugetlb_falloc struct and
make i_private point to it.  i_private will point to this struct for the
duration of the operation.  At the end of the operation, wake up anyone
who faulted on the hole and is on the waitq.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch
+++ a/fs/hugetlbfs/inode.c
@@ -507,6 +507,7 @@ static long hugetlbfs_punch_hole(struct
 {
 	struct hstate *h = hstate_inode(inode);
 	loff_t hpage_size = huge_page_size(h);
+	unsigned long hpage_shift = huge_page_shift(h);
 	loff_t hole_start, hole_end;
 
 	/*
@@ -518,8 +519,30 @@ static long hugetlbfs_punch_hole(struct
 
 	if (hole_end > hole_start) {
 		struct address_space *mapping = inode->i_mapping;
+		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(hugetlb_falloc_waitq);
+		/*
+		 * Page faults on the area to be hole punched must be stopped
+		 * during the operation.  Initialize struct and have
+		 * inode->i_private point to it.
+		 */
+		struct hugetlb_falloc hugetlb_falloc = {
+			.waitq = &hugetlb_falloc_waitq,
+			.start = hole_start >> hpage_shift,
+			.end = hole_end >> hpage_shift
+		};
 
 		mutex_lock(&inode->i_mutex);
+
+		/*
+		 * inode->i_private will be checked in the page fault path.
+		 * The locking assures that all writes to the structure are
+		 * complete before assigning to i_private.  A fault on another
+		 * CPU will see the fully initialized structure.
+		 */
+		spin_lock(&inode->i_lock);
+		inode->i_private = &hugetlb_falloc;
+		spin_unlock(&inode->i_lock);
+
 		i_mmap_lock_write(mapping);
 		if (!RB_EMPTY_ROOT(&mapping->i_mmap))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
@@ -527,6 +550,12 @@ static long hugetlbfs_punch_hole(struct
 						hole_end  >> PAGE_SHIFT);
 		i_mmap_unlock_write(mapping);
 		remove_inode_hugepages(inode, hole_start, hole_end);
+
+		spin_lock(&inode->i_lock);
+		inode->i_private = NULL;
+		wake_up_all(&hugetlb_falloc_waitq);
+		spin_unlock(&inode->i_lock);
+
 		mutex_unlock(&inode->i_mutex);
 	}
 
@@ -647,9 +676,6 @@ static long hugetlbfs_fallocate(struct f
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

mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch
mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch.patch
mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait.patch
mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch.patch

