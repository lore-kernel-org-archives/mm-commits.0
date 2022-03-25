Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6700C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357327AbiCYBcI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357321AbiCYBbw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9412DD42
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19C86617C7
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A22C340EC;
        Fri, 25 Mar 2022 01:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171818;
        bh=RX6kYIbazR1oIcUiNJUNvHBZyUvhs48YzGLF3cDWYK4=;
        h=Date:To:From:Subject:From;
        b=X3dXEI2dCMtjQPlgHdYMypBCKi9ylj/kxxuyEs4Lc6ysN0JY2O2zn80b6Vx+qz5BG
         pfX7l160FpUqlopaWYysPNzH6qpA94HkHS0XDC9mI/za4x5jRPtM7b1E8HEtfM9GJA
         0STH79BZsQUdnKFYAZiUPVLKysH6GXDdy1dISs8E=
Date:   Thu, 24 Mar 2022 18:30:17 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com,
        chris@chrisdown.name, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch removed from -mm tree
Message-Id: <20220325013018.75A22C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: synchronously enforce memory.high for large overcharges
has been removed from the -mm tree.  Its filename was
     memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: synchronously enforce memory.high for large overcharges

The high limit is used to throttle the workload without invoking the
oom-killer.  Recently we tried to use the high limit to right size our
internal workloads.  More specifically dynamically adjusting the limits of
the workload without letting the workload get oom-killed.  However due to
the limitation of the implementation of high limit enforcement, we
observed the mechanism fails for some real workloads.

The high limit is enforced on return-to-userspace i.e.  the kernel let the
usage goes over the limit and when the execution returns to userspace, the
high reclaim is triggered and the process can get throttled as well. 
However this mechanism fails for workloads which do large allocations in a
single kernel entry e.g.  applications that mlock() a large chunk of
memory in a single syscall.  Such applications bypass the high limit and
can trigger the oom-killer.

To make high limit enforcement more robust, this patch makes the limit
enforcement synchronous only if the accumulated overcharge becomes larger
than MEMCG_CHARGE_BATCH.  So, most of the allocations would still be
throttled on the return-to-userspace path but only the extreme allocations
which accumulates large amount of overcharge without returning to the
userspace will be throttled synchronously.  The value MEMCG_CHARGE_BATCH
is a bit arbitrary but most of other places in the memcg codebase uses
this constant therefore for now uses the same one.

Link: https://lkml.kernel.org/r/20220211064917.2028469-5-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memcontrol.c~memcg-synchronously-enforce-memoryhigh-for-large-overcharges
+++ a/mm/memcontrol.c
@@ -2704,6 +2704,11 @@ done_restock:
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
+	    !(current->flags & PF_MEMALLOC) &&
+	    gfpflags_allow_blocking(gfp_mask)) {
+		mem_cgroup_handle_over_high();
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-sync-flush-only-if-periodic-flush-is-delayed.patch

