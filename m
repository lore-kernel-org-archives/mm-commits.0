Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763ACC77B72
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 01:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjDRBSg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRBSc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 21:18:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB7A46BD
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 18:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 501116176F
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 01:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4830C433EF;
        Tue, 18 Apr 2023 01:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681780709;
        bh=yaYAvrRJbRn3qVkXDgkhz3DnbAkDPVmxaJf7ULAQARs=;
        h=Date:To:From:Subject:From;
        b=JZ/SnVNCPA6eCJ3P1p/BnqQweQ3Bv0zV61vb7Bx8o7h/LTFxhXH31dVshCYMNu0lz
         xeekNRTSIhtoXsaFsqFn/FEuIhjitqxfhL+Ak1DEcY+7kCvqbv+TugQkYGrA6hHJQH
         WElkkDKcHEYTjDy3pqhUaOp5WzqQvQJ5KWY0iqbM=
Date:   Mon, 17 Apr 2023 18:18:28 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, mike.kravetz@oracle.com, david@redhat.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-use-helper-function-range_in_vma.patch added to mm-unstable branch
Message-Id: <20230418011829.A4830C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: use helper function range_in_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-use-helper-function-range_in_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-use-helper-function-range_in_vma.patch

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
Subject: userfaultfd: use helper function range_in_vma()
Date: Mon, 17 Apr 2023 08:39:19 +0800

We can use range_in_vma() to check if dst_start, dst_start + len are
within the dst_vma range.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20230417003919.930515-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-use-helper-function-range_in_vma
+++ a/mm/userfaultfd.c
@@ -31,11 +31,7 @@ struct vm_area_struct *find_dst_vma(stru
 	struct vm_area_struct *dst_vma;
 
 	dst_vma = find_vma(dst_mm, dst_start);
-	if (!dst_vma)
-		return NULL;
-
-	if (dst_start < dst_vma->vm_start ||
-	    dst_start + len > dst_vma->vm_end)
+	if (!range_in_vma(dst_vma, dst_start, dst_start + len))
 		return NULL;
 
 	/*
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-madvise-use-vma_lookup-instead-of-find_vma.patch
userfaultfd-convert-mfill_atomic_pte_copy-to-use-a-folio.patch
userfaultfd-use-kmap_local_page-in-copy_huge_page_from_user.patch
userfaultfd-convert-copy_huge_page_from_user-to-copy_folio_from_user.patch
userfaultfd-convert-mfill_atomic_hugetlb-to-use-a-folio.patch
mm-convert-copy_user_huge_page-to-copy_user_large_folio.patch
userfaultfd-convert-mfill_atomic-to-use-a-folio.patch
userfaultfd-use-helper-function-range_in_vma.patch

