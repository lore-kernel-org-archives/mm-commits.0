From: akpm@linux-foundation.org
Subject: +
 mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
 added to -mm tree
Date: Wed, 13 Sep 2017 14:48:58 -0700
Message-ID: <59b9a7ca.IbfQodDxEAhioRTD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47480 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdIMVs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 17:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch

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
Subject: mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes

WARNING: line over 80 characters
#79: FILE: mm/oom_kill.c:501:
+	 * what they do is basically undeterministic. So let's have a short sleep

total: 0 errors, 1 warnings, 39 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mmu_notifier.h~mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes include/linux/mmu_notifier.h
diff -puN mm/oom_kill.c~mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes
+++ a/mm/oom_kill.c
@@ -498,8 +498,8 @@ static bool __oom_reap_task_mm(struct ta
 	/*
 	 * If the mm has notifiers then we would need to invalidate them around
 	 * unmap_page_range and that is risky because notifiers can sleep and
-	 * what they do is basically undeterministic. So let's have a short sleep
-	 * to give the oom victim some more time.
+	 * what they do is basically undeterministic.  So let's have a short
+	 * sleep to give the oom victim some more time.
 	 * TODO: we really want to get rid of this ugly hack and make sure that
 	 * notifiers cannot block for unbounded amount of time and add
 	 * mmu_notifier_invalidate_range_{start,end} around unmap_page_range
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

