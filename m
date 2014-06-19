From: akpm@linux-foundation.org
Subject: + fork-reset-mm-pinned_vm.patch added to -mm tree
Date: Thu, 19 Jun 2014 13:59:21 -0700
Message-ID: <53a34f29.nVuhSJvi8gJt4jGH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaFSU7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jun 2014 16:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, oleg@redhat.com, cl@linux.com, vdavydov@parallels.com


The patch titled
     Subject: fork: reset mm->pinned_vm
has been added to the -mm tree.  Its filename is
     fork-reset-mm-pinned_vm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fork-reset-mm-pinned_vm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fork-reset-mm-pinned_vm.patch

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
Subject: fork: reset mm->pinned_vm

mm->pinned_vm counts pages of mm's address space that were permanently
pinned in memory by increasing their reference counter. The counter was
introduced by commit bc3e53f682d9 ("mm: distinguish between mlocked and
pinned pages"), while before it locked_vm had been used for such pages.

Obviously, we should reset the counter on fork if !CLONE_VM, just like
we do with locked_vm, but currently we don't. Let's fix it.

This patch will fix the contents of /proc/pid/status:VmPin.  It has no
other effect.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/fork.c~fork-reset-mm-pinned_vm kernel/fork.c
--- a/kernel/fork.c~fork-reset-mm-pinned_vm
+++ a/kernel/fork.c
@@ -534,6 +534,7 @@ static struct mm_struct *mm_init(struct
 	atomic_long_set(&mm->nr_ptes, 0);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
+	mm->pinned_vm = 0;
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
 	mm_init_cpumask(mm);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-fix-oops-when-reading-proc-slab_allocators.patch
slab-fix-oops-when-reading-proc-slab_allocators-v2.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
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
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

