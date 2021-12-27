Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C929BC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbhL0AdV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbhL0AdV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:33:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF110C06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 16:33:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F05E60F19
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBFCC36AE8;
        Mon, 27 Dec 2021 00:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640565199;
        bh=QfFT7cZ/j2DJqdM7He3D4rOEnaCmElKMBiQ8mMMhv1M=;
        h=Date:From:To:Subject:From;
        b=LpQpQ4QoBNEbA9HIeo6WBxzBJ+I+iJdIZrhJgLMUksJLKNjX5mlhf0SxORJEBh3IG
         HQ7QWQYCECc9SihyLHzym0uxKPlQW1ivKp50Uvqb20SMdI93mGGm7UlUhp7JWZ5ta6
         DZtj6cjgTW0pG6/U1VR6mKHKSmXWWEgan8FVPTPc=
Date:   Sun, 26 Dec 2021 16:33:19 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, guoqing.jiang@linux.dev
Subject:  +
 mm-damon-move-the-implementation-of-damon_insert_region-to-damonh.patch added
 to -mm tree
Message-ID: <20211227003319.L92_N%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: move the implementation of damon_insert_region to damon.h
has been added to the -mm tree.  Its filename is
     mm-damon-move-the-implementation-of-damon_insert_region-to-damonh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-move-the-implementation-of-damon_insert_region-to-damonh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-move-the-implementation-of-damon_insert_region-to-damonh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-move-the-implementation-of-damon_insert_region-to-damonh.patch

