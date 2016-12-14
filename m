From: akpm@linux-foundation.org
Subject: [merged]
 mm-khugepaged-close-use-after-free-race-during-shmem-collapsing.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:25:17 -0800
Message-ID: <58519c9d.QgSKeZfOl3YsS19B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcLNTZS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: close use-after-free race during shmem collapsing
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-close-use-after-free-race-during-shmem-collapsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: khugepaged: close use-after-free race during shmem collapsing

Patch series "mm: workingset: radix tree subtleties & single-page file
refaults", v3.

This is another revision of the radix tree / workingset patches based
on feedback from Jan and Kirill.

This is a follow-up to d3798ae8c6f3 ("mm: filemap: don't plant shadow
entries without radix tree node").  That patch fixed an issue that was
caused mainly by the page cache sneaking special shadow page entries into
the radix tree and relying on subtleties in the radix tree code to make
that work.  The fix also had to stop tracking refaults for single-page
files because shadow pages stored as direct pointers in
radix_tree_root->rnode weren't properly handled during tree extension.

These patches make the radix tree code explicitely support and track such
special entries, to eliminate the subtleties and to restore the thrash
detection for single-page files.


This patch (of 9):

When a radix tree iteration drops the tree lock, another thread might
swoop in and free the node holding the current slot.  The iteration needs
to do another tree lookup from the current index to continue.

[kirill.shutemov@linux.intel.com: re-lookup for replacement]
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Link: http://lkml.kernel.org/r/20161117191138.22769-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/khugepaged.c~mm-khugepaged-close-use-after-free-race-during-shmem-collapsing mm/khugepaged.c
--- a/mm/khugepaged.c~mm-khugepaged-close-use-after-free-race-during-shmem-collapsing
+++ a/mm/khugepaged.c
@@ -1403,6 +1403,9 @@ static void collapse_shmem(struct mm_str
 
 		spin_lock_irq(&mapping->tree_lock);
 
+		slot = radix_tree_lookup_slot(&mapping->page_tree, index);
+		VM_BUG_ON_PAGE(page != radix_tree_deref_slot_protected(slot,
+					&mapping->tree_lock), page);
 		VM_BUG_ON_PAGE(page_mapped(page), page);
 
 		/*
@@ -1426,6 +1429,7 @@ static void collapse_shmem(struct mm_str
 		radix_tree_replace_slot(slot,
 				new_page + (index % HPAGE_PMD_NR));
 
+		slot = radix_tree_iter_next(&iter);
 		index++;
 		continue;
 out_lru:
@@ -1537,6 +1541,7 @@ tree_unlocked:
 			putback_lru_page(page);
 			unlock_page(page);
 			spin_lock_irq(&mapping->tree_lock);
+			slot = radix_tree_iter_next(&iter);
 		}
 		VM_BUG_ON(nr_none);
 		spin_unlock_irq(&mapping->tree_lock);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


