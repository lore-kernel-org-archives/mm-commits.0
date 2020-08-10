Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF48C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B67D32065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027182;
	bh=E+3CVNhazYV2qZ0XUFzwmCpNNfrrs40IoUuHudsNiPw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CzYLn5yB4pi+YFKbcqNissR4K2tnCWTFnZVuXsJcO73mCPVQrMFEhISW9Ntwej9R2
	 QuLsfyV2PnwDrdA6V61PAdL58q8qStGAUdAvRWmnxAI7MU7roOOqu40tuyhzToC6SU
	 D/ywbcpUknfqH3wM69+xjjZMgjHEjztxVvJYv5vo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgHJCjm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgHJCjm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B2AC206C3;
        Mon, 10 Aug 2020 02:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027181;
        bh=E+3CVNhazYV2qZ0XUFzwmCpNNfrrs40IoUuHudsNiPw=;
        h=Date:From:To:Subject:From;
        b=meUnEIAHAFe7bAxjFwoVRtMeL3pWO1g9/m0S3QeWIeYXOvWmS3cgCpU3nsIrElRuo
         9GtTRNA4c0pI5zZC+p4C05oFGPZUniKYlS63xqA2ciDcMf4TAj5Ti3FSANc7N9w5Ox
         iu59qiNlyFyVB7zsixI/LggOU0muo7enpuYfuutw=
Date:   Sun, 09 Aug 2020 19:39:41 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, hughd@google.com, hughd@googlecom,
        liwang@redhat.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged] mm-page_alloc-use-unlikely-in-task_capc.patch
 removed from -mm tree
Message-ID: <20200810023941.IYW5WN6ne%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: use unlikely() in task_capc()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-unlikely-in-task_capc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: use unlikely() in task_capc()

Hugh noted that task_capc() could use unlikely(), as most of the time
there is no capture in progress and we are in page freeing hot path. 
Indeed adding unlikely() produces assembly that better matches the
assumption and moves all the tests away from the hot path.

I have also noticed that we don't need to test for cc->direct_compaction
as the only place we set current->task_capture is compact_zone_order()
which also always sets cc->direct_compaction true.

Link: http://lkml.kernel.org/r/4a24f7af-3aa5-6e80-4ae6-8f253b562039@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@googlecom>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Li Wang <liwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-unlikely-in-task_capc
+++ a/mm/page_alloc.c
@@ -813,11 +813,10 @@ static inline struct capture_control *ta
 {
 	struct capture_control *capc = current->capture_control;
 
-	return capc &&
+	return unlikely(capc) &&
 		!(current->flags & PF_KTHREAD) &&
 		!capc->page &&
-		capc->cc->zone == zone &&
-		capc->cc->direct_compaction ? capc : NULL;
+		capc->cc->zone == zone ? capc : NULL;
 }
 
 static inline bool
_

Patches currently in -mm which might be from vbabka@suse.cz are


