Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E2BC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjDRXgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjDRXew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA9BAF2D
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F5CE62F29
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5202C433EF;
        Tue, 18 Apr 2023 23:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860869;
        bh=Strl6dLfXzpomjK3ONwbNA1WBtEaTbPZWcfiVDm4mP4=;
        h=Date:To:From:Subject:From;
        b=GO4ihzNN4MXO61cHbTsGXknk/ZtRkphF6lQAG7Um44JwRAbo5YkK6AdaCj5jUfHGq
         +sz24RwZt8H6bK2uMw6rCYt8bvgiYpFxk8D5Mm4stCCDCnVpFKHDZ4HykPHvAVVQ/G
         Y+Hqq+m+J6jWKUuMxSxCfHAnGBoIDl1+ixR8dFgM=
Date:   Tue, 18 Apr 2023 16:34:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch removed from -mm tree
Message-Id: <20230418233429.B5202C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: use kmap_local_page() in copy_huge_page_from_user()
has been removed from the -mm tree.  Its filename was
     userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: userfaultfd: use kmap_local_page() in copy_huge_page_from_user()
Date: Mon, 10 Apr 2023 21:39:28 +0800

kmap() and kmap_atomic() are being deprecated in favor of
kmap_local_page() which is appropriate for any thread local context.[1]

Let's replace the kmap() and kmap_atomic() with kmap_local_page() in
copy_huge_page_from_user().  When allow_pagefault is false, disable page
faults to prevent potential deadlock.[2]

[1] https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com/
[2] https://lkml.kernel.org/r/20221025220136.2366143-1-ira.weiny@intel.com

Link: https://lkml.kernel.org/r/20230410133932.32288-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/memory.c~userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user
+++ a/mm/memory.c
@@ -5880,16 +5880,14 @@ long copy_huge_page_from_user(struct pag
 
 	for (i = 0; i < pages_per_huge_page; i++) {
 		subpage = nth_page(dst_page, i);
-		if (allow_pagefault)
-			page_kaddr = kmap(subpage);
-		else
-			page_kaddr = kmap_atomic(subpage);
+		page_kaddr = kmap_local_page(subpage);
+		if (!allow_pagefault)
+			pagefault_disable();
 		rc = copy_from_user(page_kaddr,
 				usr_src + i * PAGE_SIZE, PAGE_SIZE);
-		if (allow_pagefault)
-			kunmap(subpage);
-		else
-			kunmap_atomic(page_kaddr);
+		if (!allow_pagefault)
+			pagefault_enable();
+		kunmap_local(page_kaddr);
 
 		ret_val -= (PAGE_SIZE - rc);
 		if (rc)
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch
userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch
userfaultfd-use-helper-function-range_in_vma.patch

