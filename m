From: akpm@linux-foundation.org
Subject: +
 mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch added to -mm tree
Date: Mon, 23 May 2016 15:05:12 -0700
Message-ID: <57437e98.gkPTUJzRozXC35oC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbcEWWFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 18:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, minchan@kernel.org, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch

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
Subject: mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix

fix typo, per Minchan

Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix include/linux/sched.h
--- a/include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix
+++ a/include/linux/sched.h
@@ -2741,7 +2741,7 @@ static inline bool mmget_not_zero(struct
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
 #ifdef CONFIG_MMU
-/* same as above but performs the slow path from the async kontext. Can
+/* same as above but performs the slow path from the async context. Can
  * be called from the atomic context as well
  */
 extern void mmput_async(struct mm_struct *);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

