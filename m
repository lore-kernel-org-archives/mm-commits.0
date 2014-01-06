From: akpm@linux-foundation.org
Subject: + slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch added
 to -mm tree
Date: Mon, 06 Jan 2014 14:56:27 -0800
Message-ID: <52cb349b.9MXQ4Dp7SdNEi33D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933617AbaAFW42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 17:56:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, vdavydov@parallels.com

Subject: + slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch added to -mm tree
To: vdavydov@parallels.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 14:56:27 -0800


The patch titled
     Subject: slab: do not panic if we fail to create memcg cache
has been added to the -mm tree.  Its filename is
     slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch

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
Subject: slab: do not panic if we fail to create memcg cache

There is no point in flooding logs with warnings or especially crashing
the system if we fail to create a cache for a memcg.  In this case we will
be accounting the memcg allocation to the root cgroup until we succeed to
create its own cache, but it isn't that critical.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/slab_common.c~slab-do-not-panic-if-we-fail-to-create-memcg-cache mm/slab_common.c
--- a/mm/slab_common.c~slab-do-not-panic-if-we-fail-to-create-memcg-cache
+++ a/mm/slab_common.c
@@ -233,7 +233,14 @@ out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-	if (err) {
+	/*
+	 * There is no point in flooding logs with warnings or especially
+	 * crashing the system if we fail to create a cache for a memcg. In
+	 * this case we will be accounting the memcg allocation to the root
+	 * cgroup until we succeed to create its own cache, but it isn't that
+	 * critical.
+	 */
+	if (err && !memcg) {
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
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

