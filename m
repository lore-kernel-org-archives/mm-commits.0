From: akpm@linux-foundation.org
Subject: + mlock-do-not-munlock-pages-in-__do_fault.patch added to -mm tree
Date: Mon, 07 Feb 2011 17:18:08 -0800
Message-ID: <201102080118.p181I8JL006699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011Ab1BHBS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2011 20:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     mlock: do not munlock pages in __do_fault()
has been added to the -mm tree.  Its filename is
     mlock-do-not-munlock-pages-in-__do_fault.patch

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
Subject: mlock: do not munlock pages in __do_fault()
From: Michel Lespinasse <walken@google.com>

If the page is going to be written to, __do_page needs to break COW. 
However, the old page (before breaking COW) was never mapped mapped into
the current pte (__do_fault is only called when the pte is not present),
so vmscan can't have marked the old page as PageMlocked due to being
mapped in __do_fault's VMA.  Therefore, __do_fault() does not need to
worry about clearing PageMlocked() on the old page.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
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
mlock-fix-race-when-munlocking-pages-in-do_wp_page.patch
mlock-do-not-munlock-pages-in-__do_fault.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch

