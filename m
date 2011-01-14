From: akpm@linux-foundation.org
Subject: [merged] thp-comment-reminder-in-destroy_compound_page.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:44 -0800
Message-ID: <201101142249.p0EMnYLr005305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1ANWtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: comment reminder in destroy_compound_page
has been removed from the -mm tree.  Its filename was
     thp-comment-reminder-in-destroy_compound_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: comment reminder in destroy_compound_page
From: Andrea Arcangeli <aarcange@redhat.com>

Warn destroy_compound_page that __split_huge_page_refcount is heavily
dependent on its internal behavior.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~thp-comment-reminder-in-destroy_compound_page mm/page_alloc.c
--- a/mm/page_alloc.c~thp-comment-reminder-in-destroy_compound_page
+++ a/mm/page_alloc.c
@@ -357,6 +357,7 @@ void prep_compound_page(struct page *pag
 	}
 }
 
+/* update __split_huge_page_refcount if you change this function */
 static int destroy_compound_page(struct page *page, unsigned long order)
 {
 	int i;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

