From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 080/127] lib/flex_proportions.c: cleanup
 __fprop_inc_percpu_max
Date: Thu, 04 Jun 2020 16:50:23 -0700
Message-ID: <20200604235023.2rEaVKMyz%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgFDXuZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:50:25 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, linux-mm@kvack.org, mm-commits@vger.kernel.org, tan.hu@zte.com.cn, torvalds@linux-foundation.org, wang.liang82@zte.com.cn, wang.yi59@zte.com.cn, xue.zhihong@zte.com.cn

From: Tan Hu <tan.hu@zte.com.cn>
Subject: lib/flex_proportions.c: cleanup __fprop_inc_percpu_max

If the given type has fraction smaller than max_frac/FPROP_FRAC_BASE, the
code could be modified to call __fprop_inc_percpu() directly and easier to
understand.  After this patch, fprop_reflect_period_percpu() will be
called twice, and quicky return on pl->period == p->period test, so it
would not result to significant downside of performance.

Thanks for Jan's guidance.

Link: http://lkml.kernel.org/r/1589004753-27554-1-git-send-email-tan.hu@zte.com.cn
Signed-off-by: Tan Hu <tan.hu@zte.com.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: <xue.zhihong@zte.com.cn>
Cc: Yi Wang <wang.yi59@zte.com.cn>
Cc: <wang.liang82@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_proportions.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/lib/flex_proportions.c~lib-flex_proportionsc-cleanup-__fprop_inc_percpu_max
+++ a/lib/flex_proportions.c
@@ -266,8 +266,7 @@ void __fprop_inc_percpu_max(struct fprop
 		if (numerator >
 		    (((u64)denominator) * max_frac) >> FPROP_FRAC_SHIFT)
 			return;
-	} else
-		fprop_reflect_period_percpu(p, pl);
-	percpu_counter_add_batch(&pl->events, 1, PROP_BATCH);
-	percpu_counter_add(&p->events, 1);
+	}
+
+	__fprop_inc_percpu(p, pl);
 }
_
