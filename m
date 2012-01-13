From: akpm@linux-foundation.org
Subject: + proc-clear_refs-do-not-clear-reserved-pages.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:47:14 -0800
Message-ID: <20120113224714.C224F1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:39675 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMWrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:47:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, hughd@google.com, moussaba@micron.com, mpm@selenic.com, nico@fluxnic.net, rientjes@google.com, rmk@arm.linux.org.uk, stable@vger.kernel.org


The patch titled
     Subject: proc: clear_refs: do not clear reserved pages
has been added to the -mm tree.  Its filename is
     proc-clear_refs-do-not-clear-reserved-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: proc: clear_refs: do not clear reserved pages

/proc/pid/clear_refs is used to clear the Referenced and YOUNG bits for
pages and corresponding page table entries of the task with PID pid, which
includes any special mappings inserted into the page tables in order to
provide things like vDSOs and user helper functions.

On ARM this causes a problem because the vectors page is mapped as a
global mapping and since ec706dab ("ARM: add a vma entry for the user
accessible vector page"), a VMA is also inserted into each task for this
page to aid unwinding through signals and syscall restarts.  Since the
vectors page is required for handling faults, clearing the YOUNG bit (and
subsequently writing a faulting pte) means that we lose the vectors page
*globally* and cannot fault it back in.  This results in a system deadlock
on the next exception.

To see this problem in action, just run:

	$ echo 1 > /proc/self/clear_refs

on an ARM platform (as any user) and watch your system hang.  I think this
has been the case since 2.6.37

This patch avoids clearing the aforementioned bits for reserved pages,
therefore leaving the vectors page intact on ARM.  Since reserved pages
are not candidates for swap, this change should not have any impact on the
usefulness of clear_refs.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Reported-by: Moussa Ba <moussaba@micron.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>		[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/proc/task_mmu.c~proc-clear_refs-do-not-clear-reserved-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-clear_refs-do-not-clear-reserved-pages
+++ a/fs/proc/task_mmu.c
@@ -518,6 +518,9 @@ static int clear_refs_pte_range(pmd_t *p
 		if (!page)
 			continue;
 
+		if (PageReserved(page))
+			continue;
+
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		ClearPageReferenced(page);
_
Subject: Subject: proc: clear_refs: do not clear reserved pages

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch
proc-clear_refs-do-not-clear-reserved-pages.patch

