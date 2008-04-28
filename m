From: akpm@linux-foundation.org
Subject: - oom_kill-remove-unused-parameter-in-badness.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:02 -0700
Message-ID: <200804282154.m3SLs2c6017960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936216AbYD1VyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     oom_kill: remove unused parameter in badness()
has been removed from the -mm tree.  Its filename was
     oom_kill-remove-unused-parameter-in-badness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom_kill: remove unused parameter in badness()
From: Li Zefan <lizf@cn.fujitsu.com>

In commit 4c4a22148909e4c003562ea7ffe0a06e26919e3c, we moved the
memcontroller-related code from badness() to select_bad_process(), so the
parameter 'mem' in badness() is unused now.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~oom_kill-remove-unused-parameter-in-badness mm/oom_kill.c
--- a/mm/oom_kill.c~oom_kill-remove-unused-parameter-in-badness
+++ a/mm/oom_kill.c
@@ -53,8 +53,7 @@ static DEFINE_SPINLOCK(zone_scan_mutex);
  *    of least surprise ... (be careful when you change it)
  */
 
-unsigned long badness(struct task_struct *p, unsigned long uptime,
-			struct mem_cgroup *mem)
+unsigned long badness(struct task_struct *p, unsigned long uptime)
 {
 	unsigned long points, cpu_time, run_time, s;
 	struct mm_struct *mm;
@@ -256,7 +255,7 @@ static struct task_struct *select_bad_pr
 		if (p->oomkilladj == OOM_DISABLE)
 			continue;
 
-		points = badness(p, uptime.tv_sec, mem);
+		points = badness(p, uptime.tv_sec);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
reapply-sched-cpuset-customize-sched-domains-core-bits-fix.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
memcg-remove-redundant-initialization-in-mem_cgroup_create.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

