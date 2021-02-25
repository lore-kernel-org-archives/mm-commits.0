Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6EBC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5233364F49
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhBYTao (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:30:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234538AbhBYT16 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9384064F93;
        Thu, 25 Feb 2021 19:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280579;
        bh=m8bLteOq8R4hY3n81esjDu60cl1pB87VgF27Wv7QtOU=;
        h=Date:From:To:Subject:From;
        b=HQs8BixCCsticBtDQ/49uH22Z8TwFWTyiSZ0BStMkv/cNOHtcmC1BZ37fnu06bSoE
         LjOscfvwFSuIHjiWFVckVEL6pJEWU9vrHaHF2arsYIJjceJwNyD4aR8U5M66kK8YPR
         IX6YVyzVu0wfFxJdWdDiHjyuLLquLYSk3Bo3lTUI=
Date:   Thu, 25 Feb 2021 11:16:18 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, gustavoars@kernel.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, sam@ravnborg.org, tglx@linutronix.de
Subject:  [merged]
 video-fbdev-acornfb-remove-free_unused_pages.patch removed from -mm tree
Message-ID: <20210225191618.8hGyoknzI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: video: fbdev: acornfb: remove free_unused_pages()
has been removed from the -mm tree.  Its filename was
     video-fbdev-acornfb-remove-free_unused_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from david@redhat.com are

mm-cma-expose-all-pages-to-the-buddy-if-activation-of-an-area-fails.patch
mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch
mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2.patch
mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v3.patch
mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource.patch
drivers-base-memory-dont-store-phys_device-in-memory-blocks.patch
documentation-sysfs-memory-clarify-some-memory-block-device-properties.patch
virtio-mem-check-against-mhp_get_pluggable_range-which-memory-we-can-hotplug.patch

