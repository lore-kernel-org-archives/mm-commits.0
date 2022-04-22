Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67459C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiDVWrQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbiDVWqp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:46:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D6D21D001
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 14:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 497E4B8327E
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 21:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8B2C385A0;
        Fri, 22 Apr 2022 21:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650663467;
        bh=DEb/W9NF5KMBtZPhKe/1tO8YpbtFg7kNZL5LsXonWrU=;
        h=Date:To:From:Subject:From;
        b=rgsKAGwoxNJ6nGS71RrkXRcVb4luegTdoGr2i6o8G12Q5BnMfw/IXmgihCWXtVHZi
         Ia4C9GTDJ+7eSV2N7HJZmVhrfHHsgcSh0fA+kK1aHQL0PGnw2MXpF/gqA2MqUhHorU
         8cDzSJQ1y6/ooWcuc9EuxpNYs8qjC2B7fhv8hXRo=
Date:   Fri, 22 Apr 2022 14:37:47 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, weixugc@google.com, vaibhav@linux.ibm.com,
        tj@kernel.org, tim.c.chen@linux.intel.com, shuah@kernel.org,
        schatzberg.dan@gmail.com, roman.gushchin@linux.dev,
        rientjes@google.com, mkoutny@suse.com, mhocko@suse.com,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, gthelen@google.com,
        dave.hansen@linux.intel.com, corbet@lwn.net, chenwandun@huawei.com,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-introduce-per-memcg-reclaim-interface.patch added to -mm tree
Message-Id: <20220422213747.BF8B2C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: introduce per-memcg reclaim interface
has been added to the -mm tree.  Its filename is
     memcg-introduce-per-memcg-reclaim-interface.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-introduce-per-memcg-reclaim-interface.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-introduce-per-memcg-reclaim-interface.patch

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
Subject: memcg: introduce per-memcg reclaim interface

Patch series "memcg: introduce per-memcg proactive reclaim", v4.

Add a memory.reclaim proactive reclaim interface.  The rationale behind
the interface and how it works are in the first patch.


This patch (of 4):

Introduce a memcg interface to trigger memory reclaim on a memory cgroup.

Use case: Proactive Reclaim
---------------------------

A userspace proactive reclaimer can continuously probe the memcg to
reclaim a small amount of memory.  This gives more accurate and up-to-date
workingset estimation as the LRUs are continuously sorted and can
potentially provide more deterministic memory overcommit behavior.  The
memory overcommit controller can provide more proactive response to the
changing behavior of the running applications instead of being reactive.

A userspace reclaimer's purpose in this case is not a complete replacement
for kswapd or direct reclaim, it is to proactively identify memory savings
opportunities and reclaim some amount of cold pages set by the policy to
free up the memory for more demanding jobs or scheduling new jobs.

A user space proactive reclaimer is used in Google data centers. 
Additionally, Meta's TMO paper recently referenced a very similar
interface used for user space proactive reclaim:
https://dl.acm.org/doi/pdf/10.1145/3503222.3507731

Benefits of a user space reclaimer:
-----------------------------------

1) More flexible on who should be charged for the cpu of the memory
   reclaim.  For proactive reclaim, it makes more sense to be centralized.

2) More flexible on dedicating the resources (like cpu).  The memory
   overcommit controller can balance the cost between the cpu usage and
   the memory reclaimed.

3) Provides a way to the applications to keep their LRUs sorted, so,
   under memory pressure better reclaim candidates are selected.  This
   also gives more accurate and uptodate notion of working set for an
   application.

Why memory.high is not enough?
------------------------------

- memory.high can be used to trigger reclaim in a memcg and can
  potentially be used for proactive reclaim.  However there is a big
  downside in using memory.high.  It can potentially introduce high
  reclaim stalls in the target application as the allocations from the
  processes or the threads of the application can hit the temporary
  memory.high limit.

- Userspace proactive reclaimers usually use feedback loops to decide
  how much memory to proactively reclaim from a workload.  The metrics
  used for this are usually either refaults or PSI, and these metrics will
  become messy if the application gets throttled by hitting the high
  limit.

