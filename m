From: akpm@linux-foundation.org
Subject: + mm-dont-return-0-too-early-from-find_get_pages.patch added to -mm tree
Date: Thu, 24 Feb 2011 16:20:11 -0800
Message-ID: <201102250020.p1P0KBpH003545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756664Ab1BYAUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 19:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, npiggin@kernel.dk, sqazi@google.com


The patch titled
     mm: don't return 0 too early from find_get_pages()
has been added to the -mm tree.  Its filename is
     mm-dont-return-0-too-early-from-find_get_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't return 0 too early from find_get_pages()
From: Hugh Dickins <hughd@google.com>

Callers of find_get_pages(), or its wrapper pagevec_lookup() - notably
truncate_inode_pages_range() - stop looking further when it returns 0.

But if an interrupt comes just after its radix_tree_gang_lookup_slot(),
especially if we have preemptible RCU enabled, isn't it conceivable that
all 14 pages returned could be removed from the page cache by
shrink_page_list(), before find_get_pages() gets to process them?  So
causing it to return 0 although there may be plenty more pages beyond.

Make find_get_pages() and find_get_pages_tag() check for this unlikely
case, and restart should it occur; but callers of find_get_pages_contig()
have no such expectation, it's okay for that to return 0 early.

I have not seen this in practice, just worried by the possibility.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Salman Qazi <sqazi@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN mm/filemap.c~mm-dont-return-0-too-early-from-find_get_pages mm/filemap.c
--- a/mm/filemap.c~mm-dont-return-0-too-early-from-find_get_pages
+++ a/mm/filemap.c
@@ -897,6 +897,13 @@ repeat:
 		pages[ret] = page;
 		ret++;
 	}
+
+	/*
+	 * If all entries were removed before we could secure them,
+	 * try again, because callers stop trying once 0 is returned.
+	 */
+	if (unlikely(!ret && nr_found))
+		goto restart;
 	rcu_read_unlock();
 	return ret;
 }
@@ -1016,6 +1023,13 @@ repeat:
 		pages[ret] = page;
 		ret++;
 	}
+
+	/*
+	 * If all entries were removed before we could secure them,
+	 * try again, because callers stop trying once 0 is returned.
+	 */
+	if (unlikely(!ret && nr_found))
+		goto restart;
 	rcu_read_unlock();
 
 	if (ret)
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-rename-drop_anon_vma-to-put_anon_vma.patch
mm-move-anon_vma-ref-out-from-under-config_foo.patch
mm-simplify-anon_vma-refcounts.patch
mm-remove-worrying-dead-code-from-find_get_pages.patch
mm-dont-return-0-too-early-from-find_get_pages.patch
prio_tree-debugging-patch.patch

