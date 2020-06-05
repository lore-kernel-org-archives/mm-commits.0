From: akpm@linux-foundation.org
Subject: [merged]
 lib-flex_proportionsc-cleanup-__fprop_inc_percpu_max.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:19:13 -0700
Message-ID: <20200605201913.019yRTN8Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUTP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org, tan.hu@zte.com.cn, wang.liang82@zte.com.cn, wang.yi59@zte.com.cn, xue.zhihong@zte.com.cn


The patch titled
     Subject: lib/flex_proportions.c: cleanup __fprop_inc_percpu_max
has been removed from the -mm tree.  Its filename was
     lib-flex_proportionsc-cleanup-__fprop_inc_percpu_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from tan.hu@zte.com.cn are
