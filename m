From: akpm@linux-foundation.org
Subject: [folded-merged] mm-make-compound_head-robust-fix.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 16:12:05 -0800
Message-ID: <563d41d5.0F8mKGxN+4hbpqf9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358AbbKGAMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:12:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid false-positive PageTail() during meminit
has been removed from the -mm tree.  Its filename was
     mm-make-compound_head-robust-fix.patch

This patch was dropped because it was folded into mm-make-compound_head-robust.patch

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

mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch

