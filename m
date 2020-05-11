From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-flex_proportionsc-cleanup-__fprop_inc_percpu_max.patch added to -mm
 tree
Date: Mon, 11 May 2020 14:23:37 -0700
Message-ID: <20200511212337.dvmUk_hjK%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgEKVXi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 17:23:38 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org, tan.hu@zte.com.cn, wang.liang82@zte.com.cn, wang.yi59@zte.com.cn, xue.zhihong@zte.com.cn


The patch titled
     Subject: lib/flex_proportions.c: cleanup __fprop_inc_percpu_max
has been added to the -mm tree.  Its filename is
     lib-flex_proportionsc-cleanup-__fprop_inc_percpu_max.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-flex_proportionsc-cleanup-__fprop_inc_percpu_max.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-flex_proportionsc-cleanup-__fprop_inc_percpu_max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Jan Kara <jack@suse.cz>
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

lib-flex_proportionsc-cleanup-__fprop_inc_percpu_max.patch
lib-flex_proportionsc-aging-counts-when-fraction-smaller-than-max_frac-fprop_frac_base.patch
