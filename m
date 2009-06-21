From: akpm@linux-foundation.org
Subject: + mm-pass-mm-to-grab_swap_token.patch added to -mm tree
Date: Sun, 21 Jun 2009 09:30:52 -0700
Message-ID: <200906211630.n5LGUqs2009017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbZFUQbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Jun 2009 12:31:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, hannes@cmpxchg.org, ieidus@redhat.com, riel@redhat.com


The patch titled
     mm: pass mm to grab_swap_token
has been added to the -mm tree.  Its filename is
     mm-pass-mm-to-grab_swap_token.patch

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
@@ -2516,7 +2516,7 @@ static int do_swap_page(struct mm_struct
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
mm-pass-mm-to-grab_swap_token.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
elf-reduce-default-max_map_count-to-be-safe-value.patch
prio_tree-debugging-patch.patch

