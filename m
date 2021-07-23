Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433EAC4320A
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB7960F37
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhGWWJq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 18:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233043AbhGWWJp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 18:09:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9975B60EB5;
        Fri, 23 Jul 2021 22:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080617;
        bh=Ie8KW1gqKVigYgdWdvXa5xrDDnPZVyW4txtPpNygGLQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nhTvl0ebtSzDg/eYZOyngyAZCdsPonVl+DoSUxm8gqp3tQWRjmVI1r/3rfzHY1lGZ
         docantuwxdFgUvdmJUa3MmEGNJ8KdVDBbq+i0Tt9fHdtzQGwwEzI+C3vV61c5bUOUu
         F0mVURPP2k1zQXZLxvnDXCLmhkT9zSucOA2L/rNA=
Date:   Fri, 23 Jul 2021 15:50:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chaitanya.kulkarni@wdc.com, hch@lst.de,
        ira.weiny@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/15] mm: call flush_dcache_page() in
 memcpy_to_page() and memzero_page()
Message-ID: <20210723225017.xFO0jZesP%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: call flush_dcache_page() in memcpy_to_page() and memzero_page()

memcpy_to_page and memzero_page can write to arbitrary pages, which could
be in the page cache or in high memory, so call flush_kernel_dcache_pages
to flush the dcache.

This is a problem when using these helpers on dcache challeneged
architectures.  Right now there are just a few users, chances are no
one used the PC floppy dr\u0456ver, the aha1542 driver for an ISA SCSI
HBA, and a few advanced and optional btrfs and ext4 features on those
platforms yet since the conversion.

Link: https://lkml.kernel.org/r/20210713055231.137602-2-hch@lst.de
Fixes: bb90d4bc7b6a ("mm/highmem: Lift memcpy_[to|from]_page to core")
Fixes: 28961998f858 ("iov_iter: lift memzero_page() to highmem.h")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/highmem.h~mm-call-flush_dcache_page-in-memcpy_to_page-and-memzero_page
+++ a/include/linux/highmem.h
@@ -318,6 +318,7 @@ static inline void memcpy_to_page(struct
 
 	VM_BUG_ON(offset + len > PAGE_SIZE);
 	memcpy(to + offset, from, len);
+	flush_dcache_page(page);
 	kunmap_local(to);
 }
 
@@ -325,6 +326,7 @@ static inline void memzero_page(struct p
 {
 	char *addr = kmap_atomic(page);
 	memset(addr + offset, 0, len);
+	flush_dcache_page(page);
 	kunmap_atomic(addr);
 }
 
_
