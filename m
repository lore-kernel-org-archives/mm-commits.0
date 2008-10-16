From: akpm@linux-foundation.org
Subject: + mm-stop-returning-enoent-from-sys_move_pages-if-nothing-got-migrated.patch added to -mm tree
Date: Thu, 16 Oct 2008 13:47:33 -0700
Message-ID: <200810162047.m9GKlXsj017220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821AbYJPUrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Brice.Goglin@inria.fr, cl@linux-foundation.org, nickpiggin@yahoo.com.au


The patch titled
     mm: stop returning -ENOENT from sys_move_pages() if nothing got migrated
has been added to the -mm tree.  Its filename is
     mm-stop-returning-enoent-from-sys_move_pages-if-nothing-got-migrated.patch

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
Subject: mm: stop returning -ENOENT from sys_move_pages() if nothing got migrated
From: Brice Goglin <Brice.Goglin@inria.fr>

A patchset reworking sys_move_pages().  It removes the possibly large
vmalloc by using multiple chunks when migrating large buffers.  It also
dramatically increases the throughput for large buffers since the lookup
in new_page_node() is now limited to a single chunk, causing the quadratic
complexity to have a much slower impact.  There is no need to use any
radix-tree-like structure to improve this lookup.

sys_move_pages() duration on a 4-quadcore-opteron 2347HE (1.9Gz),
migrating between nodes #2 and #3:

	length		move_pages (us)		move_pages+patch (us)
	4kB		126			98
	40kB		198			168
	400kB		963			937
	4MB		12503			11930
	40MB		246867			11848

Patches #1 and #4 are the important ones:
1) stop returning -ENOENT from sys_move_pages() if nothing got migrated
2) don't vmalloc a huge page_to_node array for do_pages_stat()
3) extract do_pages_move() out of sys_move_pages()
4) rework do_pages_move() to work on page_sized chunks
5) move_pages: no need to set pp->page to ZERO_PAGE(0) by default



This patch:

There is no point in returning -ENOENT from sys_move_pages() if all pages
were already on the right node, while we return 0 if only 1 page was not. 
Most application don't know where their pages are allocated, so it's not
an error to try to migrate them anyway.

Just return 0 and let the status array in user-space be checked if the
application needs details.

It will make the upcoming chunked-move_pages() support much easier.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-stop-returning-enoent-from-sys_move_pages-if-nothing-got-migrated mm/migrate.c
--- a/mm/migrate.c~mm-stop-returning-enoent-from-sys_move_pages-if-nothing-got-migrated
+++ a/mm/migrate.c
@@ -896,11 +896,10 @@ set_status:
 		pp->status = err;
 	}
 
+	err = 0;
 	if (!list_empty(&pagelist))
 		err = migrate_pages(&pagelist, new_page_node,
 				(unsigned long)pm);
-	else
-		err = -ENOENT;
 
 	up_read(&mm->mmap_sem);
 	return err;
_

Patches currently in -mm which might be from Brice.Goglin@inria.fr are

mm-stop-returning-enoent-from-sys_move_pages-if-nothing-got-migrated.patch
mm-dont-vmalloc-a-huge-page_to_node-array-for-do_pages_stat.patch
mm-extract-do_pages_move-out-of-sys_move_pages.patch
mm-rework-do_pages_move-to-work-on-page_sized-chunks.patch
mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch

