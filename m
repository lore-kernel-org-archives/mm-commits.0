Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAEDC6FD1D
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 19:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCQTG3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 15:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCQTG2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 15:06:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D43B56509
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 12:06:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1FFC61323
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 19:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081A8C433D2;
        Fri, 17 Mar 2023 19:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679079986;
        bh=a/B85FhXY7w37tXgKiGYtzC09nKQXnqLhsGAb9wr34c=;
        h=Date:To:From:Subject:From;
        b=YW0getuSx3sq++iehVO+5t0ZZsUV8DGwPeC0wmVI/BcufiUzW11sw1NyjSqOcmpID
         6mka8NPkyTwZOtE5GhpsQAv7tR+LkbzHH72SpXlPYHwAyjp58Yo/fMl8M5Ob2gL97x
         GhOQrz3p5dcuQmSU1M/9HjsE8Y14qfIHyNLlnXBA=
Date:   Fri, 17 Mar 2023 12:06:25 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        shakeelb@google.com, roman.gushchin@linux.dev,
        peterz@infradead.org, muchun.song@linux.dev, mtosatti@redhat.com,
        mingo@elte.hu, mhocko@suse.com, leobras@redhat.com,
        hannes@cmpxchg.org, frederic@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-isolation-add-cpu_is_isolated-api.patch added to mm-unstable branch
Message-Id: <20230317190626.081A8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched/isolation: add cpu_is_isolated() API
has been added to the -mm mm-unstable branch.  Its filename is
     sched-isolation-add-cpu_is_isolated-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-isolation-add-cpu_is_isolated-api.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

sched-isolation-add-cpu_is_isolated-api.patch

