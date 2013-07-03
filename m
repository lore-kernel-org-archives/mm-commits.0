From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-soft-dirty-bits-for-user-memory-changes-tracking-call-mmu-notifiers-when-write-protecting-ptes.patch removed from -mm tree
Date: Wed, 03 Jul 2013 14:24:15 -0700
Message-ID: <51d4967f.0EG0a6I+vzsaEKV1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3GCVYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:24:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, sfr@canb.auug.org.au, mtosatti@redhat.com, mpm@selenic.com, kosaki.motohiro@gmail.com, glommer@parallels.com, xemul@parallels.com

Subject: [folded-merged] mm-soft-dirty-bits-for-user-memory-changes-tracking-call-mmu-notifiers-when-write-protecting-ptes.patch removed from -mm tree
To: xemul@parallels.com,glommer@parallels.com,kosaki.motohiro@gmail.com,mpm@selenic.com,mtosatti@redhat.com,sfr@canb.auug.org.au,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:24:15 -0700


The patch titled
     Subject: soft-dirty: call mmu notifiers when write-protecting ptes
has been removed from the -mm tree.  Its filename was
     mm-soft-dirty-bits-for-user-memory-changes-tracking-call-mmu-notifiers-when-write-protecting-ptes.patch

This patch was dropped because it was folded into mm-soft-dirty-bits-for-user-memory-changes-tracking.patch

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: soft-dirty: call mmu notifiers when write-protecting ptes

As noticed by Xiao, since soft-dirty clear command modifies page tables we
have to flush tlbs and call mmu notifiers.  While the former is done by
the clear_refs engine itself, the latter is to be done.

One thing to note about this -- in order not to call per-page invalidate
notifier (_all_ address space is about to be changed), the
_invalidate_range_start and _end are used.  But for those start and end
are not known exactly.  To address this, the same trick as in exit_mmap()
is used -- start is 0 and end is (unsigned long)-1.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/proc/task_mmu.c~mm-soft-dirty-bits-for-user-memory-changes-tracking-call-mmu-notifiers-when-write-protecting-ptes fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-soft-dirty-bits-for-user-memory-changes-tracking-call-mmu-notifiers-when-write-protecting-ptes
+++ a/fs/proc/task_mmu.c
@@ -11,6 +11,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/elf.h>
 #include <asm/uaccess.h>
@@ -791,6 +792,8 @@ static ssize_t clear_refs_write(struct f
 			.private = &cp,
 		};
 		down_read(&mm->mmap_sem);
+		if (type == CLEAR_REFS_SOFT_DIRTY)
+			mmu_notifier_invalidate_range_start(mm, 0, -1);
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
 			cp.vma = vma;
 			if (is_vm_hugetlb_page(vma))
@@ -811,6 +814,8 @@ static ssize_t clear_refs_write(struct f
 			walk_page_range(vma->vm_start, vma->vm_end,
 					&clear_refs_walk);
 		}
+		if (type == CLEAR_REFS_SOFT_DIRTY)
+			mmu_notifier_invalidate_range_end(mm, 0, -1);
 		flush_tlb_mm(mm);
 		up_read(&mm->mmap_sem);
 		mmput(mm);
_

Patches currently in -mm which might be from xemul@parallels.com are

clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch
ptrace-add-ability-to-get-set-signal-blocked-mask.patch
fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid.patch
kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch
kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch
kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch

