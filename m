From: akpm@linux-foundation.org
Subject: + memcg-debugging-facility-to-access-dangling-memcgs.patch added to -mm tree
Date: Mon, 03 Dec 2012 15:44:31 -0800
Message-ID: <20121203234431.8F6D182004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:60574 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2LCXod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 18:44:33 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so418800ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 15:44:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: debugging facility to access dangling memcgs
has been added to the -mm tree.  Its filename is
     memcg-debugging-facility-to-access-dangling-memcgs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
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
@@ -70,6 +70,7 @@ Brief summary of control files.
  memory.move_charge_at_immigrate # set/show controls of moving charges
  memory.oom_control		 # set/show oom controls.
  memory.numa_stat		 # show the number of memory usage per numa node
+ memory.dangling_memcgs          # show debugging information about dangling groups
 
  memory.kmem.limit_in_bytes      # set/show hard limit for kernel memory
  memory.kmem.usage_in_bytes      # show current kernel memory allocation
@@ -577,6 +578,21 @@ unevictable=<total anon pages> N0=<node 
 
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
@@ -896,6 +896,23 @@ config MEMCG_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
+config MEMCG_DEBUG_ASYNC_DESTROY
+	bool "Memory Resource Controller Debug assynchronous object destruction"
+	depends on MEMCG_KMEM || MEMCG_SWAP
+	default n
+	help
+	  When a memcg is destroyed, the memory
+	  consumed by it may not be immediately freed. This is because when some
+	  extensions are used, such as swap or kernel memory, objects can
+	  outlive the group and hold a reference to it.
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
@@ -313,14 +313,31 @@ struct mem_cgroup {
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
@@ -351,6 +368,55 @@ struct mem_cgroup {
 #endif
 };
 
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
@@ -4890,6 +4956,107 @@ static ssize_t mem_cgroup_read(struct cg
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
@@ -5853,6 +6020,14 @@ static struct cftype mem_cgroup_files[] 
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
 
@@ -5972,6 +6147,8 @@ static void free_work(struct work_struct
 	struct mem_cgroup *memcg;
 
 	memcg = container_of(work, struct mem_cgroup, work_freeing);
+
+	memcg_dangling_free(memcg);
 	__mem_cgroup_free(memcg);
 }
 
@@ -6161,6 +6338,7 @@ static void mem_cgroup_css_free(struct c
 
 	kmem_cgroup_destroy(memcg);
 
+	memcg_dangling_add(memcg);
 	mem_cgroup_put(memcg);
 }
 
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears-simplify-ida-initialization.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch
res_counter-delete-res_counter_write.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

