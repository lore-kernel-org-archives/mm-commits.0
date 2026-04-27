Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35EA3845CF
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 16:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777307173; cv=none; b=cyy55eucV/X7K+ugiEsouTKSYHLX5Mn2Po+au+yLrlho9XcoYGA6W7Q9YDQHf78H+e101MBKCqyPK5T7Len4g0WsyZ62EJZuKTAKdP6CG6RJDOjmOphSPxC6diILQP9aU7jugRuAVcuW+SnYnOUfZGMV9keWOTPs2hR0wuT9mqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777307173; c=relaxed/simple;
	bh=EKWpNQ85HZ8WSynIRdjvLjRuiDDR4ZSExR/2J4YMf3M=;
	h=Date:To:From:Subject:Message-Id; b=oZmcfx4bxEFoZBNhjpIbdQ9SR//RlQy1M95394Os5vpAdsQEdaDRxXh9N4DGLKTXIm1E+38VsCw6QcvKWQ7vOuNfS/muRctVbgHsNFjhBivlA77YISgZQS2LllmSLkfr1gPaRGZ0CZa+I/yQZDpQSQwF7CwmP7NL6oQ/keVN3As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I0bSEnpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I0bSEnpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D51C19425;
	Mon, 27 Apr 2026 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777307171;
	bh=EKWpNQ85HZ8WSynIRdjvLjRuiDDR4ZSExR/2J4YMf3M=;
	h=Date:To:From:Subject:From;
	b=I0bSEnpEvEpN3CgwCsLry24alf8kP0gjrFjdCkfR5XR7krq6VjkE003rCelRYtGDE
	 n6DozCdUGmjtqthcr0J3YcL6VmX9U5aJPNdpVv0kQZ7kTu/xGdda5Pu1r+p0928uHb
	 B7obIWbSwdCRCi+2XIsV72uK+WOCYU9w9bvFGQKs=
Date: Mon, 27 Apr 2026 09:26:11 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kas@kernel.org,hannes@cmpxchg.org,d@ilvokhin.com,david@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch removed from -mm tree
Message-Id: <20260427162611.C3D51C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: spread vmstat_update requeue across the stat interval
has been removed from the -mm tree.  Its filename was
     mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/vmstat: spread vmstat_update requeue across the stat interval
Date: Wed, 01 Apr 2026 06:57:50 -0700

vmstat_update uses round_jiffies_relative() when re-queuing itself, which
aligns all CPUs' timers to the same second boundary.  When many CPUs have
pending PCP pages to drain, they all call decay_pcp_high() ->
free_pcppages_bulk() simultaneously, serializing on zone->lock and hitting
contention.

Introduce vmstat_spread_delay() which distributes each CPU's vmstat_update
evenly across the stat interval instead of aligning them.

This does not increase the number of timer interrupts — each CPU still
fires once per interval.  The timers are simply staggered rather than
aligned.  Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
wake idle CPUs regardless of scheduling; the spread only affects CPUs that
are already active

`perf lock contention` shows 7.5x reduction in zone->lock contention (872
-> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64 system
under memory pressure.

Tested on a 72-CPU aarch64 system using stress-ng --vm to generate memory
allocation bursts.  Lock contention was measured with:

  perf lock contention -a -b -S free_pcppages_bulk

Results with KASAN enabled:

 free_pcppages_bulk contention (KASAN):
  +--------------+----------+----------+
  | Metric       | No fix   | With fix |
  +--------------+----------+----------+
  | Contentions  |      872 |      117 |
  | Total wait   | 199.43ms | 80.76ms  |
  | Max wait     |  35.76ms | 4.19ms   |
  +--------------+----------+----------+

Results without KASAN:

  free_pcppages_bulk contention (no KASAN):
  +--------------+----------+----------+
  | Metric       | No fix   | With fix |
  +--------------+----------+----------+
  | Contentions  |      240 |      133 |
  | Total wait   |  34.01ms | 24.61ms  |
  | Max wait     |   1.35ms |   965us  |
  +--------------+----------+----------+

Link: https://lore.kernel.org/20260401-vmstat-v1-1-b68ce4a35055@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval
+++ a/mm/vmstat.c
@@ -2034,6 +2034,29 @@ static int vmstat_refresh(const struct c
 }
 #endif /* CONFIG_PROC_FS */
 
+/*
+ * Return a per-cpu delay that spreads vmstat_update work across the stat
+ * interval.  Without this, round_jiffies_relative() aligns every CPU's
+ * timer to the same second boundary, causing a thundering-herd on
+ * zone->lock when multiple CPUs drain PCP pages simultaneously via
+ * decay_pcp_high() -> free_pcppages_bulk().
+ */
+static unsigned long vmstat_spread_delay(void)
+{
+	unsigned long interval = sysctl_stat_interval;
+	unsigned int nr_cpus = num_online_cpus();
+
+	if (nr_cpus <= 1)
+		return round_jiffies_relative(interval);
+
+	/*
+	 * Spread per-cpu vmstat work evenly across the interval.  Don't
+	 * use round_jiffies_relative() here -- it would snap every CPU
+	 * back to the same second boundary, defeating the spread.
+	 */
+	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
+}
+
 static void vmstat_update(struct work_struct *w)
 {
 	if (refresh_cpu_vm_stats(true)) {
@@ -2044,7 +2067,7 @@ static void vmstat_update(struct work_st
 		 */
 		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
 				this_cpu_ptr(&vmstat_work),
-				round_jiffies_relative(sysctl_stat_interval));
+				vmstat_spread_delay());
 	}
 }
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch
mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch

