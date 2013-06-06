From: akpm@linux-foundation.org
Subject: [to-be-updated]
 memcg-debugging-facility-to-access-dangling-memcgs.patch removed from -mm
 tree
Date: Thu, 06 Jun 2013 12:34:17 -0700
Message-ID: <51b0e439.wzs7EhsCJSQOH4Ni%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3FFTeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@parallels.com

Subject: [to-be-updated] memcg-debugging-facility-to-access-dangling-memcgs.patch removed from -mm tree
To: glommer@parallels.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:34:17 -0700


The patch titled
     Subject: memcg: debugging facility to access dangling memcgs
has been removed from the -mm tree.  Its filename was
     memcg-debugging-facility-to-access-dangling-memcgs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: debugging facility to access dangling memcgs

If memcg is tracking anything other than plain user memory (swap, tcp buf
mem, or slab memory), it is possible - and normal - that a reference will
be held by the group after it is dead.  Still, for developers, it would be
extremely useful to be able to query about those states during debugging.

This patch provides a debugging facility in the root memcg, so we can
inspect which memcgs still have pending objects, and what is the cause of
this state.

[akpm@linux-foundation.org: fix up Kconfig text]
Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   16 ++
 init/Kconfig                     |   17 ++
 mm/memcontrol.c                  |  192 +++++++++++++++++++++++++++--
 3 files changed, 218 insertions(+), 7 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-debugging-facility-to-access-dangling-memcgs Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-debugging-facility-to-access-dangling-memcgs
+++ a/Documentation/cgroups/memory.txt
@@ -72,6 +72,7 @@ Brief summary of control files.
  memory.move_charge_at_immigrate # set/show controls of moving charges
  memory.oom_control		 # set/show oom controls.
  memory.numa_stat		 # show the number of memory usage per numa node
+ memory.dangling_memcgs          # show debugging information about dangling groups
 
  memory.kmem.limit_in_bytes      # set/show hard limit for kernel memory
  memory.kmem.usage_in_bytes      # show current kernel memory allocation
@@ -581,6 +582,21 @@ unevictable=<total anon pages> N0=<node
 
 And we have total = file + anon + unevictable.
 
+5.7 dangling_memcgs
+
+This file will only be ever present in the root cgroup, if the option
+CONFIG_MEMCG_DEBUG_ASYNC_DESTROY is set. When a memcg is destroyed, the memory
+consumed by it may not be immediately freed. This is because when some
+extensions are used, such as swap or kernel memory, objects can outlive the
+group and hold a reference to it.
+
+If this is the case, the dangling_memcgs file will show information about what
+are the memcgs still alive, and which references are still preventing it to be
+freed. There is nothing wrong with that, but it is very useful when debugging,
+to know where this memory is being held. This is a developer-oriented debugging
+facility only, and no guarantees of interface stability will be given. The file
+is read-only, and has the sole purpose of displaying information.
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
diff -puN init/Kconfig~memcg-debugging-facility-to-access-dangling-memcgs init/Kconfig
--- a/init/Kconfig~memcg-debugging-facility-to-access-dangling-memcgs
+++ a/init/Kconfig
@@ -940,6 +940,23 @@ config MEMCG_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
+config MEMCG_DEBUG_ASYNC_DESTROY
+	bool "Memory Resource Controller Debug asynchronous object destruction"
+	depends on MEMCG_KMEM || MEMCG_SWAP
+	default n
+	help
+	  When a memcg is destroyed, the memory consumed by it may not be
+	  immediately freed. This is because when some extensions are used, such
+	  as swap or kernel memory, objects can outlive the group and hold a
+	  reference to it.
+
+	  If this is the case, the dangling_memcgs file will show information
+	  about what are the memcgs still alive, and which references are still
+	  preventing it to be freed. There is nothing wrong with that, but it is
+	  very useful when debugging, to know where this memory is being held.
+	  This is a developer-oriented debugging facility only, and no
+	  guarantees of interface stability will be given.
+
 config CGROUP_HUGETLB
 	bool "HugeTLB Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS && HUGETLB_PAGE
diff -puN mm/memcontrol.c~memcg-debugging-facility-to-access-dangling-memcgs mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-debugging-facility-to-access-dangling-memcgs
+++ a/mm/memcontrol.c
@@ -321,14 +321,31 @@ struct mem_cgroup {
 	/* thresholds for mem+swap usage. RCU-protected */
 	struct mem_cgroup_thresholds memsw_thresholds;
 
-	/* For oom notifier event fd */
-	struct list_head oom_notify;
+	union {
+		/* For oom notifier event fd */
+		struct list_head oom_notify;
+		/*
+		 * we can only trigger an oom event if the memcg is alive.
+		 * so we will reuse this field to hook the memcg in the list
+		 * of dead memcgs.
+		 */
+		struct list_head dead;
+	};
 
-	/*
-	 * Should we move charges of a task when a task is moved into this
-	 * mem_cgroup ? And what type of charges should we move ?
-	 */
-	unsigned long 	move_charge_at_immigrate;
+	union {
+		/*
+		 * Should we move charges of a task when a task is moved into
+		 * this mem_cgroup ? And what type of charges should we move ?
+		 */
+		unsigned long move_charge_at_immigrate;
+
+		/*
+		 * We are no longer concerned about moving charges after memcg
+		 * is dead. So we will fill this up with its name, to aid
+		 * debugging.
+		 */
+		char *memcg_name;
+	};
 	/*
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
 	 */
@@ -382,6 +399,55 @@ static size_t memcg_size(void)
 		nr_node_ids * sizeof(struct mem_cgroup_per_node);
 }
 
+#ifdef CONFIG_MEMCG_DEBUG_ASYNC_DESTROY
+static LIST_HEAD(dangling_memcgs);
+static DEFINE_MUTEX(dangling_memcgs_mutex);
+
+static inline void memcg_dangling_free(struct mem_cgroup *memcg)
+{
+	mutex_lock(&dangling_memcgs_mutex);
+	list_del(&memcg->dead);
+	mutex_unlock(&dangling_memcgs_mutex);
+	free_pages((unsigned long)memcg->memcg_name, 0);
+}
+
+static inline void memcg_dangling_add(struct mem_cgroup *memcg)
+{
+	/*
+	 * cgroup.c will do page-sized allocations most of the time,
+	 * so we'll just follow the pattern. Also, __get_free_pages
+	 * is a better interface than kmalloc for us here, because
+	 * we'd like this memory to be always billed to the root cgroup,
+	 * not to the process removing the memcg. While kmalloc would
+	 * require us to wrap it into memcg_stop/resume_kmem_account,
+	 * with __get_free_pages we just don't pass the memcg flag.
+	 */
+	memcg->memcg_name = (char *)__get_free_pages(GFP_KERNEL, 0);
+
+	/*
+	 * we will, in general, just ignore failures. No need to go crazy,
+	 * being this just a debugging interface. It is nice to copy a memcg
+	 * name over, but if we (unlikely) can't, just the address will do
+	 */
+	if (!memcg->memcg_name)
+		goto add_list;
+
+	if (cgroup_path(memcg->css.cgroup, memcg->memcg_name, PAGE_SIZE) < 0) {
+		free_pages((unsigned long)memcg->memcg_name, 0);
+		memcg->memcg_name = NULL;
+	}
+
+add_list:
+	INIT_LIST_HEAD(&memcg->dead);
+	mutex_lock(&dangling_memcgs_mutex);
+	list_add(&memcg->dead, &dangling_memcgs);
+	mutex_unlock(&dangling_memcgs_mutex);
+}
+#else
+static inline void memcg_dangling_free(struct mem_cgroup *memcg) {}
+static inline void memcg_dangling_add(struct mem_cgroup *memcg) {}
+#endif
+
 /* internal only representation about the status of kmem accounting. */
 enum {
 	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
@@ -5127,6 +5193,107 @@ static ssize_t mem_cgroup_read(struct cg
 	return simple_read_from_buffer(buf, nbytes, ppos, str, len);
 }
 
+#ifdef CONFIG_MEMCG_DEBUG_ASYNC_DESTROY
+static void
+mem_cgroup_dangling_swap(struct mem_cgroup *memcg, struct seq_file *m)
+{
+#ifdef CONFIG_MEMCG_SWAP
+	u64 kmem;
+	u64 memsw;
+
+	/*
+	 * kmem will also propagate here, so we are only interested in the
+	 * difference.  See comment in mem_cgroup_reparent_charges for details.
+	 *
+	 * We could save this value for later consumption by kmem reports, but
+	 * there is not a lot of problem if the figures differ slightly.
+	 */
+	kmem = res_counter_read_u64(&memcg->kmem, RES_USAGE);
+	memsw = res_counter_read_u64(&memcg->memsw, RES_USAGE) - kmem;
+	seq_printf(m, "\t%llu swap bytes\n", memsw);
+#endif
+}
+
+
+static void
+mem_cgroup_dangling_tcp(struct mem_cgroup *memcg, struct seq_file *m)
+{
+#if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
+	struct tcp_memcontrol *tcp = &memcg->tcp_mem;
+	s64 tcp_socks;
+	u64 tcp_bytes;
+
+	tcp_socks = percpu_counter_sum_positive(&tcp->tcp_sockets_allocated);
+	tcp_bytes = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_USAGE);
+	seq_printf(m, "\t%llu tcp bytes", tcp_bytes);
+	/*
+	 * if tcp_bytes == 0, tcp_socks != 0 is a bug. One more reason to print
+	 * it!
+	 */
+	if (tcp_bytes || tcp_socks)
+		seq_printf(m, ", in %lld sockets", tcp_socks);
+	seq_printf(m, "\n");
+
+#endif
+}
+
+static void
+mem_cgroup_dangling_kmem(struct mem_cgroup *memcg, struct seq_file *m)
+{
+#ifdef CONFIG_MEMCG_KMEM
+	u64 kmem;
+	struct memcg_cache_params *params;
+
+	kmem = res_counter_read_u64(&memcg->kmem, RES_USAGE);
+	seq_printf(m, "\t%llu kmem bytes", kmem);
+
+	/* list below may not be initialized, so not even try */
+	if (!kmem)
+		return;
+
+	seq_printf(m, " in caches");
+	mutex_lock(&memcg->slab_caches_mutex);
+	list_for_each_entry(params, &memcg->memcg_slab_caches, list) {
+			struct kmem_cache *s = memcg_params_to_cache(params);
+
+		seq_printf(m, " %s", s->name);
+	}
+	mutex_unlock(&memcg->slab_caches_mutex);
+	seq_printf(m, "\n");
+#endif
+}
+
+/*
+ * After a memcg is destroyed, it may still be kept around in memory.
+ * Currently, the two main reasons for it are swap entries, and kernel memory.
+ * Because they will be freed assynchronously, they will pin the memcg structure
+ * and its resources until the last reference goes away.
+ *
+ * This root-only file will show information about which users
+ */
+static int mem_cgroup_dangling_read(struct cgroup *cont, struct cftype *cft,
+					struct seq_file *m)
+{
+	struct mem_cgroup *memcg;
+
+	mutex_lock(&dangling_memcgs_mutex);
+
+	list_for_each_entry(memcg, &dangling_memcgs, dead) {
+		if (memcg->memcg_name)
+			seq_printf(m, "%s:\n", memcg->memcg_name);
+		else
+			seq_printf(m, "%p (name lost):\n", memcg);
+
+		mem_cgroup_dangling_swap(memcg, m);
+		mem_cgroup_dangling_tcp(memcg, m);
+		mem_cgroup_dangling_kmem(memcg, m);
+	}
+
+	mutex_unlock(&dangling_memcgs_mutex);
+	return 0;
+}
+#endif
+
 static int memcg_update_kmem_limit(struct cgroup *cont, u64 val)
 {
 	int ret = -EINVAL;
@@ -6028,6 +6195,14 @@ static struct cftype mem_cgroup_files[]
 	},
 #endif
 #endif
+
+#ifdef CONFIG_MEMCG_DEBUG_ASYNC_DESTROY
+	{
+		.name = "dangling_memcgs",
+		.read_seq_string = mem_cgroup_dangling_read,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+#endif
 	{ },	/* terminate */
 };
 
@@ -6177,6 +6352,8 @@ static void free_work(struct work_struct
 	struct mem_cgroup *memcg;
 
 	memcg = container_of(work, struct mem_cgroup, work_freeing);
+
+	memcg_dangling_free(memcg);
 	__mem_cgroup_free(memcg);
 }
 
@@ -6371,6 +6548,7 @@ static void mem_cgroup_css_free(struct c
 
 	kmem_cgroup_destroy(memcg);
 
+	memcg_dangling_add(memcg);
 	mem_cgroup_put(memcg);
 }
 
_

Patches currently in -mm which might be from glommer@parallels.com are

memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator.patch
clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking-call-mmu-notifiers-when-write-protecting-ptes.patch
pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch
mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch
vmpressure-in-kernel-notifications.patch

