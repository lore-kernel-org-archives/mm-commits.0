From: akpm@linux-foundation.org
Subject: + mm-oom_reaper-report-success-failure-fix.patch added to -mm
 tree
Date: Wed, 03 Feb 2016 16:04:22 -0800
Message-ID: <56b29586.oUD2vbaPXcQEa+x9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbcBDAEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 19:04:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrea@kernel.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-report-success-failure-fix
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-report-success-failure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-report-success-failure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-report-success-failure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -414,6 +414,8 @@ static DECLARE_WAIT_QUEUE_HEAD(oom_victi
 
 bool oom_killer_disabled __read_mostly;
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
 #ifdef CONFIG_MMU
 /*
  * OOM Reaper kernel thread which tries to reap the memory used by the OOM
@@ -423,7 +425,6 @@ static struct task_struct *oom_reaper_th
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
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

