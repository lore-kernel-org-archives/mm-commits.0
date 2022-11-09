Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB949C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiKIBkh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKIBjv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5BA64A25
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC7AFB81CC9
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE00C433C1;
        Wed,  9 Nov 2022 01:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957944;
        bh=3iW+zZ2GBJUPajdKdU3QXd2vA6J91RbHG1RKwpIXn8Q=;
        h=Date:To:From:Subject:From;
        b=ghYV9ur9nvqNUExG9F3clg+yvlOHb9YSX7C6mD0ebftk6AYIhWLEhVVM8hM4E8XVQ
         fMhoD+41Hh3Z9Q8aZuhv8BnI5gbIaZ+p4IQVqcC69WjcRzTFComKT3R39VX8gyhLE+
         zz/HOLznLZv76ueTMWZ8tkUXCutWG+sjHoLZf/v8=
Date:   Tue, 08 Nov 2022 17:39:04 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-find_get_incore_page-to-use-folios.patch removed from -mm tree
Message-Id: <20221109013904.8AE00C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert find_get_incore_page to use folios
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-find_get_incore_page-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert find_get_incore_page to use folios
Date: Wed, 19 Oct 2022 19:33:30 +0100

Eliminates a use of FGP_HEAD and saves 35 bytes of text.

Link: https://lkml.kernel.org/r/20221019183332.2802139-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/swap_state.c~mm-swap-convert-find_get_incore_page-to-use-folios
+++ a/mm/swap_state.c
@@ -386,17 +386,14 @@ struct page *find_get_incore_page(struct
 {
 	swp_entry_t swp;
 	struct swap_info_struct *si;
-	struct page *page = pagecache_get_page(mapping, index,
-						FGP_ENTRY | FGP_HEAD, 0);
+	struct folio *folio = __filemap_get_folio(mapping, index, FGP_ENTRY, 0);
 
-	if (!page)
-		return page;
-	if (!xa_is_value(page))
-		return find_subpage(page, index);
+	if (!xa_is_value(folio))
+		goto out;
 	if (!shmem_mapping(mapping))
 		return NULL;
 
-	swp = radix_to_swp_entry(page);
+	swp = radix_to_swp_entry(folio);
 	/* There might be swapin error entries in shmem mapping. */
 	if (non_swap_entry(swp))
 		return NULL;
@@ -404,9 +401,13 @@ struct page *find_get_incore_page(struct
 	si = get_swap_device(swp);
 	if (!si)
 		return NULL;
-	page = find_get_page(swap_address_space(swp), swp_offset(swp));
+	index = swp_offset(swp);
+	folio = filemap_get_folio(swap_address_space(swp), index);
 	put_swap_device(si);
-	return page;
+out:
+	if (!folio)
+		return NULL;
+	return folio_file_page(folio, index);
 }
 
 struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
_

Patches currently in -mm which might be from willy@infradead.org are


