Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A1CECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239366AbiH0D24 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiH0D2s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:28:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C880BA74EE
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 518A161DF6
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7566C433D7;
        Sat, 27 Aug 2022 03:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661570925;
        bh=/hUUFpg2Ig+yd06DXL0XPYRWAzQBzntTEIo+Fh79f80=;
        h=Date:To:From:Subject:From;
        b=oF5sxaLIUTX2roc2WDF9DZ8R6iOCvt/EMu1QyKiadcGhZiD/DtUWLVltCJStr5vW6
         OxkaXRLOq1ZLJezNamL2w1r+aNFKaKqXW8jzeGi7V3TS/gmvw6XHGueOACu/VoAhIH
         Iw75A6NTf1E52Up5UsFlmNnhdRQ27Loy640OINoM=
Date:   Fri, 26 Aug 2022 20:28:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, konishi.ryusuke@gmail.com,
        josef@toxicpanda.com, dsterb@suse.com, dsterba@suse.com,
        clm@fb.com, vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + btrfs-convert-process_page_range-to-use-filemap_get_folios_contig.patch added to mm-unstable branch
Message-Id: <20220827032845.A7566C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: convert process_page_range() to use filemap_get_folios_contig()
has been added to the -mm mm-unstable branch.  Its filename is
     btrfs-convert-process_page_range-to-use-filemap_get_folios_contig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/btrfs-convert-process_page_range-to-use-filemap_get_folios_contig.patch

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
Subject: btrfs: convert process_page_range() to use filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:20 -0700

Converted function to use folios throughout.  This is in preparation for
the removal of find_get_pages_contig().  Now also supports large folios.

Since we may receive more than nr_pages pages, nr_pages may underflow. 
Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
with this check instead.

Also minor comment renaming for consistency in subpage.

Link: https://lkml.kernel.org/r/20220824004023.77310-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Sterba <dsterb@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/subpage.c               |    2 -
 fs/btrfs/tests/extent-io-tests.c |   32 +++++++++++++++--------------
 2 files changed, 18 insertions(+), 16 deletions(-)

--- a/fs/btrfs/subpage.c~btrfs-convert-process_page_range-to-use-filemap_get_folios_contig
+++ a/fs/btrfs/subpage.c
@@ -337,7 +337,7 @@ bool btrfs_subpage_end_and_test_writer(c
  *
  * Even with 0 returned, the page still need extra check to make sure
  * it's really the correct page, as the caller is using
- * find_get_pages_contig(), which can race with page invalidating.
+ * filemap_get_folios_contig(), which can race with page invalidating.
  */
 int btrfs_page_start_writer_lock(const struct btrfs_fs_info *fs_info,
 		struct page *page, u64 start, u32 len)
--- a/fs/btrfs/tests/extent-io-tests.c~btrfs-convert-process_page_range-to-use-filemap_get_folios_contig
+++ a/fs/btrfs/tests/extent-io-tests.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sizes.h>
@@ -20,39 +21,40 @@ static noinline int process_page_range(s
 				       unsigned long flags)
 {
 	int ret;
-	struct page *pages[16];
+	struct folio_batch fbatch;
 	unsigned long index = start >> PAGE_SHIFT;
 	unsigned long end_index = end >> PAGE_SHIFT;
-	unsigned long nr_pages = end_index - index + 1;
 	int i;
 	int count = 0;
 	int loops = 0;
 
-	while (nr_pages > 0) {
-		ret = find_get_pages_contig(inode->i_mapping, index,
-				     min_t(unsigned long, nr_pages,
-				     ARRAY_SIZE(pages)), pages);
+	folio_batch_init(&fbatch);
+
+	while (index <= end_index) {
+		ret = filemap_get_folios_contig(inode->i_mapping, &index,
+				end_index, &fbatch);
 		for (i = 0; i < ret; i++) {
+			struct folio *folio = fbatch.folios[i];
+
 			if (flags & PROCESS_TEST_LOCKED &&
-			    !PageLocked(pages[i]))
+			    !folio_test_locked(folio))
 				count++;
-			if (flags & PROCESS_UNLOCK && PageLocked(pages[i]))
-				unlock_page(pages[i]);
-			put_page(pages[i]);
+			if (flags & PROCESS_UNLOCK && folio_test_locked(folio))
+				folio_unlock(folio);
 			if (flags & PROCESS_RELEASE)
-				put_page(pages[i]);
+				folio_put(folio);
 		}
-		nr_pages -= ret;
-		index += ret;
+		folio_batch_release(&fbatch);
 		cond_resched();
 		loops++;
 		if (loops > 100000) {
 			printk(KERN_ERR
-		"stuck in a loop, start %llu, end %llu, nr_pages %lu, ret %d\n",
-				start, end, nr_pages, ret);
+		"stuck in a loop, start %llu, end %llu, ret %d\n",
+				start, end, ret);
 			break;
 		}
 	}
+
 	return count;
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

