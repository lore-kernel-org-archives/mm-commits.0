From: akpm@linux-foundation.org
Subject: + memcg-per-memcg-kmem-shrinking.patch added to -mm tree
Date: Wed, 05 Jun 2013 16:11:27 -0700
Message-ID: <51afc59f.tHZ3+wmKlLp1tu04%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3FEXL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, riel@redhat.com, penberg@kernel.org, mtosatti@redhat.com, mhocko@suse.cz, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hughd@google.com, hch@lst.de, hannes@cmpxchg.org, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, anton@enomsg.org, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: + memcg-per-memcg-kmem-shrinking.patch added to -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,anton@enomsg.org,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hannes@cmpxchg.org,hch@lst.de,hughd@google.com,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mhocko@suse.cz,mtosatti@redhat.com,penberg@kernel.org,riel@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:11:27 -0700


The patch titled
     Subject: memcg: per-memcg kmem shrinking
has been added to the -mm tree.  Its filename is
     memcg-per-memcg-kmem-shrinking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: memcg: per-memcg kmem shrinking

If the kernel limit is smaller than the user limit, we will have
situations in which our allocations fail but freeing user pages will buy
us nothing.  In those, we would like to call a specialized memcg reclaimer
that only frees kernel memory and leave the user memory alone.  Those are
also expected to fail when we account memcg->kmem, instead of when we
account memcg->res.  Based on that, this patch implements a memcg-specific
reclaimer, that only shrinks kernel objects, withouth touching user pages.

There might be situations in which there are plenty of objects to shrink,
but we can't do it because the __GFP_FS flag is not set.  Although they
can happen with user pages, they are a lot more common with fs-metadata:
this is the case with almost all inode allocation.

Those allocations are, however, capable of waiting.  So we can just span a
worker, let it finish its job and proceed with the allocation.  As slow as
it is, at this point we are already past any hopes anyway.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 
 mm/memcontrol.c      |  180 ++++++++++++++++++++++++++++++++---------
 mm/vmscan.c          |   44 +++++++++-
 3 files changed, 187 insertions(+), 39 deletions(-)

diff -puN include/linux/swap.h~memcg-per-memcg-kmem-shrinking include/linux/swap.h
--- a/include/linux/swap.h~memcg-per-memcg-kmem-shrinking
+++ a/include/linux/swap.h
@@ -276,6 +276,8 @@ extern unsigned long try_to_free_pages(s
 extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
 						  gfp_t gfp_mask, bool noswap);
+extern unsigned long try_to_free_mem_cgroup_kmem(struct mem_cgroup *mem,
+						 gfp_t gfp_mask);
 extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						struct zone *zone,
