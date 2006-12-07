From: akpm@osdl.org
Subject: - mm-slab-eliminate-lock_cpu_hotplug-from-slab.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:40 -0800
Message-ID: <200612072256.kB7Mue8n029219@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163565AbWLGW4w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kiran@scalex86.org, shai@scalex86.org, mm-commits@vger.kernel.org


The patch titled
     mm: slab: eliminate lock_cpu_hotplug from slab
has been removed from the -mm tree.  Its filename was
     mm-slab-eliminate-lock_cpu_hotplug-from-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: slab: eliminate lock_cpu_hotplug from slab
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Here's an attempt towards doing away with lock_cpu_hotplug in the slab
subsystem.  This approach also fixes a bug which shows up when cpus are
being offlined/onlined and slab caches are being tuned simultaneously.

http://marc.theaimsgroup.com/?l=linux-kernel&m=116098888100481&w=2

The patch has been stress tested overnight on a 2 socket 4 core AMD box with
repeated cpu online and offline, while dbench and kernbench process are
running, and slab caches being tuned at the same time.
There were no lockdep warnings either.  (This test on 2,6.18 as 2.6.19-rc
crashes at __drain_pages
http://marc.theaimsgroup.com/?l=linux-kernel&m=116172164217678&w=2 )

The approach here is to hold cache_chain_mutex from CPU_UP_PREPARE until
CPU_ONLINE (similar in approach as worqueue_mutex) .  Slab code sensitive
to cpu_online_map (kmem_cache_create, kmem_cache_destroy, slabinfo_write,
__cache_shrink) is already serialized with cache_chain_mutex.  (This patch
lengthens cache_chain_mutex hold time at kmem_cache_destroy to cover this).
 This patch also takes the cache_chain_sem at kmem_cache_shrink to protect
sanity of cpu_online_map at __cache_shrink, as viewed by slab. 
(kmem_cache_shrink->__cache_shrink->drain_cpu_caches).  But, really,
kmem_cache_shrink is used at just one place in the acpi subsystem!  Do we
really need to keep kmem_cache_shrink at all?

Another note.  Looks like a cpu hotplug event can send  CPU_UP_CANCELED to
a registered subsystem even if the subsystem did not receive CPU_UP_PREPARE.
This could be due to a subsystem registered for notification earlier than
the current subsystem crapping out with NOTIFY_BAD. Badness can occur with
in the CPU_UP_CANCELED code path at slab if this happens (The same would
apply for workqueue.c as well).  To overcome this, we might have to use either
a) a per subsystem flag and avoid handling of CPU_UP_CANCELED, or
b) Use a special notifier events like LOCK_ACQUIRE/RELEASE as Gautham was
   using in his experiments, or
c) Do not send CPU_UP_CANCELED to a subsystem which did not receive
   CPU_UP_PREPARE.

I would prefer c).

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff -puN mm/slab.c~mm-slab-eliminate-lock_cpu_hotplug-from-slab mm/slab.c
--- a/mm/slab.c~mm-slab-eliminate-lock_cpu_hotplug-from-slab
+++ a/mm/slab.c
@@ -730,7 +730,10 @@ static inline void init_lock_keys(void)
 }
 #endif
 
-/* Guard access to the cache-chain. */
+/*
+ * 1. Guard access to the cache-chain.
+ * 2. Protect sanity of cpu_online_map against cpu hotplug events
+ */
 static DEFINE_MUTEX(cache_chain_mutex);
 static struct list_head cache_chain;
 
@@ -1230,12 +1233,18 @@ static int __cpuinit cpuup_callback(stru
 			kfree(shared);
 			free_alien_cache(alien);
 		}
-		mutex_unlock(&cache_chain_mutex);
 		break;
 	case CPU_ONLINE:
+		mutex_unlock(&cache_chain_mutex);
 		start_cpu_timer(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
+	case CPU_DOWN_PREPARE:
+		mutex_lock(&cache_chain_mutex);
+		break;
+	case CPU_DOWN_FAILED:
+		mutex_unlock(&cache_chain_mutex);
+		break;
 	case CPU_DEAD:
 		/*
 		 * Even if all the cpus of a node are down, we don't free the
@@ -1246,8 +1255,8 @@ static int __cpuinit cpuup_callback(stru
 		 * gets destroyed at kmem_cache_destroy().
 		 */
 		/* fall thru */
+#endif
 	case CPU_UP_CANCELED:
-		mutex_lock(&cache_chain_mutex);
 		list_for_each_entry(cachep, &cache_chain, next) {
 			struct array_cache *nc;
 			struct array_cache *shared;
@@ -1308,11 +1317,9 @@ free_array_cache:
 		}
 		mutex_unlock(&cache_chain_mutex);
 		break;
-#endif
 	}
 	return NOTIFY_OK;
 bad:
-	mutex_unlock(&cache_chain_mutex);
 	return NOTIFY_BAD;
 }
 
@@ -2098,11 +2105,9 @@ kmem_cache_create (const char *name, siz
 	}
 
 	/*
-	 * Prevent CPUs from coming and going.
-	 * lock_cpu_hotplug() nests outside cache_chain_mutex
+	 * We use cache_chain_mutex to ensure a consistent view of
+	 * cpu_online_map as well.  Please see cpuup_callback
 	 */
-	lock_cpu_hotplug();
-
 	mutex_lock(&cache_chain_mutex);
 
 	list_for_each_entry(pc, &cache_chain, next) {
@@ -2325,7 +2330,6 @@ oops:
 		panic("kmem_cache_create(): failed to create slab `%s'\n",
 		      name);
 	mutex_unlock(&cache_chain_mutex);
-	unlock_cpu_hotplug();
 	return cachep;
 }
 EXPORT_SYMBOL(kmem_cache_create);
@@ -2443,6 +2447,7 @@ out:
 	return nr_freed;
 }
 
+/* Called with cache_chain_mutex held to protect against cpu hotplug */
 static int __cache_shrink(struct kmem_cache *cachep)
 {
 	int ret = 0, i = 0;
@@ -2473,9 +2478,13 @@ static int __cache_shrink(struct kmem_ca
  */
 int kmem_cache_shrink(struct kmem_cache *cachep)
 {
+	int ret;
 	BUG_ON(!cachep || in_interrupt());
 
-	return __cache_shrink(cachep);
+	mutex_lock(&cache_chain_mutex);
+	ret = __cache_shrink(cachep);
+	mutex_unlock(&cache_chain_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
@@ -2499,23 +2508,16 @@ void kmem_cache_destroy(struct kmem_cach
 {
 	BUG_ON(!cachep || in_interrupt());
 
-	/* Don't let CPUs to come and go */
-	lock_cpu_hotplug();
-
 	/* Find the cache in the chain of caches. */
 	mutex_lock(&cache_chain_mutex);
 	/*
 	 * the chain is never empty, cache_cache is never destroyed
 	 */
 	list_del(&cachep->next);
-	mutex_unlock(&cache_chain_mutex);
-
 	if (__cache_shrink(cachep)) {
 		slab_error(cachep, "Can't free all objects");
-		mutex_lock(&cache_chain_mutex);
 		list_add(&cachep->next, &cache_chain);
 		mutex_unlock(&cache_chain_mutex);
-		unlock_cpu_hotplug();
 		return;
 	}
 
@@ -2523,7 +2525,7 @@ void kmem_cache_destroy(struct kmem_cach
 		synchronize_rcu();
 
 	__kmem_cache_destroy(cachep);
-	unlock_cpu_hotplug();
+	mutex_unlock(&cache_chain_mutex);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
_

Patches currently in -mm which might be from kiran@scalex86.org are

origin.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy-tidy-2.patch
slab-leaks3-default-y.patch

