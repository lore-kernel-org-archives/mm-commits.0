Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D48C0015E
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjGMR1Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjGMR1V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F030A1992
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84D9761B08
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84ABC433C7;
        Thu, 13 Jul 2023 17:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689269213;
        bh=OGoPDeABp8UZUKjHVAYP4KkpuWck3iolJrna+TAExJE=;
        h=Date:To:From:Subject:From;
        b=zlMY4mTDMeaFXdQfh5rpzSvyBPyl+bq3MZTCHmqwzb+ehfQolZN8a1vSqBVdwaeW8
         3/s5K7z4A6P/Pxxmd7XrPWiVrTQWWBCC+r8wYPpT3zGQaMA2NeSU5g3H7hRZPR3CuN
         7E/F/6KZuDH8cY4eR5YRLyP9x21KU+5QbsziTpDE=
Date:   Thu, 13 Jul 2023 10:26:53 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230713172653.D84ABC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs3: convert ntfs_get_block_vbo() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch

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
Subject: ntfs3: convert ntfs_get_block_vbo() to use a folio
Date: Thu, 13 Jul 2023 04:55:10 +0100

Remove a user of set_bh_page().

Link: https://lkml.kernel.org/r/20230713035512.4139457-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ntfs3/inode.c~ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio
+++ a/fs/ntfs3/inode.c
@@ -554,7 +554,7 @@ static noinline int ntfs_get_block_vbo(s
 	struct super_block *sb = inode->i_sb;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	struct ntfs_inode *ni = ntfs_i(inode);
-	struct page *page = bh->b_page;
+	struct folio *folio = bh->b_folio;
 	u8 cluster_bits = sbi->cluster_bits;
 	u32 block_size = sb->s_blocksize;
 	u64 bytes, lbo, valid;
@@ -569,7 +569,7 @@ static noinline int ntfs_get_block_vbo(s
 
 	if (is_resident(ni)) {
 		ni_lock(ni);
-		err = attr_data_read_resident(ni, page);
+		err = attr_data_read_resident(ni, &folio->page);
 		ni_unlock(ni);
 
 		if (!err)
@@ -642,17 +642,17 @@ static noinline int ntfs_get_block_vbo(s
 		 */
 		bytes = block_size;
 
-		if (page) {
+		if (folio) {
 			u32 voff = valid - vbo;
 
 			bh->b_size = block_size;
 			off = vbo & (PAGE_SIZE - 1);
-			set_bh_page(bh, page, off);
+			folio_set_bh(bh, folio, off);
 
 			err = bh_read(bh, 0);
 			if (err < 0)
 				goto out;
-			zero_user_segment(page, off + voff, off + block_size);
+			folio_zero_segment(folio, off + voff, off + block_size);
 		}
 	}
 
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

