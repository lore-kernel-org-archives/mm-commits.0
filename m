Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F050C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FCAE61C9D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhGFUvR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 16:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhGFUvR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 16:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7583561C3B;
        Tue,  6 Jul 2021 20:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625604517;
        bh=UiNhVXd8+A7GmJSbFBc+iBAf4Gk/IYj+mJXRYbyjX9U=;
        h=Date:From:To:Subject:From;
        b=VKEnMI1fMJZAGRlOW7Z+HKpEfa3nsrSLEZhxM4tDWXvLcLKnbqmT8GU8xYQrozmSy
         +/oJT4EfKAXlvhYMKZdRYBZ9FD9vQ02YgwAQom3wXcrzpyi6GXCQFxd/K0HAWTy8tR
         0xq1znRD8NF9Y3JpqXn6kYvbzNrhz9AddOep1ePE=
Date:   Tue, 06 Jul 2021 13:48:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, hch@lst.de
Subject:  + mm-fix-the-try_to_unmap-prototype-for-config_mmu.patch
 added to -mm tree
Message-ID: <20210706204837.jCsDW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix the try_to_unmap prototype for !CONFIG_MMU
has been added to the -mm tree.  Its filename is
     mm-fix-the-try_to_unmap-prototype-for-config_mmu.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-the-try_to_unmap-prototype-for-config_mmu.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-the-try_to_unmap-prototype-for-config_mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: fix the try_to_unmap prototype for !CONFIG_MMU

Adjust the nommu stub of try_to_unmap to match the changed protype for the
full version.  Turn it into an inline instead of a macro to generally
improve the type checking.

Link: https://lkml.kernel.org/r/20210705053944.885828-1-hch@lst.de
Fixes: 1fb08ac63bee ("mm: rmap: make try_to_unmap() void function")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-fix-the-try_to_unmap-prototype-for-config_mmu
+++ a/include/linux/rmap.h
@@ -291,7 +291,9 @@ static inline int page_referenced(struct
 	return 0;
 }
 
-#define try_to_unmap(page, refs) false
+static inline void try_to_unmap(struct page *page, enum ttu_flags flags)
+{
+}
 
 static inline int page_mkclean(struct page *page)
 {
_

Patches currently in -mm which might be from hch@lst.de are

mm-fix-the-try_to_unmap-prototype-for-config_mmu.patch

