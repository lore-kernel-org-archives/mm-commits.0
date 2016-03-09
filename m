From: akpm@linux-foundation.org
Subject: +
 oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2.patch added to -mm tree
Date: Wed, 09 Mar 2016 13:22:18 -0800
Message-ID: <56e0940a.7xZnPXn4RRYdJQul%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbcCIVWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 16:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix
has been added to the -mm tree.  Its filename is
     oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix

fix a left over

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2 mm/oom_kill.c
--- a/mm/oom_kill.c~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2
+++ a/mm/oom_kill.c
@@ -551,7 +551,7 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
-static void wake_oom_reaper(struct task_struct *mm)
+static void wake_oom_reaper(struct task_struct *tsk)
 {
 }
 #endif
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-report-success-failure-fix-2.patch
mm-oom_reaper-report-success-failure-fix-fix.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
oom-make-oom_reaper-freezable.patch
oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
mm-remove-__gfp_nofail-is-deprecated-comment.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

