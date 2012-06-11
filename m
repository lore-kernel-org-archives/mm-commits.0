From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-hugetlb-extension-fix-fix.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:09:50 -0700
Message-ID: <20120611210950.8E7FEA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37362 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2FKVJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:09:52 -0400
Received: by vcbfl13 with SMTP id fl13so414988vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:09:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-hugetlb-extension-fix-fix
has been removed from the -mm tree.  Its filename was
     memcg-add-hugetlb-extension-fix-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-add-hugetlb-extension-fix-fix

optimise CONFIG_HUGETLB_PAGE=y, CONFIG_MEM_RES_CTLR_HUGETLB=n

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-hugetlb-extension-fix-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-hugetlb-extension-fix-fix
+++ a/mm/memcontrol.c
@@ -57,6 +57,16 @@
 
 #include <trace/events/vmscan.h>
 
+/*
+ * If CONFIG_MEM_RES_CTLR_HUGETLB=n, CONFIG_HUGETLB_PAGE=y we can avoid
+ * generating any code or storage for the resource counters
+ */
+#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
+#define NR_HUGEPAGE_RES_COUNTERS HUGE_MAX_HSTATE
+#else
+#define NR_HUGEPAGE_RES_COUNTERS 0
+#endif
+
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 static struct mem_cgroup *root_mem_cgroup __read_mostly;
@@ -267,7 +277,7 @@ struct mem_cgroup {
 	/*
 	 * the counter to account for hugepages from hugetlb.
 	 */
-	struct res_counter hugepage[HUGE_MAX_HSTATE];
+	struct res_counter hugepage[NR_HUGEPAGE_RES_COUNTERS];
 	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
@@ -5016,9 +5026,9 @@ mem_cgroup_create(struct cgroup *cont)
 		mem_cgroup_get(parent);
 		/*
 		 * We could get called before hugetlb init is called.
-		 * Use HUGE_MAX_HSTATE as the max index.
+		 * Use NR_HUGEPAGE_RES_COUNTERS as the max index.
 		 */
-		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
+		for (idx = 0; idx < NR_HUGEPAGE_RES_COUNTERS; idx++)
 			res_counter_init(&memcg->hugepage[idx],
 					 &parent->hugepage[idx]);
 	} else {
@@ -5026,9 +5036,9 @@ mem_cgroup_create(struct cgroup *cont)
 		res_counter_init(&memcg->memsw, NULL);
 		/*
 		 * We could get called before hugetlb init is called.
-		 * Use HUGE_MAX_HSTATE as the max index.
+		 * Use NR_HUGEPAGE_RES_COUNTERS as the max index.
 		 */
-		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
+		for (idx = 0; idx < NR_HUGEPAGE_RES_COUNTERS; idx++)
 			res_counter_init(&memcg->hugepage[idx], NULL);
 	}
 	memcg->last_scanned_node = MAX_NUMNODES;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

