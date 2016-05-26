From: akpm@linux-foundation.org
Subject: + oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
 added to -mm tree
Date: Thu, 26 May 2016 14:05:19 -0700
Message-ID: <5747650f.FBch6/gcj/V2h5iH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbcEZVFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 17:05:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom_reaper-close-race-with-exiting-task-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch

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
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch
drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch
oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

