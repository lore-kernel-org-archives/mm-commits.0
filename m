From: akpm@linux-foundation.org
Subject: +
 mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path.patch
 added to -mm tree
Date: Fri, 18 Nov 2016 16:45:32 -0800
Message-ID: <582fa0ac.NdI+zdujoL0bHSau%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753117AbcKSApd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 19:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: fix radix tree node leak in shmem collapse error path
has been added to the -mm tree.  Its filename is
     mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: khugepaged: fix radix tree node leak in shmem collapse error path

The radix tree counts valid entries in each tree node.  Entries stored in
the tree cannot be removed by simpling storing NULL in the slot or the
internal counters will be off and the node never gets freed again.

When collapsing a shmem page fails, restore the holes that were filled
with radix_tree_insert() with a proper radix tree deletion.

Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Link: http://lkml.kernel.org/r/20161117191138.22769-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/khugepaged.c~mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path mm/khugepaged.c
--- a/mm/khugepaged.c~mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path
+++ a/mm/khugepaged.c
@@ -1525,9 +1525,11 @@ tree_unlocked:
 			if (!page || iter.index < page->index) {
 				if (!nr_none)
 					break;
-				/* Put holes back where they were */
-				radix_tree_replace_slot(slot, NULL);
 				nr_none--;
+				/* Put holes back where they were */
+				radix_tree_delete(&mapping->page_tree,
+						  iter.index);
+				slot = radix_tree_iter_next(&iter);
 				continue;
 			}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-khugepaged-close-use-after-free-race-during-shmem-collapsing.patch
mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path.patch
mm-workingset-turn-shadow-node-shrinker-bugs-into-warnings.patch
lib-radix-tree-native-accounting-of-exceptional-entries.patch
lib-radix-tree-check-accounting-of-existing-slot-replacement-users.patch
lib-radix-tree-add-entry-deletion-support-to-__radix_tree_replace.patch
lib-radix-tree-update-callback-for-changing-leaf-nodes.patch
mm-workingset-move-shadow-entry-tracking-to-radix-tree-exceptional-tracking.patch
mm-workingset-restore-refault-tracking-for-single-page-files.patch

