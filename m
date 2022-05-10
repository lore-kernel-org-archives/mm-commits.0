Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09ECBC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbiEJEWz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236136AbiEJEUr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5703614B
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A1C36176B
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D154BC385A6;
        Tue, 10 May 2022 04:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156150;
        bh=kafN3DqW6peHP8NRczC0f/6TimiGxs5y0MopWrEabCM=;
        h=Date:To:From:Subject:From;
        b=C+jtDqfAH1Rz3OdzbZG0PzBUpO+rYPW32hIb1F6Vp9bNsU7PzHdfG/U4NZJ9S1PPv
         eX+ek96JIc+3cNqke2PgZBxpktHf5VrkSuBBSdecluAt82PfDBoc0379UiFq8R6dRU
         y9Kh5FzPu3+4kfJh4IqbyuhwZRFUnu+f9G+0rFzQ=
Date:   Mon, 09 May 2022 21:15:50 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-remove-damon_va_apply_three_regions.patch removed from -mm tree
Message-Id: <20220510041550.D154BC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: remove damon_va_apply_three_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-remove-damon_va_apply_three_regions.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: remove damon_va_apply_three_regions()

'damon_va_apply_three_regions()' is just a wrapper of its general version,
'damon_set_regions()'.  This commit replaces the wrapper calls to directly
call the general version.

Link: https://lkml.kernel.org/r/20220429160606.127307-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |    6 +++---
 mm/damon/vaddr.c      |   18 +-----------------
 2 files changed, 4 insertions(+), 20 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-remove-damon_va_apply_three_regions
+++ a/mm/damon/vaddr.c
@@ -282,22 +282,6 @@ static void damon_va_init(struct damon_c
 }
 
 /*
- * Functions for the dynamic monitoring target regions update
- */
-
-/*
- * Update damon regions for the three big regions of the given target
- *
- * t		the given target
- * bregions	the three big regions of the target
- */
-static void damon_va_apply_three_regions(struct damon_target *t,
-		struct damon_addr_range bregions[3])
-{
-	damon_set_regions(t, bregions, 3);
-}
-
-/*
  * Update regions for current memory mappings
  */
 static void damon_va_update(struct damon_ctx *ctx)
@@ -308,7 +292,7 @@ static void damon_va_update(struct damon
 	damon_for_each_target(t, ctx) {
 		if (damon_va_three_regions(t, three_regions))
 			continue;
-		damon_va_apply_three_regions(t, three_regions);
+		damon_set_regions(t, three_regions, 3);
 	}
 }
 
--- a/mm/damon/vaddr-test.h~mm-damon-vaddr-remove-damon_va_apply_three_regions
+++ a/mm/damon/vaddr-test.h
@@ -109,7 +109,7 @@ static struct damon_region *__nth_region
 }
 
 /*
- * Test 'damon_va_apply_three_regions()'
+ * Test 'damon_set_regions()'
  *
  * test			kunit object
  * regions		an array containing start/end addresses of current
@@ -124,7 +124,7 @@ static struct damon_region *__nth_region
  * the change, DAMON periodically reads the mappings, simplifies it to the
  * three regions, and updates the monitoring target regions to fit in the three
  * regions.  The update of current target regions is the role of
- * 'damon_va_apply_three_regions()'.
+ * 'damon_set_regions()'.
  *
  * This test passes the given target regions and the new three regions that
  * need to be applied to the function and check whether it updates the regions
@@ -145,7 +145,7 @@ static void damon_do_test_apply_three_re
 		damon_add_region(r, t);
 	}
 
-	damon_va_apply_three_regions(t, three_regions);
+	damon_set_regions(t, three_regions, 3);
 
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
_

Patches currently in -mm which might be from sj@kernel.org are


