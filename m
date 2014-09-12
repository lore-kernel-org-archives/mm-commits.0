From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmap-use-pr_emerg-when-printing-bug-related-information.patch removed
 from -mm tree
Date: Fri, 12 Sep 2014 13:13:08 -0700
Message-ID: <541353d4./Huwe0EhP1Ak2N8q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaILUNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 16:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: use pr_emerg when printing BUG related information
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-pr_emerg-when-printing-bug-related-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm/mmap.c: use pr_emerg when printing BUG related information

Make sure we actually see the output of validate_mm() and browse_rb()
before triggering a BUG().  pr_info isn't shown by default so the reason
for the BUG() isn't obvious.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/mmap.c~mm-mmap-use-pr_emerg-when-printing-bug-related-information mm/mmap.c
--- a/mm/mmap.c~mm-mmap-use-pr_emerg-when-printing-bug-related-information
+++ a/mm/mmap.c
@@ -369,20 +369,20 @@ static int browse_rb(struct rb_root *roo
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
 		if (vma->vm_start < prev) {
-			pr_info("vm_start %lx prev %lx\n", vma->vm_start, prev);
+			pr_emerg("vm_start %lx prev %lx\n", vma->vm_start, prev);
 			bug = 1;
 		}
 		if (vma->vm_start < pend) {
-			pr_info("vm_start %lx pend %lx\n", vma->vm_start, pend);
+			pr_emerg("vm_start %lx pend %lx\n", vma->vm_start, pend);
 			bug = 1;
 		}
 		if (vma->vm_start > vma->vm_end) {
-			pr_info("vm_end %lx < vm_start %lx\n",
+			pr_emerg("vm_end %lx < vm_start %lx\n",
 				vma->vm_end, vma->vm_start);
 			bug = 1;
 		}
 		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma)) {
-			pr_info("free gap %lx, correct %lx\n",
+			pr_emerg("free gap %lx, correct %lx\n",
 			       vma->rb_subtree_gap,
 			       vma_compute_subtree_gap(vma));
 			bug = 1;
@@ -396,7 +396,7 @@ static int browse_rb(struct rb_root *roo
 	for (nd = pn; nd; nd = rb_prev(nd))
 		j++;
 	if (i != j) {
-		pr_info("backwards %d, forwards %d\n", j, i);
+		pr_emerg("backwards %d, forwards %d\n", j, i);
 		bug = 1;
 	}
 	return bug ? -1 : i;
@@ -431,17 +431,17 @@ static void validate_mm(struct mm_struct
 		i++;
 	}
 	if (i != mm->map_count) {
-		pr_info("map_count %d vm_next %d\n", mm->map_count, i);
+		pr_emerg("map_count %d vm_next %d\n", mm->map_count, i);
 		bug = 1;
 	}
 	if (highest_address != mm->highest_vm_end) {
-		pr_info("mm->highest_vm_end %lx, found %lx\n",
+		pr_emerg("mm->highest_vm_end %lx, found %lx\n",
 		       mm->highest_vm_end, highest_address);
 		bug = 1;
 	}
 	i = browse_rb(&mm->mm_rb);
 	if (i != mm->map_count) {
-		pr_info("map_count %d rb %d\n", mm->map_count, i);
+		pr_emerg("map_count %d rb %d\n", mm->map_count, i);
 		bug = 1;
 	}
 	BUG_ON(bug);
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fsnotify-dont-put-user-context-if-it-was-never-assigned.patch
mm-balloon_compaction-ignore-anonymous-pages.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-dump_vma-fix-2.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-move-debug-code-out-of-page_allocc.patch
mm-introduce-vm_bug_on_mm.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-use-vm_bug_on_mm-where-possible.patch
mm-debugc-use-pr_emerg.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

