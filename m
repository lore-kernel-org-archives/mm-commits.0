From: akpm@linux-foundation.org
Subject: [merged]
 proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:31:42 -0800
Message-ID: <20180201193142.ByZ5fkc3U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58030 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753060AbeBATbn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:31:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: fs/proc/task_mmu.c: do not show VmExe bigger than total executable virtual memory
has been removed from the -mm tree.  Its filename was
     proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


I've seen this for huge (>2Gb) statically linked binary which has whole
world inside.  For it start_code ..  end_code range also covers one of
rodata sections.  Probably this is bug in customized linker, elf loader
or both.

Anyway CONFIG_CHECKPOINT_RESTORE allows to change these pointers,
thus we cannot trust them without validation.

Link: http://lkml.kernel.org/r/150728955451.743749.11276392315459539583.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory
+++ a/fs/proc/task_mmu.c
@@ -47,8 +47,11 @@ void task_mem(struct seq_file *m, struct
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
 	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
@@ -76,7 +79,9 @@ void task_mem(struct seq_file *m, struct
 		file << (PAGE_SHIFT-10),
 		shmem << (PAGE_SHIFT-10),
 		mm->data_vm << (PAGE_SHIFT-10),
-		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
+		mm->stack_vm << (PAGE_SHIFT-10),
+		text >> 10,
+		lib >> 10,
 		mm_pgtables_bytes(mm) >> 10,
 		swap << (PAGE_SHIFT-10));
 	hugetlb_report_usage(m, mm);
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are


