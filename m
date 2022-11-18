Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C64C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 22:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiKRWJM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 17:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiKRWI6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 17:08:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EBF5D6AC
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 14:08:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9817C6279F
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 22:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F187AC433D7;
        Fri, 18 Nov 2022 22:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668809325;
        bh=wPDnw08Giipd2nu7a7WQWFFcZY1C9ynydKRVEDBpJsw=;
        h=Date:To:From:Subject:From;
        b=lKYBdm0eENIm0fFswRCEEelkTnpdbXqSZXKIHfdISkb4XrI8vkPirc63hNaPIgMRA
         bhub5bya4QoXlNelM7X2FeIYqAKEAZHzweCZdYEYDUqwYxzdGzl9QCPyE/m7RPFc9I
         5Q3LvgIkUBMbH3fSKGzOIESunnfJ5DbhkT+3gdoM=
Date:   Fri, 18 Nov 2022 14:08:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        naoya.horiguchi@nec.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepage-replace-try_to_release_page-with-filemap_release_folio.patch added to mm-unstable branch
Message-Id: <20221118220844.F187AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepage: replace try_to_release_page() with filemap_release_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     khugepage-replace-try_to_release_page-with-filemap_release_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepage-replace-try_to_release_page-with-filemap_release_folio.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: khugepage: replace try_to_release_page() with filemap_release_folio()
Date: Thu, 17 Nov 2022 23:30:53 -0800

Replace some calls with their folio equivalents.  This change removes 4
calls to compound_head() and is in preparation for the removal of the
try_to_release_page() wrapper.

Link: https://lkml.kernel.org/r/20221118073055.55694-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/khugepaged.c~khugepage-replace-try_to_release_page-with-filemap_release_folio
+++ a/mm/khugepaged.c
@@ -1810,6 +1810,7 @@ static int collapse_file(struct mm_struc
 	xas_set(&xas, start);
 	for (index = start; index < end; index++) {
 		page = xas_next(&xas);
+		struct folio *folio;
 
 		VM_BUG_ON(index != xas.xa_index);
 		if (is_shmem) {
@@ -1836,8 +1837,6 @@ static int collapse_file(struct mm_struc
 			}
 
 			if (xa_is_value(page) || !PageUptodate(page)) {
-				struct folio *folio;
-
 				xas_unlock_irq(&xas);
 				/* swap in or instantiate fallocated page */
 				if (shmem_get_folio(mapping->host, index,
@@ -1925,13 +1924,15 @@ static int collapse_file(struct mm_struc
 			goto out_unlock;
 		}
 
-		if (page_mapping(page) != mapping) {
+		folio = page_folio(page);
+
+		if (folio_mapping(folio) != mapping) {
 			result = SCAN_TRUNCATED;
 			goto out_unlock;
 		}
 
-		if (!is_shmem && (PageDirty(page) ||
-				  PageWriteback(page))) {
+		if (!is_shmem && (folio_test_dirty(folio) ||
+				  folio_test_writeback(folio))) {
 			/*
 			 * khugepaged only works on read-only fd, so this
 			 * page is dirty because it hasn't been flushed
@@ -1941,20 +1942,20 @@ static int collapse_file(struct mm_struc
 			goto out_unlock;
 		}
 
-		if (isolate_lru_page(page)) {
+		if (folio_isolate_lru(folio)) {
 			result = SCAN_DEL_PAGE_LRU;
 			goto out_unlock;
 		}
 
-		if (page_has_private(page) &&
-		    !try_to_release_page(page, GFP_KERNEL)) {
+		if (folio_has_private(folio) &&
+		    !filemap_release_folio(folio, GFP_KERNEL)) {
 			result = SCAN_PAGE_HAS_PRIVATE;
-			putback_lru_page(page);
+			folio_putback_lru(folio);
 			goto out_unlock;
 		}
 
-		if (page_mapped(page))
-			try_to_unmap(page_folio(page),
+		if (folio_mapped(folio))
+			try_to_unmap(folio,
 					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
 
 		xas_lock_irq(&xas);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

ext4-convert-move_extent_per_page-to-use-folios.patch
khugepage-replace-try_to_release_page-with-filemap_release_folio.patch
memory-failure-convert-truncate_error_page-to-use-folio.patch
folio-compat-remove-try_to_release_page.patch

