Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCA2C38147
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjARVKm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjARVKD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:10:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798856308E
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:09:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16A7661A34
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E992C433EF;
        Wed, 18 Jan 2023 21:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674076160;
        bh=+sRyJqclVnnSJ6SCBrXuI8gDZ/qV3j2qN+fEJk7UfJE=;
        h=Date:To:From:Subject:From;
        b=bos1GxWXkZRNsSfD7xhyRSpGolrKhbZNFK0udshV3qECxBuviL1+52/aXASIgGrE+
         4XuQ3bNAck5ocugZ8YxGnlQSvY8Ue2hsNsvKRdPyiknSTAlMFS+GatPjPPi8zwxYWD
         b957O1jH9g0cjl9aFbybmzYr8xL1pcXSIaoBZ3+4=
Date:   Wed, 18 Jan 2023 13:09:19 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mark@fasheh.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jack@suse.cz,
        dushistov@mail.ru, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch added to mm-nonmm-unstable branch
Message-Id: <20230118210920.6E992C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
Date: Wed, 18 Jan 2023 18:30:27 +0100

Use filemap_write_and_wait_range to write back the range of the dirty page
instead of write_one_page in preparation of removing write_one_page and
eventually ->writepage.

Link: https://lkml.kernel.org/r/20230118173027.294869-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/refcounttree.c
@@ -2952,10 +2952,11 @@ retry:
 		 */
 		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
 			if (PageDirty(page)) {
-				/*
-				 * write_on_page will unlock the page on return
-				 */
-				ret = write_one_page(page);
+				unlock_page(page);
+				put_page(page);
+
+				ret = filemap_write_and_wait_range(mapping,
+						offset, map_end - 1);
 				goto retry;
 			}
 		}
_

Patches currently in -mm which might be from hch@lst.de are

fs-remove-an-outdated-comment-on-mpage_writepages.patch
ntfs3-stop-using-generic_writepages.patch
ntfs3-remove-writepage.patch
jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2.patch
ocfs2-use-filemap_fdatawrite_wbc-instead-of-generic_writepages.patch
mm-remove-generic_writepages.patch
minix-move-releasing-pages-into-unlink-and-rename.patch
minix-fix-error-handling-in-minix_delete_entry.patch
minix-fix-error-handling-in-minix_set_link.patch
minix-dont-flush-page-immediately-for-dirsync-directories.patch
sysv-dont-flush-page-immediately-for-dirsync-directories.patch
ufs-dont-flush-page-immediately-for-dirsync-directories.patch
ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

