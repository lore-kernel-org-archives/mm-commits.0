Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D049715E5BB
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313710; cv=none; b=GjJrVtG3hreOra2eh2Y5gWNH6wsTGTl/BtVoAm3sJaJHMjnyJudqICU7PnK8CuPc85nlqpReaA4KgpQp5S4UNR9SI0WLXnqC54iDhgyQRZjFFQpO3humP5uG/zD3fjo1rjz0hhK2Txoj28JDuVdWLdZbjwV8XYOBVEGLoJUSY/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313710; c=relaxed/simple;
	bh=71jVyQ2avxA8bqQHRhtgLmZW7SxcT+MWIxALJTWZn8c=;
	h=Date:To:From:Subject:Message-Id; b=kQhjCiytCC7kdj9KuKmAY/CDcCzYA6aztBNTIuUmJawn1j5q7K9/r7n61GYHkd/RZwpziEVSI2FvkMQQqJWGjm+9NynuBNJKLEGxa1GFxwbV8gdgv8vn8Ii8B+cKQ2n4wqnLjucf6NW5P/jtt2lQ9wUQAnShXrFwH9mo52HtyAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rrT1qNvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rrT1qNvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6969C4CED4;
	Mon, 11 Nov 2024 08:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313710;
	bh=71jVyQ2avxA8bqQHRhtgLmZW7SxcT+MWIxALJTWZn8c=;
	h=Date:To:From:Subject:From;
	b=rrT1qNvmjCITw8TAgwi0rZ0XDq/rqkPNcPwLhD+kyb2jvh1JJg6vnr5hVTCnslxJF
	 9lYKext6KAGyOoY7xstkquPhdRW+/vixqp1+0g9O070qCmYSsVB5Rg2//Atnr2BtYB
	 CuCcifFMFFCYx9e9hfX1HfAbmzyvaxSznL/digTQ=
Date: Mon, 11 Nov 2024 00:28:30 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,hannes@cmpxchg.org,inwardvessel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-add-flush-tracepoint.patch removed from -mm tree
Message-Id: <20241111082830.A6969C4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: add flush tracepoint
has been removed from the -mm tree.  Its filename was
     memcg-add-flush-tracepoint.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: JP Kobryn <inwardvessel@gmail.com>
Subject: memcg: add flush tracepoint
Date: Mon, 28 Oct 2024 19:11:06 -0700

This tracepoint gives visibility on how often the flushing of memcg stats
occurs and contains info on whether it was forced, skipped, and the value
of stats updated.  It can help with understanding how readers are affected
by having to perform the flush, and the effectiveness of the flush by
inspecting the number of stats updated.  Paired with the recently added
tracepoints for tracing rstat updates, it can also help show correlation
where stats exceed thresholds frequently.

Link: https://lkml.kernel.org/r/20241029021106.25587-3-inwardvessel@gmail.com
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/memcg.h |   25 +++++++++++++++++++++++++
 mm/memcontrol.c              |    7 ++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

--- a/include/trace/events/memcg.h~memcg-add-flush-tracepoint
+++ a/include/trace/events/memcg.h
@@ -74,6 +74,31 @@ DEFINE_EVENT(memcg_rstat_events, count_m
 	TP_ARGS(memcg, item, val)
 );
 
+TRACE_EVENT(memcg_flush_stats,
+
+	TP_PROTO(struct mem_cgroup *memcg, s64 stats_updates,
+		bool force, bool needs_flush),
+
+	TP_ARGS(memcg, stats_updates, force, needs_flush),
+
+	TP_STRUCT__entry(
+		__field(u64, id)
+		__field(s64, stats_updates)
+		__field(bool, force)
+		__field(bool, needs_flush)
+	),
+
+	TP_fast_assign(
+		__entry->id = cgroup_id(memcg->css.cgroup);
+		__entry->stats_updates = stats_updates;
+		__entry->force = force;
+		__entry->needs_flush = needs_flush;
+	),
+
+	TP_printk("memcg_id=%llu stats_updates=%lld force=%d needs_flush=%d",
+		__entry->id, __entry->stats_updates,
+		__entry->force, __entry->needs_flush)
+);
 
 #endif /* _TRACE_MEMCG_H */
 
--- a/mm/memcontrol.c~memcg-add-flush-tracepoint
+++ a/mm/memcontrol.c
@@ -597,7 +597,12 @@ static inline void memcg_rstat_updated(s
 
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 {
-	if (!force && !memcg_vmstats_needs_flush(memcg->vmstats))
+	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
+
+	trace_memcg_flush_stats(memcg, atomic64_read(&memcg->vmstats->stats_updates),
+		force, needs_flush);
+
+	if (!force && !needs_flush)
 		return;
 
 	if (mem_cgroup_is_root(memcg))
_

Patches currently in -mm which might be from inwardvessel@gmail.com are


