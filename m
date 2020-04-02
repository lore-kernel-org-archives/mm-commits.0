From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 048/155] mm: improve dump_page() for compound
 pages
Date: Wed, 01 Apr 2020 21:05:49 -0700
Message-ID: <20200402040549.UuGxPWRJI%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEFv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:05:51 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org

=46rom: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: improve dump_page() for compound pages

There was no protection against a corrupted struct page having an
implausible compound_head().  Sanity check that a compound page has a head
within reach of the maximum allocatable page (this will need to be
adjusted if one of the plans to allocate 1GB pages comes to fruition).  In
addition,

 - Print the mapping pointer using %p insted of %px.  The actual value of
   the pointer can be read out of the raw page dump and using %p gives a
   chance to correlate it with an earlier printk of the mapping pointer
 - Print the mapping pointer from the head page, not the tail page
   (the tail ->mapping pointer may be in use for other purposes, eg part
   of a list_head)
 - Print the order of the page for compound pages
 - Dump the raw head page as well as the raw page
 - Print the refcount from the head page, not the tail page

Link: http://lkml.kernel.org/r/20200211001536.1027652-12-jhubbard@nvidia.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Co-developed-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
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

 mm/debug.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/mm/debug.c~mm-improve-dump_page-for-compound-pages
+++ a/mm/debug.c
@@ -44,8 +44,10 @@ const struct trace_print_flags vmaflag_n
=20
 void __dump_page(struct page *page, const char *reason)
 {
+	struct page *head =3D compound_head(page);
 	struct address_space *mapping;
 	bool page_poisoned =3D PagePoisoned(page);
+	bool compound =3D PageCompound(page);
 	/*
 	 * Accessing the pageblock without the zone lock. It could change to
 	 * "isolate" again in the meantime, but since we are just dumping the
@@ -66,25 +68,32 @@ void __dump_page(struct page *page, cons
 		goto hex_only;
 	}
=20
-	mapping =3D page_mapping(page);
+	if (page < head || (page >=3D head + MAX_ORDER_NR_PAGES)) {
+		/* Corrupt page, cannot call page_mapping */
+		mapping =3D page->mapping;
+		head =3D page;
+		compound =3D false;
+	} else {
+		mapping =3D page_mapping(page);
+	}
=20
 	/*
 	 * Avoid VM_BUG_ON() in page_mapcount().
 	 * page->_mapcount space in struct page is used by sl[aou]b pages to
 	 * encode own info.
 	 */
-	mapcount =3D PageSlab(page) ? 0 : page_mapcount(page);
+	mapcount =3D PageSlab(head) ? 0 : page_mapcount(page);
=20
-	if (PageCompound(page))
-		pr_warn("page:%px refcount:%d mapcount:%d mapping:%px "
-			"index:%#lx compound_mapcount: %d\n",
-			page, page_ref_count(page), mapcount,
-			page->mapping, page_to_pgoff(page),
-			compound_mapcount(page));
+	if (compound)
+		pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
+			"index:%#lx head:%px order:%u compound_mapcount:%d\n",
+			page, page_ref_count(head), mapcount,
+			mapping, page_to_pgoff(page), head,
+			compound_order(head), compound_mapcount(page));
 	else
-		pr_warn("page:%px refcount:%d mapcount:%d mapping:%px index:%#lx\n",
+		pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
 			page, page_ref_count(page), mapcount,
-			page->mapping, page_to_pgoff(page));
+			mapping, page_to_pgoff(page));
 	if (PageKsm(page))
 		type =3D "ksm ";
 	else if (PageAnon(page))
@@ -106,6 +115,10 @@ hex_only:
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
 			sizeof(struct page), false);
+	if (head !=3D page)
+		print_hex_dump(KERN_WARNING, "head: ", DUMP_PREFIX_NONE, 32,
+			sizeof(unsigned long), head,
+			sizeof(struct page), false);
=20
 	if (reason)
 		pr_warn("page dumped because: %s\n", reason);
_
