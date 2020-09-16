Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF41C433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE9C62220E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600300663;
	bh=pUtaeskwBBkrfJWPdZpOhP37g5dfoE1SV697n7Jr2V8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aWxTvTrmX2uetxhRgEU5x384UyzDzIZh6GEYuujzlJotvqTwLQiGPwHqyYqyEiweF
	 PO5CGX9O5kuk5cnkWeoNQwkKCeedPB5KlBTDtX4z6afn2IJt2DFMaifULL0Rh+iuX4
	 ZPXabtqJCNnvT1kjeyY1CklNIH4rNYhECeIxe0SQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgIPX5m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgIPX5m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 19:57:42 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 012D422207;
        Wed, 16 Sep 2020 23:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600300662;
        bh=pUtaeskwBBkrfJWPdZpOhP37g5dfoE1SV697n7Jr2V8=;
        h=Date:From:To:Subject:From;
        b=1jJfFjkWnjjU5oeMSmn5kfhogphe7NYaLxaPjYqrYcpITF+p9muQqNzlQKB15sKJa
         pytFK69cDqNgv038W9eMeUkgzwhzfgs0dwA9t3F+51puy6Fq8s5BLpalwKWfmVa1vR
         XlM63VIrIKXaOyO3Kz4VaAh9B7m14v1Xgu6283hI=
Date:   Wed, 16 Sep 2020 16:57:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        yanfei.xu@windriver.com
Subject:  +
 mm-page_allocc-__perform_reclaim-should-return-unsigned-long.patch added to
 -mm tree
Message-ID: <20200916235741.uk_S3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: __perform_reclaim should return 'unsigned long'
has been added to the -mm tree.  Its filename is
     mm-page_allocc-__perform_reclaim-should-return-unsigned-long.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-__perform_reclaim-should-return-unsigned-long.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-__perform_reclaim-should-return-unsigned-long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/page_alloc.c: __perform_reclaim should return 'unsigned long'

__perform_reclaim()'s single caller expects it to return 'unsigned long',
hence change its return value and a local variable to 'unsigned long'.

Link: https://lkml.kernel.org/r/20200916022138.16740-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-__perform_reclaim-should-return-unsigned-long
+++ a/mm/page_alloc.c
@@ -4239,13 +4239,12 @@ EXPORT_SYMBOL_GPL(fs_reclaim_release);
 #endif
 
 /* Perform direct synchronous page reclaim */
-static int
+static unsigned long
 __perform_reclaim(gfp_t gfp_mask, unsigned int order,
 					const struct alloc_context *ac)
 {
-	int progress;
 	unsigned int noreclaim_flag;
-	unsigned long pflags;
+	unsigned long pflags, progress;
 
 	cond_resched();
 
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are

mm-memory-fix-typo-in-__do_fault-comment.patch
mm-memoryc-replace-vmf-vma-with-variable-vma.patch
mm-page_allocc-__perform_reclaim-should-return-unsigned-long.patch

