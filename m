From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait.patch added to -mm tree
Date: Wed, 21 Oct 2015 13:39:43 -0700
Message-ID: <5627f80f.0XhFpygmnmnewk0Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbbJUUjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: page faults check for fallocate hole punch in progress and wait
has been added to the -mm tree.  Its filename is
     mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait.patch

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
Subject: mm/hugetlb: page faults check for fallocate hole punch in progress and wait

At page fault time, check i_private which indicates a fallocate hole punch
is in progress.  If the fault falls within the hole, wait for the hole
punch operation to complete before proceeding with the fault.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait
+++ a/mm/hugetlb.c
@@ -3670,6 +3670,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	struct page *pagecache_page = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
+	struct inode *inode = file_inode(vma->vm_file);
 	int need_wait_lock = 0;
 
 	address &= huge_page_mask(h);
@@ -3693,6 +3694,44 @@ int hugetlb_fault(struct mm_struct *mm,
 	idx = vma_hugecache_offset(h, vma, address);
 
 	/*
+	 * page faults could race with fallocate hole punch.  If a page
+	 * is faulted between unmap and deallocation, it will still remain
+	 * in the punched hole.  During hole punch operations, a hugetlb_falloc
+	 * structure will be pointed to by i_private.  If this fault is for
+	 * a page in a hole being punched, wait for the operation to finish
+	 * before proceeding.
+	 *
+	 * Even with this strategy, it is still possible for a page fault to
+	 * race with hole punch.  In this case, remove_inode_hugepages() will
+	 * unmap the page and then remove.  Checking i_private as below should
+	 * catch most of these races as we want to minimize unmapping a page
+	 * multiple times.
+	 */
+	if (unlikely(inode->i_private)) {
+		struct hugetlb_falloc *hugetlb_falloc;
+
+		spin_lock(&inode->i_lock);
+		hugetlb_falloc = inode->i_private;
+		if (hugetlb_falloc && hugetlb_falloc->waitq &&
+		    idx >= hugetlb_falloc->start &&
+		    idx <= hugetlb_falloc->end) {
+			wait_queue_head_t *hugetlb_falloc_waitq;
+			DEFINE_WAIT(hugetlb_fault_wait);
+
+			hugetlb_falloc_waitq = hugetlb_falloc->waitq;
+			prepare_to_wait(hugetlb_falloc_waitq,
+					&hugetlb_fault_wait,
+					TASK_UNINTERRUPTIBLE);
+			spin_unlock(&inode->i_lock);
+			schedule();
+
+			spin_lock(&inode->i_lock);
+			finish_wait(hugetlb_falloc_waitq, &hugetlb_fault_wait);
+		}
+		spin_unlock(&inode->i_lock);
+	}
+
+	/*
 	 * Serialize hugepage allocation and instantiation, so that we don't
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch
mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch.patch
mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait.patch
mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch.patch

