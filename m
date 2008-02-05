From: akpm@linux-foundation.org
Subject: - maps4-move-is_swap_pte.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:00 -0800
Message-ID: <200802052230.m15MUf9u012093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760079AbYBEWnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     maps4: move is_swap_pte
has been removed from the -mm tree.  Its filename was
     maps4-move-is_swap_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: maps4: move is_swap_pte
From: Matt Mackall <mpm@selenic.com>

Move is_swap_pte helper function to swapops.h for use by pagemap code

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    6 ++++++
 mm/migrate.c            |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN include/linux/swapops.h~maps4-move-is_swap_pte include/linux/swapops.h
--- a/include/linux/swapops.h~maps4-move-is_swap_pte
+++ a/include/linux/swapops.h
@@ -42,6 +42,12 @@ static inline pgoff_t swp_offset(swp_ent
 	return entry.val & SWP_OFFSET_MASK(entry);
 }
 
+/* check whether a pte points to a swap entry */
+static inline int is_swap_pte(pte_t pte)
+{
+	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
+}
+
 /*
  * Convert the arch-dependent pte representation of a swp_entry_t into an
  * arch-independent swp_entry_t.
diff -puN mm/migrate.c~maps4-move-is_swap_pte mm/migrate.c
--- a/mm/migrate.c~maps4-move-is_swap_pte
+++ a/mm/migrate.c
@@ -115,11 +115,6 @@ int putback_lru_pages(struct list_head *
 	return count;
 }
 
-static inline int is_swap_pte(pte_t pte)
-{
-	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
-}
-
 /*
  * Restore a potential migration pte to a working pte entry
  */
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch
