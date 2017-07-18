From: akpm@linux-foundation.org
Subject: + mm-mempolicy-add-queue_pages_required.patch added to -mm tree
Date: Tue, 18 Jul 2017 15:27:01 -0700
Message-ID: <596e8b35.gspsrMzsCKKKquqJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752546AbdGRW1D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2017 18:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, minchan@kernel.org, mingo@elte.hu, tglx@linutronix.de, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: add queue_pages_required()
has been added to the -mm tree.  Its filename is
     mm-mempolicy-add-queue_pages_required.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-add-queue_pages_required.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-add-queue_pages_required.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: mempolicy: add queue_pages_required()

Patch series "mm: page migration enhancement for thp", v9.

Motivations
===========================================

1. THP migration becomes important in the upcoming heterogeneous
   memory systems.  As David Nellans from NVIDIA pointed out from other
   threads
   (http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1349227.html),
   future GPUs or other accelerators will have their memory managed by
   operating systems.  Moving data into and out of these memory nodes
   efficiently is critical to applications that use GPUs or other
   accelerators.  Existing page migration only supports base pages, which
   has a very low memory bandwidth utilization.  My experiments (see
   below) show THP migration can migrate pages more efficiently.

2. Base page migration vs THP migration throughput.

Here are cross-socket page migration results from calling move_pages()
syscall:

In x86_64, a Intel two-socket E5-2640v3 box,
single 4KB base page migration takes 62.47 us, using 0.06 GB/s BW,
single 2MB THP migration takes 658.54 us, using 2.97 GB/s BW,
512 4KB base page migration takes 1987.38 us, using 0.98 GB/s BW.

In ppc64, a two-socket Power8 box,
single 64KB base page migration takes 49.3 us, using 1.24 GB/s BW,
single 16MB THP migration takes 2202.17 us, using 7.10 GB/s BW,
256 64KB base page migration takes 2543.65 us, using 6.14 GB/s BW.

THP migration can give us 3x and 1.15x throughput over base page migration
in x86_64 and ppc64 respectivley.

You can test it out by using the code here:
https://github.com/x-y-z/thp-migration-bench

3. Existing page migration splits THP before migration and cannot
   guarantee the migrated pages are still contiguous.  Contiguity is
   always what GPUs and accelerators look for.  Without THP migration,
   khugepaged needs to do extra work to reassemble the migrated pages back
   to THPs.



This patch (of 10):

Introduce a separate check routine related to MPOL_MF_INVERT flag.  This
patch just does cleanup, no behavioral change.

Link: http://lkml.kernel.org/r/20170717193955.20207-2-zi.yan@sent.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-add-queue_pages_required mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-add-queue_pages_required
+++ a/mm/mempolicy.c
@@ -412,6 +412,21 @@ struct queue_pages {
 };
 
 /*
+ * Check if the page's nid is in qp->nmask.
+ *
+ * If MPOL_MF_INVERT is set in qp->flags, check if the nid is
+ * in the invert of qp->nmask.
+ */
+static inline bool queue_pages_required(struct page *page,
+					struct queue_pages *qp)
+{
+	int nid = page_to_nid(page);
+	unsigned long flags = qp->flags;
+
+	return node_isset(nid, *qp->nmask) == !(flags & MPOL_MF_INVERT);
+}
+
+/*
  * Scan through pages checking if pages follow certain conditions,
  * and move them to the pagelist if they do.
  */
@@ -464,8 +479,7 @@ retry:
 		 */
 		if (PageReserved(page))
 			continue;
-		nid = page_to_nid(page);
-		if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
+		if (!queue_pages_required(page, qp))
 			continue;
 		if (PageTransCompound(page)) {
 			get_page(page);
@@ -497,7 +511,6 @@ static int queue_pages_hugetlb(pte_t *pt
 #ifdef CONFIG_HUGETLB_PAGE
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
-	int nid;
 	struct page *page;
 	spinlock_t *ptl;
 	pte_t entry;
@@ -507,8 +520,7 @@ static int queue_pages_hugetlb(pte_t *pt
 	if (!pte_present(entry))
 		goto unlock;
 	page = pte_page(entry);
-	nid = page_to_nid(page);
-	if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
+	if (!queue_pages_required(page, qp))
 		goto unlock;
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-mempolicy-add-queue_pages_required.patch
mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1.patch
mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch
mm-thp-introduce-config_arch_enable_thp_migration.patch
mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration.patch
mm-mempolicy-mbind-and-migrate_pages-support-thp-migration.patch
mm-migrate-move_pages-supports-thp-migration.patch
mm-memory_hotplug-memory-hotremove-supports-thp-migration.patch

