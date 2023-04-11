Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C12C76196
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 03:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDKDrz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDKDrx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2023 23:47:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BB210EB
        for <mm-commits@vger.kernel.org>; Mon, 10 Apr 2023 20:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91F1861C54
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 03:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36B4C433D2;
        Tue, 11 Apr 2023 03:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681184872;
        bh=E60CN5r+U7Cp/ptB0Fdpa07VbzPCcc9ZeiKJ+q4j34M=;
        h=Date:To:From:Subject:From;
        b=wlqwzJxZsdn3OfegM7M7c/tLYI9ytSOEgVUnMhOVS62UL9lbsfSUz4cm2bU8s8Uqs
         viQ3rYyJXlh1ltQoPyzCiN61DhHblSfHVtOByPZvE3zRHSxZW6rIg7+zzY8wGIy2Gs
         fVYEfCpfDid2+SZFAqPHLs7HLgq0a8uekKph+WR8=
Date:   Mon, 10 Apr 2023 20:47:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch added to mm-unstable branch
Message-Id: <20230411034751.E36B4C433D2@smtp.kernel.org>
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
@@ -5866,16 +5866,14 @@ long copy_huge_page_from_user(struct pag
 
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

mm-madvise-use-vma_lookup-instead-of-find_vma.patch
userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch
userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch
userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch
userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch

