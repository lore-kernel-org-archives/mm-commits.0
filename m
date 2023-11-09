Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD70C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjKIVyv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjKIVyv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:54:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ECD1FE5
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:54:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006A9C433C8;
        Thu,  9 Nov 2023 21:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699566889;
        bh=cohAtUw+S7EP11FrzCkGCWAfi6ZRUDzfRgsd5ESW1yo=;
        h=Date:To:From:Subject:From;
        b=H2p7iR8gfJfhU5U0ZSIwnhZozBtg907Dvd0+Gx9Wy/dLYgZ3gvvhm+9knbaN35xhI
         nx20zje22f6Wx++OmGXPR+FjcFhJksoigoctugYKRdSeqZEtt/xMp+jqod7B4XclQK
         nrWHusaoUIPzHu4uW677HtHjs3h71AHWWtICZjjs=
Date:   Thu, 09 Nov 2023 13:54:48 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu, djwong@kernel.org,
        agruenba@redhat.com, adilger.kernel@dilger.ca, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_fill_tail-and-use-it-in-iomap.patch added to mm-unstable branch
Message-Id: <20231109215449.006A9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add folio_fill_tail() and use it in iomap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_fill_tail-and-use-it-in-iomap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_fill_tail-and-use-it-in-iomap.patch

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
Subject: mm: add folio_fill_tail() and use it in iomap
Date: Tue, 7 Nov 2023 21:26:41 +0000

The iomap code was limited to PAGE_SIZE bytes; generalise it to cover
an arbitrary-sized folio, and move it to be a common helper.

Link: https://lkml.kernel.org/r/20231107212643.3490372-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap/buffered-io.c  |   14 ++------------
 include/linux/highmem.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 12 deletions(-)

--- a/fs/iomap/buffered-io.c~mm-add-folio_fill_tail-and-use-it-in-iomap
+++ a/fs/iomap/buffered-io.c
@@ -305,28 +305,18 @@ static int iomap_read_inline_data(const
 {
 	const struct iomap *iomap = iomap_iter_srcmap(iter);
 	size_t size = i_size_read(iter->inode) - iomap->offset;
-	size_t poff = offset_in_page(iomap->offset);
 	size_t offset = offset_in_folio(folio, iomap->offset);
-	void *addr;
 
 	if (folio_test_uptodate(folio))
 		return 0;
 
-	if (WARN_ON_ONCE(size > PAGE_SIZE - poff))
-		return -EIO;
-	if (WARN_ON_ONCE(size > PAGE_SIZE -
-			 offset_in_page(iomap->inline_data)))
-		return -EIO;
 	if (WARN_ON_ONCE(size > iomap->length))
 		return -EIO;
 	if (offset > 0)
 		ifs_alloc(iter->inode, folio, iter->flags);
 
-	addr = kmap_local_folio(folio, offset);
-	memcpy(addr, iomap->inline_data, size);
-	memset(addr + size, 0, PAGE_SIZE - poff - size);
-	kunmap_local(addr);
-	iomap_set_range_uptodate(folio, offset, PAGE_SIZE - poff);
+	folio_fill_tail(folio, offset, iomap->inline_data, size);
+	iomap_set_range_uptodate(folio, offset, folio_size(folio) - offset);
 	return 0;
 }
 
--- a/include/linux/highmem.h~mm-add-folio_fill_tail-and-use-it-in-iomap
+++ a/include/linux/highmem.h
@@ -522,6 +522,44 @@ static inline __must_check void *folio_z
 }
 
 /**
+ * folio_fill_tail - Copy some data to a folio and pad with zeroes.
+ * @folio: The destination folio.
+ * @offset: The offset into @folio at which to start copying.
+ * @from: The data to copy.
+ * @len: How many bytes of data to copy.
+ *
+ * This function is most useful for filesystems which support inline data.
+ * When they want to copy data from the inode into the page cache, this
+ * function does everything for them.  It supports large folios even on
+ * HIGHMEM configurations.
+ */
+static inline void folio_fill_tail(struct folio *folio, size_t offset,
+		const char *from, size_t len)
+{
+	char *to = kmap_local_folio(folio, offset);
+
+	VM_BUG_ON(offset + len > folio_size(folio));
+
+	if (folio_test_highmem(folio)) {
+		size_t max = PAGE_SIZE - offset_in_page(offset);
+
+		while (len > max) {
+			memcpy(to, from, max);
+			kunmap_local(to);
+			len -= max;
+			from += max;
+			offset += max;
+			max = PAGE_SIZE;
+			to = kmap_local_folio(folio, offset);
+		}
+	}
+
+	memcpy(to, from, len);
+	to = folio_zero_tail(folio, offset, to);
+	kunmap_local(to);
+}
+
+/**
  * memcpy_from_file_folio - Copy some bytes from a file folio.
  * @to: The destination buffer.
  * @folio: The folio to copy from.
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch
mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch

