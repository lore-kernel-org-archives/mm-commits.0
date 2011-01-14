From: akpm@linux-foundation.org
Subject: [merged] do_wp_page-remove-the-reuse-flag.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:18 -0800
Message-ID: <201101142248.p0EMm8Xd005090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915Ab1ANWsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, david@fromorbit.com, hch@infradead.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.co


The patch titled
     do_wp_page: remove the 'reuse' flag
has been removed from the -mm tree.  Its filename was
     do_wp_page-remove-the-reuse-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wp_page: remove the 'reuse' flag
From: Michel Lespinasse <walken@google.com>

mlocking a shared, writable vma currently causes the corresponding pages
to be marked as dirty and queued for writeback.  This seems rather
unnecessary given that the pages are not being actually modified during
mlock.  It is understood that for non-shared mappings (file or anon) we
want to use a write fault in order to break COW, but there is just no such
need for shared mappings.

The first two patches in this series do not introduce any behavior change.
 The intent there is to make it obvious that dirtying file pages is only
done in the (writable, shared) case.  I think this clarifies the code, but
I wouldn't mind dropping these two patches if there is no consensus about
them.

The last patch is where we actually avoid dirtying shared mappings during
mlock.  Note that as a side effect of this, we won't call page_mkwrite()
for the mappings that define it, and won't be pre-allocating data blocks
at the FS level if the mapped file was sparsely allocated.  My
understanding is that mlock does not need to provide such guarantee, as
evidenced by the fact that it never did for the filesystems that don't
define page_mkwrite() - including some common ones like ext3.  However, I
would like to gather feedback on this from filesystem people as a
precaution.  If this turns out to be a showstopper, maybe block
preallocation can be added back on using a different interface.

Large shared mlocks are getting significantly (>2x) faster in my tests, as
the disk can be fully used for reading the file instead of having to share
between this and writeback.



This patch:

Reorganize the code to remove the 'reuse' flag.  No behavior changes.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Theodore Tso <tytso@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~do_wp_page-remove-the-reuse-flag mm/memory.c
--- a/mm/memory.c~do_wp_page-remove-the-reuse-flag
+++ a/mm/memory.c
@@ -2112,7 +2112,7 @@ static int do_wp_page(struct mm_struct *
 {
 	struct page *old_page, *new_page;
 	pte_t entry;
-	int reuse = 0, ret = 0;
+	int ret = 0;
 	int page_mkwrite = 0;
 	struct page *dirty_page = NULL;
 
@@ -2149,14 +2149,16 @@ static int do_wp_page(struct mm_struct *
 			}
 			page_cache_release(old_page);
 		}
-		reuse = reuse_swap_page(old_page);
-		if (reuse)
+		if (reuse_swap_page(old_page)) {
 			/*
 			 * The page is all ours.  Move it to our anon_vma so
 			 * the rmap code will not search our parent or siblings.
 			 * Protected against the rmap code by the page lock.
 			 */
 			page_move_anon_rmap(old_page, vma, address);
+			unlock_page(old_page);
+			goto reuse;
+		}
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
@@ -2220,10 +2222,7 @@ static int do_wp_page(struct mm_struct *
 		}
 		dirty_page = old_page;
 		get_page(dirty_page);
-		reuse = 1;
-	}
 
-	if (reuse) {
 reuse:
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = pte_mkyoung(orig_pte);
_

Patches currently in -mm which might be from walken@google.com are

origin.patch

