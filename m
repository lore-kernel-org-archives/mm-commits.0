From: akpm@linux-foundation.org
Subject: + fs-superc-fix-warn-on-alloc_super-fail-path.patch added to -mm
 tree
Date: Wed, 08 Jan 2014 14:16:05 -0800
Message-ID: <52cdce25.cVmaoZQPUh7Ampyq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351AbaAHWQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 17:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, vdavydov@parallels.com

Subject: + fs-superc-fix-warn-on-alloc_super-fail-path.patch added to -mm tree
To: vdavydov@parallels.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 14:16:05 -0800


The patch titled
     Subject: fs/super.c: fix WARN on alloc_super() fail path
has been added to the -mm tree.  Its filename is
     fs-superc-fix-warn-on-alloc_super-fail-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-superc-fix-warn-on-alloc_super-fail-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-superc-fix-warn-on-alloc_super-fail-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
linux-next.patch
fs-superc-fix-warn-on-alloc_super-fail-path.patch

