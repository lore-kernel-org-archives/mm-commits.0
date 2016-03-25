From: akpm@linux-foundation.org
Subject: + mm-oom_reaper-report-success-failure-v6-fix.patch added to -mm
 tree
Date: Fri, 25 Mar 2016 13:56:23 -0700
Message-ID: <56f5a5f7.V79g0PkCMFXldy95%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbcCYU4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 16:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-report-success-failure-v6-fix
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-report-success-failure-v6-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-report-success-failure-v6-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-report-success-failure-v6-fix.patch

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
Subject: mm-oom_reaper-report-success-failure-v6-fix

mm/oom_kill.c: In function 'oom_kill_process':
mm/oom_kill.c:749: error: implicit declaration of function 'K'
mm/oom_kill.c:749: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'int'
mm/oom_kill.c:749: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'int'
mm/oom_kill.c:749: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'int'
mm/oom_kill.c:749: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'int'

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-report-success-failure-v6-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-report-success-failure-v6-fix
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
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-v6-fix.patch
drivers-input-eliminate-input_compat_test-macro.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

