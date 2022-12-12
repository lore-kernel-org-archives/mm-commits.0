Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6650C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 01:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiLLBQY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 20:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiLLBQX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 20:16:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A60E657D
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 17:16:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42ECBB80B39
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 01:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D55C433D2;
        Mon, 12 Dec 2022 01:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670807779;
        bh=6NEuBsWcj6gN5UFfuvqmx/wRwj4s+PvxcmuZoYL9XL0=;
        h=Date:To:From:Subject:From;
        b=YhYYiVRZiZs1d2cjS+PSVutumw7xt43BX97JMMza6Q3L7zhz8kjGLcwoc+0ks98ib
         8eWucv7690BpdVCM7qav7FJnYvfRnzyo/bHGEsRQd9xBTYnB0pBzivZAf1nBrH+Lpl
         L5k8DHqmpv2CEt+nB0Vqr2IDCw6MJb/UfQaXfURY=
Date:   Sun, 11 Dec 2022 17:16:18 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, allison.henderson@oracle.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix.patch removed from -mm tree
Message-Id: <20221212011618.D1D55C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax: introduce page->share for fsdax in reflink mode
has been removed from the -mm tree.  Its filename was
     fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix.patch

This patch was dropped because it was folded into fsdax-introduce-page-share-for-fsdax-in-reflink-mode.patch

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: introduce page->share for fsdax in reflink mode
Date: Fri, 2 Dec 2022 09:23:11 +0000

rename several functions

Link: https://lkml.kernel.org/r/1669972991-246-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/dax.c~fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix
+++ a/fs/dax.c
@@ -334,7 +334,7 @@ static unsigned long dax_end_pfn(void *e
 	for (pfn = dax_to_pfn(entry); \
 			pfn < dax_end_pfn(entry); pfn++)
 
-static inline bool dax_mapping_is_shared(struct page *page)
+static inline bool dax_page_is_shared(struct page *page)
 {
 	return (unsigned long)page->mapping == PAGE_MAPPING_DAX_SHARED;
 }
@@ -343,7 +343,7 @@ static inline bool dax_mapping_is_shared
  * Set the page->mapping with PAGE_MAPPING_DAX_SHARED flag, increase the
  * refcount.
  */
-static inline void dax_mapping_set_shared(struct page *page)
+static inline void dax_page_bump_sharing(struct page *page)
 {
 	if ((uintptr_t)page->mapping != PAGE_MAPPING_DAX_SHARED) {
 		/*
@@ -357,7 +357,7 @@ static inline void dax_mapping_set_share
 	page->share++;
 }
 
-static inline unsigned long dax_mapping_decrease_shared(struct page *page)
+static inline unsigned long dax_page_drop_sharing(struct page *page)
 {
 	return --page->share;
 }
@@ -381,7 +381,7 @@ static void dax_associate_entry(void *en
 		struct page *page = pfn_to_page(pfn);
 
 		if (shared) {
-			dax_mapping_set_shared(page);
+			dax_page_bump_sharing(page);
 		} else {
 			WARN_ON_ONCE(page->mapping);
 			page->mapping = mapping;
@@ -402,9 +402,9 @@ static void dax_disassociate_entry(void
 		struct page *page = pfn_to_page(pfn);
 
 		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
-		if (dax_mapping_is_shared(page)) {
+		if (dax_page_is_shared(page)) {
 			/* keep the shared flag if this page is still shared */
-			if (dax_mapping_decrease_shared(page) > 0)
+			if (dax_page_drop_sharing(page) > 0)
 				continue;
 		} else
 			WARN_ON_ONCE(page->mapping && page->mapping != mapping);
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

fsdax-introduce-page-share-for-fsdax-in-reflink-mode.patch
fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2.patch
fsdax-invalidate-pages-when-cow.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch
fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared.patch
fsdax-dedupe-iter-two-files-at-the-same-time.patch
xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode.patch
fsdaxxfs-port-unshare-to-fsdax.patch
xfs-remove-restrictions-for-fsdax-and-reflink.patch

