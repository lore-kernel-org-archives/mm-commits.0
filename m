Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67614C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345897AbiCYBKp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348360AbiCYBKl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:10:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3BE457BC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FFF9B81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC650C340EC;
        Fri, 25 Mar 2022 01:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170545;
        bh=6LWfCzLrPgNVafpJLonBr1p+EEPnw+GvRm+9q6c9V/c=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=R/BOpdSd5tlqvXyuyDEibdgyYCHX4F6GVffNvsgj0PsTnSo24PkfiB72dyOqqHhjK
         ywUu8kpQnJvXcFlDQRBI9sXg9jkavds9c7Djw+vS5eJ1RBZP6bOd7RAaWxFMpwb+NC
         Ze3jVJULRCFFCpv2y3SKrWaUTpqoHpYqKFoUG9Ik=
Date:   Thu, 24 Mar 2022 18:09:05 -0700
To:     vdavydov.dev@gmail.com, senozhatsky@chromium.org,
        rppt@linux.ibm.com, rostedt@goodmis.org, roman.gushchin@linux.dev,
        rientjes@google.com, pmladek@suse.com, mhocko@kernel.org,
        linux@rasmusvillemoes.dk, ira.weiny@intel.com, hannes@cmpxchg.org,
        aquini@redhat.com, andriy.shevchenko@linux.intel.com,
        longman@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 010/114] mm/page_owner: use scnprintf() to avoid excessive buffer overrun check
Message-Id: <20220325010905.BC650C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
