From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch removed from -mm tree
Date: Thu, 05 Nov 2015 18:26:09 -0800
Message-ID: <563c0fc1.yaB59JUfZX9IOpVu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFC0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:26:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kwalker@redhat.com, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, skozina@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch

This patch was dropped because it was folded into mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix

document process_shares_mm() a bit

Cc: David Rientjes <rientjes@google.com>
Cc: Kyle Walker <kwalker@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Stanislav Kozina <skozina@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/oom_kill.c~mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix
+++ a/mm/oom_kill.c
@@ -483,6 +483,12 @@ void oom_killer_enable(void)
 	oom_killer_disabled = false;
 }
 
+/*
+ * task->mm can be NULL if the task is the exited group leader.  So to
+ * determine whether the task is using a particular mm, we examine all the
+ * task's threads: if one of those is using this mm then this task was also
+ * using it.
+ */
 static bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
 {
 	struct task_struct *t;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch

