From: akpm@linux-foundation.org
Subject: + mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch
 added to -mm tree
Date: Tue, 01 Jul 2014 13:24:09 -0700
Message-ID: <53b318e9.syb838YX50gYTLQL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:36674 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427AbaGAUYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 16:24:11 -0400
Received: by mail-ie0-f201.google.com with SMTP id lx4so2340899iec.2
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 13:24:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix

Add comments on the private use of -EAGAIN.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix mm/shmem.c
--- a/mm/shmem.c~mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix
+++ a/mm/shmem.c
@@ -594,7 +594,7 @@ static int shmem_unuse_inode(struct shme
 	radswap = swp_to_radix_entry(swap);
 	index = radix_tree_locate_item(&mapping->page_tree, radswap);
 	if (index == -1)
-		return -EAGAIN;
+		return -EAGAIN;	/* tell shmem_unuse we found nothing */
 
 	/*
 	 * Move _head_ to start search for next from here.
@@ -695,6 +695,7 @@ int shmem_unuse(swp_entry_t swap, struct
 		cond_resched();
 		if (error != -EAGAIN)
 			break;
+		/* found nothing in this: move on to search the next */
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
 
_

Patches currently in -mm which might be from hughd@google.com are

shmem-fix-init_page_accessed-use-to-stop-pagelru-bug.patch
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
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

