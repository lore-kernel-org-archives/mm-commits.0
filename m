From: akpm@linux-foundation.org
Subject: + mm-thp-minor-lock-simplification-in-__khugepaged_exit.patch added to -mm tree
Date: Mon, 20 Jun 2011 15:16:47 -0700
Message-ID: <201106202216.p5KMGlDG025698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971Ab1FTWRC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 18:17:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, aarcange@redhat.com, mhocko@suse.cz


The patch titled
     mm/huge_memory.c: minor lock simplification in __khugepaged_exit
has been added to the -mm tree.  Its filename is
     mm-thp-minor-lock-simplification-in-__khugepaged_exit.patch

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
Subject: mm/huge_memory.c: minor lock simplification in __khugepaged_exit
From: Chris Wright <chrisw@sous-sol.org>

The lock is released first thing in all three branches.  Simplify this by
unconditionally releasing lock and remove else clause which was only there
to be sure lock was released.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-minor-lock-simplification-in-__khugepaged_exit mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-minor-lock-simplification-in-__khugepaged_exit
+++ a/mm/huge_memory.c
@@ -1596,14 +1596,13 @@ void __khugepaged_exit(struct mm_struct 
 		list_del(&mm_slot->mm_node);
 		free = 1;
 	}
+	spin_unlock(&khugepaged_mm_lock);
 
 	if (free) {
-		spin_unlock(&khugepaged_mm_lock);
 		clear_bit(MMF_VM_HUGEPAGE, &mm->flags);
 		free_mm_slot(mm_slot);
 		mmdrop(mm);
 	} else if (mm_slot) {
-		spin_unlock(&khugepaged_mm_lock);
 		/*
 		 * This is required to serialize against
 		 * khugepaged_test_exit() (which is guaranteed to run
@@ -1614,8 +1613,7 @@ void __khugepaged_exit(struct mm_struct 
 		 */
 		down_write(&mm->mmap_sem);
 		up_write(&mm->mmap_sem);
-	} else
-		spin_unlock(&khugepaged_mm_lock);
+	}
 }
 
 static void release_pte_page(struct page *page)
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

origin.patch
mm-thp-minor-lock-simplification-in-__khugepaged_exit.patch

