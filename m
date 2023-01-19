Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4A8C678D6
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjASBUJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjASBSK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1FB69B09
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23B5A61B20
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB0CC433D2;
        Thu, 19 Jan 2023 01:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090946;
        bh=OEFxkjJd5F2jnUHqadEByIbPputczLPkVFOPijmAnaw=;
        h=Date:To:From:Subject:From;
        b=VpVv9sWe4hF8Tc1hB7Zc+gkO1li8N5crc2qPFU6vdY7kpir6Q1NTV1AiH1Hq4pyOW
         5SxEpnct4cFFYRB0IBujwmvpiD/gNGrD0iq7OQ/TngTiXpWSboKjPbwXOkYx6Fg4Du
         RtdLa914Stj0NHJdMKyjKvZu/BuqR9hCEnJIVLrw=
Date:   Wed, 18 Jan 2023 17:15:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.cz, almaz.alexandrovich@paragon-software.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-generic_writepages.patch removed from -mm tree
Message-Id: <20230119011546.7BB0CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove generic_writepages
has been removed from the -mm tree.  Its filename was
     mm-remove-generic_writepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove generic_writepages
Date: Thu, 29 Dec 2022 06:10:31 -1000

Now that all external callers are gone, just fold it into do_writepages.

Link: https://lkml.kernel.org/r/20221229161031.391878-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    2 -
 mm/page-writeback.c       |   53 ++++++++++--------------------------
 2 files changed, 15 insertions(+), 40 deletions(-)

--- a/include/linux/writeback.h~mm-remove-generic_writepages
+++ a/include/linux/writeback.h
@@ -369,8 +369,6 @@ bool wb_over_bg_thresh(struct bdi_writeb
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 				void *data);
 
-int generic_writepages(struct address_space *mapping,
-		       struct writeback_control *wbc);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 int write_cache_pages(struct address_space *mapping,
--- a/mm/page-writeback.c~mm-remove-generic_writepages
+++ a/mm/page-writeback.c
@@ -2526,12 +2526,8 @@ continue_unlock:
 }
 EXPORT_SYMBOL(write_cache_pages);
 
-/*
- * Function used by generic_writepages to call the real writepage
- * function and set the mapping flags on error
- */
-static int __writepage(struct page *page, struct writeback_control *wbc,
-		       void *data)
+static int writepage_cb(struct page *page, struct writeback_control *wbc,
+		void *data)
 {
 	struct address_space *mapping = data;
 	int ret = mapping->a_ops->writepage(page, wbc);
@@ -2539,34 +2535,6 @@ static int __writepage(struct page *page
 	return ret;
 }
 
-/**
- * generic_writepages - walk the list of dirty pages of the given address space and writepage() all of them.
- * @mapping: address space structure to write
- * @wbc: subtract the number of written pages from *@wbc->nr_to_write
- *
- * This is a library function, which implements the writepages()
- * address_space_operation.
- *
- * Return: %0 on success, negative error code otherwise
- */
-int generic_writepages(struct address_space *mapping,
-		       struct writeback_control *wbc)
-{
-	struct blk_plug plug;
-	int ret;
-
-	/* deal with chardevs and other special file */
-	if (!mapping->a_ops->writepage)
-		return 0;
-
-	blk_start_plug(&plug);
-	ret = write_cache_pages(mapping, wbc, __writepage, mapping);
-	blk_finish_plug(&plug);
-	return ret;
-}
-
-EXPORT_SYMBOL(generic_writepages);
-
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
@@ -2577,11 +2545,20 @@ int do_writepages(struct address_space *
 	wb = inode_to_wb_wbc(mapping->host, wbc);
 	wb_bandwidth_estimate_start(wb);
 	while (1) {
-		if (mapping->a_ops->writepages)
+		if (mapping->a_ops->writepages) {
 			ret = mapping->a_ops->writepages(mapping, wbc);
-		else
-			ret = generic_writepages(mapping, wbc);
-		if ((ret != -ENOMEM) || (wbc->sync_mode != WB_SYNC_ALL))
+		} else if (mapping->a_ops->writepage) {
+			struct blk_plug plug;
+
+			blk_start_plug(&plug);
+			ret = write_cache_pages(mapping, wbc, writepage_cb,
+						mapping);
+			blk_finish_plug(&plug);
+		} else {
+			/* deal with chardevs and other special files */
+			ret = 0;
+		}
+		if (ret != -ENOMEM || wbc->sync_mode != WB_SYNC_ALL)
 			break;
 
 		/*
_

Patches currently in -mm which might be from hch@lst.de are


