From: akpm@linux-foundation.org
Subject: + vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch added to -mm tree
Date: Mon, 14 Jul 2008 16:49:52 -0700
Message-ID: <200807142349.m6ENnqfM001313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759810AbYGNXu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 19:50:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, ak@linux.intel.com, gregkh@suse.de, hugh@veritas.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     adapt vmscan-unevictable-lru-scan-sysctl.patch to new sysfs API
has been added to the -mm tree.  Its filename is
     vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adapt vmscan-unevictable-lru-scan-sysctl.patch to new sysfs API
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The second attribute parameter is missing in
read_scan_unevictable_node()/write_scan_unevictable_node().
which has been added recently.

	mm/vmscan.c:2654: warning: initialization from incompatible pointer type
	mm/vmscan.c:2654: warning: initialization from incompatible pointer type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter mm/vmscan.c
--- a/mm/vmscan.c~vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter
+++ a/mm/vmscan.c
@@ -2611,12 +2611,15 @@ int scan_unevictable_handler(struct ctl_
  * a specified node's per zone unevictable lists for evictable pages.
  */
 
-static ssize_t read_scan_unevictable_node(struct sys_device *dev, char *buf)
+static ssize_t read_scan_unevictable_node(struct sys_device *dev,
+					  struct sysdev_attribute *attr,
+					  char *buf)
 {
 	return sprintf(buf, "0\n");	/* always zero; should fit... */
 }
 
 static ssize_t write_scan_unevictable_node(struct sys_device *dev,
+					   struct sysdev_attribute *attr,
 					const char *buf, size_t count)
 {
 	struct zone *node_zones = NODE_DATA(dev->id)->node_zones;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

adapt-drivers-base-topologyc-to-new-sysfs-api.patch
ia64-hp-sim-simserialc-adapt-to-new-tty-framework.patch
ahci-use-correct-type-for-cpu-flags.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
mm-make-config_migration-available-w-o-config_numa-fix.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

