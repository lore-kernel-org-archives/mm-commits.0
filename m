Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3948FC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2389D6103C
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbhIODxm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236352AbhIODxk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA26260F25;
        Wed, 15 Sep 2021 03:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631677942;
        bh=2IP6Kr0VDE8Z9ktNR2WaF2Vr7lxVSvAJ65vevojZjUw=;
        h=Date:From:To:Subject:From;
        b=j3Odjwajh9iF1+se87bsve69aQ3ogE2b+fDOr0y4AMELY2Ci8yxVtdTgFIS3kot1l
         yRBeq78gtS9KQRI3pIoHynjIV4tFmBCHh9d3F0H5C6JWg+uhoHkXyZ7rBnw9avVq4E
         qb4RYm8LNtz7wxDLQKpS/g67OCgPU5/4FKka02uc=
Date:   Tue, 14 Sep 2021 20:52:21 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        liuyuntao10@huawei.com, mm-commits@vger.kernel.org,
        wuxu.wu@huawei.com
Subject:  + fix-judgment-error-in-shmem_is_huge.patch added to -mm
 tree
Message-ID: <20210915035221.uu9PEVK0M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: fix judgment error in shmem_is_huge()
has been added to the -mm tree.  Its filename is
     fix-judgment-error-in-shmem_is_huge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fix-judgment-error-in-shmem_is_huge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fix-judgment-error-in-shmem_is_huge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Yuntao <liuyuntao10@huawei.com>
Subject: mm/shmem.c: fix judgment error in shmem_is_huge()

In the case of SHMEM_HUGE_WITHIN_SIZE, the page index is not rounded up
correctly.  When the page index points to the first page in a huge page,
round_up() cannot bring it to the end of the huge page, but to the end of
the previous one.

An example:

HPAGE_PMD_NR on my machine is 512(2 MB huge page size).  After allcoating
a 3000 KB buffer, I access it at location 2050 KB.  In shmem_is_huge(),
the corresponding index happens to be 512.  After rounded up by
HPAGE_PMD_NR, it will still be 512 which is smaller than i_size, and
shmem_is_huge() will return true.  As a result, my buffer takes an
additional huge page, and that shouldn't happen when shmem_enabled is set
to within_size.

Link: https://lkml.kernel.org/r/20210909032007.18353-1-liuyuntao10@huawei.com
Fixes: f3f0e1d2150b2b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Liu Yuntao <liuyuntao10@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: wuxu.wu <wuxu.wu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~fix-judgment-error-in-shmem_is_huge
+++ a/mm/shmem.c
@@ -490,9 +490,9 @@ bool shmem_is_huge(struct vm_area_struct
 	case SHMEM_HUGE_ALWAYS:
 		return true;
 	case SHMEM_HUGE_WITHIN_SIZE:
-		index = round_up(index, HPAGE_PMD_NR);
+		index = round_up(index + 1, HPAGE_PMD_NR);
 		i_size = round_up(i_size_read(inode), PAGE_SIZE);
-		if (i_size >= HPAGE_PMD_SIZE && (i_size >> PAGE_SHIFT) >= index)
+		if (i_size >> PAGE_SHIFT >= index)
 			return true;
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
_

Patches currently in -mm which might be from liuyuntao10@huawei.com are

fix-judgment-error-in-shmem_is_huge.patch

