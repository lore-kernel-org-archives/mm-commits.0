From: akpm@linux-foundation.org
Subject: + mlock-fix-race-when-munlocking-pages-in-do_wp_page.patch added to -mm tree
Date: Mon, 07 Feb 2011 17:18:06 -0800
Message-ID: <201102080118.p181I6nl006696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011Ab1BHBSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2011 20:18:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     mlock: fix race when munlocking pages in do_wp_page()
has been added to the -mm tree.  Its filename is
     mlock-fix-race-when-munlocking-pages-in-do_wp_page.patch

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
Subject: mlock: fix race when munlocking pages in do_wp_page()
From: Michel Lespinasse <walken@google.com>

vmscan can lazily find pages that are mapped within VM_LOCKED vmas, and
set the PageMlocked bit on these pages, transfering them onto the
unevictable list.  When do_wp_page() breaks COW within a VM_LOCKED vma, it
may need to clear PageMlocked on the old page and set it on the new page
instead.

This change fixes an issue where do_wp_page() was clearing PageMlocked on
the old page while the pte was still pointing to it (as well as rmap). 
Therefore, we were not protected against vmscan immediately transfering
the old page back onto the unevictable list.  This could cause pages to
get stranded there forever.

I propose to move the corresponding code to the end of do_wp_page(), after
the pte (and rmap) have been pointed to the new page.  Additionally, we
can use munlock_vma_page() instead of clear_page_mlock(), so that the old
page stays mlocked if there are still other VM_LOCKED vmas mapping it.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN mm/memory.c~mlock-fix-race-when-munlocking-pages-in-do_wp_page mm/memory.c
--- a/mm/memory.c~mlock-fix-race-when-munlocking-pages-in-do_wp_page
+++ a/mm/memory.c
@@ -2219,7 +2219,6 @@ static int do_wp_page(struct mm_struct *
 							 &ptl);
 			if (!pte_same(*page_table, orig_pte)) {
 				unlock_page(old_page);
-				page_cache_release(old_page);
 				goto unlock;
 			}
 			page_cache_release(old_page);
@@ -2289,7 +2288,6 @@ static int do_wp_page(struct mm_struct *
 							 &ptl);
 			if (!pte_same(*page_table, orig_pte)) {
 				unlock_page(old_page);
-				page_cache_release(old_page);
 				goto unlock;
 			}
 
@@ -2367,16 +2365,6 @@ gotten:
 	}
 	__SetPageUptodate(new_page);
 
-	/*
-	 * Don't let another task, with possibly unlocked vma,
-	 * keep the mlocked page.
-	 */
-	if ((vma->vm_flags & VM_LOCKED) && old_page) {
-		lock_page(old_page);	/* for LRU manipulation */
-		clear_page_mlock(old_page);
-		unlock_page(old_page);
-	}
-
 	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 
@@ -2444,10 +2432,20 @@ gotten:
 
 	if (new_page)
 		page_cache_release(new_page);
-	if (old_page)
-		page_cache_release(old_page);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
+	if (old_page) {
+		/*
+		 * Don't let another task, with possibly unlocked vma,
+		 * keep the mlocked page.
+		 */
+		if ((ret & VM_FAULT_WRITE) && (vma->vm_flags & VM_LOCKED)) {
+			lock_page(old_page);	/* LRU manipulation */
+			munlock_vma_page(old_page);
+			unlock_page(old_page);
+		}
+		page_cache_release(old_page);
+	}
 	return ret;
 oom_free_new:
 	page_cache_release(new_page);
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
mlock-fix-race-when-munlocking-pages-in-do_wp_page.patch
mlock-do-not-munlock-pages-in-__do_fault.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch

