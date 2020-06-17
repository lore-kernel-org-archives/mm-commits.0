From: akpm@linux-foundation.org
Subject: + mm-proactive-compaction.patch added to -mm tree
Date: Wed, 17 Jun 2020 13:55:44 -0700
Message-ID: <20200617205544.cF10J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQUzq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 16:55:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz, rientjes@google.com, oleksandr@redhat.com, ngupta@nitingupta.dev, mike.kravetz@oracle.com, mhocko@suse.com, mgorman@techsingularity.net, khalid.aziz@oracle.com, iamjoonsoo.kim@lge.com, nigupta@nvidia.com


The patch titled
     Subject: mm: proactive compaction
has been added to the -mm tree.  Its filename is
     mm-proactive-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proactive-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proactive-compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nitin Gupta <nigupta@nvidia.com>
Subject: mm: proactive compaction

For some applications, we need to allocate almost all memory as hugepages.
However, on a running system, higher-order allocations can fail if the
memory is fragmented.  Linux kernel currently does on-demand compaction as
we request more hugepages, but this style of compaction incurs very high
latency.  Experiments with one-time full memory compaction (followed by
hugepage allocations) show that kernel is able to restore a highly
fragmented memory state to a fairly compacted memory state within <1 sec
for a 32G system.  Such data suggests that a more proactive compaction can
help us allocate a large fraction of memory as hugepages keeping
allocation latencies low.

For a more proactive compaction, the approach taken here is to define a
new sysctl called 'vm.compaction_proactiveness' which dictates bounds for
external fragmentation which kcompactd tries to maintain.

The tunable takes a value in range [0, 100], with a default of 20.

Note that a previous version of this patch [1] was found to introduce too
many tunables (per-order extfrag{low, high}), but this one reduces them to
just one sysctl.  Also, the new tunable is an opaque value instead of
asking for specific bounds of "external fragmentation", which would have
been difficult to estimate.  The internal interpretation of this opaque
value allows for future fine-tuning.

Currently, we use a simple translation from this tunable to [low, high]
"fragmentation score" thresholds (low=3D100-proactiveness, high=3Dlow+10%).=
=20
The score for a node is defined as weighted mean of per-zone external
fragmentation.  A zone's present_pages determines its weight.

To periodically check per-node score, we reuse per-node kcompactd threads,
which are woken up every 500 milliseconds to check the same.  If a node's
score exceeds its high threshold (as derived from user-provided
proactiveness value), proactive compaction is started until its score
reaches its low threshold value.  By default, proactiveness is set to 20,
which implies threshold values of low=3D80 and high=3D90.

This patch is largely based on ideas from Michal Hocko [2].  See also the
LWN article [3].

Performance data
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

System: x64_64, 1T RAM, 80 CPU threads.
Kernel: 5.6.0-rc3 + this patch

echo madvise | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
echo madvise | sudo tee /sys/kernel/mm/transparent_hugepage/defrag

Before starting the driver, the system was fragmented from a userspace
program that allocates all memory and then for each 2M aligned section,
frees 3/4 of base pages using munmap.  The workload is mainly anonymous
userspace pages, which are easy to move around.  I intentionally avoided
unmovable pages in this test to see how much latency we incur when
hugepage allocations hit direct compaction.

1. Kernel hugepage allocation latencies

With the system in such a fragmented state, a kernel driver then allocates
as many hugepages as possible and measures allocation latency:

(all latency values are in microseconds)

- With vanilla 5.6.0-rc3

  percentile latency
  =E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=
=E2=80=93=E2=80=93 =E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=
=E2=80=93
	   5    7894
	  10    9496
	  25   12561
	  30   15295
	  40   18244
	  50   21229
	  60   27556
	  75   30147
	  80   31047
	  90   32859
	  95   33799

Total 2M hugepages allocated =3D 383859 (749G worth of hugepages out of 762G
total free =3D> 98% of free memory could be allocated as hugepages)

- With 5.6.0-rc3 + this patch, with proactiveness=3D20

sysctl -w vm.compaction_proactiveness=3D20

  percentile latency
  =E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=
=E2=80=93=E2=80=93 =E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=E2=80=93=
=E2=80=93
	   5       2
	  10       2
	  25       3
	  30       3
	  40       3
	  50       4
	  60       4
	  75       4
	  80       4
	  90       5
	  95     429

Total 2M hugepages allocated =3D 384105 (750G worth of hugepages out of 762G
total free =3D> 98% of free memory could be allocated as hugepages)

2. JAVA heap allocation

In this test, we first fragment memory using the same method as for (1).

Then, we start a Java process with a heap size set to 700G and request the
heap to be allocated with THP hugepages.  We also set THP to madvise to
allow hugepage backing of this heap.

/usr/bin/time
 java -Xms700G -Xmx700G -XX:+UseTransparentHugePages -XX:+AlwaysPreTouch

The above command allocates 700G of Java heap using hugepages.

- With vanilla 5.6.0-rc3

17.39user 1666.48system 27:37.89elapsed

- With 5.6.0-rc3 + this patch, with proactiveness=3D20

8.35user 194.58system 3:19.62elapsed

Elapsed time remains around 3:15, as proactiveness is further increased.

Note that proactive compaction happens throughout the runtime of these
workloads.  The situation of one-time compaction, sufficient to supply
hugepages for following allocation stream, can probably happen for more
extreme proactiveness values, like 80 or 90.

In the above Java workload, proactiveness is set to 20.  The test starts
with a node's score of 80 or higher, depending on the delay between the
fragmentation step and starting the benchmark, which gives more-or-less
time for the initial round of compaction.  As t he benchmark consumes
hugepages, node's score quickly rises above the high threshold (90) and
proactive compaction starts again, which brings down the score to the low
threshold level (80).  Repeat.

bpftrace also confirms proactive compaction running 20+ times during the
runtime of this Java benchmark.  kcompactd threads consume 100% of one of
the CPUs while it tries to bring a node's score within thresholds.

Backoff behavior
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Above workloads produce a memory state which is easy to compact.  However,
if memory is filled with unmovable pages, proactive compaction should
essentially back off.  To test this aspect:

- Created a kernel driver that allocates almost all memory as hugepages
  followed by freeing first 3/4 of each hugepage.
- Set proactiveness=3D40
- Note that proactive_compact_node() is deferred maximum number of times
  with HPAGE_FRAG_CHECK_INTERVAL_MSEC of wait between each check
  (=3D> ~30 seconds between retries).

[1] https://patchwork.kernel.org/patch/11098289/
[2] https://lore.kernel.org/linux-mm/20161230131412.GI13301@dhcp22.suse.cz/
[3] https://lwn.net/Articles/817905/

Link: http://lkml.kernel.org/r/20200616204527.19185-1-nigupta@nvidia.com
Signed-off-by: Nitin Gupta <nigupta@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Reviewed-by: Oleksandr Natalenko <oleksandr@redhat.com>
Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Nitin Gupta <ngupta@nitingupta.dev>
Cc: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   15 +
 include/linux/compaction.h              |    2=20
 kernel/sysctl.c                         |    9 +
 mm/compaction.c                         |  183 +++++++++++++++++++++-
 mm/internal.h                           |    1=20
 mm/vmstat.c                             |   18 ++
 6 files changed, 223 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-proactive-compaction
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -119,6 +119,21 @@ all zones are compacted such that free m
 blocks where possible. This can be important for example in the allocation=
 of
 huge pages although processes will also directly compact memory as require=
