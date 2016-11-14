From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-extra-newline-from-allocation-stall-warning.patch removed from
 -mm tree
Date: Mon, 14 Nov 2016 12:02:22 -0800
Message-ID: <582a184e.IIcqYVphgpQylHuc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933969AbcKNUCX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 15:02:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove extra newline from allocation stall warning
has been removed from the -mm tree.  Its filename was
     mm-remove-extra-newline-from-allocation-stall-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: remove extra newline from allocation stall warning

63f53dea0c9866e9 ("mm: warn about allocations which stall for too long")
by error embedded "\n" in the format string, resulting in strange output.

[  722.876655] kworker/0:1: page alloction stalls for 160001ms, order:0
[  722.876656] , mode:0x2400000(GFP_NOIO)
[  722.876657] CPU: 0 PID: 6966 Comm: kworker/0:1 Not tainted 4.8.0+ #69

Link: http://lkml.kernel.org/r/1476026219-7974-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-remove-extra-newline-from-allocation-stall-warning mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-extra-newline-from-allocation-stall-warning
+++ a/mm/page_alloc.c
@@ -3658,7 +3658,7 @@ retry:
 	/* Make sure we know about allocations which stall for too long */
 	if (time_after(jiffies, alloc_start + stall_timeout)) {
 		warn_alloc(gfp_mask,
-			"page alloction stalls for %ums, order:%u\n",
+			"page allocation stalls for %ums, order:%u",
 			jiffies_to_msecs(jiffies-alloc_start), order);
 		stall_timeout += 10 * HZ;
 	}
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch

