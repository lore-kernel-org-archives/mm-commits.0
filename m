From: akpm@linux-foundation.org
Subject: [merged] mm-oom_kill-introduce-is_sysrq_oom-helper.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:44:08 -0800
Message-ID: <5640f788.XwIpUxfj7+FtViKT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbbKIToJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: introduce is_sysrq_oom helper
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-introduce-is_sysrq_oom-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/oom_kill.c: introduce is_sysrq_oom helper

Introduce is_sysrq_oom helper function indicating oom kill triggered
by sysrq to improve readability.

No functional changes.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_kill-introduce-is_sysrq_oom-helper mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-introduce-is_sysrq_oom-helper
+++ a/mm/oom_kill.c
@@ -118,6 +118,15 @@ found:
 	return t;
 }
 
+/*
+ * order == -1 means the oom kill is required by sysrq, otherwise only
+ * for display purposes.
+ */
+static inline bool is_sysrq_oom(struct oom_control *oc)
+{
+	return oc->order == -1;
+}
+
 /* return true if the task is not adequate as candidate victim task. */
 static bool oom_unkillable_task(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask)
@@ -265,7 +274,7 @@ enum oom_scan_t oom_scan_process_thread(
 	 * Don't allow any other task to have access to the reserves.
 	 */
 	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
-		if (oc->order != -1)
+		if (!is_sysrq_oom(oc))
 			return OOM_SCAN_ABORT;
 	}
 	if (!task->mm)
@@ -278,7 +287,7 @@ enum oom_scan_t oom_scan_process_thread(
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task_will_free_mem(task) && oc->order != -1)
+	if (task_will_free_mem(task) && !is_sysrq_oom(oc))
 		return OOM_SCAN_ABORT;
 
 	return OOM_SCAN_OK;
@@ -629,7 +638,7 @@ void check_panic_on_oom(struct oom_contr
 			return;
 	}
 	/* Do not panic for oom kills triggered by sysrq */
-	if (oc->order == -1)
+	if (is_sysrq_oom(oc))
 		return;
 	dump_header(oc, NULL, memcg);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
@@ -709,7 +718,7 @@ bool out_of_memory(struct oom_control *o
 
 	p = select_bad_process(oc, &points, totalpages);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
-	if (!p && oc->order != -1) {
+	if (!p && !is_sysrq_oom(oc)) {
 		dump_header(oc, NULL, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
_

Patches currently in -mm which might be from bywxiaobai@163.com are

fs-kdev_t-remove-unused-huge_valid_dev-function.patch
fs-kdev_t-old-new_valid_dev-can-be-boolean.patch
fs-vfs-remove-unnecessary-new_valid_dev-check.patch
fs-btrfs-remove-unnecessary-new_valid_dev-check.patch
fs-exofs-remove-unnecessary-new_valid_dev-check.patch
fs-ext2-remove-unnecessary-new_valid_dev-check.patch
fs-f2fs-remove-unnecessary-new_valid_dev-check.patch
fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
fs-jfs-remove-unnecessary-new_valid_dev-check.patch
fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
fs-nilfs2-remove-unnecessary-new_valid_dev-check.patch
fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch
fs-stat-remove-unnecessary-new_valid_dev-check.patch
fs-ubifs-remove-unnecessary-new_valid_dev-check.patch

