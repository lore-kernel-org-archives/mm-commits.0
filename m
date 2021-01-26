Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19131C4361A
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA76B206D8
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhA0Csi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403914AbhAZTiV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 14:38:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2603A2223D;
        Tue, 26 Jan 2021 19:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611689860;
        bh=axqVJCLyQf/aKVRr6BzixjS9ELGle2AXyXPbsxQWD3Q=;
        h=Date:From:To:Subject:From;
        b=NpFd3MUg/8WEmONg/hmbXfw4A3dW0ZTHctw8vhD8crR7/GIyTykrLTKLsEZexYErh
         SXsP6w0CbeOkFHlOz5DVPdapEeSl0Atb7siSKIx6gfTQdXFBnR+TVL7vmKWEyknRfJ
         Ukgrm8v88LcEjax9YlGdpEpQDYmNGAMsn19CdS7k=
Date:   Tue, 26 Jan 2021 11:37:39 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, gustavoars@kernel.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, sam@ravnborg.org, tglx@linutronix.de
Subject:  + video-fbdev-acornfb-remove-free_unused_pages.patch
 added to -mm tree
Message-ID: <20210126193739.3cvdiBU0d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: video: fbdev: acornfb: remove free_unused_pages()
has been added to the -mm tree.  Its filename is
     video-fbdev-acornfb-remove-free_unused_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/video-fbdev-acornfb-remove-free_unused_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/video-fbdev-acornfb-remove-free_unused_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: video: fbdev: acornfb: remove free_unused_pages()

Patch series "mm: simplify free_highmem_page() and free_reserved_page()".

Let's simplify and unify free_highmem_page() and free_reserved_page().


This patch (of 2):

This function is never used and it is one of the last remaining user of
__free_reserved_page().  Let's just drop it.

Link: https://lkml.kernel.org/r/20210126182113.19892-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210126182113.19892-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
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

Patches currently in -mm which might be from david@redhat.com are

video-fbdev-acornfb-remove-free_unused_pages.patch
mm-simplify-free_highmem_page-and-free_reserved_page.patch

