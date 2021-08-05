Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D892C4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4264160EB9
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhHEXWk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhHEXWk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C7B861104;
        Thu,  5 Aug 2021 23:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628205744;
        bh=Dk4kJ3URn/Q9A6TDSl/tVtNxP3jdsLaixeCPXZ5BCBc=;
        h=Date:From:To:Subject:From;
        b=Ar0B78urdGQyGvGoLeew30FpXIgm0DlBT4HtXCKwqJWAwluBuEy60cWNKAhI0TTXx
         rMQ0L251pMck7LeL0GN+5O05Gqv8mrSJuNyFZaDZGwtVEUYvaSNM2hDIERzGidy7ap
         xfhtbuUxqcxIiQ+HxxJWrswQU67Bpl1S9cO4A018=
Date:   Thu, 05 Aug 2021 16:22:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        mingo@kernel.org, mgorman@techsingularity.net, hughd@google.com,
        mingo@elte.hu
Subject:  [to-be-updated]
 mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt.patch removed
 from -mm tree
Message-ID: <20210805232221.lQOBh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: protect per cpu variables with preempt disable on RT
has been removed from the -mm tree.  Its filename was
     mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ingo Molnar <mingo@elte.hu>
Subject: mm/vmstat: protect per cpu variables with preempt disable on RT

Disable preemption on -RT for the vmstat code.  On vanilla the code runs
in IRQ-off regions while on -RT it may not when stats are updated under a
local_lock.  "preempt_disable" ensures that the same resources are not
updated in parallel due to preemption.

This patch differs from the preempt-rt version where __count_vm_event and
__count_vm_events are also protected.  The counters are explicitly
"allowed to be to be racy" so there is no need to protect them from
preemption.  Only the accurate page stats that are updated by a
read-modify-write need protection.

Link: https://lkml.kernel.org/r/20210723100034.13353-3-mgorman@techsingularity.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/vmstat.c~mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt
+++ a/mm/vmstat.c
@@ -319,6 +319,7 @@ void __mod_zone_page_state(struct zone *
 	long x;
 	long t;
 
+	preempt_disable_rt();
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -328,6 +329,7 @@ void __mod_zone_page_state(struct zone *
 		x = 0;
 	}
 	__this_cpu_write(*p, x);
+	preempt_enable_rt();
 }
 EXPORT_SYMBOL(__mod_zone_page_state);
 
@@ -350,6 +352,7 @@ void __mod_node_page_state(struct pglist
 		delta >>= PAGE_SHIFT;
 	}
 
+	preempt_disable_rt();
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -359,6 +362,7 @@ void __mod_node_page_state(struct pglist
 		x = 0;
 	}
 	__this_cpu_write(*p, x);
+	preempt_enable_rt();
 }
 EXPORT_SYMBOL(__mod_node_page_state);
 
@@ -391,6 +395,7 @@ void __inc_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
+	preempt_disable_rt();
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
@@ -399,6 +404,7 @@ void __inc_zone_state(struct zone *zone,
 		zone_page_state_add(v + overstep, zone, item);
 		__this_cpu_write(*p, -overstep);
 	}
+	preempt_enable_rt();
 }
 
 void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
@@ -409,6 +415,7 @@ void __inc_node_state(struct pglist_data
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
+	preempt_disable_rt();
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
@@ -417,6 +424,7 @@ void __inc_node_state(struct pglist_data
 		node_page_state_add(v + overstep, pgdat, item);
 		__this_cpu_write(*p, -overstep);
 	}
+	preempt_enable_rt();
 }
 
 void __inc_zone_page_state(struct page *page, enum zone_stat_item item)
@@ -437,6 +445,7 @@ void __dec_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
+	preempt_disable_rt();
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
@@ -445,6 +454,7 @@ void __dec_zone_state(struct zone *zone,
 		zone_page_state_add(v - overstep, zone, item);
 		__this_cpu_write(*p, overstep);
 	}
+	preempt_enable_rt();
 }
 
 void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
@@ -455,6 +465,7 @@ void __dec_node_state(struct pglist_data
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
+	preempt_disable_rt();
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
@@ -463,6 +474,7 @@ void __dec_node_state(struct pglist_data
 		node_page_state_add(v - overstep, pgdat, item);
 		__this_cpu_write(*p, overstep);
 	}
+	preempt_enable_rt();
 }
 
 void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
_

Patches currently in -mm which might be from mingo@elte.hu are


