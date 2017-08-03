From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-task_will_free_memcurrent-should-ignore-mmf_oom_skip-for-once-fix.patch removed from -mm tree
Date: Thu, 03 Aug 2017 15:57:42 -0700
Message-ID: <5983aa66.7ZJUCqlO/fXXhJmU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdHCW5n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2017 18:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mjaggi@caviumnetworks.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-task_will_free_memcurrent-should-ignore-mmf_oom_skip-for-once-fix
has been removed from the -mm tree.  Its filename was
     mm-oom-task_will_free_memcurrent-should-ignore-mmf_oom_skip-for-once-fix.patch

This patch was dropped because it was folded into mm-oom-task_will_free_memcurrent-should-ignore-mmf_oom_skip-for-once.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom-task_will_free_memcurrent-should-ignore-mmf_oom_skip-for-once-fix

tweak comment, s/true/1/

Cc: David Rientjes <rientjes@google.com>
Cc: Manish Jaggi <mjaggi@caviumnetworks.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-task_will_free_memcurrent-should-ignore-mmf_oom_skip-for-once-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-task_will_free_memcurrent-should-ignore-mmf_oom_skip-for-once-fix
+++ a/mm/oom_kill.c
@@ -780,15 +780,15 @@ static bool task_will_free_mem(struct ta
 		return false;
 
 	/*
-	 * It is possible that current thread fails to try allocation from
+	 * It is possible that the current thread fails to try allocation from
 	 * memory reserves if the OOM reaper set MMF_OOM_SKIP on this mm before
-	 * current thread calls out_of_memory() in order to get TIF_MEMDIE.
-	 * In that case, allow current thread to try TIF_MEMDIE allocation
-	 * before start selecting next OOM victims.
+	 * the current thread called out_of_memory() in order to get TIF_MEMDIE.
+	 * In that case, allow the current thread to try TIF_MEMDIE allocation
+	 * before starting to select the next OOM victims.
 	 */
 	if (test_bit(MMF_OOM_SKIP, &mm->flags)) {
 		if (task == current && !task->oom_kill_free_check_raced) {
-			task->oom_kill_free_check_raced = true;
+			task->oom_kill_free_check_raced = 1;
 			return true;
 		}
 		return false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-make-tlb_flush_pending-global-fix.patch
mm-oom-task_will_free_memcurrent-should-ignore-mmf_oom_skip-for-once.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
add-testcases-for-memset16-32-64-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

