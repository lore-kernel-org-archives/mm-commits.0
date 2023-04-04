Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2C1C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 21:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbjDDVpL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbjDDVpI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 17:45:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F512173A
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 14:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEE2063A2D
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 21:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242A5C433D2;
        Tue,  4 Apr 2023 21:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680644706;
        bh=1Wd7rP7VQ/j5rwg7ZcIdVP2P9oIPC5str7Ac7F4z1Ko=;
        h=Date:To:From:Subject:From;
        b=PvbpAIq1c/2FE6c0p9TEV6ivZm/HJA8OmjDyK8kafgCRA/u16FACppCfYKnhTyGRw
         jkwrTg3a+n1jg6wtgFWjN93sKHcm2RYZQnQQnzrFoo31vSmYa+4ealRvyxLgCVgMGE
         W7vn1AETd3oPtV/XbeBXz3/fBNI6o15EWpdNS9cw=
Date:   Tue, 04 Apr 2023 14:45:05 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, yuzhao@google.com,
        willy@infradead.org, shy828301@gmail.com, ryan.roberts@arm.com,
        roman.gushchin@linux.dev, mkoutny@suse.com,
        kirill.shutemov@linux.intel.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch added to mm-unstable branch
Message-Id: <20230404214506.242A5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: truncate: split huge page cache page to a non-zero order if possible
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch
mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch
mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch
mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch
mm-thp-split-huge-page-to-any-lower-order-pages.patch
mm-truncate-split-huge-page-cache-page-to-a-non-zero-order-if-possible.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch

