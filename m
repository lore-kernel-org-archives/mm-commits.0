Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01037C04A94
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjGMR11 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjGMR1V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE50268F
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F12B61B0A
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D93C433C7;
        Thu, 13 Jul 2023 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689269217;
        bh=XdRlF2kitTA4QarnaSTaJRaNRZKvPpikyH7+bbLuXpA=;
        h=Date:To:From:Subject:From;
        b=JVktMPHjNAfTG8p70s0yQFo/NXrWyaPXrhHfJzuKIdKpNSFaHm/j2H01FkZUyem7P
         VBzzwxndcuQUttD48AZ9g2IbypoNOlqzeKia3lUcF/z6JJsl1ulNdNmqWoAaI5aiKu
         t3P3CoZqqmeCJQhvJgjevL9d7DYsTmckbVxt1PiE=
Date:   Thu, 13 Jul 2023 10:26:57 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-remove-set_bh_page.patch added to mm-unstable branch
Message-Id: <20230713172657.92D93C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: remove set_bh_page()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-remove-set_bh_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-remove-set_bh_page.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: remove set_bh_page()
Date: Thu, 13 Jul 2023 04:55:12 +0100

With all users converted to folio_set_bh(), remove this function.

Link: https://lkml.kernel.org/r/20230713035512.4139457-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   15 ---------------
 include/linux/buffer_head.h |    2 --
 2 files changed, 17 deletions(-)

--- a/fs/buffer.c~buffer-remove-set_bh_page
+++ a/fs/buffer.c
@@ -1539,21 +1539,6 @@ void invalidate_bh_lrus_cpu(void)
 	bh_lru_unlock();
 }
 
-void set_bh_page(struct buffer_head *bh,
-		struct page *page, unsigned long offset)
-{
-	bh->b_page = page;
-	BUG_ON(offset >= PAGE_SIZE);
-	if (PageHighMem(page))
-		/*
-		 * This catches illegal uses and preserves the offset:
-		 */
-		bh->b_data = (char *)(0 + offset);
-	else
-		bh->b_data = page_address(page) + offset;
-}
-EXPORT_SYMBOL(set_bh_page);
-
 void folio_set_bh(struct buffer_head *bh, struct folio *folio,
 		  unsigned long offset)
 {
--- a/include/linux/buffer_head.h~buffer-remove-set_bh_page
+++ a/include/linux/buffer_head.h
@@ -194,8 +194,6 @@ void buffer_check_dirty_writeback(struct
 void mark_buffer_dirty(struct buffer_head *bh);
 void mark_buffer_write_io_error(struct buffer_head *bh);
 void touch_buffer(struct buffer_head *bh);
-void set_bh_page(struct buffer_head *bh,
-		struct page *page, unsigned long offset);
 void folio_set_bh(struct buffer_head *bh, struct folio *folio,
 		  unsigned long offset);
 bool try_to_free_buffers(struct folio *);
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch

