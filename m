From: akpm@linux-foundation.org
Subject: + mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch added to -mm tree
Date: Wed, 01 Feb 2012 14:45:50 -0800
Message-ID: <20120201224551.14953A03A7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:53912 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2BAWpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 17:45:53 -0500
Received: by eekb15 with SMTP id b15so52682eek.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 14:45:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm: do not reset cached_hole_size when vma is unmapped
has been added to the -mm tree.  Its filename is
     mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-do-not-reset-cached_hole_size-when-vma-is-unmapped mm/mmap.c
--- a/mm/mmap.c~mm-do-not-reset-cached_hole_size-when-vma-is-unmapped
+++ a/mm/mmap.c
@@ -1446,10 +1446,8 @@ void arch_unmap_area(struct mm_struct *m
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
Subject: Subject: mm: do not reset cached_hole_size when vma is unmapped

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch

