Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FC1C25B72
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjJYXss (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjJYXsV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8FD194
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8124C433C7;
        Wed, 25 Oct 2023 23:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277691;
        bh=6SoZAcfZr9snFhO5iFkewgWaa5JAZM1p/FvmPF4hRBc=;
        h=Date:To:From:Subject:From;
        b=iO8x7LiWii1G0YdxzkxTWOydMNdalBwpKOWY8FMhIOVaMk9r4GI8e0kpRKKBUDaqf
         7FKCTD3Nb5v7qJGDdmYW3NgicNC4vhI9BKcr/HriX8ou1N7gQEseJVcSa9x/ICZzQe
         GXaK4j5dnRaHBRj5uTKt8iNELNaq5UYGOSQeeW3I=
Date:   Wed, 25 Oct 2023 16:48:11 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ufs-remove-ufs_get_locked_page.patch removed from -mm tree
Message-Id: <20231025234811.B8124C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ufs: remove ufs_get_locked_page()
has been removed from the -mm tree.  Its filename was
     ufs-remove-ufs_get_locked_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ufs: remove ufs_get_locked_page()
Date: Mon, 16 Oct 2023 21:11:13 +0100

Both callers are now converted to ufs_get_locked_folio().

Link: https://lkml.kernel.org/r/20231016201114.1928083-27-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/util.c |    9 ---------
 fs/ufs/util.h |    7 -------
 2 files changed, 16 deletions(-)

--- a/fs/ufs/util.c~ufs-remove-ufs_get_locked_page
+++ a/fs/ufs/util.c
@@ -229,15 +229,6 @@ ufs_set_inode_dev(struct super_block *sb
 		ufsi->i_u1.i_data[0] = cpu_to_fs32(sb, fs32);
 }
 
-struct page *ufs_get_locked_page(struct address_space *mapping, pgoff_t index)
-{
-	struct folio *folio = ufs_get_locked_folio(mapping, index);
-
-	if (folio)
-		return folio_file_page(folio, index);
-	return NULL;
-}
-
 /**
  * ufs_get_locked_folio() - locate, pin and lock a pagecache folio, if not exist
  * read it from disk.
--- a/fs/ufs/util.h~ufs-remove-ufs_get_locked_page
+++ a/fs/ufs/util.h
@@ -273,7 +273,6 @@ extern void _ubh_ubhcpymem_(struct ufs_s
 extern void _ubh_memcpyubh_(struct ufs_sb_private_info *, struct ufs_buffer_head *, unsigned char *, unsigned);
 
 /* This functions works with cache pages*/
-struct page *ufs_get_locked_page(struct address_space *mapping, pgoff_t index);
 struct folio *ufs_get_locked_folio(struct address_space *mapping, pgoff_t index);
 static inline void ufs_put_locked_folio(struct folio *folio)
 {
@@ -281,12 +280,6 @@ static inline void ufs_put_locked_folio(
        folio_put(folio);
 }
 
-static inline void ufs_put_locked_page(struct page *page)
-{
-	ufs_put_locked_folio(page_folio(page));
-}
-
-
 /*
  * macros and inline function to get important structures from ufs_sb_private_info
  */
_

Patches currently in -mm which might be from willy@infradead.org are


