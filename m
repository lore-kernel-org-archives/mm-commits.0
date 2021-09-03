Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B550C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52AD8610E8
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350079AbhICU5f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350144AbhICU5Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9829D60E9B;
        Fri,  3 Sep 2021 20:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702584;
        bh=oqrpYBLvQp6ilJ7VBOn1XjAYh/dT4odPceD8Bc/QbYo=;
        h=Date:From:To:Subject:From;
        b=LGjk0qRRB9icYIEGwj7yY4fAxwWafCqdyxQS6IVJgP/xmUlSxvt+rwuA7+3uXDRsZ
         v2tf3Uoh76BQI2ezL+oN6CkMXtC65sbSpkcMIy4Pm2d/lieaTkYG6eis7nQLJK8Cvt
         xjJFQzVETzOIIJu1+ppRXcmrTjD8ICrZjcHrEV0s=
Date:   Fri, 03 Sep 2021 13:56:24 -0700
From:   akpm@linux-foundation.org
To:     imbrenda@linux.ibm.com, jack@suse.cz, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch removed
 from -mm tree
Message-ID: <20210903205624.bKtOX9-au%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: fix potential pgmap refcnt leak in __gup_device_huge()
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

