Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2FB2905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126210; cv=none; b=GaF7z/k3sr/oXqSRgEdClK4qqTeSos6oltQK8vn3zJRUTT0LOp8VEgPznBmSoFBhP/ADPWJ9lxGE/7Z4WLpbQep7wvhs378aKXp0a2KMrYP4w4uSHN/j60sxJqziPV8GjCrSpF1sUHFyhxV4QQleBIN0qkQLgeaFCCdRQAjcOPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126210; c=relaxed/simple;
	bh=wrhy3eIBMszHkpXgnm9nxU5x5QoSGcjUdEObT0ptF2Y=;
	h=Date:To:From:Subject:Message-Id; b=JIOPP06NWOSWoLzQIt6UK4aMCmf+LAp5TEtlNHjRpqIfZBJJuGdnEw7jJFNwrpWqnsQe8QzKkvFpY8aAra41yB7NHhVYsJEzJTvWikWq6/Ma2ZkmL44++S1aV7xWbDl1mn9xHjptmKTgJ6LGk0SK4peljaVEDPuAn19s90jVOT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GvNCfe3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GvNCfe3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8770C4CEE3;
	Thu, 10 Jul 2025 05:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126210;
	bh=wrhy3eIBMszHkpXgnm9nxU5x5QoSGcjUdEObT0ptF2Y=;
	h=Date:To:From:Subject:From;
	b=GvNCfe3U8R6tjwXV9UD9tPpfXwK3LciBsPWqAkYP1Rk587GTzjY9bPanx+gHUAWA9
	 EBTv8UTdEaKLXa3CVqjNM7BVW6+k+1aM3ba6HH6Tv1AOjkjO+9/+YXmZrLFlC9QblQ
	 x4yLNpXhYIZKiJT+dLVhpr54hTSAezb+NA6dHgQ0=
Date: Wed, 09 Jul 2025 22:43:29 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch removed from -mm tree
Message-Id: <20250710054329.E8770C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: calculate and expose idle time percentiles
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -34,6 +34,11 @@ module_param(estimated_memory_bandwidth,
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
+static unsigned long memory_idle_ms_percentiles[101] __read_mostly = {0,};
+module_param_array(memory_idle_ms_percentiles, ulong, NULL, 0400);
+MODULE_PARM_DESC(memory_idle_ms_percentiles,
+		"Memory idle time percentiles in milliseconds");
+
 static struct damon_ctx *damon_stat_context;
 
 static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
@@ -51,6 +56,72 @@ static void damon_stat_set_estimated_mem
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
@@ -62,6 +133,7 @@ static int damon_stat_after_aggregation(
 	last_refresh_jiffies = jiffies;
 
 	damon_stat_set_estimated_memory_bandwidth(c);
+	damon_stat_set_idletime_percentiles(c);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch

