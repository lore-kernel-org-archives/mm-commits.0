From: akpm@linux-foundation.org
Subject: - ia64-use-goto-to-jump-out-do-while_each_thread.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:28 -0700
Message-ID: <200804102001.m3AK1SGB014975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758680AbYDJUCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:02:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: use goto to jump out do/while_each_thread
has been removed from the -mm tree.  Its filename was
     ia64-use-goto-to-jump-out-do-while_each_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: use goto to jump out do/while_each_thread
From: Li Zefan <lizf@cn.fujitsu.com>

do_each_thread/while_each_thread is a double loop, so should use 'goto' rather
than 'break' to break out the loop.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~ia64-use-goto-to-jump-out-do-while_each_thread arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~ia64-use-goto-to-jump-out-do-while_each_thread
+++ a/arch/ia64/kernel/perfmon.c
@@ -4204,10 +4204,10 @@ pfm_check_task_exist(pfm_context_t *ctx)
 	do_each_thread (g, t) {
 		if (t->thread.pfm_context == ctx) {
 			ret = 0;
-			break;
+			goto out;
 		}
 	} while_each_thread (g, t);
-
+out:
 	read_unlock(&tasklist_lock);
 
 	DPRINT(("pfm_check_task_exist: ret=%d ctx=%p\n", ret, ctx));
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
git-ia64.patch
git-net.patch
oom_kill-remove-unused-parameter-in-badness.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
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
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

