Return-Path: <SRS0=50af=CO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297A9C433E2
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE56F2074B
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599338098;
	bh=tOUjINReW/gIWynmYuJzj4i6eESWdBCSCow13zcrn08=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WUngvr2ztYHcKMxKxafeb+qz41JCx0mGx5FnqoEo5uhpdYo08KxFwWKetFcuixiw1
	 uzcnVWJmGJI7MBsChXsHZREC6VLqUcnlqEqZq4ZVbtfSMzXR/F5QNDgzJ3lJPFsbpe
	 41glHN7Lsxu7JhGlXjGQe1E5i1k7DaVnHtFeG66c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIEUe6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Sep 2020 16:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEUe6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 5 Sep 2020 16:34:58 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B415020738;
        Sat,  5 Sep 2020 20:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599338097;
        bh=tOUjINReW/gIWynmYuJzj4i6eESWdBCSCow13zcrn08=;
        h=Date:From:To:Subject:From;
        b=TPoTMBp2oLeZIMGs5VtfdlLTw5KBENP/qoJ16IItqgU2S585bvQJfBzRPbR0rvebb
         CQbQu8RayAypcDFKoynA6JOBFXZt4cF+GU9oXrKSPEKFoGZHjK6JR//DoZe9486uMs
         YCSqRQlrnx8bde1IaKD1ladl4EWARFiNg+XnrKoE=
Date:   Sat, 05 Sep 2020 13:34:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com,
        linmiaohe@huawei.com
Subject:  + mm-swap-fix-confusing-comment-in-release_pages.patch
 added to -mm tree
Message-ID: <20200905203457.cVbdy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: fix confusing comment in release_pages()
has been added to the -mm tree.  Its filename is
     mm-swap-fix-confusing-comment-in-release_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-confusing-comment-in-release_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-confusing-comment-in-release_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap.c: fix confusing comment in release_pages()

Since commit 07d802699528 ("mm: devmap: refactor 1-based refcounting for
ZONE_DEVICE pages"), we have renamed the func put_devmap_managed_page() to
page_is_devmap_managed().

Link: https://lkml.kernel.org/r/20200905084453.19353-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-fix-confusing-comment-in-release_pages
+++ a/mm/swap.c
@@ -859,7 +859,7 @@ void release_pages(struct page **pages,
 			}
 			/*
 			 * ZONE_DEVICE pages that return 'false' from
-			 * put_devmap_managed_page() do not require special
+			 * page_is_devmap_managed() do not require special
 			 * processing, and instead, expect a call to
 			 * put_page_testzero().
 			 */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-vmstat-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

