Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85BCEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjHUUmi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjHUUmA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:42:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A3D10CC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9547561806
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6C1C433C8;
        Mon, 21 Aug 2023 20:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650461;
        bh=b9GB3VeawsVnqguBByuvG+NOJNHNkLpVu1p4uKS+NbI=;
        h=Date:To:From:Subject:From;
        b=G1AQW5PZDM8U+bpK9Uhv8mdQQBvSnN9lrwitDqXD38o5sz6MILn0V6fxRLb0va/8u
         ndWQOrNzhs+jPwr8Ze03/ThIztsFVyZk3vmjhA0Y5/UyzcFxaDa55EvvEIDzk4Xjl2
         6zqoq0wHZUIJi6YjorOq4PmZwiTNv0jRga5YtZVQ=
Date:   Mon, 21 Aug 2023 13:41:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-unnecessary-inner-__get_pfnblock_flags_mask.patch removed from -mm tree
Message-Id: <20230821204100.ED6C1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove unnecessary inner __get_pfnblock_flags_mask
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-inner-__get_pfnblock_flags_mask.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_alloc: remove unnecessary inner __get_pfnblock_flags_mask
Date: Fri, 11 Aug 2023 19:59:44 +0800

Patch series "Two minor cleanups for get pageblock migratetype".

This series contains two minor cleanups for get pageblock migratetype. 
More details can be found in respective patches.


This patch (of 2):

get_pfnblock_flags_mask() just calls inline inner
__get_pfnblock_flags_mask without any extra work.  Just opencode
__get_pfnblock_flags_mask in get_pfnblock_flags_mask and replace call to
__get_pfnblock_flags_mask with call to get_pfnblock_flags_mask to remove
unnecessary __get_pfnblock_flags_mask.

Link: https://lkml.kernel.org/r/20230811115945.3423894-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230811115945.3423894-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-inner-__get_pfnblock_flags_mask
+++ a/mm/page_alloc.c
@@ -371,10 +371,16 @@ static inline int pfn_to_bitidx(const st
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 }
 
-static __always_inline
-unsigned long __get_pfnblock_flags_mask(const struct page *page,
-					unsigned long pfn,
-					unsigned long mask)
+/**
+ * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
+ * @page: The page within the block of interest
+ * @pfn: The target page frame number
+ * @mask: mask of bits that the caller is interested in
+ *
+ * Return: pageblock_bits flags
+ */
+unsigned long get_pfnblock_flags_mask(const struct page *page,
+					unsigned long pfn, unsigned long mask)
 {
 	unsigned long *bitmap;
 	unsigned long bitidx, word_bitidx;
@@ -393,24 +399,10 @@ unsigned long __get_pfnblock_flags_mask(
 	return (word >> bitidx) & mask;
 }
 
-/**
- * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
- * @page: The page within the block of interest
- * @pfn: The target page frame number
- * @mask: mask of bits that the caller is interested in
- *
- * Return: pageblock_bits flags
- */
-unsigned long get_pfnblock_flags_mask(const struct page *page,
-					unsigned long pfn, unsigned long mask)
-{
-	return __get_pfnblock_flags_mask(page, pfn, mask);
-}
-
 static __always_inline int get_pfnblock_migratetype(const struct page *page,
 					unsigned long pfn)
 {
-	return __get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
+	return get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
 }
 
 /**
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


