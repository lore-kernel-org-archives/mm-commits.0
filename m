Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48BEC43219
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiCYWnQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiCYWnL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBE3208C2C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D57FEB82A31
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7814DC004DD;
        Fri, 25 Mar 2022 22:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248093;
        bh=CAWCjkh6BSSkVnO53MYr5fgNcl1s/jdz4lOC2xVOAiw=;
        h=Date:To:From:Subject:From;
        b=KP86rhi/rKJ52Ybx1TV4kMOQ+DCmhSCNrKwkmM8kVxUcLK0T0OxDvxYnuHhYkvGfq
         l8/YbzsdcnzWUEImnqobcW9n8UHDX60+tW6//7xgiCuPIXosLOXBGNi2O66q+PmmxG
         gdZYF+KF03AkxoP9cVn+h+7n5HBdouYLiU/p1FsY=
Date:   Fri, 25 Mar 2022 15:41:32 -0700
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        senozhatsky@chromium.org, rppt@linux.ibm.com, rostedt@goodmis.org,
        roman.gushchin@linux.dev, rientjes@google.com, pmladek@suse.com,
        mhocko@kernel.org, linux@rasmusvillemoes.dk, ira.weiny@intel.com,
        hannes@cmpxchg.org, aquini@redhat.com,
        andriy.shevchenko@linux.intel.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch removed from -mm tree
Message-Id: <20220325224133.7814DC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: use scnprintf() to avoid excessive buffer overrun check
has been removed from the -mm tree.  Its filename was
     mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/page_owner: use scnprintf() to avoid excessive buffer overrun check

The snprintf() function can return a length greater than the given input
size.  That will require a check for buffer overrun after each invocation
of snprintf().  scnprintf(), on the other hand, will never return a
greater length.  By using scnprintf() in selected places, we can avoid
some buffer overrun checks except after stack_depot_snprint() and after
the last snprintf().

Link: https://lkml.kernel.org/r/20220202203036.744010-3-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check
+++ a/mm/page_owner.c
@@ -338,19 +338,16 @@ print_page_owner(char __user *buf, size_
 	if (!kbuf)
 		return -ENOMEM;
 
-	ret = snprintf(kbuf, count,
+	ret = scnprintf(kbuf, count,
 			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns, free_ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
 			page_owner->ts_nsec, page_owner->free_ts_nsec);
 
-	if (ret >= count)
-		goto err;
-
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
 	page_mt  = gfp_migratetype(page_owner->gfp_mask);
-	ret += snprintf(kbuf + ret, count - ret,
+	ret += scnprintf(kbuf + ret, count - ret,
 			"PFN %lu type %s Block %lu type %s Flags %pGp\n",
 			pfn,
 			migratetype_names[page_mt],
@@ -358,19 +355,14 @@ print_page_owner(char __user *buf, size_
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	if (ret >= count)
-		goto err;
-
 	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
 	if (ret >= count)
 		goto err;
 
 	if (page_owner->last_migrate_reason != -1) {
-		ret += snprintf(kbuf + ret, count - ret,
+		ret += scnprintf(kbuf + ret, count - ret,
 			"Page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
-		if (ret >= count)
-			goto err;
 	}
 
 	ret += snprintf(kbuf + ret, count - ret, "\n");
_

Patches currently in -mm which might be from longman@redhat.com are

ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

