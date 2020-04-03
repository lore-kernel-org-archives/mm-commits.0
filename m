From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-fix-omission-of-check-on-foll_longterm-in-gup-fast-path.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:37:01 -0700
Message-ID: <20200403203701.Wc5n_7ThF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUhC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, hch@infradead.org, hch@lst.de, ira.weiny@intel.com, jgg@mellanox.com, jgg@ziepe.ca, jhubbard@nvidia.com, kernelfans@gmail.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, shuah@kernel.org, willy@infradead.org


The patch titled
     Subject: mm/gup: fix omission of check on FOLL_LONGTERM in gup fast path
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-omission-of-check-on-foll_longterm-in-gup-fast-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pingfan Liu <kernelfans@gmail.com>
Subject: mm/gup: fix omission of check on FOLL_LONGTERM in gup fast path

FOLL_LONGTERM is a special case of FOLL_PIN.  It suggests a pin which is
going to be given to hardware and can't move.  It would truncate CMA
permanently and should be excluded.

In gup slow path, where
__gup_longterm_locked->check_and_migrate_cma_pages() handles
FOLL_LONGTERM, but in fast path, there lacks such a check, which means a
possible leak of CMA page to longterm pinned.

Place a check in try_grab_compound_head() in the fast path to fix the
leak, and if FOLL_LONGTERM happens on CMA, it will fall back to slow path
to migrate the page.

Some note about the check: Huge page's subpages have the same migrate type
due to either allocation from a free_list[] or alloc_contig_range() with
param MIGRATE_MOVABLE.  So it is enough to check on a single subpage by
is_migrate_cma_page(subpage)

Link: http://lkml.kernel.org/r/1584876733-17405-3-git-send-email-kernelfans@gmail.com
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/gup.c~mm-gup-fix-omission-of-check-on-foll_longterm-in-gup-fast-path
+++ a/mm/gup.c
@@ -89,6 +89,14 @@ static __maybe_unused struct page *try_g
 		int orig_refs = refs;
 
 		/*
+		 * Can't do FOLL_LONGTERM + FOLL_PIN with CMA in the gup fast
+		 * path, so fail and let the caller fall back to the slow path.
+		 */
+		if (unlikely(flags & FOLL_LONGTERM) &&
+				is_migrate_cma_page(page))
+			return NULL;
+
+		/*
 		 * When pinning a compound page of order > 1 (which is what
 		 * hpage_pincount_available() checks for), use an exact count to
 		 * track it, via hpage_pincount_add/_sub().
_

Patches currently in -mm which might be from kernelfans@gmail.com are
