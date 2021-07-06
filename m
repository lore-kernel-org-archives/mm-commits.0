Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DA5C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1258161CA0
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhGFTXo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTXo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B72161C9C;
        Tue,  6 Jul 2021 19:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599264;
        bh=GdugBSRjIaSZSrusGEss22viNpHuZBi9tlkjMuFJAGo=;
        h=Date:From:To:Subject:From;
        b=dqNQjn1hGrKNMUsydD1RXcmJpNJuZDqTxqUl9fD/2y1HSMqZOyEy2XiXfmsbXyRtW
         f4JFG2AOxfDRfsZR/mFMB0N/u3KGhpQeuEZM84mpJX1pBieVrypqRDVlVyPxbD9oCI
         fuxh/LAlreOuxb56rvp51bKvzsNTcmeGGlx7TkWc=
Date:   Tue, 06 Jul 2021 12:21:04 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch removed
 from -mm tree
Message-ID: <20210706192104.jmqJ9Mxoa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix kerneldoc comment for __remove_memory
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/memory_hotplug: fix kerneldoc comment for __remove_memory

make W=1 generates the following warning for __remove_memory

  mm/memory_hotplug.c:2044: warning: expecting prototype for remove_memory(). Prototype was for __remove_memory() instead

Commit eca499ab3749 ("mm/hotplug: make remove_memory() interface usable")
introduced the kerneldoc comment and function but the kerneldoc name and
function name did not match.

Link: https://lkml.kernel.org/r/20210520084809.8576-9-mgorman@techsingularity.net
Fixes: eca499ab3749 ("mm/hotplug: make remove_memory() interface usable")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory
+++ a/mm/memory_hotplug.c
@@ -1908,7 +1908,7 @@ static int __ref try_remove_memory(int n
 }
 
 /**
- * remove_memory
+ * __remove_memory - Remove memory if every memory block is offline
  * @nid: the node ID
  * @start: physical address of the region to remove
  * @size: size of the region to remove
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


