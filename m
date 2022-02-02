Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268B9C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Feb 2022 22:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347938AbiBBWxC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Feb 2022 17:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbiBBWxC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Feb 2022 17:53:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFC4C061714
        for <mm-commits@vger.kernel.org>; Wed,  2 Feb 2022 14:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DDFFB8310A
        for <mm-commits@vger.kernel.org>; Wed,  2 Feb 2022 22:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FA8C004E1;
        Wed,  2 Feb 2022 22:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643842379;
        bh=B12bsiRH8882jUx8o7K1jCVwEHUjRyoLUjoYiS6rbBU=;
        h=Date:To:From:Subject:From;
        b=Zl5KC/w+vLahTOt6qpW1HI+y/DS3e/NcCFbhkkxk1qySy35beHdLuEzyex2JI3tMA
         16OYLzm+i7YtVCHxJefHd8qxKAKm2ahV5BoDmlKuUAothTllaxqPBia70J6w3FSnj/
         BxkNMMz6tkpTwwjlGfhQre6/evVzDVkcFFdc1e8I=
Received: by hp1 (sSMTP sendmail emulation); Wed, 02 Feb 2022 14:52:57 -0800
Date:   Wed, 02 Feb 2022 14:52:57 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        senozhatsky@chromium.org, rppt@kernel.org, rostedt@goodmis.org,
        rientjes@google.com, pmladek@suse.com, mhocko@kernel.org,
        linux@rasmusvillemoes.dk, ira.weiny@intel.com, hannes@cmpxchg.org,
        guro@fb.com, aquini@redhat.com, andriy.shevchenko@linux.intel.com,
        longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch added to -mm tree
Message-Id: <20220202225257.D8FA8C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: use scnprintf() to avoid excessive buffer overrun check
has been added to the -mm tree.  Its filename is
     mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Roman Gushchin <guro@fb.com>
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

lib-vsprintf-avoid-redundant-work-with-0-size.patch
mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch
mm-page_owner-print-memcg-information.patch
mm-page_owner-record-task-command-name.patch
mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

