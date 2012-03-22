From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:56 -0700
Message-ID: <20120322201756.8F81EA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:61580 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab2CVUR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2012 16:17:59 -0400
Received: by laai8 with SMTP id i8so133907laa.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not reset cached_hole_size when vma is unmapped
has been removed from the -mm tree.  Its filename was
     mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: mm: do not reset cached_hole_size when vma is unmapped

In the current code, cached_hole_size is set to the maximum value if the
unmapped vma is less that free_area_cache so the next search will search
from the base address.

Actually, we can keep cached_hole_size so that if the next required size
is more than cached_hole_size, it can search from free_area_cache.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-do-not-reset-cached_hole_size-when-vma-is-unmapped mm/mmap.c
--- a/mm/mmap.c~mm-do-not-reset-cached_hole_size-when-vma-is-unmapped
+++ a/mm/mmap.c
@@ -1426,10 +1426,8 @@ void arch_unmap_area(struct mm_struct *m
 	/*
 	 * Is this a new hole at the lowest possible address?
 	 */
-	if (addr >= TASK_UNMAPPED_BASE && addr < mm->free_area_cache) {
+	if (addr >= TASK_UNMAPPED_BASE && addr < mm->free_area_cache)
 		mm->free_area_cache = addr;
-		mm->cached_hole_size = ~0UL;
-	}
 }
 
 /*
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch
prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch
prio_tree-cleanup-prio_tree_left-prio_tree_right.patch
prio_tree-simplify-prio_tree_expand.patch
prio_tree-introduce-prio_set_parent.patch

