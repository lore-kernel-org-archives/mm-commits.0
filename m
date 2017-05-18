From: akpm@linux-foundation.org
Subject: + virtually-mapped-stacks-do-not-disable-interrupts.patch added
 to -mm tree
Date: Thu, 18 May 2017 13:31:18 -0700
Message-ID: <591e0496.hx8VYn4k9zfofRdG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753775AbdERUbT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 16:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, luto@amacapital.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: virtually mapped stacks: do not disable interrupts
has been added to the -mm tree.  Its filename is
     virtually-mapped-stacks-do-not-disable-interrupts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/virtually-mapped-stacks-do-not-disable-interrupts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/virtually-mapped-stacks-do-not-disable-interrupts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: kernel/fork.c: virtually mapped stacks: do not disable interrupts

The reason to disable interrupts seems to be to avoid switching to a
different processor while handling per cpu data using individual loads and
stores.  If we use per cpu RMV primitives we will not have to disable
interrupts.

Link: http://lkml.kernel.org/r/alpine.DEB.2.20.1705171055130.5898@east.gentwo.org
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN kernel/fork.c~virtually-mapped-stacks-do-not-disable-interrupts kernel/fork.c
--- a/kernel/fork.c~virtually-mapped-stacks-do-not-disable-interrupts
+++ a/kernel/fork.c
@@ -205,19 +205,17 @@ static unsigned long *alloc_thread_stack
 	void *stack;
 	int i;
 
-	local_irq_disable();
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		struct vm_struct *s = this_cpu_read(cached_stacks[i]);
+		struct vm_struct *s;
+
+		s = this_cpu_xchg(cached_stacks[i], NULL);
 
 		if (!s)
 			continue;
-		this_cpu_write(cached_stacks[i], NULL);
 
 		tsk->stack_vm_area = s;
-		local_irq_enable();
 		return s->addr;
 	}
-	local_irq_enable();
 
 	stack = __vmalloc_node_range(THREAD_SIZE, THREAD_SIZE,
 				     VMALLOC_START, VMALLOC_END,
@@ -245,19 +243,15 @@ static inline void free_thread_stack(str
 {
 #ifdef CONFIG_VMAP_STACK
 	if (task_stack_vm_area(tsk)) {
-		unsigned long flags;
 		int i;
 
-		local_irq_save(flags);
 		for (i = 0; i < NR_CACHED_STACKS; i++) {
-			if (this_cpu_read(cached_stacks[i]))
+			if (this_cpu_cmpxchg(cached_stacks[i],
+					NULL, tsk->stack_vm_area) != NULL)
 				continue;
 
-			this_cpu_write(cached_stacks[i], tsk->stack_vm_area);
-			local_irq_restore(flags);
 			return;
 		}
-		local_irq_restore(flags);
 
 		vfree_atomic(tsk->stack);
 		return;
_

Patches currently in -mm which might be from cl@linux.com are

virtually-mapped-stacks-do-not-disable-interrupts.patch

