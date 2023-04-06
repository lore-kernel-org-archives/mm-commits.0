Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259FFC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbjDFCod (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbjDFCoP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E674E8A42
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81CB66421A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5BCC433D2;
        Thu,  6 Apr 2023 02:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749054;
        bh=cKinkgR9cYp9beMjpUFRAye3MER4IHZVxXX5OmfP7Hw=;
        h=Date:To:From:Subject:From;
        b=tm5Uu8D9AqX+knPycoinXNamlK+9X3hUxVjk6RtUfAGCt8oyXxppA2bAydf+IXOwL
         n4L8gFC6Y6hq5EhJp91SzXKqrYXAl5zyrVLe1diPN+V+ZJr3grlOCoxLcOf/jyM0JP
         hvPFzfWTyb/S4ajg9lZ50dA0E3O87+g9LSJ9q560=
Date:   Wed, 05 Apr 2023 19:44:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hughd@google.com, agruenba@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-mapping_get_entry-available-outside-of-filemapc.patch removed from -mm tree
Message-Id: <20230406024413.DB5BCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make mapping_get_entry available outside of filemap.c
has been removed from the -mm tree.  Its filename was
     mm-make-mapping_get_entry-available-outside-of-filemapc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: make mapping_get_entry available outside of filemap.c
Date: Tue, 7 Mar 2023 15:34:05 +0100

mapping_get_entry is useful for page cache API users that need to know
about xa_value internals.  Rename it and make it available in pagemap.h.

Link: https://lkml.kernel.org/r/20230307143410.28031-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 +
 mm/filemap.c            |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/pagemap.h~mm-make-mapping_get_entry-available-outside-of-filemapc
+++ a/include/linux/pagemap.h
@@ -507,6 +507,7 @@ pgoff_t page_cache_prev_miss(struct addr
 #define FGP_ENTRY		0x00000080
 #define FGP_STABLE		0x00000100
 
+void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
 struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 		int fgp_flags, gfp_t gfp);
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
--- a/mm/filemap.c~mm-make-mapping_get_entry-available-outside-of-filemapc
+++ a/mm/filemap.c
@@ -1836,7 +1836,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  */
 
 /*
- * mapping_get_entry - Get a page cache entry.
+ * filemap_get_entry - Get a page cache entry.
  * @mapping: the address_space to search
  * @index: The page cache index.
  *
@@ -1847,7 +1847,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  *
  * Return: The folio, swap or shadow entry, %NULL if nothing is found.
  */
-static void *mapping_get_entry(struct address_space *mapping, pgoff_t index)
+void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct folio *folio;
@@ -1917,7 +1917,7 @@ struct folio *__filemap_get_folio(struct
 	struct folio *folio;
 
 repeat:
-	folio = mapping_get_entry(mapping, index);
+	folio = filemap_get_entry(mapping, index);
 	if (xa_is_value(folio)) {
 		if (fgp_flags & FGP_ENTRY)
 			return folio;
_

Patches currently in -mm which might be from hch@lst.de are


