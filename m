From: akpm@linux-foundation.org
Subject: - oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:13:56 -0800
Message-ID: <200901062013.n06KDuCm011538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbZAFUOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:14:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: task lock current before dereferencing cpuset
has been removed from the -mm tree.  Its filename was
     oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch

This patch was dropped because it was folded into oom-print-triggering-tasks-cpuset-and-mems-allowed.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: task lock current before dereferencing cpuset
From: David Rientjes <rientjes@google.com>

As the comment in cpuset_print_task_mems_allowed() indicates, it's
necessary to take task_lock() on current before dereferencing its cpuset.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/oom_kill.c~oom-print-triggering-tasks-cpuset-and-mems-allowed-fix mm/oom_kill.c
--- a/mm/oom_kill.c~oom-print-triggering-tasks-cpuset-and-mems-allowed-fix
+++ a/mm/oom_kill.c
@@ -392,7 +392,9 @@ static int oom_kill_process(struct task_
 		printk(KERN_WARNING "%s invoked oom-killer: "
 			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
 			current->comm, gfp_mask, order, current->oomkilladj);
+		task_lock(current);
 		cpuset_print_task_mems_allowed(current);
+		task_unlock(current);
 		dump_stack();
 		show_mem();
 		if (sysctl_oom_dump_tasks)
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
oom-fix-zone_scan_mutex-name.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
mm-change-dirty-limit-type-specifiers-to-unsigned-long.patch
mm-add-dirty_background_bytes-and-dirty_bytes-sysctls.patch
mm-add-dirty_background_bytes-and-dirty_bytes-sysctls-fix.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch

