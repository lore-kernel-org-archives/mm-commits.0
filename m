From: akpm@linux-foundation.org
Subject: - mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:15 -0800
Message-ID: <200901072211.n07MBFps011527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbZAGWLU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Brice.Goglin@inria.fr, cl@linux-foundation.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: move_pages: no need to set pp->page to ZERO_PAGE(0) by default
has been removed from the -mm tree.  Its filename was
     mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move_pages: no need to set pp->page to ZERO_PAGE(0) by default
From: Brice Goglin <Brice.Goglin@inria.fr>

pp->page is never used when not set to the right page, so there is no need
to set it to ZERO_PAGE(0) by default.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/migrate.c~mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default mm/migrate.c
--- a/mm/migrate.c~mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default
+++ a/mm/migrate.c
@@ -848,12 +848,6 @@ static int do_move_page_to_node_array(st
 		struct vm_area_struct *vma;
 		struct page *page;
 
-		/*
-		 * A valid page pointer that will not match any of the
-		 * pages that will be moved.
-		 */
-		pp->page = ZERO_PAGE(0);
