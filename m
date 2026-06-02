Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E853C3434
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439093; cv=none; b=RG586S2zTneeBbwS0IUWjE9rjOQNfTrMFGZlh76/1b+Cv/cH1y3CPYLgEZXH+aVXT7ERFm7/AgXQSzS8E6xAssIFhyV4IliOSmhQXxOD4W+oEBkZm8KWYdh65oEpXBRPdeBfTpOJTRP8jsTSJB5GLbzYqq+a+JWlmRJB5H66d7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439093; c=relaxed/simple;
	bh=jkUD1oYIxbVTIiJymCJPkTY2t7C+Gd+gNnjWtzxatus=;
	h=Date:To:From:Subject:Message-Id; b=BfTo6YGxFXd6LZ5+/6ZurZHNpQSePJKvYE49UAOXfQMI2RJq6KuXkSwXnXK/+f4F4eYNHOUEQQqjSbkpoosPCgtmg5IiGauFREFT4HpVe/Do1orxp48MZrjKW5vaNcw/sn7YDQ3UJFUQC+xUDMcwKjDIytPbmaELtYbXEPvNDf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R6YFwkzP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R6YFwkzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCE61F0089C;
	Tue,  2 Jun 2026 22:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439091;
	bh=06nG9G7ZC/IsRoBm2SdNotE9vXNEtGicShAzu9b6ZN0=;
	h=Date:To:From:Subject;
	b=R6YFwkzPHCwcfj0ToAwTUu+jspu2RjtL5/yrWR1TfCDv0D3QSjl9T+xK6Ni36yp8d
	 e8QGGyBF0oMcqSSYFNayK+yFVe0wOX6fqWS4RWJZYNlExMWEMClPvWeef+K92M172n
	 ACXcaV2lpNIvn1Lssa7OdAES+eC47VYSI9v7YGh8=
Date: Tue, 02 Jun 2026 15:24:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-do-data-attributes-monitoring.patch removed from -mm tree
Message-Id: <20260602222451.BDCE61F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: do data attributes monitoring
has been removed from the -mm tree.  Its filename was
     mm-damon-core-do-data-attributes-monitoring.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: do data attributes monitoring
Date: Mon, 18 May 2026 16:40:55 -0700

Implement the data attributes monitoring execution.  Update kdamond to
invoke the probes application callback, and reset the aggregated number of
per-region per-probe positive samples for every aggregation interval.

Link: https://lore.kernel.org/20260518234119.97569-8-sj@kernel.org
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

 mm/damon/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-do-data-attributes-monitoring
+++ a/mm/damon/core.c
@@ -1910,10 +1910,14 @@ static void kdamond_reset_aggregated(str
 		struct damon_region *r;
 
 		damon_for_each_region(r, t) {
+			int i;
+
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			for (i = 0; i < DAMON_MAX_PROBES; i++)
+				r->probe_hits[i] = 0;
 			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
@@ -3407,6 +3411,8 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
+		if (ctx->ops.apply_probes)
+			ctx->ops.apply_probes(ctx);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