- memory.high is a stateful interface, if the userspace proactive
  reclaimer crashes for any reason while triggering reclaim it can leave
  the application in a bad state.

- If a workload is rapidly expanding, setting memory.high to proactively
  reclaim memory can result in actually reclaiming more memory than
  intended.

The benefits of such interface and shortcomings of existing interface
were further discussed in this RFC thread:
https://lore.kernel.org/linux-mm/5df21376-7dd1-bf81-8414-32a73cea45dd@google.com/

Interface:
----------

Introduce a very simple memcg interface 'echo 10M > memory.reclaim' to
trigger reclaim in the target memory cgroup.

The interface is introduced as a nested-keyed file to allow for future
optional arguments to be easily added to configure the behavior of
reclaim.

Possible Extensions:
--------------------

- This interface can be extended with an additional parameter or flags
  to allow specifying one or more types of memory to reclaim from (e.g.
  file, anon, ..).

- The interface can also be extended with a node mask to reclaim from
  specific nodes. This has use cases for reclaim-based demotion in memory
  tiering systens.

- A similar per-node interface can also be added to support proactive
  reclaim and reclaim-based demotion in systems without memcg.

- Add a timeout parameter to make it easier for user space to call the
  interface without worrying about being blocked for an undefined amount
  of time.

For now, let's keep things simple by adding the basic functionality.

[yosryahmed@google.com: refreshed to current master, updated commit message based on recent discussions and use cases]
Link: https://lkml.kernel.org/r/20220421234426.3494842-2-yosryahmed@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Wei Xu <weixugc@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   21 ++++++++++
 mm/memcontrol.c                         |   44 ++++++++++++++++++++++
 2 files changed, 65 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-introduce-per-memcg-reclaim-interface
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1208,6 +1208,27 @@ PAGE_SIZE multiple when read back.
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
 
+  memory.reclaim
+	A write-only nested-keyed file which exists for all cgroups.
+
+	This is a simple interface to trigger memory reclaim in the
+	target cgroup.
+
+	This file accepts a single key, the number of bytes to reclaim.
+	No nested keys are currently supported.
+
+	Example::
+
+	  echo "1G" > memory.reclaim
+
+	The interface can be later extended with nested keys to
+	configure the reclaim behavior. For example, specify the
+	type of memory to reclaim from (anon, file, ..).
+
+	Please note that the kernel can over or under reclaim from
+	the target cgroup. If less bytes are reclaimed than the
+	specified amount, -EAGAIN is returned.
+
   memory.oom.group
 	A read-write single value file which exists on non-root
 	cgroups.  The default value is "0".
--- a/mm/memcontrol.c~memcg-introduce-per-memcg-reclaim-interface
+++ a/mm/memcontrol.c
@@ -6356,6 +6356,45 @@ static ssize_t memory_oom_group_write(st
 	return nbytes;
 }
 
+static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
+			      size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned long nr_to_reclaim, nr_reclaimed = 0;
+	int err;
+
+	buf = strstrip(buf);
+	err = page_counter_memparse(buf, "", &nr_to_reclaim);
+	if (err)
+		return err;
+
+	while (nr_reclaimed < nr_to_reclaim) {
+		unsigned long reclaimed;
+
+		if (signal_pending(current))
+			return -EINTR;
+
+		/* This is the final attempt, drain percpu lru caches in the
+		 * hope of introducing more evictable pages for
+		 * try_to_free_mem_cgroup_pages().
+		 */
+		if (!nr_retries)
+			lru_add_drain_all();
+
+		reclaimed = try_to_free_mem_cgroup_pages(memcg,
+						nr_to_reclaim - nr_reclaimed,
+						GFP_KERNEL, true);
+
+		if (!reclaimed && !nr_retries--)
+			return -EAGAIN;
+
+		nr_reclaimed += reclaimed;
+	}
+
+	return nbytes;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6414,6 +6453,11 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_oom_group_show,
 		.write = memory_oom_group_write,
 	},
+	{
+		.name = "reclaim",
+		.flags = CFTYPE_NS_DELEGATABLE,
+		.write = memory_reclaim,
+	},
 	{ }	/* terminate */
 };
 
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-introduce-per-memcg-reclaim-interface.patch

