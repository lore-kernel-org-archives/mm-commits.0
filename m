From: akpm@linux-foundation.org
Subject: [merged] mm-vmstat-fix-up-zone-state-accounting.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:31:15 -0700
Message-ID: <533f0883.g1cguttvIxnvlzjf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaDDTbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, tj@kernel.org, semenzato@google.com, rmallon@gmail.com, riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com, minchan.kim@gmail.com, mgorman@suse.de, metin@citusdata.com, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz, hughd@google.com, hch@infradead.org, gthelen@google.com, david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-vmstat-fix-up-zone-state-accounting.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,bob.liu@oracle.com,david@fromorbit.com,gthelen@google.com,hch@infradead.org,hughd@google.com,jack@suse.cz,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,metin@citusdata.com,mgorman@suse.de,minchan.kim@gmail.com,ozgun@citusdata.com,peterz@infradead.org,riel@redhat.com,rmallon@gmail.com,semenzato@google.com,tj@kernel.org,vbabka@suse.cz,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:15 -0700


The patch titled
     Subject: mm: vmstat: fix UP zone state accounting
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-up-zone-state-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmstat: fix UP zone state accounting

	Summary

The VM maintains cached filesystem pages on two types of lists.  One list
holds the pages recently faulted into the cache, the other list holds
pages that have been referenced repeatedly on that first list.  The idea
is to prefer reclaiming young pages over those that have shown to benefit
from caching in the past.  We call the recently used list "inactive list"
and the frequently used list "active list".

Currently, the VM aims for a 1:1 ratio between the lists, which is the
"perfect" trade-off between the ability to *protect* frequently used pages
and the ability to *detect* frequently used pages.  This means that
working set changes bigger than half of cache memory go undetected and
thrash indefinitely, whereas working sets bigger than half of cache memory
are unprotected against used-once streams that don't even need caching.

This happens on file servers and media streaming servers, where the
popular files and file sections change over time.  Even though the
individual files might be smaller than half of memory, concurrent access
to many of them may still result in their inter-reference distance being
greater than half of memory.  It's also been reported as a problem on
database workloads that switch back and forth between tables that are
bigger than half of memory.  In these cases the VM never recognizes the
new working set and will for the remainder of the workload thrash disk
data which could easily live in memory.

Historically, every reclaim scan of the inactive list also took a smaller
number of pages from the tail of the active list and moved them to the
head of the inactive list.  This model gave established working sets more
gracetime in the face of temporary use-once streams, but ultimately was
not significantly better than a FIFO policy and still thrashed cache based
on eviction speed, rather than actual demand for cache.

This series solves the problem by maintaining a history of pages evicted
from the inactive list, enabling the VM to detect frequently used pages
regardless of inactive list size and facilitate working set transitions.

	Tests

The reported database workload is easily demonstrated on a 8G machine with
two filesets a 6G.  This fio workload operates on one set first, then
switches to the other.  The VM should obviously always cache the set that
the workload is currently using.

This test is based on a problem encountered by Citus Data customers:
http://citusdata.com/blog/72-linux-memory-manager-and-your-big-data

unpatched:
db1: READ: io=98304MB, aggrb=885559KB/s, minb=885559KB/s, maxb=885559KB/s, mint= 113672msec, maxt= 113672msec
db2: READ: io=98304MB, aggrb= 66169KB/s, minb= 66169KB/s, maxb= 66169KB/s, mint=1521302msec, maxt=1521302msec
sdb: ios=835750/4, merge=2/1, ticks=4659739/60016, in_queue=4719203, util=98.92%

real    27m15.541s
user    0m19.059s
sys     0m51.459s

patched:
db1: READ: io=98304MB, aggrb=877783KB/s, minb=877783KB/s, maxb=877783KB/s, mint=114679msec, maxt=114679msec
db2: READ: io=98304MB, aggrb=397449KB/s, minb=397449KB/s, maxb=397449KB/s, mint=253273msec, maxt=253273msec
sdb: ios=170587/4, merge=2/1, ticks=954910/61123, in_queue=1015923, util=90.40%

real    6m8.630s
user    0m14.714s
sys     0m31.233s

As can be seen, the unpatched kernel simply never adapts to the workingset
change and db2 is stuck indefinitely with secondary storage speed.  The
patched kernel needs 2-3 iterations over db2 before it replaces db1 and
reaches full memory speed.  Given the unbounded negative affect of the
existing VM behavior, these patches should be considered correctness fixes
rather than performance optimizations.

Another test resembles a fileserver or streaming server workload, where
data in excess of memory size is accessed at different frequencies.  There
is very hot data accessed at a high frequency.  Machines should be fitted
so that the hot set of such a workload can be fully cached or all bets are
off.  Then there is a very big (compared to available memory) set of data
that is used-once or at a very low frequency; this is what drives the
inactive list and does not really benefit from caching.  Lastly, there is
a big set of warm data in between that is accessed at medium frequencies
and benefits from caching the pages between the first and last streamer of
each burst.

unpatched:
 hot: READ: io=128000MB, aggrb=160693KB/s, minb=160693KB/s, maxb=160693KB/s, mint=815665msec, maxt=815665msec
warm: READ: io= 81920MB, aggrb=109853KB/s, minb= 27463KB/s, maxb= 29244KB/s, mint=717110msec, maxt=763617msec
cold: READ: io= 30720MB, aggrb= 35245KB/s, minb= 35245KB/s, maxb= 35245KB/s, mint=892530msec, maxt=892530msec
 sdb: ios=797960/4, merge=11763/1, ticks=4307910/796, in_queue=4308380, util=100.00%

patched:
 hot: READ: io=128000MB, aggrb=160678KB/s, minb=160678KB/s, maxb=160678KB/s, mint=815740msec, maxt=815740msec
