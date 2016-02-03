From: akpm@linux-foundation.org
Subject: + oom-reaper-handle-mlocked-pages.patch added to -mm tree
Date: Wed, 03 Feb 2016 15:19:44 -0800
Message-ID: <56b28b10.0vMtgFgTEddvyBe9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934AbcBCXTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 18:19:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, andrea@kernel.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom reaper: handle mlocked pages
has been added to the -mm tree.  Its filename is
     oom-reaper-handle-mlocked-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-reaper-handle-mlocked-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-reaper-handle-mlocked-pages.patch

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
Subject: oom reaper: handle mlocked pages

__oom_reap_vmas current skips over all mlocked vmas because they need a
special treatment before they are unmapped.  This is primarily done for
simplicity.  There is no reason to skip over them and reduce the amount of
reclaimed memory.  This is safe from the semantic point of view because
try_to_unmap_one during rmap walk would keep tell the reclaim to cull the
page back and mlock it again.

munlock_vma_pages_all is also safe to be called from the oom reaper
context because it doesn't sit on any locks but mmap_sem (for read).

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Argangeli <andrea@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~oom-reaper-handle-mlocked-pages mm/oom_kill.c
--- a/mm/oom_kill.c~oom-reaper-handle-mlocked-pages
+++ a/mm/oom_kill.c
@@ -446,13 +446,6 @@ static bool __oom_reap_vmas(struct mm_st
 			continue;
 
 		/*
-		 * mlocked VMAs require explicit munlocking before unmap.
-		 * Let's keep it simple here and skip such VMAs.
-		 */
-		if (vma->vm_flags & VM_LOCKED)
-			continue;
-
-		/*
 		 * Only anonymous pages have a good chance to be dropped
 		 * without additional steps which we cannot afford as we
 		 * are OOM already.
@@ -462,9 +455,12 @@ static bool __oom_reap_vmas(struct mm_st
 		 * we do not want to block exit_mmap by keeping mm ref
 		 * count elevated without a good reason.
 		 */
-		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED))
+		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED)) {
+			if (vma->vm_flags & VM_LOCKED)
+				munlock_vma_pages_all(vma);
 			unmap_page_range(&tlb, vma, vma->vm_start, vma->vm_end,
 					 &details);
+		}
 	}
 	tlb_finish_mmu(&tlb, 0, -1);
 	up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmstat-make-quiet_vmstat-lighter.patch
vmstat-make-vmstat_update-deferrable.patch
mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

