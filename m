From: akpm@linux-foundation.org
Subject: + mm-dont-mark_page_accessed-in-fault-path.patch added to -mm tree
Date: Tue, 21 Oct 2008 14:37:14 -0700
Message-ID: <200810212137.m9LLbEoV025690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbYJUVhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 17:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hannes@saeurebad.de


The patch titled
     mm: don't mark_page_accessed in fault path
has been added to the -mm tree.  Its filename is
     mm-dont-mark_page_accessed-in-fault-path.patch

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
Subject: mm: don't mark_page_accessed in fault path
From: Nick Piggin <npiggin@suse.de>

Doing a mark_page_accessed at fault-time, then doing SetPageReferenced at
unmap-time if the pte is young has a number of problems.

mark_page_accessed is supposed to be roughly the equivalent of a young pte
for unmapped references. Unfortunately it doesn't come with any context:
after being called, reclaim doesn't know who or why the page was touched.

So calling mark_page_accessed not only adds extra lru or PG_referenced
manipulations for pages that are already going to have pte_young ptes anyway,
but it also adds these references which are difficult to work with from the
context of vma specific references (eg. MADV_SEQUENTIAL pte_young may not
wish to contribute to the page being referenced).

Then, simply doing SetPageReferenced when zapping a pte and finding it is
young, is not a really good solution either. SetPageReferenced does not
correctly promote the page to the active list for example. So after removing
mark_page_accessed from the fault path, several mmap()+touch+munmap() would
have a very different result from several read(2) calls for example, which
is not really desirable.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 mm/memory.c  |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-dont-mark_page_accessed-in-fault-path mm/filemap.c
--- a/mm/filemap.c~mm-dont-mark_page_accessed-in-fault-path
+++ a/mm/filemap.c
@@ -1530,7 +1530,6 @@ retry_find:
 	/*
 	 * Found the page and have a reference on it.
 	 */
-	mark_page_accessed(page);
 	ra->prev_pos = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
diff -puN mm/memory.c~mm-dont-mark_page_accessed-in-fault-path mm/memory.c
--- a/mm/memory.c~mm-dont-mark_page_accessed-in-fault-path
+++ a/mm/memory.c
@@ -760,7 +760,7 @@ static unsigned long zap_pte_range(struc
 				if (pte_dirty(ptent))
 					set_page_dirty(page);
 				if (pte_young(ptent))
-					SetPageReferenced(page);
+					mark_page_accessed(page);
 				file_rss--;
 			}
 			page_remove_rmap(page, vma);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-increase-the-default-mlock-limit-from-32k-to-64k.patch
fs-remove-prepare_write-commit_write.patch
linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

