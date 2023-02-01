Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3A2C38142
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjBAApC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjBAApA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:45:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B274F87F
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:44:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94E2D6174D
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE46FC433EF;
        Wed,  1 Feb 2023 00:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212298;
        bh=jpHk3roOtM1T6jz80GIHPJYxg3QrGYwq2FAa0FZ0Nbs=;
        h=Date:To:From:Subject:From;
        b=d2qqOyXKVMy2EGCJQBSNHrOhwwGhJ5Z0FbzFz8cMxJrVYcn+i4c+YWJOq/NI834GF
         w3MBwC7Wt+GuLlAvtix4ihNFsY6Wz40lKyUKx+2CNv5+YoquWluXfAxx1Xh9ERdbW3
         0Bo70kNLw7tRtgqjHA4qj7IpmTmM53eXdtZH6vQM=
Date:   Tue, 31 Jan 2023 16:44:57 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, yang.shi@linux.alibaba.com,
        weixugc@google.com, tj@kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net,
        bagasdotme@gmail.com, almasrymina@google.com, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-add-nodes=-arg-to-memoryreclaim.patch removed from -mm tree
Message-Id: <20230201004457.EE46FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm: add nodes= arg to memory.reclaim"
has been removed from the -mm tree.  Its filename was
     revert-mm-add-nodes=-arg-to-memoryreclaim.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: Revert "mm: add nodes= arg to memory.reclaim"
Date: Fri, 16 Dec 2022 10:46:33 +0100

This reverts commit 12a5d3955227b0d7e04fb793ccceeb2a1dd275c5.

Although it is recognized that a finer grained pro-active reclaim is
something we need and want the semantic of this implementation is really
ambiguous.

In a follow up discussion it became clear that there are two essential
usecases here.  One is to use memory.reclaim to pro-actively reclaim
memory and expectation is that the requested and reported amount of memory
is uncharged from the memcg.  Another usecase focuses on pro-active
demotion when the memory is merely shuffled around to demotion targets
while the overall charged memory stays unchanged.

The current implementation considers demoted pages as reclaimed and that
break both usecases.  [1] has tried to address the reporting part but
there are more issues with that summarized in [2] and follow up emails.

Let's revert the nodemask based extension of the memcg pro-active
reclaim for now until we settle with a more robust semantic.

[1] http://lkml.kernel.org/r/http://lkml.kernel.org/r/20221206023406.3182800-1-almasrymina@google.com
[2] http://lkml.kernel.org/r/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz

Link: https://lkml.kernel.org/r/Y5xASNe1x8cusiTx@dhcp22.suse.cz
Fixes: 12a5d3955227b0d ("mm: add nodes= arg to memory.reclaim")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   15 +---
 include/linux/swap.h                    |    3 
 mm/memcontrol.c                         |   67 ++++------------------
 mm/vmscan.c                             |    4 -
 4 files changed, 21 insertions(+), 68 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~revert-mm-add-nodes=-arg-to-memoryreclaim
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1245,13 +1245,17 @@ PAGE_SIZE multiple when read back.
 	This is a simple interface to trigger memory reclaim in the
 	target cgroup.
 
-	This file accepts a string which contains the number of bytes to
-	reclaim.
+	This file accepts a single key, the number of bytes to reclaim.
+	No nested keys are currently supported.
 
 	Example::
 
 	  echo "1G" > memory.reclaim
 
+	The interface can be later extended with nested keys to
+	configure the reclaim behavior. For example, specify the
+	type of memory to reclaim from (anon, file, ..).
+
 	Please note that the kernel can over or under reclaim from
 	the target cgroup. If less bytes are reclaimed than the
 	specified amount, -EAGAIN is returned.
@@ -1263,13 +1267,6 @@ PAGE_SIZE multiple when read back.
 	This means that the networking layer will not adapt based on
 	reclaim induced by memory.reclaim.
 
-	This file also allows the user to specify the nodes to reclaim from,
-	via the 'nodes=' key, for example::
-
-	  echo "1G nodes=0,1" > memory.reclaim
-
-	The above instructs the kernel to reclaim memory from nodes 0,1.
-
   memory.peak
 	A read-only single value file which exists on non-root
 	cgroups.
