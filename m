Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5CCC07E96
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1ADE61380
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbhGNBfh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237249AbhGNBfh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 21:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB53F61374;
        Wed, 14 Jul 2021 01:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626226366;
        bh=ITq9wJJC4GSMMU4RL8VkDgLrljWi0j09+AEwwwmrTm8=;
        h=Date:From:To:Subject:From;
        b=fNiBvWI3NUQHk75qdMAZesR2p8MT9XDL/UrTtAacFpkDVYVIlsELl8PDCEsCpQS3L
         g2FGdY0fi0pBQUeMBC42kab3Ph+dNMpIVmkbNNjqy3pjhAEP5c/DM60NjLfq+3pzvZ
         tryDTg7fLMkMlcsADoAFIPtbW53SUz/VhD0QT3/Y=
Date:   Tue, 13 Jul 2021 18:32:45 -0700
From:   akpm@linux-foundation.org
To:     chaitanya.kulkarni@wdc.com, hch@lst.de, ira.weiny@intel.com,
        mm-commits@vger.kernel.org
Subject:  + mm-use-kmap_local_page-in-memzero_page.patch added to
 -mm tree
Message-ID: <20210714013245._HPLonFzN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use kmap_local_page in memzero_page
has been added to the -mm tree.  Its filename is
     mm-use-kmap_local_page-in-memzero_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-kmap_local_page-in-memzero_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-kmap_local_page-in-memzero_page.patch

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
Subject: mm: use kmap_local_page in memzero_page

The commit message introducing the global memzero_page explicitly mentions
switching to kmap_local_page in the commit log but doesn't actually do
that.

Link: https://lkml.kernel.org/r/20210713055231.137602-3-hch@lst.de
Fixes: 28961998f858 ("iov_iter: lift memzero_page() to highmem.h")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/highmem.h~mm-use-kmap_local_page-in-memzero_page
+++ a/include/linux/highmem.h
@@ -324,10 +324,10 @@ static inline void memcpy_to_page(struct
 
 static inline void memzero_page(struct page *page, size_t offset, size_t len)
 {
-	char *addr = kmap_atomic(page);
+	char *addr = kmap_local_page(page);
 	memset(addr + offset, 0, len);
 	flush_dcache_page(page);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 }
 
 #endif /* _LINUX_HIGHMEM_H */
_

Patches currently in -mm which might be from hch@lst.de are

mm-fix-the-try_to_unmap-prototype-for-config_mmu.patch
mm-call-flush_dcache_page-in-memcpy_to_page-and-memzero_page.patch
mm-use-kmap_local_page-in-memzero_page.patch

