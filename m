Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0180C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6006610D2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347822AbhIBVyr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347574AbhIBVyl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B12FA61106;
        Thu,  2 Sep 2021 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619623;
        bh=Xjg05lUJFJney2qTQhTkKV7hezBsNAoulLyBLwKadVA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oqFsVpdaoLFpVfKz4W2nLiFKMpW63IQfkdSV/xEKasj/xztfo6p2ofkGFV1VE7mh+
         BVjgZn40vebPhxZEfHv0okOyTuYyRRMkXQZUCfZpai7QWhZi0HRbciw/OCN1/uZmNT
         bONWBjpK0mnvc0cQH0NCmmsSjj9uCBOY4yz7AT7g=
Date:   Thu, 02 Sep 2021 14:53:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, imbrenda@linux.ibm.com, jack@suse.cz,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 071/212] mm: gup: fix potential pgmap refcnt leak
 in __gup_device_huge()
Message-ID: <20210902215342.RcyFEb0qQ%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: gup: fix potential pgmap refcnt leak in __gup_device_huge()

When failed to try_grab_page, put_dev_pagemap() is missed.  So pgmap
refcnt will leak in this case.  Also we remove the check for pgmap against
NULL as it's also checked inside the put_dev_pagemap().

[akpm@linux-foundation.org: simplify, cleanup]
[akpm@linux-foundation.org: fix return value]
Link: https://lkml.kernel.org/r/20210807093620.21347-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge
+++ a/mm/gup.c
@@ -2240,6 +2240,7 @@ static int __gup_device_huge(unsigned lo
 {
 	int nr_start = *nr;
 	struct dev_pagemap *pgmap = NULL;
+	int ret = 1;
 
 	do {
 		struct page *page = pfn_to_page(pfn);
@@ -2247,21 +2248,22 @@ static int __gup_device_huge(unsigned lo
 		pgmap = get_dev_pagemap(pfn, pgmap);
 		if (unlikely(!pgmap)) {
 			undo_dev_pagemap(nr, nr_start, flags, pages);
-			return 0;
+			ret = 0;
+			break;
 		}
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		if (unlikely(!try_grab_page(page, flags))) {
 			undo_dev_pagemap(nr, nr_start, flags, pages);
-			return 0;
+			ret = 0;
+			break;
 		}
 		(*nr)++;
 		pfn++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (pgmap)
-		put_dev_pagemap(pgmap);
-	return 1;
+	put_dev_pagemap(pgmap);
+	return ret;
 }
 
 static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
_
