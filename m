From: akpm@linux-foundation.org
Subject: + mm-verify-compound-order-when-freeing-a-page.patch added to -mm tree
Date: Wed, 15 Oct 2014 12:31:03 -0700
Message-ID: <543ecb77.xKsf1r0MOS76uAfg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaJOTbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 15:31:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, lliubbo@gmail.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: verify compound order when freeing a page
has been added to the -mm tree.  Its filename is
     mm-verify-compound-order-when-freeing-a-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-verify-compound-order-when-freeing-a-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-verify-compound-order-when-freeing-a-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: verify compound order when freeing a page

This allows us to catch the bug fixed in the previous patch (mm: free
compound page with correct order).

Here we also verify whether a page is tail page or not -- tail pages are
supposed to be freed along with their head, not by themselves.

Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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
@@ -750,6 +750,9 @@ static bool free_pages_prepare(struct pa
 	int i;
 	int bad = 0;
 
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(PageHead(page) && compound_order(page) != order, page);
+
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-free-compound-page-with-correct-order.patch
mm-verify-compound-order-when-freeing-a-page.patch

