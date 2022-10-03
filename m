Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8915DC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJCVNE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiJCVLi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1892451A29
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAEC1611EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F652C433C1;
        Mon,  3 Oct 2022 21:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831234;
        bh=jn4SqDvbCXN/U15ZWju1B6Hu3AU8RO1lUs/MTDK7ycE=;
        h=Date:To:From:Subject:From;
        b=FjR1chaoIGKIbYQrTjuswpNNIWZErvXb4fOWv8X1eci9A8ysdgkyOsrUo+fKlk5pL
         BZpT8rHKwdFxIpyWX02Gpkj0esbLTiCJMwO7Hf+9CGzjUPpx7/Qcvn3oV/haIudqlP
         4MOKaXFjIlJhBHnTX89/V+u2eJPbhfZ3q7gehh5Q=
Date:   Mon, 03 Oct 2022 14:07:13 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch removed from -mm tree
Message-Id: <20221003210714.0F652C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: deduplicate damon_pa_{mark_accessed,deactivate_pages}()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: deduplicate damon_pa_{mark_accessed,deactivate_pages}()
Date: Tue, 13 Sep 2022 17:44:29 +0000

The bodies of damon_pa_{mark_accessed,deactivate_pages}() contains
duplicates.  This commit factors out the common part to a separate
function and removes the duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages
+++ a/mm/damon/paddr.c
@@ -232,7 +232,8 @@ static unsigned long damon_pa_pageout(st
 	return applied * PAGE_SIZE;
 }
 
-static unsigned long damon_pa_mark_accessed(struct damon_region *r)
+static inline unsigned long damon_pa_mark_accessed_or_deactivate(
+		struct damon_region *r, bool mark_accessed)
 {
 	unsigned long addr, applied = 0;
 
@@ -241,27 +242,24 @@ static unsigned long damon_pa_mark_acces
 
 		if (!page)
 			continue;
-		mark_page_accessed(page);
+		if (mark_accessed)
+			mark_page_accessed(page);
+		else
+			deactivate_page(page);
 		put_page(page);
 		applied++;
 	}
 	return applied * PAGE_SIZE;
 }
 
-static unsigned long damon_pa_deactivate_pages(struct damon_region *r)
+static unsigned long damon_pa_mark_accessed(struct damon_region *r)
 {
-	unsigned long addr, applied = 0;
-
-	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
-		struct page *page = damon_get_page(PHYS_PFN(addr));
+	return damon_pa_mark_accessed_or_deactivate(r, true);
+}
 
-		if (!page)
-			continue;
-		deactivate_page(page);
-		put_page(page);
-		applied++;
-	}
-	return applied * PAGE_SIZE;
+static unsigned long damon_pa_deactivate_pages(struct damon_region *r)
+{
+	return damon_pa_mark_accessed_or_deactivate(r, false);
 }
 
 static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

