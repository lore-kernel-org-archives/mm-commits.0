From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-dump_page-additional-diagnostics-for-huge-pinned-pages.patch added to
 -mm tree
Date: Mon, 10 Feb 2020 21:51:02 -0800
Message-ID: <20200211055102.haL8nihuk%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbgBKFvE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 00:51:04 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org


The patch titled
     Subject: mm: dump_page(): additional diagnostics for huge pinned pages
has been added to the -mm tree.  Its filename is
     mm-dump_page-additional-diagnostics-for-huge-pinned-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dump_page-additional-diagno=
stics-for-huge-pinned-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dump_page-additional-diagno=
stics-for-huge-pinned-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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

mm-gup-split-get_user_pages_remote-into-two-routines.patch
mm-gup-pass-a-flags-arg-to-__gup_device_-functions.patch
mm-introduce-page_ref_sub_return.patch
mm-gup-pass-gup-flags-to-two-more-routines.patch
mm-gup-require-foll_get-for-get_user_pages_fast.patch
mm-gup-track-foll_pin-pages.patch
mm-gup-page-hpage_pinned_refcount-exact-pin-counts-for-huge-pages.patch
mm-gup-proc-vmstat-pin_user_pages-foll_pin-reporting.patch
mm-gup_benchmark-support-pin_user_pages-and-related-calls.patch
selftests-vm-run_vmtests-invoke-gup_benchmark-with-basic-foll_pin-coverage.=
patch
mm-dump_page-additional-diagnostics-for-huge-pinned-pages.patch
