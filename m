From: akpm@linux-foundation.org
Subject: +
 hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch added to -mm tree
Date: Tue, 24 Mar 2015 14:28:33 -0700
Message-ID: <5511d701.cO9bnFESy3+EupyU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbCXV2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 17:28:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, andi@firstfloor.org, aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net, iamjoonsoo.kim@lge.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: add minimum size tracking fields to subpool structure
has been added to the -mm tree.  Its filename is
     hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch

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
Subject: hugetlbfs: add minimum size tracking fields to subpool structure

hugetlbfs allocates huge pages from the global pool as needed.  Even if
the global pool contains a sufficient number pages for the filesystem size
at mount time, those global pages could be grabbed for some other use.  As
a result, filesystem huge page allocations may fail due to lack of pages.

Applications such as a database want to use huge pages for performance
reasons.  hugetlbfs filesystem semantics with ownership and modes work
well to manage access to a pool of huge pages.  However, the application
would like some reasonable assurance that allocations will not fail due to
a lack of huge pages.  At application startup time, the application would
like to configure itself to use a specific number of huge pages.  Before
starting, the application can check to make sure that enough huge pages
exist in the system global pools.  However, there are no guarantees that
those pages will be available when needed by the application.  What the
application wants is exclusive use of a subset of huge pages.

Add a new hugetlbfs mount option 'min_size=<value>' to indicate that the
specified number of pages will be available for use by the filesystem.  At
mount time, this number of huge pages will be reserved for exclusive use
of the filesystem.  If there is not a sufficient number of free pages, the
mount will fail.  As pages are allocated to and freeed from the
filesystem, the number of reserved pages is adjusted so that the specified
minimum is maintained.



This patch (of 4):

Add a field to the subpool structure to indicate the minimimum number of
huge pages to always be used by this subpool.  This minimum count includes
allocated pages as well as reserved pages.  If the minimum number of pages
for the subpool have not been allocated, pages are reserved up to this
minimum.  An additional field (rsv_hpages) is used to track the number of
pages reserved to meet this minimum size.  The hstate pointer in the
subpool is convenient to have when reserving and unreserving the pages.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    8 +++++++-
 mm/hugetlb.c            |    3 +--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure
+++ a/include/linux/hugetlb.h
@@ -22,7 +22,13 @@ struct mmu_gather;
 struct hugepage_subpool {
 	spinlock_t lock;
 	long count;
-	long max_hpages, used_hpages;
+	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
+	long used_hpages;	/* Used count against maximum, includes */
+				/* both alloced and reserved pages. */
+	struct hstate *hstate;
+	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
+	long rsv_hpages;	/* Pages reserved against global pool to */
+				/* sasitfy minimum size. */
 };
 
 struct resv_map {
diff -puN mm/hugetlb.c~hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure
+++ a/mm/hugetlb.c
@@ -77,14 +77,13 @@ struct hugepage_subpool *hugepage_new_su
 {
 	struct hugepage_subpool *spool;
 
-	spool = kmalloc(sizeof(*spool), GFP_KERNEL);
+	spool = kzalloc(sizeof(*spool), GFP_KERNEL);
 	if (!spool)
 		return NULL;
 
 	spin_lock_init(&spool->lock);
 	spool->count = 1;
 	spool->max_hpages = nr_blocks;
-	spool->used_hpages = 0;
 
 	return spool;
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option-and-cleanup.patch

