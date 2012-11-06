From: akpm@linux-foundation.org
Subject: + mm-check-rb_subtree_gap-correctness.patch added to -mm tree
Date: Tue, 06 Nov 2012 14:38:56 -0800
Message-ID: <20121106223857.4A5ED100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63374 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2KFWi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 17:38:59 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so108108vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 14:38:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm: check rb_subtree_gap correctness
has been added to the -mm tree.  Its filename is
     mm-check-rb_subtree_gap-correctness.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: check rb_subtree_gap correctness

When CONFIG_DEBUG_VM_RB is enabled, check that rb_subtree_gap is correctly
set for every vma and that mm->highest_vm_end is also correct.

Also add an explicit 'bug' variable to track if browse_rb() detected any
invalid condition.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN mm/mmap.c~mm-check-rb_subtree_gap-correctness mm/mmap.c
--- a/mm/mmap.c~mm-check-rb_subtree_gap-correctness
+++ a/mm/mmap.c
@@ -365,7 +365,7 @@ static void vma_rb_erase(struct vm_area_
 #ifdef CONFIG_DEBUG_VM_RB
 static int browse_rb(struct rb_root *root)
 {
-	int i = 0, j;
+	int i = 0, j, bug = 0;
 	struct rb_node *nd, *pn = NULL;
 	unsigned long prev = 0, pend = 0;
 
@@ -373,29 +373,33 @@ static int browse_rb(struct rb_root *roo
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
 		if (vma->vm_start < prev)
-			printk("vm_start %lx prev %lx\n", vma->vm_start, prev), i = -1;
+			printk("vm_start %lx prev %lx\n", vma->vm_start, prev), bug = 1;
 		if (vma->vm_start < pend)
-			printk("vm_start %lx pend %lx\n", vma->vm_start, pend);
+			printk("vm_start %lx pend %lx\n", vma->vm_start, pend), bug = 1;
 		if (vma->vm_start > vma->vm_end)
-			printk("vm_end %lx < vm_start %lx\n", vma->vm_end, vma->vm_start);
+			printk("vm_end %lx < vm_start %lx\n", vma->vm_end, vma->vm_start), bug = 1;
+		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma))
+			printk("free gap %lx, correct %lx\n",
+			       vma->rb_subtree_gap,
+			       vma_compute_subtree_gap(vma)), bug = 1;
 		i++;
 		pn = nd;
 		prev = vma->vm_start;
 		pend = vma->vm_end;
 	}
 	j = 0;
-	for (nd = pn; nd; nd = rb_prev(nd)) {
+	for (nd = pn; nd; nd = rb_prev(nd))
 		j++;
-	}
 	if (i != j)
-		printk("backwards %d, forwards %d\n", j, i), i = 0;
-	return i;
+		printk("backwards %d, forwards %d\n", j, i), bug = 1;
+	return bug ? -1 : i;
 }
 
 void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
 	int i = 0;
+	unsigned long highest_address = 0;
 	struct vm_area_struct *vma = mm->mmap;
 	while (vma) {
 		struct anon_vma_chain *avc;
@@ -403,11 +407,15 @@ void validate_mm(struct mm_struct *mm)
 		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 			anon_vma_interval_tree_verify(avc);
 		vma_unlock_anon_vma(vma);
+		highest_address = vma->vm_end;
 		vma = vma->vm_next;
 		i++;
 	}
 	if (i != mm->map_count)
 		printk("map_count %d vm_next %d\n", mm->map_count, i), bug = 1;
+	if (highest_address != mm->highest_vm_end)
+		printk("mm->highest_vm_end %lx, found %lx\n",
+		       mm->highest_vm_end, highest_address), bug = 1;
 	i = browse_rb(&mm->mm_rb);
 	if (i != mm->map_count)
 		printk("map_count %d rb %d\n", mm->map_count, i), bug = 1;
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-add-anon_vma_lock-to-validate_mm.patch
mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-check-rb_subtree_gap-correctness.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch

