Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6E7C001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 01:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiLLBQZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 20:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLLBQY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 20:16:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0949665AD
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 17:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE718B80B3B
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 01:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE09C433EF;
        Mon, 12 Dec 2022 01:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670807780;
        bh=Fj1MbLb0wB98fiUfodryJLWfYOvtCPveJpQe9Nb6csE=;
        h=Date:To:From:Subject:From;
        b=QfqaXJuUIvq+G59lwPw4H4VG5Q6k+q7K0BgboV+jeGZOguhYCfDXjtggXqLxhVCqj
         4F8v+NCiksnpfm1KmDy03NLufDZgFbbpy4bZqXKEFp133E1gpCx0iFiHFFvTcyM57D
         1W4t/tinfMGXmrbbrl1oqvlj9eTAg3m3ZtbGeQto=
Date:   Sun, 11 Dec 2022 17:16:19 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, allison.henderson@oracle.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2.patch removed from -mm tree
Message-Id: <20221212011620.4EE09C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2
has been removed from the -mm tree.  Its filename was
     fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2.patch

This patch was dropped because it was folded into fsdax-introduce-page-share-for-fsdax-in-reflink-mode.patch

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2
Date: Wed, 7 Dec 2022 02:49:19 +0000

v2.2

Link: https://lkml.kernel.org/r/1670381359-53-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                   |   14 +++++++-------
 include/linux/page-flags.h |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/dax.c~fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2
+++ a/fs/dax.c
@@ -336,28 +336,28 @@ static unsigned long dax_end_pfn(void *e
 
 static inline bool dax_page_is_shared(struct page *page)
 {
-	return (unsigned long)page->mapping == PAGE_MAPPING_DAX_SHARED;
+	return page->mapping == PAGE_MAPPING_DAX_SHARED;
 }
 
 /*
  * Set the page->mapping with PAGE_MAPPING_DAX_SHARED flag, increase the
  * refcount.
  */
-static inline void dax_page_bump_sharing(struct page *page)
+static inline void dax_page_share_get(struct page *page)
 {
-	if ((uintptr_t)page->mapping != PAGE_MAPPING_DAX_SHARED) {
+	if (page->mapping != PAGE_MAPPING_DAX_SHARED) {
 		/*
 		 * Reset the index if the page was already mapped
 		 * regularly before.
 		 */
 		if (page->mapping)
 			page->share = 1;
-		page->mapping = (void *)PAGE_MAPPING_DAX_SHARED;
+		page->mapping = PAGE_MAPPING_DAX_SHARED;
 	}
 	page->share++;
 }
 
-static inline unsigned long dax_page_drop_sharing(struct page *page)
+static inline unsigned long dax_page_share_put(struct page *page)
 {
 	return --page->share;
 }
@@ -381,7 +381,7 @@ static void dax_associate_entry(void *en
 		struct page *page = pfn_to_page(pfn);
 
 		if (shared) {
-			dax_page_bump_sharing(page);
+			dax_page_share_get(page);
 		} else {
 			WARN_ON_ONCE(page->mapping);
 			page->mapping = mapping;
@@ -404,7 +404,7 @@ static void dax_disassociate_entry(void
 		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
 		if (dax_page_is_shared(page)) {
 			/* keep the shared flag if this page is still shared */
-			if (dax_page_drop_sharing(page) > 0)
+			if (dax_page_share_put(page) > 0)
 				continue;
 		} else
 			WARN_ON_ONCE(page->mapping && page->mapping != mapping);
--- a/include/linux/page-flags.h~fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2
+++ a/include/linux/page-flags.h
@@ -638,7 +638,7 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemma
  * Different with flags above, this flag is used only for fsdax mode.  It
  * indicates that this page->mapping is now under reflink case.
  */
-#define PAGE_MAPPING_DAX_SHARED	0x1
+#define PAGE_MAPPING_DAX_SHARED	((void *)0x1)
 
 static __always_inline bool folio_mapping_flags(struct folio *folio)
 {
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

fsdax-introduce-page-share-for-fsdax-in-reflink-mode.patch
fsdax-invalidate-pages-when-cow.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch
fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared.patch
fsdax-dedupe-iter-two-files-at-the-same-time.patch
xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode.patch
fsdaxxfs-port-unshare-to-fsdax.patch
xfs-remove-restrictions-for-fsdax-and-reflink.patch

