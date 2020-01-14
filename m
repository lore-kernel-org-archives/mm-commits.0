From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 09/11] mm/page-writeback.c: improve arithmetic
 divisions
Date: Mon, 13 Jan 2020 16:29:29 -0800
Message-ID: <20200114002929.P5URA%akpm@linux-foundation.org>
References: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgANA3a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:30 -0500
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cai@lca.pw, axboe@kernel.dk, wenyang@linux.alibaba.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
