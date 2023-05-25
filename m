Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52291C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 20:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbjEYUlu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 16:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbjEYUlt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 16:41:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9515BB
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 13:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6173364AE0
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 20:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC0EC4339B;
        Thu, 25 May 2023 20:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685047306;
        bh=eKfux2HDdx6fsceE1A9VgapeeKY3sB7YJwzPxLJA0uw=;
        h=Date:To:From:Subject:From;
        b=OUt4xc6LZ2qrEqzziguK/TQb9fY9YAyi0jn3bchEJEFS3lINwtUhgIlk07ze84Lgm
         o6QdSyCTZMbm1/vX+sJgVyLPlAOODQvh5DDc9/N5aj4zPa1kc5TlqcXlhj2KMM/R8d
         iT9EkE76NOx4JMp53h7MuGNB8LAdlZyZMWsn0cx4=
Date:   Thu, 25 May 2023 13:41:45 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net,
        lars@pixar.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-export-memcgswap-watermark-via-sysfs-for-v2-memcg.patch added to mm-unstable branch
Message-Id: <20230525204146.ACC0EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: export memcg.swap watermark via sysfs for v2 memcg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-export-memcgswap-watermark-via-sysfs-for-v2-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-export-memcgswap-watermark-via-sysfs-for-v2-memcg.patch

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

mm-memcontrol-export-memcgswap-watermark-via-sysfs-for-v2-memcg.patch

