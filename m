From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-writeback-add-callbacks-for-inaccessible-pages.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:36:56 -0700
Message-ID: <20200403203656.SxjH2QEMM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUg6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, david@redhat.com, hch@infradead.org, imbrenda@linux.ibm.com, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, will@kernel.org, willy@infradead.org


The patch titled
     Subject: mm/gup/writeback: add callbacks for inaccessible pages
has been removed from the -mm tree.  Its filename was
     mm-gup-writeback-add-callbacks-for-inaccessible-pages.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: mm/gup/writeback: add callbacks for inaccessible pages

With the introduction of protected KVM guests on s390 there is now a
concept of inaccessible pages.  These pages need to be made accessible
before the host can access them.

While cpu accesses will trigger a fault that can be resolved, I/O accesses
will just fail.  We need to add a callback into architecture code for
places that will do I/O, namely when writeback is started or when a page
reference is taken.

This is not only to enable paging, file backing etc, it is also necessary
to protect the host against a malicious user space.  For example a bad
QEMU could simply start direct I/O on such protected memory.  We do not
want userspace to be able to trigger I/O errors and thus the logic is
"whenever somebody accesses that page (gup) or does I/O, make sure that
this page can be accessed".  When the guest tries to access that page we
will wait in the page fault handler for writeback to have finished and for
the page_ref to be the expected value.

On s390x the function is not supposed to fail, so it is ok to use a
WARN_ON on failure.  If we ever need some more finegrained handling we can
tackle this when we know the details.

Link: http://lkml.kernel.org/r/20200306132537.783769-3-imbrenda@linux.ibm.c=
om
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
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

 include/linux/gfp.h |    6 ++++++
 mm/gup.c            |   30 +++++++++++++++++++++++++++---
 mm/page-writeback.c |    9 ++++++++-
 3 files changed, 41 insertions(+), 4 deletions(-)

--- a/include/linux/gfp.h~mm-gup-writeback-add-callbacks-for-inaccessible-p=
ages
+++ a/include/linux/gfp.h
@@ -485,6 +485,12 @@ static inline void arch_free_page(struct
 #ifndef HAVE_ARCH_ALLOC_PAGE
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
+#ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
+static inline int arch_make_page_accessible(struct page *page)
+{
+	return 0;
+}
+#endif
=20
 struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_n=
id,
--- a/mm/gup.c~mm-gup-writeback-add-callbacks-for-inaccessible-pages
+++ a/mm/gup.c
@@ -390,6 +390,7 @@ static struct page *follow_page_pte(stru
 	struct page *page;
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
+	int ret;
=20
 	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
 	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) =3D=3D
@@ -448,8 +449,6 @@ retry:
 		if (is_zero_pfn(pte_pfn(pte))) {
 			page =3D pte_page(pte);
 		} else {
-			int ret;
-
 			ret =3D follow_pfn_pte(vma, address, ptep, flags);
 			page =3D ERR_PTR(ret);
 			goto out;
@@ -457,7 +456,6 @@ retry:
 	}
=20
 	if (flags & FOLL_SPLIT && PageTransCompound(page)) {
-		int ret;
 		get_page(page);
 		pte_unmap_unlock(ptep, ptl);
 		lock_page(page);
@@ -474,6 +472,19 @@ retry:
 		page =3D ERR_PTR(-ENOMEM);
 		goto out;
 	}
+	/*
+	 * We need to make the page accessible if and only if we are going
+	 * to access its content (the FOLL_PIN case).  Please see
+	 * Documentation/core-api/pin_user_pages.rst for details.
+	 */
+	if (flags & FOLL_PIN) {
+		ret =3D arch_make_page_accessible(page);
+		if (ret) {
+			unpin_user_page(page);
+			page =3D ERR_PTR(ret);
+			goto out;
+		}
+	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
@@ -2163,6 +2174,19 @@ static int gup_pte_range(pmd_t pmd, unsi
=20
 		VM_BUG_ON_PAGE(compound_head(page) !=3D head, page);
=20
+		/*
+		 * We need to make the page accessible if and only if we are
+		 * going to access its content (the FOLL_PIN case).  Please
+		 * see Documentation/core-api/pin_user_pages.rst for
+		 * details.
+		 */
+		if (flags & FOLL_PIN) {
+			ret =3D arch_make_page_accessible(page);
+			if (ret) {
+				unpin_user_page(page);
+				goto pte_unmap;
+			}
+		}
 		SetPageReferenced(page);
 		pages[*nr] =3D page;
 		(*nr)++;
--- a/mm/page-writeback.c~mm-gup-writeback-add-callbacks-for-inaccessible-p=
ages
+++ a/mm/page-writeback.c
@@ -2764,7 +2764,7 @@ int test_clear_page_writeback(struct pag
 int __test_set_page_writeback(struct page *page, bool keep_write)
 {
 	struct address_space *mapping =3D page_mapping(page);
-	int ret;
+	int ret, access_ret;
=20
 	lock_page_memcg(page);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
@@ -2807,6 +2807,13 @@ int __test_set_page_writeback(struct pag
 		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 	}
 	unlock_page_memcg(page);
+	access_ret =3D arch_make_page_accessible(page);
+	/*
+	 * If writeback has been triggered on a page that cannot be made
+	 * accessible, it is too late to recover here.
+	 */
+	VM_BUG_ON_PAGE(access_ret !=3D 0, page);
+
 	return ret;
=20
 }
_

Patches currently in -mm which might be from imbrenda@linux.ibm.com are
