Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A337C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 233BF64F28
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhBXUHM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235195AbhBXUG4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:06:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D309464F2E;
        Wed, 24 Feb 2021 20:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197189;
        bh=2iYM7+rPPzb9zRWJHyALLlK17AlvPdA0VGoBKJqkNl0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sglWpnpvceFKaln0vF7TE+rMBorTO46C1sycoaEkHgeKUVMiVNbZyhS1Vs6BPSDnu
         w0/joEXelTJZkkseaLKpm5Ry/Y/rT0EztIdnEsbioJkpxV0Pmvr2snTqx2sSIreTzN
         FoDJXFfphM1hvNn9cmR5CGP4l1FGbLoVTyPxQT2s=
Date:   Wed, 24 Feb 2021 12:06:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, gustavoars@kernel.org, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, sam@ravnborg.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 107/173] video: fbdev: acornfb: remove
 free_unused_pages()
Message-ID: <20210224200628.3noD6aLz6%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: video: fbdev: acornfb: remove free_unused_pages()

Patch series "mm: simplify free_highmem_page() and free_reserved_page()".

Let's simplify and unify free_highmem_page() and free_reserved_page().


This patch (of 2):

This function is never used and it is one of the last remaining user of
__free_reserved_page().  Let's just drop it.

Link: https://lkml.kernel.org/r/20210126182113.19892-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210126182113.19892-2-david@redhat.com
Fixes: ffd29195ed720188 ("drivers/video/acornfb.c: remove dead code")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/acornfb.c |   34 --------------------------------
 1 file changed, 34 deletions(-)

--- a/drivers/video/fbdev/acornfb.c~video-fbdev-acornfb-remove-free_unused_pages
+++ a/drivers/video/fbdev/acornfb.c
@@ -921,40 +921,6 @@ static int acornfb_detect_monitortype(vo
 	return 4;
 }
 
-/*
- * This enables the unused memory to be freed on older Acorn machines.
- * We are freeing memory on behalf of the architecture initialisation
- * code here.
- */
-static inline void
-free_unused_pages(unsigned int virtual_start, unsigned int virtual_end)
-{
-	int mb_freed = 0;
-
-	/*
-	 * Align addresses
-	 */
-	virtual_start = PAGE_ALIGN(virtual_start);
-	virtual_end = PAGE_ALIGN(virtual_end);
-
-	while (virtual_start < virtual_end) {
-		struct page *page;
-
-		/*
-		 * Clear page reserved bit,
-		 * set count to 1, and free
-		 * the page.
-		 */
-		page = virt_to_page(virtual_start);
-		__free_reserved_page(page);
-
-		virtual_start += PAGE_SIZE;
-		mb_freed += PAGE_SIZE / 1024;
-	}
-
-	printk("acornfb: freed %dK memory\n", mb_freed);
-}
-
 static int acornfb_probe(struct platform_device *dev)
 {
 	unsigned long size;
_
