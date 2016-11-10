From: akpm@linux-foundation.org
Subject: [patch 01/15] mm: remove extra newline from allocation stall
 warning
Date: Thu, 10 Nov 2016 10:46:04 -0800
Message-ID: <5824c06c.4LuJLG8rHIvpSBwA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754491AbcKJSqG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2016 13:46:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com

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
