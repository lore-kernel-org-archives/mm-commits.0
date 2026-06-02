Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F62C3BE165
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439107; cv=none; b=qlXGhZOHDUcfc61NZEC19B1GcsNcIe3WvJwl7Om60hjo2kr6vUMWzgNjpsEh1es4Lf8DcvQEOXgCfARgcfB8q+VmeZCQ1FoOexEPGaEM+pABmjDUaW9WG9NiyQQl8G4Y3MRqsQRyOGOf1OSXY3rtyfZg3c6fBSiETzLmKKChlIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439107; c=relaxed/simple;
	bh=GSD4datU19LepOJ2lHE5S9VbMIqHQol6eMb2U97KwuU=;
	h=Date:To:From:Subject:Message-Id; b=NwIKpiqQrUYhQ+C0DSkhw4MW4H7FYTYwCp+7H4yRV9Lj5jmCYqpig5oshJiAViFYhxjSwic8jZuabim625SjQpl2GAkna//SOoqIqrDcuqQYp049QHfhehg9IDbiaWQpReFNFZ5A2IkDOQ5AI64PwUanO2LlTFpPXoardX5YUGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KhlmKA2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KhlmKA2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E803D1F00898;
	Tue,  2 Jun 2026 22:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439106;
	bh=BZA2dXv86FTMLY05UX79fv/bYmCms6fITjA4kRt8q80=;
	h=Date:To:From:Subject;
	b=KhlmKA2Sr3AXak6TdWyvs6ccTOeH8RbkXt34YIYnzUy6cfGu4RjfwmYKKuiksRLX7
	 ea/+wYdU366wJOnI6N+iRmZAR+FAXb77dCjIiUHVdl3PHzEabQJ+Q7r8hDk00UX3uQ
	 b0HfHTPAuhTpFbpH5l0DxGEOv4NUEX+JFvbqLK0s=
Date: Tue, 02 Jun 2026 15:25:05 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-trace-probe_hits.patch removed from -mm tree
Message-Id: <20260602222505.E803D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: trace probe_hits
has been removed from the -mm tree.  Its filename was
     mm-damon-trace-probe_hits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: trace probe_hits
Date: Mon, 18 May 2026 16:41:06 -0700

Introduce a new tracepoint for exposing the per-region per-probe positive
sample count via tracefs.

Link: https://lore.kernel.org/20260518234119.97569-19-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |   38 +++++++++++++++++++++++++++++++++
 mm/damon/core.c              |    9 +++++++
 2 files changed, 47 insertions(+)

--- a/include/trace/events/damon.h~mm-damon-trace-probe_hits
+++ a/include/trace/events/damon.h
@@ -130,6 +130,44 @@ TRACE_EVENT(damon_monitor_intervals_tune
 	TP_printk("sample_us=%lu", __entry->sample_us)
 );
 
+TRACE_EVENT_CONDITION(damon_region_aggregated,
+
+	TP_PROTO(unsigned int target_id, struct damon_region *r,
+		unsigned int nr_regions, unsigned int nr_probes),
+
+	TP_ARGS(target_id, r, nr_regions, nr_probes),
+
+	TP_CONDITION(nr_probes > 0),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, target_id)
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned int, nr_regions)
+		__field(unsigned int, nr_accesses)
+		__field(unsigned int, age)
+		__dynamic_array(unsigned char, probe_hits, nr_probes)
+	),
+
+	TP_fast_assign(
+		__entry->target_id = target_id;
+		__entry->start = r->ar.start;
+		__entry->end = r->ar.end;
+		__entry->nr_regions = nr_regions;
+		__entry->nr_accesses = r->nr_accesses;
+		__entry->age = r->age;
+		memcpy(__get_dynamic_array(probe_hits), r->probe_hits,
+			sizeof(*r->probe_hits) * nr_probes);
+	),
+
+	TP_printk("target_id=%lu nr_regions=%u %lu-%lu: %u %u probe_hits=%s",
+			__entry->target_id, __entry->nr_regions,
+			__entry->start, __entry->end,
+			__entry->nr_accesses, __entry->age,
+			__print_hex(__get_dynamic_array(probe_hits),
+				__get_dynamic_array_len(probe_hits)))
+);
+
 TRACE_EVENT(damon_aggregated,
 
 	TP_PROTO(unsigned int target_id, struct damon_region *r,
--- a/mm/damon/core.c~mm-damon-trace-probe_hits
+++ a/mm/damon/core.c
@@ -1905,6 +1905,13 @@ static void kdamond_reset_aggregated(str
 {
 	struct damon_target *t;
 	unsigned int ti = 0;	/* target's index */
+	unsigned int nr_probes = 0;
+	struct damon_probe *probe;
+
+	if (trace_damon_region_aggregated_enabled()) {
+		damon_for_each_probe(probe, c)
+			nr_probes++;
+	}
 
 	damon_for_each_target(t, c) {
 		struct damon_region *r;
@@ -1913,6 +1920,8 @@ static void kdamond_reset_aggregated(str
 			int i;
 
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
+			trace_damon_region_aggregated(ti, r,
+					damon_nr_regions(t), nr_probes);
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

