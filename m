From: akpm@linux-foundation.org
Subject: +
 mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks.patch added to -mm tree
Date: Fri, 15 Dec 2017 15:04:54 -0800
Message-ID: <5a345516.zRShnO2XaqCywYkN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755978AbdLOXFA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Dec 2017 18:05:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, airlied@linux.ie, alexander.deucher@amd.com, benh@kernel.crashing.org, boris.ostrovsky@oracle.com, christian.koenig@amd.com, dledford@redhat.com, jani.nikula@linux.intel.com, jglisse@redhat.com, joro@8bytes.org, mhocko@suse.com, mike.marciniszyn@intel.com, oded.gabbay@gmail.com, paulus@samba.org, pbonzini@redhat.com, rkrcmar@redhat.com, sean.hefty@intel.com, sivanich@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: avoid reaping only for mm's with blockable invalidate callbacks
has been added to the -mm tree.  Its filename is
     mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: avoid reaping only for mm's with blockable invalidate callbacks

This uses the new annotation to determine if an mm has mmu notifiers with
blockable invalidate range callbacks to avoid oom reaping.  Otherwise, the
callbacks are used around unmap_page_range().

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1712141330120.74052@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dimitri Sivanich <sivanich@hpe.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks
+++ a/mm/oom_kill.c
@@ -514,15 +514,12 @@ static bool __oom_reap_task_mm(struct ta
 	}
 
 	/*
-	 * If the mm has notifiers then we would need to invalidate them around
-	 * unmap_page_range and that is risky because notifiers can sleep and
-	 * what they do is basically undeterministic.  So let's have a short
+	 * If the mm has invalidate_{start,end}() notifiers that could block,
 	 * sleep to give the oom victim some more time.
 	 * TODO: we really want to get rid of this ugly hack and make sure that
-	 * notifiers cannot block for unbounded amount of time and add
-	 * mmu_notifier_invalidate_range_{start,end} around unmap_page_range
+	 * notifiers cannot block for unbounded amount of time
 	 */
-	if (mm_has_notifiers(mm)) {
+	if (mm_has_blockable_invalidate_notifiers(mm)) {
 		up_read(&mm->mmap_sem);
 		schedule_timeout_idle(HZ);
 		goto unlock_oom;
@@ -565,10 +562,14 @@ static bool __oom_reap_task_mm(struct ta
 		 * count elevated without a good reason.
 		 */
 		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED)) {
-			tlb_gather_mmu(&tlb, mm, vma->vm_start, vma->vm_end);
-			unmap_page_range(&tlb, vma, vma->vm_start, vma->vm_end,
-					 NULL);
-			tlb_finish_mmu(&tlb, vma->vm_start, vma->vm_end);
+			const unsigned long start = vma->vm_start;
+			const unsigned long end = vma->vm_end;
+
+			tlb_gather_mmu(&tlb, mm, start, end);
+			mmu_notifier_invalidate_range_start(mm, start, end);
+			unmap_page_range(&tlb, vma, start, end, NULL);
+			mmu_notifier_invalidate_range_end(mm, start, end);
+			tlb_finish_mmu(&tlb, start, end);
 		}
 	}
 	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
_

Patches currently in -mm which might be from rientjes@google.com are

mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch
mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks.patch

