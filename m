From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-nr_writeback-leak-in-memcg-and-system-stats.patch added
 to -mm tree
Date: Mon, 05 Feb 2018 16:18:59 -0800
Message-ID: <5a78f473.ixDDbmtWBk3vr8Xf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752179AbeBFATB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Feb 2018 19:19:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, akpm@linux-foundation.org, mhocko@suse.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix NR_WRITEBACK leak in memcg and system stats
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-nr_writeback-leak-in-memcg-and-system-stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-nr_writeback-leak-in-memcg-and-system-stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-nr_writeback-leak-in-memcg-and-system-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix NR_WRITEBACK leak in memcg and system stats

After a983b5ebee57 ("mm: memcontrol: fix excessive complexity in
memory.stat reporting"), we observed slowly upward creeping NR_WRITEBACK
counts over the course of several days, both the per-memcg stats as well
as the system counter in e.g.  /proc/meminfo.

The conversion from full per-cpu stat counts to per-cpu cached atomic stat
counts introduced an irq-unsafe RMW operation into the updates.

Most stat updates come from process context, but one notable exception is
the NR_WRITEBACK counter.  While writebacks are issued from process
context, they are retired from (soft)irq context.

When writeback completions interrupt the RMW counter updates of new
writebacks being issued, the decs from the completions are lost.

Since the global updates are routed through the joint lruvec API, both the
memcg counters as well as the system counters are affected.

This patch makes the joint stat and event API irq safe.

Link: http://lkml.kernel.org/r/20180203082353.17284-1-hannes@cmpxchg.org
Fixes: a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat reporting")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Debugged-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-fix-nr_writeback-leak-in-memcg-and-system-stats include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-fix-nr_writeback-leak-in-memcg-and-system-stats
+++ a/include/linux/memcontrol.h
@@ -523,9 +523,11 @@ static inline void __mod_memcg_state(str
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
 				   int idx, int val)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__mod_memcg_state(memcg, idx, val);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 /**
@@ -606,9 +608,11 @@ static inline void __mod_lruvec_state(st
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__mod_lruvec_state(lruvec, idx, val);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 static inline void __mod_lruvec_page_state(struct page *page,
@@ -630,9 +634,11 @@ static inline void __mod_lruvec_page_sta
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__mod_lruvec_page_state(page, idx, val);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -659,9 +665,11 @@ static inline void __count_memcg_events(
 static inline void count_memcg_events(struct mem_cgroup *memcg,
 				      int idx, unsigned long count)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__count_memcg_events(memcg, idx, count);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 /* idx can be of type enum memcg_event_item or vm_event_item */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-fix-nr_writeback-leak-in-memcg-and-system-stats.patch

