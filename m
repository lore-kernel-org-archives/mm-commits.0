Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2738C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 22:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiKRWJs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 17:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiKRWJC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 17:09:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E957179E3A
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 14:08:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D4762795
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 22:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0D0C43470;
        Fri, 18 Nov 2022 22:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668809329;
        bh=4/iJiCo9+OBXMc2MOh0Rujpk9S1b/d3cSqSrE7nZivE=;
        h=Date:To:From:Subject:From;
        b=qCKha/qaxGayCvvqyiyXa51JOkvrKbNkG6xGB1t7DM4e5Zs1w/FaBnFwgiSrYsTU4
         9/x8pQxGJTILOrwnsUd5FBySG36eZhHiqY3X6nvwNo7zsNBcUkmgDOlOhiE/0f/1Ef
         SUs0tQqjdtE+yMZE6mCyW+lTzUtYSH0RdB1cSCX8=
Date:   Fri, 18 Nov 2022 14:08:48 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        naoya.horiguchi@nec.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + folio-compat-remove-try_to_release_page.patch added to mm-unstable branch
Message-Id: <20221118220848.DF0D0C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: folio-compat: remove try_to_release_page()
has been added to the -mm mm-unstable branch.  Its filename is
     folio-compat-remove-try_to_release_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/folio-compat-remove-try_to_release_page.patch

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
Subject: folio-compat: remove try_to_release_page()
Date: Thu, 17 Nov 2022 23:30:55 -0800

There are no more callers of try_to_release_page(), so remove it.  This
saves 149 bytes of kernel text.

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

ext4-convert-move_extent_per_page-to-use-folios.patch
khugepage-replace-try_to_release_page-with-filemap_release_folio.patch
memory-failure-convert-truncate_error_page-to-use-folio.patch
folio-compat-remove-try_to_release_page.patch

