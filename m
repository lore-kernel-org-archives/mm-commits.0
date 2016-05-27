From: akpm@linux-foundation.org
Subject: + oom_reaper-close-race-with-exiting-task-fix.patch added to -mm
 tree
Date: Fri, 27 May 2016 12:53:20 -0700
Message-ID: <5748a5b0.y+Hch8nrnDDJlJgw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbcE0TxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 15:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: oom_reaper-close-race-with-exiting-task-fix
has been added to the -mm tree.  Its filename is
     oom_reaper-close-race-with-exiting-task-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom_reaper-close-race-with-exiting-task-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom_reaper-close-race-with-exiting-task-fix.patch

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
Subject: oom_reaper-close-race-with-exiting-task-fix

fix use of unused `mm', Per Stephen

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom_reaper-close-race-with-exiting-task-fix mm/oom_kill.c
--- a/mm/oom_kill.c~oom_reaper-close-race-with-exiting-task-fix
+++ a/mm/oom_kill.c
@@ -443,7 +443,7 @@ static bool __oom_reap_task(struct task_
 {
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
-	struct mm_struct *mm;
+	struct mm_struct *mm = NULL;
 	struct task_struct *p;
 	struct zap_details details = {.check_swap_entries = true,
 				      .ignore_dirty = true};
@@ -534,7 +534,8 @@ unlock_oom:
 	 * different context because we shouldn't risk we get stuck there and
 	 * put the oom_reaper out of the way.
 	 */
-	mmput_async(mm);
+	if (mm)
+		mmput_async(mm);
 	return ret;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
oom_reaper-close-race-with-exiting-task-fix.patch
oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

