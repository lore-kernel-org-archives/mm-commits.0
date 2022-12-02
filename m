Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A75EC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbiLBUSi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbiLBUSb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:18:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7E74092F
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A71D623B2
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3EEC433D6;
        Fri,  2 Dec 2022 20:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670012309;
        bh=uQFecHUI/SYWgog2JVHDYXhumtb5nkEuYdkItC9kv/o=;
        h=Date:To:From:Subject:From;
        b=zsv8+pVX0dJj4qV8DUnbZMHsjA1ebRX/k45Z+m0KHqjk92l38Q1Mznot2Iv5rS5Ts
         YeqKTXlUTFMWnrRiGMlNfsRSfKsUfqXrWSWCstXa5bNFt0ABrM30ysuhSqVILOW93G
         KOUpKZ1y2u3NB414D1XYXYnfglsYoNb1m/DMQGYU=
Date:   Fri, 02 Dec 2022 12:18:28 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix.patch added to mm-unstable branch
Message-Id: <20221202201829.AC3EEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: introduce page->share for fsdax in reflink mode
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix.patch

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
fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix.patch
fsdax-invalidate-pages-when-cow.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch
fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared.patch
fsdax-dedupe-iter-two-files-at-the-same-time.patch
xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode.patch
fsdaxxfs-port-unshare-to-fsdax.patch
xfs-remove-restrictions-for-fsdax-and-reflink.patch

