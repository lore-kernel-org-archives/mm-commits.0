Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7ECECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiILDdz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiILDcR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFA91D0DD
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 281A36116D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC2AC433D7;
        Mon, 12 Sep 2022 03:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953401;
        bh=8Kg1Q904Mrj+5stt12GwUir64CniqGy57Avkyi3leBU=;
        h=Date:To:From:Subject:From;
        b=qRTleh8RGfMpvJXbSuxz27ND4IC52B+iLJ1d5w9z3jBxgRG5j8vWubhV0i5Awq9QN
         /CIbTKscRxT2oMk0nvKkb2Buui79Ds6OdQXGcEBLGs8chB4ldgP11kMI38xNxhDkXT
         YDqgOiKrK1/gtK+X/YIRWj7kVY7fQBB4zVYHaSqA=
Date:   Sun, 11 Sep 2022 20:30:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, konishi.ryusuke@gmail.com,
        josef@toxicpanda.com, dsterb@suse.com, dsterba@suse.com,
        clm@fb.com, vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] btrfs-convert-__process_pages_contig-to-use-filemap_get_folios_contig.patch removed from -mm tree
Message-Id: <20220912033001.7EC2AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: btrfs: convert __process_pages_contig() to use filemap_get_folios_contig()
has been removed from the -mm tree.  Its filename was
     btrfs-convert-__process_pages_contig-to-use-filemap_get_folios_contig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: btrfs: convert __process_pages_contig() to use filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:18 -0700

Convert to use folios throughout.  This is in preparation for the removal
of find_get_pages_contig().  Now also supports large folios.

Since we may receive more than nr_pages pages, nr_pages may underflow. 
Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
with this check instead.

Link: https://lkml.kernel.org/r/20220824004023.77310-3-vishal.moola@gmail.com
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

 fs/btrfs/extent_io.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

--- a/fs/btrfs/extent_io.c~btrfs-convert-__process_pages_contig-to-use-filemap_get_folios_contig
+++ a/fs/btrfs/extent_io.c
@@ -1900,9 +1900,8 @@ static int __process_pages_contig(struct
 	pgoff_t start_index = start >> PAGE_SHIFT;
 	pgoff_t end_index = end >> PAGE_SHIFT;
 	pgoff_t index = start_index;
-	unsigned long nr_pages = end_index - start_index + 1;
 	unsigned long pages_processed = 0;
-	struct page *pages[16];
+	struct folio_batch fbatch;
 	int err = 0;
 	int i;
 
@@ -1911,16 +1910,17 @@ static int __process_pages_contig(struct
 		ASSERT(processed_end && *processed_end == start);
 	}
 
-	if ((page_ops & PAGE_SET_ERROR) && nr_pages > 0)
+	if ((page_ops & PAGE_SET_ERROR) && start_index <= end_index)
 		mapping_set_error(mapping, -EIO);
 
-	while (nr_pages > 0) {
-		int found_pages;
+	folio_batch_init(&fbatch);
+	while (index <= end_index) {
+		int found_folios;
 
-		found_pages = find_get_pages_contig(mapping, index,
-				     min_t(unsigned long,
-				     nr_pages, ARRAY_SIZE(pages)), pages);
-		if (found_pages == 0) {
+		found_folios = filemap_get_folios_contig(mapping, &index,
+				end_index, &fbatch);
+
+		if (found_folios == 0) {
 			/*
 			 * Only if we're going to lock these pages, we can find
 			 * nothing at @index.
@@ -1930,23 +1930,20 @@ static int __process_pages_contig(struct
 			goto out;
 		}
 
-		for (i = 0; i < found_pages; i++) {
+		for (i = 0; i < found_folios; i++) {
 			int process_ret;
-
+			struct folio *folio = fbatch.folios[i];
 			process_ret = process_one_page(fs_info, mapping,
-					pages[i], locked_page, page_ops,
+					&folio->page, locked_page, page_ops,
 					start, end);
 			if (process_ret < 0) {
-				for (; i < found_pages; i++)
-					put_page(pages[i]);
 				err = -EAGAIN;
+				folio_batch_release(&fbatch);
 				goto out;
 			}
-			put_page(pages[i]);
-			pages_processed++;
+			pages_processed += folio_nr_pages(folio);
 		}
-		nr_pages -= found_pages;
-		index += found_pages;
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 out:
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-convert-filemap_range_has_writeback-to-use-folios.patch

