From: akpm@linux-foundation.org
Subject: - mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch removed from -mm tree
Date: Tue, 15 May 2007 23:04:10 -0700
Message-ID: <200705160604.l4G649cW027492@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41717 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212AbXEPGHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 02:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, npiggin@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     get_user_pages vs mmap MAP_FIXED bug
has been removed from the -mm tree.  Its filename was
     mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch

This patch was dropped because it was folded into mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch

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
@@ -1049,7 +1049,8 @@ int get_user_pages(struct task_struct *t
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
@@ -643,8 +643,10 @@ void page_remove_rmap(struct page *page,
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

slob-implement-rcu-freeing.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
sched2-sched-domain-sysctl.patch
