Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C435CC4338F
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6363610FA
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbhHTCFF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 22:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhHTCFE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 22:05:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 902D7610FF;
        Fri, 20 Aug 2021 02:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629425067;
        bh=HhWI4yAbztYciuyaaAgUUnX6qCJfSTjgeSDuHh1CDWo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JYrs3N5yUY8BMuJTTpHmErNjuFvBW3Awdg87kfPzS1wNVITqtNQtk1CUtQN9GOUfJ
         JxhsjfTLvUTi2tePhV4y74odam5hw5lo7lxS47yJWy7TmNPUMn7b0Kku2wdvo5jgdj
         J2f0vKSGc/QdVChEE9qyFFHfmibEYWurQfLl518A=
Date:   Thu, 19 Aug 2021 19:04:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 08/10] mm: vmscan: fix missing psi annotation for
 node_reclaim()
Message-ID: <20210820020427.f6efFx9EV%akpm@linux-foundation.org>
In-Reply-To: <20210819190327.14fc4e97102e1af7929e30af@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: fix missing psi annotation for node_reclaim()

In a debugging session the other day, Rik noticed that node_reclaim() was
missing memstall annotations.  This means we'll miss pressure and lost
productivity resulting from reclaim on an overloaded local NUMA node when
vm.zone_reclaim_mode is enabled.

There haven't been any reports, but that's likely because
vm.zone_reclaim_mode hasn't been a commonly used feature recently, and the
intersection between such setups and psi users is probably nil.  Although,
secondary memory such as CXL-connected DIMMS, persistent memory etc.  and
the page demotion patches that handle them
(https://lore.kernel.org/lkml/20210401183216.443C4443@viggo.jf.intel.com/)
could soon make this a more common codepath again.

Link: https://lkml.kernel.org/r/20210818152457.35846-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-fix-missing-psi-annotation-for-node_reclaim
+++ a/mm/vmscan.c
@@ -4424,11 +4424,13 @@ static int __node_reclaim(struct pglist_
 		.may_swap = 1,
 		.reclaim_idx = gfp_zone(gfp_mask),
 	};
+	unsigned long pflags;
 
 	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, order,
 					   sc.gfp_mask);
 
 	cond_resched();
+	psi_memstall_enter(&pflags);
 	fs_reclaim_acquire(sc.gfp_mask);
 	/*
 	 * We need to be able to allocate from the reserves for RECLAIM_UNMAP
@@ -4453,6 +4455,7 @@ static int __node_reclaim(struct pglist_
 	current->flags &= ~PF_SWAPWRITE;
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc.gfp_mask);
+	psi_memstall_leave(&pflags);
 
 	trace_mm_vmscan_node_reclaim_end(sc.nr_reclaimed);
 
_
