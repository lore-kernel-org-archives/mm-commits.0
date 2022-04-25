Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9813DC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 20:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237581AbiDYUVm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237389AbiDYUVl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 16:21:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B36F28E04
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 13:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B931F60ED2
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 20:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E26C385A7;
        Mon, 25 Apr 2022 20:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650917914;
        bh=VD21A42/1eLILpqYojOiQE5pUbZeih4QhqO/kVpmRkw=;
        h=Date:To:From:Subject:From;
        b=f7zuh7364pN+V9pxF2ilti9ky4dwJieoLIDQBh07af5mIntYiw/jKbUJPgbdxGusC
         /pJZYXTC5pXF8Ft0P90FCXj7N4rYtm4ZCho4VFwx274L5prEpySqVvBpaNZCVhKrhS
         4cPcTEvpvnIh39zKesmgAYLxdaSaIH5X34dRlI7I=
Date:   Mon, 25 Apr 2022 13:18:33 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, weixugc@google.com, vaibhav@linux.ibm.com,
        tj@kernel.org, tim.c.chen@linux.intel.com, shuah@kernel.org,
        roman.gushchin@linux.dev, rientjes@google.com, mkoutny@suse.com,
        mhocko@suse.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        gthelen@google.com, dave.hansen@linux.intel.com, corbet@lwn.net,
        chenwandun@huawei.com, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-introduce-per-memcg-reclaim-interface.patch added to -mm tree
Message-Id: <20220425201834.12E26C385A7@smtp.kernel.org>
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

This patch series adds a memory.reclaim proactive reclaim interface.
The rationale behind the interface and how it works are in the first
patch.


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

The benefits of such interface and shortcomings of existing interface were
further discussed in this RFC thread:
https://lore.kernel.org/linux-mm/5df21376-7dd1-bf81-8414-32a73cea45dd@google.com/

Interface:
----------

Introducing a very simple memcg interface 'echo 10M > memory.reclaim' to
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

[yosryahmed@google.com: worked on versions v2 onwards, refreshed to
current master, updated commit message based on recent
discussions and use cases]
Link: https://lkml.kernel.org/r/20220425190040.2475377-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20220425190040.2475377-2-yosryahmed@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Co-developed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Wei Xu <weixugc@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: "Michal Koutn" <mkoutny@suse.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   21 ++++++++++
 mm/memcontrol.c                         |   45 ++++++++++++++++++++++
 2 files changed, 66 insertions(+)

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
@@ -6360,6 +6360,46 @@ static ssize_t memory_oom_group_write(st
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
+		/*
+		 * This is the final attempt, drain percpu lru caches in the
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
@@ -6418,6 +6458,11 @@ static struct cftype memory_files[] = {
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

