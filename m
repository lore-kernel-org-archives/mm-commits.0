Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D50C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjFIXcy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjFIXbj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22A8469A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57EDB63EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9738C433EF;
        Fri,  9 Jun 2023 23:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353367;
        bh=nMUQkJ4OdVbUi3vas/cuu/ZLfrz4l+7hEcGYbDut7VE=;
        h=Date:To:From:Subject:From;
        b=LjDPGdwGfQess5xUb0X8aiTw60Z4PGZrjBSOs89Y/0DOuk0iX72jJIwNyxoKPEYsq
         0Ba4hQaPYZz1/kJup3T2zagS5cUWmHCRVN6W0lpfil+zNEg6IIpdJEg8D5wREzXLBV
         SJNo/vU75f/3yinkfSqaRPa2FnyPD1Kt1O9/jsnU=
Date:   Fri, 09 Jun 2023 16:29:27 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net,
        lars@pixar.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-export-memcgswap-watermark-via-sysfs-for-v2-memcg.patch removed from -mm tree
Message-Id: <20230609232927.A9738C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol: export memcg.swap watermark via sysfs for v2 memcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-export-memcgswap-watermark-via-sysfs-for-v2-memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lars R. Damerow" <lars@pixar.com>
Subject: mm/memcontrol: export memcg.swap watermark via sysfs for v2 memcg
Date: Wed, 24 May 2023 11:17:33 -0700

This patch is similar to commit 8e20d4b33266 ("mm/memcontrol: export
memcg->watermark via sysfs for v2 memcg"), but exports the swap counter's
watermark.

We allocate jobs to our compute farm using heuristics determined by memory
and swap usage from previous jobs.  Tracking the peak swap usage for new
jobs is important for determining when jobs are exceeding their expected
bounds, or when our baseline metrics are getting outdated.

Our toolset was written to use the "memory.memsw.max_usage_in_bytes" file
in cgroups v1, and altering it to poll cgroups v2's "memory.swap.current"
would give less accurate results as well as add complication to the code. 
Having this watermark exposed in sysfs is much preferred.

Link: https://lkml.kernel.org/r/20230524181734.125696-1-lars@pixar.com
Signed-off-by: Lars R. Damerow <lars@pixar.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    7 +++++++
 mm/memcontrol.c                         |   13 +++++++++++++
 2 files changed, 20 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-export-memcgswap-watermark-via-sysfs-for-v2-memcg
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1582,6 +1582,13 @@ PAGE_SIZE multiple when read back.
 
 	Healthy workloads are not expected to reach this limit.
 
+  memory.swap.peak
+	A read-only single value file which exists on non-root
+	cgroups.
+
+	The max swap usage recorded for the cgroup and its
+	descendants since the creation of the cgroup.
+
   memory.swap.max
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
--- a/mm/memcontrol.c~mm-memcontrol-export-memcgswap-watermark-via-sysfs-for-v2-memcg
+++ a/mm/memcontrol.c
@@ -7622,6 +7622,14 @@ static u64 swap_current_read(struct cgro
 	return (u64)page_counter_read(&memcg->swap) * PAGE_SIZE;
 }
 
+static u64 swap_peak_read(struct cgroup_subsys_state *css,
+			  struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)memcg->swap.watermark * PAGE_SIZE;
+}
+
 static int swap_high_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
@@ -7701,6 +7709,11 @@ static struct cftype swap_files[] = {
 		.write = swap_max_write,
 	},
 	{
+		.name = "swap.peak",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = swap_peak_read,
+	},
+	{
 		.name = "swap.events",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.file_offset = offsetof(struct mem_cgroup, swap_events_file),
_

Patches currently in -mm which might be from lars@pixar.com are


