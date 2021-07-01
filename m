Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAADEC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58F761469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbhGABxK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238450AbhGABxK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A556105A;
        Thu,  1 Jul 2021 01:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104240;
        bh=4t4tLlA0YIs4aLmPXUV2HxdlmBdxAJZgCR1Najhl0Q4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LtMWwKvCsvOhthzBZfyFGS9fbvnLhC600kXrB4CgjJlL6QsrK5TdyEvXq8aY8Rvm6
         MvPkhaG5/9VNrTd9SQvVfQEpeOeinlSx9yMTRgfSu5eSjW4aUtWY0w30BCc/yfppS1
         YkvGx9/vNJsJ3paR5sf+A5POpG/NShrPRJRlUEMA=
Date:   Wed, 30 Jun 2021 18:50:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hdanton@sina.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 065/192] mm/z3fold: use
 release_z3fold_page_locked() to release locked z3fold page
Message-ID: <20210701015039.95EwGK4nc%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page

We should use release_z3fold_page_locked() to release z3fold page when
it's locked, although it looks harmless to use release_z3fold_page() now.

Link: https://lkml.kernel.org/r/20210619093151.1492174-7-linmiaohe@huawei.com
Fixes: dcf5aedb24f8 ("z3fold: stricter locking and more careful reclaim")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page
+++ a/mm/z3fold.c
@@ -1370,7 +1370,7 @@ static int z3fold_reclaim_page(struct z3
 			if (zhdr->foreign_handles ||
 			    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
 				if (kref_put(&zhdr->refcount,
-						release_z3fold_page))
+						release_z3fold_page_locked))
 					atomic64_dec(&pool->pages_nr);
 				else
 					z3fold_page_unlock(zhdr);
_
