Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A4EECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345149AbiH0D2y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239366AbiH0D2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:28:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E19A721E
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE1E8B83388
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD92C433D6;
        Sat, 27 Aug 2022 03:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661570923;
        bh=TkW2EuXK51tLYsy2hXY0SnGXa7kDFkzjc9Uxhf5k48E=;
        h=Date:To:From:Subject:From;
        b=FSk8AxEWUW0Nwy6a2jsssvUUrukKDgYwMo1fGSpLzosOoqSOvh9eqZAKX2H96BjoR
         bBD03NhAfk4S7Tz+4bsW6+i4h4RhHOW/WdJc8JXqCNEbHoNraZSAb3nFcsTcFS7Sfx
         W6VGM1dEfJR10IWnDZsithRXdki2BUuaH5/z60gA=
Date:   Fri, 26 Aug 2022 20:28:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, konishi.ryusuke@gmail.com,
        josef@toxicpanda.com, dsterb@suse.com, dsterba@suse.com,
        clm@fb.com, vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + btrfs-convert-end_compressed_writeback-to-use-filemap_get_folios.patch added to mm-unstable branch
Message-Id: <20220827032843.9DD92C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: convert end_compressed_writeback() to use filemap_get_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     btrfs-convert-end_compressed_writeback-to-use-filemap_get_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/btrfs-convert-end_compressed_writeback-to-use-filemap_get_folios.patch

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
Subject: btrfs: convert end_compressed_writeback() to use filemap_get_folios()
Date: Tue, 23 Aug 2022 17:40:19 -0700

Converted function to use folios throughout.  This is in preparation for
the removal of find_get_pages_contig().  Now also supports large folios.

Since we may receive more than nr_pages pages, nr_pages may underflow. 
Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
with this check instead.

Also this function does not care about the pages being contiguous so we
can just use filemap_get_folios() to be more efficient.

Link: https://lkml.kernel.org/r/20220824004023.77310-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Sterba <dsterba@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterb@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/compression.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/fs/btrfs/compression.c~btrfs-convert-end_compressed_writeback-to-use-filemap_get_folios
+++ a/fs/btrfs/compression.c
@@ -8,6 +8,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
 #include <linux/time.h>
@@ -222,8 +223,7 @@ static noinline void end_compressed_writ
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	unsigned long index = cb->start >> PAGE_SHIFT;
 	unsigned long end_index = (cb->start + cb->len - 1) >> PAGE_SHIFT;
-	struct page *pages[16];
-	unsigned long nr_pages = end_index - index + 1;
+	struct folio_batch fbatch;
 	const int errno = blk_status_to_errno(cb->status);
 	int i;
 	int ret;
@@ -231,24 +231,23 @@ static noinline void end_compressed_writ
 	if (errno)
 		mapping_set_error(inode->i_mapping, errno);
 
-	while (nr_pages > 0) {
-		ret = find_get_pages_contig(inode->i_mapping, index,
-				     min_t(unsigned long,
-				     nr_pages, ARRAY_SIZE(pages)), pages);
-		if (ret == 0) {
-			nr_pages -= 1;
-			index += 1;
-			continue;
-		}
+	folio_batch_init(&fbatch);
+	while (index <= end_index) {
+		ret = filemap_get_folios(inode->i_mapping, &index, end_index,
+				&fbatch);
+
+		if (ret == 0)
+			return;
+
 		for (i = 0; i < ret; i++) {
+			struct folio *folio = fbatch.folios[i];
+
 			if (errno)
-				SetPageError(pages[i]);
-			btrfs_page_clamp_clear_writeback(fs_info, pages[i],
+				folio_set_error(folio);
+			btrfs_page_clamp_clear_writeback(fs_info, &folio->page,
 							 cb->start, cb->len);
-			put_page(pages[i]);
 		}
-		nr_pages -= ret;
-		index += ret;
+		folio_batch_release(&fbatch);
 	}
 	/* the inode may be gone now */
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-add-filemap_get_folios_contig.patch
btrfs-convert-__process_pages_contig-to-use-filemap_get_folios_contig.patch
btrfs-convert-end_compressed_writeback-to-use-filemap_get_folios.patch
btrfs-convert-process_page_range-to-use-filemap_get_folios_contig.patch
nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch
ramfs-convert-ramfs_nommu_get_unmapped_area-to-use-filemap_get_folios_contig.patch
filemap-remove-find_get_pages_contig.patch

