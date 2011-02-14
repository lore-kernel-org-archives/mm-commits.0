From: akpm@linux-foundation.org
Subject: [merged] mlock-do-not-munlock-pages-in-__do_fault.patch removed from -mm tree
Date: Mon, 14 Feb 2011 12:19:37 -0800
Message-ID: <201102142019.p1EKJbtR023003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046Ab1BNUUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 15:20:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mlock: do not munlock pages in __do_fault()
has been removed from the -mm tree.  Its filename was
     mlock-do-not-munlock-pages-in-__do_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: do not munlock pages in __do_fault()
From: Michel Lespinasse <walken@google.com>

If the page is going to be written to, __do_page needs to break COW. 
However, the old page (before breaking COW) was never mapped mapped into
the current pte (__do_fault is only called when the pte is not present),
so vmscan can't have marked the old page as PageMlocked due to being
mapped in __do_fault's VMA.  Therefore, __do_fault() does not need to
worry about clearing PageMlocked() on the old page.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/memory.c~mlock-do-not-munlock-pages-in-__do_fault mm/memory.c
--- a/mm/memory.c~mlock-do-not-munlock-pages-in-__do_fault
+++ a/mm/memory.c
@@ -3051,12 +3051,6 @@ static int __do_fault(struct mm_struct *
 				goto out;
 			}
 			charged = 1;
-			/*
-			 * Don't let another task, with possibly unlocked vma,
-			 * keep the mlocked page.
-			 */
-			if (vma->vm_flags & VM_LOCKED)
-				clear_page_mlock(vmf.page);
 			copy_user_highpage(page, vmf.page, address, vma);
 			__SetPageUptodate(page);
 		} else {
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch

