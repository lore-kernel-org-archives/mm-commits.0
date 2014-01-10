From: akpm@linux-foundation.org
Subject: + memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch
 added to -mm tree
Date: Fri, 10 Jan 2014 13:57:21 -0800
Message-ID: <52d06cc1.vz8oPBtE5fgOnBoQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaAJV5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 16:57:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, vdavydov@parallels.com

Subject: + memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch added to -mm tree
To: vdavydov@parallels.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 13:57:21 -0800


The patch titled
     Subject: memcg-rework-memcg_update_kmem_limit-synchronization-fix
has been added to the -mm tree.  Its filename is
     memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch

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
Subject: memcg-rework-memcg_update_kmem_limit-synchronization-fix

mm/memcontrol.c: In function 'mem_cgroup_css_online':
mm/memcontrol.c:5884:5: warning: 'ret' may be used uninitialized in this
function [-Wmaybe-uninitialized]

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-rework-memcg_update_kmem_limit-synchronization-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rework-memcg_update_kmem_limit-synchronization-fix
+++ a/mm/memcontrol.c
@@ -5189,7 +5189,7 @@ static int memcg_update_kmem_limit(struc
 
 static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 {
-	int ret;
+	int ret = 0;
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	if (!parent)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

fs-superc-fix-warn-on-alloc_super-fail-path.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
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
linux-next.patch

