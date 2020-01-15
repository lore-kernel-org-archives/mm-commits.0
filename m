From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-writebackc-improve-arithmetic-divisions.patch removed from -mm tree
Date: Tue, 14 Jan 2020 16:45:57 -0800
Message-ID: <20200115004557.tO3kVPAbu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbgAOAp6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:45:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, cai@lca.pw, mm-commits@vger.kernel.org, tj@kernel.org, wenyang@linux.alibaba.com


The patch titled
     Subject: mm/page-writeback.c: improve arithmetic divisions
has been removed from the -mm tree.  Its filename was
     mm-page-writebackc-improve-arithmetic-divisions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Yang <wenyang@linux.alibaba.com>
Subject: mm/page-writeback.c: improve arithmetic divisions

Use div64_ul() instead of do_div() if the divisor is unsigned long, to
avoid truncation to 32-bit on 64-bit platforms.

Link: http://lkml.kernel.org/r/20200102081442.8273-4-wenyang@linux.alibaba.com
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-page-writebackc-improve-arithmetic-divisions
+++ a/mm/page-writeback.c
@@ -1102,7 +1102,7 @@ static void wb_update_write_bandwidth(st
 	bw = written - min(written, wb->written_stamp);
 	bw *= HZ;
 	if (unlikely(elapsed > period)) {
-		do_div(bw, elapsed);
+		bw = div64_ul(bw, elapsed);
 		avg = bw;
 		goto out;
 	}
_

Patches currently in -mm which might be from wenyang@linux.alibaba.com are
