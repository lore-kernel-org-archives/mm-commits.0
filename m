From: akpm@linux-foundation.org
Subject: [merged] mm-pass-mm-to-grab_swap_token.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:10:33 -0700
Message-ID: <200906241910.n5OJAXQj010766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997AbZFXTK5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:10:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, hannes@cmpxchg.org, ieidus@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: pass mm to grab_swap_token
has been removed from the -mm tree.  Its filename was
     mm-pass-mm-to-grab_swap_token.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: pass mm to grab_swap_token
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

If a kthread happens to use get_user_pages() on an mm (as KSM does),
there's a chance that it will end up trying to read in a swap page, then
oops in grab_swap_token() because the kthread has no mm: GUP passes down
the right mm, so grab_swap_token() ought to be using it.

We have not identified a stronger case than KSM's daemon (not yet in
mainline), but the issue must have come up before, since RHEL has included
a fix for this for years (though a different fix, they just back out of
grab_swap_token if current->mm is unset: which is what we first proposed,
but using the right mm here seems more correct).

Reported-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   12 ++++++------
 mm/memory.c          |    2 +-
 mm/thrash.c          |   32 +++++++++++++++-----------------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff -puN include/linux/swap.h~mm-pass-mm-to-grab_swap_token include/linux/swap.h
--- a/include/linux/swap.h~mm-pass-mm-to-grab_swap_token
+++ a/include/linux/swap.h
@@ -298,8 +298,8 @@ extern int try_to_free_swap(struct page 
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
-extern struct mm_struct * swap_token_mm;
-extern void grab_swap_token(void);
+extern struct mm_struct *swap_token_mm;
+extern void grab_swap_token(struct mm_struct *);
 extern void __put_swap_token(struct mm_struct *);
 
 static inline int has_swap_token(struct mm_struct *mm)
@@ -419,10 +419,10 @@ static inline swp_entry_t get_swap_page(
 }
 
 /* linux/mm/thrash.c */
-#define put_swap_token(x) do { } while(0)
-#define grab_swap_token()  do { } while(0)
-#define has_swap_token(x) 0
-#define disable_swap_token() do { } while(0)
+#define put_swap_token(mm)	do { } while (0)
+#define grab_swap_token(mm)	do { } while (0)
+#define has_swap_token(mm)	0
+#define disable_swap_token()	do { } while (0)
 
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
diff -puN mm/memory.c~mm-pass-mm-to-grab_swap_token mm/memory.c
--- a/mm/memory.c~mm-pass-mm-to-grab_swap_token
+++ a/mm/memory.c
@@ -2517,7 +2517,7 @@ static int do_swap_page(struct mm_struct
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry);
 	if (!page) {
-		grab_swap_token(); /* Contend for token _before_ read-in */
+		grab_swap_token(mm); /* Contend for token _before_ read-in */
 		page = swapin_readahead(entry,
 					GFP_HIGHUSER_MOVABLE, vma, address);
 		if (!page) {
diff -puN mm/thrash.c~mm-pass-mm-to-grab_swap_token mm/thrash.c
--- a/mm/thrash.c~mm-pass-mm-to-grab_swap_token
+++ a/mm/thrash.c
@@ -26,47 +26,45 @@ static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
 static unsigned int global_faults;
 
-void grab_swap_token(void)
+void grab_swap_token(struct mm_struct *mm)
 {
 	int current_interval;
 
 	global_faults++;
 
-	current_interval = global_faults - current->mm->faultstamp;
+	current_interval = global_faults - mm->faultstamp;
 
 	if (!spin_trylock(&swap_token_lock))
 		return;
 
 	/* First come first served */
 	if (swap_token_mm == NULL) {
-		current->mm->token_priority = current->mm->token_priority + 2;
-		swap_token_mm = current->mm;
+		mm->token_priority = mm->token_priority + 2;
+		swap_token_mm = mm;
 		goto out;
 	}
 
-	if (current->mm != swap_token_mm) {
-		if (current_interval < current->mm->last_interval)
-			current->mm->token_priority++;
+	if (mm != swap_token_mm) {
+		if (current_interval < mm->last_interval)
+			mm->token_priority++;
 		else {
-			if (likely(current->mm->token_priority > 0))
-				current->mm->token_priority--;
+			if (likely(mm->token_priority > 0))
+				mm->token_priority--;
 		}
 		/* Check if we deserve the token */
-		if (current->mm->token_priority >
-				swap_token_mm->token_priority) {
-			current->mm->token_priority += 2;
-			swap_token_mm = current->mm;
+		if (mm->token_priority > swap_token_mm->token_priority) {
+			mm->token_priority += 2;
+			swap_token_mm = mm;
 		}
 	} else {
 		/* Token holder came in again! */
-		current->mm->token_priority += 2;
+		mm->token_priority += 2;
 	}
 
 out:
-	current->mm->faultstamp = global_faults;
-	current->mm->last_interval = current_interval;
+	mm->faultstamp = global_faults;
+	mm->last_interval = current_interval;
 	spin_unlock(&swap_token_lock);
-return;
 }
 
 /* Called on process exit. */
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
elf-limit-max-map-count-to-safe-value.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
prio_tree-debugging-patch.patch

