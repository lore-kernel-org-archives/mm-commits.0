From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 08/11] mm/page-writeback.c: use div64_ul() for
 u64-by-unsigned-long divide
Date: Mon, 13 Jan 2020 16:29:26 -0800
Message-ID: <20200114002926.Cskkh%akpm__4412.23914256028$1578961888$gmane$org@linux-foundation.org>
References: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgANA31 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:27 -0500
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cai@lca.pw, axboe@kernel.dk, wenyang@linux.alibaba.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Wen Yang <wenyang@linux.alibaba.com>
Subject: mm/page-writeback.c: use div64_ul() for u64-by-unsigned-long divide

The two variables 'numerator' and 'denominator', though they are declared
as long, they should actually be unsigned long (according to the
implementation of the fprop_fraction_percpu() function)

And do_div() does a 64-by-32 division, while the divisor 'denominator' is
unsigned long, thus 64-bit on 64-bit platforms.  Hence the proper function
to call is div64_ul().

Link: http://lkml.kernel.org/r/20200102081442.8273-3-wenyang@linux.alibaba.com
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page-writeback.c~mm-page-writebackc-use-div64_ul-for-u64-by-unsigned-long-divide
+++ a/mm/page-writeback.c
@@ -766,7 +766,7 @@ static unsigned long __wb_calc_thresh(st
 	struct wb_domain *dom = dtc_dom(dtc);
 	unsigned long thresh = dtc->thresh;
 	u64 wb_thresh;
-	long numerator, denominator;
+	unsigned long numerator, denominator;
 	unsigned long wb_min_ratio, wb_max_ratio;
 
 	/*
@@ -777,7 +777,7 @@ static unsigned long __wb_calc_thresh(st
 
 	wb_thresh = (thresh * (100 - bdi_min_ratio)) / 100;
 	wb_thresh *= numerator;
-	do_div(wb_thresh, denominator);
+	wb_thresh = div64_ul(wb_thresh, denominator);
 
 	wb_min_max_ratio(dtc->wb, &wb_min_ratio, &wb_max_ratio);
 
_
