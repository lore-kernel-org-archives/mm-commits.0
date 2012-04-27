From: akpm@linux-foundation.org
Subject: + blackfin-fix-possible-deadlock-in-decode_address.patch added to -mm tree
Date: Thu, 26 Apr 2012 17:06:04 -0700
Message-ID: <20120427000604.E918EA042D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:54477 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758020Ab2D0AGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2012 20:06:08 -0400
Received: by laai8 with SMTP id i8so5582laa.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 17:06:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton.vorontsov@linaro.org, oleg@redhat.com, vapier@gentoo.org


The patch titled
     Subject: blackfin: fix possible deadlock in decode_address()
has been added to the -mm tree.  Its filename is
     blackfin-fix-possible-deadlock-in-decode_address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: blackfin: fix possible deadlock in decode_address()

Oleg Nesterov found an interesting deadlock possibility:

> sysrq_showregs_othercpus() does smp_call_function(showacpu)
> and showacpu() show_stack()->decode_address(). Now suppose that IPI
> interrupts the task holding read_lock(tasklist).

To fix this, blackfin should not grab the write_ variant of the
tasklist lock, read_ one is enough.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/trace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/blackfin/kernel/trace.c~blackfin-fix-possible-deadlock-in-decode_address arch/blackfin/kernel/trace.c
--- a/arch/blackfin/kernel/trace.c~blackfin-fix-possible-deadlock-in-decode_address
+++ a/arch/blackfin/kernel/trace.c
@@ -29,7 +29,7 @@ void decode_address(char *buf, unsigned 
 {
 	struct task_struct *p;
 	struct mm_struct *mm;
-	unsigned long flags, offset;
+	unsigned long offset;
 	struct rb_node *n;
 
 #ifdef CONFIG_KALLSYMS
@@ -113,7 +113,7 @@ void decode_address(char *buf, unsigned 
 	 * mappings of all our processes and see if we can't be a whee
 	 * bit more specific
 	 */
-	write_lock_irqsave(&tasklist_lock, flags);
+	read_lock(&tasklist_lock);
 	for_each_process(p) {
 		struct task_struct *t;
 
@@ -186,7 +186,7 @@ __continue:
 	sprintf(buf, "/* kernel dynamic memory */");
 
 done:
-	write_unlock_irqrestore(&tasklist_lock, flags);
+	read_unlock(&tasklist_lock);
 }
 
 #define EXPAND_LEN ((1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN) * 256 - 1)
_
Subject: Subject: blackfin: fix possible deadlock in decode_address()

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

cpu-introduce-clear_tasks_mm_cpumask-helper.patch
arm-use-clear_tasks_mm_cpumask.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch

