From: akpm@linux-foundation.org
Subject: +
 mm-mmap-use-pr_emerg-when-printing-bug-related-information.patch added to
 -mm tree
Date: Thu, 04 Sep 2014 13:20:31 -0700
Message-ID: <5408c98f.o9tVRSSk0HGrvtLH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaIDUUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2014 16:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: use pr_emerg when printing BUG related information
has been added to the -mm tree.  Its filename is
     mm-mmap-use-pr_emerg-when-printing-bug-related-information.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-use-pr_emerg-when-printing-bug-related-information.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-use-pr_emerg-when-printing-bug-related-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmap-use-pr_emerg-when-printing-bug-related-information.patch
mm-balloon_compaction-ignore-anonymous-pages.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-dump_vma-fix-2.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

