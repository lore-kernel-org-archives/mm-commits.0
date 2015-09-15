From: akpm@linux-foundation.org
Subject: + zsmalloc-use-page-private-instead-of-page-first_page.patch
 added to -mm tree
Date: Tue, 15 Sep 2015 15:12:56 -0700
Message-ID: <55f897e8.Fq4zT9+eCtgOTqFp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbbIOWM5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:12:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, paulmck@linux.vnet.ibm.com, rientjes@google.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use page->private instead of page->first_page
has been added to the -mm tree.  Its filename is
     zsmalloc-use-page-private-instead-of-page-first_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-use-page-private-instead-of-page-first_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-use-page-private-instead-of-page-first_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: zsmalloc: use page->private instead of page->first_page

We are going to rework how compound_head() work. It will not use
page->first_page as we have it now.

The only other user of page->first_page beyond compound pages is
zsmalloc.

Let's use page->private instead of page->first_page here. It occupies
the same storage space.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-page-private-instead-of-page-first_page mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-page-private-instead-of-page-first_page
+++ a/mm/zsmalloc.c
@@ -16,7 +16,7 @@
  * struct page(s) to form a zspage.
  *
  * Usage of struct page fields:
- *	page->first_page: points to the first component (0-order) page
+ *	page->private: points to the first component (0-order) page
  *	page->index (union with page->freelist): offset of the first object
  *		starting in this page. For the first page, this is
  *		always 0, so we use this field (aka freelist) to point
@@ -26,8 +26,7 @@
  *
  *	For _first_ page only:
  *
- *	page->private (union with page->first_page): refers to the
- *		component page after the first page
+ *	page->private: refers to the component page after the first page
  *		If the page is first_page for huge object, it stores handle.
  *		Look at size_class->huge.
  *	page->freelist: points to the first free object in zspage.
@@ -764,7 +763,7 @@ static struct page *get_first_page(struc
 	if (is_first_page(page))
 		return page;
 	else
-		return page->first_page;
+		return (struct page *)page_private(page);
 }
 
 static struct page *get_next_page(struct page *page)
@@ -949,7 +948,7 @@ static struct page *alloc_zspage(struct
 	 * Allocate individual pages and link them together as:
 	 * 1. first page->private = first sub-page
 	 * 2. all sub-pages are linked together using page->lru
-	 * 3. each sub-page is linked to the first page using page->first_page
+	 * 3. each sub-page is linked to the first page using page->private
 	 *
 	 * For each size class, First/Head pages are linked together using
 	 * page->lru. Also, we set PG_private to identify the first page
@@ -974,7 +973,7 @@ static struct page *alloc_zspage(struct
 		if (i == 1)
 			set_page_private(first_page, (unsigned long)page);
 		if (i >= 1)
-			page->first_page = first_page;
+			set_page_private(page, (unsigned long)first_page);
 		if (i >= 2)
 			list_add(&page->lru, &prev_page->lru);
 		if (i == class->pages_per_zspage - 1)	/* last page */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

