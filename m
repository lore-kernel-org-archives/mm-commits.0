Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440B8C727AD
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244118AbjHXXW6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244123AbjHXXWX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C139E59
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFF2B63A67
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205CDC433C7;
        Thu, 24 Aug 2023 23:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919340;
        bh=WtbMukqJYSCAJ0muyMgJq+UQlKJ4269qwKHRPrxcuKw=;
        h=Date:To:From:Subject:From;
        b=nY1cHqPH6QdfveO0Vzi+jom32ez+FoRdJ+P3dzmE2szTGslG2q2EDCHgrlKvgcEF6
         NMzv7euPQ2aUbt7jrcdz9vRT+cxsaPM/GxnhiqdfBmQhs5KAXGS4sahEcBLN7ws5gw
         r10UbxquaJFEH7/vdPUD2mmwzkEcieC47nyRbPk4=
Date:   Thu, 24 Aug 2023 16:22:19 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, david@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch removed from -mm tree
Message-Id: <20230824232220.205CDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: secretmem: convert page_is_secretmem() to folio_is_secretmem()
has been removed from the -mm tree.  Its filename was
     secretmem-conert-page_is_secretmem-to-folio_is_secretmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: secretmem: convert page_is_secretmem() to folio_is_secretmem()
Date: Tue, 22 Aug 2023 21:23:35 +0100

The only caller already has a folio, so use it to save calling
compound_head() in PageLRU() and remove a use of page->mapping.

Link: https://lkml.kernel.org/r/20230822202335.179081-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h |   15 +++++++--------
 mm/gup.c                  |    2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

--- a/include/linux/secretmem.h~secretmem-conert-page_is_secretmem-to-folio_is_secretmem
+++ a/include/linux/secretmem.h
@@ -6,24 +6,23 @@
 
 extern const struct address_space_operations secretmem_aops;
 
-static inline bool page_is_secretmem(struct page *page)
+static inline bool folio_is_secretmem(struct folio *folio)
 {
 	struct address_space *mapping;
 
 	/*
-	 * Using page_mapping() is quite slow because of the actual call
-	 * instruction and repeated compound_head(page) inside the
-	 * page_mapping() function.
+	 * Using folio_mapping() is quite slow because of the actual call
+	 * instruction.
 	 * We know that secretmem pages are not compound and LRU so we can
 	 * save a couple of cycles here.
 	 */
-	if (PageCompound(page) || !PageLRU(page))
+	if (folio_test_large(folio) || !folio_test_lru(folio))
 		return false;
 
 	mapping = (struct address_space *)
-		((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
+		((unsigned long)folio->mapping & ~PAGE_MAPPING_FLAGS);
 
-	if (!mapping || mapping != page->mapping)
+	if (!mapping || mapping != folio->mapping)
 		return false;
 
 	return mapping->a_ops == &secretmem_aops;
@@ -39,7 +38,7 @@ static inline bool vma_is_secretmem(stru
 	return false;
 }
 
-static inline bool page_is_secretmem(struct page *page)
+static inline bool folio_is_secretmem(struct folio *folio)
 {
 	return false;
 }
--- a/mm/gup.c~secretmem-conert-page_is_secretmem-to-folio_is_secretmem
+++ a/mm/gup.c
@@ -2600,7 +2600,7 @@ static int gup_pte_range(pmd_t pmd, pmd_
 		if (!folio)
 			goto pte_unmap;
 
-		if (unlikely(page_is_secretmem(page))) {
+		if (unlikely(folio_is_secretmem(folio))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
_

Patches currently in -mm which might be from willy@infradead.org are


