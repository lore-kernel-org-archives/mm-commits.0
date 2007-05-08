From: akpm@linux-foundation.org
Subject: + mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch added to -mm tree
Date: Tue, 08 May 2007 16:24:21 -0700
Message-ID: <200705082324.l48NOLc4004649@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967345AbXEHXZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:25:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au, npiggin@suse.de, rusty@rustcorp.com.au


The patch titled
     get_user_pages vs mmap MAP_FIXED bug
has been added to the -mm tree.  Its filename is
     mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: get_user_pages vs mmap MAP_FIXED bug
From: Nick Piggin <nickpiggin@yahoo.com.au>

Fix a couple of places that should be testing fault as well as nopage.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 mm/rmap.c   |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix mm/memory.c
--- a/mm/memory.c~mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix
+++ a/mm/memory.c
@@ -1077,7 +1077,8 @@ int get_user_pages(struct task_struct *t
 		if (pages)
 			foll_flags |= FOLL_GET;
 		if (!write && !(vma->vm_flags & VM_LOCKED) &&
-		    (!vma->vm_ops || !vma->vm_ops->nopage))
+		    (!vma->vm_ops || (!vma->vm_ops->nopage &&
+					!vma->vm_ops->fault)))
 			foll_flags |= FOLL_ANON;
 
 		do {
diff -puN mm/rmap.c~mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix mm/rmap.c
--- a/mm/rmap.c~mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix
+++ a/mm/rmap.c
@@ -641,8 +641,10 @@ void page_remove_rmap(struct page *page,
 			printk (KERN_EMERG "  page->count = %x\n", page_count(page));
 			printk (KERN_EMERG "  page->mapping = %p\n", page->mapping);
 			print_symbol (KERN_EMERG "  vma->vm_ops = %s\n", (unsigned long)vma->vm_ops);
-			if (vma->vm_ops)
+			if (vma->vm_ops) {
 				print_symbol (KERN_EMERG "  vma->vm_ops->nopage = %s\n", (unsigned long)vma->vm_ops->nopage);
+				print_symbol (KERN_EMERG "  vma->vm_ops->fault = %s\n", (unsigned long)vma->vm_ops->fault);
+			}
 			if (vma->vm_file && vma->vm_file->f_op)
 				print_symbol (KERN_EMERG "  vma->vm_file->f_op->mmap = %s\n", (unsigned long)vma->vm_file->f_op->mmap);
 			BUG();
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
as-fix-antic_expire-check.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-align-rq-to-cacheline-boundary.patch
ia64-race-flushing-icache-in-do_no_page-path.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
kblockd-use-flush_work.patch
sched2-sched-domain-sysctl.patch
futex-new-private-futexes.patch
revoke-core-code-break-cow-fixes.patch
