Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4A6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377901AbiATV3G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59180 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347624AbiATV3F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11701B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5A4C340E0;
        Thu, 20 Jan 2022 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714142;
        bh=53BPxm6/w5STavFoku0/4rWaqirYpUdgGwmajXj3afw=;
        h=Date:From:To:Subject:From;
        b=ow2/dl85uECHtyGLZaMenm5tQU1WxgOlmIBJe1/zAZCL3R993tZiXGl/elwFPbLoG
         XosogBcRRmM9Hhwg81K4CDU2bqJO3tiUvcjdUMuA4E2aJmeKULLoXUFbKfNs1ifHQa
         uZjmYe8abKMF8uZieGlya/HnP/JFnj4oCwdTZuaY=
Date:   Thu, 20 Jan 2022 13:29:02 -0800
From:   akpm@linux-foundation.org
To:     guoqing.jiang@linux.dev, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-move-the-implementation-of-damon_insert_region-to-damonh.patch
 removed from -mm tree
Message-ID: <20220120212902.Lui83g-Wy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: move the implementation of damon_insert_region to damon.h
has been removed from the -mm tree.  Its filename was
     mm-damon-move-the-implementation-of-damon_insert_region-to-damonh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: mm/damon: move the implementation of damon_insert_region to damon.h

Usually, inline function is declared static since it should sit between
storage and type.  And implement it in a header file if used by multiple
files.

And this change also fixes compile issue when backport damon to 5.10.

mm/damon/vaddr.c: In function `damon_va_evenly_split_region':
./include/linux/damon.h:425:13: error: inlining failed in call to `always_inline' `damon_insert_region': function body not available
425 | inline void damon_insert_region(struct damon_region *r,
| ^~~~~~~~~~~~~~~~~~~
mm/damon/vaddr.c:86:3: note: called from here
86 | damon_insert_region(n, r, next, t);
| ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20211223085703.6142-1-guoqing.jiang@linux.dev
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   13 +++++++++++--
 mm/damon/core.c       |   11 -----------
 2 files changed, 11 insertions(+), 13 deletions(-)

--- a/include/linux/damon.h~mm-damon-move-the-implementation-of-damon_insert_region-to-damonh
+++ a/include/linux/damon.h
@@ -451,9 +451,18 @@ static inline struct damon_region *damon
 #ifdef CONFIG_DAMON
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
-inline void damon_insert_region(struct damon_region *r,
+
+/*
+ * Add a region between two other regions
+ */
+static inline void damon_insert_region(struct damon_region *r,
 		struct damon_region *prev, struct damon_region *next,
-		struct damon_target *t);
+		struct damon_target *t)
+{
+	__list_add(&r->list, &prev->list, &next->list);
+	t->nr_regions++;
+}
+
 void damon_add_region(struct damon_region *r, struct damon_target *t);
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 
--- a/mm/damon/core.c~mm-damon-move-the-implementation-of-damon_insert_region-to-damonh
+++ a/mm/damon/core.c
@@ -49,17 +49,6 @@ struct damon_region *damon_new_region(un
 	return region;
 }
 
-/*
- * Add a region between two other regions
- */
-inline void damon_insert_region(struct damon_region *r,
-		struct damon_region *prev, struct damon_region *next,
-		struct damon_target *t)
-{
-	__list_add(&r->list, &prev->list, &next->list);
-	t->nr_regions++;
-}
-
 void damon_add_region(struct damon_region *r, struct damon_target *t)
 {
 	list_add_tail(&r->list, &t->regions_list);
_

Patches currently in -mm which might be from guoqing.jiang@linux.dev are


