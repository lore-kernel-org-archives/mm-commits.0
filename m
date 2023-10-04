Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C8BE7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjJDURJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjJDURH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5956593
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95AEC433C7;
        Wed,  4 Oct 2023 20:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450624;
        bh=2SaceXMejGJ84xdAc+ZKzN3L49e2c4rWaWAcFk8pF8E=;
        h=Date:To:From:Subject:From;
        b=YIhPVutMLTvDJr3Qssa87BCzHc06apj/rsAQYZ2XIZ/UrjAdK1W1zq09PLKX7ngkv
         sXRWny/RMDIQ9YcSiRnauVErqmZ+H6HN2DVmymDvhtTdKz3Swczg+t8NkimuvvNM0x
         6xzh8k5Cv2QzW8BonE2HAcJFHQSRW7nkwaFFiTI0=
Date:   Wed, 04 Oct 2023 13:17:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix.patch removed from -mm tree
Message-Id: <20231004201703.B95AEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix.patch

This patch was dropped because it was folded into mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix
Date: Fri, 8 Sep 2023 16:23:36 -0600

add comment to mf_generic_kill_procss(), simplify
mf_generic_kill_procs:folio initialization.

Link: https://lkml.kernel.org/r/20230908222336.186313-1-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-convert-dax-lock-unlock-page-to-lock-unlock-folio-fix
+++ a/mm/memory-failure.c
@@ -1713,11 +1713,19 @@ static void unmap_and_kill(struct list_h
 	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
 }
 
+/*
+ * Only dev_pagemap pages get here, such as fsdax when the filesystem
+ * either do not claim or fails to claim a hwpoison event, or devdax.
+ * The fsdax pages are initialized per base page, and the devdax pages
+ * could be initialized either as base pages, or as compound pages with
+ * vmemmap optimization enabled. Devdax is simplistic in its dealing with
+ * hwpoison, such that, if a subpage of a compound page is poisoned,
+ * simply mark the compound head page is by far sufficient.
+ */
 static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 		struct dev_pagemap *pgmap)
 {
-	struct page *page = pfn_to_page(pfn);
-	struct folio *folio = page_folio(page);
+	struct folio *folio = pfn_folio(pfn);
 	LIST_HEAD(to_kill);
 	dax_entry_t cookie;
 	int rc = 0;
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch

