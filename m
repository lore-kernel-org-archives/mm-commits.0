From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged]
 =?US-ASCII?Q?lib-flex=5Fproportionsc-aging-counts-when-fraction-smaller?=
 =?US-ASCII?Q?-than-max=5Ffrac-fprop=5Ffrac=5Fbase.patch?= removed from -mm
 tree
Date: Mon, 11 May 2020 14:31:05 -0700
Message-ID: <20200511213105.kSqbJ3-iK%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgEKVbG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 17:31:06 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org, tan.hu@zte.com.cn, wang.liang82@zte.com.cn, wang.yi59@zte.com.cn, xue.zhihong@zte.com.cn


The patch titled
     Subject: lib/flex_proportions.c: aging counts when fraction smaller than max_frac/FPROP_FRAC_BASE
has been removed from the -mm tree.  Its filename was
     lib-flex_proportionsc-aging-counts-when-fraction-smaller-than-max_frac-fprop_frac_base.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Tan Hu <tan.hu@zte.com.cn>
Subject: lib/flex_proportions.c: aging counts when fraction smaller than max_frac/FPROP_FRAC_BASE

If the given type has fraction smaller than max_frac/FPROP_FRAC_BASE,
__fprop_inc_percpu_max should follow the design formula and aging fraction
too.

Link: http://lkml.kernel.org/r/1588746088-38605-1-git-send-email-tan.hu@zte.com.cn
Signed-off-by: Tan Hu <tan.hu@zte.com.cn>
Cc: <xue.zhihong@zte.com.cn>
Cc: Yi Wang <wang.yi59@zte.com.cn>
Cc: <wang.liang82@zte.com.cn>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_proportions.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/lib/flex_proportions.c~lib-flex_proportionsc-aging-counts-when-fraction-smaller-than-max_frac-fprop_frac_base
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
