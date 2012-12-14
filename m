From: akpm@linux-foundation.org
Subject: [merged] mm-oom-remove-redundant-sleep-in-pagefault-oom-handler.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:24 -0800
Message-ID: <20121214232924.9EFDE82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42253 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab2LNX3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:25 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so409514ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove redundant sleep in pagefault oom handler
has been removed from the -mm tree.  Its filename was
     mm-oom-remove-redundant-sleep-in-pagefault-oom-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: remove redundant sleep in pagefault oom handler

out_of_memory() will already cause current to schedule if it has not been
killed, so doing it again in pagefault_out_of_memory() is redundant. 
Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom-remove-redundant-sleep-in-pagefault-oom-handler mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-remove-redundant-sleep-in-pagefault-oom-handler
+++ a/mm/oom_kill.c
@@ -683,5 +683,4 @@ void pagefault_out_of_memory(void)
 		out_of_memory(NULL, 0, 0, NULL, false);
 		clear_zonelist_oom(zonelist, GFP_KERNEL);
 	}
-	schedule_timeout_killable(1);
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
irq-tsk-comm-is-an-array.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears-simplify-ida-initialization.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch
ksm-numa-awareness-sysfs-knob.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

