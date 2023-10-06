Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14B9E94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjJFVrr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbjJFVre (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D15BE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C622CC433C8;
        Fri,  6 Oct 2023 21:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628852;
        bh=i2KdxfAktNnaS2qrnXUng+oDT/c2CH1iaYAig/VIxco=;
        h=Date:To:From:Subject:From;
        b=12xiB0NvyjZfFz7LKlAPzZbxTnE68tfpxAM4qf/SPLzZHJSQsL4V16vxkS3xk7Mr7
         GTMpowm3uJKMfW3+eyArNLQZTPMpqED3xrKWjjlSsogeLTtWyNgUGqb8az1pd7uSxB
         7mgGhY9mEjagLXboqOZ+m+LDGJtnoAb9UZN3g78I=
Date:   Fri, 06 Oct 2023 14:47:29 -0700
To:     mm-commits@vger.kernel.org, wangyun@bilibili.com,
        bsingharora@gmail.com, wenyuli@ex.bilibili.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] delayacct-add-memory-reclaim-delay-in-get_page_from_freelist.patch removed from -mm tree
Message-Id: <20231006214731.C622CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: delayacct: add memory reclaim delay in get_page_from_freelist
has been removed from the -mm tree.  Its filename was
     delayacct-add-memory-reclaim-delay-in-get_page_from_freelist.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: liwenyu <wenyuli@ex.bilibili.com>
Subject: delayacct: add memory reclaim delay in get_page_from_freelist
Date: Wed, 20 Sep 2023 17:38:49 +0800

The current memory reclaim delay statistics only count the direct memory
reclaim of the task in do_try_to_free_pages().  In systems with NUMA open,
some tasks occasionally experience slower response times, but the total
count of reclaim does not increase, using ftrace can show that
node_reclaim has occurred.

The memory reclaim occurring in get_page_from_freelist() is also due to
heavy memory load.  To get the impact of tasks in memory reclaim, this
patch adds the statistics of the memory reclaim delay statistics for
__node_reclaim().

Link: https://lkml.kernel.org/r/181C946095F0252B+7cc60eca-1abf-4502-aad3-ffd8ef89d910@ex.bilibili.com
Signed-off-by: Wen Yu Li <wenyuli@ex.bilibili.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <wangyun@bilibili.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmscan.c~delayacct-add-memory-reclaim-delay-in-get_page_from_freelist
+++ a/mm/vmscan.c
@@ -7326,6 +7326,7 @@ static int __node_reclaim(struct pglist_
 
 	cond_resched();
 	psi_memstall_enter(&pflags);
+	delayacct_freepages_start();
 	fs_reclaim_acquire(sc.gfp_mask);
 	/*
 	 * We need to be able to allocate from the reserves for RECLAIM_UNMAP
@@ -7348,6 +7349,7 @@ static int __node_reclaim(struct pglist_
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc.gfp_mask);
 	psi_memstall_leave(&pflags);
+	delayacct_freepages_end();
 
 	trace_mm_vmscan_node_reclaim_end(sc.nr_reclaimed);
 
_

Patches currently in -mm which might be from wenyuli@ex.bilibili.com are


