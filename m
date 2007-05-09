From: akpm@linux-foundation.org
Subject: - slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:13 -0700
Message-ID: <200705092148.l49LmDTJ002563@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287AbXEIVsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: include lifetime stats and sets of cpus / nodes in tracking output
has been removed from the -mm tree.  Its filename was
     slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: include lifetime stats and sets of cpus / nodes in tracking output
From: Christoph Lameter <clameter@sgi.com>

We have information about how long an object existed and about the nodes and
cpus where the allocations and frees took place.  Add that information to the
tracking output in /sys/slab/xx/alloc_calls and /sys/slab/free_calls

This will then enable slabinfo to output nice reports like this:

christoph@qirst:~/slub$ ./slabinfo kmalloc-128

Slabcache: kmalloc-128           Aliases:  0 Order :  0

Sizes (bytes)     Slabs              Debug                Memory
------------------------------------------------------------------------
Object :     128  Total  :      12   Sanity Checks : On   Total:   49152
SlabObj:     200  Full   :       7   Redzoning     : On   Used :   24832
SlabSiz:    4096  Partial:       4   Poisoning     : On   Loss :   24320
Loss   :      72  CpuSlab:       1   Tracking      : On   Lalig:   13968
Align  :       8  Objects:      20   Tracing       : Off  Lpadd:    1152

kmalloc-128 has no kmem_cache operations

kmalloc-128: Kernel object allocation
-----------------------------------------------------------------------
      6 param_sysfs_setup+0x71/0x130 age=284512/284512/284512 pid=1 nodes=0-1,3
     11 percpu_populate+0x39/0x80 age=283914/284428/284512 pid=1 nodes=0
     21 __register_chrdev_region+0x31/0x170 age=282896/284347/284473 pid=1-1705 nodes=0-2
      1 sys_inotify_init+0x76/0x1c0 age=283423 pid=1004 nodes=0
     19 as_get_io_context+0x32/0xd0 age=6/247567/283988 pid=1-11782 nodes=0,2
     10 ida_pre_get+0x4a/0x80 age=277666/283773/284526 pid=0-2177 nodes=0,2
     24 kobject_kset_add_dir+0x37/0xb0 age=282727/283860/284472 pid=1-1723 nodes=0-2
      1 acpi_ds_build_internal_buffer_obj+0xd3/0x11d age=284508 pid=1 nodes=0
     24 con_insert_unipair+0xd7/0x110 age=284438/284438/284438 pid=1 nodes=0,2
      1 uart_open+0x2d2/0x4b0 age=283896 pid=1 nodes=0
     26 dma_pool_create+0x73/0x1a0 age=282762/282833/282916 pid=1705-1723 nodes=0
      1 neigh_table_init_no_netlink+0xd2/0x210 age=284461 pid=1 nodes=0
      2 neigh_parms_alloc+0x2b/0xe0 age=284410/284411/284412 pid=1 nodes=2
      2 neigh_resolve_output+0x1e1/0x280 age=276289/276291/276293 pid=0-2443 nodes=0
      1 netlink_kernel_create+0x90/0x170 age=284472 pid=1 nodes=0
      4 xt_alloc_table_info+0x39/0xf0 age=283958/283958/283959 pid=1 nodes=1
      3 fn_hash_insert+0x473/0x720 age=277653/277661/277666 pid=2177-2185 nodes=0
      1 get_mtrr_state+0x285/0x2a0 age=284526 pid=0 nodes=0
      1 cacheinfo_cpu_callback+0x26d/0x3e0 age=284458 pid=1 nodes=0
     29 kernel_param_sysfs_setup+0x25/0x90 age=284511/284511/284512 pid=1 nodes=0-1,3
      5 process_zones+0x5e/0x170 age=284546/284546/284546 pid=0 nodes=0
      1 drm_core_init+0x48/0x160 age=284421 pid=1 nodes=2

kmalloc-128: Kernel object freeing
------------------------------------------------------------------------
    163 <not-available> age=4295176847 pid=0 nodes=0-3
      1 __vunmap+0x6e/0xf0 age=282907 pid=1723 nodes=0
     28 free_as_io_context+0x12/0x90 age=9243/262197/283474 pid=42-11754 nodes=0
      1 acpi_get_object_info+0x1b7/0x1d4 age=284475 pid=1 nodes=0
      1 do_acpi_find_child+0x45/0x4e age=284475 pid=1 nodes=0

NUMA nodes           :    0    1    2    3
------------------------------------------
All slabs                 7    2    2    1
Partial slabs             2    2    0    0

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   96 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 81 insertions(+), 15 deletions(-)

