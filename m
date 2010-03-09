From: akpm@linux-foundation.org
Subject: [merged] rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:10 -0800
Message-ID: <201003091904.o29J4Ari031026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613Ab0CITEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, Lee.Schermerhorn@hp.com, aarcange@redhat.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, minchan.kim@gmail.com, mm-commits@vger.


The patch titled
     rmap: remove obsolete check from __page_check_anon_rmap()
has been removed from the -mm tree.  Its filename was
     rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rmap: remove obsolete check from __page_check_anon_rmap()
From: Rik van Riel <riel@redhat.com>

When an anonymous page is inherited from a parent process, the
vma->anon_vma can differ from the page anon_vma.  This can trip up
__page_check_anon_rmap, which is indirectly called from do_swap_page().

Remove that obsolete check to prevent an oops.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/rmap.c~rmap-remove-obsolete-check-from-__page_check_anon_rmap mm/rmap.c
--- a/mm/rmap.c~rmap-remove-obsolete-check-from-__page_check_anon_rmap
+++ a/mm/rmap.c
@@ -754,9 +754,6 @@ static void __page_check_anon_rmap(struc
 	 * are initially only visible via the pagetables, and the pte is locked
 	 * over the call to page_add_new_anon_rmap.
 	 */
-	struct anon_vma *anon_vma = vma->anon_vma;
-	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
-	BUG_ON(page->mapping != (struct address_space *)anon_vma);
 	BUG_ON(page->index != linear_page_index(vma, address));
 #endif
 }
_

Patches currently in -mm which might be from riel@redhat.com are

fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch

