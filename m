From: akpm@linux-foundation.org
Subject: + memcg-stop-warning-on-memcg_propagate_kmem.patch added to -mm tree
Date: Wed, 06 Feb 2013 16:22:37 -0800
Message-ID: <20130207002237.CAE3931C208@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:63924 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab3BGAWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 19:22:39 -0500
Received: by mail-oa0-f73.google.com with SMTP id o6so390665oag.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 16:22:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, glommer@parallels.com, mhocko@suse.cz


The patch titled
     Subject: memcg: stop warning on memcg_propagate_kmem
has been added to the -mm tree.  Its filename is
     memcg-stop-warning-on-memcg_propagate_kmem.patch

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
Subject: memcg: stop warning on memcg_propagate_kmem

Whilst I run the risk of a flogging for disloyalty to the Lord of Sealand,
I do have CONFIG_MEMCG=y CONFIG_MEMCG_KMEM not set, and grow tired of the
"mm/memcontrol.c:4972:12: warning: `memcg_propagate_kmem' defined but not
used [-Wunused-function]" seen in 3.8-rc: move the #ifdef outwards.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-stop-warning-on-memcg_propagate_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-stop-warning-on-memcg_propagate_kmem
+++ a/mm/memcontrol.c
@@ -5023,6 +5023,7 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MEMCG_KMEM
 static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 {
 	int ret = 0;
@@ -5031,7 +5032,6 @@ static int memcg_propagate_kmem(struct m
 		goto out;
 
 	memcg->kmem_account_flags = parent->kmem_account_flags;
-#ifdef CONFIG_MEMCG_KMEM
 	/*
 	 * When that happen, we need to disable the static branch only on those
 	 * memcgs that enabled it. To achieve this, we would be forced to
@@ -5057,10 +5057,10 @@ static int memcg_propagate_kmem(struct m
 	mutex_lock(&set_limit_mutex);
 	ret = memcg_update_cache_sizes(memcg);
 	mutex_unlock(&set_limit_mutex);
-#endif
 out:
 	return ret;
 }
+#endif /* CONFIG_MEMCG_KMEM */
 
 /*
  * The user of this function is...
_

Patches currently in -mm which might be from hughd@google.com are

mm-dont-overwrite-mm-def_flags-in-do_mlockall.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix-fix.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-make-each-swap-partition-have-one-address_space-fix-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-trivial-tidyups-fix.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-shmem-use-new-radix-tree-iterator.patch
mm-mlockc-document-scary-looking-stack-expansion-mlock-chain.patch
mmu_notifier_unregister-null-pointer-deref-and-multiple-release-callouts.patch
mm-use-up-free-swap-space-before-reaching-oom-kill.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch

