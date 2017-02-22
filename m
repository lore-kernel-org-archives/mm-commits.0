From: akpm@linux-foundation.org
Subject: [folded-merged]
 slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix.patch removed from -mm tree
Date: Wed, 22 Feb 2017 15:17:11 -0800
Message-ID: <58ae1bf7.veZNlWws0ZVlbvN1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45132 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933898AbdBVXSq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:18:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix
has been removed from the -mm tree.  Its filename was
     slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix.patch

This patch was dropped because it was folded into slub-make-sysfs-directories-for-memcg-sub-caches-optional.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix

kset_unregister(NULL) is legal

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slub.c~slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix mm/slub.c
--- a/mm/slub.c~slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix
+++ a/mm/slub.c
@@ -5703,8 +5703,7 @@ static void sysfs_slab_remove(struct kme
 		return;
 
 #ifdef CONFIG_MEMCG
-	if (s->memcg_kset)
-		kset_unregister(s->memcg_kset);
+	kset_unregister(s->memcg_kset);
 #endif
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slub-make-sysfs-directories-for-memcg-sub-caches-optional.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch

