From: akpm@linux-foundation.org
Subject: [alternative-merged]
 page-owners-correct-page-order-when-to-free-page.patch removed from -mm
 tree
Date: Tue, 25 Nov 2014 13:55:03 -0800
Message-ID: <5474fab7.MgLzK0Y+/gkybHPL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaKYVzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 16:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jungsoo.son@lge.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: page owners: correct page->order when to free page
has been removed from the -mm tree.  Its filename was
     page-owners-correct-page-order-when-to-free-page.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Jungsoo Son <jungsoo.son@lge.com>
Subject: page owners: correct page->order when to free page

When I use PAGE_OWNER in mmotm tree, I found a problem that mismatches the
number of allocated pages.  When I investigate, the problem is that
set_page_order is called for only a head page if freed page is merged to a
higher order page in the buddy allocator so tail pages of the higher order
page couldn't be reset to page->order = -1.

It means when we do 'cat /proc/page-owner', it could show wrong
information.

So page->order should be set to -1 for all the tail pages as well as the
first page before buddy allocator merges them.

This patch is for clearing page->order of all the tail pages in
free_pages_prepare() when to free page.

Signed-off-by: Jungsoo Son <jungsoo.son@lge.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/page_alloc.c~page-owners-correct-page-order-when-to-free-page mm/page_alloc.c
--- a/mm/page_alloc.c~page-owners-correct-page-order-when-to-free-page
+++ a/mm/page_alloc.c
@@ -766,6 +766,13 @@ static bool free_pages_prepare(struct pa
 	if (bad)
 		return false;
 
+#ifdef CONFIG_PAGE_OWNER
+	for (i = 0; i < (1 << order); i++) {
+		struct page *p = (page + i);
+		p->order = -1;
+	}
+#endif
+
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page),
 					   PAGE_SIZE << order);
_

Patches currently in -mm which might be from jungsoo.son@lge.com are

mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch

