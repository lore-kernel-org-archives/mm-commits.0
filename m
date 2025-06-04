Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A298111BF
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 19:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749067144; cv=none; b=l5CZQ9jXd6MNOpY+o0T6gWthum8Bb/eWSe8rXO8cv6dhhW6iHEUWduChwRIWDMbix4xhHEKzZEzS/no+1+JWZKPbiUyuJzCJQJg+FxCV0+8iJQ/RRKla2vaaHPxRad7BlaYwJy4X+KIYjfVNmCEeLhgAc27AgieAbRFQQcPXmmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749067144; c=relaxed/simple;
	bh=j9UTIlMZ2r2RmJXNAlTiZ3LUXqeG3QqqY5Vfo9aaHVs=;
	h=Date:To:From:Subject:Message-Id; b=NGon7QA8jUByJa5RSf434X4J5Wg3GcxxdZuVDBHROn331vH3/xcQ1XvHxGiF/Ki6wDodN81qXmSuKBzn5D4Rss1OIGCLHFVWTSvKk15x1KQkpcNUCEzuXkrZeOoQerj5LdoilOWZA6K1pnzaSaTNq4OSfemmee6z7A/5RMZ2I3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ra4YnVS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ra4YnVS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0694C4CEE4;
	Wed,  4 Jun 2025 19:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749067144;
	bh=j9UTIlMZ2r2RmJXNAlTiZ3LUXqeG3QqqY5Vfo9aaHVs=;
	h=Date:To:From:Subject:From;
	b=Ra4YnVS1qy6FifeRkEKjuZSCU1mHrNOYk06vGrF/GqMO+4/CX+UIiBix88epF0yv0
	 KVIEaEVlU7w4Ylc0/+UqyThaB+GsFLcC7FHT65k2gVLL/VjoTkkHsu0+x2dYN1o3Zu
	 7gQ1j2Zvuywx6f7arr4V/xzVM+fazP485Yw78zho=
Date: Wed, 04 Jun 2025 12:59:03 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch added to mm-new branch
Message-Id: <20250604195903.F0694C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: calculate and expose estimated memory bandwidth
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: calculate and expose estimated memory bandwidth
Date: Wed, 4 Jun 2025 11:31:25 -0700

The raw form of DAMON's monitoring results captures many details of the
information.  However, not every bit of the information is always required
for understanding practical access patterns.  Especially on real world
production systems of high scale time and size, the raw form is difficult
to be aggregated and compared.

Convert the raw monitoring results into a single number metric, namely
estimated memory bandwidth and expose it to users as a read-only
DAMON_STAT parameter.  The metric represents access intensiveness
(hotness) of the system.  It can easily be aggregated and compared for
high level understanding of the access pattern on large systems.

Link: https://lkml.kernel.org/r/20250604183127.13968-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/mm/damon/stat.c~mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth
+++ a/mm/damon/stat.c
@@ -28,8 +28,42 @@ static bool enabled __read_mostly = CONF
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
+static unsigned long estimated_memory_bandwidth __read_mostly;
+module_param(estimated_memory_bandwidth, ulong, 0400);
+MODULE_PARM_DESC(estimated_memory_bandwidth,
+		"Estimated memory bandwidth usage in bytes per second");
+
 static struct damon_ctx *damon_stat_context;
 
+static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long access_bytes = 0;
+
+	damon_for_each_target(t, c) {
+		damon_for_each_region(r, t)
+			access_bytes += (r->ar.end - r->ar.start) *
+				r->nr_accesses;
+	}
+	estimated_memory_bandwidth = access_bytes * USEC_PER_MSEC *
+		MSEC_PER_SEC / c->attrs.aggr_interval;
+}
+
+static int damon_stat_after_aggregation(struct damon_ctx *c)
+{
+	static unsigned long last_refresh_jiffies;
+
+	/* avoid unnecessarily frequent stat update */
+	if (time_before_eq(jiffies, last_refresh_jiffies +
+				msecs_to_jiffies(5 * MSEC_PER_SEC)))
+		return 0;
+	last_refresh_jiffies = jiffies;
+
+	damon_stat_set_estimated_memory_bandwidth(c);
+	return 0;
+}
+
 static struct damon_ctx *damon_stat_build_ctx(void)
 {
 	struct damon_ctx *ctx;
@@ -75,6 +109,7 @@ static struct damon_ctx *damon_stat_buil
 	damon_add_target(ctx, target);
 	if (damon_set_region_biggest_system_ram_default(target, &start, &end))
 		goto free_out;
+	ctx->callback.after_aggregation = damon_stat_after_aggregation;
 	return ctx;
 free_out:
 	damon_destroy_ctx(ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch

