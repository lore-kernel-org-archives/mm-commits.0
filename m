Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80002C77B76
	for <mm-commits@archiver.kernel.org>; Sun, 16 Apr 2023 18:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDPSqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Apr 2023 14:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjDPSqr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Apr 2023 14:46:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DD5173D
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 11:46:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E4160F5A
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 18:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA36C433D2;
        Sun, 16 Apr 2023 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681670805;
        bh=vBuSISLQXsEnivvRWeNy6TET42T2s5usBcDbW8AjVCM=;
        h=Date:To:From:Subject:From;
        b=kB7fTTGeo2ENAKQzlOyPBCmGdjB8HWYWLZnujN5E9ntc8QfZunnaZ+406XCAF97H1
         W3uIBZ0MT5HHco7k1K9CpK4XERd334PhlwOQoqbtn+XJCurOK7a9BwxEPVcfEEa9Tl
         hxCtYzkNoQ81Ku24lp8/BVfYhfj2wWcwmgyw1nXM=
Date:   Sun, 16 Apr 2023 11:46:44 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, yuzhao@google.com,
        willy@infradead.org, shy828301@gmail.com, ryan.roberts@arm.com,
        roman.gushchin@linux.dev, mkoutny@suse.com,
        kirill.shutemov@linux.intel.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch removed from -mm tree
Message-Id: <20230416184645.0BA36C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: truncate: split huge page cache page to a non-zero order if possible
has been removed from the -mm tree.  Its filename was
     mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: truncate: split huge page cache page to a non-zero order if possible
Date: Mon, 3 Apr 2023 16:18:38 -0400

To minimize the number of pages after a huge page truncation, we do not
need to split it all the way down to order-0.  The huge page has at most
three parts, the part before offset, the part to be truncated, the part
remaining at the end.  Find the greatest common divisor of them to
calculate the new page order from it, so we can split the huge page to
this order and keep the remaining pages as large and as few as possible.

Link: https://lkml.kernel.org/r/20230403201839.4097845-7-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/mm/truncate.c~mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible
+++ a/mm/truncate.c
@@ -22,6 +22,7 @@
 #include <linux/buffer_head.h>	/* grr. try_to_release_page */
 #include <linux/shmem_fs.h>
 #include <linux/rmap.h>
+#include <linux/gcd.h>
 #include "internal.h"
 
 /*
@@ -211,7 +212,8 @@ int truncate_inode_folio(struct address_
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 {
 	loff_t pos = folio_pos(folio);
-	unsigned int offset, length;
+	unsigned int offset, length, remaining;
+	unsigned int new_order = folio_order(folio);
 
 	if (pos < start)
 		offset = start - pos;
@@ -222,6 +224,7 @@ bool truncate_inode_partial_folio(struct
 		length = length - offset;
 	else
 		length = end + 1 - pos - offset;
+	remaining = folio_size(folio) - offset - length;
 
 	folio_wait_writeback(folio);
 	if (length == folio_size(folio)) {
@@ -236,11 +239,25 @@ bool truncate_inode_partial_folio(struct
 	 */
 	folio_zero_range(folio, offset, length);
 
+	/*
+	 * Use the greatest common divisor of offset, length, and remaining
+	 * as the smallest page size and compute the new order from it. So we
+	 * can truncate a subpage as large as possible. Round up gcd to
+	 * PAGE_SIZE, otherwise ilog2 can give -1 when gcd/PAGE_SIZE is 0.
+	 */
+	new_order = ilog2(round_up(gcd(gcd(offset, length), remaining),
+				   PAGE_SIZE) / PAGE_SIZE);
+
+	/* order-1 THP not supported, downgrade to order-0 */
+	if (new_order == 1)
+		new_order = 0;
+
+
 	if (folio_has_private(folio))
 		folio_invalidate(folio, offset, length);
 	if (!folio_test_large(folio))
 		return true;
-	if (split_folio(folio) == 0)
+	if (split_huge_page_to_list_to_order(&folio->page, NULL, new_order) == 0)
 		return true;
 	if (folio_test_dirty(folio))
 		return false;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch

