From: akpm@linux-foundation.org
Subject: [merged]
 mmoom-do-not-loop-__gfp_fs-allocation-if-the-oom-killer-is-disabled.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:45 -0700
Message-ID: <56f0402d.G5AkRuyo5LKhjnEB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbcCUT40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom: do not loop !__GFP_FS allocation if the OOM killer is disabled
has been removed from the -mm tree.  Its filename was
     mmoom-do-not-loop-__gfp_fs-allocation-if-the-oom-killer-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,oom: do not loop !__GFP_FS allocation if the OOM killer is disabled

After the OOM killer is disabled during suspend operation, any
!__GFP_NOFAIL && __GFP_FS allocations are forced to fail.  Thus, any
!__GFP_NOFAIL && !__GFP_FS allocations should be forced to fail as well.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mmoom-do-not-loop-__gfp_fs-allocation-if-the-oom-killer-is-disabled mm/page_alloc.c
--- a/mm/page_alloc.c~mmoom-do-not-loop-__gfp_fs-allocation-if-the-oom-killer-is-disabled
+++ a/mm/page_alloc.c
@@ -2858,8 +2858,12 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 			 * XXX: Page reclaim didn't yield anything,
 			 * and the OOM killer can't be invoked, but
 			 * keep looping as per tradition.
+			 *
+			 * But do not keep looping if oom_killer_disable()
+			 * was already called, for the system is trying to
+			 * enter a quiescent state during suspend.
 			 */
-			*did_some_progress = 1;
+			*did_some_progress = !oom_killer_disabled;
 			goto out;
 		}
 		if (pm_suspended_storage())
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

kernel-hung_taskc-use-timeout-diff-when-timeout-is-updated.patch

