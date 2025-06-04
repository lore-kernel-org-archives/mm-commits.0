Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BA1111BF
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 19:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749067146; cv=none; b=CiljzdJ69l23VuT9SrVWwfA7vvxKGvUs7o5yCNv0peS9PeZhB1qfu/y158mFzcnireOuZCwJRbHd2azic8IW6ms8YbzBqeV/uY6n2P4bGwrHb9AuZkJ4dJEVTSymViMtzUe5Cl1kFM//3INdOkO3sAZkDJtFCe3GnHvKFheMUCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749067146; c=relaxed/simple;
	bh=Z59QkEsNE6dq9uDN1AVpUT6QUTdvPFUxIKT6jpT4tOQ=;
	h=Date:To:From:Subject:Message-Id; b=oOjan/8ly92V3PqlYl6O3O+aoQdMf2rH4XcpWbUDG9onX7TK/+Y2B/tEt0BH0OeGJJr88V6JxjKd3CV7PlfW9AyolW/YeYALhUgIuwMhVptSlM9OcRdQaaF4xCuOXrw19fyKTVoPXsLe16s+h5xRUPhWZLvuJdWNEs8RJKQjhbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eHHOsC6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eHHOsC6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4374BC4CEE4;
	Wed,  4 Jun 2025 19:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749067145;
	bh=Z59QkEsNE6dq9uDN1AVpUT6QUTdvPFUxIKT6jpT4tOQ=;
	h=Date:To:From:Subject:From;
	b=eHHOsC6a35Te7NkHvdslATMtp44BdZW+PR0cRp7tGmgXNGnjWt4luloMAAAFKa7wH
	 0JGy8aP7E0kttfshSmEaI71ddlq/+eqx19UxFStBpT1b4XqCu4M5pi+Rl4DNK22XNn
	 Q5pMbzWNa2PU5HiY5W5LQTx9QeakMXPik3MnrHGE=
Date: Wed, 04 Jun 2025 12:59:04 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch added to mm-new branch
Message-Id: <20250604195905.4374BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: calculate and expose idle time percentiles
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch

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
Subject: mm/damon/stat: calculate and expose idle time percentiles
Date: Wed, 4 Jun 2025 11:31:26 -0700

Knowing how much memory is how cold can be useful for understanding
coldness and utilization efficiency of memory.  The raw form of DAMON's
monitoring results has the information.  Convert the raw results into the
per-byte idle time distributions and expose it as percentiles metric to
users, as a read-only DAMON_STAT parameter.

In detail, the metrics are calculated as follows.  First, DAMON's
per-region access frequency and age information is converted into per-byte
idle time.  If access frequency of a region is higher than zero, every
byte of the region has zero idle time.  If the access frequency of a
region is zero, every byte of the region has idle time as the age of the
region.  Then the logic sorts the per-byte idle times and provides the
value at 0/100, 1/100, ..., 99/100 and 100/100 location of the sorted
array.

The metric can be easily aggregated and compared on large scale production
systems.  For example, if an average of 75-th percentile idle time of
machines that collected on similar time is two minutes, it means the
system's 25 percent memory is not accessed at all for two minutes or more
on average.  If a workload considers two minutes as unit work time, we can
conclude its working set size is only 75 percent of the memory.  If the
system utilizes proactive reclamation and it supports coldness-based
thresholds like DAMON_RECLAIM, the idle time percentiles can be used to
find a more safe or aggressive coldness threshold for aimed memory saving.

Link: https://lkml.kernel.org/r/20250604183127.13968-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

--- a/mm/damon/stat.c~mm-damon-stat-calculate-and-expose-idle-time-percentiles
+++ a/mm/damon/stat.c
@@ -33,6 +33,11 @@ module_param(estimated_memory_bandwidth,
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
+static unsigned long memory_idle_ms_percentiles[101] __read_mostly = {0,};
+module_param_array(memory_idle_ms_percentiles, ulong, NULL, 0400);
+MODULE_PARM_DESC(memory_idle_ms_percentiles,
+		"Memory idle time percentiles in milliseconds");
+
 static struct damon_ctx *damon_stat_context;
 
 static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
@@ -50,6 +55,72 @@ static void damon_stat_set_estimated_mem
 		MSEC_PER_SEC / c->attrs.aggr_interval;
 }
 
+static unsigned int damon_stat_idletime(const struct damon_region *r)
+{
+	if (r->nr_accesses)
+		return 0;
+	return r->age + 1;
+}
+
+static int damon_stat_cmp_regions(const void *a, const void *b)
+{
+	const struct damon_region *ra = *(const struct damon_region **)a;
+	const struct damon_region *rb = *(const struct damon_region **)b;
+
+	return damon_stat_idletime(ra) - damon_stat_idletime(rb);
+}
+
+static int damon_stat_sort_regions(struct damon_ctx *c,
+		struct damon_region ***sorted_ptr, int *nr_regions_ptr,
+		unsigned long *total_sz_ptr)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_region **region_pointers;
+	unsigned int nr_regions = 0;
+	unsigned long total_sz = 0;
+
+	damon_for_each_target(t, c) {
+		/* there is only one target */
+		region_pointers = kmalloc_array(damon_nr_regions(t),
+				sizeof(*region_pointers), GFP_KERNEL);
+		if (!region_pointers)
+			return -ENOMEM;
+		damon_for_each_region(r, t) {
+			region_pointers[nr_regions++] = r;
+			total_sz += r->ar.end - r->ar.start;
+		}
+	}
+	sort(region_pointers, nr_regions, sizeof(*region_pointers),
+			damon_stat_cmp_regions, NULL);
+	*sorted_ptr = region_pointers;
+	*nr_regions_ptr = nr_regions;
+	*total_sz_ptr = total_sz;
+	return 0;
+}
+
+static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
+{
+	struct damon_region **sorted_regions, *region;
+	int nr_regions;
+	unsigned long total_sz, accounted_bytes = 0;
+	int err, i, next_percentile = 0;
+
+	err = damon_stat_sort_regions(c, &sorted_regions, &nr_regions,
+			&total_sz);
+	if (err)
+		return;
+	for (i = 0; i < nr_regions; i++) {
+		region = sorted_regions[i];
+		accounted_bytes += region->ar.end - region->ar.start;
+		while (next_percentile <= accounted_bytes * 100 / total_sz)
+			memory_idle_ms_percentiles[next_percentile++] =
+				damon_stat_idletime(region) *
+				c->attrs.aggr_interval / USEC_PER_MSEC;
+	}
+	kfree(sorted_regions);
+}
+
 static int damon_stat_after_aggregation(struct damon_ctx *c)
 {
 	static unsigned long last_refresh_jiffies;
@@ -61,6 +132,7 @@ static int damon_stat_after_aggregation(
 	last_refresh_jiffies = jiffies;
 
 	damon_stat_set_estimated_memory_bandwidth(c);
+	damon_stat_set_idletime_percentiles(c);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch

