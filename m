From: akpm@linux-foundation.org
Subject: [merged] mm-numa-skip-pte-mapped-thp-on-numa-fault.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:02:38 -0800
Message-ID: <569e965e.L/SHMbentL7t7q7W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbcASUCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, numa: skip PTE-mapped THP on numa fault
has been removed from the -mm tree.  Its filename was
     mm-numa-skip-pte-mapped-thp-on-numa-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, numa: skip PTE-mapped THP on numa fault

We're going to have THP mapped with PTEs. It will confuse numabalancing.
Let's skip them for now.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/memory.c~mm-numa-skip-pte-mapped-thp-on-numa-fault mm/memory.c
--- a/mm/memory.c~mm-numa-skip-pte-mapped-thp-on-numa-fault
+++ a/mm/memory.c
@@ -3193,6 +3193,12 @@ static int do_numa_page(struct mm_struct
 		return 0;
 	}
 
+	/* TODO: handle PTE-mapped THP */
+	if (PageCompound(page)) {
+		pte_unmap_unlock(ptep, ptl);
+		return 0;
+	}
+
 	/*
 	 * Avoid grouping on RO pages in general. RO pages shouldn't hurt as
 	 * much anyway since they can be in shared cache state. This misses
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