d.
=20
+compaction_proactiveness
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+This tunable takes a value in the range [0, 100] with a default value of
+20. This tunable determines how aggressively compaction is done in the
+background. Setting it to 0 disables proactive compaction.
+
+Note that compaction has a non-trivial system-wide impact as pages
+belonging to different processes are moved around, which could also lead
+to latency spikes in unsuspecting applications. The kernel employs
+various heuristics to avoid wasting CPU cycles if it detects that
+proactive compaction is not being effective.
+
+Be careful when setting it to extreme values like 100, as that may
+cause excessive background compaction activity.
=20
 compact_unevictable_allowed
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
--- a/include/linux/compaction.h~mm-proactive-compaction
+++ a/include/linux/compaction.h
@@ -85,11 +85,13 @@ static inline unsigned long compact_gap(
=20
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
+extern int sysctl_compaction_proactiveness;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void *buffer, size_t *length, loff_t *ppos);
 extern int sysctl_extfrag_threshold;
 extern int sysctl_compact_unevictable_allowed;
=20
+extern int extfrag_for_order(struct zone *zone, unsigned int order);
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 		unsigned int order, unsigned int alloc_flags,
--- a/kernel/sysctl.c~mm-proactive-compaction
+++ a/kernel/sysctl.c
@@ -2831,6 +2831,15 @@ static struct ctl_table vm_table[] =3D {
 		.proc_handler	=3D sysctl_compaction_handler,
 	},
 	{
+		.procname	=3D "compaction_proactiveness",
+		.data		=3D &sysctl_compaction_proactiveness,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D proc_dointvec_minmax,
+		.extra1		=3D SYSCTL_ZERO,
+		.extra2		=3D &one_hundred,
+	},
+	{
 		.procname	=3D "extfrag_threshold",
 		.data		=3D &sysctl_extfrag_threshold,
 		.maxlen		=3D sizeof(int),
--- a/mm/compaction.c~mm-proactive-compaction
+++ a/mm/compaction.c
@@ -50,6 +50,24 @@ static inline void count_compact_events(
 #define pageblock_start_pfn(pfn)	block_start_pfn(pfn, pageblock_order)
 #define pageblock_end_pfn(pfn)		block_end_pfn(pfn, pageblock_order)
=20
+/*
+ * Fragmentation score check interval for proactive compaction purposes.
+ */
+static const int HPAGE_FRAG_CHECK_INTERVAL_MSEC =3D 500;
+
+/*
+ * Page order with-respect-to which proactive compaction
+ * calculates external fragmentation, which is used as
+ * the "fragmentation score" of a node/zone.
+ */
+#if defined CONFIG_TRANSPARENT_HUGEPAGE
+#define COMPACTION_HPAGE_ORDER	HPAGE_PMD_ORDER
+#elif defined HUGETLB_PAGE_ORDER
+#define COMPACTION_HPAGE_ORDER	HUGETLB_PAGE_ORDER
+#else
+#define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
+#endif
+
 static unsigned long release_freepages(struct list_head *freelist)
 {
 	struct page *page, *next;
@@ -1857,6 +1875,76 @@ static inline bool is_via_compact_memory
 	return order =3D=3D -1;
 }
=20
+static bool kswapd_is_running(pg_data_t *pgdat)
+{
+	return pgdat->kswapd && (pgdat->kswapd->state =3D=3D TASK_RUNNING);
+}
+
+/*
+ * A zone's fragmentation score is the external fragmentation wrt to the
+ * COMPACTION_HPAGE_ORDER scaled by the zone's size. It returns a value
+ * in the range [0, 100].
+ *
+ * The scaling factor ensures that proactive compaction focuses on larger
+ * zones like ZONE_NORMAL, rather than smaller, specialized zones like
+ * ZONE_DMA32. For smaller zones, the score value remains close to zero,
+ * and thus never exceeds the high threshold for proactive compaction.
+ */
+static int fragmentation_score_zone(struct zone *zone)
+{
+	unsigned long score;
+
+	score =3D zone->present_pages *
+			extfrag_for_order(zone, COMPACTION_HPAGE_ORDER);
+	return div64_ul(score, zone->zone_pgdat->node_present_pages + 1);
+}
+
+/*
+ * The per-node proactive (background) compaction process is started by its
+ * corresponding kcompactd thread when the node's fragmentation score
+ * exceeds the high threshold. The compaction process remains active till
+ * the node's score falls below the low threshold, or one of the back-off
+ * conditions is met.
+ */
+static int fragmentation_score_node(pg_data_t *pgdat)
+{
+	unsigned long score =3D 0;
+	int zoneid;
+
+	for (zoneid =3D 0; zoneid < MAX_NR_ZONES; zoneid++) {
+		struct zone *zone;
+
+		zone =3D &pgdat->node_zones[zoneid];
+		score +=3D fragmentation_score_zone(zone);
+	}
+
+	return score;
+}
+
+static int fragmentation_score_wmark(pg_data_t *pgdat, bool low)
+{
+	int wmark_low;
+
+	/*
+	 * Cap the low watermak to avoid excessive compaction
+	 * activity in case a user sets the proactivess tunable
+	 * close to 100 (maximum).
+	 */
+	wmark_low =3D max(100 - sysctl_compaction_proactiveness, 5);
+	return low ? wmark_low : min(wmark_low + 10, 100);
+}
+
+static bool should_proactive_compact_node(pg_data_t *pgdat)
+{
+	int wmark_high;
+
+	if (!sysctl_compaction_proactiveness || kswapd_is_running(pgdat))
+		return false;
+
+	wmark_high =3D fragmentation_score_wmark(pgdat, false);
+	return fragmentation_score_node(pgdat) > wmark_high;
+}
+
 static enum compact_result __compact_finished(struct compact_control *cc)
 {
 	unsigned int order;
@@ -1883,6 +1971,25 @@ static enum compact_result __compact_fin
 			return COMPACT_PARTIAL_SKIPPED;
 	}
=20
+	if (cc->proactive_compaction) {
+		int score, wmark_low;
+		pg_data_t *pgdat;
+
+		pgdat =3D cc->zone->zone_pgdat;
+		if (kswapd_is_running(pgdat))
+			return COMPACT_PARTIAL_SKIPPED;
+
+		score =3D fragmentation_score_zone(cc->zone);
+		wmark_low =3D fragmentation_score_wmark(pgdat, true);
+
+		if (score > wmark_low)
+			ret =3D COMPACT_CONTINUE;
+		else
+			ret =3D COMPACT_SUCCESS;
+
+		goto out;
+	}
+
 	if (is_via_compact_memory(cc->order))
 		return COMPACT_CONTINUE;
=20
@@ -1941,6 +2048,7 @@ static enum compact_result __compact_fin
 		}
 	}
