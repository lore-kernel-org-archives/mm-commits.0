From: akpm@linux-foundation.org
Subject: [merged] memcg-kmem-accounting-basic-infrastructure.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:10 -0800
Message-ID: <20121219204010.E1F0A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50359 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2LSUkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:13 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so277839vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: kmem accounting basic infrastructure
has been removed from the -mm tree.  Its filename was
     memcg-kmem-accounting-basic-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: kmem accounting basic infrastructure

Add the basic infrastructure for the accounting of kernel memory.  To
control that, the following files are created:

 * memory.kmem.usage_in_bytes
 * memory.kmem.limit_in_bytes
 * memory.kmem.failcnt
 * memory.kmem.max_usage_in_bytes

They have the same meaning of their user memory counterparts.  They
reflect the state of the "kmem" res_counter.

Per cgroup kmem memory accounting is not enabled until a limit is set for
the group.  Once the limit is set the accounting cannot be disabled for
that group.  This means that after the patch is applied, no behavioral
changes exists for whoever is still using memcg to control their memory
usage, until memory.kmem.limit_in_bytes is set for the first time.

We always account to both user and kernel resource_counters.  This
effectively means that an independent kernel limit is in place when the
limit is set to a lower value than the user memory.  A equal or higher
value means that the user limit will always hit first, meaning that kmem
is effectively unlimited.

People who want to track kernel memory but not limit it, can set this
limit to a very high number (like RESOURCE_MAX - 1page - that no one will
ever hit, or equal to the user memory)

[akpm@linux-foundation.org: MEMCG_MMEM only works with slab and slub]
Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig    |    1 
 mm/memcontrol.c |  126 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 124 insertions(+), 3 deletions(-)

diff -puN init/Kconfig~memcg-kmem-accounting-basic-infrastructure init/Kconfig
--- a/init/Kconfig~memcg-kmem-accounting-basic-infrastructure
+++ a/init/Kconfig
@@ -882,6 +882,7 @@ config MEMCG_SWAP_ENABLED
 config MEMCG_KMEM
 	bool "Memory Resource Controller Kernel Memory accounting (EXPERIMENTAL)"
 	depends on MEMCG && EXPERIMENTAL
+	depends on SLUB || SLAB
 	default n
 	help
 	  The Kernel Memory extension for Memory Resource Controller can limit
diff -puN mm/memcontrol.c~memcg-kmem-accounting-basic-infrastructure mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-kmem-accounting-basic-infrastructure
+++ a/mm/memcontrol.c
@@ -268,6 +268,10 @@ struct mem_cgroup {
 	};
 
 	/*
+	 * the counter to account for kernel memory usage.
+	 */
+	struct res_counter kmem;
+	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
 	 */
@@ -282,6 +286,7 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
+	unsigned long kmem_account_flags; /* See KMEM_ACCOUNTED_*, below */
 
 	bool		oom_lock;
 	atomic_t	under_oom;
@@ -334,6 +339,20 @@ struct mem_cgroup {
 #endif
 };
 
+/* internal only representation about the status of kmem accounting. */
+enum {
+	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
+};
+
+#define KMEM_ACCOUNTED_MASK (1 << KMEM_ACCOUNTED_ACTIVE)
+
+#ifdef CONFIG_MEMCG_KMEM
+static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
+{
+	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
+}
+#endif
+
 /* Stuffs for move charges at task migration. */
 /*
  * Types of charges to be moved. "move_charge_at_immitgrate" is treated as a
@@ -392,6 +411,7 @@ enum res_type {
 	_MEM,
 	_MEMSWAP,
 	_OOM_TYPE,
+	_KMEM,
 };
 
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
@@ -1456,6 +1476,10 @@ done:
 		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
+	printk(KERN_INFO "kmem: usage %llukB, limit %llukB, failcnt %llu\n",
+		res_counter_read_u64(&memcg->kmem, RES_USAGE) >> 10,
+		res_counter_read_u64(&memcg->kmem, RES_LIMIT) >> 10,
+		res_counter_read_u64(&memcg->kmem, RES_FAILCNT));
 }
 
 /*
@@ -3977,6 +4001,9 @@ static ssize_t mem_cgroup_read(struct cg
 		else
 			val = res_counter_read_u64(&memcg->memsw, name);
 		break;
+	case _KMEM:
+		val = res_counter_read_u64(&memcg->kmem, name);
+		break;
 	default:
 		BUG();
 	}
@@ -3984,6 +4011,59 @@ static ssize_t mem_cgroup_read(struct cg
 	len = scnprintf(str, sizeof(str), "%llu\n", (unsigned long long)val);
 	return simple_read_from_buffer(buf, nbytes, ppos, str, len);
 }
+
+static int memcg_update_kmem_limit(struct cgroup *cont, u64 val)
+{
+	int ret = -EINVAL;
+#ifdef CONFIG_MEMCG_KMEM
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	/*
+	 * For simplicity, we won't allow this to be disabled.  It also can't
+	 * be changed if the cgroup has children already, or if tasks had
+	 * already joined.
+	 *
+	 * If tasks join before we set the limit, a person looking at
+	 * kmem.usage_in_bytes will have no way to determine when it took
+	 * place, which makes the value quite meaningless.
+	 *
+	 * After it first became limited, changes in the value of the limit are
+	 * of course permitted.
+	 *
+	 * Taking the cgroup_lock is really offensive, but it is so far the only
+	 * way to guarantee that no children will appear. There are plenty of
+	 * other offenders, and they should all go away. Fine grained locking
+	 * is probably the way to go here. When we are fully hierarchical, we
+	 * can also get rid of the use_hierarchy check.
+	 */
+	cgroup_lock();
+	mutex_lock(&set_limit_mutex);
+	if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
+		if (cgroup_task_count(cont) || (memcg->use_hierarchy &&
+						!list_empty(&cont->children))) {
+			ret = -EBUSY;
+			goto out;
+		}
+		ret = res_counter_set_limit(&memcg->kmem, val);
+		VM_BUG_ON(ret);
+
+		memcg_kmem_set_active(memcg);
+	} else
+		ret = res_counter_set_limit(&memcg->kmem, val);
+out:
+	mutex_unlock(&set_limit_mutex);
+	cgroup_unlock();
+#endif
+	return ret;
+}
+
+static void memcg_propagate_kmem(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	if (!parent)
+		return;
+	memcg->kmem_account_flags = parent->kmem_account_flags;
+}
+
 /*
  * The user of this function is...
  * RES_LIMIT.
@@ -4015,8 +4095,12 @@ static int mem_cgroup_write(struct cgrou
 			break;
 		if (type == _MEM)
 			ret = mem_cgroup_resize_limit(memcg, val);
-		else
+		else if (type == _MEMSWAP)
 			ret = mem_cgroup_resize_memsw_limit(memcg, val);
+		else if (type == _KMEM)
+			ret = memcg_update_kmem_limit(cont, val);
+		else
+			return -EINVAL;
 		break;
 	case RES_SOFT_LIMIT:
 		ret = res_counter_memparse_write_strategy(buffer, &val);
@@ -4082,14 +4166,22 @@ static int mem_cgroup_reset(struct cgrou
 	case RES_MAX_USAGE:
 		if (type == _MEM)
 			res_counter_reset_max(&memcg->res);
-		else
+		else if (type == _MEMSWAP)
 			res_counter_reset_max(&memcg->memsw);
+		else if (type == _KMEM)
+			res_counter_reset_max(&memcg->kmem);
+		else
+			return -EINVAL;
 		break;
 	case RES_FAILCNT:
 		if (type == _MEM)
 			res_counter_reset_failcnt(&memcg->res);
-		else
+		else if (type == _MEMSWAP)
 			res_counter_reset_failcnt(&memcg->memsw);
+		else if (type == _KMEM)
+			res_counter_reset_failcnt(&memcg->kmem);
+		else
+			return -EINVAL;
 		break;
 	}
 
@@ -4651,6 +4743,7 @@ static int mem_cgroup_oom_control_write(
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
+	memcg_propagate_kmem(memcg);
 	return mem_cgroup_sockets_init(memcg, ss);
 };
 
@@ -4765,6 +4858,31 @@ static struct cftype mem_cgroup_files[] 
 		.read = mem_cgroup_read,
 	},
 #endif
+#ifdef CONFIG_MEMCG_KMEM
+	{
+		.name = "kmem.limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
+		.write_string = mem_cgroup_write,
+		.read = mem_cgroup_read,
+	},
+	{
+		.name = "kmem.usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_KMEM, RES_USAGE),
+		.read = mem_cgroup_read,
+	},
+	{
+		.name = "kmem.failcnt",
+		.private = MEMFILE_PRIVATE(_KMEM, RES_FAILCNT),
+		.trigger = mem_cgroup_reset,
+		.read = mem_cgroup_read,
+	},
+	{
+		.name = "kmem.max_usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_KMEM, RES_MAX_USAGE),
+		.trigger = mem_cgroup_reset,
+		.read = mem_cgroup_read,
+	},
+#endif
 	{ },	/* terminate */
 };
 
@@ -5010,6 +5128,7 @@ mem_cgroup_css_alloc(struct cgroup *cont
 	if (parent && parent->use_hierarchy) {
 		res_counter_init(&memcg->res, &parent->res);
 		res_counter_init(&memcg->memsw, &parent->memsw);
+		res_counter_init(&memcg->kmem, &parent->kmem);
 		/*
 		 * We increment refcnt of the parent to ensure that we can
 		 * safely access it on res_counter_charge/uncharge.
@@ -5020,6 +5139,7 @@ mem_cgroup_css_alloc(struct cgroup *cont
 	} else {
 		res_counter_init(&memcg->res, NULL);
 		res_counter_init(&memcg->memsw, NULL);
+		res_counter_init(&memcg->kmem, NULL);
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

