Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8143BED7B
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896704; cv=none; b=e6mDTCEud8HV6CVY4iB0xnMwQcEwD5v+ReolZOpp4O+Z39vrejHE4W/TzKGc4aCo9ZmXKOXN/5DMflvT/fAuIEWJRB7o/ZPM8u7hxeEtm8BtPCzs7kEg+Jx+nzbfJYf8Vfp3hfnXBxHnm0xH4fNgV6tDGn978YWVk1a6gS1LFrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896704; c=relaxed/simple;
	bh=SQBXyONHh8S9xcTtCsb09X1P4pqVuHwKBMs4vAygVYM=;
	h=Date:To:From:Subject:Message-Id; b=Ennk8D9lYk6dCLajBsbr7A6lFYbllhotujtLUgFYdCmp8S5EYi8P7CclngcKLpC0HHYcB6vVlHlsx6vdJl7TukwXQctpjGASq+8eNq1EJqgNPdr8i+vPRONG7xmWxKI4qFYdFP8Jw5fahNz6XdpLhGn7iN5ZmuuJgFmZvg0PoAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N6RcSfDg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N6RcSfDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042FA1F000E9;
	Wed,  5 Aug 2026 02:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896702;
	bh=jAwSJ+ec5BLLVq2ePjFQ2XXMLhIIHNvO1Go00pzD/8c=;
	h=Date:To:From:Subject;
	b=N6RcSfDglGFn/dS9VIG75GWZNAM+LRw33h2Yaqd6s0w9aa72mnHVUIuUWsuXwyPvr
	 aaRBkT8difLFgk1Jq/CUVXOX5ZlvzzGjlGXI5aU4bsqfc4SjB5/BILOomRy8laYWHE
	 kXM7D0DkQgxFjs3bZ7s+8PnNw+phDFT3DLWraC8U=
Date: Tue, 04 Aug 2026 19:25:01 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_probe-weight.patch removed from -mm tree
Message-Id: <20260805022502.042FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damon_probe->weight
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_probe-weight.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_probe->weight
Date: Fri, 10 Jul 2026 06:46:30 -0700

Patch series "mm/damon: introduce data attributes only monitoring".

TL;DR: Introduce a way to get DAMON's best effort accuracy monitoring of
user-demanding non-access data attributes.

Background
==========

DAMON was initially designed for only access monitoring.  It turned out
users want to get the information together with more data attributes.  For
example, some users want to know how much of a hot memory region belongs
to huge pages or specific cgroups.  Page level properties based monitoring
was introduced with commit 626ffabe67c2 ("mm/damon: clarify trying vs
applying on damos_stat kernel-doc comment") to fill the gap.  Because it
works only at snapshot level and snapshot capturing in the mode can induce
high overhead, commit 45c49d9fd608 ("mm/damon/core: introduce struct
damon_probe") introduced data attributes monitoring.

Data attributes monitoring treats the attributes as only additional and
subordinate information.  Data access monitoring is always turned on, and
regions are adjusted for best accuracy of the access information.  In some
cases, users may be primarily interested in the attributes more than the
access.  They might even not care about the access information at all. 
Because DAMON treats data accesses as the only primary information, such
users cannot get high quality attributes information.

Design and Implementation
=========================

Introduce another way for treating data attributes as the primary
information.  Add 'weight' property to each data attribute probe.  When
any of the weights are set, the mode is enabled.  Data access monitoring
is completely turned off in the mode.  For region adjustment, the weighted
sum of probe hit counters is used instead of the nr_accesses.

Using the weights, users can specify to what attributes they are
interested in to what degree.  DAMON will adjust the regions and provide
the best-effort quality monitoring that is optimized for the user demands.

Extend damon_operations for efficient use of probe hits.  Update regions
merge and kdamond main logic to support the new mode.  Add a new struct
field and a sysfs file for API callers and ABI users, respectively.

Test
====

On ~7 GiB memory idle system, run a simple AI-assisted program.  The
program allocates and faults 2 GiB anonymous pages.  Then, it does nothing
but wait until the user terminates it.  Hence, the system ~2 GiB of
anonymous pages with no active accesses.

Monitor the distribution of the anonymous pages using DAMON attributes
monitoring mode, using DAMON user-space tool, damo [1].

    $ sudo ./damo start --probe_filter allow anon
    $ sudo ./damo report access --dont_merge_regions
    heatmap: 00000000000000000000000000000000000000000000000399999995111111146666666666666666
    # min/max temperatures: -2,470,000,000, -1,620,000,000, column size: 99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    #   <start>      <size>       <freq> <age>         <probe hits>
    0   4.000 KiB    79.840 MiB   0 hz   24.700 s      2
    1   79.844 MiB   718.562 MiB  0 hz   24.700 s      8
    2   798.406 MiB  793.148 MiB  0 hz   24.700 s      7
    3   1.554 GiB    797.828 MiB  0 hz   24.700 s      7
    4   2.333 GiB    794.668 MiB  0 hz   24.600 s      8
    5   3.109 GiB    791.117 MiB  0 hz   24.500 s      0
    6   3.882 GiB    785.312 MiB  0 hz   24 s          2
    7   4.649 GiB    787.867 MiB  0 hz   16.200 s      6
    8   5.418 GiB    784.477 MiB  0 hz   23.300 s      6
    9   6.184 GiB    783.820 MiB  0 hz   18.200 s      9
    10  6.950 GiB    797.730 MiB  0 hz   18.900 s      7
    11  7.729 GiB    69.625 MiB   0 hz   18.900 s      0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Note that the line after the line starting with "intervals:" is not
provided by the current version of 'damo'.  I manually added the legends
line for easier understanding of these results.

Each of the 12 lines after the legend line shows the DAMON-found regions. 
Each line shows 1) index of the region, 2) start address of the region, 3)
size of the region, 4) access frequency of the region, 5) age (how long
the access frequency on the region was kept) of the region, and finally 6)
the probe hit count.

Because data access is the primary information that adjusts region for,
and there is only nearly zero access on the system, regions are naively
adjusted with the same size.  Still <probe hits> show different
distribution of the anonymous pages, but it is obviously very rough
information.

Switch to the attributes only mode and show how it changes the picture:

    $ sudo ./damo tune --probe_filter allow anon --probe_weight 100
    $ sudo ./damo report access --dont_merge_regions
    heatmap: 88888888888888888889888999999889999999000004888888888888889999988888898888888888
    # min/max temperatures: -4,430,000,000, 0, column size: 99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    #   <start>      <size>       <freq> <age>         <probe hits>
    0   4.000 KiB    60.445 MiB   0 hz   700 ms        0
    1   60.449 MiB   1.363 MiB    0 hz   600 ms        18
    2   61.812 MiB   144.000 KiB  0 hz   0 ns          1
    3   61.953 MiB   1.922 MiB    0 hz   2.400 s       19
    4   63.875 MiB   12.133 MiB   0 hz   200 ms        0
    [...]
    500 5.132 GiB    8.000 KiB    0 hz   2 m 15.800 s  20
    501 5.132 GiB    8.000 KiB    0 hz   2 m 16.200 s  0
    502 5.132 GiB    16.000 KiB   0 hz   2 m 16.900 s  20
    503 5.132 GiB    24.000 KiB   0 hz   2 m 14.200 s  0
    504 5.132 GiB    8.000 KiB    0 hz   2 m 14.900 s  20
    [...]
    923 7.534 GiB    126.637 MiB  0 hz   0 ns          6
    924 7.658 GiB    252.000 KiB  0 hz   54.800 s      20
    925 7.658 GiB    142.242 MiB  0 hz   300 ms        0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

As expected, regions are adjusted to provide the best accurate picture for
the anonymous pages distribution (<probe hits>).  The region 0 (60.445 MiB
memory from the address 4.000 KiB) has nearly zero anonymous pages.  The
region 1 (1.363 MiB memory from the address 60.449 MiB) is nearly full
with anonymous pages.  Region 500 (8 KiB memory from the address 5.132
GiB) is certainly two anonymous pages.

Future Work
===========

Attributes only monitoring disables access monitoring.  We will enable
that in future, by extending the supported attributes to include data
accesses.  This patch series, and the future work are parts of the ongoing
project [2] for extending DAMON.  The project aims to extend DAMON with
primitives other than page table accessed bits such as AMD IBS, Intel
PEBS, and Arm SPE, to provide more powerful and detailed information like
per-CPUs/threads/reads/writes monitoring.

Patches Sequence
================

Patch 1 introduces damon_probe->weight for specifying the weights of each
attribute.  Patches 2-6 extends apply_probe() damon_ops callback to
efficiently support the new mode.  Patch 7 fixes wrong use of abs() in the
regions merge code.  Patch 8 extends regions merge function to work with
probe hits in the mode.  Patch 8 also introduces the function for
detecting the mode enablement but always returns false, for safe and
incremental changes.  Patches 9 and 10 adds user parameters validation to
prevent theoretical overflow of probe hits and the weighted sum.  Patches
11-14 incrementally update kdamond_fn() to support the mode.  Patch 15
completes the mode detection function implementation, so that the new mode
really works.  Patch 16 introduces a new sysfs file for ABI users. 
Finally, patches 17-19 respectively updates design, usage and ABI
documents for the new feature and interfaces.

[1] https://github.com/damonitor/damo
[2] https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/


This patch (of 19):

Add a new field, weight to damon_probe struct.  The field is used to
specify the degree of the API caller's interest to the data attribute of
the probe.

Link: https://lore.kernel.org/20260710134651.18084-1-sj@kernel.org
Link: https://lore.kernel.org/20260710134651.18084-2-sj@kernel.org
Link: https://github.com/damonitor/damo [1]
Link: https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/ [2]
Signed-off-by: SJ Park <sj@kernel.org>
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

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |    3 +++
 2 files changed, 5 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_probe-weight
+++ a/include/linux/damon.h
@@ -760,10 +760,12 @@ struct damon_filter {
 /**
  * struct damon_probe - Data region attribute probe.
  *
+ * @weight:	Relative priority of the attribute for this probe.
  * @filters:	Filters for assessing if a given region is for this probe.
  * @list:	Siblings list.
  */
 struct damon_probe {
+	unsigned int weight;
 	struct list_head filters;
 	struct list_head list;
 };
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_probe-weight
+++ a/mm/damon/core.c
@@ -166,6 +166,7 @@ struct damon_probe *damon_new_probe(void
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	p->weight = 0;
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
@@ -1658,6 +1659,7 @@ static int damon_commit_probes(struct da
 	damon_for_each_probe_safe(dst_probe, next, dst) {
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
+			dst_probe->weight = src_probe->weight;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1674,6 +1676,7 @@ static int damon_commit_probes(struct da
 		if (!new_probe)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
+		new_probe->weight = src_probe->weight;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch
mm-damon-core-hide-private-damon_region-fields.patch
mm-damon-core-hide-private-damon_target-fields.patch
mm-damon-core-hide-private-damos_quota_goal-fields.patch
mm-damon-core-hide-private-damos_quota-fields.patch
mm-damon-core-hide-private-damos_filter-fields.patch
mm-damon-core-hide-private-damos-fields.patch
mm-damon-core-hide-private-damon_filter-fields.patch
mm-damon-core-hide-private-damon_probe-fields.patch
mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch
mm-damon-core-hide-core-private-damon_ctx-fields.patch
mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch
mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch
mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch
mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch
mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-core-initialize-damos-last_applied.patch
mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch
mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch
mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch
mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch
mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch
mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

