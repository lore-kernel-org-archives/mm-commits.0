From: akpm@linux-foundation.org
Subject: [merged]
 mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:37:44 -0700
Message-ID: <5591ac98.fLmxnSOdXtZ1Vken%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbbF2Uhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, bp@alien8.de, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop bogus VM_BUG_ON_PAGE assert in put_page() codepath
has been removed from the -mm tree.  Its filename was
     mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop bogus VM_BUG_ON_PAGE assert in put_page() codepath

My patch 8d63d99a5dfb ("mm: avoid tail page refcounting on non-THP
compound pages") which was merged during 4.1 merge window caused
regression:

  page:ffffea0010a15040 count:0 mapcount:1 mapping:          (null) index:0x0
  flags: 0x8000000000008014(referenced|dirty|tail)
  page dumped because: VM_BUG_ON_PAGE(page_mapcount(page) != 0)
  ------------[ cut here ]------------
  kernel BUG at mm/swap.c:134!

The problem can be reproduced by playing *two* audio files at the same
time and then stopping one of players.  I used two mplayers to trigger
this.

The VM_BUG_ON_PAGE() which triggers the bug is bogus:

Sound subsystem uses compound pages for its buffers, but unlike most
__GFP_COMP sound maps compound pages to userspace with PTEs.

In our case with two players map the buffer twice and therefore elevates
page_mapcount() on tail pages by two.  When one of players exits it unmaps
the VMA and drops page_mapcount() to one and try to release reference on
the page with put_page().

My commit changes which path it takes under put_compound_page().  It hits
put_unrefcounted_compound_page() where VM_BUG_ON_PAGE() is.  It sees
page_mapcount() == 1.  The function wrongly assumes that subpages of
compound page cannot be be mapped by itself with PTEs..

The solution is simply drop the VM_BUG_ON_PAGE().

Note: there's no need to move the check under put_page_testzero(). 
Allocator will check the mapcount by itself before putting on free list.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Borislav Petkov <bp@alien8.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/swap.c~mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath mm/swap.c
--- a/mm/swap.c~mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath
+++ a/mm/swap.c
@@ -131,7 +131,6 @@ void put_unrefcounted_compound_page(stru
 		 * here, see the comment above this function.
 		 */
 		VM_BUG_ON_PAGE(!PageHead(page_head), page_head);
-		VM_BUG_ON_PAGE(page_mapcount(page) != 0, page);
 		if (put_page_testzero(page_head)) {
 			/*
 			 * If this is the tail of a slab THP page,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
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
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch

