Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F690C77B7E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjDRXdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDRXdb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD197ABA
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21E5662CA1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793F7C433D2;
        Tue, 18 Apr 2023 23:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860809;
        bh=OfvMjc8OU7hroYTxjGAwDbhXB0LLZN4h6UG+BiifCRg=;
        h=Date:To:From:Subject:From;
        b=cRf5Gerk9/dkl4mpDzVDe4OeWtzwEWSfFd6D5hSuO4n+Gcfcb377I3fq/KFig98cm
         mRGgu0AJejjJlPZJrYCe/iZI7L+iSybRTpSmrwJntlOvr2+JZvjcdNuMcXqAE5maFK
         3/AdTJ1NfzPSWU8opqpC7Owx3qugY2x5eQqAgr8w=
Date:   Tue, 18 Apr 2023 16:33:28 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        shakeelb@google.com, roman.gushchin@linux.dev,
        peterz@infradead.org, muchun.song@linux.dev, mtosatti@redhat.com,
        mingo@elte.hu, mhocko@suse.com, leobras@redhat.com,
        hannes@cmpxchg.org, frederic@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-isolation-add-cpu_is_isolated-api.patch removed from -mm tree
Message-Id: <20230418233329.793F7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched/isolation: add cpu_is_isolated() API
has been removed from the -mm tree.  Its filename was
     sched-isolation-add-cpu_is_isolated-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frederic Weisbecker <frederic@kernel.org>
Subject: sched/isolation: add cpu_is_isolated() API
Date: Fri, 17 Mar 2023 14:44:47 +0100

Patch series "memcg, cpuisol: do not interfere pcp cache charges draining
with cpuisol workloads".

Leonardo has reported [1] that pcp memcg charge draining can interfere
with cpu isolated workloads.  The said draining is done from a WQ context
with a pcp worker scheduled on each CPU which holds any cached charges for
a specific memcg hierarchy.  Operation is not really a common operation
[2].  It can be triggered from the userspace though so some care is
definitely due.

Leonardo has tried to address the issue by allowing remote charge draining
[3].  This approach requires an additional locking to synchronize pcp
caches sync from a remote cpu from local pcp consumers.  Even though the
proposed lock was per-cpu there is still potential for contention and less
predictable behavior.

This patchset addresses the issue from a different angle.  Rather than
dealing with a potential synchronization, cpus which are isolated are
simply never scheduled to be drained.  This means that a small amount of
charges could be laying around and waiting for a later use or they are
flushed when a different memcg is charged from the same cpu.  More details
are in patch 2.  The first patch from Frederic is implementing an
abstraction to tell whether a specific cpu has been isolated and therefore
require a special treatment.


This patch (of 2):

Provide this new API to check if a CPU has been isolated either through
isolcpus= or nohz_full= kernel parameter.

It aims at avoiding kernel load deemed to be safely spared on CPUs running
sensitive workload that can't bear any disturbance, such as pcp cache
draining.

Link: https://lkml.kernel.org/r/20230317134448.11082-1-mhocko@kernel.org
Link: https://lkml.kernel.org/r/20230317134448.11082-2-mhocko@kernel.org
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Leonardo Bras <leobras@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/isolation.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/include/linux/sched/isolation.h~sched-isolation-add-cpu_is_isolated-api
+++ a/include/linux/sched/isolation.h
@@ -46,6 +46,12 @@ static inline bool housekeeping_enabled(
 
 static inline void housekeeping_affine(struct task_struct *t,
 				       enum hk_type type) { }
+
+static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
+{
+	return true;
+}
+
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
@@ -58,4 +64,10 @@ static inline bool housekeeping_cpu(int
 	return true;
 }
 
+static inline bool cpu_is_isolated(int cpu)
+{
+	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
+		 !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
+}
+
 #endif /* _LINUX_SCHED_ISOLATION_H */
_

Patches currently in -mm which might be from frederic@kernel.org are


