From: akpm@linux-foundation.org
Subject: [merged]
 page-flags-define-pg_uptodate-behavior-on-compound-pages.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:01:08 -0800
Message-ID: <569e9604.fFKZ7aoOtMs1mIwr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016AbcASUBJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: define PG_uptodate behavior on compound pages
has been removed from the -mm tree.  Its filename was
     page-flags-define-pg_uptodate-behavior-on-compound-pages.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: define PG_uptodate behavior on compound pages

We use PG_uptodate on head pages on transparent huge page.
Let's use PF_NO_TAIL.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: J=E9r=F4me Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-define-pg_uptodate-beha=
vior-on-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-define-pg_uptodate-behavior=
-on-compound-pages
+++ a/include/linux/page-flags.h
@@ -404,8 +404,9 @@ u64 stable_page_flags(struct page *page)
=20
 static inline int PageUptodate(struct page *page)
 {
-	int ret =3D test_bit(PG_uptodate, &(page)->flags);
-
+	int ret;
+	page =3D compound_head(page);
+	ret =3D test_bit(PG_uptodate, &(page)->flags);
 	/*
 	 * Must ensure that the data we read out of the page is loaded
 	 * _after_ we've loaded page->flags to check for PageUptodate.
@@ -422,12 +423,14 @@ static inline int PageUptodate(struct pa
=20
 static inline void __SetPageUptodate(struct page *page)
 {
+	VM_BUG_ON_PAGE(PageTail(page), page);
 	smp_wmb();
 	__set_bit(PG_uptodate, &page->flags);
 }
=20
 static inline void SetPageUptodate(struct page *page)
 {
+	VM_BUG_ON_PAGE(PageTail(page), page);
 	/*
 	 * Memory barrier must be issued before setting the PG_uptodate bit,
 	 * so that all previous stores issued in order to bring the page
@@ -437,7 +440,7 @@ static inline void SetPageUptodate(struc
 	set_bit(PG_uptodate, &page->flags);
 }
=20
-CLEARPAGEFLAG(Uptodate, uptodate, PF_ANY)
+CLEARPAGEFLAG(Uptodate, uptodate, PF_NO_TAIL)
=20
 int test_clear_page_writeback(struct page *page);
 int __test_set_page_writeback(struct page *page, bool keep_write);
_

Patches currently in -mm which might be from kirill.shutemov@linux.inte=
l.com are

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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
