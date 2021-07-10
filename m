Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34AFC07E95
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 04:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D422613D0
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 04:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhGJEHf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 00:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhGJEHf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 00:07:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFD0361375;
        Sat, 10 Jul 2021 04:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625889889;
        bh=eLRK8TO+Wmn61A9joiIYXQST298QG2Lb0EuRfPRsuio=;
        h=Date:From:To:Subject:From;
        b=1QOJt0QJAS2bGGm+LmtjMz9oSniAHehrbWjF+1r7I7P8jJ7BzjWhaU6Piq15PGem3
         rN2ap6mxw6JsOQQn33OfIWAZGXHpIsWl72OBXMEbILB/bnLwlPhSXA1JrOfvHmQmxB
         0PphE255Qx7j2RWFkEVjPaKMhE4lUEYIPUbfqFN0=
Date:   Fri, 09 Jul 2021 21:04:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        oliver.sang@intel.com, hulkci@huawei.com, apopple@nvidia.com
Subject:  + lib-test_hmm-remove-set-but-unused-page-variable.patch
 added to -mm tree
Message-ID: <20210710040449.YJxfV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hmm: remove set but unused page variable
has been added to the -mm tree.  Its filename is
     lib-test_hmm-remove-set-but-unused-page-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_hmm-remove-set-but-unused-page-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_hmm-remove-set-but-unused-page-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: lib/test_hmm: remove set but unused page variable

The HMM selftests use atomic_check_access() to check atomic access to a
page has been revoked.  It doesn't matter if the page mapping has been
removed from the mirrored page tables as that also implies atomic access
has been revoked.  Therefore remove the unused page variable to fix this
compiler warning:

  lib/test_hmm.c:631:16: warning: variable `page' set but not used [-Wunused-but-set-variable]

Link: https://lkml.kernel.org/r/20210706025603.4059-1-apopple@nvidia.com
Fixes: b659baea7546 ("mm: selftests for exclusive device memory")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-remove-set-but-unused-page-variable
+++ a/lib/test_hmm.c
@@ -628,10 +628,8 @@ static int dmirror_check_atomic(struct d
 
 	for (pfn = start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++) {
 		void *entry;
-		struct page *page;
 
 		entry = xa_load(&dmirror->pt, pfn);
-		page = xa_untag_pointer(entry);
 		if (xa_pointer_tag(entry) == DPT_XA_TAG_ATOMIC)
 			return -EPERM;
 	}
_

Patches currently in -mm which might be from apopple@nvidia.com are

lib-test_hmm-remove-set-but-unused-page-variable.patch

