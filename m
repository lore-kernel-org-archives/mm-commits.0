Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F3FC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbiGDBK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiGDBJ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D066310
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96AC961303
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB684C341C6;
        Mon,  4 Jul 2022 01:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896997;
        bh=JmBis6MGSMq8GmYrJo0CMXI05X2C33/wkm/zdBUayro=;
        h=Date:To:From:Subject:From;
        b=ty2OYIsmmfMV8TNdKhdYA8iOuilUipqyOHRJ1IibHgF1TbEOMclopd78wJmqfS8SP
         kWOts44IU/mX1cbmeqWcI4Ro/m7zWD1vZmqQWfBjFfYKz+s/xkyGIjLPNIpsLqkU+/
         NX6Grhm/ENEVMfGXnVHjgbzamSieW8pYH6pjxoHs=
Date:   Sun, 03 Jul 2022 18:09:56 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch removed from -mm tree
Message-Id: <20220704010956.EB684C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: use a separate function for 'DAMOS_PAGEOUT' handling
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: use a separate function for 'DAMOS_PAGEOUT' handling
Date: Mon, 13 Jun 2022 19:22:55 +0000

This commit moves code for 'DAMOS_PAGEOUT' handling of the physical
address space monitoring operations set to a separate function so that its
caller, 'damon_pa_apply_scheme()', can be more easily extended for
additional DAMOS actions later.

Link: https://lkml.kernel.org/r/20220613192301.8817-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling
+++ a/mm/damon/paddr.c
@@ -204,16 +204,11 @@ static unsigned int damon_pa_check_acces
 	return max_nr_accesses;
 }
 
-static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
-		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+static unsigned long damon_pa_pageout(struct damon_region *r)
 {
 	unsigned long addr, applied;
 	LIST_HEAD(page_list);
 
-	if (scheme->action != DAMOS_PAGEOUT)
-		return 0;
-
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
 		struct page *page = damon_get_page(PHYS_PFN(addr));
 
@@ -238,6 +233,19 @@ static unsigned long damon_pa_apply_sche
 	return applied * PAGE_SIZE;
 }
 
+static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme)
+{
+	switch (scheme->action) {
+	case DAMOS_PAGEOUT:
+		return damon_pa_pageout(r);
+	default:
+		break;
+	}
+	return 0;
+}
+
 static int damon_pa_scheme_score(struct damon_ctx *context,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

