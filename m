From: akpm@linux-foundation.org
Subject: [withdrawn] mm-memcontrolc-memcg_create_kmem_cache-tweaks.patch
 removed from -mm tree
Date: Fri, 31 Jan 2014 11:18:24 -0800
Message-ID: <52ebf700.hD05JTgDNLvNIah8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaAaTSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:18:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, mhocko@suse.cz, hannes@cmpxchg.org, glommer@parallels.com, akpm@linux-foundation.org

Subject: [withdrawn] mm-memcontrolc-memcg_create_kmem_cache-tweaks.patch removed from -mm tree
To: akpm@linux-foundation.org,glommer@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,vdavydov@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:18:24 -0800


The patch titled
     Subject: mm/memcontrol.c: memcg_create_kmem_cache() tweaks
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-memcg_create_kmem_cache-tweaks.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memcontrol.c: memcg_create_kmem_cache() tweaks

Allocate tmp_name on demand rather than permanently consuming PATH_MAX
bytes of memory.  Remove the mutex which protected the static tmp_name.

Cc: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-memcg_create_kmem_cache-tweaks mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-memcg_create_kmem_cache-tweaks
+++ a/mm/memcontrol.c
@@ -3400,24 +3400,18 @@ void mem_cgroup_destroy_cache(struct kme
 static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 						  struct kmem_cache *s)
 {
-	struct kmem_cache *new = NULL;
-	static char *tmp_name = NULL;
-	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
+	struct kmem_cache *new;
+	char *tmp_name;
 
 	BUG_ON(!memcg_can_account_kmem(memcg));
 
-	mutex_lock(&mutex);
 	/*
-	 * kmem_cache_create_memcg duplicates the given name and
-	 * cgroup_name for this name requires RCU context.
-	 * This static temporary buffer is used to prevent from
-	 * pointless shortliving allocation.
+	 * kmem_cache_create_memcg duplicates the given name and cgroup_name()
+	 * for this name requires rcu_read_lock().
 	 */
-	if (!tmp_name) {
-		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (!tmp_name)
-			goto out;
-	}
+	tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!tmp_name)
+		return NULL;
 
 	rcu_read_lock();
 	snprintf(tmp_name, PATH_MAX, "%s(%d:%s)", s->name,
@@ -3430,8 +3424,7 @@ static struct kmem_cache *memcg_create_k
 		new->allocflags |= __GFP_KMEMCG;
 	else
 		new = s;
-out:
-	mutex_unlock(&mutex);
+	kfree(tmp_name);
 	return new;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

