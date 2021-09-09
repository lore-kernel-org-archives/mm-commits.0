Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0109DC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2A9A611C8
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346632AbhIIVHE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347200AbhIIVGv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E904611B0;
        Thu,  9 Sep 2021 21:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221541;
        bh=d9nw0O9SH4svDk+mYwTq4D8Qc5nEOAYtb7t0hP9Ya/w=;
        h=Date:From:To:Subject:From;
        b=uqNglGZEphDj+RVBh2j2NMgvyB0XwTvIDIU1doUYX1SqomeK5KzZ0B8uVVe0vJvBr
         pAf8dctOlLZlfI2VeU9FJk0kihpcmS69LnJPJA76LCBPwDMwCMhq0ITsyeJH1bR0gN
         1Pg4ytZ/wtm/RVieehJhNKObPKdC0WhxNbpUcFa0=
Date:   Thu, 09 Sep 2021 14:05:41 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, mgorman@techsingularity.net, mingo@elte.hu,
        mm-commits@vger.kernel.org, tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt.patch
 removed from -mm tree
Message-ID: <20210909210541.tOtQyOLir%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: protect per cpu variables with preempt disable on RT
has been removed from the -mm tree.  Its filename was
     mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ingo Molnar <mingo@elte.hu>
Subject: mm/vmstat: protect per cpu variables with preempt disable on RT

Disable preemption on -RT for the vmstat code.  On vanila the code runs in
IRQ-off regions while on -RT it may not when stats are updated under a
local_lock.  "preempt_disable" ensures that the same resources is not
updated in parallel due to preemption.

This patch differs from the preempt-rt version where __count_vm_event and
__count_vm_events are also protected.  The counters are explicitly
"allowed to be to be racy" so there is no need to protect them from
preemption.  Only the accurate page stats that are updated by a
read-modify-write need protection.  This patch also differs in that a
preempt_[en|dis]able_rt helper is not used.  As vmstat is the only user of
the helper, it was suggested that it be open-coded in vmstat.c instead of
risking the helper being used in unnecessary contexts.

Link: https://lkml.kernel.org/r/20210805160019.1137-2-mgorman@techsingularity.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/mm/vmstat.c~mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt
+++ a/mm/vmstat.c
@@ -319,6 +319,16 @@ void __mod_zone_page_state(struct zone *
 	long x;
 	long t;
 
+	/*
+	 * Accurate vmstat updates require a RMW. On !PREEMPT_RT kernels,
+	 * atomicity is provided by IRQs being disabled -- either explicitly
+	 * or via local_lock_irq. On PREEMPT_RT, local_lock_irq only disables
+	 * CPU migrations and preemption potentially corrupts a counter so
+	 * disable preemption.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -328,6 +338,9 @@ void __mod_zone_page_state(struct zone *
 		x = 0;
 	}
 	__this_cpu_write(*p, x);
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 }
 EXPORT_SYMBOL(__mod_zone_page_state);
 
@@ -350,6 +363,10 @@ void __mod_node_page_state(struct pglist
 		delta >>= PAGE_SHIFT;
 	}
 
+	/* See __mod_node_page_state */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -359,6 +376,9 @@ void __mod_node_page_state(struct pglist
 		x = 0;
 	}
 	__this_cpu_write(*p, x);
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 }
 EXPORT_SYMBOL(__mod_node_page_state);
 
@@ -391,6 +411,10 @@ void __inc_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
+	/* See __mod_node_page_state */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
@@ -399,6 +423,9 @@ void __inc_zone_state(struct zone *zone,
 		zone_page_state_add(v + overstep, zone, item);
 		__this_cpu_write(*p, -overstep);
 	}
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 }
 
 void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
@@ -409,6 +436,10 @@ void __inc_node_state(struct pglist_data
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
+	/* See __mod_node_page_state */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
@@ -417,6 +448,9 @@ void __inc_node_state(struct pglist_data
 		node_page_state_add(v + overstep, pgdat, item);
 		__this_cpu_write(*p, -overstep);
 	}
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 }
 
 void __inc_zone_page_state(struct page *page, enum zone_stat_item item)
@@ -437,6 +471,10 @@ void __dec_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
+	/* See __mod_node_page_state */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
@@ -445,6 +483,9 @@ void __dec_zone_state(struct zone *zone,
 		zone_page_state_add(v - overstep, zone, item);
 		__this_cpu_write(*p, overstep);
 	}
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 }
 
 void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
@@ -455,6 +496,10 @@ void __dec_node_state(struct pglist_data
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
+	/* See __mod_node_page_state */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
@@ -463,6 +508,9 @@ void __dec_node_state(struct pglist_data
 		node_page_state_add(v - overstep, pgdat, item);
 		__this_cpu_write(*p, overstep);
 	}
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 }
 
 void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
_

Patches currently in -mm which might be from mingo@elte.hu are


