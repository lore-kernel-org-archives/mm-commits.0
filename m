Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E823FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 22:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbiEJWYL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 18:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiEJWYG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 18:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697A628ED34
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 15:24:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0077A61800
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 22:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F56CC385CF;
        Tue, 10 May 2022 22:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652221444;
        bh=0WjUZ8SWsDvldaTg1LNmvpZ3Z39RWfo1B5J3rr9Oni4=;
        h=Date:To:From:Subject:From;
        b=jRINyUJqsdhtiDSQXR2WEEe1mVd6ysI0rkc1dMb6L7bRy5L6dzucR0P2Jp3zKVH8u
         4AXW/KXm3c3YDCMCasRhQB3u+cj+3NOQkXsEhlzbu3B2bqey2isVJ3dhjSyUbbGo3D
         ikEAEs7aKG3s+kju2RLA9+kdpXFkAinjT56Cjf9Q=
Date:   Tue, 10 May 2022 15:24:03 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        rganesan@arista.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-export-memcg-watermark-via-sysfs-for-v2-memcg.patch added to mm-unstable branch
Message-Id: <20220510222404.4F56CC385CF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: export memcg->watermark via sysfs for v2 memcg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-export-memcg-watermark-via-sysfs-for-v2-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-export-memcg-watermark-via-sysfs-for-v2-memcg.patch

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
From: Ganesan Rajagopal <rganesan@arista.com>
Subject: mm/memcontrol: export memcg->watermark via sysfs for v2 memcg

We run a lot of automated tests when building our software and run into
OOM scenarios when the tests run unbounded.  v1 memcg exports
memcg->watermark as "memory.max_usage_in_bytes" in sysfs.  We use this
metric to heuristically limit the number of tests that can run in parallel
based on per test historical data.

This metric is currently not exported for v2 memcg and there is no other
easy way of getting this information.  getrusage() syscall returns
"ru_maxrss" which can be used as an approximation but that's the max RSS
of a single child process across all children instead of the aggregated
max for all child processes.  The only work around is to periodically poll
"memory.current" but that's not practical for short-lived one-off cgroups.

Hence, expose memcg->watermark as "memory.peak" for v2 memcg.

Link: https://lkml.kernel.org/r/20220507050916.GA13577@us192.sjc.aristanetworks.com
Signed-off-by: Ganesan Rajagopal <rganesan@arista.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    7 +++++++
 mm/memcontrol.c                         |   13 +++++++++++++
 2 files changed, 20 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-export-memcg-watermark-via-sysfs-for-v2-memcg
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1229,6 +1229,13 @@ PAGE_SIZE multiple when read back.
 	the target cgroup. If less bytes are reclaimed than the
 	specified amount, -EAGAIN is returned.
 
+  memory.peak
+	A read-only single value file which exists on non-root
+	cgroups.
+
+	The max memory usage recorded for the cgroup and its
+	descendants since the creation of the cgroup.
+
   memory.oom.group
 	A read-write single value file which exists on non-root
 	cgroups.  The default value is "0".
--- a/mm/memcontrol.c~mm-memcontrol-export-memcg-watermark-via-sysfs-for-v2-memcg
+++ a/mm/memcontrol.c
@@ -6146,6 +6146,14 @@ static u64 memory_current_read(struct cg
 	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
+static u64 memory_peak_read(struct cgroup_subsys_state *css,
+			    struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)memcg->memory.watermark * PAGE_SIZE;
+}
+
 static int memory_min_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
@@ -6450,6 +6458,11 @@ static struct cftype memory_files[] = {
 		.read_u64 = memory_current_read,
 	},
 	{
+		.name = "peak",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = memory_peak_read,
+	},
+	{
 		.name = "min",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = memory_min_show,
_

Patches currently in -mm which might be from rganesan@arista.com are

mm-memcontrol-export-memcg-watermark-via-sysfs-for-v2-memcg.patch

