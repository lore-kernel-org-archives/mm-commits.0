Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC87C3DA79
	for <mm-commits@archiver.kernel.org>; Thu, 29 Dec 2022 19:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiL2TzG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiL2TzE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2022 14:55:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8C2FADE
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 11:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 692F6618F8
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2022 19:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA874C433F0;
        Thu, 29 Dec 2022 19:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672343702;
        bh=OftlgjmPvDKSiM6PmZa0tRFFxcgnrca6zWvTqdZC2Mo=;
        h=Date:To:From:Subject:From;
        b=LXBGYBNNEPbU2cKDDD28353lcyp7PSc5gPvj4tN+6/OholBomcX2/PkpNNitLL0jm
         mXgID4E33DTbuLIup1gjNhoI+Fen1qgcQopKKTJ8hSKTgtXj5OWVDIPoJ4JU+dfCCa
         JG+ClXEcgvrzkD2ACDRd98Pt2lRDK7Hj9SwhthQg=
Date:   Thu, 29 Dec 2022 11:55:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.com, almaz.alexandrovich@paragon-software.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs3-stop-using-generic_writepages.patch added to mm-unstable branch
Message-Id: <20221229195502.BA874C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs3: stop using generic_writepages
has been added to the -mm mm-unstable branch.  Its filename is
     ntfs3-stop-using-generic_writepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs3-stop-using-generic_writepages.patch

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
Subject: ntfs3: stop using generic_writepages
Date: Thu, 29 Dec 2022 06:10:27 -1000

Open code the resident inode handling in ntfs_writepages by directly using
write_cache_pages to prepare removing the ->writepage handler in ntfs3.

Link: https://lkml.kernel.org/r/20221229161031.391878-3-hch@lst.de
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


--- a/fs/ntfs3/inode.c~ntfs3-stop-using-generic_writepages
+++ a/fs/ntfs3/inode.c
@@ -846,12 +846,29 @@ static int ntfs_writepage(struct page *p
 	return block_write_full_page(page, ntfs_get_block, wbc);
 }
 
+static int ntfs_resident_writepage(struct page *page,
+		struct writeback_control *wbc, void *data)
+{
+	struct address_space *mapping = data;
+	struct ntfs_inode *ni = ntfs_i(mapping->host);
+	int ret;
+
+	ni_lock(ni);
+	ret = attr_data_write_resident(ni, page);
+	ni_unlock(ni);
+
+	if (ret != E_NTFS_NONRESIDENT)
+		unlock_page(page);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
 static int ntfs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
-	/* Redirect call to 'ntfs_writepage' for resident files. */
 	if (is_resident(ntfs_i(mapping->host)))
-		return generic_writepages(mapping, wbc);
+		return write_cache_pages(mapping, wbc, ntfs_resident_writepage,
+					 mapping);
 	return mpage_writepages(mapping, wbc, ntfs_get_block);
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

fs-remove-an-outdated-comment-on-mpage_writepages.patch
ntfs3-stop-using-generic_writepages.patch
ntfs3-remove-writepage.patch
jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2.patch
ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch
mm-remove-generic_writepages.patch

