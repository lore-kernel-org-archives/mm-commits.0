Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD53C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjKIVyu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjKIVyu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:54:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9A43C3C
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:54:48 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B830C433C8;
        Thu,  9 Nov 2023 21:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699566887;
        bh=26r7+0AXct9vHs9plJh9D6lHe+7FADc/Qorj4cDbGWM=;
        h=Date:To:From:Subject:From;
        b=UUZgtKKN2eHUW9cTuWGQeThnwmTHOWg1N83C2opGDH9f/e+1aEYaUyDDeUExNynRf
         RK/N+6yQl/TZ8fIPgmT5gs163LQIWSRk79bz6KErJZO4ogBF4DYkicxGwi3w5V3dqK
         JtBXcc5V9ZfYbCSSqGzgXiwZWObjILA9xrm4wiWY=
Date:   Thu, 09 Nov 2023 13:54:46 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu, djwong@kernel.org,
        agruenba@redhat.com, adilger.kernel@dilger.ca, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_zero_tail-and-use-it-in-ext4.patch added to mm-unstable branch
Message-Id: <20231109215447.9B830C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add folio_zero_tail() and use it in ext4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_zero_tail-and-use-it-in-ext4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_zero_tail-and-use-it-in-ext4.patch

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
Subject: mm: add folio_zero_tail() and use it in ext4
Date: Tue, 7 Nov 2023 21:26:40 +0000

Patch series "Add folio_zero_tail() and folio_fill_tail()".

I'm trying to make it easier for filesystems with tailpacking / stuffing /
inline data to use folios.  The primary function here is
folio_fill_tail().  You give it a pointer to memory where the data
currently is, and it takes care of copying it into the folio at that
offset.  That works for gfs2 & iomap.  Then There's Ext4.  Rather than gin
up some kind of specialist "Here's a two pointers to two blocks of memory"
routine, just let it do its current thing, and let it call
folio_zero_tail(), which is also called by folio_fill_tail().

Other filesystems can be converted later; these ones seemed like good
examples as they're already partly or completely converted to folios.


This patch (of 3):

Instead of unmapping the folio after copying the data to it, then mapping
it again to zero the tail, provide folio_zero_tail() to zero the tail of
an already-mapped folio.

Link: https://lkml.kernel.org/r/20231107212643.3490372-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231107212643.3490372-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inline.c        |    3 +--
 include/linux/highmem.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

--- a/fs/ext4/inline.c~mm-add-folio_zero_tail-and-use-it-in-ext4
+++ a/fs/ext4/inline.c
@@ -502,9 +502,8 @@ static int ext4_read_inline_folio(struct
 	BUG_ON(len > PAGE_SIZE);
 	kaddr = kmap_local_folio(folio, 0);
 	ret = ext4_read_inline_data(inode, kaddr, len, &iloc);
-	flush_dcache_folio(folio);
+	kaddr = folio_zero_tail(folio, len, kaddr + len);
 	kunmap_local(kaddr);
-	folio_zero_segment(folio, len, folio_size(folio));
 	folio_mark_uptodate(folio);
 	brelse(iloc.bh);
 
--- a/include/linux/highmem.h~mm-add-folio_zero_tail-and-use-it-in-ext4
+++ a/include/linux/highmem.h
@@ -484,6 +484,44 @@ static inline void memcpy_to_folio(struc
 }
 
 /**
+ * folio_zero_tail - Zero the tail of a folio.
+ * @folio: The folio to zero.
+ * @kaddr: The address the folio is currently mapped to.
+ * @offset: The byte offset in the folio to start zeroing at.
+ *
+ * If you have already used kmap_local_folio() to map a folio, written
+ * some data to it and now need to zero the end of the folio (and flush
+ * the dcache), you can use this function.  If you do not have the
+ * folio kmapped (eg the folio has been partially populated by DMA),
+ * use folio_zero_range() or folio_zero_segment() instead.
+ *
+ * Return: An address which can be passed to kunmap_local().
+ */
+static inline __must_check void *folio_zero_tail(struct folio *folio,
+		size_t offset, void *kaddr)
+{
+	size_t len = folio_size(folio) - offset;
+
+	if (folio_test_highmem(folio)) {
+		size_t max = PAGE_SIZE - offset_in_page(offset);
+
+		while (len > max) {
+			memset(kaddr, 0, max);
+			kunmap_local(kaddr);
+			len -= max;
+			offset += max;
+			max = PAGE_SIZE;
+			kaddr = kmap_local_folio(folio, offset);
+		}
+	}
+
+	memset(kaddr, 0, len);
+	flush_dcache_folio(folio);
+
+	return kaddr;
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

