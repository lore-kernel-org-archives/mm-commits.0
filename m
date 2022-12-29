Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2AFC3DA7A
	for <mm-commits@archiver.kernel.org>; Thu, 29 Dec 2022 19:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiL2TzQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiL2TzL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2022 14:55:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25163165B2
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 11:55:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2755618FF
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 19:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C58C433EF;
        Thu, 29 Dec 2022 19:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672343709;
        bh=/KlmVSaLXqIy+8QGzBlnwbx14+uBNm2FQHKEM+rRrq8=;
        h=Date:To:From:Subject:From;
        b=MZpYnz+sinEa0l23r7X2cbA+l62RhLE0QcdByVcr7/vkgyQL2geDQDj4gGF9JMpan
         p8u8YaWOxLDSs5/UFQu7lxTyUnzTYjua7nQWq4g+vbvLDQlKbheHPLIt+qY6iBu7F5
         Xag2W4E3fP1SH1MGcjkqKHzowrJyFmelNTRNxFu4=
Date:   Thu, 29 Dec 2022 11:55:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.com, almaz.alexandrovich@paragon-software.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-generic_writepages.patch added to mm-unstable branch
Message-Id: <20221229195509.02C58C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove generic_writepages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-generic_writepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-generic_writepages.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove generic_writepages
Date: Thu, 29 Dec 2022 06:10:31 -1000

Now that all external callers are gone, just fold it into do_writepages.

Link: https://lkml.kernel.org/r/20221229161031.391878-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

fs-remove-an-outdated-comment-on-mpage_writepages.patch
ntfs3-stop-using-generic_writepages.patch
ntfs3-remove-writepage.patch
jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2.patch
ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch
mm-remove-generic_writepages.patch

