Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31640C0015E
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jun 2023 18:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjFWSbD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 14:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjFWSbC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 14:31:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EC5271E
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 11:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D8E261AD5
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 18:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C334CC433C8;
        Fri, 23 Jun 2023 18:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687545060;
        bh=cV68vhUdB437jDGMzRigHrCS0kZAiTexwtO9waOOlxQ=;
        h=Date:To:From:Subject:From;
        b=jjhXig1MTJZIoybMSFUH7RGeZ/oNY75jQM0i08d7Ledv8nRPK6cadLDOQkDid9aZv
         ssNXBvY1YLCY9gDMAk7WKJmXJyj4E8gqBFz68qNCSa+ZaeEABNf0X/xAMymCFAdL0c
         OptGTrymzGrGwYOnKHzbBbtFKWa0Fk3JqojYe3eA=
Date:   Fri, 23 Jun 2023 11:31:00 -0700
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        dan.carpenter@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-revert-use-of-page_cache_next_miss-fix.patch added to mm-unstable branch
Message-Id: <20230623183100.C334CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix hugetlbfs_pagecache_present()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-revert-use-of-page_cache_next_miss-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-revert-use-of-page_cache_next_miss-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: mm/hugetlb: fix hugetlbfs_pagecache_present()
Date: Fri, 23 Jun 2023 09:26:02 +0300

The filemap_get_folio() function doesn't returns NULL, it returns error
pointers.  So the "return folio != NULL;" statement means
hugetlbfs_pagecache_present() always returns true.

Link: https://lkml.kernel.org/r/efa86091-6a2c-4064-8f55-9b44e1313015@moroto.mountain
Fixes: 267d6792f43b ("hugetlb: revert use of page_cache_next_miss()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-revert-use-of-page_cache_next_miss-fix
+++ a/mm/hugetlb.c
@@ -5731,9 +5731,10 @@ static bool hugetlbfs_pagecache_present(
 	struct folio *folio;
 
 	folio = filemap_get_folio(mapping, idx);
-	if (!IS_ERR(folio))
-		folio_put(folio);
-	return folio != NULL;
+	if (IS_ERR(folio))
+		return false;
+	folio_put(folio);
+	return true;
 }
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

hugetlb-revert-use-of-page_cache_next_miss-fix.patch