diff -puN mm/memcontrol.c~memcg-per-memcg-kmem-shrinking mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-per-memcg-kmem-shrinking
+++ a/mm/memcontrol.c
@@ -382,7 +382,8 @@ struct mem_cgroup {
 	atomic_t	numainfo_events;
 	atomic_t	numainfo_updating;
 #endif
-
+	/* when kmem shrinkers can sleep but can't proceed due to context */
+	struct work_struct kmemcg_shrink_work;
 	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
@@ -448,11 +449,14 @@ static inline void memcg_dangling_free(s
 static inline void memcg_dangling_add(struct mem_cgroup *memcg) {}
 #endif
 
+static DEFINE_MUTEX(set_limit_mutex);
+
 /* internal only representation about the status of kmem accounting. */
 enum {
 	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
 	KMEM_ACCOUNTED_ACTIVATED, /* static key enabled. */
 	KMEM_ACCOUNTED_DEAD, /* dead memcg with pending kmem charges */
+	KMEM_MAY_SHRINK, /* kmem limit < mem limit, shrink kmem only */
 };
 
 /* We account when limit is on, but only after call sites are patched */
@@ -491,6 +495,31 @@ static bool memcg_kmem_test_and_clear_de
 	return test_and_clear_bit(KMEM_ACCOUNTED_DEAD,
 				  &memcg->kmem_account_flags);
 }
+
+/*
+ * If the kernel limit is smaller than the user limit, we will have situations
+ * in which our allocations fail but freeing user pages will buy us nothing.
+ * In those, we would like to call a specialized memcg reclaimer that only
+ * frees kernel memory and leave the user memory alone.
+ *
+ * This test exists so we can differentiate between those. Everytime one of the
+ * limits is updated, we need to run it. The set_limit_mutex must be held, so
+ * they don't change again.
+ */
+static void memcg_update_shrink_status(struct mem_cgroup *memcg)
+{
+	mutex_lock(&set_limit_mutex);
+	if (res_counter_read_u64(&memcg->kmem, RES_LIMIT) <
+		res_counter_read_u64(&memcg->res, RES_LIMIT))
+		set_bit(KMEM_MAY_SHRINK, &memcg->kmem_account_flags);
+	else
+		clear_bit(KMEM_MAY_SHRINK, &memcg->kmem_account_flags);
+	mutex_unlock(&set_limit_mutex);
+}
+#else
+static void memcg_update_shrink_status(struct mem_cgroup *memcg)
+{
+}
 #endif
 
 /* Stuffs for move charges at task migration. */
@@ -3039,8 +3068,6 @@ static void __mem_cgroup_commit_charge(s
 	memcg_check_events(memcg, page);
 }
 
-static DEFINE_MUTEX(set_limit_mutex);
-
 #ifdef CONFIG_MEMCG_KMEM
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
@@ -3082,16 +3109,91 @@ static int mem_cgroup_slabinfo_read(stru
 }
 #endif
 
+/*
+ * During the creation a new cache, we need to disable our accounting mechanism
+ * altogether. This is true even if we are not creating, but rather just
+ * enqueing new caches to be created.
+ *
+ * This is because that process will trigger allocations; some visible, like
+ * explicit kmallocs to auxiliary data structures, name strings and internal
+ * cache structures; some well concealed, like INIT_WORK() that can allocate
+ * objects during debug.
+ *
+ * If any allocation happens during memcg_kmem_get_cache, we will recurse back
+ * to it. This may not be a bounded recursion: since the first cache creation
+ * failed to complete (waiting on the allocation), we'll just try to create the
+ * cache again, failing at the same point.
+ *
+ * memcg_kmem_get_cache is prepared to abort after seeing a positive count of
+ * memcg_kmem_skip_account. So we enclose anything that might allocate memory
+ * inside the following two functions.
+ */
+static inline void memcg_stop_kmem_account(void)
+{
+	VM_BUG_ON(!current->mm);
+	current->memcg_kmem_skip_account++;
+}
+
+static inline void memcg_resume_kmem_account(void)
+{
+	VM_BUG_ON(!current->mm);
+	current->memcg_kmem_skip_account--;
+}
+
+static int memcg_try_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
+{
+	int retries = MEM_CGROUP_RECLAIM_RETRIES;
+	struct res_counter *fail_res;
+	int ret;
+
+	do {
+		ret = res_counter_charge(&memcg->kmem, size, &fail_res);
+		if (!ret)
+			return ret;
+
+		if (!(gfp & __GFP_WAIT))
+			return ret;
+
+		/*
+		 * We will try to shrink kernel memory present in caches. We
+		 * are sure that we can wait, so we will. The duration of our
+		 * wait is determined by congestion, the same way as vmscan.c
+		 *
+		 * If we are in FS context, though, then although we can wait,
+		 * we cannot call the shrinkers. Most fs shrinkers (which
+		 * comprises most of our kmem data) will not run without
+		 * __GFP_FS since they can deadlock. The solution is to
+		 * synchronously run that in a different context.
+		 */
+		if (!(gfp & __GFP_FS)) {
+			/*
+			 * we are already short on memory, every queue
+			 * allocation is likely to fail
+			 */
+			memcg_stop_kmem_account();
+			schedule_work(&memcg->kmemcg_shrink_work);
+			flush_work(&memcg->kmemcg_shrink_work);
+			memcg_resume_kmem_account();
+		} else
+			try_to_free_mem_cgroup_kmem(memcg, gfp);
+	} while (retries--);
+
+	return ret;
+}
+
 static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
 {
 	struct res_counter *fail_res;
 	struct mem_cgroup *_memcg;
 	int ret = 0;
 	bool may_oom;
+	bool kmem_first = test_bit(KMEM_MAY_SHRINK, &memcg->kmem_account_flags);
 
-	ret = res_counter_charge(&memcg->kmem, size, &fail_res);
-	if (ret)
-		return ret;
+	if (kmem_first) {
+		ret = memcg_try_charge_kmem(memcg, gfp, size);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Conditions under which we can wait for the oom_killer. Those are
@@ -3124,12 +3226,41 @@ static int memcg_charge_kmem(struct mem_
 			res_counter_charge_nofail(&memcg->memsw, size,
 						  &fail_res);
 		ret = 0;
-	} else if (ret)
+		if (kmem_first)
+			res_counter_charge_nofail(&memcg->kmem, size, &fail_res);
+	} else if (ret && kmem_first)
 		res_counter_uncharge(&memcg->kmem, size);
 
+	if (!ret && !kmem_first) {
+		ret = res_counter_charge(&memcg->kmem, size, &fail_res);
+		if (!ret)
+			return ret;
+
+		res_counter_uncharge(&memcg->res, size);
+		if (do_swap_account)
+			res_counter_uncharge(&memcg->memsw, size);
+	}
+
 	return ret;
 }
 
+/*
+ * There might be situations in which there are plenty of objects to shrink,
+ * but we can't do it because the __GFP_FS flag is not set.  This is the case
+ * with almost all inode allocation. They do are, however, capable of waiting.
+ * So we can just span a worker, let it finish its job and proceed with the
+ * allocation. As slow as it is, at this point we are already past any hopes
+ * anyway.
+ */
+static void kmemcg_shrink_work_fn(struct work_struct *w)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = container_of(w, struct mem_cgroup, kmemcg_shrink_work);
+	try_to_free_mem_cgroup_kmem(memcg, GFP_KERNEL);
+}
+
+
 static void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size)
 {
 	res_counter_uncharge(&memcg->res, size);
@@ -3209,6 +3340,7 @@ int memcg_update_cache_sizes(struct mem_
 	memcg_update_array_size(num + 1);
 
 	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
+	INIT_WORK(&memcg->kmemcg_shrink_work, kmemcg_shrink_work_fn);
 	mutex_init(&memcg->slab_caches_mutex);
 
 	return 0;
@@ -3483,37 +3615,6 @@ out:
 	kfree(s->memcg_params);
 }
 
-/*
- * During the creation a new cache, we need to disable our accounting mechanism
- * altogether. This is true even if we are not creating, but rather just
- * enqueing new caches to be created.
- *
- * This is because that process will trigger allocations; some visible, like
- * explicit kmallocs to auxiliary data structures, name strings and internal
- * cache structures; some well concealed, like INIT_WORK() that can allocate
- * objects during debug.
- *
- * If any allocation happens during memcg_kmem_get_cache, we will recurse back
- * to it. This may not be a bounded recursion: since the first cache creation
- * failed to complete (waiting on the allocation), we'll just try to create the
- * cache again, failing at the same point.
- *
- * memcg_kmem_get_cache is prepared to abort after seeing a positive count of
- * memcg_kmem_skip_account. So we enclose anything that might allocate memory
- * inside the following two functions.
- */
-static inline void memcg_stop_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account++;
-}
-
-static inline void memcg_resume_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account--;
-}
-
 struct mem_cgroup *mem_cgroup_from_kmem_page(struct page *page)
 {
 	struct page_cgroup *pc;
@@ -5598,6 +5699,9 @@ static int mem_cgroup_write(struct cgrou
 			ret = memcg_update_kmem_limit(cont, val);
 		else
 			return -EINVAL;
+
+		if (!ret)
+			memcg_update_shrink_status(memcg);
 		break;
 	case RES_SOFT_LIMIT:
 		ret = res_counter_memparse_write_strategy(buffer, &val);
diff -puN mm/vmscan.c~memcg-per-memcg-kmem-shrinking mm/vmscan.c
--- a/mm/vmscan.c~memcg-per-memcg-kmem-shrinking
+++ a/mm/vmscan.c
@@ -2731,7 +2731,49 @@ unsigned long try_to_free_mem_cgroup_pag
 
 	return nr_reclaimed;
 }
-#endif
+
+#ifdef CONFIG_MEMCG_KMEM
+/*
+ * This function is called when we are under kmem-specific pressure.  It will
+ * only trigger in environments with kmem.limit_in_bytes < limit_in_bytes, IOW,
+ * with a lower kmem allowance than the memory allowance.
+ *
+ * In this situation, freeing user pages from the cgroup won't do us any good.
+ * What we really need is to call the memcg-aware shrinkers, in the hope of
+ * freeing pages holding kmem objects. It may also be that we won't be able to
+ * free any pages, but will get rid of old objects opening up space for new
+ * ones.
+ */
+unsigned long try_to_free_mem_cgroup_kmem(struct mem_cgroup *memcg,
+					  gfp_t gfp_mask)
+{
+	long freed;
+
+	struct shrink_control shrink = {
+		.gfp_mask = gfp_mask,
+		.target_mem_cgroup = memcg,
+	};
+
+	if (!(gfp_mask & __GFP_WAIT))
+		return 0;
+
+	/*
+	 * memcg pressure is always global */
+	nodes_setall(shrink.nodes_to_scan);
+
+	/*
+	 * We haven't scanned any user LRU, so we basically come up with
+	 * crafted values of nr_scanned and LRU page (1 and 0 respectively).
+	 * This should be enough to tell shrink_slab that the freeing
+	 * responsibility is all on himself.
+	 */
+	freed = shrink_slab(&shrink, 1, 0);
+	if (!freed)
+		congestion_wait(BLK_RW_ASYNC, HZ/10);
+	return freed;
+}
+#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_MEMCG */
 
 static void age_active_anon(struct zone *zone, struct scan_control *sc)
 {
_

Patches currently in -mm which might be from glommer@openvz.org are

fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

