From: akpm@linux-foundation.org
Subject: + mm-drop-null-return-check-of-pte_offset_map_lock.patch added to -mm tree
Date: Thu, 18 May 2017 13:10:32 -0700
Message-ID: <591dffb8.nr3US3rXHgaUJKc0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33942 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbdERUKd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 16:10:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop NULL return check of pte_offset_map_lock()
has been added to the -mm tree.  Its filename is
     mm-drop-null-return-check-of-pte_offset_map_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-null-return-check-of-pte_offset_map_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-null-return-check-of-pte_offset_map_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: drop NULL return check of pte_offset_map_lock()

pte_offset_map_lock() finds and takes ptl, and returns pte.  But some
callers return without unlocking the ptl when pte == NULL, which seems
weird.

Git history said that !pte check in change_pte_range() was introduced in
commit 1ad9f620c3a2 ("mm: numa: recheck for transhuge pages under lock
during protection changes") and still remains after commit 175ad4f1e7a2
("mm: mprotect: use pmd_trans_unstable instead of taking the pmd_lock")
which partially reverts 1ad9f620c3a2.  So I think that it's just dead
code.

Many other caller of pte_offset_map_lock() never check NULL return, so
let's do likewise.

Link: http://lkml.kernel.org/r/1495089737-1292-1-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    2 --
 mm/mprotect.c |    2 --
 2 files changed, 4 deletions(-)

diff -puN mm/memory.c~mm-drop-null-return-check-of-pte_offset_map_lock mm/memory.c
--- a/mm/memory.c~mm-drop-null-return-check-of-pte_offset_map_lock
+++ a/mm/memory.c
@@ -4032,8 +4032,6 @@ static int __follow_pte_pmd(struct mm_st
 		goto out;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
-	if (!ptep)
-		goto out;
 	if (!pte_present(*ptep))
 		goto unlock;
 	*ptepp = ptep;
diff -puN mm/mprotect.c~mm-drop-null-return-check-of-pte_offset_map_lock mm/mprotect.c
--- a/mm/mprotect.c~mm-drop-null-return-check-of-pte_offset_map_lock
+++ a/mm/mprotect.c
@@ -58,8 +58,6 @@ static unsigned long change_pte_range(st
 	 * reading.
 	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	if (!pte)
-		return 0;
 
 	/* Get target node for single threaded private VMAs */
 	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-drop-null-return-check-of-pte_offset_map_lock.patch

