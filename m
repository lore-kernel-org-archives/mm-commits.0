From: akpm@linux-foundation.org
Subject: [merged] mm-simplify-find_vma_prev.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:55 -0800
Message-ID: <20120111212756.269EF200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54553 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994Ab2AKV16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:58 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44236eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, shaohua.li@intel.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify find_vma_prev()
has been removed from the -mm tree.  Its filename was
     mm-simplify-find_vma_prev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: simplify find_vma_prev()

commit 297c5eee37 ("mm: make the vma list be doubly linked") added the
vm_prev member to vm_area_struct.  We can simplify find_vma_prev() by
using it.  Also, this change helps to improve page fault performance
because it has stronger locality of reference.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff -puN mm/mmap.c~mm-simplify-find_vma_prev mm/mmap.c
--- a/mm/mmap.c~mm-simplify-find_vma_prev
+++ a/mm/mmap.c
@@ -1603,39 +1603,19 @@ struct vm_area_struct *find_vma(struct m
 
 EXPORT_SYMBOL(find_vma);
 
-/* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
+/*
+ * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
+ * Note: pprev is set to NULL when return value is NULL.
+ */
 struct vm_area_struct *
 find_vma_prev(struct mm_struct *mm, unsigned long addr,
 			struct vm_area_struct **pprev)
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
-
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
+	struct vm_area_struct *vma;
 
-out:
-	*pprev = prev;
-	return prev ? prev->vm_next : vma;
+	vma = find_vma(mm, addr);
+	*pprev = vma ? vma->vm_prev : NULL;
+	return vma;
 }
 
 /*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
mm-take-pagevecs-off-reclaim-stack.patch
mm-fewer-underscores-in-____pagevec_lru_add.patch
mm-no-blank-line-after-export_symbol-in-swapc.patch
mm-enum-lru_list-lru.patch
mm-remove-del_page_from_lru-add-page_off_lru.patch
mm-remove-isolate_pages.patch
kexec-remove-kmsg_dump_kexec.patch
ipc-mqueue-simplify-reading-msgqueue-limit.patch

