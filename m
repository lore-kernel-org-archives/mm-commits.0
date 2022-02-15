Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF0AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbiBOUtP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:49:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244165AbiBOUtO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:49:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31A5BC1E
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:49:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8418361871
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83C1C340EB;
        Tue, 15 Feb 2022 20:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958142;
        bh=XUaM5FTu0j3L9v1y4Ku9SqAf7WJJi1LHZhsTy29o97A=;
        h=Date:To:From:Subject:From;
        b=fF74FHWKucbKKppIsmIZRaUh7hMDo2YEZaS421ijN+97mAwA3qJUTOEkps1QWqMuJ
         gbsATy2ktSL/z6UbRgHa/PRBxweC/FpazQtv9rQp75Doi2Xv7iqVIDYsvQcQNfVx1V
         69hq8t2kofC7sfjBIVYc8mAhBU380LaiZI7QTLI0=
Date:   Tue, 15 Feb 2022 12:49:01 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        guro@fb.com, chris@chrisdown.name, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch added to -mm tree
Message-Id: <20220215204901.D83C1C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: synchronously enforce memory.high for large overcharges
has been added to the -mm tree.  Its filename is
     memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
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

memcg-replace-in_interrupt-with-in_task.patch
memcg-refactor-mem_cgroup_oom.patch
memcg-unify-force-charging-conditions.patch
selftests-memcg-test-high-limit-for-single-entry-allocation.patch
memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch

