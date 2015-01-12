From: akpm@linux-foundation.org
Subject: + mm-memcontrol-default-hierarchy-interface-for-memory.patch
 added to -mm tree
Date: Mon, 12 Jan 2015 15:37:58 -0800
Message-ID: <54b45ad6.9tlekaZchEJ9BjvN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbALXh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:37:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: default hierarchy interface for memory
has been added to the -mm tree.  Its filename is
     mm-memcontrol-default-hierarchy-interface-for-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-default-hierarchy-interface-for-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-default-hierarchy-interface-for-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: default hierarchy interface for memory

Introduce the basic control files to account, partition, and limit
memory using cgroups in default hierarchy mode.

This interface versioning allows us to address fundamental design
issues in the existing memory cgroup interface, further explained
below.  The old interface will be maintained indefinitely, but a
clearer model and improved workload performance should encourage
existing users to switch over to the new one eventually.

The control files are thus:

  - memory.current shows the current consumption of the cgroup and its
    descendants, in bytes.

  - memory.low configures the lower end of the cgroup's expected
    memory consumption range.  The kernel considers memory below that
    boundary to be a reserve - the minimum that the workload needs in
    order to make forward progress - and generally avoids reclaiming
    it, unless there is an imminent risk of entering an OOM situation.

  - memory.high configures the upper end of the cgroup's expected
    memory consumption range.  A cgroup whose consumption grows beyond
    this threshold is forced into direct reclaim, to work off the
    excess and to throttle new allocations heavily, but is generally
    allowed to continue and the OOM killer is not invoked.

  - memory.max configures the hard maximum amount of memory that the
    cgroup is allowed to consume before the OOM killer is invoked.

  - memory.events shows event counters that indicate how often the
    cgroup was reclaimed while below memory.low, how often it was
    forced to reclaim excess beyond memory.high, how often it hit
    memory.max, and how often it entered OOM due to memory.max.  This
    allows users to identify configuration problems when observing a
    degradation in workload performance.  An overcommitted system will
    have an increased rate of low boundary breaches, whereas increased
    rates of high limit breaches, maximum hits, or even OOM situations
    will indicate internally overcommitted cgroups.

For existing users of memory cgroups, the following deviations from
the current interface are worth pointing out and explaining:

  - The original lower boundary, the soft limit, is defined as a limit
    that is per default unset.  As a result, the set of cgroups that
    global reclaim prefers is opt-in, rather than opt-out.  The costs
    for optimizing these mostly negative lookups are so high that the
    implementation, despite its enormous size, does not even provide
    the basic desirable behavior.  First off, the soft limit has no
    hierarchical meaning.  All configured groups are organized in a
    global rbtree and treated like equal peers, regardless where they
    are located in the hierarchy.  This makes subtree delegation
    impossible.  Second, the soft limit reclaim pass is so aggressive
    that it not just introduces high allocation latencies into the
    system, but also impacts system performance due to overreclaim, to
    the point where the feature becomes self-defeating.

    The memory.low boundary on the other hand is a top-down allocated
    reserve.  A cgroup enjoys reclaim protection when it and all its
    ancestors are below their low boundaries, which makes delegation
    of subtrees possible.  Secondly, new cgroups have no reserve per
    default and in the common case most cgroups are eligible for the
    preferred reclaim pass.  This allows the new low boundary to be
    efficiently implemented with just a minor addition to the generic
    reclaim code, without the need for out-of-band data structures and
    reclaim passes.  Because the generic reclaim code considers all
    cgroups except for the ones running low in the preferred first
    reclaim pass, overreclaim of individual groups is eliminated as
    well, resulting in much better overall workload performance.

  - The original high boundary, the hard limit, is defined as a strict
    limit that can not budge, even if the OOM killer has to be called.
    But this generally goes against the goal of making the most out of
    the available memory.  The memory consumption of workloads varies
    during runtime, and that requires users to overcommit.  But doing
    that with a strict upper limit requires either a fairly accurate
    prediction of the working set size or adding slack to the limit.
    Since working set size estimation is hard and error prone, and
    getting it wrong results in OOM kills, most users tend to err on
    the side of a looser limit and end up wasting precious resources.

    The memory.high boundary on the other hand can be set much more
    conservatively.  When hit, it throttles allocations by forcing
    them into direct reclaim to work off the excess, but it never
    invokes the OOM killer.  As a result, a high boundary that is
    chosen too aggressively will not terminate the processes, but
    instead it will lead to gradual performance degradation.  The user
    can monitor this and make corrections until the minimal memory
    footprint that still gives acceptable performance is found.

    In extreme cases, with many concurrent allocations and a complete
    breakdown of reclaim progress within the group, the high boundary
    can be exceeded.  But even then it's mostly better to satisfy the
    allocation from the slack available in other groups or the rest of
    the system than killing the group.  Otherwise, memory.max is there
    to limit this type of spillover and ultimately contain buggy or
    even malicious applications.

  - The existing control file names are unwieldy and inconsistent in
    many different ways.  For example, the upper boundary hit count is
    exported in the memory.failcnt file, but an OOM event count has to
    be manually counted by listening to memory.oom_control events, and
    lower boundary / soft limit events have to be counted by first
    setting a threshold for that value and then counting those events.
    Also, usage and limit files encode their units in the filename.
    That makes the filenames very long, even though this is not
    information that a user needs to be reminded of every time they
    type out those names.

    To address these naming issues, as well as to signal clearly that
    the new interface carries a new configuration model, the naming
    conventions in it necessarily differ from the old interface.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   32 ++++
 mm/memcontrol.c            |  247 +++++++++++++++++++++++++++++++++--
 mm/vmscan.c                |   22 ++-
 3 files changed, 287 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-default-hierarchy-interface-for-memory include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-default-hierarchy-interface-for-memory
