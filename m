Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBB3C432BE
	for <mm-commits@archiver.kernel.org>; Mon, 23 Aug 2021 18:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E5A613A7
	for <mm-commits@archiver.kernel.org>; Mon, 23 Aug 2021 18:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhHWSZH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Aug 2021 14:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231955AbhHWSZG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Aug 2021 14:25:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 871E9613A6;
        Mon, 23 Aug 2021 18:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629743063;
        bh=qPQuKUoFohsO4INmMsT0H/QkTw2ONP3rojr+icyzgwQ=;
        h=Date:From:To:Subject:From;
        b=qc5rUgn7gcJtBjXh99W84rSfDHNiHERFzvmmmqetWtQTB4Ipqt7FvfroPo3Te+JzR
         jf1/q4e+lq8RxBi8ib+4D/Sffc/ogrNHuI98ZT6DlEardkDDQn3TGSN907LyZCnpOB
         la7nNsIPOSzLd+4zSeXQEUa7oiNreCarBsrHzTH4=
Date:   Mon, 23 Aug 2021 11:24:23 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org, riel@surriel.com,
        shakeelb@google.com
Subject:  [merged]
 mm-vmscan-fix-missing-psi-annotation-for-node_reclaim.patch removed from
 -mm tree
Message-ID: <20210823182423.LpcfYzlpn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix missing psi annotation for node_reclaim()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-missing-psi-annotation-for-node_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch
fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch
vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

