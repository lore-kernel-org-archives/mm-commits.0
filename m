From: akpm@linux-foundation.org
Subject: + mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch added to -mm tree
Date: Thu, 16 Oct 2008 13:47:44 -0700
Message-ID: <200810162047.m9GKliwM017246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870AbYJPUrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:47:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Brice.Goglin@inria.fr, cl@linux-foundation.org, nickpiggin@yahoo.com.au


The patch titled
     mm: move_pages: no need to set pp->page to ZERO_PAGE(0) by default
has been added to the -mm tree.  Its filename is
     mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
@@ -846,12 +846,6 @@ static int do_move_page_to_node_array(st
 		struct vm_area_struct *vma;
 		struct page *page;
 
-		/*
-		 * A valid page pointer that will not match any of the
-		 * pages that will be moved.
-		 */
-		pp->page = ZERO_PAGE(0);
