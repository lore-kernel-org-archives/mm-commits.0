From: akpm@linux-foundation.org
Subject: + hugetlb-move-hugetlb_acct_memory.patch added to -mm tree
Date: Wed, 28 May 2008 18:43:26 -0700
Message-ID: <200805290143.m4T1hQge010520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbYE2BqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 21:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, agl@us.ibm.com, apw@shadowen.org, hugh@veritas.com, wli@holomorphy.com


The patch titled
     hugetlb: move hugetlb_acct_memory()
has been added to the -mm tree.  Its filename is
     hugetlb-move-hugetlb_acct_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: move hugetlb_acct_memory()
From: Mel Gorman <mel@csn.ul.ie>

This is a patchset to give reliable behaviour to a process that
successfully calls mmap(MAP_PRIVATE) on a hugetlbfs file.  Currently, it
is possible for the process to be killed due to a small hugepage pool size
even if it calls mlock().

MAP_SHARED mappings on hugetlbfs reserve huge pages at mmap() time.  This
guarantees all future faults against the mapping will succeed.  This
allows local allocations at first use improving NUMA locality whilst
retaining reliability.

MAP_PRIVATE mappings do not reserve pages.  This can result in an
application being SIGKILLed later if a huge page is not available at fault
time.  This makes huge pages usage very ill-advised in some cases as the
unexpected application failure cannot be detected and handled as it is
immediately fatal.  Although an application may force instantiation of the
pages using mlock(), this may lead to poor memory placement and the
process may still be killed when performing COW.

This patchset introduces a reliability guarantee for the process which
creates a private mapping, i.e.  the process that calls mmap() on a
hugetlbfs file successfully.  The first patch of the set is purely
mechanical code move to make later diffs easier to read.  The second patch
will guarantee faults up until the process calls fork().  After patch two,
as long as the child keeps the mappings, the parent is no longer
guaranteed to be reliable.  Patch 3 guarantees that the parent will always
successfully COW by unmapping the pages from the child in the event there
are insufficient pages in the hugepage pool in allocate a new page, be it
via a static or dynamic pool.

Existing hugepage-aware applications are unlikely to be affected by this
change.  For much of hugetlbfs's history, pages were pre-faulted at mmap()
time or mmap() failed which acts in a reserve-like manner.  If the pool is
sized correctly already so that parent and child can fault reliably, the
application will not even notice the reserves.  It's only when the pool is
too small for the application to function perfectly reliably that the
reserves come into play.

Credit goes to Andy Whitcroft for cleaning up a number of mistakes during
review before the patches were released.


This patch:

A later patch in this set needs to call hugetlb_acct_memory() before it is
defined.  This patch moves the function without modification.  This makes
later diffs easier to read.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   82 ++++++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-move-hugetlb_acct_memory mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-move-hugetlb_acct_memory
+++ a/mm/hugetlb.c
@@ -716,6 +716,47 @@ unsigned long hugetlb_total_pages(void)
 	return nr_huge_pages * (HPAGE_SIZE / PAGE_SIZE);
 }
 
+static int hugetlb_acct_memory(long delta)
+{
+	int ret = -ENOMEM;
+
+	spin_lock(&hugetlb_lock);
+	/*
+	 * When cpuset is configured, it breaks the strict hugetlb page
+	 * reservation as the accounting is done on a global variable. Such
+	 * reservation is completely rubbish in the presence of cpuset because
+	 * the reservation is not checked against page availability for the
+	 * current cpuset. Application can still potentially OOM'ed by kernel
+	 * with lack of free htlb page in cpuset that the task is in.
+	 * Attempt to enforce strict accounting with cpuset is almost
+	 * impossible (or too ugly) because cpuset is too fluid that
+	 * task or memory node can be dynamically moved between cpusets.
+	 *
+	 * The change of semantics for shared hugetlb mapping with cpuset is
+	 * undesirable. However, in order to preserve some of the semantics,
+	 * we fall back to check against current free page availability as
+	 * a best attempt and hopefully to minimize the impact of changing
+	 * semantics that cpuset has.
+	 */
+	if (delta > 0) {
+		if (gather_surplus_pages(delta) < 0)
+			goto out;
+
+		if (delta > cpuset_mems_nr(free_huge_pages_node)) {
+			return_unused_surplus_pages(delta);
+			goto out;
+		}
+	}
+
+	ret = 0;
+	if (delta < 0)
+		return_unused_surplus_pages((unsigned long) -delta);
+
+out:
+	spin_unlock(&hugetlb_lock);
+	return ret;
+}
+
 /*
  * We cannot handle pagefaults against hugetlb pages at all.  They cause
  * handle_mm_fault() to try to instantiate regular-sized pages in the
@@ -1248,47 +1289,6 @@ static long region_truncate(struct list_
 	return chg;
 }
 
-static int hugetlb_acct_memory(long delta)
-{
-	int ret = -ENOMEM;
-
-	spin_lock(&hugetlb_lock);
-	/*
-	 * When cpuset is configured, it breaks the strict hugetlb page
-	 * reservation as the accounting is done on a global variable. Such
-	 * reservation is completely rubbish in the presence of cpuset because
-	 * the reservation is not checked against page availability for the
-	 * current cpuset. Application can still potentially OOM'ed by kernel
-	 * with lack of free htlb page in cpuset that the task is in.
-	 * Attempt to enforce strict accounting with cpuset is almost
-	 * impossible (or too ugly) because cpuset is too fluid that
-	 * task or memory node can be dynamically moved between cpusets.
-	 *
-	 * The change of semantics for shared hugetlb mapping with cpuset is
-	 * undesirable. However, in order to preserve some of the semantics,
-	 * we fall back to check against current free page availability as
-	 * a best attempt and hopefully to minimize the impact of changing
-	 * semantics that cpuset has.
-	 */
-	if (delta > 0) {
-		if (gather_surplus_pages(delta) < 0)
-			goto out;
-
-		if (delta > cpuset_mems_nr(free_huge_pages_node)) {
-			return_unused_surplus_pages(delta);
-			goto out;
-		}
-	}
-
-	ret = 0;
-	if (delta < 0)
-		return_unused_surplus_pages((unsigned long) -delta);
-
-out:
-	spin_unlock(&hugetlb_lock);
-	return ret;
-}
-
 int hugetlb_reserve_pages(struct inode *inode, long from, long to)
 {
 	long ret, chg;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

