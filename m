Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9F6C001DF
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 16:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjJTQkt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 12:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjJTQkt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 12:40:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8746CA
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 09:40:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4020DC433C8;
        Fri, 20 Oct 2023 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697820047;
        bh=QT1OBc/U4APDj9SSwHOvtGXpqhuA/FZkirz/9eHqz7s=;
        h=Date:To:From:Subject:From;
        b=qjZwYQQIuguvUAl/AV5/6QeKGmuO41ynXTeF6LFvunUM8uPyggaQzJKXfdMYO6KIH
         qBTbbzZWLAhu9et3UQmQxN2K/NyAtL6XogrcGkCD90hW9geYSj+Vw5TlAPgldm1nKQ
         jLes5kerS3z9sWaxMgLWpKI9m3n/gGS1Ro6XFv6Q=
Date:   Fri, 20 Oct 2023 09:40:46 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, rppt@kernel.org,
        osalvador@suse.de, mingo@kernel.org, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org, david@redhat.com,
        aneesh.kumar@linux.ibm.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-skip-memoryless-nodes-entirely-v4.patch added to mm-unstable branch
Message-Id: <20231020164047.4020DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: skip memoryless nodes entirely
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-skip-memoryless-nodes-entirely-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-skip-memoryless-nodes-entirely-v4.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: page_alloc: skip memoryless nodes entirely
Date: Fri, 20 Oct 2023 19:04:45 +0800

update comment, per Ingo

Link: https://lkml.kernel.org/r/7300fc00a057eefeb9a68c8ad28171c3f0ce66ce.1697799303.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-memoryless-nodes-entirely-v4
+++ a/mm/page_alloc.c
@@ -5057,8 +5057,8 @@ int find_next_best_node(int node, nodema
 	int best_node = NUMA_NO_NODE;
 
 	/*
-	 * Use the local node if we haven't already. But for memoryless local
-	 * node, we should skip it and fallback to other nodes.
+	 * Use the local node if we haven't already, but for memoryless local
+	 * node, we should skip it and fall back to other nodes.
 	 */
 	if (!node_isset(node, *used_node_mask) && node_state(node, N_MEMORY)) {
 		node_set(node, *used_node_mask);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-page_alloc-skip-memoryless-nodes-entirely.patch
mm-page_alloc-skip-memoryless-nodes-entirely-v4.patch
mm-memory_hotplug-drop-memoryless-node-from-fallback-lists.patch

