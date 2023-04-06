Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDDAC761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbjDFCos (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbjDFCoU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406F88A53
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2290F640CA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA9FC433EF;
        Thu,  6 Apr 2023 02:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749058;
        bh=64dD5XUT2jmBpGZqVLC14T0/ReknDSaxkEdr8uECPXY=;
        h=Date:To:From:Subject:From;
        b=R7KfZ5PZ3up7OJIe2Yu3ips6osXEdC4Gu7tbQAPHVgnEoXn+rE5tnUqeKE1Q04ghX
         0UhgxxyR5NoUrrnIRX0HaKzHjV79gSoOuuCuMl40NNUJVOBqJU6hzhvEtzad6OooBh
         kaRFQElnpyFBeba1LLCruBPWnIjzUXKf/aJcB7Rg=
Date:   Wed, 05 Apr 2023 19:44:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hughd@google.com, agruenba@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-fgp_entry.patch removed from -mm tree
Message-Id: <20230406024418.7BA9FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove FGP_ENTRY
has been removed from the -mm tree.  Its filename was
     mm-remove-fgp_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove FGP_ENTRY
Date: Tue, 7 Mar 2023 15:34:09 +0100

FGP_ENTRY is unused now, so remove it.

Link: https://lkml.kernel.org/r/20230307143410.28031-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 +--
 mm/filemap.c            |    7 +------
 mm/folio-compat.c       |    4 ++--
 3 files changed, 4 insertions(+), 10 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-fgp_entry
+++ a/include/linux/pagemap.h
@@ -504,8 +504,7 @@ pgoff_t page_cache_prev_miss(struct addr
 #define FGP_NOFS		0x00000010
 #define FGP_NOWAIT		0x00000020
 #define FGP_FOR_MMAP		0x00000040
-#define FGP_ENTRY		0x00000080
-#define FGP_STABLE		0x00000100
+#define FGP_STABLE		0x00000080
 
 void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
 struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
--- a/mm/filemap.c~mm-remove-fgp_entry
+++ a/mm/filemap.c
@@ -1891,8 +1891,6 @@ out:
  *
  * * %FGP_ACCESSED - The folio will be marked accessed.
  * * %FGP_LOCK - The folio is returned locked.
- * * %FGP_ENTRY - If there is a shadow / swap / DAX entry, return it
- *   instead of allocating a new folio to replace it.
  * * %FGP_CREAT - If no page is present then a new page is allocated using
  *   @gfp and added to the page cache and the VM's LRU list.
  *   The page is returned locked and with an increased refcount.
@@ -1918,11 +1916,8 @@ struct folio *__filemap_get_folio(struct
 
 repeat:
 	folio = filemap_get_entry(mapping, index);
-	if (xa_is_value(folio)) {
-		if (fgp_flags & FGP_ENTRY)
-			return folio;
+	if (xa_is_value(folio))
 		folio = NULL;
-	}
 	if (!folio)
 		goto no_page;
 
--- a/mm/folio-compat.c~mm-remove-fgp_entry
+++ a/mm/folio-compat.c
@@ -97,8 +97,8 @@ struct page *pagecache_get_page(struct a
 	struct folio *folio;
 
 	folio = __filemap_get_folio(mapping, index, fgp_flags, gfp);
-	if (!folio || xa_is_value(folio))
-		return &folio->page;
+	if (!folio)
+		return NULL;
 	return folio_file_page(folio, index);
 }
 EXPORT_SYMBOL(pagecache_get_page);
_

Patches currently in -mm which might be from hch@lst.de are


