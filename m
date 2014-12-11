From: akpm@linux-foundation.org
Subject: [merged] mm-verify-compound-order-when-freeing-a-page.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:29 -0800
Message-ID: <5489e8dd.R+26uL4pe0wgp6VY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857AbaLKS4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, aarcange@redhat.com, kirill@shutemov.name, lliubbo@gmail.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: verify compound order when freeing a page
has been removed from the -mm tree.  Its filename was
     mm-verify-compound-order-when-freeing-a-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: verify compound order when freeing a page

This allows us to catch the bug fixed in the previous patch (mm: free
compound page with correct order).

Here we also verify whether a page is tail page or not -- tail pages are
supposed to be freed along with their head, not by themselves.

Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-verify-compound-order-when-freeing-a-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-verify-compound-order-when-freeing-a-page
+++ a/mm/page_alloc.c
@@ -741,6 +741,9 @@ static bool free_pages_prepare(struct pa
 	int i;
 	int bad = 0;
 
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(PageHead(page) && compound_order(page) != order, page);
+
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
 
_

Patches currently in -mm which might be from yuzhao@google.com are

origin.patch
linux-next.patch

