From: akpm@linux-foundation.org
Subject: [folded-merged]
 shmem-fix-faulting-into-a-hole-not-taking-i_mutex-fix.patch removed from
 -mm tree
Date: Wed, 23 Jul 2014 13:57:59 -0700
Message-ID: <53d021d7.vVgvjW/WUo/VeWQw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:41782 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047AbaGWU6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jul 2014 16:58:01 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so107368ykb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 Jul 2014 13:58:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix faulting into a hole, not taking i_mutex: fix
has been removed from the -mm tree.  Its filename was
     shmem-fix-faulting-into-a-hole-not-taking-i_mutex-fix.patch

This patch was dropped because it was folded into shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix faulting into a hole, not taking i_mutex: fix

Sasha reports various nasty trinity crashes when shmem_fault() tries to
finish_wait(), we guess from rare cases when the wait_queue_head on
shmem_fallocate()'s stack has already gone.  Fix those by using
TASK_UNINTERRUPIBLE instead of TASK_KILLABLE in prepare_to_wait(), that's
much simpler and safer: TASK_KILLABLE was a nice aspiration, but not worth
any more hassle.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~shmem-fix-faulting-into-a-hole-not-taking-i_mutex-fix mm/shmem.c
--- a/mm/shmem.c~shmem-fix-faulting-into-a-hole-not-taking-i_mutex-fix
+++ a/mm/shmem.c
@@ -1283,7 +1283,7 @@ static int shmem_fault(struct vm_area_st
 
 			shmem_falloc_waitq = shmem_falloc->waitq;
 			prepare_to_wait(shmem_falloc_waitq, &shmem_fault_wait,
-					TASK_KILLABLE);
+					TASK_UNINTERRUPTIBLE);
 			spin_unlock(&inode->i_lock);
 			schedule();
 
_

Patches currently in -mm which might be from hughd@google.com are

rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
mm-do-not-call-do_fault_around-for-non-linear-fault.patch
shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch
shmem-fix-splicing-from-a-hole-while-its-punched.patch
mm-fs-fix-pessimization-in-hole-punching-pagecache.patch
simple_xattr-permit-0-size-extended-attributes.patch
mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
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
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

