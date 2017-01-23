From: akpm@linux-foundation.org
Subject: +
 mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch added
 to -mm tree
Date: Mon, 23 Jan 2017 13:49:13 -0800
Message-ID: <58867a59.dVwMdj1PekFKrMZ4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdAWVtO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 16:49:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix
has been added to the -mm tree.  Its filename is
     mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch

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
Subject: mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix

fix alloc_flags may-be-used-uninitalized

Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix
+++ a/mm/page_alloc.c
@@ -3577,6 +3577,14 @@ retry_cpuset:
 	no_progress_loops = 0;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
+
+	/*
+	 * The fast path uses conservative alloc_flags to succeed only until
+	 * kswapd needs to be woken up, and to avoid the cost of setting up
+	 * alloc_flags precisely. So we do that now.
+	 */
+	alloc_flags = gfp_to_alloc_flags(gfp_mask);
+
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
 	 * because we might have used different nodemask in the fast path, or
@@ -3588,14 +3596,6 @@ retry_cpuset:
 	if (!ac->preferred_zoneref->zone)
 		goto nopage;
 
-
-	/*
-	 * The fast path uses conservative alloc_flags to succeed only until
-	 * kswapd needs to be woken up, and to avoid the cost of setting up
-	 * alloc_flags precisely. So we do that now.
-	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask);
-
 	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
 		wake_all_kswapds(order, ac);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

