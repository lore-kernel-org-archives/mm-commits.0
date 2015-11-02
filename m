From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch
 removed from -mm tree
Date: Mon, 02 Nov 2015 13:38:14 -0800
Message-ID: <5637d7c6.GbZwQjtx9w5rf62b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbbKBViP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 16:38:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: define hugetlb_falloc structure for hole punch race
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: define hugetlb_falloc structure for hole punch race

The hugetlbfs fallocate hole punch code can race with page faults.  The
result is that after a hole punch operation, pages may remain within the
hole.  No other side effects of this race were observed.

In preparation for adding userfaultfd support to hugetlbfs, it is
desirable to close the window of this race.  This patch set starts by
using the same mechanism employed in shmem (see commit f00cdc6df7).  This
greatly reduces the race window.  However, it is still possible for the
race to occur.

The current hugetlbfs code to remove pages did not deal with pages that
were mapped (because of such a race).  This patch set also adds code to
unmap pages in this rare case.  This unmapping of a single page happens
under the hugetlb_fault_mutex, so it can not be faulted again until the
end of the operation.


This patch (of 4):

A hugetlb_falloc structure is pointed to by i_private during fallocate
hole punch operations.  Page faults check this structure and if they are
in the hole, wait for the operation to finish.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/hugetlb.h~mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race
+++ a/include/linux/hugetlb.h
@@ -42,6 +42,16 @@ struct resv_map {
 extern struct resv_map *resv_map_alloc(void);
 void resv_map_release(struct kref *ref);
 
+/*
+ * hugetlb_falloc is used to prevent page faults during falloc hole punch
+ * operations.  During hole punch, inode->i_private points to this struct.
+ */
+struct hugetlb_falloc {
+	wait_queue_head_t *waitq;	/* Page faults waiting on hole punch */
+	pgoff_t start;			/* Start of fallocate hole */
+	pgoff_t end;			/* End of fallocate hole */
+};
+
 extern spinlock_t hugetlb_lock;
 extern int hugetlb_max_hstate __read_mostly;
 #define for_each_hstate(h) \
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch.patch
mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait.patch
mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch.patch

