Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748B4C10F1E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiLLCRU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiLLCQZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDDDDED6
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1785BB80B67
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BAFC433F0;
        Mon, 12 Dec 2022 02:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811296;
        bh=/B2VTO1ZmwII0ed/+pBaArIv4wBuNCdm324/W/rtQNg=;
        h=Date:To:From:Subject:From;
        b=f539/0LAIQWPXUtZPTXSPEkV3rz8vtbNjY4ePoWy0PV6HzwFKJX5J29Yisq6LPVuJ
         ObZLBDJOib+I0A/w3SLwNozhbVj3/SWIzLIHIVg2MiyUJ0GiuMJtiY8GGR7MhjWgRX
         Wrl/FUwVE/YX3Vz/etIIiZhtEgpbIUG9vFwVwIkU=
Date:   Sun, 11 Dec 2022 18:14:55 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, yang.shi@linux.alibaba.com,
        weixugc@google.com, tj@kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net,
        bagasdotme@gmail.com, almasrymina@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-nodes=-arg-to-memoryreclaim.patch removed from -mm tree
Message-Id: <20221212021456.A3BAFC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add nodes= arg to memory.reclaim
has been removed from the -mm tree.  Its filename was
     mm-add-nodes=-arg-to-memoryreclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: mm: add nodes= arg to memory.reclaim
Date: Fri, 2 Dec 2022 14:35:31 -0800

The nodes= arg instructs the kernel to only scan the given nodes for
proactive reclaim.  For example use cases, consider a 2 tier memory
system:

nodes 0,1 -> top tier
nodes 2,3 -> second tier

$ echo "1m nodes=0" > memory.reclaim

This instructs the kernel to attempt to reclaim 1m memory from node 0. 
Since node 0 is a top tier node, demotion will be attempted first.  This
is useful to direct proactive reclaim to specific nodes that are under
pressure.

$ echo "1m nodes=2,3" > memory.reclaim

This instructs the kernel to attempt to reclaim 1m memory in the second
tier, since this tier of memory has no demotion targets the memory will be
reclaimed.

$ echo "1m nodes=0,1" > memory.reclaim

Instructs the kernel to reclaim memory from the top tier nodes, which can
be desirable according to the userspace policy if there is pressure on the
top tiers.  Since these nodes have demotion targets, the kernel will
attempt demotion first.

Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
reclaim""), the proactive reclaim interface memory.reclaim does both
reclaim and demotion.  Reclaim and demotion incur different latency costs
to the jobs in the cgroup.  Demoted memory would still be addressable by
the userspace at a higher latency, but reclaimed memory would need to
incur a pagefault.

The 'nodes' arg is useful to allow the userspace to control demotion and
reclaim independently according to its policy: if the memory.reclaim is
called on a node with demotion targets, it will attempt demotion first; if
it is called on a node without demotion targets, it will only attempt
reclaim.

Link: https://lkml.kernel.org/r/20221202223533.1785418-1-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   15 ++--
 include/linux/swap.h                    |    3 
 mm/memcontrol.c                         |   67 +++++++++++++++++-----
 mm/vmscan.c                             |    4 -
 4 files changed, 68 insertions(+), 21 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-add-nodes=-arg-to-memoryreclaim
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1245,17 +1245,13 @@ PAGE_SIZE multiple when read back.
 	This is a simple interface to trigger memory reclaim in the
 	target cgroup.
 
-	This file accepts a single key, the number of bytes to reclaim.
-	No nested keys are currently supported.
+	This file accepts a string which contains the number of bytes to
+	reclaim.
 
 	Example::
 
 	  echo "1G" > memory.reclaim
 
-	The interface can be later extended with nested keys to
-	configure the reclaim behavior. For example, specify the
-	type of memory to reclaim from (anon, file, ..).
-
 	Please note that the kernel can over or under reclaim from
 	the target cgroup. If less bytes are reclaimed than the
 	specified amount, -EAGAIN is returned.
@@ -1267,6 +1263,13 @@ PAGE_SIZE multiple when read back.
 	This means that the networking layer will not adapt based on
 	reclaim induced by memory.reclaim.
 
