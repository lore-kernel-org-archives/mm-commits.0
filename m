Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D861993B4
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 04:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730176019; cv=none; b=e+9Nt7ntXRacbWs4rMvT88DQoYDhdtjMTfxvpTkTrK+yS2ItXZY1nKo8xWnm/TNhRStDk2jA6yPphzmvfgjjtE0SOFzSxj7GCiuEe+/ksqqtA1WZ/siIn4BR3DYiM30xqg0GdHvzunFVzrbigr+umtZMd6H5pKwvjoR/dNfGTtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730176019; c=relaxed/simple;
	bh=ntFzLjnH8YdDuxSRGpEAkd6R8VUfjJZdopSThjIKLvU=;
	h=Date:To:From:Subject:Message-Id; b=ozzu245ZqAJp4XcBsO751LuE2SJ8xv/xAwCfHuMGpHD0DkCMHot/GcNwDBZVAif1SQHcuJsKDm1NiApigzbE2pL07HtWfm+9A3StERWyyLmmaUgmC0yIeZR9uxIqJxkSx/oOVg3netrybl+4dpKY0e6kSgkV5WRTm2/MFP6jgao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gsKa6gmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gsKa6gmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8E9C4CECD;
	Tue, 29 Oct 2024 04:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730176019;
	bh=ntFzLjnH8YdDuxSRGpEAkd6R8VUfjJZdopSThjIKLvU=;
	h=Date:To:From:Subject:From;
	b=gsKa6gmK7vK1bqRfFEhbu9zgG2Jk2WmLfQuACd9mfObbLPlOHQWA2pLDWxvG0MFwr
	 L5W1qDirnRsos8tnZbeyeaSoC7csVoFOsDB7c4uf9EgnPxb2TTxQVKU7g4vdKWogpl
	 F08DRfX5oupo7LqfqAoUdBAVOZom7KsEEjxMu0Rk=
Date: Mon, 28 Oct 2024 21:26:58 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,hannes@cmpxchg.org,inwardvessel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-add-flush-tracepoint.patch added to mm-unstable branch
Message-Id: <20241029042659.3F8E9C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: add flush tracepoint
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-add-flush-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-add-flush-tracepoint.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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
@@ -596,7 +596,12 @@ static inline void memcg_rstat_updated(s
 
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

memcg-rename-do_flush_stats-and-add-force-flag.patch
memcg-add-flush-tracepoint.patch

