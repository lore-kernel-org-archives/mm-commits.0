From: akpm@linux-foundation.org
Subject: +
 mmoom-use-alloc_oom-for-oom-victims-last-second-allocation.patch added to
 -mm tree
Date: Mon, 27 Nov 2017 16:06:33 -0800
Message-ID: <5a1ca889.QeNXHC/2miVBnCkh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752406AbdK1AGf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 19:06:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, aarcange@redhat.com, hannes@cmpxchg.org, mhocko@suse.com, mjaggi@caviumnetworks.com, oleg@redhat.com, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom: use ALLOC_OOM for OOM victim's last second allocation
has been added to the -mm tree.  Its filename is
     mmoom-use-alloc_oom-for-oom-victims-last-second-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-use-alloc_oom-for-oom-victims-last-second-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-use-alloc_oom-for-oom-victims-last-second-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,oom: use ALLOC_OOM for OOM victim's last second allocation

Manish Jaggi noticed that running LTP oom01/oom02 ltp tests with high core
count causes random kernel panics when an OOM victim which consumed memory
in a way the OOM reaper does not help was selected by the OOM killer [1]. 
Since commit 696453e66630ad45 ("mm, oom: task_will_free_mem should skip
oom_reaped tasks") changed task_will_free_mem(current) in out_of_memory()
to return false as soon as MMF_OOM_SKIP is set, many threads sharing the
victim's mm were not able to try allocation from memory reserves after the
OOM reaper gave up reclaiming memory.

Therefore, this patch allows OOM victims to use ALLOC_OOM watermark for
last second allocation attempt.

[1] http://lkml.kernel.org/r/e6c83a26-1d59-4afd-55cf-04e58bdde188@caviumnetworks.com

Link: http://lkml.kernel.org/r/1511607169-5084-2-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Fixes: 696453e66630ad45 ("mm, oom: task_will_free_mem should skip oom_reaped tasks")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Manish Jaggi <mjaggi@caviumnetworks.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/page_alloc.c~mmoom-use-alloc_oom-for-oom-victims-last-second-allocation mm/page_alloc.c
--- a/mm/page_alloc.c~mmoom-use-alloc_oom-for-oom-victims-last-second-allocation
+++ a/mm/page_alloc.c
@@ -4154,13 +4154,19 @@ struct page *alloc_pages_before_oomkill(
 	 * we're still under heavy pressure. But make sure that this reclaim
 	 * attempt shall not depend on __GFP_DIRECT_RECLAIM && !__GFP_NORETRY
 	 * allocation which will never fail due to oom_lock already held.
+	 * Also, make sure that OOM victims can try ALLOC_OOM watermark
+	 * in case they haven't tried ALLOC_OOM watermark.
 	 */
 	int alloc_flags = ALLOC_CPUSET | ALLOC_WMARK_HIGH;
 	gfp_t gfp_mask = oc->gfp_mask | __GFP_HARDWALL;
+	int reserve_flags;
 
 	if (!oc->ac)
 		return NULL;
 	gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
+	if (reserve_flags)
+		alloc_flags = reserve_flags;
 	return get_page_from_freelist(gfp_mask, oc->order, alloc_flags, oc->ac);
 }
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot.patch
mmvmscan-mark-register_shrinker-as-__must_check.patch
mmoom-move-last-second-allocation-to-inside-the-oom-killer.patch
mmoom-use-alloc_oom-for-oom-victims-last-second-allocation.patch
mmoom-remove-oom_lock-serialization-from-the-oom-reaper.patch

