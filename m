From: akpm@osdl.org
Subject: - grab-swap-token-reordered.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:23 -0800
Message-ID: <200612072256.kB7MuNrf029196@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50414 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163568AbWLGW4f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ashwin.chaugule@celunite.com, a.p.zijlstra@chello.nl, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     grab swap token reordered
has been removed from the -mm tree.  Its filename was
     grab-swap-token-reordered.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: grab swap token reordered
From: Ashwin Chaugule <ashwin.chaugule@celunite.com>

Make sure the contention for the token happens _before_ any read-in and
kicks the swap-token algo only when the VM is under pressure.

Signed-off-by: Ashwin Chaugule <ashwin.chaugule@celunite.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/filemap.c |    1 -
 mm/memory.c  |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/filemap.c~grab-swap-token-reordered mm/filemap.c
--- a/mm/filemap.c~grab-swap-token-reordered
+++ a/mm/filemap.c
@@ -1445,7 +1445,6 @@ no_cached_page:
 	 * effect.
 	 */
 	error = page_cache_read(file, pgoff);
-	grab_swap_token();
 
 	/*
 	 * The page we want has now been added to the page cache.
diff -puN mm/memory.c~grab-swap-token-reordered mm/memory.c
--- a/mm/memory.c~grab-swap-token-reordered
+++ a/mm/memory.c
@@ -1991,6 +1991,7 @@ static int do_swap_page(struct mm_struct
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry);
 	if (!page) {
+		grab_swap_token(); /* Contend for token _before_ read-in */
  		swapin_readahead(entry, address, vma);
  		page = read_swap_cache_async(entry, vma, address);
 		if (!page) {
@@ -2008,7 +2009,6 @@ static int do_swap_page(struct mm_struct
 		/* Had to read the page from swap area: Major fault */
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
-		grab_swap_token();
 	}
 
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
_

Patches currently in -mm which might be from ashwin.chaugule@celunite.com are

origin.patch

