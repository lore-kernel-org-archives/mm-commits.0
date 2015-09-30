From: akpm@linux-foundation.org
Subject: + mm-sanitize-page-mapping-for-tail-pages.patch added to -mm tree
Date: Wed, 30 Sep 2015 15:10:04 -0700
Message-ID: <560c5dbc.nu9t3lYCVuaimVaA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbbI3WKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 18:10:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sanitize page->mapping for tail pages
has been added to the -mm tree.  Its filename is
     mm-sanitize-page-mapping-for-tail-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sanitize-page-mapping-f=
or-tail-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sanitize-page-mapping-f=
or-tail-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: sanitize page->mapping for tail pages

We don't define meaning of page->mapping for tail pages.  Currently it'=
s
always NULL, which can be inconsistent with head page and potentially l=
ead
to problems.

Let's poison the pointer to catch all illigal uses.

page_rmapping(), page_mapping() and page_anon_vma() are changed to look=
 on
head page.

The only illegal use I've caught so far is __GPF_COMP pages from sound
subsystem, mapped with PTEs.  do_shared_fault() is changed to use
page_rmapping() instead of direct access to fault_page->mapping.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
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
Cc: Jerome Marchand <jmarchan@redhat.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    4 ++++
 mm/huge_memory.c       |    2 +-
 mm/memory.c            |    2 +-
 mm/page_alloc.c        |    6 ++++++
 mm/util.c              |   10 ++++++----
 5 files changed, 18 insertions(+), 6 deletions(-)

diff -puN include/linux/poison.h~mm-sanitize-page-mapping-for-tail-page=
s include/linux/poison.h
--- a/include/linux/poison.h~mm-sanitize-page-mapping-for-tail-pages
+++ a/include/linux/poison.h
@@ -32,6 +32,10 @@
 /********** mm/debug-pagealloc.c **********/
 #define PAGE_POISON 0xaa
=20
+/********** mm/page_alloc.c ************/
+
+#define TAIL_MAPPING	((void *) 0x01014A11 + POISON_POINTER_DELTA)
+
 /********** mm/slab.c **********/
 /*
  * Magic nums for obj red zoning.
diff -puN mm/huge_memory.c~mm-sanitize-page-mapping-for-tail-pages mm/h=
uge_memory.c
--- a/mm/huge_memory.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/huge_memory.c
@@ -1836,7 +1836,7 @@ static void __split_huge_page_refcount(s
 		*/
 		page_tail->_mapcount =3D page->_mapcount;
=20
-		BUG_ON(page_tail->mapping);
+		BUG_ON(page_tail->mapping !=3D TAIL_MAPPING);
 		page_tail->mapping =3D page->mapping;
=20
 		page_tail->index =3D page->index + i;
diff -puN mm/memory.c~mm-sanitize-page-mapping-for-tail-pages mm/memory=
=2Ec
--- a/mm/memory.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/memory.c
@@ -3087,7 +3087,7 @@ static int do_shared_fault(struct mm_str
 	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
 	 * release semantics to prevent the compiler from undoing this copyin=
g.
 	 */
-	mapping =3D fault_page->mapping;
+	mapping =3D page_rmapping(fault_page);
 	unlock_page(fault_page);
 	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
 		/*
diff -puN mm/page_alloc.c~mm-sanitize-page-mapping-for-tail-pages mm/pa=
ge_alloc.c
--- a/mm/page_alloc.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/page_alloc.c
@@ -473,6 +473,7 @@ void prep_compound_page(struct page *pag
 	for (i =3D 1; i < nr_pages; i++) {
 		struct page *p =3D page + i;
 		set_page_count(p, 0);
+		p->mapping =3D TAIL_MAPPING;
 		set_compound_head(p, page);
 	}
 }
@@ -863,6 +864,10 @@ static int free_tail_pages_check(struct
 		ret =3D 0;
 		goto out;
 	}
+	if (page->mapping !=3D TAIL_MAPPING) {
+		bad_page(page, "corrupted mapping in tail page", 0);
+		goto out;
+	}
 	if (unlikely(!PageTail(page))) {
 		bad_page(page, "PageTail not set", 0);
 		goto out;
@@ -873,6 +878,7 @@ static int free_tail_pages_check(struct
 	}
 	ret =3D 0;
 out:
+	page->mapping =3D NULL;
 	clear_compound_head(page);
 	return ret;
 }
diff -puN mm/util.c~mm-sanitize-page-mapping-for-tail-pages mm/util.c
--- a/mm/util.c~mm-sanitize-page-mapping-for-tail-pages
+++ a/mm/util.c
@@ -355,7 +355,9 @@ struct anon_vma *page_anon_vma(struct pa
=20
 struct address_space *page_mapping(struct page *page)
 {
-	unsigned long mapping;
+	struct address_space *mapping;
+
+	page =3D compound_head(page);
=20
 	/* This happens if someone calls flush_dcache_page on slab page */
 	if (unlikely(PageSlab(page)))
@@ -368,10 +370,10 @@ struct address_space *page_mapping(struc
 		return swap_address_space(entry);
 	}
=20
-	mapping =3D (unsigned long)page->mapping;
-	if (mapping & PAGE_MAPPING_FLAGS)
+	mapping =3D page->mapping;
+	if ((unsigned long)mapping & PAGE_MAPPING_FLAGS)
 		return NULL;
-	return page->mapping;
+	return mapping;
 }
=20
 int overcommit_ratio_handler(struct ctl_table *table, int write,
_

Patches currently in -mm which might be from kirill.shutemov@linux.inte=
l.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.p=
atch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.pat=
ch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.pat=
ch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
