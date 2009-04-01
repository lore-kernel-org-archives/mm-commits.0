From: akpm@linux-foundation.org
Subject: [merged] mm-dont-call-mark_page_accessed-in-do_swap_page.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:26 -0700
Message-ID: <200904011834.n31IYQmV007152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762738AbZDASif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:38:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: don't call mark_page_accessed() in do_swap_page()
has been removed from the -mm tree.  Its filename was
     mm-dont-call-mark_page_accessed-in-do_swap_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't call mark_page_accessed() in do_swap_page()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit bf3f3bc5e734706730c12a323f9b2068052aa1f0 (mm: don't
mark_page_accessed in fault path) only remove the mark_page_accessed() in
filemap_fault().

Therefore, swap-backed pages and file-backed pages have inconsistent
behavior.  mark_page_accessed() should be removed from do_swap_page().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memory.c~mm-dont-call-mark_page_accessed-in-do_swap_page mm/memory.c
--- a/mm/memory.c~mm-dont-call-mark_page_accessed-in-do_swap_page
+++ a/mm/memory.c
@@ -2435,8 +2435,6 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
-	mark_page_accessed(page);
