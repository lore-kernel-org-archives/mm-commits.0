From: akpm@linux-foundation.org
Subject: [merged] mm-thp-minor-lock-simplification-in-__khugepaged_exit.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:49 -0700
Message-ID: <201107260751.p6Q7pqqK002993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662Ab1GZHwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, aarcange@redhat.com, jweiner@redhat.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm/huge_memory.c: minor lock simplification in __khugepaged_exit
has been removed from the -mm tree.  Its filename was
     mm-thp-minor-lock-simplification-in-__khugepaged_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Johannes Weiner <jweiner@redhat.com>
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
linux-next.patch

