From: akpm@linux-foundation.org
Subject: + page-cgroup-get-rid-of-nr_pcg_flags.patch added to -mm tree
Date: Tue, 24 Jun 2014 16:23:47 -0700
Message-ID: <53aa0883.vdnLsc+M+h3epGK9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaFXXXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 19:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-cgroup: get rid of NR_PCG_FLAGS
has been added to the -mm tree.  Its filename is
     page-cgroup-get-rid-of-nr_pcg_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-cgroup-get-rid-of-nr_pcg_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-cgroup-get-rid-of-nr_pcg_flags.patch

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
Subject: page-cgroup: get rid of NR_PCG_FLAGS

It's not used anywhere today, so let's remove it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    6 ------
 kernel/bounds.c             |    2 --
 2 files changed, 8 deletions(-)

diff -puN include/linux/page_cgroup.h~page-cgroup-get-rid-of-nr_pcg_flags include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~page-cgroup-get-rid-of-nr_pcg_flags
+++ a/include/linux/page_cgroup.h
@@ -6,12 +6,8 @@ enum {
 	PCG_USED = 0x01,	/* This page is charged to a memcg */
 	PCG_MEM = 0x02,		/* This page holds a memory charge */
 	PCG_MEMSW = 0x04,	/* This page holds a memory+swap charge */
-	__NR_PCG_FLAGS,
 };
 
-#ifndef __GENERATING_BOUNDS_H
-#include <generated/bounds.h>
-
 struct pglist_data;
 
 #ifdef CONFIG_MEMCG
@@ -107,6 +103,4 @@ static inline void swap_cgroup_swapoff(i
 
 #endif /* CONFIG_MEMCG_SWAP */
 
-#endif /* !__GENERATING_BOUNDS_H */
-
 #endif /* __LINUX_PAGE_CGROUP_H */
diff -puN kernel/bounds.c~page-cgroup-get-rid-of-nr_pcg_flags kernel/bounds.c
--- a/kernel/bounds.c~page-cgroup-get-rid-of-nr_pcg_flags
+++ a/kernel/bounds.c
@@ -9,7 +9,6 @@
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
 #include <linux/kbuild.h>
-#include <linux/page_cgroup.h>
 #include <linux/log2.h>
 #include <linux/spinlock_types.h>
 
@@ -18,7 +17,6 @@ void foo(void)
 	/* The enum constants to put into include/generated/bounds.h */
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
-	DEFINE(NR_PCG_FLAGS, __NR_PCG_FLAGS);
 #ifdef CONFIG_SMP
 	DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
 #endif
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

