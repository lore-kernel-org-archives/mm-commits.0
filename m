Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2C7C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiKIBkn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiKIBjv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D36A67123
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AC30617F0
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A3DC433C1;
        Wed,  9 Nov 2022 01:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957946;
        bh=ypJ+Cd+VhsUK2PgdKXJZwyFJ08AzPwLIqu6azeWn6P4=;
        h=Date:To:From:Subject:From;
        b=Iizfs0xpq/3aXwa0bPWAaevsirucWinCt3evhTAB6H1ZyRUx0Cb3HhIqQSmWJXnZN
         12sEXpfvhTUoxnWecVHiTlWJRJXnM3xrnqQOVBQjcxuV4JXEtPfl4aLzL1KsSYHCuI
         5NfWS6gRAnMlEQ5k0biZZGA//dbcjTlQTN9rjL7Y=
Date:   Tue, 08 Nov 2022 17:39:06 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-fgp_head.patch removed from -mm tree
Message-Id: <20221109013906.81A3DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove FGP_HEAD
has been removed from the -mm tree.  Its filename was
     mm-remove-fgp_head.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove FGP_HEAD
Date: Wed, 19 Oct 2022 19:33:32 +0100

This is no longer used; all callers have been converted to use folios
instead.  Somehow this manages to save 11 bytes of text.

Link: https://lkml.kernel.org/r/20221019183332.2802139-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 ++---
 mm/folio-compat.c       |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-fgp_head
+++ a/include/linux/pagemap.h
@@ -504,9 +504,8 @@ pgoff_t page_cache_prev_miss(struct addr
 #define FGP_NOFS		0x00000010
 #define FGP_NOWAIT		0x00000020
 #define FGP_FOR_MMAP		0x00000040
-#define FGP_HEAD		0x00000080
-#define FGP_ENTRY		0x00000100
-#define FGP_STABLE		0x00000200
+#define FGP_ENTRY		0x00000080
+#define FGP_STABLE		0x00000100
 
 struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 		int fgp_flags, gfp_t gfp);
--- a/mm/folio-compat.c~mm-remove-fgp_head
+++ a/mm/folio-compat.c
@@ -108,7 +108,7 @@ struct page *pagecache_get_page(struct a
 	struct folio *folio;
 
 	folio = __filemap_get_folio(mapping, index, fgp_flags, gfp);
-	if ((fgp_flags & FGP_HEAD) || !folio || xa_is_value(folio))
+	if (!folio || xa_is_value(folio))
 		return &folio->page;
 	return folio_file_page(folio, index);
 }
_

Patches currently in -mm which might be from willy@infradead.org are