+++ a/include/linux/memcontrol.h
@@ -52,7 +52,27 @@ struct mem_cgroup_reclaim_cookie {
 	unsigned int generation;
 };
 
+enum mem_cgroup_events_index {
+	MEM_CGROUP_EVENTS_PGPGIN,	/* # of pages paged in */
+	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
+	MEM_CGROUP_EVENTS_PGFAULT,	/* # of page-faults */
+	MEM_CGROUP_EVENTS_PGMAJFAULT,	/* # of major page-faults */
+	MEM_CGROUP_EVENTS_NSTATS,
+	/* default hierarchy events */
+	MEMCG_LOW = MEM_CGROUP_EVENTS_NSTATS,
+	MEMCG_HIGH,
+	MEMCG_MAX,
+	MEMCG_OOM,
+	MEMCG_NR_EVENTS,
+};
+
 #ifdef CONFIG_MEMCG
+void mem_cgroup_events(struct mem_cgroup *memcg,
+		       enum mem_cgroup_events_index idx,
+		       unsigned int nr);
+
+bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg);
+
 int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
 			  gfp_t gfp_mask, struct mem_cgroup **memcgp);
 void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
@@ -175,6 +195,18 @@ void mem_cgroup_split_huge_fixup(struct
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
+static inline void mem_cgroup_events(struct mem_cgroup *memcg,
+				     enum mem_cgroup_events_index idx,
+				     unsigned int nr)
+{
+}
+
+static inline bool mem_cgroup_low(struct mem_cgroup *root,
+				  struct mem_cgroup *memcg)
+{
+	return false;
+}
+
 static inline int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask,
 					struct mem_cgroup **memcgp)
diff -puN mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory
+++ a/mm/memcontrol.c
@@ -97,14 +97,6 @@ static const char * const mem_cgroup_sta
 	"swap",
 };
 
-enum mem_cgroup_events_index {
-	MEM_CGROUP_EVENTS_PGPGIN,	/* # of pages paged in */
-	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
-	MEM_CGROUP_EVENTS_PGFAULT,	/* # of page-faults */
-	MEM_CGROUP_EVENTS_PGMAJFAULT,	/* # of major page-faults */
-	MEM_CGROUP_EVENTS_NSTATS,
-};
-
 static const char * const mem_cgroup_events_names[] = {
 	"pgpgin",
 	"pgpgout",
@@ -138,7 +130,7 @@ enum mem_cgroup_events_target {
 
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
-	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
+	unsigned long events[MEMCG_NR_EVENTS];
 	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
 };
@@ -284,6 +276,10 @@ struct mem_cgroup {
 	struct page_counter memsw;
 	struct page_counter kmem;
 
+	/* Normal memory consumption range */
+	unsigned long low;
+	unsigned long high;
+
 	unsigned long soft_limit;
 
 	/* vmpressure notifications */
@@ -2327,6 +2323,8 @@ retry:
 	if (!(gfp_mask & __GFP_WAIT))
 		goto nomem;
 
+	mem_cgroup_events(mem_over_limit, MEMCG_MAX, 1);
+
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, may_swap);
 
@@ -2368,6 +2366,8 @@ retry:
 	if (fatal_signal_pending(current))
 		goto bypass;
 
+	mem_cgroup_events(mem_over_limit, MEMCG_OOM, 1);
+
 	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(nr_pages));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
