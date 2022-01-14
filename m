Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F3AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiANWKn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:43 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38600 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiANWKm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D9597CE2384
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1294C36AE5;
        Fri, 14 Jan 2022 22:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198239;
        bh=v1bwwHVFMHKlbRbNAi/180jRFambaRbnWJ42e8609zc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Z7CbX80CYjdVYnzWi5Ai/mCrTEitVYqHK35US8nVKve/7hsD8e5s5CdP186xX57LX
         GfwTnPeI3KPt2UNZMSJCpxX2eMBL6zSGyjW0IH0bKI9rXZJMXmnWrKU+J39PtyGQld
         98VtigBzk0KEfskWcEQuBVvWNoHdaJaF/tOBXikQ=
Date:   Fri, 14 Jan 2022 14:10:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guoqing.jiang@linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 142/146] mm/damon: move the implementation of
 damon_insert_region to damon.h
Message-ID: <20220114221038.0qYlWfSgE%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
