From: akpm@linux-foundation.org
Subject: + x86-stop-recursive-fault-in-print_context_stack-after-stack-overflow.patch added to -mm tree
Date: Fri, 23 Mar 2012 15:56:47 -0700
Message-ID: <20120323225648.15DD5A033B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45765 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab2CWW4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 18:56:49 -0400
Received: by qcsp5 with SMTP id p5so311987qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 15:56:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, fweisbec@gmail.com, hpa@zytor.com, mingo@kernel.org, namhyung@gmail.com, tglx@linutronix.de


The patch titled
     Subject: x86: stop recursive fault in print_context_stack after stack overflow
has been added to the -mm tree.  Its filename is
     x86-stop-recursive-fault-in-print_context_stack-after-stack-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: x86: stop recursive fault in print_context_stack after stack overflow

After printing out the first line of a stack backtrace,
print_context_stack() calls print_ftrace_graph_addr() to check if it's
making a graph of function calls, usually not the case.  But unfortunate
ordering of assignments causes this to oops if an earlier stack overflow
corrupted threadinfo->task.  Reorder to avoid that irritation.

(The fact that there was a stack overflow may often be more interesting
than the stack that can now be shown; but integrating that information
with this stacktrace is awkward, so leave it to overflow reporting.)

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/dumpstack.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/dumpstack.c~x86-stop-recursive-fault-in-print_context_stack-after-stack-overflow arch/x86/kernel/dumpstack.c
--- a/arch/x86/kernel/dumpstack.c~x86-stop-recursive-fault-in-print_context_stack-after-stack-overflow
+++ a/arch/x86/kernel/dumpstack.c
@@ -37,13 +37,16 @@ print_ftrace_graph_addr(unsigned long ad
 			const struct stacktrace_ops *ops,
 			struct thread_info *tinfo, int *graph)
 {
-	struct task_struct *task = tinfo->task;
+	struct task_struct *task;
 	unsigned long ret_addr;
-	int index = task->curr_ret_stack;
+	int index;
 
 	if (addr != (unsigned long)return_to_handler)
 		return;
 
+	task = tinfo->task;
+	index = task->curr_ret_stack;
+
 	if (!task->ret_stack || index < *graph)
 		return;
 
_
Subject: Subject: x86: stop recursive fault in print_context_stack after stack overflow

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
linux-next.patch
mm-for-fs-add-truncate_pagecache_range.patch
mm-for-fs-add-truncate_pagecache_range-fix.patch
x86-stop-recursive-fault-in-print_context_stack-after-stack-overflow.patch
memcg-change-behavior-of-moving-charges-at-task-move.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch

