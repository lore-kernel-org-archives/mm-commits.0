From: akpm@linux-foundation.org
Subject: [merged] hugetlb-try-to-search-again-if-it-is-really-needed.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:54 -0700
Message-ID: <20120322201754.64A11A06FD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60535 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2CVURz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:55 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so402093ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: try to search again if it is really needed
has been removed from the -mm tree.  Its filename was
     hugetlb-try-to-search-again-if-it-is-really-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: hugetlb: try to search again if it is really needed

Search again only if some holes may be skipped in the first pass.

[akpm@linux-foundation.org: clean up crazy compound definition]
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

 arch/x86/mm/hugetlbpage.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-try-to-search-again-if-it-is-really-needed arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-try-to-search-again-if-it-is-really-needed
+++ a/arch/x86/mm/hugetlbpage.c
@@ -309,9 +309,10 @@ static unsigned long hugetlb_get_unmappe
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev_vma;
-	unsigned long base = mm->mmap_base, addr = addr0;
+	unsigned long base = mm->mmap_base;
+	unsigned long addr = addr0;
 	unsigned long largest_hole = mm->cached_hole_size;
-	int first_time = 1;
+	unsigned long start_addr;
 
 	/* don't allow allocations above current base */
 	if (mm->free_area_cache > base)
@@ -322,6 +323,8 @@ static unsigned long hugetlb_get_unmappe
 		mm->free_area_cache  = base;
 	}
 try_again:
+	start_addr = mm->free_area_cache;
+
 	/* make sure it can fit in the remaining address space */
 	if (mm->free_area_cache < len)
 		goto fail;
@@ -368,10 +371,9 @@ fail:
 	 * if hint left us with no space for the requested
 	 * mapping then try again:
 	 */
-	if (first_time) {
+	if (start_addr != base) {
 		mm->free_area_cache = base;
 		largest_hole = 0;
-		first_time = 0;
 		goto try_again;
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

