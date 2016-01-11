From: akpm@linux-foundation.org
Subject: + oom-reaper-handle-anonymous-mlocked-pages.patch added to -mm
 tree
Date: Mon, 11 Jan 2016 14:56:54 -0800
Message-ID: <56943336.3whxquvtYIFpBL7X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbcAKW4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:56:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, andrea@kernel.org, hughd@google.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom reaper: handle anonymous mlocked pages
has been added to the -mm tree.  Its filename is
     oom-reaper-handle-anonymous-mlocked-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-reaper-handle-anonymous-mlocked-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-reaper-handle-anonymous-mlocked-pages.patch

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
Subject: oom reaper: handle anonymous mlocked pages

__oom_reap_vmas current skips over all mlocked vmas because they need a
special treatment before they are unmapped.  This is primarily done for
simplicity.  There is no reason to skip over them and reduce the amount of
reclaimed memory.  This is safe from the semantic point of view because
try_to_unmap_one during rmap walk would keep tell the reclaim to cull the
page back and mlock it again.

munlock_vma_pages_all is also safe to be called from the oom reaper
context because it doesn't sit on any locks but mmap_sem (for read).

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Argangeli <andrea@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~oom-reaper-handle-anonymous-mlocked-pages mm/oom_kill.c
--- a/mm/oom_kill.c~oom-reaper-handle-anonymous-mlocked-pages
+++ a/mm/oom_kill.c
@@ -445,13 +445,6 @@ static bool __oom_reap_vmas(struct mm_st
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
@@ -461,9 +454,12 @@ static bool __oom_reap_vmas(struct mm_st
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

mm-get-rid-of-__alloc_pages_high_priority.patch
mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch
mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation.patch
mm-oom-give-__gfp_nofail-allocations-access-to-memory-reserves.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-v4.patch
oom-reaper-handle-anonymous-mlocked-pages.patch

