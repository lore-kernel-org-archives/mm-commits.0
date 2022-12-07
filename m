Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1154C63705
	for <mm-commits@archiver.kernel.org>; Wed,  7 Dec 2022 21:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLGVmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Dec 2022 16:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLGVmF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2022 16:42:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4687060D
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 13:42:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F66C61CC2
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 21:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA705C433D6;
        Wed,  7 Dec 2022 21:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670449322;
        bh=ursyUNwDQa7qwK27fxJ4FciBRnl2fJnvJB8X55u9Ths=;
        h=Date:To:From:Subject:From;
        b=MjpHVal369sccNsD+kmcKyDj7BeyarvZEl43DmdmFLzon1OF/veORwGRrsA0HTuuD
         hkh41V8tiN/Rrroi8V8Y4Ty7wQqy2vDD2H7HWAd5dHmG3qWXa2hlhKxMVEQes8YcQU
         Xo427332W++scHPiIC7kHh4qkxMBc2D5W4ej1ncU=
Date:   Wed, 07 Dec 2022 13:42:01 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, allison.henderson@oracle.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2.patch added to mm-unstable branch
Message-Id: <20221207214202.CA705C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2.patch

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
fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix.patch
fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix-2.patch
fsdax-invalidate-pages-when-cow.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch
fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared.patch
fsdax-dedupe-iter-two-files-at-the-same-time.patch
xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode.patch
fsdaxxfs-port-unshare-to-fsdax.patch
xfs-remove-restrictions-for-fsdax-and-reflink.patch

