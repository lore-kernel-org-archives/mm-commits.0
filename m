From: akpm@linux-foundation.org
Subject: - mm-rework-do_pages_move-to-work-on-page_sized-chunks-update.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:12:11 -0800
Message-ID: <200901062012.n06KCBbn010080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbZAFUMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:12:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Brice.Goglin@inria.fr, Nathalie.Furmento@labri.fr, cl@linux-foundation.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm-rework-do_pages_move-to-work-on-page_sized-chunks update
has been removed from the -mm tree.  Its filename was
     mm-rework-do_pages_move-to-work-on-page_sized-chunks-update.patch

This patch was dropped because it was folded into mm-rework-do_pages_move-to-work-on-page_sized-chunks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-rework-do_pages_move-to-work-on-page_sized-chunks update
From: Brice Goglin <Brice.Goglin@inria.fr>

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Nathalie Furmento <Nathalie.Furmento@labri.fr>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/migrate.c~mm-rework-do_pages_move-to-work-on-page_sized-chunks-update mm/migrate.c
--- a/mm/migrate.c~mm-rework-do_pages_move-to-work-on-page_sized-chunks-update
+++ a/mm/migrate.c
@@ -928,14 +928,14 @@ static int do_pages_move(struct mm_struc
 	task_nodes = cpuset_mems_allowed(task);
 
 	err = -ENOMEM;
-	pm = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	pm = (struct page_to_node *)__get_free_page(GFP_KERNEL);
 	if (!pm)
 		goto out;
 	/*
 	 * Store a chunk of page_to_node array in a page,
 	 * but keep the last one as a marker
 	 */
-	chunk_nr_pages = PAGE_SIZE/sizeof(struct page_to_node) - 1;
+	chunk_nr_pages = (PAGE_SIZE / sizeof(struct page_to_node)) - 1;
 
 	for (chunk_start = 0;
 	     chunk_start < nr_pages;
@@ -988,7 +988,7 @@ static int do_pages_move(struct mm_struc
 	err = 0;
 
 out_pm:
-	kfree(pm);
+	free_page((unsigned long)pm);
 out:
 	return err;
 }
_

Patches currently in -mm which might be from Brice.Goglin@inria.fr are

mm-rework-do_pages_move-to-work-on-page_sized-chunks.patch
mm-rework-do_pages_move-to-work-on-page_sized-chunks-update.patch
mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch

