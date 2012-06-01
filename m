From: akpm@linux-foundation.org
Subject: [merged] blackfin-fix-possible-deadlock-in-decode_address.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:21 -0700
Message-ID: <20120601193421.58EB7A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53411 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178Ab2FATeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:22 -0400
Received: by qcsp5 with SMTP id p5so246834qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, oleg@redhat.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: blackfin: fix possible deadlock in decode_address()
has been removed from the -mm tree.  Its filename was
     blackfin-fix-possible-deadlock-in-decode_address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch

