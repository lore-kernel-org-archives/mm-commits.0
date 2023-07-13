Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCF6C0015E
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbjGMR1W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjGMR1U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4200C2713
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE24F61ADB
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B678C433C8;
        Thu, 13 Jul 2023 17:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689269205;
        bh=l2AWmxn6U+50ahtTMNxdkIBEFqvtT1VJ20jp1ybxc6E=;
        h=Date:To:From:Subject:From;
        b=AckhqgREsrwJKzqsSmiP0Cc5xgq/vbblXcHsFt65at5MDI5tZ4yufqRIU+hLyjBuk
         7bdlAwsmI0pGuD+hY16T8XEH/CDKVDNVoGjS4UeI4zC6/INChE+qW+3uFbX4UFxkCc
         5N2LgLUXG6ozgfRa6+mTuIg+ibrB3fMFxUPvlh9c=
Date:   Thu, 13 Jul 2023 10:26:44 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch added to mm-unstable branch
Message-Id: <20230713172645.1B678C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: add memcpy_to_folio() and memcpy_from_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch

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
Subject: highmem: add memcpy_to_folio() and memcpy_from_folio()
Date: Thu, 13 Jul 2023 04:55:06 +0100

Patch series "More filesystem folio conversions for 6.6".

Remove the only spots in affs which actually use a struct page; there
are a few places where one is mentioned, but it's part of the interface.

The rest of this is removing the remaining calls to set_bh_page(),
and then removing the function before any new users show up.


This patch (of 7):

These are the folio equivalent of memcpy_to_page() and memcpy_from_page().

Link: https://lkml.kernel.org/r/20230713035512.4139457-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230713035512.4139457-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   44 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/include/linux/highmem.h~highmem-add-memcpy_to_folio-and-memcpy_from_folio
+++ a/include/linux/highmem.h
@@ -439,6 +439,50 @@ static inline void memzero_page(struct p
 	kunmap_local(addr);
 }
 
+static inline void memcpy_from_folio(char *to, struct folio *folio,
+		size_t offset, size_t len)
+{
+	VM_BUG_ON(offset + len > folio_size(folio));
+
+	do {
+		char *from = kmap_local_folio(folio, offset);
+		size_t chunk = len;
+
+		if (folio_test_highmem(folio) &&
+		    (chunk > (PAGE_SIZE - offset_in_page(offset))))
+			chunk = PAGE_SIZE - offset_in_page(offset);
+		memcpy(to, from, len);
+		kunmap_local(from);
+
+		from += chunk;
+		offset += chunk;
+		len -= chunk;
+	} while (len > 0);
+}
+
+static inline void memcpy_to_folio(struct folio *folio, size_t offset,
+		const char *from, size_t len)
+{
+	VM_BUG_ON(offset + len > folio_size(folio));
+
+	do {
+		char *to = kmap_local_folio(folio, offset);
+		size_t chunk = len;
+
+		if (folio_test_highmem(folio) &&
+		    (chunk > (PAGE_SIZE - offset_in_page(offset))))
+			chunk = PAGE_SIZE - offset_in_page(offset);
+		memcpy(to, from, len);
+		kunmap_local(to);
+
+		from += chunk;
+		offset += chunk;
+		len -= chunk;
+	} while (len > 0);
+
+	flush_dcache_folio(folio);
+}
+
 /**
  * memcpy_from_file_folio - Copy some bytes from a file folio.
  * @to: The destination buffer.
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

