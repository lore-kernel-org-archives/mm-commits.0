From: akpm@linux-foundation.org
Subject: + revert-proc-clear_refs-do-not-clear-reserved-pages.patch added to -mm tree
Date: Fri, 20 Apr 2012 14:45:20 -0700
Message-ID: <20120420214520.D79BBA0172@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:50048 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2DTVpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 17:45:23 -0400
Received: by wibhj13 with SMTP id hj13so57230wib.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 14:45:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, hughd@google.com, nico@linaro.org


The patch titled
     Subject: revert "proc: clear_refs: do not clear reserved pages"
has been added to the -mm tree.  Its filename is
     revert-proc-clear_refs-do-not-clear-reserved-pages.patch

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
Subject: revert "proc: clear_refs: do not clear reserved pages"

Revert commit 85e72aa5384 ("proc: clear_refs: do not clear reserved
pages"), which was a quick fix suitable for -stable until ARM had been
moved over to the gate_vma mechanism:

https://lkml.org/lkml/2012/1/14/55

With commit f9d4861f ("ARM: 7294/1: vectors: use gate_vma for vectors user
mapping"), ARM does now use the gate_vma, so the PageReserved check can be
removed from the proc code.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nico@linaro.org>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/proc/task_mmu.c~revert-proc-clear_refs-do-not-clear-reserved-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~revert-proc-clear_refs-do-not-clear-reserved-pages
+++ a/fs/proc/task_mmu.c
@@ -597,9 +597,6 @@ static int clear_refs_pte_range(pmd_t *p
 		if (!page)
 			continue;
 
-		if (PageReserved(page))
-			continue;