+	This file also allows the user to specify the nodes to reclaim from,
+	via the 'nodes=' key, for example::
+
+	  echo "1G nodes=0,1" > memory.reclaim
+
+	The above instructs the kernel to reclaim memory from nodes 0,1.
+
   memory.peak
 	A read-only single value file which exists on non-root
 	cgroups.
--- a/include/linux/swap.h~mm-add-nodes=-arg-to-memoryreclaim
+++ a/include/linux/swap.h
@@ -418,7 +418,8 @@ extern unsigned long try_to_free_pages(s
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
-						  unsigned int reclaim_options);
+						  unsigned int reclaim_options,
+						  nodemask_t *nodemask);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
--- a/mm/memcontrol.c~mm-add-nodes=-arg-to-memoryreclaim
+++ a/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
 #include <linux/seq_buf.h>
+#include <linux/parser.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -2392,7 +2393,8 @@ static unsigned long reclaim_high(struct
 		psi_memstall_enter(&pflags);
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
-							MEMCG_RECLAIM_MAY_SWAP);
+							MEMCG_RECLAIM_MAY_SWAP,
+							NULL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2683,7 +2685,8 @@ retry:
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options);
+						    gfp_mask, reclaim_options,
+						    NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -3503,7 +3506,8 @@ static int mem_cgroup_resize_max(struct
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-					memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP)) {
+					memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
+					NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -3614,7 +3618,8 @@ static int mem_cgroup_force_empty(struct
 			return -EINTR;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP))
+						  MEMCG_RECLAIM_MAY_SWAP,
+						  NULL))
 			nr_retries--;
 	}
 
@@ -6418,7 +6423,8 @@ static ssize_t memory_high_write(struct
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -6467,7 +6473,8 @@ static ssize_t memory_max_write(struct k
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL))
 				nr_reclaims--;
 			continue;
 		}
@@ -6590,21 +6597,54 @@ static ssize_t memory_oom_group_write(st
 	return nbytes;
 }
 
+enum {
+	MEMORY_RECLAIM_NODES = 0,
+	MEMORY_RECLAIM_NULL,
+};
+
+static const match_table_t if_tokens = {
+	{ MEMORY_RECLAIM_NODES, "nodes=%s" },
+	{ MEMORY_RECLAIM_NULL, NULL },
+};
+
 static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
-	unsigned int reclaim_options;
-	int err;
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
+				       MEMCG_RECLAIM_PROACTIVE;
+	char *old_buf, *start;
+	substring_t args[MAX_OPT_ARGS];
+	int token;
+	char value[256];
+	nodemask_t nodemask = NODE_MASK_ALL;
 
 	buf = strstrip(buf);
-	err = page_counter_memparse(buf, "", &nr_to_reclaim);
-	if (err)
-		return err;
 
-	reclaim_options	= MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
+	old_buf = buf;
+	nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
+	if (buf == old_buf)
+		return -EINVAL;
+
+	buf = strstrip(buf);
+
+	while ((start = strsep(&buf, " ")) != NULL) {
+		if (!strlen(start))
+			continue;
+		token = match_token(start, if_tokens, args);
+		match_strlcpy(value, args, sizeof(value));
+		switch (token) {
+		case MEMORY_RECLAIM_NODES:
+			if (nodelist_parse(value, nodemask) < 0)
+				return -EINVAL;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
 	while (nr_reclaimed < nr_to_reclaim) {
 		unsigned long reclaimed;
 
@@ -6621,7 +6661,8 @@ static ssize_t memory_reclaim(struct ker
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						nr_to_reclaim - nr_reclaimed,
-						GFP_KERNEL, reclaim_options);
+						GFP_KERNEL, reclaim_options,
+						&nodemask);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
--- a/mm/vmscan.c~mm-add-nodes=-arg-to-memoryreclaim
+++ a/mm/vmscan.c
@@ -6758,7 +6758,8 @@ unsigned long mem_cgroup_shrink_node(str
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-					   unsigned int reclaim_options)
+					   unsigned int reclaim_options,
+					   nodemask_t *nodemask)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6773,6 +6774,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.nodemask = nodemask,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
_

Patches currently in -mm which might be from almasrymina@google.com are