--- a/include/linux/swap.h~revert-mm-add-nodes=-arg-to-memoryreclaim
+++ a/include/linux/swap.h
@@ -418,8 +418,7 @@ extern unsigned long try_to_free_pages(s
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
-						  unsigned int reclaim_options,
-						  nodemask_t *nodemask);
+						  unsigned int reclaim_options);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
--- a/mm/memcontrol.c~revert-mm-add-nodes=-arg-to-memoryreclaim
+++ a/mm/memcontrol.c
@@ -63,7 +63,6 @@
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
 #include <linux/seq_buf.h>
-#include <linux/parser.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -2393,8 +2392,7 @@ static unsigned long reclaim_high(struct
 		psi_memstall_enter(&pflags);
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
-							MEMCG_RECLAIM_MAY_SWAP,
-							NULL);
+							MEMCG_RECLAIM_MAY_SWAP);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2685,8 +2683,7 @@ retry:
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options,
-						    NULL);
+						    gfp_mask, reclaim_options);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -3506,8 +3503,7 @@ static int mem_cgroup_resize_max(struct
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-					memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
-					NULL)) {
+					memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -3618,8 +3614,7 @@ static int mem_cgroup_force_empty(struct
 			return -EINTR;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP,
-						  NULL))
+						  MEMCG_RECLAIM_MAY_SWAP))
 			nr_retries--;
 	}
 
@@ -6429,8 +6424,7 @@ static ssize_t memory_high_write(struct
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -6479,8 +6473,7 @@ static ssize_t memory_max_write(struct k
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP))
 				nr_reclaims--;
 			continue;
 		}
@@ -6603,54 +6596,21 @@ static ssize_t memory_oom_group_write(st
 	return nbytes;
 }
 
-enum {
-	MEMORY_RECLAIM_NODES = 0,
-	MEMORY_RECLAIM_NULL,
-};
-
-static const match_table_t if_tokens = {
-	{ MEMORY_RECLAIM_NODES, "nodes=%s" },
-	{ MEMORY_RECLAIM_NULL, NULL },
-};
-
 static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
-	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
-				       MEMCG_RECLAIM_PROACTIVE;
-	char *old_buf, *start;
-	substring_t args[MAX_OPT_ARGS];
-	int token;
-	char value[256];
-	nodemask_t nodemask = NODE_MASK_ALL;
-
-	buf = strstrip(buf);
-
-	old_buf = buf;
-	nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
-	if (buf == old_buf)
-		return -EINVAL;
+	unsigned int reclaim_options;
+	int err;
 
 	buf = strstrip(buf);
+	err = page_counter_memparse(buf, "", &nr_to_reclaim);
+	if (err)
+		return err;
 
-	while ((start = strsep(&buf, " ")) != NULL) {
-		if (!strlen(start))
-			continue;
-		token = match_token(start, if_tokens, args);
-		match_strlcpy(value, args, sizeof(value));
-		switch (token) {
-		case MEMORY_RECLAIM_NODES:
-			if (nodelist_parse(value, nodemask) < 0)
-				return -EINVAL;
-			break;
-		default:
-			return -EINVAL;
-		}
-	}
-
+	reclaim_options	= MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
 	while (nr_reclaimed < nr_to_reclaim) {
 		unsigned long reclaimed;
 
@@ -6667,8 +6627,7 @@ static ssize_t memory_reclaim(struct ker
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						nr_to_reclaim - nr_reclaimed,
-						GFP_KERNEL, reclaim_options,
-						&nodemask);
+						GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
--- a/mm/vmscan.c~revert-mm-add-nodes=-arg-to-memoryreclaim
+++ a/mm/vmscan.c
@@ -6754,8 +6754,7 @@ unsigned long mem_cgroup_shrink_node(str
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-					   unsigned int reclaim_options,
-					   nodemask_t *nodemask)
+					   unsigned int reclaim_options)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6770,7 +6769,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
-		.nodemask = nodemask,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
_

Patches currently in -mm which might be from mhocko@suse.com are


