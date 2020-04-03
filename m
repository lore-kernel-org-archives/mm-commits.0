From: akpm@linux-foundation.org
Subject: [merged] mm-gup-pass-gup-flags-to-two-more-routines.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:36:34 -0700
Message-ID: <20200403203634.kzvjGYZ7r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUgi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org


The patch titled
     Subject: mm/gup: pass gup flags to two more routines
has been removed from the -mm tree.  Its filename was
     mm-gup-pass-gup-flags-to-two-more-routines.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: pass gup flags to two more routines

In preparation for an upcoming patch, send gup flags args to two more
routines: put_compound_head(), and undo_dev_pagemap().

Link: http://lkml.kernel.org/r/20200211001536.1027652-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/gup.c~mm-gup-pass-gup-flags-to-two-more-routines
+++ a/mm/gup.c
@@ -1870,6 +1870,7 @@ static inline pte_t gup_get_pte(pte_t *p
 #endif /* CONFIG_GUP_GET_PTE_LOW_HIGH */
=20
 static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
+					    unsigned int flags,
 					    struct page **pages)
 {
 	while ((*nr) - nr_start) {
@@ -1909,7 +1910,7 @@ static int gup_pte_range(pmd_t pmd, unsi
=20
 			pgmap =3D get_dev_pagemap(pte_pfn(pte), pgmap);
 			if (unlikely(!pgmap)) {
-				undo_dev_pagemap(nr, nr_start, pages);
+				undo_dev_pagemap(nr, nr_start, flags, pages);
 				goto pte_unmap;
 			}
 		} else if (pte_special(pte))
@@ -1974,7 +1975,7 @@ static int __gup_device_huge(unsigned lo
=20
 		pgmap =3D get_dev_pagemap(pfn, pgmap);
 		if (unlikely(!pgmap)) {
-			undo_dev_pagemap(nr, nr_start, pages);
+			undo_dev_pagemap(nr, nr_start, flags, pages);
 			return 0;
 		}
 		SetPageReferenced(page);
@@ -2001,7 +2002,7 @@ static int __gup_device_huge_pmd(pmd_t o
 		return 0;
=20
 	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
-		undo_dev_pagemap(nr, nr_start, pages);
+		undo_dev_pagemap(nr, nr_start, flags, pages);
 		return 0;
 	}
 	return 1;
@@ -2019,7 +2020,7 @@ static int __gup_device_huge_pud(pud_t o
 		return 0;
=20
 	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
-		undo_dev_pagemap(nr, nr_start, pages);
+		undo_dev_pagemap(nr, nr_start, flags, pages);
 		return 0;
 	}
 	return 1;
@@ -2053,7 +2054,7 @@ static int record_subpages(struct page *
 	return nr;
 }
=20
-static void put_compound_head(struct page *page, int refs)
+static void put_compound_head(struct page *page, int refs, unsigned int fl=
ags)
 {
 	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
 	/*
@@ -2103,7 +2104,7 @@ static int gup_hugepte(pte_t *ptep, unsi
 		return 0;
=20
 	if (unlikely(pte_val(pte) !=3D pte_val(*ptep))) {
-		put_compound_head(head, refs);
+		put_compound_head(head, refs, flags);
 		return 0;
 	}
=20
@@ -2163,7 +2164,7 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		return 0;
=20
 	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
-		put_compound_head(head, refs);
+		put_compound_head(head, refs, flags);
 		return 0;
 	}
=20
@@ -2197,7 +2198,7 @@ static int gup_huge_pud(pud_t orig, pud_
 		return 0;
=20
 	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
-		put_compound_head(head, refs);
+		put_compound_head(head, refs, flags);
 		return 0;
 	}
=20
@@ -2226,7 +2227,7 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 		return 0;
=20
 	if (unlikely(pgd_val(orig) !=3D pgd_val(*pgdp))) {
-		put_compound_head(head, refs);
+		put_compound_head(head, refs, flags);
 		return 0;
 	}
=20
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

checkpatch-support-base-commit-format.patch
