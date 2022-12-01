Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8BCC4708E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiLAAIm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiLAAGk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164455F95
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EE2461E5B
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E376FC4347C;
        Thu,  1 Dec 2022 00:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852960;
        bh=6yFn51elkrXcL3F9oNQpcKKJP2MwlFfIARvnq0A5qxc=;
        h=Date:To:From:Subject:From;
        b=xzfVgMO6p4zJdKm356W6l9XgzkfzNslHxdAz6JBLnR3BMGyKEiD0KOKOov2WLkPiZ
         +fxUFsNzkawFQ+/yd5uF0SNGyuodzQwArjPWx1J8X5overnyIGUDlBo15n5Dx6DMZw
         FIRMAeDuw+R1naKNUc1BhrB0KxqdVgl7Y3oUY0Hs=
Date:   Wed, 30 Nov 2022 16:02:39 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        naoya.horiguchi@nec.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] folio-compat-remove-try_to_release_page.patch removed from -mm tree
Message-Id: <20221201000239.E376FC4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: folio-compat: remove try_to_release_page()
has been removed from the -mm tree.  Its filename was
     folio-compat-remove-try_to_release_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: folio-compat: remove try_to_release_page()
Date: Thu, 17 Nov 2022 23:30:55 -0800

There are no more callers of try_to_release_page(), so remove it.  This
saves 85 bytes of kernel text.

Link: https://lkml.kernel.org/r/20221118073055.55694-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 mm/folio-compat.c       |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/pagemap.h~folio-compat-remove-try_to_release_page
+++ a/include/linux/pagemap.h
@@ -1105,7 +1105,6 @@ void __filemap_remove_folio(struct folio
 void replace_page_cache_page(struct page *old, struct page *new);
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct folio_batch *fbatch);
-int try_to_release_page(struct page *page, gfp_t gfp);
 bool filemap_release_folio(struct folio *folio, gfp_t gfp);
 loff_t mapping_seek_hole_data(struct address_space *, loff_t start, loff_t end,
 		int whence);
--- a/mm/folio-compat.c~folio-compat-remove-try_to_release_page
+++ a/mm/folio-compat.c
@@ -118,12 +118,6 @@ struct page *grab_cache_page_write_begin
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
 
-int try_to_release_page(struct page *page, gfp_t gfp)
-{
-	return filemap_release_folio(page_folio(page), gfp);
-}
-EXPORT_SYMBOL(try_to_release_page);
-
 int isolate_lru_page(struct page *page)
 {
 	if (WARN_RATELIMIT(PageTail(page), "trying to isolate tail page"))
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-convert-replace_page_cache_page-to-replace_page_cache_folio.patch
fuse-convert-fuse_try_move_page-to-use-folios.patch
userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch
khugepage-replace-lru_cache_add-with-folio_add_lru.patch
folio-compat-remove-lru_cache_add.patch