@@ -2379,6 +2379,22 @@ done_restock:
 	css_get_many(&memcg->css, batch);
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
+	/*
+	 * If the hierarchy is above the normal consumption range,
+	 * make the charging task trim the excess.
+	 */
+	do {
+		unsigned long nr_pages = page_counter_read(&memcg->memory);
+		unsigned long high = ACCESS_ONCE(memcg->high);
+
+		if (nr_pages > high) {
+			mem_cgroup_events(memcg, MEMCG_HIGH, 1);
+
+			try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+						     gfp_mask, true);
+		}
+
+	} while ((memcg = parent_mem_cgroup(memcg)));
 done:
 	return ret;
 }
@@ -4312,7 +4328,7 @@ out_kfree:
 	return ret;
 }
 
-static struct cftype mem_cgroup_files[] = {
+static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
@@ -4588,6 +4604,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (parent_css == NULL) {
 		root_mem_cgroup = memcg;
 		page_counter_init(&memcg->memory, NULL);
+		memcg->high = PAGE_COUNTER_MAX;
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
@@ -4633,6 +4650,7 @@ mem_cgroup_css_online(struct cgroup_subs
 
 	if (parent->use_hierarchy) {
 		page_counter_init(&memcg->memory, &parent->memory);
+		memcg->high = PAGE_COUNTER_MAX;
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
@@ -4643,6 +4661,7 @@ mem_cgroup_css_online(struct cgroup_subs
 		 */
 	} else {
 		page_counter_init(&memcg->memory, NULL);
+		memcg->high = PAGE_COUNTER_MAX;
 		memcg->soft_limit = PAGE_COUNTER_MAX;
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
@@ -4718,6 +4737,8 @@ static void mem_cgroup_css_reset(struct
 	mem_cgroup_resize_limit(memcg, PAGE_COUNTER_MAX);
 	mem_cgroup_resize_memsw_limit(memcg, PAGE_COUNTER_MAX);
 	memcg_update_kmem_limit(memcg, PAGE_COUNTER_MAX);
+	memcg->low = 0;
+	memcg->high = PAGE_COUNTER_MAX;
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 }
 
@@ -5304,6 +5325,159 @@ static void mem_cgroup_bind(struct cgrou
 		mem_cgroup_from_css(root_css)->use_hierarchy = true;
 }
 
+static u64 memory_current_read(struct cgroup_subsys_state *css,
+			       struct cftype *cft)
+{
+	return mem_cgroup_usage(mem_cgroup_from_css(css), false);
+}
+
+static int memory_low_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	unsigned long low = ACCESS_ONCE(memcg->low);
+
+	if (low == 0)
+		seq_printf(m, "none\n");
+	else
+		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);
+
+	return 0;
+}
+
+static ssize_t memory_low_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long low;
+	int err;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, "none")) {
+		low = 0;
+	} else {
+		err = page_counter_memparse(buf, &low);
+		if (err)
+			return err;
+	}
+
+	memcg->low = low;
+
+	return nbytes;
+}
+
+static int memory_high_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	unsigned long high = ACCESS_ONCE(memcg->high);
+
+	if (high == PAGE_COUNTER_MAX)
+		seq_printf(m, "none\n");
+	else
+		seq_printf(m, "%llu\n", (u64)high * PAGE_SIZE);
+
+	return 0;
+}
+
+static ssize_t memory_high_write(struct kernfs_open_file *of,
+				 char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long high;
+	int err;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, "none")) {
+		high = PAGE_COUNTER_MAX;
+	} else {
+		err = page_counter_memparse(buf, &high);
+		if (err)
+			return err;
+	}
+
+	memcg->high = high;
+
+	return nbytes;
+}
+
+static int memory_max_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	unsigned long max = ACCESS_ONCE(memcg->memory.limit);
+
+	if (max == PAGE_COUNTER_MAX)
+		seq_printf(m, "none\n");
+	else
+		seq_printf(m, "%llu\n", (u64)max * PAGE_SIZE);
+
+	return 0;
+}
+
+static ssize_t memory_max_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long max;
+	int err;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, "none")) {
+		max = PAGE_COUNTER_MAX;
+	} else {
+		err = page_counter_memparse(buf, &max);
+		if (err)
+			return err;
+	}
+
+	err = mem_cgroup_resize_limit(memcg, max);
+	if (err)
+		return err;
+
+	return nbytes;
+}
+
+static int memory_events_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+
+	seq_printf(m, "low %lu\n", mem_cgroup_read_events(memcg, MEMCG_LOW));
+	seq_printf(m, "high %lu\n", mem_cgroup_read_events(memcg, MEMCG_HIGH));
+	seq_printf(m, "max %lu\n", mem_cgroup_read_events(memcg, MEMCG_MAX));
+	seq_printf(m, "oom %lu\n", mem_cgroup_read_events(memcg, MEMCG_OOM));
+
+	return 0;
+}
+
+static struct cftype memory_files[] = {
+	{
+		.name = "current",
+		.read_u64 = memory_current_read,
+	},
+	{
+		.name = "low",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_low_show,
+		.write = memory_low_write,
+	},
+	{
+		.name = "high",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_high_show,
+		.write = memory_high_write,
+	},
+	{
+		.name = "max",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_max_show,
+		.write = memory_max_write,
+	},
+	{
+		.name = "events",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_events_show,
+	},
+	{ }	/* terminate */
+};
+
 struct cgroup_subsys memory_cgrp_subsys = {
 	.css_alloc = mem_cgroup_css_alloc,
 	.css_online = mem_cgroup_css_online,
@@ -5314,7 +5488,8 @@ struct cgroup_subsys memory_cgrp_subsys
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.attach = mem_cgroup_move_task,
 	.bind = mem_cgroup_bind,
-	.legacy_cftypes = mem_cgroup_files,
+	.dfl_cftypes = memory_files,
+	.legacy_cftypes = mem_cgroup_legacy_files,
 	.early_init = 0,
 };
 
@@ -5349,6 +5524,56 @@ static void __init enable_swap_cgroup(vo
 }
 #endif
 
+/**
+ * mem_cgroup_events - count memory events against a cgroup
+ * @memcg: the memory cgroup
+ * @idx: the event index
+ * @nr: the number of events to account for
+ */
+void mem_cgroup_events(struct mem_cgroup *memcg,
+		       enum mem_cgroup_events_index idx,
+		       unsigned int nr)
+{
+	this_cpu_add(memcg->stat->events[idx], nr);
+}
+
+/**
+ * mem_cgroup_low - check if memory consumption is below the normal range
+ * @root: the highest ancestor to consider
+ * @memcg: the memory cgroup to check
+ *
+ * Returns %true if memory consumption of @memcg, and that of all
+ * configurable ancestors up to @root, is below the normal range.
+ */
+bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return false;
+
+	/*
+	 * The toplevel group doesn't have a configurable range, so
+	 * it's never low when looked at directly, and it is not
+	 * considered an ancestor when assessing the hierarchy.
+	 */
+
+	if (memcg == root_mem_cgroup)
+		return false;
+
+	if (page_counter_read(&memcg->memory) > memcg->low)
+		return false;
+
+	while (memcg != root) {
+		memcg = parent_mem_cgroup(memcg);
+
+		if (memcg == root_mem_cgroup)
+			break;
+
+		if (page_counter_read(&memcg->memory) > memcg->low)
+			return false;
+	}
+	return true;
+}
+
 #ifdef CONFIG_MEMCG_SWAP
 /**
  * mem_cgroup_swapout - transfer a memsw charge to swap
diff -puN mm/vmscan.c~mm-memcontrol-default-hierarchy-interface-for-memory mm/vmscan.c
--- a/mm/vmscan.c~mm-memcontrol-default-hierarchy-interface-for-memory
+++ a/mm/vmscan.c
@@ -91,6 +91,9 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	unsigned int may_swap:1;
 
+	/* Can cgroups be reclaimed below their normal consumption range? */
+	unsigned int may_thrash:1;
+
 	unsigned int hibernation_mode:1;
 
 	/* One of the zones is ready for compaction */
@@ -2333,6 +2336,12 @@ static bool shrink_zone(struct zone *zon
 			struct lruvec *lruvec;
 			int swappiness;
 
+			if (mem_cgroup_low(root, memcg)) {
+				if (!sc->may_thrash)
+					continue;
+				mem_cgroup_events(memcg, MEMCG_LOW, 1);
+			}
+
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 			swappiness = mem_cgroup_swappiness(memcg);
 			scanned = sc->nr_scanned;
@@ -2360,8 +2369,7 @@ static bool shrink_zone(struct zone *zon
 				mem_cgroup_iter_break(root, memcg);
 				break;
 			}
-			memcg = mem_cgroup_iter(root, memcg, &reclaim);
-		} while (memcg);
+		} while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));
 
 		/*
 		 * Shrink the slab caches in the same proportion that
@@ -2559,10 +2567,11 @@ static bool shrink_zones(struct zonelist
 static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 					  struct scan_control *sc)
 {
+	int initial_priority = sc->priority;
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
 	bool zones_reclaimable;
-
+retry:
 	delayacct_freepages_start();
 
 	if (global_reclaim(sc))
@@ -2612,6 +2621,13 @@ static unsigned long do_try_to_free_page
 	if (sc->compaction_ready)
 		return 1;
 
+	/* Untapped cgroup reserves?  Don't OOM, retry. */
+	if (!sc->may_thrash) {
+		sc->priority = initial_priority;
+		sc->may_thrash = 1;
+		goto retry;
+	}
+
 	/* Any of the zones still reclaimable?  Don't OOM. */
 	if (zones_reclaimable)
 		return 1;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-memcontrol-track-move_lock-state-internally-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

