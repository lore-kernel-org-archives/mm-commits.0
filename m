From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:24 -0700
Message-ID: <56f04018.Tx66lv74nSewNlg6%akpm__456.614528275345$1458590238$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbcCUT42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage

Setting the original memory.limit_in_bytes hardlimit is subject to a race
condition when the desired value is below the current usage.  The code
tries a few times to first reclaim and then see if the usage has dropped
to where we would like it to be, but there is no locking, and the workload
is free to continue making new charges up to the old limit.  Thus,
attempting to shrink a workload relies on pure luck and hope that the
workload happens to cooperate.

To fix this in the cgroup2 memory.max knob, do it the other way round: set
the limit first, then try enforcement.  And if reclaim is not able to
succeed, trigger OOM kills in the group.  Keep going until the new limit
is met, we run out of OOM victims and there's only unreclaimable memory
left, or the task writing to memory.max is killed.  This allows users to
shrink groups reliably, and the behavior is consistent with what happens
when new charges are attempted in excess of memory.max.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |    6 +++++
 mm/memcontrol.c             |   38 ++++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 4 deletions(-)

diff -puN Documentation/cgroup-v2.txt~mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage
+++ a/Documentation/cgroup-v2.txt
@@ -1387,6 +1387,12 @@ system than killing the group.  Otherwis
 limit this type of spillover and ultimately contain buggy or even
 malicious applications.
 
+Setting the original memory.limit_in_bytes below the current usage was
+subject to a race condition, where concurrent charges could cause the
+limit setting to fail. memory.max on the other hand will first set the
+limit to prevent new charges, and then reclaim and OOM kill until the
+new limit is met - or the task writing to memory.max is killed.
+
 The combined memory+swap accounting and limiting is replaced by real
 control over swap space.
 
diff -puN mm/memcontrol.c~mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage
+++ a/mm/memcontrol.c
@@ -1236,7 +1236,7 @@ static unsigned long mem_cgroup_get_limi
 	return limit;
 }
 
-static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				     int order)
 {
 	struct oom_control oc = {
@@ -1314,6 +1314,7 @@ static void mem_cgroup_out_of_memory(str
 	}
 unlock:
 	mutex_unlock(&oom_lock);
+	return chosen;
 }
 
 #if MAX_NUMNODES > 1
@@ -5029,6 +5030,8 @@ static ssize_t memory_max_write(struct k
 				char *buf, size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned int nr_reclaims = MEM_CGROUP_RECLAIM_RETRIES;
+	bool drained = false;
 	unsigned long max;
 	int err;
 
@@ -5037,9 +5040,36 @@ static ssize_t memory_max_write(struct k
 	if (err)
 		return err;
 
-	err = mem_cgroup_resize_limit(memcg, max);
-	if (err)
-		return err;
+	xchg(&memcg->memory.limit, max);
+
+	for (;;) {
+		unsigned long nr_pages = page_counter_read(&memcg->memory);
+
+		if (nr_pages <= max)
+			break;
+
+		if (signal_pending(current)) {
+			err = -EINTR;
+			break;
+		}
+
+		if (!drained) {
+			drain_all_stock(memcg);
+			drained = true;
+			continue;
+		}
+
+		if (nr_reclaims) {
+			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
+							  GFP_KERNEL, true))
+				nr_reclaims--;
+			continue;
+		}
+
+		mem_cgroup_events(memcg, MEMCG_OOM, 1);
+		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
+			break;
+	}
 
 	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


