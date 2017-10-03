From: akpm@linux-foundation.org
Subject: [patch 37/51] mm: memcontrol: use vmalloc fallback for large kmem memcg arrays
Date: Tue, 03 Oct 2017 16:16:10 -0700
Message-ID: <59d41a3a.RJ/4wBb/INbkXILv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58796 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXQL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, jbacik@fb.com, mhocko@suse.com, vdavydov.dev@gmail.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: use vmalloc fallback for large kmem memcg arrays

For quick per-memcg indexing, slab caches and list_lru structures maintain
linear arrays of descriptors.  As the number of concurrent memory cgroups
in the system goes up, this requires large contiguous allocations (8k
cgroups = order-5, 16k cgroups = order-6 etc.) for every existing slab
cache and list_lru, which can easily fail on loaded systems.  E.g.:

mkdir: page allocation failure: order:5, mode:0x14040c0(GFP_KERNEL|__GFP_COMP), nodemask=(null)
CPU: 1 PID: 6399 Comm: mkdir Not tainted 4.13.0-mm1-00065-g720bbe532b7c-dirty #481
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
Call Trace:
 dump_stack+0x70/0x9d
 warn_alloc+0xd6/0x170
 ? __alloc_pages_direct_compact+0x4c/0x110
 __alloc_pages_nodemask+0xf50/0x1430
 ? __lock_acquire+0xd19/0x1360
 ? memcg_update_all_list_lrus+0x2e/0x2e0
 ? __mutex_lock+0x7c/0x950
 ? memcg_update_all_list_lrus+0x2e/0x2e0
 alloc_pages_current+0x60/0xc0
 kmalloc_order_trace+0x29/0x1b0
 __kmalloc+0x1f4/0x320
 memcg_update_all_list_lrus+0xca/0x2e0
 mem_cgroup_css_alloc+0x612/0x670
 cgroup_apply_control_enable+0x19e/0x360
 cgroup_mkdir+0x322/0x490
 kernfs_iop_mkdir+0x55/0x80
 vfs_mkdir+0xd0/0x120
 SyS_mkdirat+0x6c/0xe0
 SyS_mkdir+0x14/0x20
 entry_SYSCALL_64_fastpath+0x18/0xad
RIP: 0033:0x7f9ff36cee87
RSP: 002b:00007ffc7612d758 EFLAGS: 00000202 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00007ffc7612da48 RCX: 00007f9ff36cee87
RDX: 00000000000001ff RSI: 00000000000001ff RDI: 00007ffc7612de86
RBP: 0000000000000002 R08: 00000000000001ff R09: 0000000000401db0
R10: 00000000000001e2 R11: 0000000000000202 R12: 0000000000000000
R13: 00007ffc7612da40 R14: 0000000000000000 R15: 0000000000000000
Mem-Info:
active_anon:2965 inactive_anon:19 isolated_anon:0
 active_file:100270 inactive_file:98846 isolated_file:0
 unevictable:0 dirty:0 writeback:0 unstable:0
 slab_reclaimable:7328 slab_unreclaimable:16402
 mapped:771 shmem:52 pagetables:278 bounce:0
 free:13718 free_pcp:0 free_cma:0

This output is from an artificial reproducer, but we have repeatedly
observed order-7 failures in production in the Facebook fleet.  These
systems become useless as they cannot run more jobs, even though there is
plenty of memory to allocate 128 individual pages.

Use kvmalloc and kvzalloc to fall back to vmalloc space if these arrays
prove too large for allocating them physically contiguous.

Link: http://lkml.kernel.org/r/20170918184919.20644-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c    |   12 ++++++------
 mm/slab_common.c |   22 +++++++++++++++-------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff -puN mm/list_lru.c~mm-memcontrol-use-vmalloc-fallback-for-large-kmem-memcg-arrays mm/list_lru.c
--- a/mm/list_lru.c~mm-memcontrol-use-vmalloc-fallback-for-large-kmem-memcg-arrays
+++ a/mm/list_lru.c
@@ -325,12 +325,12 @@ static int memcg_init_list_lru_node(stru
 {
 	int size = memcg_nr_cache_ids;
 
-	nlru->memcg_lrus = kmalloc(size * sizeof(void *), GFP_KERNEL);
+	nlru->memcg_lrus = kvmalloc(size * sizeof(void *), GFP_KERNEL);
 	if (!nlru->memcg_lrus)
 		return -ENOMEM;
 
 	if (__memcg_init_list_lru_node(nlru->memcg_lrus, 0, size)) {
-		kfree(nlru->memcg_lrus);
+		kvfree(nlru->memcg_lrus);
 		return -ENOMEM;
 	}
 
@@ -340,7 +340,7 @@ static int memcg_init_list_lru_node(stru
 static void memcg_destroy_list_lru_node(struct list_lru_node *nlru)
 {
 	__memcg_destroy_list_lru_node(nlru->memcg_lrus, 0, memcg_nr_cache_ids);
-	kfree(nlru->memcg_lrus);
+	kvfree(nlru->memcg_lrus);
 }
 
 static int memcg_update_list_lru_node(struct list_lru_node *nlru,
@@ -351,12 +351,12 @@ static int memcg_update_list_lru_node(st
 	BUG_ON(old_size > new_size);
 
 	old = nlru->memcg_lrus;
-	new = kmalloc(new_size * sizeof(void *), GFP_KERNEL);
+	new = kvmalloc(new_size * sizeof(void *), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
 	if (__memcg_init_list_lru_node(new, old_size, new_size)) {
-		kfree(new);
+		kvfree(new);
 		return -ENOMEM;
 	}
 
@@ -373,7 +373,7 @@ static int memcg_update_list_lru_node(st
 	nlru->memcg_lrus = new;
 	spin_unlock_irq(&nlru->lock);
 
-	kfree(old);
+	kvfree(old);
 	return 0;
 }
 
diff -puN mm/slab_common.c~mm-memcontrol-use-vmalloc-fallback-for-large-kmem-memcg-arrays mm/slab_common.c
--- a/mm/slab_common.c~mm-memcontrol-use-vmalloc-fallback-for-large-kmem-memcg-arrays
+++ a/mm/slab_common.c
@@ -165,9 +165,9 @@ static int init_memcg_params(struct kmem
 	if (!memcg_nr_cache_ids)
 		return 0;
 
-	arr = kzalloc(sizeof(struct memcg_cache_array) +
-		      memcg_nr_cache_ids * sizeof(void *),
-		      GFP_KERNEL);
+	arr = kvzalloc(sizeof(struct memcg_cache_array) +
+		       memcg_nr_cache_ids * sizeof(void *),
+		       GFP_KERNEL);
 	if (!arr)
 		return -ENOMEM;
 
@@ -178,15 +178,23 @@ static int init_memcg_params(struct kmem
 static void destroy_memcg_params(struct kmem_cache *s)
 {
 	if (is_root_cache(s))
-		kfree(rcu_access_pointer(s->memcg_params.memcg_caches));
+		kvfree(rcu_access_pointer(s->memcg_params.memcg_caches));
+}
+
+static void free_memcg_params(struct rcu_head *rcu)
+{
+	struct memcg_cache_array *old;
+
+	old = container_of(rcu, struct memcg_cache_array, rcu);
+	kvfree(old);
 }
 
 static int update_memcg_params(struct kmem_cache *s, int new_array_size)
 {
 	struct memcg_cache_array *old, *new;
 
-	new = kzalloc(sizeof(struct memcg_cache_array) +
-		      new_array_size * sizeof(void *), GFP_KERNEL);
+	new = kvzalloc(sizeof(struct memcg_cache_array) +
+		       new_array_size * sizeof(void *), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
@@ -198,7 +206,7 @@ static int update_memcg_params(struct km
 
 	rcu_assign_pointer(s->memcg_params.memcg_caches, new);
 	if (old)
-		kfree_rcu(old, rcu);
+		call_rcu(&old->rcu, free_memcg_params);
 	return 0;
 }
 
_
