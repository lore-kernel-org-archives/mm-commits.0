Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F537C432BE
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 20:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85FE060F37
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 20:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhGWTXa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 15:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhGWTXa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 15:23:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22B5560F36;
        Fri, 23 Jul 2021 20:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627070643;
        bh=4DmKIPju7LUYI9SuiZAEL1QqbMs9wxaZ/awjTFfue8w=;
        h=Date:From:To:Subject:From;
        b=1/j3hF9JTBMdzOBj0O9022pRNZDLu4DiteUPHXNoGPh9ErdPDq3BtoNXEIG6E1N5Z
         /cWGqa2Iubg1SLbS5Ar0ObjzXwo1bhWjnq3n/lwgr9YYQ5w9HkL0u1THbgpgKmZIyZ
         rJpqxPeYPDN5jnIOc9us2HEJ7CySXWgDIuE6Zfok=
Date:   Fri, 23 Jul 2021 13:04:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        mingo@kernel.org, mgorman@techsingularity.net, hughd@google.com,
        mingo@elte.hu
Subject:  +
 mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt.patch added to
 -mm tree
Message-ID: <20210723200402.7oh01%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: protect per cpu variables with preempt disable on RT
has been added to the -mm tree.  Its filename is
     mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmstat-protect-per-cpu-variables-with-preempt-disable-on-rt.patch

