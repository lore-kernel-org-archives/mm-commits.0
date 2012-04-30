From: akpm@linux-foundation.org
Subject: + memcg-add-hugetlb-extension-fix-fix.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:20:24 -0700
Message-ID: <20120430232024.826F2A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42249 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884Ab2D3XU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 19:20:27 -0400
Received: by eaaq10 with SMTP id q10so171673eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:20:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg-add-hugetlb-extension-fix-fix
has been added to the -mm tree.  Its filename is
     memcg-add-hugetlb-extension-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 struct mem_cgroup *root_mem_cgroup __read_mostly;
@@ -254,7 +264,7 @@ struct mem_cgroup {
 	/*
 	 * the counter to account for hugepages from hugetlb.
 	 */
-	struct res_counter hugepage[HUGE_MAX_HSTATE];
+	struct res_counter hugepage[NR_HUGEPAGE_RES_COUNTERS];
 	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
@@ -5106,9 +5116,9 @@ mem_cgroup_create(struct cgroup *cont)
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
@@ -5116,9 +5126,9 @@ mem_cgroup_create(struct cgroup *cont)
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
Subject: Subject: memcg-add-hugetlb-extension-fix-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

