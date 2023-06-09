Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC091C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbjFIXcq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjFIXbi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991F74692
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7873063EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8AAC433D2;
        Fri,  9 Jun 2023 23:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353364;
        bh=FgxH1i/JooLOD8K+q+K2i5tNmJrEejOJlpLt7w9bJGo=;
        h=Date:To:From:Subject:From;
        b=cpwLhg3TPU+IHVU2Kk4cE7QtY1tg+eVVx5Q1lV7XF0bFgyTwnSG7OtdnWjriYAf+5
         BhKOw4x6HFCA+j+AjHNUfembBfhBVyfJO1chSGAFGLUK/kdTa8m/RtfHZTPXyYwD2L
         AvlW9/SnZ/BzGFYBhsLHcgkSSgMWvLqlzVn35Ctk=
Date:   Fri, 09 Jun 2023 16:29:24 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch removed from -mm tree
Message-Id: <20230609232924.CE8AAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: skip fast freepages isolation if enough freepages are isolated
has been removed from the -mm tree.  Its filename was
     mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: skip fast freepages isolation if enough freepages are isolated
Date: Thu, 25 May 2023 20:54:01 +0800

I've observed that fast isolation often isolates more pages than
cc->migratepages, and the excess freepages will be released back to the
buddy system.  So skip fast freepages isolation if enough freepages are
isolated to save some CPU cycles.

Link: https://lkml.kernel.org/r/f39c2c07f2dba2732fd9c0843572e5bef96f7f67.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/compaction.c~mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated
+++ a/mm/compaction.c
@@ -1528,6 +1528,10 @@ static void fast_isolate_freepages(struc
 
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 
+		/* Skip fast search if enough freepages isolated */
+		if (cc->nr_freepages >= cc->nr_migratepages)
+			break;
+
 		/*
 		 * Smaller scan on next order so the total scan is related
 		 * to freelist_scan_limit.
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


