Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF35DC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjBCGwi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjBCGvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243BD4B754
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B13E461DC7
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9A6C433EF;
        Fri,  3 Feb 2023 06:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407092;
        bh=Er4cwvcxick7MgkFvRSd5OId6sO53jjZbR3SYXkSVvQ=;
        h=Date:To:From:Subject:From;
        b=ei9lUawzzLKdSQas3kD6XWJ/wx2OX65Zz0e5J7l4wuSiHkCyrSH8r7Z0p0oC1sRsf
         D8hn2OxlNL1+f3Ca+HpSrUdtS4Kfd1sQXTaED6ZdbBuIgq4e5EsZXWztR3apCcwPxE
         f3de938fOTJfo2koYLbZQcVaKbYpM3ivhqUNoR/0=
Date:   Thu, 02 Feb 2023 22:51:31 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vschneid@redhat.com, vincent.guittot@linaro.org, vbabka@suse.cz,
        tj@kernel.org, shakeelb@google.com, rostedt@goodmis.org,
        roman.gushchin@linux.dev, rientjes@google.com,
        peterz@infradead.org, penberg@kernel.org, muchun.song@linux.dev,
        mingo@redhat.com, mgorman@techsingularity.net,
        juri.lelli@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        dietmar.eggemann@arm.com, dennis@kernel.org, dave@stgolabs.net,
        cl@linux.com, bsegall@google.com, bristot@redhat.com,
        42.hyeyoo@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kconfigdebug-do-not-enable-debug_preempt-by-default.patch removed from -mm tree
Message-Id: <20230203065132.0D9A6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/Kconfig.debug: do not enable DEBUG_PREEMPT by default
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-do-not-enable-debug_preempt-by-default.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: lib/Kconfig.debug: do not enable DEBUG_PREEMPT by default
Date: Sat, 21 Jan 2023 12:39:42 +0900

In workloads where this_cpu operations are frequently performed,
enabling DEBUG_PREEMPT may result in significant increase in
runtime overhead due to frequent invocation of
__this_cpu_preempt_check() function.

This can be demonstrated through benchmarks such as hackbench where this
configuration results in a 10% reduction in performance, primarily due to
the added overhead within memcg charging path.

Therefore, do not to enable DEBUG_PREEMPT by default and make users aware
of its potential impact on performance in some workloads.

hackbench-process-sockets
		      debug_preempt	 no_debug_preempt
Amean     1       0.4743 (   0.00%)      0.4295 *   9.45%*
Amean     4       1.4191 (   0.00%)      1.2650 *  10.86%*
Amean     7       2.2677 (   0.00%)      2.0094 *  11.39%*
Amean     12      3.6821 (   0.00%)      3.2115 *  12.78%*
Amean     21      6.6752 (   0.00%)      5.7956 *  13.18%*
Amean     30      9.6646 (   0.00%)      8.5197 *  11.85%*
Amean     48     15.3363 (   0.00%)     13.5559 *  11.61%*
Amean     79     24.8603 (   0.00%)     22.0597 *  11.27%*
Amean     96     30.1240 (   0.00%)     26.8073 *  11.01%*

Link: https://lkml.kernel.org/r/20230121033942.350387-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ben Segall <bsegall@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/Kconfig.debug~lib-kconfigdebug-do-not-enable-debug_preempt-by-default
+++ a/lib/Kconfig.debug
@@ -1246,13 +1246,16 @@ config DEBUG_TIMEKEEPING
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPTION && TRACE_IRQFLAGS_SUPPORT
-	default y
 	help
 	  If you say Y here then the kernel will use a debug variant of the
 	  commonly used smp_processor_id() function and will print warnings
 	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
 	  will detect preemption count underflows.
 
+	  This option has potential to introduce high runtime overhead,
+	  depending on workload as it triggers debugging routines for each
+	  this_cpu operation. It should only be used for debugging purposes.
+
 menu "Lock Debugging (spinlocks, mutexes, etc...)"
 
 config LOCK_DEBUGGING_SUPPORT
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


