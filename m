From: akpm@linux-foundation.org
Subject: [folded-merged]
 oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 27 May 2016 14:23:39 -0700
Message-ID: <5748badb.CfmVLyYwaKYCpQ/+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbcE0VXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:23:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom_reaper-close-race-with-exiting-task-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch

This patch was dropped because it was folded into oom_reaper-close-race-with-exiting-task.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: oom_reaper-close-race-with-exiting-task-checkpatch-fixes

WARNING: please, no space before tabs
#65: FILE: mm/oom_kill.c:457:
+^I *   ^I^I^I^I  mmput$

WARNING: please, no space before tabs
#66: FILE: mm/oom_kill.c:458:
+^I *   ^I^I^I^I    atomic_dec_and_test$

WARNING: line over 80 characters
#71: FILE: mm/oom_kill.c:463:
+	 *				    # no TIF_MEMDIE task select new victim

total: 0 errors, 3 warnings, 53 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/oom_reaper-close-race-with-exiting-task.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~oom_reaper-close-race-with-exiting-task-checkpatch-fixes mm/oom_kill.c
--- a/mm/oom_kill.c~oom_reaper-close-race-with-exiting-task-checkpatch-fixes
+++ a/mm/oom_kill.c
@@ -454,13 +454,13 @@ static bool __oom_reap_task(struct task_
 	 * and cause premature new oom victim selection:
 	 * __oom_reap_task		exit_mm
 	 *   atomic_inc_not_zero
-	 *   				  mmput
-	 *   				    atomic_dec_and_test
+	 *				  mmput
+	 *				    atomic_dec_and_test
 	 *				  exit_oom_victim
 	 *				[...]
 	 *				out_of_memory
 	 *				  select_bad_process
-	 *				    # no TIF_MEMDIE task select new victim
+	 *				    # no TIF_MEMDIE task selects new victim
 	 *  unmap_page_range # frees some memory
 	 */
 	mutex_lock(&oom_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
oom_reaper-close-race-with-exiting-task.patch
mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
mm-fix-overflow-in-vm_map_ram-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

