From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-document-the-reserve-map-region-tracking-routines.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:38:50 -0700
Message-ID: <5591acda.YqbATi8wePBZYWGS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbF2Uiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: document the reserve map/region tracking routines
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-document-the-reserve-map-region-tracking-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: document the reserve map/region tracking routines

While working on hugetlbfs fallocate support, I noticed the following race
in the existing code.  It is unlikely that this race is hit very often in
the current code.  However, if more functionality to add and remove pages
to hugetlbfs mappings (such as fallocate) is added the likelihood of
hitting this race will increase.

alloc_huge_page and hugetlb_reserve_pages use information from the reserve
map to determine if there are enough available huge pages to complete the
operation, as well as adjust global reserve and subpool usage counts.  The
order of operations is as follows:

- call region_chg() to determine the expected change based on reserve map
- determine if enough resources are available for this operation
- adjust global counts based on the expected change
- call region_add() to update the reserve map

The issue is that reserve map could change between the call to region_chg
and region_add.  In this case, the counters which were adjusted based on
the output of region_chg will not be correct.

In order to hit this race today, there must be an existing shared hugetlb
mmap created with the MAP_NORESERVE flag.  A page fault to allocate a huge
page via this mapping must occur at the same another task is mapping the
same region without the MAP_NORESERVE flag.

The patch set does not prevent the race from happening.  Rather, it adds
simple functionality to detect when the race has occurred.  If a race is
detected, then the incorrect counts are adjusted.

Review comments pointed out the need for documentation of the existing
region/reserve map routines.  This patch set also adds documentation in
this area.



This patch (of 3):

This is a documentation only patch and does not modify any code. 
Descriptions of the routines used for reserve map/region tracking are
added.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-document-the-reserve-map-region-tracking-routines mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-document-the-reserve-map-region-tracking-routines
+++ a/mm/hugetlb.c
@@ -217,8 +217,20 @@ static inline struct hugepage_subpool *s
  * Region tracking -- allows tracking of reservations and instantiated pages
  *                    across the pages in a mapping.
  *
- * The region data structures are embedded into a resv_map and
- * protected by a resv_map's lock
+ * The region data structures are embedded into a resv_map and protected
+ * by a resv_map's lock.  The set of regions within the resv_map represent
+ * reservations for huge pages, or huge pages that have already been
+ * instantiated within the map.  The from and to elements are huge page
+ * indicies into the associated mapping.  from indicates the starting index
+ * of the region.  to represents the first index past the end of  the region.
+ *
+ * For example, a file region structure with from == 0 and to == 4 represents
+ * four huge pages in a mapping.  It is important to note that the to element
+ * represents the first element past the end of the region. This is used in
+ * arithmetic as 4(to) - 0(from) = 4 huge pages in the region.
+ *
+ * Interval notation of the form [from, to) will be used to indicate that
+ * the endpoint from is inclusive and to is exclusive.
  */
 struct file_region {
 	struct list_head link;
@@ -226,6 +238,14 @@ struct file_region {
 	long to;
 };
 
+/*
+ * Add the huge page range represented by [f, t) to the reserve
+ * map.  Existing regions will be expanded to accommodate the
+ * specified range.  We know only existing regions need to be
+ * expanded, because region_add is only called after region_chg
+ * with the same range.  If a new file_region structure must
+ * be allocated, it is done in region_chg.
+ */
 static long region_add(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
@@ -265,6 +285,25 @@ static long region_add(struct resv_map *
 	return 0;
 }
 
+/*
+ * Examine the existing reserve map and determine how many
+ * huge pages in the specified range [f, t) are NOT currently
+ * represented.  This routine is called before a subsequent
+ * call to region_add that will actually modify the reserve
+ * map to add the specified range [f, t).  region_chg does
+ * not change the number of huge pages represented by the
+ * map.  However, if the existing regions in the map can not
+ * be expanded to represent the new range, a new file_region
+ * structure is added to the map as a placeholder.  This is
+ * so that the subsequent region_add call will have all the
+ * regions it needs and will not fail.
+ *
+ * Returns the number of huge pages that need to be added
+ * to the existing reservation map for the range [f, t).
+ * This number is greater or equal to zero.  -ENOMEM is
+ * returned if a new file_region structure is needed and can
+ * not be allocated.
+ */
 static long region_chg(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
@@ -331,6 +370,11 @@ out_nrg:
 	return chg;
 }
 
+/*
+ * Truncate the reserve map at index 'end'.  Modify/truncate any
+ * region which contains end.  Delete any regions past end.
+ * Return the number of huge pages removed from the map.
+ */
 static long region_truncate(struct resv_map *resv, long end)
 {
 	struct list_head *head = &resv->regions;
@@ -366,6 +410,10 @@ out:
 	return chg;
 }
 
+/*
+ * Count and return the number of huge pages in the reserve map
+ * that intersect with the range [f, t).
+ */
 static long region_count(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

origin.patch

