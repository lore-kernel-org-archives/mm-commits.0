From: akpm@linux-foundation.org
Subject: + hugetlbfs-fix-hugetlb_get_unmapped_area.patch added to -mm tree
Date: Wed, 01 Feb 2012 14:45:42 -0800
Message-ID: <20120201224543.4F905A03A7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:49600 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2BAWpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 17:45:45 -0500
Received: by faaa19 with SMTP id a19so72818faa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 14:45:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: hugetlbfs: fix hugetlb_get_unmapped_area()
has been added to the -mm tree.  Its filename is
     hugetlbfs-fix-hugetlb_get_unmapped_area.patch

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
Subject: Subject: hugetlbfs: fix hugetlb_get_unmapped_area()

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch

