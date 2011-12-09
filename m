From: akpm@linux-foundation.org
Subject: + mm-simplify-find_vma_prev.patch added to -mm tree
Date: Fri, 09 Dec 2011 15:42:56 -0800
Message-ID: <201112092342.pB9Nguwa027769@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:59959 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1LIXm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 18:42:58 -0500
Received: by yenm5 with SMTP id m5so456747yen.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 15:42:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl, hughd@google.com, shaohua.li@intel.com, torvalds@linux-foundation.org


The patch titled
     Subject: mm: simplify find_vma_prev()
has been added to the -mm tree.  Its filename is
     mm-simplify-find_vma_prev.patch

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
Subject: mm: simplify find_vma_prev()

commit 297c5eee37 ("mm: make the vma list be doubly linked") added the
vm_prev member to vm_area_struct.  We can simplify find_vma_prev() by
using it.  Also, this change helps to improve page fault performance
because it has stronger locality of reference.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   40 +++++++++++-----------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff -puN mm/mmap.c~mm-simplify-find_vma_prev mm/mmap.c
--- a/mm/mmap.c~mm-simplify-find_vma_prev
+++ a/mm/mmap.c
@@ -1626,39 +1626,21 @@ struct vm_area_struct *find_vma(struct m
 
 EXPORT_SYMBOL(find_vma);
 
-/* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
+/*
+ * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
+ * Note: pprev is set to NULL when return value is NULL.
+ */
 struct vm_area_struct *
-find_vma_prev(struct mm_struct *mm, unsigned long addr,
-			struct vm_area_struct **pprev)
+find_vma_prev(struct mm_struct *mm, unsigned long addr, struct vm_area_struct **pprev)
 {
-	struct vm_area_struct *vma = NULL, *prev = NULL;
-	struct rb_node *rb_node;
-	if (!mm)
-		goto out;
-
-	/* Guard against addr being lower than the first VMA */
-	vma = mm->mmap;
-
-	/* Go through the RB tree quickly. */
-	rb_node = mm->mm_rb.rb_node;
+	struct vm_area_struct *vma;
 
-	while (rb_node) {
-		struct vm_area_struct *vma_tmp;
-		vma_tmp = rb_entry(rb_node, struct vm_area_struct, vm_rb);
-
-		if (addr < vma_tmp->vm_end) {
-			rb_node = rb_node->rb_left;
-		} else {
-			prev = vma_tmp;
-			if (!prev->vm_next || (addr < prev->vm_next->vm_end))
-				break;
-			rb_node = rb_node->rb_right;
-		}
-	}
+	*pprev = NULL;
+	vma = find_vma(mm, addr);
+	if (vma)
+		*pprev = vma->vm_prev;
 
-out:
-	*pprev = prev;
-	return prev ? prev->vm_next : vma;
+	return vma;
 }
 
 /*
_
Subject: Subject: mm: simplify find_vma_prev()

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

