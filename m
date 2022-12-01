Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EBDC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiLAAIl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiLAAGi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2BE10FE
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BEDC6176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997F2C433D7;
        Thu,  1 Dec 2022 00:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852957;
        bh=r5qDn4bwE4KVKqZNSXxsk0RqwqgVkBsJ1ez28aEr7q8=;
        h=Date:To:From:Subject:From;
        b=TPEY8dVnyKw52GqVJLsKpzMMvo4ABQH4+wyhPtfCHEeCTQ2AyJ6zA6wqNPVOELu//
         4ON6QJgFEABKJdFnpGhubThNZQArmRKra+6QnsTddXmsuIUuICEAjsZykfheyBOSdw
         b/7blzMOAVjTdiy5RySqXwh+gI4qmgEvt+XlfzT8=
Date:   Wed, 30 Nov 2022 16:02:36 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        naoya.horiguchi@nec.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepage-replace-try_to_release_page-with-filemap_release_folio.patch removed from -mm tree
Message-Id: <20221201000237.997F2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: khugepage: replace try_to_release_page() with filemap_release_folio()
has been removed from the -mm tree.  Its filename was
     khugepage-replace-try_to_release_page-with-filemap_release_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1789,6 +1789,7 @@ static int collapse_file(struct mm_struc
 	xas_set(&xas, start);
 	for (index = start; index < end; index++) {
 		struct page *page = xas_next(&xas);
+		struct folio *folio;
 
 		VM_BUG_ON(index != xas.xa_index);
 		if (is_shmem) {
@@ -1815,8 +1816,6 @@ static int collapse_file(struct mm_struc
 			}
 
 			if (xa_is_value(page) || !PageUptodate(page)) {
-				struct folio *folio;
-
 				xas_unlock_irq(&xas);
 				/* swap in or instantiate fallocated page */
 				if (shmem_get_folio(mapping->host, index,
@@ -1904,13 +1903,15 @@ static int collapse_file(struct mm_struc
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
@@ -1920,20 +1921,20 @@ static int collapse_file(struct mm_struc
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

filemap-convert-replace_page_cache_page-to-replace_page_cache_folio.patch
fuse-convert-fuse_try_move_page-to-use-folios.patch
userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch
khugepage-replace-lru_cache_add-with-folio_add_lru.patch
folio-compat-remove-lru_cache_add.patch

