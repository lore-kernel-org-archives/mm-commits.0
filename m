From: akpm@linux-foundation.org
Subject: [merged] mm-check-rb_subtree_gap-correctness.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:59:09 -0800
Message-ID: <20121212195910.03039100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:52007 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLUEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:04:30 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so119589qad.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:04:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: check rb_subtree_gap correctness
has been removed from the -mm tree.  Its filename was
     mm-check-rb_subtree_gap-correctness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: check rb_subtree_gap correctness

When CONFIG_DEBUG_VM_RB is enabled, check that rb_subtree_gap is correctly
set for every vma and that mm->highest_vm_end is also correct.

Also add an explicit 'bug' variable to track if browse_rb() detected any
invalid condition.

[akpm@linux-foundation.org: repair innovative coding-style inventions]
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

 mm/mmap.c |   53 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff -puN mm/mmap.c~mm-check-rb_subtree_gap-correctness mm/mmap.c
--- a/mm/mmap.c~mm-check-rb_subtree_gap-correctness
+++ a/mm/mmap.c
@@ -322,31 +322,45 @@ static long vma_compute_subtree_gap(stru
 #ifdef CONFIG_DEBUG_VM_RB
 static int browse_rb(struct rb_root *root)
 {
-	int i = 0, j;
+	int i = 0, j, bug = 0;
 	struct rb_node *nd, *pn = NULL;
 	unsigned long prev = 0, pend = 0;
 
 	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
-		if (vma->vm_start < prev)
-			printk("vm_start %lx prev %lx\n", vma->vm_start, prev), i = -1;
-		if (vma->vm_start < pend)
+		if (vma->vm_start < prev) {
+			printk("vm_start %lx prev %lx\n", vma->vm_start, prev);
+			bug = 1;
+		}
+		if (vma->vm_start < pend) {
 			printk("vm_start %lx pend %lx\n", vma->vm_start, pend);
-		if (vma->vm_start > vma->vm_end)
-			printk("vm_end %lx < vm_start %lx\n", vma->vm_end, vma->vm_start);
+			bug = 1;
+		}
+		if (vma->vm_start > vma->vm_end) {
+			printk("vm_end %lx < vm_start %lx\n",
+				vma->vm_end, vma->vm_start);
+			bug = 1;
+		}
+		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma)) {
+			printk("free gap %lx, correct %lx\n",
+			       vma->rb_subtree_gap,
+			       vma_compute_subtree_gap(vma));
+			bug = 1;
+		}
 		i++;
 		pn = nd;
 		prev = vma->vm_start;
 		pend = vma->vm_end;
 	}
 	j = 0;
-	for (nd = pn; nd; nd = rb_prev(nd)) {
+	for (nd = pn; nd; nd = rb_prev(nd))
 		j++;
+	if (i != j) {
+		printk("backwards %d, forwards %d\n", j, i);
+		bug = 1;
 	}
-	if (i != j)
-		printk("backwards %d, forwards %d\n", j, i), i = 0;
-	return i;
+	return bug ? -1 : i;
 }
 
 static void validate_mm_rb(struct rb_root *root, struct vm_area_struct *ignore)
@@ -365,6 +379,7 @@ void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
 	int i = 0;
+	unsigned long highest_address = 0;
 	struct vm_area_struct *vma = mm->mmap;
 	while (vma) {
 		struct anon_vma_chain *avc;
@@ -372,14 +387,24 @@ void validate_mm(struct mm_struct *mm)
 		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 			anon_vma_interval_tree_verify(avc);
 		vma_unlock_anon_vma(vma);
+		highest_address = vma->vm_end;
 		vma = vma->vm_next;
 		i++;
 	}
-	if (i != mm->map_count)
-		printk("map_count %d vm_next %d\n", mm->map_count, i), bug = 1;
+	if (i != mm->map_count) {
+		printk("map_count %d vm_next %d\n", mm->map_count, i);
+		bug = 1;
+	}
+	if (highest_address != mm->highest_vm_end) {
+		printk("mm->highest_vm_end %lx, found %lx\n",
+		       mm->highest_vm_end, highest_address);
+		bug = 1;
+	}
 	i = browse_rb(&mm->mm_rb);
-	if (i != mm->map_count)
-		printk("map_count %d rb %d\n", mm->map_count, i), bug = 1;
+	if (i != mm->map_count) {
+		printk("map_count %d rb %d\n", mm->map_count, i);
+		bug = 1;
+	}
 	BUG_ON(bug);
 }
 #else
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
mm-protect-against-concurrent-vma-expansion.patch
linux-next.patch
lib-rbtree_testc-fix-uninitialized-variable-warning.patch
random32-rename-random32-to-prandom.patch
prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch
bnx2x-use-prandom_bytes.patch
mtd-nandsim-use-prandom_bytes.patch
ubifs-use-prandom_bytes.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch

