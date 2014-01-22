From: akpm@linux-foundation.org
Subject: [merged] fs-superc-fix-warn-on-alloc_super-fail-path.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:11 -0800
Message-ID: <52e0261b.5MuJulT0pGQLYJXg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbaAVUMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, vdavydov@parallels.com

Subject: [merged] fs-superc-fix-warn-on-alloc_super-fail-path.patch removed from -mm tree
To: vdavydov@parallels.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:11 -0800


The patch titled
     Subject: fs/super.c: fix WARN on alloc_super() fail path
has been removed from the -mm tree.  Its filename was
     fs-superc-fix-warn-on-alloc_super-fail-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: fs/super.c: fix WARN on alloc_super() fail path

On fail path alloc_super() calls destroy_super(), which issues a warning
if the sb's s_mounts list is not empty, in particular if it has not been
initialized.  That said s_mounts must be initialized in alloc_super()
before any possible failure, but currently it is initialized close to the
end of the function leading to a useless warning dumped to log if either
percpu_counter_init() or list_lru_init() fails.  Let's fix this.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/super.c~fs-superc-fix-warn-on-alloc_super-fail-path fs/super.c
--- a/fs/super.c~fs-superc-fix-warn-on-alloc_super-fail-path
+++ a/fs/super.c
@@ -166,6 +166,8 @@ static struct super_block *alloc_super(s
 	if (!s)
 		return NULL;
 
+	INIT_LIST_HEAD(&s->s_mounts);
+
 	if (security_sb_alloc(s))
 		goto fail;
 
@@ -188,7 +190,6 @@ static struct super_block *alloc_super(s
 	if (list_lru_init(&s->s_inode_lru))
 		goto fail;
 
-	INIT_LIST_HEAD(&s->s_mounts);
 	init_rwsem(&s->s_umount);
 	lockdep_set_class(&s->s_umount, &type->s_umount_key);
 	/*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch
linux-next.patch

