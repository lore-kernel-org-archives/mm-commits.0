Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95D9C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiANWKD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWKD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F82C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EA21B82630
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04ADC36AE5;
        Fri, 14 Jan 2022 22:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198200;
        bh=ROyu1EzDKGTKYt+cupcXpS7/dD/1Se9+KtdbmMl1boE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fzKaxu6HTVVGGQc4KY0adod/WLnwSu8x1xaV34LGqaYKTFtTwGPqWBx58CNCC3a3l
         dNxs4fRx8EZnGhOxqcIX9h8sIuxYWb4TnhTPCexdsSjlNIJ03wfOmweb135owKy69f
         UKqEwsfh3kraJxvf0obl/XPod4hyE3a4hao3bxmw=
Date:   Fri, 14 Jan 2022 14:09:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 129/146] mm/damon: convert macro functions to
 static inline functions
Message-ID: <20220114220959.Y9bKQcLDC%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: convert macro functions to static inline functions

Patch series "mm/damon: Misc cleanups".

This patchset contains miscellaneous cleanups for DAMON's macro
functions and documentation.


This patch (of 6):

This commit converts macro functions in DAMON to static inline functions,
for better type checking, code documentation, etc[1].

[1] https://lore.kernel.org/linux-mm/20211202151213.6ec830863342220da4141bc5@linux-foundation.org/

Link: https://lkml.kernel.org/r/20211209131806.19317-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211209131806.19317-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   18 ++++++++++++------
 mm/damon/core.c       |    5 ++++-
 mm/damon/vaddr.c      |    6 ++++--
 3 files changed, 20 insertions(+), 9 deletions(-)

--- a/include/linux/damon.h~mm-damon-convert-macro-functions-to-static-inline-functions
+++ a/include/linux/damon.h
@@ -399,14 +399,20 @@ struct damon_ctx {
 	struct list_head schemes;
 };
 
-#define damon_next_region(r) \
-	(container_of(r->list.next, struct damon_region, list))
+static inline struct damon_region *damon_next_region(struct damon_region *r)
+{
+	return container_of(r->list.next, struct damon_region, list);
+}
 
-#define damon_prev_region(r) \
-	(container_of(r->list.prev, struct damon_region, list))
+static inline struct damon_region *damon_prev_region(struct damon_region *r)
+{
+	return container_of(r->list.prev, struct damon_region, list);
+}
 
-#define damon_last_region(t) \
-	(list_last_entry(&t->regions_list, struct damon_region, list))
+static inline struct damon_region *damon_last_region(struct damon_target *t)
+{
+	return list_last_entry(&t->regions_list, struct damon_region, list);
+}
 
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
--- a/mm/damon/core.c~mm-damon-convert-macro-functions-to-static-inline-functions
+++ a/mm/damon/core.c
@@ -729,7 +729,10 @@ static void kdamond_apply_schemes(struct
 	}
 }
 
-#define sz_damon_region(r) (r->ar.end - r->ar.start)
+static inline unsigned long sz_damon_region(struct damon_region *r)
+{
+	return r->ar.end - r->ar.start;
+}
 
 /*
  * Merge two adjacent regions into one region
--- a/mm/damon/vaddr.c~mm-damon-convert-macro-functions-to-static-inline-functions
+++ a/mm/damon/vaddr.c
@@ -26,8 +26,10 @@
  * 't->id' should be the pointer to the relevant 'struct pid' having reference
  * count.  Caller must put the returned task, unless it is NULL.
  */
-#define damon_get_task_struct(t) \
-	(get_pid_task((struct pid *)t->id, PIDTYPE_PID))
+static inline struct task_struct *damon_get_task_struct(struct damon_target *t)
+{
+	return get_pid_task((struct pid *)t->id, PIDTYPE_PID);
+}
 
 /*
  * Get the mm_struct of the given target
_
