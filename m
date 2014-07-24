From: akpm@linux-foundation.org
Subject: +
 mm-slub-fix-false-positive-lockdep-warning-in-free_partial.patch added to
 -mm tree
Date: Thu, 24 Jul 2014 13:55:06 -0700
Message-ID: <53d172aa.1QYSn9Vv+QFx3W4t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46747 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553AbaGXUzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 16:55:07 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so586541qaq.3
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 13:55:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix false-positive lockdep warning in free_partial()
has been added to the -mm tree.  Its filename is
     mm-slub-fix-false-positive-lockdep-warning-in-free_partial.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-false-positive-lockdep-warning-in-free_partial.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-false-positive-lockdep-warning-in-free_partial.patch

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
Subject: mm, slub: fix false-positive lockdep warning in free_partial()

Commit c65c1877bd68 ("slub: use lockdep_assert_held") requires
remove_partial() to be called with n->list_lock held, but free_partial()
called from kmem_cache_close() on cache destruction does not follow this
rule, leading to a warning:

  WARNING: CPU: 0 PID: 2787 at mm/slub.c:1536 __kmem_cache_shutdown+0x1b2/0x1f0()
  Modules linked in:
  CPU: 0 PID: 2787 Comm: modprobe Tainted: G        W    3.14.0-rc1-mm1+ #1
  Hardware name:
   0000000000000600 ffff88003ae1dde8 ffffffff816d9583 0000000000000600
   0000000000000000 ffff88003ae1de28 ffffffff8107c107 0000000000000000
   ffff880037ab2b00 ffff88007c240d30 ffffea0001ee5280 ffffea0001ee52a0
  Call Trace:
   [<ffffffff816d9583>] dump_stack+0x51/0x6e
   [<ffffffff8107c107>] warn_slowpath_common+0x87/0xb0
   [<ffffffff8107c145>] warn_slowpath_null+0x15/0x20
   [<ffffffff811c7fe2>] __kmem_cache_shutdown+0x1b2/0x1f0
   [<ffffffff811908d3>] kmem_cache_destroy+0x43/0xf0
   [<ffffffffa013a123>] xfs_destroy_zones+0x103/0x110 [xfs]
   [<ffffffffa0192b54>] exit_xfs_fs+0x38/0x4e4 [xfs]
   [<ffffffff811036fa>] SyS_delete_module+0x19a/0x1f0
   [<ffffffff816dfcd8>] ? retint_swapgs+0x13/0x1b
   [<ffffffff810d2125>] ? trace_hardirqs_on_caller+0x105/0x1d0
   [<ffffffff81359efe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
   [<ffffffff816e8539>] system_call_fastpath+0x16/0x1b

Although this cannot actually result in a race, because on cache
destruction there should not be any concurrent frees or allocations from
the cache, let's add spin_lock/unlock to free_partial() just to keep
lockdep happy.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~mm-slub-fix-false-positive-lockdep-warning-in-free_partial mm/slub.c
--- a/mm/slub.c~mm-slub-fix-false-positive-lockdep-warning-in-free_partial
+++ a/mm/slub.c
@@ -3166,12 +3166,13 @@ static void list_slab_objects(struct kme
 /*
  * Attempt to free all partial slabs on a node.
  * This is called from kmem_cache_close(). We must be the last thread
- * using the cache and therefore we do not need to lock anymore.
+ * using the cache, but we still have to lock for lockdep's sake.
  */
 static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
 {
 	struct page *page, *h;
 
+	spin_lock_irq(&n->list_lock);
 	list_for_each_entry_safe(page, h, &n->partial, lru) {
 		if (!page->inuse) {
 			__remove_partial(n, page);
@@ -3181,6 +3182,7 @@ static void free_partial(struct kmem_cac
 			"Objects remaining in %s on kmem_cache_close()");
 		}
 	}
+	spin_unlock_irq(&n->list_lock);
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-fix-false-positive-lockdep-warning-in-free_partial.patch
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

