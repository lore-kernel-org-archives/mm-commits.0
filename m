From: akpm@linux-foundation.org
Subject: +
 proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory.patch
 added to -mm tree
Date: Tue, 10 Oct 2017 15:25:10 -0700
Message-ID: <59dd48c6.EHtJRhfycQfFShdq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdJJWZL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 18:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: do not show VmExe bigger than total executable virtual memory
has been added to the -mm tree.  Its filename is
     proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: fs/proc/task_mmu.c: do not show VmExe bigger than total executable virtual memory

If start_code / end_code pointers are screwed then "VmExe" could be bigger
than total executable virtual memory and "VmLib" becomes negative:

VmExe:	  294320 kB
VmLib:	18446744073709327564 kB

VmExe and VmLib documented as text segment and shared library code size.

Now their sum will be always equal to mm->exec_vm which sums size of
executable and not writable and not stack areas.

Link: http://lkml.kernel.org/r/150728955451.743749.11276392315459539583.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory
+++ a/fs/proc/task_mmu.c
@@ -46,8 +46,11 @@ void task_mem(struct seq_file *m, struct
 	if (hiwater_rss < mm->hiwater_rss)
 		hiwater_rss = mm->hiwater_rss;
 
-	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
-	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
+	/* split executable areas between text and lib */
+	text = PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK);
+	text = min(text, mm->exec_vm << PAGE_SHIFT);
+	lib = (mm->exec_vm << PAGE_SHIFT) - text;
+
 	swap = get_mm_counter(mm, MM_SWAPENTS);
 	ptes = PTRS_PER_PTE * sizeof(pte_t) * atomic_long_read(&mm->nr_ptes);
 	pmds = PTRS_PER_PMD * sizeof(pmd_t) * mm_nr_pmds(mm);
@@ -80,7 +83,9 @@ void task_mem(struct seq_file *m, struct
 		file << (PAGE_SHIFT-10),
 		shmem << (PAGE_SHIFT-10),
 		mm->data_vm << (PAGE_SHIFT-10),
-		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
+		mm->stack_vm << (PAGE_SHIFT-10),
+		text >> 10,
+		lib >> 10,
 		ptes >> 10,
 		pmds >> 10,
 		puds >> 10,
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kmemleak-clear-stale-pointers-from-task-stacks.patch
kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644.patch
proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory.patch

