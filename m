From: akpm@linux-foundation.org
Subject: [folded-merged] mm-memcontrol-rewrite-uncharge-api-fix-5.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 13:56:10 -0700
Message-ID: <53e2966a.59FmHJngqK0bESip%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:50572 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaHFU4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 16:56:11 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so588090obc.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 13:56:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: page-cgroup: fix flags definition
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-uncharge-api-fix-5.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-uncharge-api.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: page-cgroup: fix flags definition

Since commit a9ce315aaec1f ("mm: memcontrol: rewrite uncharge API"),
PCG_* flags are used as bit masks, but they are still defined in a enum
as bit numbers. Fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/page_cgroup.h~mm-memcontrol-rewrite-uncharge-api-fix-5 include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~mm-memcontrol-rewrite-uncharge-api-fix-5
+++ a/include/linux/page_cgroup.h
@@ -3,9 +3,9 @@
 
 enum {
 	/* flags for mem_cgroup */
-	PCG_USED,	/* This page is charged to a memcg */
-	PCG_MEM,	/* This page holds a memory charge */
-	PCG_MEMSW,	/* This page holds a memory+swap charge */
+	PCG_USED = 0x01,	/* This page is charged to a memcg */
+	PCG_MEM = 0x02,		/* This page holds a memory charge */
+	PCG_MEMSW = 0x04,	/* This page holds a memory+swap charge */
 	__NR_PCG_FLAGS,
 };
 
@@ -46,7 +46,7 @@ struct page *lookup_cgroup_page(struct p
 
 static inline int PageCgroupUsed(struct page_cgroup *pc)
 {
-	return test_bit(PCG_USED, &pc->flags);
+	return !!(pc->flags & PCG_USED);
 }
 
 #else /* CONFIG_MEMCG */
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
fork-make-mm_init_owner-static.patch
linux-next.patch

