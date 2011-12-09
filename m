From: akpm@linux-foundation.org
Subject: + mm-simplify-find_vma_prev-fix-2.patch added to -mm tree
Date: Fri, 09 Dec 2011 15:42:58 -0800
Message-ID: <201112092342.pB9NgwXs003884@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:49985 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1LIXnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 18:43:00 -0500
Received: by ggnv2 with SMTP id v2so89147ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 15:42:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm: simplify find_vma_prev
has been added to the -mm tree.  Its filename is
     mm-simplify-find_vma_prev-fix-2.patch

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
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: simplify find_vma_prev

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-simplify-find_vma_prev-fix-2 mm/mmap.c
--- a/mm/mmap.c~mm-simplify-find_vma_prev-fix-2
+++ a/mm/mmap.c
@@ -1628,18 +1628,16 @@ EXPORT_SYMBOL(find_vma);
 
 /*
  * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
- * Note: *pprev is set to NULL when the return value is NULL.
+ * Note: pprev is set to NULL when return value is NULL.
  */
 struct vm_area_struct *
-find_vma_prev(struct mm_struct *mm, unsigned long addr, struct vm_area_struct **pprev)
+find_vma_prev(struct mm_struct *mm, unsigned long addr,
+			struct vm_area_struct **pprev)
 {
 	struct vm_area_struct *vma;
 
-	*pprev = NULL;
 	vma = find_vma(mm, addr);
-	if (vma)
-		*pprev = vma->vm_prev;
-
+	*pprev = vma ? vma->vm_prev : NULL;
 	return vma;
 }
 
_
Subject: Subject: mm: simplify find_vma_prev

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-simplify-find_vma_prev.patch
mm-simplify-find_vma_prev-fix.patch
mm-simplify-find_vma_prev-fix-2.patch
kexec-remove-kmsg_dump_kexec.patch
ipc-mqueue-simplify-reading-msgqueue-limit.patch

