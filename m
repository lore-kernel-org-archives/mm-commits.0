Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A8913B284
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854795; cv=none; b=An/vLqU+WC2F4/uWaSC8J2UPIGSpGvmhpZ4+nlK1BzfYndVN9YjqF0/zAH+Cp5mmmaNvhoZYSlA9NuE3Gl1mqCC5y7mcFV4UWTL4zsDM5ZBKhjU4U+x81VePYBw6aauZzldQQ2TbaHIsObDfiJVIJMezB1KCKW0nfKu2i7bkAY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854795; c=relaxed/simple;
	bh=ETczYndBznlWPP+W1+nmjj7CwSmHkxiR1sNQ/qkQ8fU=;
	h=Date:To:From:Subject:Message-Id; b=jDKzUNnlPBfUqE/GJjHDcYYrvRMEAMZiXIwkp9tIPlZF2htbUGndsczg67CAUjWYVkicdV7E3dyUz0JYh2NpPBXiaNUIwmZwYFrpU1VgyA4yLWTAlyhqTobcECYFKOfkvTONVd+m5lNoWRNwnIGn13XdtyRsvgvdKx9BguvJP9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JBWNLBc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JBWNLBc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC21C4CECF;
	Wed,  6 Nov 2024 00:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854795;
	bh=ETczYndBznlWPP+W1+nmjj7CwSmHkxiR1sNQ/qkQ8fU=;
	h=Date:To:From:Subject:From;
	b=JBWNLBc+m1idI9Aeu99ayNFlOJlu73O3HgKOLu+yBz5hznXx2ZzaK6sb83nWAUB8d
	 IKb3Q9F8udxE7svNWwuZbb2JUlgGZo9ovUZkiXw6SkiVH7FaJL6eKYV0GKVKrr+4sO
	 PtdvbLrclkccNb8qKqsaI45a8zu60A8SUsNdd5Kg=
Date: Tue, 05 Nov 2024 16:59:54 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,songmuchun@bytedance.com,rostedt@goodmis.org,roman.gushchin@linux.dev,mhocko@suse.com,inwardvessel@gmail.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-add-tracing-for-memcg-stat-updates.patch removed from -mm tree
Message-Id: <20241106005955.0FC21C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: add tracing for memcg stat updates
has been removed from the -mm tree.  Its filename was
     memcg-add-tracing-for-memcg-stat-updates.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: add tracing for memcg stat updates
Date: Wed, 9 Oct 2024 17:35:50 -0700

The memcg stats are maintained in rstat infrastructure which provides very
fast updates side and reasonable read side.  However memcg added plethora
of stats and made the read side, which is cgroup rstat flush, very slow. 
To solve that, threshold was added in the memcg stats read side i.e.  no
need to flush the stats if updates are within the threshold.

This threshold based improvement worked for sometime but more stats were
added to memcg and also the read codepath was getting triggered in the
performance sensitive paths which made threshold based ratelimiting
ineffective.  We need more visibility into the hot and cold stats i.e. 
stats with a lot of updates.  Let's add trace to get that visibility.

[shakeel.butt@linux.dev: use unsigned long type for memcg_rstat_events, per Yosry]
  Link: https://lkml.kernel.org/r/20241015213721.3804209-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20241010003550.3695245-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: JP Kobryn <inwardvessel@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/memcg.h |   81 +++++++++++++++++++++++++++++++++
 mm/memcontrol.c              |   13 ++++-
 2 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/memcg.h a/include/trace/events/memcg.h
new file mode 100644
--- /dev/null
+++ a/include/trace/events/memcg.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM memcg
+
+#if !defined(_TRACE_MEMCG_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MEMCG_H
+
+#include <linux/memcontrol.h>
+#include <linux/tracepoint.h>
+
+
+DECLARE_EVENT_CLASS(memcg_rstat_stats,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+
+	TP_ARGS(memcg, item, val),
+
+	TP_STRUCT__entry(
+		__field(u64, id)
+		__field(int, item)
+		__field(int, val)
+	),
+
+	TP_fast_assign(
+		__entry->id = cgroup_id(memcg->css.cgroup);
+		__entry->item = item;
+		__entry->val = val;
+	),
+
+	TP_printk("memcg_id=%llu item=%d val=%d",
+		  __entry->id, __entry->item, __entry->val)
+);
+
+DEFINE_EVENT(memcg_rstat_stats, mod_memcg_state,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+
+	TP_ARGS(memcg, item, val)
+);
+
+DEFINE_EVENT(memcg_rstat_stats, mod_memcg_lruvec_state,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+
+	TP_ARGS(memcg, item, val)
+);
+
+DECLARE_EVENT_CLASS(memcg_rstat_events,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, unsigned long val),
+
+	TP_ARGS(memcg, item, val),
+
+	TP_STRUCT__entry(
+		__field(u64, id)
+		__field(int, item)
+		__field(unsigned long, val)
+	),
+
+	TP_fast_assign(
+		__entry->id = cgroup_id(memcg->css.cgroup);
+		__entry->item = item;
+		__entry->val = val;
+	),
+
+	TP_printk("memcg_id=%llu item=%d val=%lu",
+		  __entry->id, __entry->item, __entry->val)
+);
+
+DEFINE_EVENT(memcg_rstat_events, count_memcg_events,
+
+	TP_PROTO(struct mem_cgroup *memcg, int item, unsigned long val),
+
+	TP_ARGS(memcg, item, val)
+);
+
+
+#endif /* _TRACE_MEMCG_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/mm/memcontrol.c~memcg-add-tracing-for-memcg-stat-updates
+++ a/mm/memcontrol.c
@@ -71,6 +71,10 @@
 
 #include <linux/uaccess.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/memcg.h>
+#undef CREATE_TRACE_POINTS
+
 #include <trace/events/vmscan.h>
 
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
@@ -682,7 +686,9 @@ void __mod_memcg_state(struct mem_cgroup
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
-	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val);
+	trace_mod_memcg_state(memcg, idx, val);
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -741,7 +747,9 @@ static void __mod_memcg_lruvec_state(str
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
 
-	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val);
+	trace_mod_memcg_lruvec_state(memcg, idx, val);
 	memcg_stats_unlock();
 }
 
@@ -832,6 +840,7 @@ void __count_memcg_events(struct mem_cgr
 	memcg_stats_lock();
 	__this_cpu_add(memcg->vmstats_percpu->events[i], count);
 	memcg_rstat_updated(memcg, count);
+	trace_count_memcg_events(memcg, idx, count);
 	memcg_stats_unlock();
 }
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


