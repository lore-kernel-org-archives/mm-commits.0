From: akpm@linux-foundation.org
Subject: [merged] revert-proc-clear_refs-do-not-clear-reserved-pages.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:30 -0700
Message-ID: <20120427193530.694FDA02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:61226 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761331Ab2D0Tfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:31 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so121339yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, hughd@google.com, nico@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "proc: clear_refs: do not clear reserved pages"
has been removed from the -mm tree.  Its filename was
     revert-proc-clear_refs-do-not-clear-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
