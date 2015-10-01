From: akpm@linux-foundation.org
Subject: + mm-make-compound_head-robust-fix.patch added to -mm tree
Date: Thu, 01 Oct 2015 13:52:22 -0700
Message-ID: <560d9d06.PpgJGA+L4hPBgn7P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbbJAUwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 16:52:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid false-positive PageTail() during meminit
has been added to the -mm tree.  Its filename is
     mm-make-compound_head-robust-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-compound_head-robust-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-compound_head-robust-fix.patch

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
Subject: mm: avoid false-positive PageTail() during meminit

Since compound_head() rework we encode PageTail() into bit 0 of
page->lru.next (aka page->compound_head).  We need to make sure that
page->lru is initialized before first use of compound_head() or
PageTail().

My page-flags patchset makes sure that we don't use PG_reserved on
compound pages.  That means we have PageTail() check as eary as in
SetPageReserved() in reserve_bootmem_region()

Let's initialize page->lru before that to avoid false positive from
PageTail().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-make-compound_head-robust-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-compound_head-robust-fix
+++ a/mm/page_alloc.c
@@ -922,8 +922,6 @@ static void init_reserved_page(unsigned
 #else
 static inline void init_reserved_page(unsigned long pfn)
 {
-	/* Avoid false-positive PageTail() */
-	INIT_LIST_HEAD(&pfn_to_page(pfn)->lru);
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
@@ -943,6 +941,10 @@ void __meminit reserve_bootmem_region(un
 			struct page *page = pfn_to_page(start_pfn);
 
 			init_reserved_page(start_pfn);
+
+			/* Avoid false-positive PageTail() */
+			INIT_LIST_HEAD(&page->lru);
+
 			SetPageReserved(page);
 		}
 	}
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
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

