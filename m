Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E60370AE1
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027675; cv=none; b=Ryq4G7dHLB8oQXvwOVh5OaR5g4UWDLMQ4btutp8IYFdzRQ1rgk1wgj586hajjNqRBr8S3ZqDEhUrpzvHlx7ukSYQitbNScYVfDPRRPe//gI/BljZt3pfUMpdqZdy5+LXzie7XXeIsjA8fogfdexRli/IkVHeCRUvWbtNH9EMtCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027675; c=relaxed/simple;
	bh=4IHiGWNEWelfX03Hka8kZccF586iVj4qw0Tl7xYe9yU=;
	h=Date:To:From:Subject:Message-Id; b=gdn+/gugt/zy+R9sD4MJYGNO+26Y0fueMccMmqJSqfb7GY2pcxlTEofQYYZVqcV01E5zDCVzspPMd9knCf973EgUKTfmrp7A5FLmnXGLk9PXrCdppoAhja/L4wgS9vvMMcnCik7RGeLpEPgHv+NLYNIo/NAmCSnYloNdTJNAqUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o0raXYxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o0raXYxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD8C1F00898;
	Fri, 29 May 2026 04:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027674;
	bh=zeQfHitKNaw8F4tOmzbZFSJ3nSxWd2qFGij1NAl0q6E=;
	h=Date:To:From:Subject;
	b=o0raXYxY7ZIsNQlkn3pKlr9KE8uTlR1xAUFNJf/JMcuWaPFcpGmwI8AUZBy51PL/K
	 p64jNVzXKhSU7aLgCxI/680b0UrJVq6MFGvnAFuCs/NUg2Dfzu5g8W6g3ar3sVxKPr
	 ZdZ0xcIy+S3MA8B+eTlUMI3IuvfEqBucRmvp5zhQ=
Date: Thu, 28 May 2026 21:07:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-introduce-damon_set_region_system_rams_default.patch removed from -mm tree
Message-Id: <20260529040754.5BD8C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: introduce damon_set_region_system_rams_default()
has been removed from the -mm tree.  Its filename was
     mm-damon-introduce-damon_set_region_system_rams_default.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: introduce damon_set_region_system_rams_default()
Date: Tue, 28 Apr 2026 21:12:23 -0700

Patch series "mm/damon/reclaim,lru_sort: monitor all system rams by
default".

DAMON_RECLAIM and DAMON_LRU_SORT set the biggest 'System RAM' resource of
the system as the default monitoring target address range.  The main
intention behind the design is to minimize the overhead coming from
monitoring of non-System RAM areas.

This could result in an odd setup when there are multiple discrete System
RAMs of considerable sizes.  For example, there are System RAMs each
having 500 GiB size.  In this case, only the first 500 GiB will be set as
the monitoring region by default.  This is particularly common on NUMA
systems.  Hence the modules allow users to set the monitoring target
address range using the module parameters if the default setup doesn't
work for them.  In other words, the current design trades ease of setup
for lower overhead.

However, because DAMON utilizes the sampling based access check and the
adaptive regions adjustment mechanisms, the overhead from the monitoring
of non-System RAM areas should be negligible in most setups.  Meanwhile,
the setup complexity is causing real headaches for users who need to run
those modules on various types of systems.  That is, the current tradeoff
is not a good deal.

Set the physical address range that can cover all System RAM areas of the
system as the default monitoring regions for DAMON_RECLAIM and
DAMON_LRU_SORT.

Technically speaking, this is changing documented behavior.  However, it
makes no sense to believe there is a real use case that really depends on
the old weird default behavior.  If the old default behavior was working
for them in the reasonable way, this change will only add a negligible
amount of monitoring overhead.  If it didn't work, the users may already
be using manual monitoring regions setup, and they will not be affected by
this change.

Patches Sequence
================

Patch 1 introduces a new core function that will be used for the new
default monitoring target region setup.  Patch 2 and 3 update
DAMON_RECLAIM and DAMON_LRU_SORT to use the new function instead of the
old one, respectively.  Patch 4 removes the old core function that was
replaced by the new one, as there is no more user of it.  Patch 5 updates
DAMON_STAT to use the new one instead of its in-house nearly-duplicate
self implementation of the functionality.  Finally patches 6 and 7 update
the DAMON_RECLAIM and DAMON_LRU_SORT user documentation for the new
behaviors, respectively.


This patch (of 7):

damon_set_region_biggest_system_ram_default() sets the monitoring target
region as the caller requested.  If the caller didn't specify the region,
it finds the biggest System RAM of the system and sets it as the target
region.  When there are more than one considerable size of System RAM
resources in the system, the default target setup makes no sense. 
Introduce a variant, namely damon_set_region_system_rams_default().  It
sets a physical address range that covers all System RAM resources as the
default target region.

Link: https://lore.kernel.org/20260429041232.90257-1-sj@kernel.org
Link: https://lore.kernel.org/20260429041232.90257-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 ++
 mm/damon/core.c       |   77 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-introduce-damon_set_region_system_rams_default
+++ a/include/linux/damon.h
@@ -1010,6 +1010,11 @@ int damon_kdamond_pid(struct damon_ctx *
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
+int damon_set_region_system_rams_default(struct damon_target *t,
+				unsigned long *start, unsigned long *end,
+				unsigned long addr_unit,
+				unsigned long min_region_sz);
+
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
 				unsigned long addr_unit,
--- a/mm/damon/core.c~mm-damon-introduce-damon_set_region_system_rams_default
+++ a/mm/damon/core.c
@@ -3328,14 +3328,20 @@ done:
 	return 0;
 }
 
