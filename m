From: akpm@linux-foundation.org
Subject: + mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch added to -mm tree
Date: Wed, 13 Sep 2017 14:48:08 -0700
Message-ID: <59b9a798.T8UKxwzxpiKB5a/g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbdIMVsJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 17:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: skip mm structs with mmu notifiers
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch

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
Subject: mm, oom_reaper: skip mm structs with mmu notifiers

Andrea has noticed that the oom_reaper doesn't invalidate the range via
mmu notifiers (mmu_notifier_invalidate_range_start,
mmu_notifier_invalidate_range_end) and that can corrupt the memory of the
kvm guest for example.

tlb_flush_mmu_tlbonly already invokes mmu notifiers but that is not
sufficient as per Andrea:

: mmu_notifier_invalidate_range cannot be used in replacement of
: mmu_notifier_invalidate_range_start/end. For KVM
: mmu_notifier_invalidate_range is a noop and rightfully so. A MMU
: notifier implementation has to implement either
: ->invalidate_range method or the invalidate_range_start/end
: methods, not both. And if you implement invalidate_range_start/end
: like KVM is forced to do, calling mmu_notifier_invalidate_range in
: common code is a noop for KVM.
:
: For those MMU notifiers that can get away only implementing
: ->invalidate_range, the ->invalidate_range is implicitly called by
: mmu_notifier_invalidate_range_end(). And only those secondary MMUs
: that share the same pagetable with the primary MMU (like AMD
: iommuv2) can get away only implementing ->invalidate_range.

As the callback is allowed to sleep and the implementation is out of hand
of the MM it is safer to simply bail out if there is an mmu notifier
registered.  In order to not fail too early make the mm_has_notifiers
check under the oom_lock and have a little nap before failing to give the
current oom victim some more time to exit.

Link: http://lkml.kernel.org/r/20170913113427.2291-1-mhocko@kernel.org
Fixes: aac453635549 ("mm, oom: introduce oom reaper")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    5 +++++
 mm/oom_kill.c                |   16 ++++++++++++++++
 2 files changed, 21 insertions(+)

diff -puN include/linux/mmu_notifier.h~mm-oom_reaper-skip-mm-structs-with-mmu-notifiers include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-oom_reaper-skip-mm-structs-with-mmu-notifiers
+++ a/include/linux/mmu_notifier.h
@@ -400,6 +400,11 @@ extern void mmu_notifier_synchronize(voi
 
 #else /* CONFIG_MMU_NOTIFIER */
 
+static inline int mm_has_notifiers(struct mm_struct *mm)
+{
+	return 0;
+}
+
 static inline void mmu_notifier_release(struct mm_struct *mm)
 {
 }
diff -puN mm/oom_kill.c~mm-oom_reaper-skip-mm-structs-with-mmu-notifiers mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-skip-mm-structs-with-mmu-notifiers
+++ a/mm/oom_kill.c
@@ -40,6 +40,7 @@
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
 #include <linux/init.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -494,6 +495,21 @@ static bool __oom_reap_task_mm(struct ta
 		goto unlock_oom;
 	}
 
+	/*
+	 * If the mm has notifiers then we would need to invalidate them around
+	 * unmap_page_range and that is risky because notifiers can sleep and
+	 * what they do is basically undeterministic. So let's have a short sleep
+	 * to give the oom victim some more time.
+	 * TODO: we really want to get rid of this ugly hack and make sure that
+	 * notifiers cannot block for unbounded amount of time and add
+	 * mmu_notifier_invalidate_range_{start,end} around unmap_page_range
+	 */
+	if (mm_has_notifiers(mm)) {
+		up_read(&mm->mmap_sem);
+		schedule_timeout_idle(HZ);
+		goto unlock_oom;
+	}
+
 	/*
 	 * MMF_OOM_SKIP is set by exit_mmap when the OOM reaper can't
 	 * work on the mm anymore. The check for MMF_OOM_SKIP must run
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch
mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
treewide-remove-gfp_temporary-allocation-flag.patch

