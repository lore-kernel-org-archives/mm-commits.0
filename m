Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5055EC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3363361158
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhIHWTH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 18:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235377AbhIHWTG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 18:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DECE6113A;
        Wed,  8 Sep 2021 22:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631139478;
        bh=qPu9SLKScCBklSmSTRxNrrfpi44aPVfRJfKUgbGVIew=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nZH3GxuyxjzncPKa9hQzTkVSf5ve3DtWUJwC0a7TV2opzeuHnNLC0ECPTRjJF//Ou
         lyJCU63X9XllVq1vudRc/JxM4huIlR48W5HmhoW23cZw9A+17F/WvUUvyk8rHckUhN
         VNuwzgy94E9UfU5oJKs6al01j7Xc4gkgFo1DYDg4=
Date:   Wed, 08 Sep 2021 15:17:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mingo@elte.hu,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 01/10] mm/vmstat: protect per cpu variables with
 preempt disable on RT
Message-ID: <20210908221757.XbXkMPWjB%akpm@linux-foundation.org>
In-Reply-To: <20210908151729.c9a15a9508ba0aed22289c76@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
