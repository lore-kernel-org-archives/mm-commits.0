Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9BDC433FE
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 19:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbiENT4W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 May 2022 15:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiENTza (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 May 2022 15:55:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED873377F4
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 12:55:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BE13B80AFE
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 19:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4267BC340EE;
        Sat, 14 May 2022 19:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652558126;
        bh=Nti7zrSa8KZrn+gdYyScyq5csbqfuZ/O5eGXaT0dhC0=;
        h=Date:To:From:Subject:From;
        b=1ScEDZqiTxPC2PLgZQYBhj8eeijx+JIZNSl733JS9ocfO0oFv38FkHuUpMjvklbU8
         x49jfqwO7zrkLDG8U6USEvXO0BnPqfqVtyOOdIA8OPWufkyU6W+FUAvpve1pb+r2UF
         /bnmigTN+C2NkzIsF5TmXzt+6Oqpcer0PG6wCt3s=
Date:   Sat, 14 May 2022 12:55:25 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        hannes@cmpxchg.org, rganesan@arista.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-export-memcg-watermark-via-sysfs-for-v2-memcg.patch removed from -mm tree
Message-Id: <20220514195526.4267BC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol: export memcg->watermark via sysfs for v2 memcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-export-memcg-watermark-via-sysfs-for-v2-memcg.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
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
@@ -6103,6 +6103,14 @@ static u64 memory_current_read(struct cg
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
@@ -6407,6 +6415,11 @@ static struct cftype memory_files[] = {
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


