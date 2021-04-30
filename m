Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4014BC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21D9961476
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhD3F5y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhD3F5x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8318661463;
        Fri, 30 Apr 2021 05:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762224;
        bh=ok8OtXsNP0K6GTEJDOS7VAVlnbOgfYJupbLxGeOgdBM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TM964wdbC1NtjdAET5KVrgT9MkbblruC4SYxzfTUnuXrZoIJIELl0kqSMFDuYjPk7
         P4Dvb3bjca77ED54jUkl+qdv4MiP0SG9oGh9Yk8QWLDv6uK1y5rJkdrn8Ky/a/xlSP
         rXtJu9pLeP4Zo33kVgL9FKvzFU/lSmrGMTKbYhuU=
Date:   Thu, 29 Apr 2021 22:57:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 076/178] mm: page_counter: mitigate consequences
 of a page_counter underflow
Message-ID: <20210430055704.VJCczN8O-%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_counter: mitigate consequences of a page_counter underflow

When the unsigned page_counter underflows, even just by a few pages, a
cgroup will not be able to run anything afterwards and trigger the OOM
killer in a loop.

Underflows shouldn't happen, but when they do in practice, we may just be
off by a small amount that doesn't interfere with the normal operation -
consequences don't need to be that dire.

Reset the page_counter to 0 upon underflow.  We'll issue a warning that
the accounting will be off and then try to keep limping along.

[ We used to do this with the original res_counter, where it was a
  more straight-forward correction inside the spinlock section. I
  didn't carry it forward into the lockless page counters for
  simplicity, but it turns out this is quite useful in practice. ]

Link: https://lkml.kernel.org/r/20210408143155.2679744-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-mitigate-consequences-of-a-page_counter-underflow
+++ a/mm/page_counter.c
@@ -52,9 +52,13 @@ void page_counter_cancel(struct page_cou
 	long new;
 
 	new = atomic_long_sub_return(nr_pages, &counter->usage);
-	propagate_protected_usage(counter, new);
 	/* More uncharges than charges? */
-	WARN_ON_ONCE(new < 0);
+	if (WARN_ONCE(new < 0, "page_counter underflow: %ld nr_pages=%lu\n",
+		      new, nr_pages)) {
+		new = 0;
+		atomic_long_set(&counter->usage, new);
+	}
+	propagate_protected_usage(counter, new);
 }
 
 /**
_
