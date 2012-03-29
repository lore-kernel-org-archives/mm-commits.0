From: akpm@linux-foundation.org
Subject: [merged] procfs-fix-proc-statm.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:18 -0700
Message-ID: <20120329191318.8B076A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65312 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464Ab2C2TNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:20 -0400
Received: by yenq2 with SMTP id q2so303047yen.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, drepper@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: fix /proc/statm
has been removed from the -mm tree.  Its filename was
     procfs-fix-proc-statm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: procfs: fix /proc/statm

bda7bad62bc4 ("procfs: speed up /proc/pid/stat, statm") broke /proc/statm
- 'text' is printed twice by mistake.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/array.c~procfs-fix-proc-statm fs/proc/array.c
--- a/fs/proc/array.c~procfs-fix-proc-statm
+++ a/fs/proc/array.c
@@ -550,7 +550,7 @@ int proc_pid_statm(struct seq_file *m, s
 	seq_put_decimal_ull(m, ' ', shared);
 	seq_put_decimal_ull(m, ' ', text);
 	seq_put_decimal_ull(m, ' ', 0);
-	seq_put_decimal_ull(m, ' ', text);
+	seq_put_decimal_ull(m, ' ', data);
 	seq_put_decimal_ull(m, ' ', 0);
 	seq_putc(m, '\n');
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