=20
+out:
 	if (cc->contended || fatal_signal_pending(current))
 		ret =3D COMPACT_CONTENDED;
=20
@@ -2410,6 +2518,41 @@ enum compact_result try_to_compact_pages
 	return rc;
 }
=20
+/*
+ * Compact all zones within a node till each zone's fragmentation score
+ * reaches within proactive compaction thresholds (as determined by the
+ * proactiveness tunable).
+ *
+ * It is possible that the function returns before reaching score targets
+ * due to various back-off conditions, such as, contention on per-node or
+ * per-zone locks.
+ */
+static void proactive_compact_node(pg_data_t *pgdat)
+{
+	int zoneid;
+	struct zone *zone;
+	struct compact_control cc =3D {
+		.order =3D -1,
+		.mode =3D MIGRATE_SYNC_LIGHT,
+		.ignore_skip_hint =3D true,
+		.whole_zone =3D true,
+		.gfp_mask =3D GFP_KERNEL,
+		.proactive_compaction =3D true,
+	};
+
+	for (zoneid =3D 0; zoneid < MAX_NR_ZONES; zoneid++) {
+		zone =3D &pgdat->node_zones[zoneid];
+		if (!populated_zone(zone))
+			continue;
+
+		cc.zone =3D zone;
+
+		compact_zone(&cc, NULL);
+
+		VM_BUG_ON(!list_empty(&cc.freepages));
+		VM_BUG_ON(!list_empty(&cc.migratepages));
+	}
+}
=20
 /* Compact all zones within a node */
 static void compact_node(int nid)
@@ -2457,6 +2600,13 @@ static void compact_nodes(void)
 int sysctl_compact_memory;
=20
 /*
+ * Tunable for proactive compaction. It determines how
+ * aggressively the kernel should compact memory in the
+ * background. It takes values in the range [0, 100].
+ */
+int __read_mostly sysctl_compaction_proactiveness =3D 20;
+
+/*
  * This is the entry point for compacting all nodes via
  * /proc/sys/vm/compact_memory
  */
@@ -2635,6 +2785,7 @@ static int kcompactd(void *p)
 {
 	pg_data_t *pgdat =3D (pg_data_t*)p;
 	struct task_struct *tsk =3D current;
+	unsigned int proactive_defer =3D 0;
=20
 	const struct cpumask *cpumask =3D cpumask_of_node(pgdat->node_id);
=20
@@ -2650,12 +2801,34 @@ static int kcompactd(void *p)
 		unsigned long pflags;
=20
 		trace_mm_compaction_kcompactd_sleep(pgdat->node_id);
-		wait_event_freezable(pgdat->kcompactd_wait,
-				kcompactd_work_requested(pgdat));
+		if (wait_event_freezable_timeout(pgdat->kcompactd_wait,
+			kcompactd_work_requested(pgdat),
+			msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC))) {
+
+			psi_memstall_enter(&pflags);
+			kcompactd_do_work(pgdat);
+			psi_memstall_leave(&pflags);
+			continue;
+		}
=20
-		psi_memstall_enter(&pflags);
-		kcompactd_do_work(pgdat);
-		psi_memstall_leave(&pflags);
+		/* kcompactd wait timeout */
+		if (should_proactive_compact_node(pgdat)) {
+			unsigned int prev_score, score;
+
+			if (proactive_defer) {
+				proactive_defer--;
+				continue;
+			}
+			prev_score =3D fragmentation_score_node(pgdat);
+			proactive_compact_node(pgdat);
+			score =3D fragmentation_score_node(pgdat);
+			/*
+			 * Defer proactive compaction if the fragmentation
+			 * score did not go down i.e. no progress made.
+			 */
+			proactive_defer =3D score < prev_score ?
+					0 : 1 << COMPACT_MAX_DEFER_SHIFT;
+		}
 	}
=20
 	return 0;
--- a/mm/internal.h~mm-proactive-compaction
+++ a/mm/internal.h
@@ -239,6 +239,7 @@ struct compact_control {
 	bool no_set_skip_hint;		/* Don't mark blocks for skipping */
 	bool ignore_block_suitable;	/* Scan blocks considered unsuitable */
 	bool direct_compaction;		/* False from kcompactd or /proc/... */
+	bool proactive_compaction;	/* kcompactd proactive compaction */
 	bool whole_zone;		/* Whole zone should/has been scanned */
 	bool contended;			/* Signal lock or sched contention */
 	bool rescan;			/* Rescanning the same pageblock */
--- a/mm/vmstat.c~mm-proactive-compaction
+++ a/mm/vmstat.c
@@ -1074,6 +1074,24 @@ static int __fragmentation_index(unsigne
 	return 1000 - div_u64( (1000+(div_u64(info->free_pages * 1000ULL, request=
ed))), info->free_blocks_total);
 }
=20
+/*
+ * Calculates external fragmentation within a zone wrt the given order.
+ * It is defined as the percentage of pages found in blocks of size
+ * less than 1 << order. It returns values in range [0, 100].
+ */
+int extfrag_for_order(struct zone *zone, unsigned int order)
+{
+	struct contig_page_info info;
+
+	fill_contig_page_info(zone, order, &info);
+	if (info.free_pages =3D=3D 0)
+		return 0;
+
+	return div_u64((info.free_pages -
+			(info.free_blocks_suitable << order)) * 100,
+			info.free_pages);
+}
+
 /* Same as __fragmentation index but allocs contig_page_info on stack */
 int fragmentation_index(struct zone *zone, unsigned int order)
 {
_

Patches currently in -mm which might be from nigupta@nvidia.com are

mm-proactive-compaction.patch
