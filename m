From: akpm@linux-foundation.org
Subject: [folded] mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 29 May 2012 14:47:21 -0700
Message-ID: <20120529214721.4B20EA037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:34267 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2E2VrX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:47:23 -0400
Received: by eaao13 with SMTP id o13so266101eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:47:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-print-statistics-from-live-counters-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-memcg-print-statistics-from-live-counters.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-print-statistics-from-live-counters-checkpatch-fixes

WARNING: static const char * array should probably be static const char * const
#68: FILE: mm/memcontrol.c:105:
+static const char *mem_cgroup_stat_names[] = {

WARNING: static const char * array should probably be static const char * const
#84: FILE: mm/memcontrol.c:121:
+static const char *mem_cgroup_events_names[] = {

WARNING: static const char * array should probably be static const char * const
#196: FILE: mm/memcontrol.c:4316:
+static const char *mem_cgroup_lru_names[] = {

total: 0 errors, 3 warnings, 212 lines checked

./patches/mm-memcg-print-statistics-from-live-counters.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-print-statistics-from-live-counters-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-print-statistics-from-live-counters-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -102,7 +102,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_NSTATS,
 };
 
-static const char *mem_cgroup_stat_names[] = {
+static const char * const mem_cgroup_stat_names[] = {
 	"cache",
 	"rss",
 	"mapped_file",
@@ -118,7 +118,7 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_NSTATS,
 };
 
-static const char *mem_cgroup_events_names[] = {
+static const char * const mem_cgroup_events_names[] = {
 	"pgpgin",
 	"pgpgout",
 	"pgfault",
@@ -4321,13 +4321,14 @@ static int mem_control_numa_stat_show(st
 }
 #endif /* CONFIG_NUMA */
 
-static const char *mem_cgroup_lru_names[] = {
+static const char * const mem_cgroup_lru_names[] = {
 	"inactive_anon",
 	"active_anon",
 	"inactive_file",
 	"active_file",
 	"unevictable",
 };
+
 static inline void mem_cgroup_lru_names_not_uptodate(void)
 {
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
tmpfs-support-seek_data-and-seek_hole.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-memcg-print-statistics-from-live-counters.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

