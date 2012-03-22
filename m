From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-fix-hugetlb_get_unmapped_area.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:52 -0700
Message-ID: <20120322201752.7AE7DA06FD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56068 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2CVURx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:53 -0400
Received: by yhgm50 with SMTP id m50so403131yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix hugetlb_get_unmapped_area()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-hugetlb_get_unmapped_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: hugetlbfs: fix hugetlb_get_unmapped_area()

Use/update cached_hole_size and free_area_cache properly to speedup
finding of a free region.

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

 fs/hugetlbfs/inode.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-fix-hugetlb_get_unmapped_area fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-hugetlb_get_unmapped_area
+++ a/fs/hugetlbfs/inode.c
@@ -154,10 +154,12 @@ hugetlb_get_unmapped_area(struct file *f
 			return addr;
 	}
 
-	start_addr = mm->free_area_cache;
-
-	if (len <= mm->cached_hole_size)
+	if (len > mm->cached_hole_size)
+		start_addr = mm->free_area_cache;
+	else {
 		start_addr = TASK_UNMAPPED_BASE;
+		mm->cached_hole_size = 0;
+	}
 
 full_search:
 	addr = ALIGN(start_addr, huge_page_size(h));
@@ -171,13 +173,18 @@ full_search:
 			 */
 			if (start_addr != TASK_UNMAPPED_BASE) {
 				start_addr = TASK_UNMAPPED_BASE;
+				mm->cached_hole_size = 0;
 				goto full_search;
 			}
 			return -ENOMEM;
 		}
 
-		if (!vma || addr + len <= vma->vm_start)
+		if (!vma || addr + len <= vma->vm_start) {
+			mm->free_area_cache = addr + len;
 			return addr;
+		}
+		if (addr + mm->cached_hole_size < vma->vm_start)
+			mm->cached_hole_size = vma->vm_start - addr;
 		addr = ALIGN(vma->vm_end, huge_page_size(h));
 	}
 }
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch
prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch
prio_tree-cleanup-prio_tree_left-prio_tree_right.patch
prio_tree-simplify-prio_tree_expand.patch
prio_tree-introduce-prio_set_parent.patch

