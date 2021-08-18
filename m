Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6FEC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 18:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE06661100
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 18:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhHRTAU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Aug 2021 15:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhHRTAT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Aug 2021 15:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920A460EFE;
        Wed, 18 Aug 2021 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629313184;
        bh=RtEHpuedfSkcRhQXJp29dtXR/0Jd6TF/b9gZS3CBk4M=;
        h=Date:From:To:Subject:From;
        b=0ct0DibijLmeyBK7kAXPlP+PIzMEPko3AMfIdW4oTYvphj9LoGqQWuP2lZGpo85Zv
         sqFcIqsWyjDB7naU7tgPw3jTanhibpfnNUaOY3nOwF7exbYFknfhL5zTGKn9cqZAUu
         xtjvGoVGs7nRKPAqfW4NFtYEerqar6mzizsRQiQE=
Date:   Wed, 18 Aug 2021 11:59:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org
Subject:  +
 mm-vmscan-fix-missing-psi-annotation-for-node_reclaim.patch added to -mm tree
Message-ID: <20210818185944.nTJpA%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix missing psi annotation for node_reclaim()
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-missing-psi-annotation-for-node_reclaim.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-missing-psi-annotation-for-node_reclaim.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-missing-psi-annotation-for-node_reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-fix-occasional-ooms-due-to-proportional-memorylow-reclaim.patch
mm-vmscan-fix-missing-psi-annotation-for-node_reclaim.patch
mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch
fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch
vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

