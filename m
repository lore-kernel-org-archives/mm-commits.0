From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch added
 to -mm tree
Date: Mon, 19 Oct 2015 16:19:48 -0700
Message-ID: <56257a94.WKdAxBY+RGAWYHJ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbbJSXTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 19:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: define hugetlb_falloc structure for hole punch race
has been added to the -mm tree.  Its filename is
     mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch

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
Subject: mm/hugetlb: define hugetlb_falloc structure for hole punch race

The hugetlbfs fallocate hole punch code can race with page faults.  The
result is that after a hole punch operation, pages may remain within the
hole.  No other side effects of this race were observed.

In preparation for adding userfaultfd support to hugetlbfs, it is
desirable to plug or significantly shrink this hole.  This patch set uses
the same mechanism employed in shmem (see commit f00cdc6df7 ("shmem: fix
faulting into a hole while it's punched")).

hugetlb_fault_mutex_table is already used in hugetlbfs for fault
synchronization, and there is no swap for hugetlbfs.  So, this code is
simpler than in shmem.  In fact, the hugetlb_fault_mutex_table could be
used for races with small hole punch operations.  However, we need
something that will work for large holes as well.


This patch (of 3):

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

mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch
mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch.patch
mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait.patch

