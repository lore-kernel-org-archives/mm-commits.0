From: akpm@linux-foundation.org
Subject: +
 page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch added to -mm tree
Date: Tue, 06 Oct 2015 12:28:28 -0700
Message-ID: <561420dc.QobhKdhTsoZDWkLy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbbJFT23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 15:28:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: clear PG_reserved before setting PG_head on gigantic pages
has been added to the -mm tree.  Its filename is
     page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch

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
Subject: hugetlb: clear PG_reserved before setting PG_head on gigantic pages

PF_NO_COMPOUND for PG_reserved assumes we don't use PG_reserved for
compound pages.  And we generally don't.  But during allocation of
gigantic pages we set PG_head before clearing PG_reserved and
__ClearPageReserved() steps on the VM_BUG_ON_PAGE().

The fix is trivial: set PG_head after PG_reserved.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~page-flags-define-pg_reserved-behavior-on-compound-pages-fix mm/hugetlb.c
--- a/mm/hugetlb.c~page-flags-define-pg_reserved-behavior-on-compound-pages-fix
+++ a/mm/hugetlb.c
@@ -1258,8 +1258,8 @@ static void prep_compound_gigantic_page(
 
 	/* we rely on prep_new_huge_page to set the destructor */
 	set_compound_order(page, order);
-	__SetPageHead(page);
 	__ClearPageReserved(page);
+	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		/*
 		 * For gigantic hugepages allocated through bootmem at
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