warm: READ: io= 81920MB, aggrb=147747KB/s, minb= 36936KB/s, maxb= 40960KB/s, mint=512000msec, maxt=567767msec
cold: READ: io= 30720MB, aggrb= 40960KB/s, minb= 40960KB/s, maxb= 40960KB/s, mint=768000msec, maxt=768000msec
 sdb: ios=596514/4, merge=9341/1, ticks=2395362/997, in_queue=2396484, util=79.18%

In both kernels, the hot set is propagated to the active list and then
served from cache.

In both kernels, the beginning of the warm set is propagated to the active
list as well, but in the unpatched case the active list eventually takes
up half of memory and no new pages from the warm set get activated,
despite repeated access, and despite most of the active list soon being
stale.  The patched kernel on the other hand detects the thrashing and
manages to keep this cache window rolling through the data set.  This
frees up enough IO bandwidth that the cold set is served at full speed as
well and disk utilization even drops by 20%.

For reference, this same test was performed with the traditional demotion
mechanism, where deactivation is coupled to inactive list reclaim. 
However, this had the same outcome as the unpatched kernel: while the warm
set does indeed get activated continuously, it is forced out of the active
list by inactive list pressure, which is dictated primarily by the
unrelated cold set.  The warm set is evicted before subsequent streamers
can benefit from it, even though there would be enough space available to
cache the pages of interest.

	Costs

Page reclaim used to shrink the radix trees but now the tree nodes are
reused for shadow entries, where the cost depends heavily on the page
cache access patterns.  However, with workloads that maintain spatial or
temporal locality, the shadow entries are either refaulted quickly or
reclaimed along with the inode object itself.  Workloads that will
experience a memory cost increase are those that don't really benefit from
caching in the first place.

A more predictable alternative would be a fixed-cost separate pool of
shadow entries, but this would incur relatively higher memory cost for
well-behaved workloads at the benefit of cornercases.  It would also make
the shadow entry lookup more costly compared to storing them directly in
the cache structure.

	Future

To simplify the merging process, this patch set is implementing thrash
detection on a global per-zone level only for now, but the design is such
that it can be extended to memory cgroups as well.  All we need to do is
store the unique cgroup ID along the node and zone identifier inside the
eviction cookie to identify the lruvec.

Right now we have a fixed ratio (50:50) between inactive and active list
but we already have complaints about working sets exceeding half of memory
being pushed out of the cache by simple streaming in the background. 
Ultimately, we want to adjust this ratio and allow for a much smaller
inactive list.  These patches are an essential step in this direction
because they decouple the VMs ability to detect working set changes from
the inactive list size.  This would allow us to base the inactive list
size on the combined readahead window size for example and potentially
protect a much bigger working set.

It's also a big step towards activating pages with a reuse distance larger
than memory, as long as they are the most frequently used pages in the
workload.  This will require knowing more about the access frequency of
active pages than what we measure right now, so it's also deferred in this
series.

Another possibility of having thrashing information would be to revisit
the idea of local reclaim in the form of zero-config memory control
groups.  Instead of having allocating tasks go straight to global reclaim,
they could try to reclaim the pages in the memcg they are part of first as
long as the group is not thrashing.  This would allow a user to drop e.g. 
a back-up job in an otherwise unconfigured memcg and it would only inflate
(and possibly do global reclaim) until it has enough memory to do proper
readahead.  But once it reaches that point and stops thrashing it would
just recycle its own used-once pages without kicking out the cache of any
other tasks in the system more than necessary.



This patch (of 10):

Fengguang Wu's build testing spotted problems with inc_zone_state()
and dec_zone_state() on UP configurations in out-of-tree patches.

inc_zone_state() is declared but not defined, dec_zone_state() is
missing entirely.

Just like with *_zone_page_state(), they can be defined like their
preemption-unsafe counterparts on UP.

[akpm@linux-foundation.org: make it build]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Metin Doslu <metin@citusdata.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Ozgun Erdogan <ozgun@citusdata.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/vmstat.h~mm-vmstat-fix-up-zone-state-accounting include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstat-fix-up-zone-state-accounting
+++ a/include/linux/vmstat.h
@@ -187,8 +187,6 @@ extern void zone_statistics(struct zone
 #define add_zone_page_state(__z, __i, __d) mod_zone_page_state(__z, __i, __d)
 #define sub_zone_page_state(__z, __i, __d) mod_zone_page_state(__z, __i, -(__d))
 
-extern void inc_zone_state(struct zone *, enum zone_stat_item);
-
 #ifdef CONFIG_SMP
 void __mod_zone_page_state(struct zone *, enum zone_stat_item item, int);
 void __inc_zone_page_state(struct page *, enum zone_stat_item);
@@ -230,18 +228,18 @@ static inline void __inc_zone_state(stru
 	atomic_long_inc(&vm_stat[item]);
 }
 
-static inline void __inc_zone_page_state(struct page *page,
-			enum zone_stat_item item)
-{
-	__inc_zone_state(page_zone(page), item);
-}
-
 static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
 	atomic_long_dec(&zone->vm_stat[item]);
 	atomic_long_dec(&vm_stat[item]);
 }
 
+static inline void __inc_zone_page_state(struct page *page,
+			enum zone_stat_item item)
+{
+	__inc_zone_state(page_zone(page), item);
+}
+
 static inline void __dec_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
@@ -256,6 +254,9 @@ static inline void __dec_zone_page_state
 #define dec_zone_page_state __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
+#define inc_zone_state __inc_zone_state
+#define dec_zone_state __dec_zone_state
+
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm-fix.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
debugging-keep-track-of-page-owners.patch

