Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E621EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jun 2023 23:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjFWXyb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 19:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjFWXya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 19:54:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3342940
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 16:54:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0567A61159
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 23:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E923C433C8;
        Fri, 23 Jun 2023 23:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564446;
        bh=ryNSoUVXdDY7uxP0k0DkdlRqiYvYc77uvLxA4pM9dF0=;
        h=Date:To:From:Subject:From;
        b=xFJj7O2Y5TlqgXhiQuZpXINXVszn+wZ2TTAtR6FiAOC+Y7+/78mqJnrE/mKWY24Pi
         opw18UCUMlie712GmLqDChfdQOQtPYD/uqxKvx9/lPAn8A7k6OvlsLgT3AdxrvoZ0S
         uuA1qoOe4tfTQnfRjUIYlMMY/5rA7YS8E4QZPqes=
Date:   Fri, 23 Jun 2023 16:54:05 -0700
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        dan.carpenter@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-revert-use-of-page_cache_next_miss-fix.patch removed from -mm tree
Message-Id: <20230623235406.5E923C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix hugetlbfs_pagecache_present()
has been removed from the -mm tree.  Its filename was
     hugetlb-revert-use-of-page_cache_next_miss-fix.patch

This patch was dropped because it was folded into hugetlb-revert-use-of-page_cache_next_miss.patch

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

hugetlb-revert-use-of-page_cache_next_miss.patch

