From: akpm@linux-foundation.org
Subject: [merged] memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:23 -0700
Message-ID: <201103250724.p2P7OHst025848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933712Ab1CYHYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: res_counter_read_u64(): fix potential races on 32-bit machines
has been removed from the -mm tree.  Its filename was
     memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: res_counter_read_u64(): fix potential races on 32-bit machines
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

res_counter_read_u64 reads u64 value without lock.  It's dangerous in a
32bit environment.  Add locking.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/res_counter.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN kernel/res_counter.c~memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines
+++ a/kernel/res_counter.c
@@ -126,10 +126,24 @@ ssize_t res_counter_read(struct res_coun
 			pos, buf, s - buf);
 }
 
+#if BITS_PER_LONG == 32
+u64 res_counter_read_u64(struct res_counter *counter, int member)
+{
+	unsigned long flags;
+	u64 ret;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	ret = *res_counter_member(counter, member);
+	spin_unlock_irqrestore(&counter->lock, flags);
+
+	return ret;
+}
+#else
 u64 res_counter_read_u64(struct res_counter *counter, int member)
 {
 	return *res_counter_member(counter, member);
 }
+#endif
 
 int res_counter_memparse_write_strategy(const char *buf,
 					unsigned long long *res)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

