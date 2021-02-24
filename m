Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E8AC4332E
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B11564E7A
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhBXUMz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235497AbhBXUKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E21D64F2A;
        Wed, 24 Feb 2021 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197415;
        bh=wwDyPiRX0SleMTwcSvM+kHwyYUxyk2ocyf48Jh8LQ0Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=w/ksMts0BfzPvK9ZEG29m0RcZntoykvx2TFFIfCAGAiPVB1zVY7RcjSYYa74UaMzo
         2JxR7u7+94J75QvtuVP1LE0w7xiXIq2dxnbFEw91BUVLL4dd7fr2iS4twLLwqIT5PF
         gtmVJjfP2hDKE17gNCa36lyzIcZbdYconFIpAK00=
Date:   Wed, 24 Feb 2021 12:10:14 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 169/173] hugetlbfs: make hugepage size conversion
 more readable
Message-ID: <20210224201014.gMolLNjG3%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: make hugepage size conversion more readable

The calculation 1U << (h->order + PAGE_SHIFT - 10) is actually equal to
(PAGE_SHIFT << (h->order)) >> 10.  So we can make it more readable by
replace it with huge_page_size(h) >> 10.

Link: https://lkml.kernel.org/r/20210122083141.24548-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-make-hugepage-size-conversion-more-readable
+++ a/fs/hugetlbfs/inode.c
@@ -1520,8 +1520,8 @@ static struct vfsmount *__init mount_one
 		put_fs_context(fc);
 	}
 	if (IS_ERR(mnt))
-		pr_err("Cannot mount internal hugetlbfs for page size %uK",
-		       1U << (h->order + PAGE_SHIFT - 10));
+		pr_err("Cannot mount internal hugetlbfs for page size %luK",
+		       huge_page_size(h) >> 10);
 	return mnt;
 }
 
_
