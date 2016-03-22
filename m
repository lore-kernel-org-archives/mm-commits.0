From: akpm@linux-foundation.org
Subject: [folded-merged] mm-oom_reaper-report-success-failure-fix.patch
 removed from -mm tree
Date: Tue, 22 Mar 2016 15:39:17 -0700
Message-ID: <56f1c995.ak5u3/du99CoRrPo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbcCVWjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 18:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrea@kernel.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-report-success-failure-fix
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-report-success-failure-fix.patch

This patch was dropped because it was folded into mm-oom_reaper-report-success-failure.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom_reaper-report-success-failure-fix

fix CONFIG_MMU=n build:

mm/oom_kill.c: In function 'oom_kill_process':
mm/oom_kill.c:753: error: implicit declaration of function 'K'
mm/oom_kill.c:753: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'int'
mm/oom_kill.c:753: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'int'
mm/oom_kill.c:753: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'int'
mm/oom_kill.c:753: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'int'

Cc: Andrea Argangeli <andrea@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-report-success-failure-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-report-success-failure-fix
+++ a/mm/oom_kill.c
@@ -410,6 +410,8 @@ static DECLARE_WAIT_QUEUE_HEAD(oom_victi
 
 bool oom_killer_disabled __read_mostly;
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
 #ifdef CONFIG_MMU
 /*
  * OOM Reaper kernel thread which tries to reap the memory used by the OOM
@@ -419,7 +421,6 @@ static struct task_struct *oom_reaper_th
 static struct task_struct *task_to_reap;
 static DECLARE_WAIT_QUEUE_HEAD(oom_reaper_wait);
 
-#define K(x) ((x) << (PAGE_SHIFT-10))
 static bool __oom_reap_task(struct task_struct *tsk)
 {
 	struct mmu_gather tlb;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
drivers-input-eliminate-input_compat_test-macro.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

