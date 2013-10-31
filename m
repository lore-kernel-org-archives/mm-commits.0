From: akpm@linux-foundation.org
Subject: [merged]
 memcg-use-__this_cpu_sub-to-dec-stats-to-avoid-incorrect-subtrahend-casting.patch removed from -mm tree
Date: Thu, 31 Oct 2013 11:00:07 -0700
Message-ID: <52729aa7.fFxZIcnwVXPaI+8e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3JaSAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 14:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org, gthelen@google.com

Subject: [merged] memcg-use-__this_cpu_sub-to-dec-stats-to-avoid-incorrect-subtrahend-casting.patch removed from -mm tree
To: gthelen@google.com,hannes@cmpxchg.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 11:00:07 -0700


The patch titled
     Subject: memcg: use __this_cpu_sub() to dec stats to avoid incorrect subtrahend casting
has been removed from the -mm tree.  Its filename was
     memcg-use-__this_cpu_sub-to-dec-stats-to-avoid-incorrect-subtrahend-casting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: use __this_cpu_sub() to dec stats to avoid incorrect subtrahend casting

As of v3.11-9444-g3ea67d0 ("memcg: add per cgroup writeback pages
accounting") memcg counter errors are possible when moving charged memory
to a different memcg.  Charge movement occurs when processing writes to
memory.force_empty, moving tasks to a memcg with
memcg.move_charge_at_immigrate=1, or memcg deletion.  An example showing
error after memory.force_empty:

  $ cd /sys/fs/cgroup/memory
  $ mkdir x
  $ rm /data/tmp/file
  $ (echo $BASHPID >> x/tasks && exec mmap_writer /data/tmp/file 1M) &
  [1] 13600
  $ grep ^mapped x/memory.stat
  mapped_file 1048576
  $ echo 13600 > tasks
  $ echo 1 > x/memory.force_empty
  $ grep ^mapped x/memory.stat
  mapped_file 4503599627370496

mapped_file should end with 0.
  4503599627370496 == 0x10,0000,0000,0000 == 0x100,0000,0000 pages
  1048576          == 0x10,0000           == 0x100 pages

This issue only affects the source memcg on 64 bit machines; the
destination memcg counters are correct.  So the rmdir case is not too
important because such counters are soon disappearing with the entire
memcg.  But the memcg.force_empty and memory.move_charge_at_immigrate=1
cases are larger problems as the bogus counters are visible for the
(possibly long) remaining life of the source memcg.

The problem is due to memcg use of __this_cpu_from(.., -nr_pages), which
is subtly wrong because it subtracts the unsigned int nr_pages (either -1
or -512 for THP) from a signed long percpu counter.  When nr_pages=-1,
-nr_pages=0xffffffff.  On 64 bit machines stat->count[idx] is signed 64
bit.  So memcg's attempt to simply decrement a count (e.g.  from 1 to 0)
boils down to:

  long count = 1
  unsigned int nr_pages = 1
  count += -nr_pages  /* -nr_pages == 0xffff,ffff */
  count is now 0x1,0000,0000 instead of 0

The fix is to subtract the unsigned page count rather than adding its
negation.  This only works once "percpu: fix this_cpu_sub() subtrahend
casting for unsigneds" is applied to fix this_cpu_sub().

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-use-__this_cpu_sub-to-dec-stats-to-avoid-incorrect-subtrahend-casting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-__this_cpu_sub-to-dec-stats-to-avoid-incorrect-subtrahend-casting
+++ a/mm/memcontrol.c
@@ -3774,7 +3774,7 @@ void mem_cgroup_move_account_page_stat(s
 	/* Update stat data for mem_cgroup */
 	preempt_disable();
 	WARN_ON_ONCE(from->stat->count[idx] < nr_pages);
-	__this_cpu_add(from->stat->count[idx], -nr_pages);
+	__this_cpu_sub(from->stat->count[idx], nr_pages);
 	__this_cpu_add(to->stat->count[idx], nr_pages);
 	preempt_enable();
 }
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-refactor-mem_control_numa_stat_show.patch
memcg-support-hierarchical-memorynuma_stats.patch
percpu-add-test-module-for-various-percpu-operations.patch

