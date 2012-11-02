From: akpm@linux-foundation.org
Subject: + memcg-kmem-accounting-basic-infrastructure.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:03:09 -0700
Message-ID: <20121102000309.784F110004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:44744 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KBADL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:03:11 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so366554yen.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:03:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg: kmem accounting basic infrastructure
has been added to the -mm tree.  Its filename is
     memcg-kmem-accounting-basic-infrastructure.patch

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
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  126 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 123 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-kmem-accounting-basic-infrastructure mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-kmem-accounting-basic-infrastructure
+++ a/mm/memcontrol.c
@@ -266,6 +266,10 @@ struct mem_cgroup {
 	};
 
 	/*
+	 * the counter to account for kernel memory usage.
+	 */
+	struct res_counter kmem;
+	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
 	 */
@@ -280,6 +284,7 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
+	unsigned long kmem_account_flags; /* See KMEM_ACCOUNTED_*, below */
 
 	bool		oom_lock;
 	atomic_t	under_oom;
@@ -332,6 +337,20 @@ struct mem_cgroup {
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
@@ -390,6 +409,7 @@ enum res_type {
 	_MEM,
 	_MEMSWAP,
 	_OOM_TYPE,
+	_KMEM,
 };
 
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
@@ -1433,6 +1453,10 @@ done:
 		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
+	printk(KERN_INFO "kmem: usage %llukB, limit %llukB, failcnt %llu\n",
+		res_counter_read_u64(&memcg->kmem, RES_USAGE) >> 10,
+		res_counter_read_u64(&memcg->kmem, RES_LIMIT) >> 10,
+		res_counter_read_u64(&memcg->kmem, RES_FAILCNT));
 }
 
 /*
@@ -3968,6 +3992,9 @@ static ssize_t mem_cgroup_read(struct cg
 		else
 			val = res_counter_read_u64(&memcg->memsw, name);
 		break;
+	case _KMEM:
+		val = res_counter_read_u64(&memcg->kmem, name);
+		break;
 	default:
 		BUG();
 	}
@@ -3975,6 +4002,59 @@ static ssize_t mem_cgroup_read(struct cg
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
@@ -4006,8 +4086,12 @@ static int mem_cgroup_write(struct cgrou
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
@@ -4073,14 +4157,22 @@ static int mem_cgroup_reset(struct cgrou
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
 
@@ -4642,6 +4734,7 @@ static int mem_cgroup_oom_control_write(
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
+	memcg_propagate_kmem(memcg);
 	return mem_cgroup_sockets_init(memcg, ss);
 };
 
@@ -4756,6 +4849,31 @@ static struct cftype mem_cgroup_files[] 
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
 
@@ -5001,6 +5119,7 @@ mem_cgroup_create(struct cgroup *cont)
 	if (parent && parent->use_hierarchy) {
 		res_counter_init(&memcg->res, &parent->res);
 		res_counter_init(&memcg->memsw, &parent->memsw);
+		res_counter_init(&memcg->kmem, &parent->kmem);
 		/*
 		 * We increment refcnt of the parent to ensure that we can
 		 * safely access it on res_counter_charge/uncharge.
@@ -5011,6 +5130,7 @@ mem_cgroup_create(struct cgroup *cont)
 	} else {
 		res_counter_init(&memcg->res, NULL);
 		res_counter_init(&memcg->memsw, NULL);
+		res_counter_init(&memcg->kmem, NULL);
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
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
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

