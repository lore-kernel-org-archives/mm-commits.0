From: akpm@linux-foundation.org
Subject: +
 mmoom-do-not-loop-__gfp_fs-allocation-if-the-oom-killer-is-disabled.patch
 added to -mm tree
Date: Mon, 25 Jan 2016 16:28:26 -0800
Message-ID: <56a6bdaa.m54+pHtc3MelcwOv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcAZA21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 19:28:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom: do not loop !__GFP_FS allocation if the OOM killer is disabled.
has been added to the -mm tree.  Its filename is
     mmoom-do-not-loop-__gfp_fs-allocation-if-the-oom-killer-is-disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-do-not-loop-__gfp_fs-allocation-if-the-oom-killer-is-disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-do-not-loop-__gfp_fs-allocation-if-the-oom-killer-is-disabled.patch

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
Subject: mm,oom: do not loop !__GFP_FS allocation if the OOM killer is disabled.

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
@@ -2761,8 +2761,12 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
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

mmoom-make-oom_killer_disable-killable.patch
mmoom-do-not-loop-__gfp_fs-allocation-if-the-oom-killer-is-disabled.patch
kernel-hung_taskc-use-timeout-diff-when-timeout-is-updated.patch

