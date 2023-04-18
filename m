Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CBAC77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjDRXde (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjDRXdc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6630276A0
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4770262F18
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC86C433EF;
        Tue, 18 Apr 2023 23:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860810;
        bh=syZ9zo02d5HN0S/nCNteanztfJwtmfOCeFTAafnLhB4=;
        h=Date:To:From:Subject:From;
        b=CAf2o5bczTWeH4ZcODIVc3rRBHUaMVExJjhOus9Xt4vuJFkGiar/Oo8NyejYOV97U
         AvxoTNuiQ7QyWrRtVIWhOdGBq5IIh5Qmo3mQ8gcHl/vrvRJBk8wZknd5hUk3SG6qTa
         5buv7J4ZGCh3gwgTz/i2tuQNVEuIQElzJ38DOIc4=
Date:   Tue, 18 Apr 2023 16:33:30 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        shakeelb@google.com, roman.gushchin@linux.dev,
        peterz@infradead.org, muchun.song@linux.dev, mtosatti@redhat.com,
        mingo@elte.hu, leobras@redhat.com, hannes@cmpxchg.org,
        frederic@kernel.org, mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus.patch removed from -mm tree
Message-Id: <20230418233330.9DC86C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: do not drain charge pcp caches on remote isolated cpus
has been removed from the -mm tree.  Its filename was
     memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg: do not drain charge pcp caches on remote isolated cpus
Date: Fri, 17 Mar 2023 14:44:48 +0100

Leonardo Bras has noticed that pcp charge cache draining might be
disruptive on workloads relying on 'isolated cpus', a feature commonly
used on workloads that are sensitive to interruption and context switching
such as vRAN and Industrial Control Systems.

There are essentially two ways how to approach the issue.  We can either
allow the pcp cache to be drained on a different rather than a local cpu
or avoid remote flushing on isolated cpus.

The current pcp charge cache is really optimized for high performance and
it always relies to stick with its cpu.  That means it only requires
local_lock (preempt_disable on !RT) and draining is handed over to pcp WQ
to drain locally again.

The former solution (remote draining) would require to add an additional
locking to prevent local charges from racing with the draining.  This adds
an atomic operation to otherwise simple arithmetic fast path in the
try_charge path.  Another concern is that the remote draining can cause a
lock contention for the isolated workloads and therefore interfere with it
indirectly via user space interfaces.

Another option is to avoid draining scheduling on isolated cpus
altogether.  That means that those remote cpus would keep their charges
even after drain_all_stock returns.  This is certainly not optimal either
but it shouldn't really cause any major problems.  In the worst case (many
isolated cpus with charges - each of them with MEMCG_CHARGE_BATCH i.e 64
page) the memory consumption of a memcg would be artificially higher than
can be immediately used from other cpus.

Theoretically a memcg OOM killer could be triggered pre-maturely. 
Currently it is not really clear whether this is a practical problem
though.  Tight memcg limit would be really counter productive to cpu
isolated workloads pretty much by definition because any memory reclaimed
induced by memcg limit could break user space timing expectations as those
usually expect execution in the userspace most of the time.

Also charges could be left behind on memcg removal.  Any future charge on
those isolated cpus will drain that pcp cache so this won't be a permanent
leak.

Considering cons and pros of both approaches this patch is implementing
the second option and simply do not schedule remote draining if the target
cpu is isolated.  This solution is much more simpler.  It doesn't add any
new locking and it is more more predictable from the user space POV. 
Should the pre-mature memcg OOM become a real life problem, we can revisit
this decision.

[akpm@linux-foundation.org: memcontrol.c needs sched/isolation.h]
  Link: https://lore.kernel.org/oe-kbuild-all/202303180617.7E3aIlHf-lkp@intel.com/
Link: https://lkml.kernel.org/r/20230317134448.11082-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reported-by: Leonardo Bras <leobras@redhat.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus
+++ a/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
 #include <linux/seq_buf.h>
+#include <linux/sched/isolation.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -2366,7 +2367,7 @@ static void drain_all_stock(struct mem_c
 		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
 			if (cpu == curcpu)
 				drain_local_stock(&stock->work);
-			else
+			else if (!cpu_is_isolated(cpu))
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
_

Patches currently in -mm which might be from mhocko@suse.com are


