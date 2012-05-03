From: akpm@linux-foundation.org
Subject: + mm-page_allocc-remove-pageblock_default_order.patch added to -mm tree
Date: Thu, 03 May 2012 16:41:24 -0700
Message-ID: <20120503234126.1C81EA00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:42237 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab2ECXl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2012 19:41:28 -0400
Received: by qcsp5 with SMTP id p5so259148qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 03 May 2012 16:41:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, rajman.mekaco@gmail.com, tj@kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove pageblock_default_order()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-remove-pageblock_default_order.patch

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
Subject: mm/page_alloc.c: remove pageblock_default_order()

This has always been broken: one version takes an unsigned int and the
other version takes no arguments.  This bug was hidden because one version
of set_pageblock_order() was a macro which doesn't evaluate its argument.

Simplify it all and remove pageblock_default_order() altogether.

Reported-by: rajman mekaco <rajman.mekaco@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-remove-pageblock_default_order mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-remove-pageblock_default_order
+++ a/mm/page_alloc.c
@@ -4300,25 +4300,24 @@ static inline void setup_usemap(struct p
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
-/* Return a sensible default order for the pageblock size. */
-static inline int pageblock_default_order(void)
-{
-	if (HPAGE_SHIFT > PAGE_SHIFT)
-		return HUGETLB_PAGE_ORDER;
-
-	return MAX_ORDER-1;
-}
-
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-static inline void __init set_pageblock_order(unsigned int order)
+static inline void __init set_pageblock_order(void)
 {
+	unsigned int order;
+
 	/* Check that pageblock_nr_pages has not already been setup */
 	if (pageblock_order)
 		return;
 
+	if (HPAGE_SHIFT > PAGE_SHIFT)
+		order = HUGETLB_PAGE_ORDER;
+	else
+		order = MAX_ORDER - 1;
+
 	/*
 	 * Assume the largest contiguous order of interest is a huge page.
-	 * This value may be variable depending on boot parameters on IA64
+	 * This value may be variable depending on boot parameters on IA64 and
+	 * powerpc.
 	 */
 	pageblock_order = order;
 }
@@ -4326,15 +4325,13 @@ static inline void __init set_pageblock_
 
 /*
  * When CONFIG_HUGETLB_PAGE_SIZE_VARIABLE is not set, set_pageblock_order()
- * and pageblock_default_order() are unused as pageblock_order is set
- * at compile-time. See include/linux/pageblock-flags.h for the values of
- * pageblock_order based on the kernel config
+ * is unused as pageblock_order is set at compile-time. See
+ * include/linux/pageblock-flags.h for the values of pageblock_order based on
+ * the kernel config
  */
-static inline int pageblock_default_order(unsigned int order)
+static inline void set_pageblock_order(void)
 {
-	return MAX_ORDER-1;
 }
-#define set_pageblock_order(x)	do {} while (0)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
@@ -4422,7 +4419,7 @@ static void __paginginit free_area_init_
 		if (!size)
 			continue;
 
-		set_pageblock_order(pageblock_default_order());
+		set_pageblock_order();
 		setup_usemap(pgdat, zone, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
_
Subject: Subject: mm/page_alloc.c: remove pageblock_default_order()

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
drivers-gpu-drm-gma500-mdfld_devicec-fix-build.patch
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
mm-page_allocc-remove-pageblock_default_order.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
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
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
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

