Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F42C001DE
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbjGMR10 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbjGMR1V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5CB1BEB
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5600461ADB
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED72C433C7;
        Thu, 13 Jul 2023 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689269215;
        bh=BJQNw9xrG/S6dL31T47BJ4REiluaJpYrgC6K7FF3Wp0=;
        h=Date:To:From:Subject:From;
        b=eyu+I2fUB03e+QtU+nCzCCfGNh3MldCp8DbsZ6w4lGbSEYQ01EhZ/UGL8Zo4Kzx7w
         JGmPe5+vNGA6bYu4zByOixMh4ZwNgHJo7kfKWyTTKWE2bA3LqMRwFwveVeeXBek/XR
         y9WPsPp4rPfSFf30ojycDKGIzHjNegDLjPUPqugo=
Date:   Thu, 13 Jul 2023 10:26:55 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch added to mm-unstable branch
Message-Id: <20230713172655.AED72C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2: use a folio in jbd2_journal_write_metadata_buffer()
has been added to the -mm mm-unstable branch.  Its filename is
     jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch

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
Subject: jbd2: use a folio in jbd2_journal_write_metadata_buffer()
Date: Thu, 13 Jul 2023 04:55:11 +0100

The primary goal here is removing the use of set_bh_page().  Take the
opportunity to switch from kmap_atomic() to kmap_local().  This simplifies
the function as the offset is already added to the pointer.

Link: https://lkml.kernel.org/r/20230713035512.4139457-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/fs/jbd2/journal.c~jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer
+++ a/fs/jbd2/journal.c
@@ -341,7 +341,7 @@ int jbd2_journal_write_metadata_buffer(t
 	int do_escape = 0;
 	char *mapped_data;
 	struct buffer_head *new_bh;
-	struct page *new_page;
+	struct folio *new_folio;
 	unsigned int new_offset;
 	struct buffer_head *bh_in = jh2bh(jh_in);
 	journal_t *journal = transaction->t_journal;
@@ -370,14 +370,14 @@ repeat:
 	 */
 	if (jh_in->b_frozen_data) {
 		done_copy_out = 1;
-		new_page = virt_to_page(jh_in->b_frozen_data);
-		new_offset = offset_in_page(jh_in->b_frozen_data);
+		new_folio = virt_to_folio(jh_in->b_frozen_data);
+		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
 	} else {
-		new_page = jh2bh(jh_in)->b_page;
-		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
+		new_folio = jh2bh(jh_in)->b_folio;
+		new_offset = offset_in_folio(new_folio, jh2bh(jh_in)->b_data);
 	}
 
-	mapped_data = kmap_atomic(new_page);
+	mapped_data = kmap_local_folio(new_folio, new_offset);
 	/*
 	 * Fire data frozen trigger if data already wasn't frozen.  Do this
 	 * before checking for escaping, as the trigger may modify the magic
@@ -385,18 +385,17 @@ repeat:
 	 * data in the buffer.
 	 */
 	if (!done_copy_out)
-		jbd2_buffer_frozen_trigger(jh_in, mapped_data + new_offset,
+		jbd2_buffer_frozen_trigger(jh_in, mapped_data,
 					   jh_in->b_triggers);
 
 	/*
 	 * Check for escaping
 	 */
-	if (*((__be32 *)(mapped_data + new_offset)) ==
-				cpu_to_be32(JBD2_MAGIC_NUMBER)) {
+	if (*((__be32 *)mapped_data) == cpu_to_be32(JBD2_MAGIC_NUMBER)) {
 		need_copy_out = 1;
 		do_escape = 1;
 	}
-	kunmap_atomic(mapped_data);
+	kunmap_local(mapped_data);
 
 	/*
 	 * Do we need to do a data copy?
@@ -417,12 +416,10 @@ repeat:
 		}
 
 		jh_in->b_frozen_data = tmp;
-		mapped_data = kmap_atomic(new_page);
-		memcpy(tmp, mapped_data + new_offset, bh_in->b_size);
-		kunmap_atomic(mapped_data);
+		memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_size);
 
-		new_page = virt_to_page(tmp);
-		new_offset = offset_in_page(tmp);
+		new_folio = virt_to_folio(tmp);
+		new_offset = offset_in_folio(new_folio, tmp);
 		done_copy_out = 1;
 
 		/*
@@ -438,12 +435,12 @@ repeat:
 	 * copying, we can finally do so.
 	 */
 	if (do_escape) {
-		mapped_data = kmap_atomic(new_page);
-		*((unsigned int *)(mapped_data + new_offset)) = 0;
-		kunmap_atomic(mapped_data);
+		mapped_data = kmap_local_folio(new_folio, new_offset);
+		*((unsigned int *)mapped_data) = 0;
+		kunmap_local(mapped_data);
 	}
 
-	set_bh_page(new_bh, new_page, new_offset);
+	folio_set_bh(new_bh, new_folio, new_offset);
 	new_bh->b_size = bh_in->b_size;
 	new_bh->b_bdev = journal->j_dev;
 	new_bh->b_blocknr = blocknr;
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