diff -puN mm/slub.c~slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output mm/slub.c
--- a/mm/slub.c~slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output
+++ a/mm/slub.c
@@ -1586,13 +1586,16 @@ static int calculate_order(int size)
 			order < MAX_ORDER; order++) {
 		unsigned long slab_size = PAGE_SIZE << order;
 
-		if (slub_max_order > order &&
+		if (order < slub_max_order &&
 				slab_size < slub_min_objects * size)
 			continue;
 
 		if (slab_size < size)
 			continue;
 
+		if (order >= slub_max_order)
+			break;
+
 		rem = slab_size % size;
 
 		if (rem <= slab_size / 8)
@@ -2751,6 +2754,13 @@ static void resiliency_test(void) {};
 struct location {
 	unsigned long count;
 	void *addr;
+	long long sum_time;
+	long min_time;
+	long max_time;
+	long min_pid;
+	long max_pid;
+	cpumask_t cpus;
+	nodemask_t nodes;
 };
 
 struct loc_track {
@@ -2791,11 +2801,12 @@ static int alloc_loc_track(struct loc_tr
 }
 
 static int add_location(struct loc_track *t, struct kmem_cache *s,
-						void *addr)
+				const struct track *track)
 {
 	long start, end, pos;
 	struct location *l;
 	void *caddr;
+	unsigned long age = jiffies - track->when;
 
 	start = -1;
 	end = t->count;
@@ -2811,12 +2822,29 @@ static int add_location(struct loc_track
 			break;
 
 		caddr = t->loc[pos].addr;
-		if (addr == caddr) {
-			t->loc[pos].count++;
+		if (track->addr == caddr) {
+
+			l = &t->loc[pos];
+			l->count++;
+			if (track->when) {
+				l->sum_time += age;
+				if (age < l->min_time)
+					l->min_time = age;
+				if (age > l->max_time)
+					l->max_time = age;
+
+				if (track->pid < l->min_pid)
+					l->min_pid = track->pid;
+				if (track->pid > l->max_pid)
+					l->max_pid = track->pid;
+
+				cpu_set(track->cpu, l->cpus);
+			}
+			node_set(page_to_nid(virt_to_page(track)), l->nodes);
 			return 1;
 		}
 
-		if (addr < caddr)
+		if (track->addr < caddr)
 			end = pos;
 		else
 			start = pos;
@@ -2834,7 +2862,16 @@ static int add_location(struct loc_track
 			(t->count - pos) * sizeof(struct location));
 	t->count++;
 	l->count = 1;
-	l->addr = addr;
+	l->addr = track->addr;
+	l->sum_time = age;
+	l->min_time = age;
+	l->max_time = age;
+	l->min_pid = track->pid;
+	l->max_pid = track->pid;
+	cpus_clear(l->cpus);
+	cpu_set(track->cpu, l->cpus);
+	nodes_clear(l->nodes);
+	node_set(page_to_nid(virt_to_page(track)), l->nodes);
 	return 1;
 }
 
@@ -2850,11 +2887,8 @@ static void process_slab(struct loc_trac
 		set_bit(slab_index(p, s, addr), map);
 
 	for_each_object(p, s, addr)
-		if (!test_bit(slab_index(p, s, addr), map)) {
-			void *addr = get_track(s, p, alloc)->addr;
-
-			add_location(t, s, addr);
-		}
+		if (!test_bit(slab_index(p, s, addr), map))
+			add_location(t, s, get_track(s, p, alloc));
 }
 
 static int list_locations(struct kmem_cache *s, char *buf,
@@ -2888,15 +2922,47 @@ static int list_locations(struct kmem_ca
 	}
 
 	for (i = 0; i < t.count; i++) {
-		void *addr = t.loc[i].addr;
+		struct location *l = &t.loc[i];
 
 		if (n > PAGE_SIZE - 100)
 			break;
-		n += sprintf(buf + n, "%7ld ", t.loc[i].count);
-		if (addr)
-			n += sprint_symbol(buf + n, (unsigned long)t.loc[i].addr);
+		n += sprintf(buf + n, "%7ld ", l->count);
+
+		if (l->addr)
+			n += sprint_symbol(buf + n, (unsigned long)l->addr);
 		else
 			n += sprintf(buf + n, "<not-available>");
+
+		if (l->sum_time != l->min_time) {
+			unsigned long remainder;
+
+			n += sprintf(buf + n, " age=%ld/%ld/%ld",
+			l->min_time,
+			div_long_long_rem(l->sum_time, l->count, &remainder),
+			l->max_time);
+		} else
+			n += sprintf(buf + n, " age=%ld",
+				l->min_time);
+
+		if (l->min_pid != l->max_pid)
+			n += sprintf(buf + n, " pid=%ld-%ld",
+				l->min_pid, l->max_pid);
+		else
+			n += sprintf(buf + n, " pid=%ld",
+				l->min_pid);
+
+		if (num_online_cpus() > 1 && !cpus_empty(l->cpus)) {
+			n += sprintf(buf + n, " cpus=");
+			n += cpulist_scnprintf(buf + n, PAGE_SIZE - n - 50,
+					l->cpus);
+		}
+
+		if (num_online_nodes() > 1 && !nodes_empty(l->nodes)) {
+			n += sprintf(buf + n, " nodes=");
+			n += nodelist_scnprintf(buf + n, PAGE_SIZE - n - 50,
+					l->nodes);
+		}
+
 		n += sprintf(buf + n, "\n");
 	}
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
