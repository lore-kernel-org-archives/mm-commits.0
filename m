Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAFAC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 22:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiLSWnN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Dec 2022 17:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLSWnN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2022 17:43:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13A014D24
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 14:43:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E79D61185
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 22:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CB2C433D2;
        Mon, 19 Dec 2022 22:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671489790;
        bh=4QtYovXFVnCMqTuKV5SMl4BEm47GvqUozoXvW5Trvoo=;
        h=Date:To:From:Subject:From;
        b=PM2eeljorUEk0/DchtPsIGuZIIAkc1oOopuN/Zzc3cGd7iaoaBfrSLitjuwlEI1Ya
         5mDpmjSkd/FouwvYnuoW/rghPj6Omii5Rco7Dxtr3EJk+95Ywau4bhAxthfj3Atj3K
         ++dtqQpCOzCNvjDnNfn7giYGPcC1cDz++Qd+QbjQ=
Date:   Mon, 19 Dec 2022 14:43:10 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, yang.shi@linux.alibaba.com,
        weixugc@google.com, tj@kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net,
        bagasdotme@gmail.com, almasrymina@google.com, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-add-nodes=-arg-to-memoryreclaim.patch added to mm-unstable branch
Message-Id: <20221219224310.D3CB2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Fri, 16 Dec 2022 10:46:33 +0100
has been added to the -mm mm-unstable branch.  Its filename is
     revert-mm-add-nodes=-arg-to-memoryreclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-add-nodes=-arg-to-memoryreclaim.patch

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
From: Michal Hocko <mhocko@suse.com>
Date: Fri, 16 Dec 2022 10:46:33 +0100
Subject: Revert "mm: add nodes= arg to memory.reclaim"

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
 
@@ -6457,8 +6452,7 @@ static ssize_t memory_high_write(struct
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -6507,8 +6501,7 @@ static ssize_t memory_max_write(struct k
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP))
 				nr_reclaims--;
 			continue;
 		}
@@ -6631,54 +6624,21 @@ static ssize_t memory_oom_group_write(st
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
 
@@ -6695,8 +6655,7 @@ static ssize_t memory_reclaim(struct ker
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						nr_to_reclaim - nr_reclaimed,
-						GFP_KERNEL, reclaim_options,
-						&nodemask);
+						GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
--- a/mm/vmscan.c~revert-mm-add-nodes=-arg-to-memoryreclaim
+++ a/mm/vmscan.c
@@ -6757,8 +6757,7 @@ unsigned long mem_cgroup_shrink_node(str
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-					   unsigned int reclaim_options,
-					   nodemask_t *nodemask)
+					   unsigned int reclaim_options)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6773,7 +6772,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
-		.nodemask = nodemask,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-mempolicy-do-not-duplicate-policy-if-it-is-not-applicable-for-set_mempolicy_home_node.patch
revert-mm-add-nodes=-arg-to-memoryreclaim.patch

