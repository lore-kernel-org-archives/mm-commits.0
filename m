From: akpm@linux-foundation.org
Subject: + mm-validate_mm-browse_rb-smp-race-condition.patch added to -mm
 tree
Date: Mon, 01 Feb 2016 16:40:50 -0800
Message-ID: <56affb12.gXsgW19yTiM+fNQ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbcBBAkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 19:40:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dvyukov@google.com, koct9i@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: validate_mm browse_rb SMP race condition
has been added to the -mm tree.  Its filename is
     mm-validate_mm-browse_rb-smp-race-condition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-validate_mm-browse_rb-smp-race-condition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-validate_mm-browse_rb-smp-race-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: validate_mm browse_rb SMP race condition

The mmap_sem for reading in validate_mm called from expand_stack is not
enough to prevent the argumented rbtree rb_subtree_gap information to
change from under us because expand_stack may be running from other
threads concurrently which will hold the mmap_sem for reading too.

The argumented rbtree is updated with vma_gap_update under the
page_table_lock so use it in browse_rb() too to avoid false positives.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-validate_mm-browse_rb-smp-race-condition mm/mmap.c
--- a/mm/mmap.c~mm-validate_mm-browse_rb-smp-race-condition
+++ a/mm/mmap.c
@@ -390,8 +390,9 @@ static long vma_compute_subtree_gap(stru
 }
 
 #ifdef CONFIG_DEBUG_VM_RB
-static int browse_rb(struct rb_root *root)
+static int browse_rb(struct mm_struct *mm)
 {
+	struct rb_root *root = &mm->mm_rb;
 	int i = 0, j, bug = 0;
 	struct rb_node *nd, *pn = NULL;
 	unsigned long prev = 0, pend = 0;
@@ -414,12 +415,14 @@ static int browse_rb(struct rb_root *roo
 				  vma->vm_start, vma->vm_end);
 			bug = 1;
 		}
+		spin_lock(&mm->page_table_lock);
 		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma)) {
 			pr_emerg("free gap %lx, correct %lx\n",
 			       vma->rb_subtree_gap,
 			       vma_compute_subtree_gap(vma));
 			bug = 1;
 		}
+		spin_unlock(&mm->page_table_lock);
 		i++;
 		pn = nd;
 		prev = vma->vm_start;
@@ -475,7 +478,7 @@ static void validate_mm(struct mm_struct
 			  mm->highest_vm_end, highest_address);
 		bug = 1;
 	}
-	i = browse_rb(&mm->mm_rb);
+	i = browse_rb(mm);
 	if (i != mm->map_count) {
 		if (i != -1)
 			pr_emerg("map_count %d rb %d\n", mm->map_count, i);
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-validate_mm-browse_rb-smp-race-condition.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch

