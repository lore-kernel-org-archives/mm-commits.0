From: akpm@linux-foundation.org
Subject: + mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch added to -mm tree
Date: Thu, 26 Apr 2012 14:18:53 -0700
Message-ID: <20120426211853.41CF8A0533@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41595 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2DZVSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 17:18:55 -0400
Received: by wibhj13 with SMTP id hj13so2130wib.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 14:18:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, lwoodman@redhat.com, mel@csn.ul.ie, mkosaki@redhat.com, riel@redhat.com


The patch titled
     Subject: mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix
has been added to the -mm tree.  Its filename is
     mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch

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
Subject: mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix

clean up comment layout

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <mkosaki@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/mempolicy.c~mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix
+++ a/mm/mempolicy.c
@@ -1014,18 +1014,18 @@ int do_migrate_pages(struct mm_struct *m
 		for_each_node_mask(s, tmp) {
 
 			/*
-			 * do_migrate_pages() tries to maintain the
-			 * relative node relationship of the pages
-			 * established between threads and memory areas.
+			 * do_migrate_pages() tries to maintain the relative
+			 * node relationship of the pages established between
+			 * threads and memory areas.
                          *
-			 * However if the number of source nodes is not
-			 * equal to the number of destination nodes we
-			 * can not preserve this node relative relationship.
-			 * In that case, skip copying memory from a node that
-			 * is in the destination mask.
+			 * However if the number of source nodes is not equal to
+			 * the number of destination nodes we can not preserve
+			 * this node relative relationship.  In that case, skip
+			 * copying memory from a node that is in the destination
+			 * mask.
 			 *
 			 * Example: [2,3,4] -> [3,4,5] moves everything.
-			 *                 [0-7] - > [3,4,5] moves only 0,1,2,6,7.
+			 *          [0-7] - > [3,4,5] moves only 0,1,2,6,7.
 			 */
 
 			if ((nodes_weight(*from_nodes) != nodes_weight(*to_nodes)) &&
_
Subject: Subject: mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
sound-usb-endpointc-suppress-warning.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
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
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