-static int walk_system_ram(struct resource *res, void *arg)
+struct damon_system_ram_range_walk_arg {
+	bool walked;
+	struct resource res;
+};
+
+static int damon_system_ram_walk_fn(struct resource *res, void *arg)
 {
-	struct resource *a = arg;
+	struct damon_system_ram_range_walk_arg *a = arg;
 
-	if (resource_size(a) < resource_size(res)) {
-		a->start = res->start;
-		a->end = res->end;
+	if (!a->walked) {
+		a->walked = true;
+		a->res.start = res->start;
 	}
+	a->res.end = res->end;
 	return 0;
 }
 
@@ -3352,6 +3358,67 @@ static unsigned long damon_res_to_core_a
 	return ra / addr_unit;
 }
 
+static bool damon_find_system_rams_range(unsigned long *start,
+		unsigned long *end, unsigned long addr_unit)
+{
+	struct damon_system_ram_range_walk_arg arg = {};
+
+	walk_system_ram_res(0, -1, &arg, damon_system_ram_walk_fn);
+	if (!arg.walked)
+		return false;
+	*start = damon_res_to_core_addr(arg.res.start, addr_unit);
+	*end = damon_res_to_core_addr(arg.res.end + 1, addr_unit);
+	if (*end <= *start)
+		return false;
+	return true;
+}
+
+/**
+ * damon_set_region_system_rams_default() - Set the region of the given
+ * monitoring target as requested, or to cover all 'System RAM' resources.
+ * @t:		The monitoring target to set the region.
+ * @start:	The pointer to the start address of the region.
+ * @end:	The pointer to the end address of the region.
+ * @addr_unit:	The address unit for the damon_ctx of @t.
+ * @min_region_sz:	Minimum region size.
+ *
+ * This function sets the region of @t as requested by @start and @end.  If the
+ * values of @start and @end are zero, however, this function finds 'System
+ * RAM' resources and sets the region to cover all the resource.  In the latter
+ * case, this function saves the start and the end addresseses of the first and
+ * the last resources in @start and @end, respectively.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_set_region_system_rams_default(struct damon_target *t,
+			unsigned long *start, unsigned long *end,
+			unsigned long addr_unit, unsigned long min_region_sz)
+{
+	struct damon_addr_range addr_range;
+
+	if (*start > *end)
+		return -EINVAL;
+
+	if (!*start && !*end &&
+		!damon_find_system_rams_range(start, end, addr_unit))
+		return -EINVAL;
+
+	addr_range.start = *start;
+	addr_range.end = *end;
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+}
+
+static int walk_system_ram(struct resource *res, void *arg)
+{
+	struct resource *a = arg;
+
+	if (resource_size(a) < resource_size(res)) {
+		a->start = res->start;
+		a->end = res->end;
+	}
+	return 0;
+}
+
 /*
  * Find biggest 'System RAM' resource and store its start and end address in
  * @start and @end, respectively.  If no System RAM is found, returns false.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch
mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
mm-damon-core-introduce-struct-damon_probe.patch
mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch
mm-damon-core-introduce-damon_filter.patch
mm-damon-core-commit-probes.patch
mm-damon-core-introduce-damon_region-probe_hits.patch
mm-damon-core-introduce-damon_ops-apply_probes.patch
mm-damon-core-do-data-attributes-monitoring.patch
mm-damon-paddr-support-data-attributes-monitoring.patch
mm-damon-sysfs-implement-probes-dir.patch
mm-damon-sysfs-implement-probe-dir.patch
mm-damon-sysfs-implement-filters-directory.patch
mm-damon-sysfs-implement-filter-dir.patch
mm-damon-sysfs-implement-filter-dir-files.patch
mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch
mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch
mm-damon-sysfs-schemes-implement-probe-dir.patch
mm-damon-sysfs-schemes-implement-probe-hits-file.patch
mm-damon-trace-probe_hits.patch
selftests-damon-sysfssh-test-probes-dir.patch
docs-mm-damon-design-document-data-attributes-monitoring.patch
docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch
mm-damon-core-introduce-damon_filter_type_memcg.patch
mm-damon-paddr-support-damon_filter_type_memcg.patch
mm-damon-sysfs-add-filters-f-path-file.patch
mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch
mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch
docs-mm-damon-design-update-for-memcg-damon-filter.patch
docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch
mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch
mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch
samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-core-hide-damon_add_region.patch
mm-damon-core-hide-damon_insert_region.patch
mm-damon-core-hide-damon_destroy_region.patch
mm-damon-core-add-kdamond_call-debug_sanity-check.patch
mm-damon-core-remove-damon_verify_nr_regions.patch
mm-damon-tests-core-kunit-add-damon_set_regions-test-cases.patch
selftests-damon-sysfspy-stop-kdamonds-before-failing.patch
selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch
selftests-damon-sysfssh-test-addr_unit-file-existence.patch
selftests-damon-sysfssh-test-pause-file-existence.patch
mm-damon-core-trace-esz-at-first-setup.patch

