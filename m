Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDF6C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 01:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49B1C6113C
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 01:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349081AbhIIBLa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 21:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349033AbhIIBL3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 21:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0AD261167;
        Thu,  9 Sep 2021 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631149821;
        bh=hQV3I7izmMCYun39hvLMYFdMjP18vrfosOb34WJ/O54=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LtsZXf55SheMRiWr7peh4Gk0+FrR/YsG5PCq9J1Qwv9Mxqn/2XCEMx2W7Mq1n/DAa
         GKyY5PpadS4RbFJ79MXmFinIxCldvAoF4sUEJRM5/UV/FOpnfnK8qa9gR8STORxhNN
         SFLCjamnMwhQFJIUafwVTbJoFhXbV1jBVJNhZ0y4=
Date:   Wed, 08 Sep 2021 18:10:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        yanghui.def@bytedance.com
Subject:  [patch 7/8] mm/mempolicy: fix a race between
 offset_il_node and mpol_rebind_task
Message-ID: <20210909011020.5uPjbdM2T%akpm@linux-foundation.org>
In-Reply-To: <20210908180859.d523d4bb4ad8eec11c61500d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: yanghui <yanghui.def@bytedance.com>
Subject: mm/mempolicy: fix a race between offset_il_node and mpol_rebind_task

Servers happened below panic:
Kernel version:5.4.56
BUG: unable to handle page fault for address: 0000000000002c48
RIP: 0010:__next_zones_zonelist+0x1d/0x40
[264003.977696] RAX: 0000000000002c40 RBX: 0000000000100dca RCX: 0000000000000014
[264003.977872] Call Trace:
[264003.977888]  __alloc_pages_nodemask+0x277/0x310
[264003.977908]  alloc_page_interleave+0x13/0x70
[264003.977926]  handle_mm_fault+0xf99/0x1390
[264003.977951]  __do_page_fault+0x288/0x500
[264003.977979]  ? schedule+0x39/0xa0
[264003.977994]  do_page_fault+0x30/0x110
[264003.978010]  page_fault+0x3e/0x50

The reason for the panic is that MAX_NUMNODES is passed in the third
parameter in __alloc_pages_nodemask(preferred_nid).  So access to
zonelist->zoneref->zone_idx in __next_zones_zonelist will cause a panic.

In offset_il_node(), first_node() returns nid from pol->v.nodes, after
this other threads may chang pol->v.nodes before next_node().  This race
condition will let next_node return MAX_NUMNODES.  So put pol->nodes in a
local variable.

The race condition is between offset_il_node and cpuset_change_task_nodemask:
CPU0:                                     CPU1:
alloc_pages_vma()
  interleave_nid(pol,)
    offset_il_node(pol,)
      first_node(pol->v.nodes)            cpuset_change_task_nodemask
                      //nodes==0xc          mpol_rebind_task
                                              mpol_rebind_policy
                                                mpol_rebind_nodemask(pol,nodes)
                      //nodes==0x3
      next_node(nid, pol->v.nodes)//return MAX_NUMNODES

Link: https://lkml.kernel.org/r/20210906034658.48721-1-yanghui.def@bytedance.com
Signed-off-by: yanghui <yanghui.def@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-a-race-between-offset_il_node-and-mpol_rebind_task
+++ a/mm/mempolicy.c
@@ -1876,17 +1876,26 @@ unsigned int mempolicy_slab_node(void)
  */
 static unsigned offset_il_node(struct mempolicy *pol, unsigned long n)
 {
-	unsigned nnodes = nodes_weight(pol->nodes);
-	unsigned target;
+	nodemask_t nodemask = pol->nodes;
+	unsigned int target, nnodes;
 	int i;
 	int nid;
+	/*
+	 * The barrier will stabilize the nodemask in a register or on
+	 * the stack so that it will stop changing under the code.
+	 *
+	 * Between first_node() and next_node(), pol->nodes could be changed
+	 * by other threads. So we put pol->nodes in a local stack.
+	 */
+	barrier();
 
+	nnodes = nodes_weight(nodemask);
 	if (!nnodes)
 		return numa_node_id();
 	target = (unsigned int)n % nnodes;
-	nid = first_node(pol->nodes);
+	nid = first_node(nodemask);
 	for (i = 0; i < target; i++)
-		nid = next_node(nid, pol->nodes);
+		nid = next_node(nid, nodemask);
 	return nid;
 }
 
_
