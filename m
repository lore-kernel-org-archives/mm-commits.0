From: akpm@linux-foundation.org
Subject: + vmstat-remove-bug_on-from-vmstat_update.patch added to -mm tree
Date: Fri, 22 Jan 2016 13:39:07 -0800
Message-ID: <56a2a17b.CSFwefamu/of5/Ia%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbcAVVjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jan 2016 16:39:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, mhocko@suse.com, sasha.levin@oracle.com, shiraz.linux.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: remove BUG_ON from vmstat_update
has been added to the -mm tree.  Its filename is
     vmstat-remove-bug_on-from-vmstat_update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-remove-bug_on-from-vmstat_update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-remove-bug_on-from-vmstat_update.patch

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
Subject: vmstat: remove BUG_ON from vmstat_update

If we detect that there is nothing to do just set the flag and do not
check if it was already set before.  Races really do not matter.  If the
flag is set by any code then the shepherd will start dealing with the
situation and reenable the vmstat workers when necessary again.

Since 0eb77e988032 ("vmstat: make vmstat_updater deferrable again and shut
down on idle") quiet_vmstat might update cpu_stat_off and mark a
particular cpu to be handled by vmstat_shepherd.  This might trigger a
VM_BUG_ON in vmstat_update because the work item might have been sleeping
during the idle period and see the cpu_stat_off updated after the wake up.
The VM_BUG_ON is therefore misleading and no more appropriate.  Moreover
it doesn't really suite any protection from real bugs because
vmstat_shepherd will simply reschedule the vmstat_work anytime it sees a
particular cpu set or vmstat_update would do the same from the worker
context directly.  Even when the two would race the result wouldn't be
incorrect as the counters update is fully idempotent.

Fixes: 0eb77e988032 ("vmstat: make vmstat_updater deferrable again and shut down on idle")
Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Shiraz Hashim <shiraz.linux.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN mm/vmstat.c~vmstat-remove-bug_on-from-vmstat_update mm/vmstat.c
--- a/mm/vmstat.c~vmstat-remove-bug_on-from-vmstat_update
+++ a/mm/vmstat.c
@@ -1408,17 +1408,7 @@ static void vmstat_update(struct work_st
 		 * Defer the checking for differentials to the
 		 * shepherd thread on a different processor.
 		 */
-		int r;
-		/*
-		 * Shepherd work thread does not race since it never
-		 * changes the bit if its zero but the cpu
-		 * online / off line code may race if
-		 * worker threads are still allowed during
-		 * shutdown / startup.
-		 */
-		r = cpumask_test_and_set_cpu(smp_processor_id(),
-			cpu_stat_off);
-		VM_BUG_ON(r);
+		cpumask_set_cpu(smp_processor_id(), cpu_stat_off);
 	}
 }
 
_

Patches currently in -mm which might be from cl@linux.com are

vmstat-remove-bug_on-from-vmstat_update.patch

