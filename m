Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8E8C77B60
	for <mm-commits@archiver.kernel.org>; Fri, 31 Mar 2023 22:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjCaWJO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Mar 2023 18:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjCaWJN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2023 18:09:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57652700
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 15:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FD0262C34
        for <mm-commits@vger.kernel.org>; Fri, 31 Mar 2023 22:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B22C433EF;
        Fri, 31 Mar 2023 22:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680300551;
        bh=4mJd1sx5R2RnkdQHLgZc7VkWKMeMBzGK5zOXzc1H4dI=;
        h=Date:To:From:Subject:From;
        b=zWgDWCPP6e5Uz/3bGC7CptOK4fhxGbB/FZLlOzJVf8aEFowDGk6Hstz2uHk+eAYCK
         ovB6Xa1gBu0US0RMQJ8VVXGkQJWp1t/sgrJ86m/bW7J0uz7T0vscsbyWECT3bDM4Kp
         Zv1xTebhQRfVf44bsT8f3rzxOAJITiPZ5stSkBGU=
Date:   Fri, 31 Mar 2023 15:09:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch added to mm-unstable branch
Message-Id: <20230331220911.A6B22C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: use kmap_local_page() in copy_huge_page_from_user()
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: userfaultfd: use kmap_local_page() in copy_huge_page_from_user()
Date: Fri, 31 Mar 2023 17:39:33 +0800

kmap() and kmap_atomic() are being deprecated in favor of
kmap_local_page() which is appropriate for any thread local context.[1]

Let's replace the kmap() and kmap_atomic() with kmap_local_page() in
copy_huge_page_from_user().  When allow_pagefault is false, disable page
faults to prevent potential deadlock.[2]

Link:https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com/ [1]
Link: https://lkml.kernel.org/r/20221025220136.2366143-1-ira.weiny@intel.com [2]
Link: https://lkml.kernel.org/r/20230331093937.945725-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch
userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch
userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch
userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch

