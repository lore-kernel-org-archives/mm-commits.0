From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-bring-back-the-vm_bug_on-in-mem_cgroup_swapout.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:56:33 -0700
Message-ID: <559ed1f1.4qSA1SSK8ZRU3j6v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbbGIT4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, hannes@cmpxchg.org, rostedt@goodmis.org, tglx@linutronix.de, williams@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: bring back the VM_BUG_ON() in mem_cgroup_swapout()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-bring-back-the-vm_bug_on-in-mem_cgroup_swapout.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-bring-back-the-vm_bug_on-in-mem_cgroup_swapout.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-bring-back-the-vm_bug_on-in-mem_cgroup_swapout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: memcontrol: bring back the VM_BUG_ON() in mem_cgroup_swapout()

Clark stumbled over a VM_BUG_ON() in -RT which was then was removed by
Johannes in commit f371763a79d ("mm: memcontrol: fix false-positive
VM_BUG_ON() on -rt").  The comment before that patch was a tiny bit better
than it is now.  While the patch claimed to fix a false-postive on -RT
this was not the case.  None of the -RT folks ACKed it and it was not a
false positive report.  That was a *real* problem.

This patch updates the comment that is improper because it refers to
"disabled preemption" as a consequence of that lock being taken.  A
spin_lock() disables preemption, true, but in this case the code relies on
the fact that the lock _also_ disables interrupts once it is acquired. 
And this is the important detail (which was checked the VM_BUG_ON()) which
needs to be pointed out.  This is the hint one needs while looking at the
code.  It was explained by Johannes on the list that the per-CPU variables
are protected by local_irq_save().  The BUG_ON() was helpful.  This code
has been workarounded in -RT in the meantime.  I wouldn't mind running
into more of those if the code in question uses *special* kind of locking
since now there is no verification (in terms of lockdep or BUG_ON()) and
therefore I bring the VM_BUG_ON() check back in.

The two functions after the comment could also have a "local_irq_save()"
dance around them in order to serialize access to the per-CPU variables. 
This has been avoided because the interrupts should be off.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Clark Williams <williams@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-bring-back-the-vm_bug_on-in-mem_cgroup_swapout mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-bring-back-the-vm_bug_on-in-mem_cgroup_swapout
+++ a/mm/memcontrol.c
@@ -5965,7 +5965,13 @@ void mem_cgroup_swapout(struct page *pag
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, 1);
 
-	/* Caller disabled preemption with mapping->tree_lock */
+	/*
+	 * Interrupts should be disabled here because the caller holds the
+	 * mapping->tree_lock lock which is taken with interrupts-off. It is
+	 * important here to have the interrupts disabled because it is the
+	 * only synchronisation we have for udpating the per-CPU variables.
+	 */
+	VM_BUG_ON(!irqs_disabled());
 	mem_cgroup_charge_statistics(memcg, page, -1);
 	memcg_check_events(memcg, page);
 }
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-memcontrol-bring-back-the-vm_bug_on-in-mem_cgroup_swapout.patch
linux-next.patch

