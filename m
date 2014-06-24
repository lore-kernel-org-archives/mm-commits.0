From: akpm@linux-foundation.org
Subject: + page-cgroup-trivial-cleanup.patch added to -mm tree
Date: Tue, 24 Jun 2014 16:22:33 -0700
Message-ID: <53aa0839.tazZQ7nNIuPHHVul%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaFXXWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 19:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-cgroup: trivial cleanup
has been added to the -mm tree.  Its filename is
     page-cgroup-trivial-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-cgroup-trivial-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-cgroup-trivial-cleanup.patch

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
Subject: page-cgroup: trivial cleanup

Add forward declarations for struct pglist_data, mem_cgroup.

Remove __init, __meminit from function prototypes and inline functions.

Remove redundant inclusion of bit_spinlock.h.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/page_cgroup.h~page-cgroup-trivial-cleanup include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~page-cgroup-trivial-cleanup
+++ a/include/linux/page_cgroup.h
@@ -12,8 +12,10 @@ enum {
 #ifndef __GENERATING_BOUNDS_H
 #include <generated/bounds.h>
 
+struct pglist_data;
+
 #ifdef CONFIG_MEMCG
-#include <linux/bit_spinlock.h>
+struct mem_cgroup;
 
 /*
  * Page Cgroup can be considered as an extended mem_map.
@@ -27,16 +29,16 @@ struct page_cgroup {
 	struct mem_cgroup *mem_cgroup;
 };
 
-void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
+extern void pgdat_page_cgroup_init(struct pglist_data *pgdat);
 
 #ifdef CONFIG_SPARSEMEM
-static inline void __init page_cgroup_init_flatmem(void)
+static inline void page_cgroup_init_flatmem(void)
 {
 }
-extern void __init page_cgroup_init(void);
+extern void page_cgroup_init(void);
 #else
-void __init page_cgroup_init_flatmem(void);
-static inline void __init page_cgroup_init(void)
+extern void page_cgroup_init_flatmem(void);
+static inline void page_cgroup_init(void)
 {
 }
 #endif
@@ -48,11 +50,10 @@ static inline int PageCgroupUsed(struct
 {
 	return !!(pc->flags & PCG_USED);
 }
-
-#else /* CONFIG_MEMCG */
+#else /* !CONFIG_MEMCG */
 struct page_cgroup;
 
-static inline void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
+static inline void pgdat_page_cgroup_init(struct pglist_data *pgdat)
 {
 }
 
@@ -65,10 +66,9 @@ static inline void page_cgroup_init(void
 {
 }
 
-static inline void __init page_cgroup_init_flatmem(void)
+static inline void page_cgroup_init_flatmem(void)
 {
 }
-
 #endif /* CONFIG_MEMCG */
 
 #include <linux/swap.h>
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
slub-fix-off-by-one-in-number-of-slab-tests.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
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
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

