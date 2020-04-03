From: akpm@linux-foundation.org
Subject: [merged]
 mm-dump_page-additional-diagnostics-for-huge-pinned-pages.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:36:53 -0700
Message-ID: <20200403203653.t3JB59yzl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUgz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org


The patch titled
     Subject: mm: dump_page(): additional diagnostics for huge pinned pages
has been removed from the -mm tree.  Its filename was
     mm-dump_page-additional-diagnostics-for-huge-pinned-pages.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm: dump_page(): additional diagnostics for huge pinned pages

As part of pin_user_pages() and related API calls, pages are "dma-pinned".
For the case of compound pages of order > 1, the per-page accounting of
dma pins is accomplished via the 3rd struct page in the compound page.  In
order to support debugging of any pin_user_pages()- related problems,
enhance dump_page() so as to report the pin count in that case.

Documentation/core-api/pin_user_pages.rst is also updated accordingly.

Link: http://lkml.kernel.org/r/20200211001536.1027652-13-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
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

 Documentation/core-api/pin_user_pages.rst |    7 ++++++
 mm/debug.c                                |   21 +++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-dump_page-additional-dia=
gnostics-for-huge-pinned-pages
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -238,6 +238,13 @@ long-term [R]DMA pins in place, or durin
 (...unless it was already out of balance due to a long-term RDMA pin being=
 in
 place.)
=20
+Other diagnostics
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+dump_page() has been enhanced slightly, to handle these new counting field=
s, and
+to better report on compound pages in general. Specifically, for compound =
pages
+with order > 1, the exact (hpage_pinned_refcount) pincount is reported.
+
 References
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
--- a/mm/debug.c~mm-dump_page-additional-diagnostics-for-huge-pinned-pages
+++ a/mm/debug.c
@@ -85,11 +85,22 @@ void __dump_page(struct page *page, cons
 	mapcount =3D PageSlab(head) ? 0 : page_mapcount(page);
=20
 	if (compound)
-		pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
-			"index:%#lx head:%px order:%u compound_mapcount:%d\n",
-			page, page_ref_count(head), mapcount,
-			mapping, page_to_pgoff(page), head,
-			compound_order(head), compound_mapcount(page));
+		if (hpage_pincount_available(page)) {
+			pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
+				"index:%#lx head:%px order:%u "
+				"compound_mapcount:%d compound_pincount:%d\n",
+				page, page_ref_count(head), mapcount,
+				mapping, page_to_pgoff(page), head,
+				compound_order(head), compound_mapcount(page),
+				compound_pincount(page));
+		} else {
+			pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
+				"index:%#lx head:%px order:%u "
+				"compound_mapcount:%d\n",
+				page, page_ref_count(head), mapcount,
+				mapping, page_to_pgoff(page), head,
+				compound_order(head), compound_mapcount(page));
+		}
 	else
 		pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
 			page, page_ref_count(page), mapcount,
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

checkpatch-support-base-commit-format.patch
