From: akpm@linux-foundation.org
Subject: + cpu-hotplug-slab-cleanup-cpuup_callback.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:51:22 -0700
Message-ID: <200707262051.l6QKpMJt020270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934341AbXGZUvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, clameter@sgi.com, ego@in.ibm.com, oleg@tv-sign.ru, penberg@cs.helsinki.fi


The patch titled
     cpu hotplug: slab: cleanup cpuup_callback()
has been added to the -mm tree.  Its filename is
     cpu-hotplug-slab-cleanup-cpuup_callback.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu hotplug: slab: cleanup cpuup_callback()
From: Akinobu Mita <akinobu.mita@gmail.com>

cpuup_callback() is too long.  This patch factors out CPU_UP_CANCELLED and
CPU_UP_PREPARE handlings from cpuup_callback().

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |  301 +++++++++++++++++++++++++++-------------------------
 1 file changed, 159 insertions(+), 142 deletions(-)

diff -puN mm/slab.c~cpu-hotplug-slab-cleanup-cpuup_callback mm/slab.c
--- a/mm/slab.c~cpu-hotplug-slab-cleanup-cpuup_callback
+++ a/mm/slab.c
@@ -1156,105 +1156,181 @@ static inline int cache_free_alien(struc
 }
 #endif
 
-static int __cpuinit cpuup_callback(struct notifier_block *nfb,
-				    unsigned long action, void *hcpu)
+static void __cpuinit cpuup_canceled(long cpu)
+{
+	struct kmem_cache *cachep;
+	struct kmem_list3 *l3 = NULL;
+	int node = cpu_to_node(cpu);
+
+	list_for_each_entry(cachep, &cache_chain, next) {
+		struct array_cache *nc;
+		struct array_cache *shared;
+		struct array_cache **alien;
+		cpumask_t mask;
+
+		mask = node_to_cpumask(node);
+		/* cpu is dead; no one can alloc from it. */
+		nc = cachep->array[cpu];
+		cachep->array[cpu] = NULL;
+		l3 = cachep->nodelists[node];
+
+		if (!l3)
+			goto free_array_cache;
+
+		spin_lock_irq(&l3->list_lock);
+
+		/* Free limit for this kmem_list3 */
+		l3->free_limit -= cachep->batchcount;
+		if (nc)
+			free_block(cachep, nc->entry, nc->avail, node);
+
+		if (!cpus_empty(mask)) {
+			spin_unlock_irq(&l3->list_lock);
+			goto free_array_cache;
+		}
+
+		shared = l3->shared;
+		if (shared) {
+			free_block(cachep, shared->entry,
+				   shared->avail, node);
+			l3->shared = NULL;
+		}
+
+		alien = l3->alien;
+		l3->alien = NULL;
+
+		spin_unlock_irq(&l3->list_lock);
+
+		kfree(shared);
+		if (alien) {
+			drain_alien_cache(cachep, alien);
+			free_alien_cache(alien);
+		}
+free_array_cache:
+		kfree(nc);
+	}
+	/*
+	 * In the previous loop, all the objects were freed to
+	 * the respective cache's slabs,  now we can go ahead and
+	 * shrink each nodelist to its limit.
+	 */
+	list_for_each_entry(cachep, &cache_chain, next) {
+		l3 = cachep->nodelists[node];
+		if (!l3)
+			continue;
+		drain_freelist(cachep, l3, l3->free_objects);
+	}
+}
+
+static int __cpuinit cpuup_prepare(long cpu)
 {
-	long cpu = (long)hcpu;
 	struct kmem_cache *cachep;
 	struct kmem_list3 *l3 = NULL;
 	int node = cpu_to_node(cpu);
 	const int memsize = sizeof(struct kmem_list3);
 
-	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&cache_chain_mutex);
-		break;
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
+	/*
+	 * We need to do this right in the beginning since
+	 * alloc_arraycache's are going to use this list.
+	 * kmalloc_node allows us to add the slab to the right
+	 * kmem_list3 and not this cpu's kmem_list3
+	 */
+
+	list_for_each_entry(cachep, &cache_chain, next) {
 		/*
-		 * We need to do this right in the beginning since
-		 * alloc_arraycache's are going to use this list.
-		 * kmalloc_node allows us to add the slab to the right
-		 * kmem_list3 and not this cpu's kmem_list3
+		 * Set up the size64 kmemlist for cpu before we can
+		 * begin anything. Make sure some other cpu on this
+		 * node has not already allocated this
 		 */
+		if (!cachep->nodelists[node]) {
+			l3 = kmalloc_node(memsize, GFP_KERNEL, node);
+			if (!l3)
+				goto bad;
+			kmem_list3_init(l3);
+			l3->next_reap = jiffies + REAPTIMEOUT_LIST3 +
+			    ((unsigned long)cachep) % REAPTIMEOUT_LIST3;
 
-		list_for_each_entry(cachep, &cache_chain, next) {
 			/*
-			 * Set up the size64 kmemlist for cpu before we can
-			 * begin anything. Make sure some other cpu on this
-			 * node has not already allocated this
+			 * The l3s don't come and go as CPUs come and
+			 * go.  cache_chain_mutex is sufficient
+			 * protection here.
 			 */
-			if (!cachep->nodelists[node]) {
-				l3 = kmalloc_node(memsize, GFP_KERNEL, node);
-				if (!l3)
-					goto bad;
-				kmem_list3_init(l3);
-				l3->next_reap = jiffies + REAPTIMEOUT_LIST3 +
-				    ((unsigned long)cachep) % REAPTIMEOUT_LIST3;
-
-				/*
-				 * The l3s don't come and go as CPUs come and
-				 * go.  cache_chain_mutex is sufficient
-				 * protection here.
-				 */
-				cachep->nodelists[node] = l3;
-			}
-
-			spin_lock_irq(&cachep->nodelists[node]->list_lock);
-			cachep->nodelists[node]->free_limit =
-				(1 + nr_cpus_node(node)) *
-				cachep->batchcount + cachep->num;
-			spin_unlock_irq(&cachep->nodelists[node]->list_lock);
+			cachep->nodelists[node] = l3;
 		}
 
-		/*
-		 * Now we can go ahead with allocating the shared arrays and
-		 * array caches
-		 */
-		list_for_each_entry(cachep, &cache_chain, next) {
-			struct array_cache *nc;
-			struct array_cache *shared = NULL;
-			struct array_cache **alien = NULL;
+		spin_lock_irq(&cachep->nodelists[node]->list_lock);
+		cachep->nodelists[node]->free_limit =
+			(1 + nr_cpus_node(node)) *
+			cachep->batchcount + cachep->num;
+		spin_unlock_irq(&cachep->nodelists[node]->list_lock);
+	}
 
-			nc = alloc_arraycache(node, cachep->limit,
-						cachep->batchcount);
-			if (!nc)
+	/*
+	 * Now we can go ahead with allocating the shared arrays and
+	 * array caches
+	 */
+	list_for_each_entry(cachep, &cache_chain, next) {
+		struct array_cache *nc;
+		struct array_cache *shared = NULL;
+		struct array_cache **alien = NULL;
+
+		nc = alloc_arraycache(node, cachep->limit,
+					cachep->batchcount);
+		if (!nc)
+			goto bad;
+		if (cachep->shared) {
+			shared = alloc_arraycache(node,
+				cachep->shared * cachep->batchcount,
+				0xbaadf00d);
+			if (!shared)
 				goto bad;
-			if (cachep->shared) {
-				shared = alloc_arraycache(node,
-					cachep->shared * cachep->batchcount,
-					0xbaadf00d);
-				if (!shared)
-					goto bad;
-			}
-			if (use_alien_caches) {
-                                alien = alloc_alien_cache(node, cachep->limit);
-                                if (!alien)
-                                        goto bad;
-                        }
-			cachep->array[cpu] = nc;
-			l3 = cachep->nodelists[node];
-			BUG_ON(!l3);
+		}
+		if (use_alien_caches) {
+			alien = alloc_alien_cache(node, cachep->limit);
+			if (!alien)
+				goto bad;
+		}
+		cachep->array[cpu] = nc;
+		l3 = cachep->nodelists[node];
+		BUG_ON(!l3);
 
-			spin_lock_irq(&l3->list_lock);
-			if (!l3->shared) {
-				/*
-				 * We are serialised from CPU_DEAD or
-				 * CPU_UP_CANCELLED by the cpucontrol lock
-				 */
-				l3->shared = shared;
-				shared = NULL;
-			}
+		spin_lock_irq(&l3->list_lock);
+		if (!l3->shared) {
+			/*
+			 * We are serialised from CPU_DEAD or
+			 * CPU_UP_CANCELLED by the cpucontrol lock
+			 */
+			l3->shared = shared;
+			shared = NULL;
+		}
 #ifdef CONFIG_NUMA
-			if (!l3->alien) {
-				l3->alien = alien;
-				alien = NULL;
-			}
-#endif
-			spin_unlock_irq(&l3->list_lock);
-			kfree(shared);
-			free_alien_cache(alien);
+		if (!l3->alien) {
+			l3->alien = alien;
+			alien = NULL;
 		}
+#endif
+		spin_unlock_irq(&l3->list_lock);
+		kfree(shared);
+		free_alien_cache(alien);
+	}
+	return 0;
+bad:
+	return -ENOMEM;
+}
+
+static int __cpuinit cpuup_callback(struct notifier_block *nfb,
+				    unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	int err = 0;
+
+	switch (action) {
+	case CPU_LOCK_ACQUIRE:
+		mutex_lock(&cache_chain_mutex);
+		break;
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = cpuup_prepare(cpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
@@ -1291,72 +1367,13 @@ static int __cpuinit cpuup_callback(stru
 #endif
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		list_for_each_entry(cachep, &cache_chain, next) {
-			struct array_cache *nc;
-			struct array_cache *shared;
-			struct array_cache **alien;
-			cpumask_t mask;
-
-			mask = node_to_cpumask(node);
-			/* cpu is dead; no one can alloc from it. */
-			nc = cachep->array[cpu];
-			cachep->array[cpu] = NULL;
-			l3 = cachep->nodelists[node];
-
-			if (!l3)
-				goto free_array_cache;
-
-			spin_lock_irq(&l3->list_lock);
-
-			/* Free limit for this kmem_list3 */
-			l3->free_limit -= cachep->batchcount;
-			if (nc)
-				free_block(cachep, nc->entry, nc->avail, node);
-
-			if (!cpus_empty(mask)) {
-				spin_unlock_irq(&l3->list_lock);
-				goto free_array_cache;
-			}
-
-			shared = l3->shared;
-			if (shared) {
-				free_block(cachep, shared->entry,
-					   shared->avail, node);
-				l3->shared = NULL;
-			}
-
-			alien = l3->alien;
-			l3->alien = NULL;
-
-			spin_unlock_irq(&l3->list_lock);
-
-			kfree(shared);
-			if (alien) {
-				drain_alien_cache(cachep, alien);
-				free_alien_cache(alien);
-			}
-free_array_cache:
-			kfree(nc);
-		}
-		/*
-		 * In the previous loop, all the objects were freed to
-		 * the respective cache's slabs,  now we can go ahead and
-		 * shrink each nodelist to its limit.
-		 */
-		list_for_each_entry(cachep, &cache_chain, next) {
-			l3 = cachep->nodelists[node];
-			if (!l3)
-				continue;
-			drain_freelist(cachep, l3, l3->free_objects);
-		}
+		cpuup_canceled(cpu);
 		break;
 	case CPU_LOCK_RELEASE:
 		mutex_unlock(&cache_chain_mutex);
 		break;
 	}
-	return NOTIFY_OK;
-bad:
-	return NOTIFY_BAD;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block __cpuinitdata cpucache_notifier = {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
